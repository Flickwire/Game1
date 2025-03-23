local dancing_rect = {}
local next_id = require('src.utils.next_id')

function dancing_rect:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = math.random(0,500),
        y = math.random(0,500)
      }
    }
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function dancing_rect:init()
  print(string.format("INFO: Initializing dancing_rect with ID %i", self.id))
end

function dancing_rect:update()
  self.pos.x = self.pos.x + math.random(-1,1)
  self.pos.y = self.pos.y + math.random(-1,1)
end

function dancing_rect:draw()
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
end


function dancing_rect:destroy()
  print(string.format("INFO: Destroying dancing_rect with ID %i", self.id))
end

return dancing_rect
