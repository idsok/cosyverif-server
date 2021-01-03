-- http://stackoverflow.com/questions/20284515/capitalize-first-letter-of-every-word-in-lua
function string:to_http ()
  return self:gsub ("_", "-"):gsub ("(%a)(%a*)", function (letter, r)
    return letter:upper() .. r:lower()
  end)
end

function string:to_identifier ()
  return self:trim ():lower ():gsub ("-", "_")
end

-- Sequence: { [1] = text ... }
-- Parameterized: { [1] = { token = ..., parameters = { ... } }
-- MIME | Language: { [1] = { ..., parameters = { ... } }
-- Tokens:   { [token] = { parameters } }
-- Token:    { token = ..., parameters = { ... } }

-- local dump = require "pl.pretty" . dump

local Header = {}

Header.__index = Header

--

Header.Sequence = {
  name = "Sequence",
}

function Header.Sequence.request (header, context)
  local value = context.request.headers [header.as_identifier]
  local result = {}
  for token in value:gmatch "([^,%s]+)" do
    result [#result + 1] = { token = token }
  end
  context.request.headers [header.as_identifier] = result
end

function Header.Sequence.response (header, context)
  local value  = context.response.headers [header.as_identifier]
  local result = {}
  for i, v in ipairs (value) do
    result [i] = v.token
  end
  context.response.headers [header.as_identifier] = table.concat (result, ",")
end

--

Header.Normalized = {
  name = "Normalized",
}

function Header.Normalized.request (header, context)
  local value = context.request.headers [header.as_identifier]
  for _, x in ipairs (value) do
    x.token = x.token:to_identifier ()
  end
end

function Header.Normalized.response (header, context)
  local value = context.response.headers [header.as_identifier]
  for _, x in ipairs (value) do
    x.token = x.token:to_http ()
  end
end

--

Header.Parameterized = {
  name = "Parameterized",
  token_pattern     = "([^;%s]+)%s*;?(.*)",
  parameter_pattern = "([^=;%s]+)%s*[=]%s*([^;%s]+)",
}

function Header.Parameterized.request (header, context)
  local value = context.request.headers [header.as_identifier]
  for _, x in ipairs (value) do
    local _, remaining = x.token:match (Header.Parameterized.token_pattern)
    local parameters = {}
    for k, v in remaining:gmatch (Header.Parameterized.parameter_pattern) do
      parameters [k] = v
    end
    x.parameters = parameters
  end
end

function Header.Parameterized.response (header, context)
  local value = context.response.headers [header.as_identifier]
  for _, x in ipairs (value) do
    local result = x.token
    for k, v in pairs (x.parameters or {}) do
      result = result .. "; " .. k .. "=" .. v
    end
    x.token = result
  end
end

--

Header.MIME = {
  name = "MIME",
  pattern = "([^/%s]+)%s*/%s*(.*)",  
}

function Header.MIME.request (header, context)
  local value = context.request.headers [header.as_identifier]
  for _, x in ipairs (value) do
    x.main, x.sub = x.token:match (Header.MIME.pattern)
  end
end

function Header.MIME.response (header, context)
  local value = context.response.headers [header.as_identifier]
  for _, x in ipairs (value) do
    x.token = x.main .. "/" .. x.sub
  end
end

--

Header.Language = {
  name = "Language",
  pattern = "(%a+)(-(%a+))?",
}

function Header.Language.request (header, context)
  local value = context.request.headers [header.as_identifier]
  for _, x in ipairs (value) do
    x.primary, _, x.sub = x.token:match (Header.Language.pattern)
  end
end

function Header.Language.response (header, context)
  local value = context.response.headers [header.as_identifier]
  for _, x in ipairs (value) do
    x.token = x.primary .. (x.sub and "-" .. x.sub or "")
  end
end

--

Header.Sorted = {
  name = "Sorted",
}

function Header.Sorted.request (header, context)
  local value = context.request.headers [header.as_identifier]
  table.sort (value, function (lhs, rhs)
    local l = (lhs.parameters or {}).q or 1
    local r = (rhs.parameters or {}).q or 1
    return l > r
  end)
end

function Header.Sorted.response ()
end

--

Header.Tokenized = {
  name = "Tokenized",
}

function Header.Tokenized.request (header, context)
  local value  = context.request.headers [header.as_identifier]
  local result = {}
  for _, x in ipairs (value) do
    result [x.token] = x.parameters or {}
  end
  context.request.headers [header.as_identifier] = result
end

function Header.Tokenized.response (header, context)
  local value  = context.response.headers [header.as_identifier]
  local result = {}
  for k, v in pairs (value) do
    result [#result + 1] = {
      token      = k,
      parameters = v,
    }
  end
  context.response.headers [header.as_identifier] = result
end

--

Header.First = {
  name = "First",
}

function Header.First.request (header, context)
  local value = context.request.headers [header.as_identifier]
  context.request.headers [header.as_identifier] = value [1]
end

function Header.First.response (header, context)
  local value = context.response.headers [header.as_identifier]
  context.response.headers [header.as_identifier] = { value }
end

--

Header.Integer = {
  name = "Integer",
}

function Header.Integer.request (header, context)
  local value = context.request.headers [header.as_identifier]
  context.request.headers [header.as_identifier] = tonumber (value.token)
end

function Header.Integer.response (header, context)
  local value = context.response.headers [header.as_identifier]
  context.response.headers [header.as_identifier] = {
    token = tostring (value),
  }
end

--

Header.depends = {}

function Header.sort (headers)
  table.sort (headers, function (lhs, rhs)
    local lhs_id = lhs.as_identifier
    local rhs_id = rhs.as_identifier
    if not Header.depends [rhs_id] then
      local dependencies = {}
      for _, dep in ipairs (rhs.depends or {}) do
        dependencies [dep:to_identifier ()] = true
      end
      Header.depends [rhs_id] = dependencies
    end
    return Header.depends [rhs_id] [lhs_id]
  end)
end

function Header.__tostring (header)
  return header.as_http
end

function Header.class (attributes)
  attributes.as_identifier = attributes.name:to_identifier ()
  attributes.as_http       = attributes.name:to_http ()
  return setmetatable (attributes, Header)
end

function Header.request (header, context)
  local value = context.request.headers [header.as_identifier]
  if not value then
    return
  end
  local filters = header.filters
  for i = 1, #filters do
    filters [i].request (header, context)
  end
end

function Header.response (header, context)
  local value = context.response.headers [header.as_identifier]
  if not value then
    return
  end
  local filters = header.filters
  for i = #filters, 1, -1 do
    filters [i].response (header, context)
  end
end

function Header.request_default ()
end

function Header.response_default ()
end

function Header.on_request ()
end

function Header.on_response ()
end

return Header
