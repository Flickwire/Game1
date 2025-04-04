local player = {}
local next_id = require('src.utils.next_id')

function player:new(instance)
  if instance == nil then
    instance = {
      pos = {
        x = 0,
        y = 0
      },
      speed = 100,
      pointerDirection = 0,
      pointerDistance = 100,
      shotCooldownTimer = 0,
      shotCooldown = 0.33,
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
  if love.keyboard.isDown('w') then
    self.pos.y = self.pos.y - self.speed * dt
  end
  if love.keyboard.isDown('s') then
    self.pos.y = self.pos.y + self.speed * dt
  end
  if love.keyboard.isDown('a') then
    self.pos.x = self.pos.x - self.speed * dt
  end
  if love.keyboard.isDown('d') then
    self.pos.x = self.pos.x + self.speed * dt
  end
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
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
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
end

function player:destroy()
  print(string.format("INFO: Destroying player with ID %i", self.id))
end

return player