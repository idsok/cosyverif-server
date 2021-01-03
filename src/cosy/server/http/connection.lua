local Header = require "cosy.server.http.header"

local Connection = Header.class {
  name = "Connection",
  filters = {
    Header.Sequence,
    Header.Normalized,
    Header.Tokenized,
  },
}

function Connection.on_request (header, context)
  local response = {}
  if header.close then
    response.close = true
  elseif header.keep_alive then
    response.keep_alive = true
  end
  context.response.headers.connection = response
end

function Connection.response_default (context)
  context.response.headers.connection = { close = true }
end

function Connection.on_response (header, context)
  if header.close then
    context.continue = false
  elseif header.keep_alive then
    context.continue = true
  end
end

return Connection
