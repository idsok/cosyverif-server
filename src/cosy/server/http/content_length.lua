local Header = require "cosy.server.http.header"

local Content_Length = Header.class {
  name = "Content-Length",
  filters = {
    Header.Sequence,
    Header.First,
    Header.Integer,
  },
}

function Content_Length.on_request (header, context)
  context.request.body = context.socket:receive (header)
end

function Content_Length.response_default (context)
  context.response.headers.content_length = 0
end

function Content_Length.on_response (_, context)
  context.response.headers.content_length = #(context.response.body or "")
end

return Content_Length
