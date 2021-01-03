local _             = require "cosy.util.string"
local Configuration = require "cosy.server.configuration"
local Status        = require "cosy.server.status"
local coroutine     = require "coroutine.make" ()
local json          = require "cjson"

local logger         = Configuration.logger
local scheduler      = Configuration.scheduler
local root_id        = Configuration.server.root

local properties_key     = "//properties"
local identifier_pattern = "[^/]+"

local Resource    = {}
local Read_Only   = {}
local Empty_Class = {}

function Resource.get (context, id)
  local client = context.redis
  client:watch (id)
  local properties = client:hget (id, properties_key)
  if not properties then
    error (Status.Not_Found {
      resource = id,
    })
  end
  properties = json.decode (properties)
  local class
  if properties.type then
    class = require ("cosy.server.resource." .. properties.type:lower ())
  else
    class = Empty_Class
  end
  local path  = {}
  for s in id:gmatch (identifier_pattern) do
    path [#path + 1] = s
  end
  local result = {
    _id         = id,
    _context    = context,
    _class      = class,
    _properties = properties,
    _path       = path,
  }
  return setmetatable (result, Resource)
end

function Resource.root (context)
  return Resource.get (context, root_id)
end

function Resource:__index (key)
  local in_resource = Resource [key]
  if in_resource then
    return in_resource
  end
  local in_class = self._class [key]
  if in_class then
    if type (in_class) == "function" then
      return function (resource, ...)
        return in_class (resource, resource._context, ...)
      end
    else
      return in_class
    end
  end
  local context    = self._context
  local properties = self._properties
  if properties.status == "deleted" then
    error (Status.Gone {
      resource = self._id,
    })
  elseif properties.status == "moved" then
    error (Status.Moved_Permanently {
      resource = self._id,
      target   = properties.redirection,
    })
  elseif properties.status == "created" then
    error (Status.Method_Not_Allowed {
      resource = self._id,
      reason   = "Resource has not been activated yet."
    })
  elseif properties.status == "active" then
    if not self:can_read () then
      error (Status.Forbidden {
        resource = self._id,
        reason   = "User ${usename} is not allowed to read ${resource}." % {
            username = context.username or "<anonymous>",
            resource = self._id,
        },
      })
    end
    return Read_Only.make (properties)
  end
  assert (false)
end

function Resource.__newindex ()
  assert (false)
end

function Resource:__div (key)
  assert (type (key) == "string" and key:match (identifier_pattern) == key)
  local context = self._context
  local id      = "${parent}/${key}" % {
    parent = self._id,
    key    = key,
  }
  return Resource.get (context, id)
end

function Resource:new (identifier, properties)
  assert (type (identifier) == "string")
  assert (type (properties) == "table")
  local context = self._context
  if not self:is_owner () then
    error (Status.Forbidden {
      resource = self._id,
      reason   = "User ${usename} is not an owner of ${resource}." % {
          username = context.username or "<anonymous>",
          resource = self._id,
      },
    })
  end
  local client = context.redis
  local target = "${parent}/${identifier}" % {
    parent     = self._id,
    identifier = identifier,
  }
  client:watch (target)
  if client:exists (target) then
    error (Status.Conflict {
      resource = target,
      reason   = "Resource ${target} exists already." % {
        target = target,
      }
    })
  end
  client:multi ()
  client:hset (target, properties_key, json.encode (properties))
  client:hset (self._id, identifier, target)
  if not client:exec () then
    error (Status.Conflict {
      resource = target,
      reason   = "Conflict with another request",
    })
  end
  return Resource.get (context, target)
end

function Resource:remove ()
  local context = self._context
  if not self:is_owner () then
    error (Status.Forbidden {
      resource = self._id,
      reason   = "User ${usename} is not an owner of ${resource}." % {
          username = context.username or "<anonymous>",
          resource = self._id,
      },
    })
  end
  local client = context.redis
  if client:hlen (self._id) ~= 1 then -- properties_key
    error (Status.Method_Not_Allowed {
      resource = self._id,
      reason   = "Resource ${resource} is not empty." % {
        resource = self._id,
      }
    })
  end
  local path   = self.path
  local parent = table.concat (path, "/", 1, #path-1)
  client:watch (parent)
  client:watch (self._id)
  client:multi ()
  client:hset (self._id, properties_key, json.encode {
    status = "deleted",
  })
  client:hdel (parent, path [#path])
  if not client:exec () then
    error (Status.Conflict {
      resource = self._id,
      reason   = "Conflict with another request",
    })
  end
end

function Resource:update (f)
  assert (type (f) == "function")
  local context = self._context
  if not self:can_read () then
    error (Status.Forbidden {
      resource = self._id,
      reason   = "User ${usename} is not allowed to read ${resource}." % {
          username = context.username or "<anonymous>",
          resource = self._id,
      },
    })
  end
  if not self:can_write () then
    error (Status.Forbidden {
      resource = self._id,
      reason   = "User ${usename} is not allowed to write ${resource}." % {
          username = context.username or "<anonymous>",
          resource = self._id,
      },
    })
  end
  local client     = context.redis
  local properties = self._properties
  client:watch (self._id)
  local ok, err = pcall (f, properties, context)
  if not ok then
    error (err)
  end
  client:multi ()
  client:hset (self._id, properties_key, json.encode (properties))
  if not client:exec () then
    error (Status.Conflict {
      resource = self._id,
      reason   = "Conflict with another request",
    })
  end
end

function Resource:__pairs ()
  local client  = self._context.redis
  return coroutine.wrap (function ()
    for k in client:hscan (self._id) do
      if k:sub (1, 1) ~= "_" then
        coroutine.yield (k, self / k)
      end
    end
  end)
end

function Resource:__tostring ()
  return self._id
end

function Resource.__eq (lhs, rhs)
  return getmetatable (lhs) == getmetatable (rhs)
     and lhs._id == rhs._id
end


function Read_Only.make (properties)
  return setmetatable ({
    _data = properties,
  }, Read_Only)
end

function Read_Only:__index (key)
  local value = self._data [key]
  if type (value) == "table" then
    return Read_Only.make (value)
  else
    return value
  end
end

function Read_Only.__newindex ()
  assert (false)
end

scheduler:addthread (function ()
  local context = {}
  local Redis   = require "cosy.server.redis"
  Redis.acquire (context)
  local client = context.redis
  if Configuration.clean then
    logger:debug "Flushing database..."
    client:flushdb ()
  end
  client:watch (root_id)
  if not client:exists (root_id) then
    client:multi ()
    client:hset (root_id, properties_key, json.encode {
      type = "Root",
    })
    client:exec ()
  end
  Redis.release (context)
end)

return Resource