local configuration = require "cosy.server.configuration"
local redis         = require "redis"

local host      = configuration.redis.host
local port      = configuration.redis.port
local database  = configuration.redis.database
local size      = configuration.redis.size
local scheduler = configuration.scheduler

local Redis = {}

scheduler:addthread (function ()
  local socket    = require "socket"
  local coroutine = require "coroutine.make" ()
  for _ = 1, size do
    local skt = socket.connect (host, port)
    local client = redis.connect {
      socket    = skt,
      coroutine = coroutine,
    }
    client:select (database)
    Redis [#Redis + 1] = client
  end
end)

Redis.name = "Redis"

function Redis.acquire (context)
  while #Redis == 0 do
    scheduler:pass ()
  end
  context.redis = Redis [#Redis]
  Redis [#Redis] = nil
end

function Redis.release (context)
  Redis [#Redis + 1] = context.redis
end

return Redis
