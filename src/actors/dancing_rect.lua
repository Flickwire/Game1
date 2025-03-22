local dancing_rect = {}
local next_id = require('src.utils.next_id')

function dancing_rect:new()
  local instance = {
    id = next_id(),
    pos = {
      x = math.random(0,500),
      y = math.random(0,500)
    }
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end


function dancing_rect:draw()
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
end

return dancing_rect
