MODE_DEBUG = false
if arg[2] == "debug" then
  require("lldebugger").start()
  MODE_DEBUG = true
end

function love.load()
  local init = require('src.init')
  init.go()
end

function love.update()
  Y = Y + 1
end

function love.draw()
  love.graphics.print("Hello World", 400, Y)
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