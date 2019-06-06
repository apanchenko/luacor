-- Log system.
-- Have output functions for messages of different severity: info, trace, warning, error.
-- Active severity is selected by cfg.build setting.

-- created modules
local mods = {}

-- stack depth represented as messages indentation
local depth = 0

-- raw output
local out = function(prefix, ...)
  if #arg == 0 then
    return
  end
  local str = prefix.. string.rep('. ', depth)
  for i = 1, #arg do
    str = str.. tostring(arg[i]).. ' '
  end
  print(str)
end

-- global trace/info configuration
local enable_info = true
local enable_trace = true
local log = {}
local log_log

-- configure log one of: 'debug', 'develop', 'release'
log.set_configuration = function(cfg)
  enable_info = (cfg == 'debug')
  enable_trace = (cfg == 'debug' or cfg == 'dev')
  log_log = log.get('log')
  log_log.trace('set_configuration('..cfg..')', 'Info:', enable_info, 'Trace:', enable_trace)
end

-- create log module
-- it is convenient to use ids of same length
log.get = function(id)
  local mod = mods[id]
  if mod == nil then
    local enabled = true
    mod = {}

    if enable_info then
      local pre = '['..id..'.i] '
      mod.info = function(...) if enabled then out(pre, ...) end return mod end
    else
      mod.info = function() return mod end
    end

    if enable_trace then
      local pre = '['..id..'.t] '
      mod.trace = function(...) if enabled then out(pre, ...) end return mod end
    else
      mod.trace = function() return mod end
    end

    local pre = '['..id..'.w] '
    mod.warning = function(...) out(pre, ...) return mod end

    local pre = '['..id..'.e] '
    mod.error = function(...) out(pre, ...) return mod end

    mod.disable = function(   ) enabled = false return mod end
    mod.enter   = function(   ) if enabled then depth = depth + 1 end end
    mod.exit    = function(   ) if enabled then depth = depth - 1 end end

    mods[id] = mod
  end
  return mod
end

return log