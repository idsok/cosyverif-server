local mime          = require "mime"
local Configuration = require "cosy.server.configuration"
local Status        = require "cosy.server.status"
local Header        = require "cosy.server.http.header"

local Authorization = Header.class {
  name = "Authorization",
}

function Authorization.on_request (header, context)
  local encoded = header:match "%s*Basic (.+)%s*"
  local decoded = mime.unb64 (encoded)
  local username, password = decoded:match "(%w+):(.*)"
  context.username = username
  context.password = password
end

function Authorization.on_response (_, context)
  if context.response.status == Status.Unauthorized then
    context.request.headers.www_authenticate = [[Basic realm="${realm}"]] % {
      realm = Configuration.server.root,
    }
  end
end

return Authorization
