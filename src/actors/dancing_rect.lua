local dancing_rect = {}
local next_id = require('src.utils.next_id')
local resolve_collisions = require('src.utils.resolve_collisions')

function dancing_rect:new(instance)
  if instance == nil then
    instance = {}
  end
  if instance.width == nil then
    instance.width = math.random(10,100)
  end
  if instance.height == nil then
    instance.height = math.random(10,100)
  end
  if instance.pos == nil then
    instance.pos = {
      x = math.random(10,900),
      y = math.random(10,900)
    }
  end
  if instance.health == nil then
    instance.health = 1
  end
  instance.type = "dancing_rect"
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function dancing_rect:init(world)
  self.world = world
end

function dancing_rect:update()
  local pos_before = {x=self.pos.x, y=self.pos.y}
  self.pos.x = self.pos.x + math.random(-1,1)
  resolve_collisions(self.world, self, pos_before, 'x')
  pos_before = {x=self.pos.x, y=self.pos.y}
  self.pos.y = self.pos.y + math.random(-1,1)
  resolve_collisions(self.world, self, pos_before, 'y')
end

function dancing_rect:draw()
  love.graphics.setColor(0,0.2,1,0.8)
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end

function dancing_rect:getBoundingBox()
  return {
    x1 = self.pos.x,
    y1 = self.pos.y,
    x2 = self.pos.x + self.width,
    y2 = self.pos.y + self.height
  }
end

function dancing_rect:take_damage(damage_type, damage_amount)
  self.health = self.health - damage_amount
  if self.health <= 0 then
    self.world:remove_actor(self)
  end
end

function dancing_rect:destroy()
  print(string.format("INFO: Destroying dancing_rect with ID %s", self.id))
end

return dancing_rect
