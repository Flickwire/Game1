local magic_bullet = {}
local next_id = require('src.utils.next_id')
local find_collisions = require('src.utils.find_collisions')

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
      type = "enemy_bullet",
      damage = 1,
      damage_type = "magic",
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
  self:handleCollisions()
end

function magic_bullet:handleCollisions()
  local collisions = find_collisions(self.world, self)
  local did_collision = false
  for _,actor in pairs(collisions) do
    if did_collision then
      break
    end
    if actor.id == self.id then
      goto continue
    end
    if (self.type == "enemy_bullet" and actor.type == "enemy") then
      goto continue
    end
    if (self.type == "player_bullet" and actor.type == "player") then
      goto continue
    end
    if actor.take_damage then
      actor:take_damage("magic", 1)
    end
    did_collision = true
    ::continue::
  end
  if did_collision then
    self.world:remove_actor(self)
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

function magic_bullet:destroy()
  print(string.format("INFO: Destroying magic_bullet with ID %s", self.id))
end

return magic_bullet
