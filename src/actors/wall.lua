local wall = {}
local next_id = require('src.utils.next_id')

function wall:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = 0,
        y = 0
      },
      width = 100,
      height = 100,
      world = nil,
    }
  end
  instance.id = next_id()
  instance.type = "wall"
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function wall:draw()
  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end

function wall:getBoundingBox()
  return {
    x1 = self.pos.x,
    y1 = self.pos.y,
    x2 = self.pos.x + self.width,
    y2 = self.pos.y + self.height
  }
end

return wall
