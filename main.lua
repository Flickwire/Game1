MODE_DEBUG = false
if arg[2] == "debug" then
  require("lldebugger").start()
  MODE_DEBUG = true
end

WORLD = nil
SETTINGS_MANAGER = require('src.utils.settings_manager'):new()
require('src.utils.globals')

function love.load()
  SETTINGS_MANAGER:load()
  SETTINGS_MANAGER:apply()
  if (MODE_DEBUG) then
    require("lib.vudu.vudu").initialize()
  end
  WORLD = require('src.world'):new()
  WORLD:init()
end

function love.update(dt)
  WORLD:update(dt)
end

function love.draw()
  WORLD:draw()
end

function love.quit()
  SETTINGS_MANAGER:save()
  return true
end

--Error Handler for debug
local love_errorhandler = love.errorhandler

---@param msg string
function love.errorhandler(msg)
    if MODE_DEBUG then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end