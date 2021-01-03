local Configuration = require "cosy.server.configuration"
local Status        = require "cosy.server.status"
local url   = require "socket.url"
local mime  = require "mime"
local lfs   = require "lfs"

local base64 = {}
base64.encode = mime.b64
base64.decode = mime.unb64

local Http = {}

local logger = Configuration.logger
do
  -- Load all HTTP header classes:
  local Header  = require "cosy.server.http.header"
  local headers = {}
  for path in package.path:gmatch "([^;]+)" do
    if path:sub (-5) == "?.lua" then
      path = path:sub (1, #path - 5) .. "cosy/server/http/"
      if lfs.attributes (path, "mode") == "directory" then
        for file in lfs.dir (path) do
          if lfs.attributes (path .. file, "mode") == "file"
          and file:sub (1,1) ~= "." then
            local name   = file:gsub (".lua", "")
            local header = require ("cosy.server.http." .. name)
            if header ~= Header then
              headers [header] = true
            end
          end
        end
      end
    end
  end
  -- Sort HTTP headers:
  local sorted = {}
  for header in pairs (headers) do
    sorted [#sorted + 1] = header
  end
  Header.sort (sorted)
  Http.headers = sorted
  for _, h in ipairs (sorted) do
    logger:debug ("Loaded header: " .. tostring (h))
  end
end

Http.name = "Http"

function Http.request (context)
  local skt        = context.skt
  local firstline  = skt:receive "*l"
  if firstline == nil then
    context.continue = false
    return
  end
  -- Extract method:
  local method, query, protocol = firstline:match "^(%a+)%s+(%S+)%s+(%S+)"
  if not method or not query or not protocol then
    error (Status.Bad_Request{})
  end
  local request     = context.request
  local response    = context.response
  request.protocol  = protocol
  request.method    = method:upper ()
  request.query     = query
  local parsed      = url.parse (query)
  request.resource  = url.parse_path (parsed.path)
  response.protocol = protocol
  -- Extract headers:
  local headers     = request.headers
  while true do
    local line = skt:receive "*l"
    if line == "" then
      break
    end
    local name, value = line:match "([^:]+):%s*(.*)"
    name  = name:to_identifier ()
    value = value:trim ()
    headers [name] = value
  end
  -- Extract parameters:
  local parameters = request.parameters
  local params     = parsed.query or ""
  for p in params:gmatch "([^;&]+)" do
    local k, v = p:match "([^=]+)=(.*)"
    k = url.unescape (k):gsub ("+", " ")
    v = url.unescape (v):gsub ("+", " ")
    parameters [k] = v
  end
  -- Parse headers:
  for _, h in ipairs (Http.headers) do
    if headers [h.as_identifier] then
      h.request (h, context)
    end
  end
  -- Set default headers:
  for _, h in ipairs (Http.headers) do
    if not headers [h.as_identifier] then
      h.request_default (context)
    end
  end
  -- Handle headers:
  for _, h in ipairs (Http.headers) do
    local value = headers [h.as_identifier] 
    if value then
      h.on_request (value, context)
    end
  end
end

function Http.response (context)
  local skt       = context.skt
  local response  = context.response
  local headers   = response.headers
  local body      = response.body
  assert (response.status)
  if not response.body and response.status.reason then
    response.body = response.status.reason
  end
  -- Set default headers:
  for _, h in ipairs (Http.headers) do
    if not headers [h.as_identifier] then
      h.response_default (context)
    end
  end
  -- Handle headers:
  for _, h in ipairs (Http.headers) do
    local value = headers [h.as_identifier] 
    if value then
      h.on_response (value, context)
    end
  end
  -- Prety-print headers:
  for _, h in ipairs (Http.headers) do
    if headers [h.as_identifier] then
      h.response (h, context)
    end
  end
  -- Send response:
  local to_send   = {}
  to_send [1] = "${protocol} ${code} ${message}" % {
    protocol = response.protocol,
    code     = response.status.code,
    message  = response.status.message,
  }
  for _, h in ipairs (Http.headers) do
    local value = headers [h.as_identifier]
    if value then
      to_send [#to_send + 1] = "${name}: ${value}" % {
        name  = h.as_http,
        value = value,
      }
    end
  end
  to_send [#to_send + 1] = ""
  if body == nil then
    skt:send (table.concat (to_send, "\r\n"))
  elseif type (body) == "string" then
    to_send [#to_send + 1] = body
    skt:send (table.concat (to_send, "\r\n"))
  end
end

function Http.error (context, err)
  if type (err) == "table" then
    context.response.status = err
    context.response.body   = err.reason
    Http.response (context)
  else
    context.continue        = false
    context.response.status = Status.Internal_Server_Error {}
    context.response.body   = err
    context.response.headers.connection = { close = true }
    Http.response (context)
  end
end

return Http
