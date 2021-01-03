local bcrypt        = require "bcrypt"
local json          = require "cjson"
local Configuration = require "cosy.server.configuration"
local Status        = require "cosy.server.status"

local rounds = Configuration.server.password_rounds

local Authentication = {}

Authentication.name = "Authentication"

function Authentication.add (context, t)
  local client   = context.redis
  local username = t.username
  client:watch ("/auth")
  if client:hexists ("/auth", username) then
    error (Status.Conflict {
      reason = "User ${username} exists already." % {
        username = username,
      }
    })
  end
  client:multi ()
  t.password = bcrypt.digest (t.password, rounds)
  client:hset ("/auth", username, json.encode (t))
  if not client:exec () then
    error (Status.Conflict {
      reason   = "Conflict with another request",
    })
  end
end

function Authentication.update (context, t)
  local client   = context.redis
  local username = t.username
  client:watch ("/auth")
  if not client:hexists ("/auth", username) then
    error (Status.Not_Found {
      reason = "User ${username} does not exist." % {
        username = username,
      }
    })
  end
  client:multi ()
  t.password = bcrypt.digest (t.password, rounds)
  client:hset ("/auth", username, json.encode (t))
  if not client:exec () then
    error (Status.Conflict {
      reason   = "Conflict with another request",
    })
  end
end

function Authentication.remove (context, t)
  local client   = context.redis
  local username = t.username
  client:watch ("/auth")
  if not client:hexists ("/auth", username) then
    error (Status.Not_Found {
      reason = "User ${username} does not exist." % {
        username = username,
      }
    })
  end
  client:multi ()
  client:hdel ("/auth", username)
  if not client:exec () then
    error (Status.Conflict {
      reason = "Conflict with another request",
    })
  end
end

local cache = setmetatable ({}, { __mode = "kv" })

function Authentication.check (context)
  local client   = context.redis
  local username = context.username
  local info     = client:hget ("/auth", username)
  if not info then
    error (Status.Not_Found {
      reason = "User ${username} does not exist." % {
        username = username,
      }
    })
  end
  if cache [username .. ":" .. context.password] == info.password then
    return true
  else
    local ok = bcrypt.verify (context.password, info.password)
    if ok then
      cache [username .. ":" .. context.password] = info.password
      return true
    end
  end
  error (Status.Unauthorized {})
end

function Authentication.request (context)
  if context.username then
    Authentication.check (context)
  end
end

function Authentication.response ()
end

function Authentication.error (_, err)
  error (err)
end


return Authentication