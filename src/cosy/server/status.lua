local Status = {}

Status [100] = "Continue"
Status [101] = "Switching Protocols"
Status [102] = "Processing"
Status [118] = "Connection timed out"
Status [200] = "OK"
Status [201] = "Created"
Status [202] = "Accepted"
Status [203] = "Non-Authoritative Information"
Status [204] = "No Content"
Status [205] = "Reset Content"
Status [206] = "Partial Content"
Status [207] = "Multi-Status"
Status [210] = "Content Different"
Status [226] = "IM Used"
Status [300] = "Multiple Choices"
Status [301] = "Moved Permanently"
Status [302] = "Moved Temporarily"
Status [303] = "See Other"
Status [304] = "Not Modified"
Status [305] = "Use Proxy"
Status [307] = "Temporary Redirect"
Status [308] = "Permanent Redirect"
Status [310] = "Too many Redirects"
Status [400] = "Bad Request"
Status [401] = "Unauthorized"
Status [402] = "Payment Required"
Status [403] = "Forbidden"
Status [404] = "Not Found"
Status [405] = "Method Not Allowed"
Status [406] = "Not Acceptable"
Status [407] = "Proxy Authentication Required"
Status [408] = "Request Time-out"
Status [409] = "Conflict"
Status [410] = "Gone"
Status [411] = "Length Required"
Status [412] = "Precondition Failed"
Status [413] = "Request Entity Too Large"
Status [414] = "Request-URI Too Long"
Status [415] = "Unsupported Media Type"
Status [416] = "Requested range unsatisfiable."
Status [417] = "Expectation failed"
Status [418] = "I’m a teapot"
Status [422] = "Unprocessable entity"
Status [423] = "Locked"
Status [424] = "Method failure"
Status [425] = "Unordered Collection"
Status [426] = "Upgrade Required"
Status [428] = "Precondition Required"
Status [429] = "Too Many Requests"
Status [431] = "Request Header Fields Too Large"
Status [449] = "Retry With"
Status [450] = "Blocked by Windows Parental Controls"
Status [456] = "Unrecoverable Error"
Status [499] = "Client Has Closed Connection"
Status [500] = "Internal Server Error"
Status [501] = "Not Implemented"
Status [502] = "Bad Gateway or Proxy Error"
Status [503] = "Service Unavailable"
Status [504] = "Gateway Time-out"
Status [505] = "HTTP Version not supported"
Status [506] = "Variant also negociate"
Status [507] = "Insufficient storage"
Status [508] = "Loop detected"
Status [509] = "Bandwidth Limit Exceeded"
Status [510] = "Not extended"
Status [520] = "Unknown Error"

local json = require "cjson"

local metatable = {}

function metatable.__eq (lhs, rhs)
  assert (type (rhs) == "table" and getmetatable (rhs) == metatable)
  return lhs.code == rhs.code
end

function metatable:__tostring ()
  return json.encode (self)
end

-- Build shortcuts for statuses.
do
  local functions = {}
  for code, message in pairs (Status) do
    local id = message:gsub ("[^%w]", "_")
    local function f (x)
      if type (x) == "table" then
        x.code    = code
        x.message = message
        return setmetatable (x, metatable)
      else
        return setmetatable ({
          code    = code,
          message = message,
          reason  = x,
        }, metatable)
      end
    end
    functions [code] = f
    functions [id  ] = f
  end
  for k, v in pairs (functions) do
    Status [k] = v
  end
end

return Status
