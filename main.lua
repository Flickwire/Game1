MODE_DEBUG = false
if arg[2] == "debug" then
  require("lldebugger").start()
  MODE_DEBUG = true
end

WORLD = nil

function love.load()
  WORLD = require('src.world'):new()
  WORLD:init()
  for _=1,200 do
    WORLD:add_actor(require('src.actors.dancing_rect'):new({pos={x=math.random(0,1000),y=math.random(0,1000)}}))
  end
end

function love.update()
  WORLD:update()
end

function love.draw()
  WORLD:draw()
end

--Error Handler for debug
local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if MODE_DEBUG then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end