local configuration = require "cosy.server.configuration"
local socket        = require "socket"
--local iconv         = require "iconv"
--local utf8          = require "utf8"
--local ssl           = require "ssl"

local logger    = configuration.logger
local scheduler = configuration.scheduler
local host      = configuration.server.host
local port      = configuration.server.port
local retries   = configuration.server.retries_on_conflict

local Http           = require "cosy.server.http"
local Redis          = require "cosy.server.redis"
local Authentication = require "cosy.server.authentication"
local Resource       = require "cosy.server.resource"
local Status         = require "cosy.server.status"
local Email          = require "cosy.server.email"

local Context = {}

function Context.new (context)
  if context then
    assert (getmetatable (context) == Context)
    return setmetatable ({
      _parent = context,
    }, Context)
  else
    return setmetatable ({
      skt      = nil,
      continue = true,
      request  = {
        protocol   = nil,
        method     = nil,
        resource   = nil,
        headers    = {},
        parameters = {},
        body       = nil,
      },
      response = {
        protocol = nil,
        status   = nil,
        message  = nil,
        reason   = nil,
        headers  = {},
        body     = nil,
      },
      onion = {
        Http,
        Authentication,
      },
    }, Context)
  end
end

function Context:__index (k)
  local parent = rawget (self, "_parent")
  if parent then
    return parent [k]
  else
    return nil
  end
end

function Context:__newindex (k, v)
  local parent = rawget (self, "_parent")
  if parent and parent [k] then
    parent [k] = v
  else
    rawset (self, k, v)
  end
end

local function answer (context)
  local request  = context.request
  local response = context.response
  local redis    = context.redis
  local r        = Resource.root (context)
  for _, k in ipairs (request.resource) do
    r = r / k
    if not Resource.exists (r) then
      error (Status.Not_Found {})
    end
  end
  local method = r [request.method]
  if not method then
    error (Status.Method_Not_Allowed {})
  end
  local ok
  for _ = 1, retries do
    redis:unwatch ()
    ok, response.status = pcall (method, r, context)
    if ok and not response.status then
      response.status = Status.OK
    end
    if response.status ~= Status.Conflict then
      return
    end
  end  
end

local function handler (skt)
  local base_context = Context.new ()
  base_context.skt   = skt
  while base_context.continue do
    local context = Context.new (base_context)
    Redis.acquire (context)
    local onion   = context.onion
    local ok, err
    local function perform (i)
      local o = onion [i]
      ok, err = pcall (function ()
        if i > #onion then
          answer (context)
        else
          o.request (context)
          perform (i+1)
          o.response (context)
        end
      end)
      if not ok then
        if type (err) == "string" then
          context.error = err
          Email.send (context, {
            from = "Admin of ${root} <${email}>" % {
              root  = configuration.server.root,
              email = configuration.server.admin,
            },
            to   = "Admin of ${root} <${email}>" % {
              root  = configuration.server.root,
              email = configuration.server.admin,
            },
            subject = "[CosyVerif] 500 -- Internal Server Error",
            body = err,
          })
          err = Status.Internal_Server_Error {}
        end
        if o then
          o.error (context, err)
        else
          error (err)
        end
      end
    end
    ok, err = pcall (perform, 1)
    if not ok then
      context.error = err
      Email.send (context, {
        from = "Cosy <test.cosyverif@gmail.com>",
        to   = "Cosy <test.cosyverif@gmail.com>",
        subject = "[CosyVerif] 500 -- Internal Server Error",
        body = err,
      })
      logger:warn ("Error:", err)
      break
    end
    Redis.release (context)
  end
end

logger:info ("Awaiting connexions on ${host}:${port}..." % {
  host = host,
  port = port,
})

scheduler:addserver (socket.bind (host, port), handler)
scheduler:loop ()
