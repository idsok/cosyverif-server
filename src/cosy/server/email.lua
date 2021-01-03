local waiting_email_key = "//email/waiting"
local sent_email_key    = "//email/sent/"

local function server ()
  local _             = require "cosy.util.string"
  local Configuration = require "cosy.server.configuration"
  local socket        = require "socket"
  local smtp          = require "socket.smtp"
  local ssl           = require "ssl"
  local redis         = require "redis"
  local json          = require "cjson"
  local logger        = Configuration.logger

  local client
  do
    local host      = Configuration.redis.host
    local port      = Configuration.redis.port
    local database  = Configuration.redis.database
    client = redis.connect (host, port)
    client:select (database)
  end

  -- http://lua-users.org/wiki/StringRecipes
  local email_pattern = "<[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?>"

  local tls_alias = {
    ["TLS v1.2"] = "tlsv1_2",
    ["TLS v1.1"] = "tlsv1_1",
    ["TLS v1.0"] = "tlsv1",
    ["SSL v3"  ] = "sslv3",
    ["SSL v2"  ] = "sslv23",
  }
    -- http://stackoverflow.com/questions/11070623/lua-send-mail-with-gmail-account
  local Tcp = {}
  
  local function forward__index (self, key)
    local result = getmetatable (self) [key]
    if result then
      assert (type (result) == "function")
      return result
    end
    result = self.socket [key]
    if result then
      assert (type (result) == "function")
      return function (s, ...)
        return result (s.socket, ...)
      end
    end
  end
  
  function Tcp.PLAINTEXT ()
    return function ()
      local result = socket.tcp ()
      result:settimeout (1)
      return result
    end
  end

  local TLS_mt = {}
  TLS_mt.__index = forward__index
  function TLS_mt:connect (host, port)
    self.socket = socket.tcp ()
    self.socket:settimeout (1)
    if not self.socket:connect (host, port) then
      return false
    end
    self.socket = ssl.wrap (self.socket, {
      mode     = "client",
      protocol = tls_alias [self.protocol],
    })
    return self.socket:dohandshake()
  end
  function Tcp.TLS (protocol)
    return function ()
      return setmetatable ({
        socket   = socket.tcp (),
        protocol = protocol,
      }, TLS_mt)
    end
  end

  local STARTTLS_mt = {}
  STARTTLS_mt.__index = forward__index
  function STARTTLS_mt:connect (host, port)
    self.socket = socket.tcp ()
    self.socket:settimeout (1)
    if not self.socket:connect (host, port) then
      return false
    end
    self.socket:receive "*l"
    self.socket:send ("EHLO " .. Configuration.server.root .. "\r\n")
    repeat
      local line = self.socket:receive "*l"
    until line == nil
    self.socket:send "STARTTLS\r\n"
    self.socket:receive "*l"
    self.socket = ssl.wrap (self.socket, {
      mode     = "client",
      protocol = tls_alias [self.protocol],
    })
    local result = self.socket:dohandshake()
    self.socket:send ("EHLO " .. Configuration.server.root .. "\r\n")
    return result
  end
  function Tcp.STARTTLS (protocol)
    return function ()
      return setmetatable ({
        socket   = socket.tcp (),
        protocol = protocol,
      }, STARTTLS_mt)
    end
  end

  local function discover ()
    local domain   = Configuration.server.root
    local host     = Configuration.smtp.host
    local username = Configuration.smtp.username
    local password = Configuration.smtp.password
    local ports    = { Configuration.smtp.port }
    if #ports == 0 then
      ports = { 25, 587, 465 }
    end
    for _, method in ipairs {
      "STARTTLS",
      "TLS",
      "PLAINTEXT",
    } do
      local protocols = (method == "PLAIN") and { "nothing" } or {
        "TLS v1.2",
        "TLS v1.1",
        "TLS v1.0",
        "SSL v3",
        "SSL v2",
      }
      for _, protocol in ipairs (protocols) do
        for _, port in ipairs (ports) do
          logger:debug ("Discovering SMTP on ${host}:${port} using ${method} (encrypted with ${protocol})" % {
            host     = host,
            port     = port,
            method   = method,
            protocol = protocol,
          })
          local ok, s = pcall (smtp.open, host, port, Tcp [method] (protocol))
          if ok then
            local ok = pcall (s.auth, s, username, password, s:greet (domain))
            if ok then
              Configuration.smtp.port     = port
              Configuration.smtp.method   = method
              Configuration.smtp.protocol = protocol
              return true
            else
              s:close ()
            end
          end
        end
      end
    end
  end
  if not discover () then
    logger:warn ("No SMTP server discovered, sending of emails will not work.")
    return
  end
  logger:info ("SMTP on ${host}:${port} uses ${method} (encrypted with ${protocol})." % {
    host     = Configuration.smtp.host,
    port     = Configuration.smtp.port,
    method   = Configuration.smtp.method,
    protocol = Configuration.smtp.protocol,
  })

  local function extract (source, t)
    if source == nil then
      source = {}
    elseif type (source) == "string" then
      source = { source }
    end
    for _, s in ipairs (source) do
      t [#t + 1] = s:match (email_pattern)
    end
  end

  local function send (message)
    local from       = {}
    local recipients = {}
    extract (message.from, from)
    extract (message.to  , recipients)
    extract (message.cc  , recipients)
    extract (message.bcc , recipients)
    return smtp.send {
      from     = from [1],
      rcpt     = recipients,
      source   = smtp.message {
        headers = {
          from    = message.from,
          to      = message.to,
          cc      = message.cc,
          subject = message.subject,
        },
        body = message.body
      },
      user     = Configuration.smtp.username,
      password = Configuration.smtp.password,
      server   = Configuration.smtp.host,
      port     = Configuration.smtp.port,
      create   = Tcp [Configuration.smtp.method] (Configuration.smtp.protocol),
    }
  end
  
  while true do
    local text = client:brpop (waiting_email_key, 0)
    local key  = sent_email_key .. text [2]
    if text and not client:exists (key) then
      client:set    (key, "true")
      client:expire (key, 5)
      local message = json.decode (text [2])
      local ok, err = send (message)
      if not ok then
        logger:warn ("A failure occured when sending an email: " .. err)
      end
    end
  end

end

local Email = {}

do
  local Configuration = require "cosy.server.configuration"
  local lanes         = require "lanes"
  local json          = require "cjson"
  local logger        = Configuration.logger

  function Email.send (context, message)
    local redis   = context.redis
    local encoded = json.encode (message)
    redis:lpush (waiting_email_key, encoded)
  end

  lanes.configure ()
  lanes.gen ("*", function ()
    local ok, err = pcall (server)
    if not ok then
      logger:warn (err)
    end
  end) ()
end

return Email