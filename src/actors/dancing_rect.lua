local dancing_rect = {}
local next_id = require('src.utils.next_id')
local resolve_collisions = require('src.utils.resolve_collisions')

function dancing_rect:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = math.random(0,1000),
        y = math.random(0,1000)
      },
      width = math.random(10,100),
      height = math.random(10,100),
      health = 1,
      world = nil,
      type = "dancing_rect",
    }
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function dancing_rect:init(world)
  self.world = world
  print(string.format("INFO: Initializing dancing_rect with ID %s", self.id))
end

function dancing_rect:update()
  local pos_before = {x=self.pos.x, y=self.pos.y}
  self.pos.x = self.pos.x + math.random(-1,1)
  self.pos.y = self.pos.y + math.random(-1,1)
  resolve_collisions(self.world, self, pos_before, {'dancing_rect', 'player_bullet', 'enemy_bullet'})
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
