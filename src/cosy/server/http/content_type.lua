local Header = require "cosy.server.http.header"
local Status = require "cosy.server.status"
local json   = require "cjson"
local yaml   = require "yaml"
local url    = require "socket.url"

local Content_Type = Header.class {
  name = "Content-Type",
  filters = {
    Header.Sequence,
    Header.Parameterized,
    Header.MIME,
    Header.First,
  },
  depends = {
    "Accept",
    "Content-Length",
  },
}

function Content_Type.on_request (header, context)
  local body = context.request.body
  if     header.main == "application" and header.sub == "json" then
    body = json.decode (body)
  elseif header.main == "application" and header.sub == "yaml" then
    body = yaml.load (body)
  elseif header.main == "application" and header.sub == "lua"  then
    error (Status.Not_Implemented {
      reason = "Lua content-type is not available yet.",
    })
  elseif header.main == "application" and header.sub == "x-www-form-urlencoded" then
    body = {}
    for p in body:gmatch "([^;&]+)" do
      local k, v = p:match "([^=]+)=(.*)"
      k = url.unescape (k):gsub ("+", " ")
      v = url.unescape (v):gsub ("+", " ")
      body [k] = v
    end
  elseif header.main == "multipart" and header.sub == "form-data" then
    error (Status.Not_Implemented {
      reason = "Multipart/form-data content-type is not available yet.",
    })
  else
    error (Status.Unsupported_Media_Type {
      reason  = "unknown Content-Type: ${main}/${sub}." % header,
    })
  end
  context.request.body = body
end

function Content_Type.response_default (context)
  if context.response.body == nil then
    return
  end
  local accepts = context.request.headers.accept
  for _, x in ipairs (accepts) do
    if x.main == "*"           and x.sub == "*"
    or x.main == "application" and x.sub == "*"
    or x.main == "application" and x.sub == "json" then
      context.response.headers.content_type = {
        main = "application",
        sub  = "json",
      }
      break
    elseif x.main == "application" and x.sub == "yaml" then
      context.response.headers.content_type = {
        main = "application",
        sub  = "yaml",
      }
      break
    elseif x.main == "application" and x.sub == "lua" then
      error (Status.Not_Implemented {
        reason = "Lua content-type is not available yet."
      })
    else
      error (Status.Not_Acceptable {
        reason  = "No valid accepted format.",
      })
    end
  end
end

function Content_Type.on_response (header, context)
  local body = context.response.body
  if     header.main == "application" and header.sub == "json" then
    body = json.encode (body)
  elseif header.main == "application" and header.sub == "yaml" then
    body = yaml.dump (body)
  end
  context.response.body = body
end

return Content_Type
