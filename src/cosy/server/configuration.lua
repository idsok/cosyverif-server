local yaml      = require "yaml"
local _         = require "cosy.util.string"
local logging   = require "logging"
logging.console = require "logging.console"
local logger    = logging.console "%level %message\n"
local scheduler = require "cosy.server.scheduler" .create ()

local paths = {
  "/etc/cosy.yaml",
  os.getenv "HOME" .. "/.cosy/cosy.yaml",
  os.getenv "PWD"  .. "/cosy.yaml",
  os.getenv "PWD"  .. "/.cosy.yaml",
}

local function import (source, target)
  assert (type (source) == "table")
  assert (type (target) == "table")
  for k, v in pairs (source) do
    if type (v) == "table" then
      if target [k] == nil then
        target [k] = v
      else
        import (v, target [k])
      end
    else
      target [k] = v
    end
  end
end

local configuration = {}

for _, filename in ipairs (paths) do
  local file = io.open (filename, "r")
  if file then
    logger:info ("Reading configuration file ${filename}..." % { filename = filename })
    local text = file:read ("*all")
    import (yaml.load (text), configuration)
    file:close()
  end
end
logger:info "Loaded configuration."

do
  local run = io.popen ("uuidgen", "r")
  local result = run:read "*all"
  run:close ()
  configuration.server.uuid = result:trim ()
end
logger:debug ("Generated uuid ${uuid}." % {
  uuid = configuration.server.uuid,
})

configuration.logger = logger

configuration.scheduler = scheduler
configuration.scheduler.logger = logger

return configuration
