local player = {}
local next_id = require('src.utils.next_id')

function player:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = 0,
        y = 0
      }
    }
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function player:init(world)
  print(string.format("INFO: Initializing player with ID %i", self.id))
  self.world = world
end

function player:update()
  if love.keyboard.isDown('w') then
    self.pos.y = self.pos.y - 1
  end
  if love.keyboard.isDown('s') then
    self.pos.y = self.pos.y + 1
  end
  if love.keyboard.isDown('a') then
    self.pos.x = self.pos.x - 1
  end
  if love.keyboard.isDown('d') then
    self.pos.x = self.pos.x + 1
  end
  self.world.camera:setPosition(self.pos.x, self.pos.y)
end

function player:draw()
  love.graphics.setColor(1,0,0,1)
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
end

function player:destroy()
  print(string.format("INFO: Destroying player with ID %i", self.id))
end

return player