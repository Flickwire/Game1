local magic_bullet = {}
local next_id = require('src.utils.next_id')

function magic_bullet:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = 0,
        y = 0
      },
      velocity = {
        x = 0,
        y = 0
      },
      lifetime = 0,
      max_lifetime = 1,
      world = nil,
    }
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function magic_bullet:init(world)
  self.world = world
  self.lifetime = 0
  print(string.format("INFO: Initializing magic_bullet with ID %s", self.id))
end

function magic_bullet:update(dt)
  self.lifetime = self.lifetime + dt
  if self.lifetime > self.max_lifetime then
    self.world:remove_actor(self)
    return
  end
  self.pos.x = self.pos.x + self.velocity.x * dt
  self.pos.y = self.pos.y + self.velocity.y * dt
end

function magic_bullet:draw()
  love.graphics.setColor(1, 0.8, 0, 0.8)
  love.graphics.circle("fill", self.pos.x, self.pos.y, 5)
end

function magic_bullet:destroy()
  print(string.format("INFO: Destroying magic_bullet with ID %s", self.id))
end

return magic_bullet
