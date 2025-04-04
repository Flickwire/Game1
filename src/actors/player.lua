local player = {}
local next_id = require('src.utils.next_id')
local resolve_collisions = require('src.utils.resolve_collisions')
local magic_bullet = require('src.actors.magic_bullet')

function player:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = 0,
        y = 0
      },
      width = 5,
      height = 5,
      speed = 100,
      pointerDirection = 0,
      pointerDistance = 100,
      shotCooldownTimer = 0,
      shotCooldown = 0.33,
      type = "player",
    }
  end
  instance.id = next_id()
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function player:init(world)
  print(string.format("INFO: Initializing player with ID %s", self.id))
  self.world = world
end

function player:update(dt)
  self:handleInput(dt)
  self.world.camera:setPosition(self.pos.x, self.pos.y)
end

function player:handleInput(dt)
  local speed = self.speed
  local pos_before = {x=self.pos.x, y=self.pos.y}
  if love.keyboard.isDown('q') then
    speed = speed * 20
  end
  if love.keyboard.isDown('w') then
    self.pos.y = self.pos.y - speed * dt
  end
  if love.keyboard.isDown('s') then
    self.pos.y = self.pos.y + speed * dt
  end
  if love.keyboard.isDown('a') then
    self.pos.x = self.pos.x - speed * dt
  end
  if love.keyboard.isDown('d') then
    self.pos.x = self.pos.x + speed * dt
  end
  resolve_collisions(self.world, self, pos_before, {'player_bullet', 'enemy_bullet', 'player'})
  local mouseX, mouseY = love.mouse.getPosition()
  local screenX, screenY = self.world.camera:toScreen(self.pos.x, self.pos.y)
  local dx = mouseX - screenX
  local dy = mouseY - screenY
  self.pointerDirection = math.atan2(dy, dx)
  if love.mouse.isDown(1) then
    self:fire()
  end
  self.shotCooldownTimer = self.shotCooldownTimer + dt
  if self.shotCooldownTimer > self.shotCooldown then
    self.shotCooldownTimer = self.shotCooldown
  end
end

function player:draw()
  love.graphics.setColor(1,0,0,1)
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
  local pointerX = self.pos.x + math.cos(self.pointerDirection) * self.pointerDistance
  local pointerY = self.pos.y + math.sin(self.pointerDirection) * self.pointerDistance
  love.graphics.setColor(0,1,0,1)
  love.graphics.circle("line", pointerX, pointerY, 5)
end

function player:fire()
  if self.shotCooldownTimer < self.shotCooldown then
    return
  end
  self.shotCooldownTimer = 0
  print(string.format("INFO: Player with ID %s fired a shot", self.id))
  local bullet = magic_bullet:new({
    pos = {
      x = self.pos.x,
      y = self.pos.y
    },
    velocity = {
      x = math.cos(self.pointerDirection) * 300,
      y = math.sin(self.pointerDirection) * 300
    },
    max_lifetime = 0.5,
    type = "player_bullet",
    damage = 10,
    damage_type = "magic",
  })
  self.world:add_actor(bullet)
end

function player:getBoundingBox()
  return {
    x1 = self.pos.x,
    y1 = self.pos.y,
    x2 = self.pos.x + self.width,
    y2 = self.pos.y + self.height
  }
end

function player:destroy()
  print(string.format("INFO: Destroying player with ID %i", self.id))
end

return player