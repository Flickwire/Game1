local dancing_rect = {}
local next_id = require('src.utils.next_id')

function dancing_rect:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = math.random(0,500),
        y = math.random(0,500)
      },
      width = 25,
      height = 25
    }
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function dancing_rect:init()
  print(string.format("INFO: Initializing dancing_rect with ID %s", self.id))
end

function dancing_rect:update()
  self.pos.x = self.pos.x + math.random(-1,1)
  self.pos.y = self.pos.y + math.random(-1,1)
end

function dancing_rect:draw()
  love.graphics.setColor(0,0.2,1,0.8)
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end


function dancing_rect:destroy()
  print(string.format("INFO: Destroying dancing_rect with ID %i", self.id))
end

return dancing_rect
