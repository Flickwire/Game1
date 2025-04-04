MODE_DEBUG = false
if arg[2] == "debug" then
  require("lldebugger").start()
  MODE_DEBUG = true
end

WORLD = nil

function love.load()
  if (MODE_DEBUG) then
    require("lib.vudu.vudu").initialize()
  end
  WORLD = require('src.world'):new()
  WORLD:init()

  local dancing_rect = require('src.actors.dancing_rect')
  local player = require('src.actors.player')
  local wall = require('src.actors.wall')
  for _=1,200 do
    WORLD:add_actor(dancing_rect:new())
  end
  WORLD:add_actor(player:new())
  WORLD:add_actor(wall:new({pos={x=100,y=100}, width=200, height=200}))
end

function love.update(dt)
  WORLD:update(dt)
end

function love.draw()
  WORLD:draw()
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