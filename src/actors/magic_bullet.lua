local magic_bullet = {}
local next_id = require('src.utils.next_id')
local find_collisions = require('src.utils.find_collisions')

function magic_bullet:new(instance)
  if instance == nil then
    instance = {}
  end
  if instance.pos == nil then
    instance.pos = {
      x = 0,
      y = 0
    }
  end
  if instance.velocity == nil then
    instance.velocity = {
      x = 0,
      y = 0
    }
  end
  if instance.max_lifetime == nil then
    instance.max_lifetime = 0
  end
  if instance.health == nil then
    instance.health = 1
  end
  if instance.radius == nil then
    instance.radius = 0.5
  end
  if instance.damage == nil then
    instance.damage = 0
  end
  if instance.damage_type == nil then
    instance.damage_type = "magic"
  end
  if (instance.type == nil) then
    instance.type = "magic_bullet"
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function magic_bullet:init(world)
  self.world = world
  self.lifetime = 0
end

function magic_bullet:update(dt)
  self.lifetime = self.lifetime + dt
  if self.lifetime > self.max_lifetime or self.health <= 0 then
    self.world:remove_actor(self)
    return
  end
  self.pos.x = self.pos.x + self.velocity.x * dt
  self.pos.y = self.pos.y + self.velocity.y * dt
  self:handleCollisions()
end

function magic_bullet:handleCollisions()
  local collisions = find_collisions(self.world, self)
  for _,actor in pairs(collisions) do
    if actor.id == self.id then
      goto continue
    end
    if (self.type == "enemy_bullet" and actor.type == "enemy") then
      goto continue
    end
    if (self.type == "player_bullet" and actor.type == "player") then
      goto continue
    end
    print(string.format("INFO: %s (%s) collided with %s (%s)", self.type, self.id, actor.type, actor.id))
    if actor.take_damage then
      actor:take_damage("magic", 1)
    end
    self.health = self.health - 1
    if self.health <= 0 then
      self.world:remove_actor(self)
      break
    end
    ::continue::
  end
end

function magic_bullet:getBoundingBox()
  return {
    x1 = self.pos.x - 4,
    y1 = self.pos.y - 4,
    x2 = self.pos.x + 4,
    y2 = self.pos.y + 4
  }
end

function magic_bullet:draw()
  love.graphics.setColor(1, 0.8, 0, 0.8)
  love.graphics.circle("fill", self.pos.x, self.pos.y, 5)
end

return magic_bullet
