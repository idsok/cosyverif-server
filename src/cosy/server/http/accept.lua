local Header = require "cosy.server.http.header"

local Accept = Header.class {
  name = "Accept",
  filters = {
    Header.Sequence,
    Header.Parameterized,
    Header.MIME,
    Header.Sorted,
  },
}

function Accept.request_default (context)
  context.request.headers.accept = {
    {
      main       = "*",
      sub        = "*",
    },
  }
end

return Accept
