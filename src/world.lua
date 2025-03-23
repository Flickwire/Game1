local world = {}

function world:new()
  local instance = {
    actors = {}
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function world:init()
  math.randomseed(os.clock())
  world.camera = require('lib.gamera.gamera').new(0, 0, 1000, 1000)
end

function world:update()
  for _,actor in ipairs(self.actors) do
    if (actor.update and type(actor.update) == "function") then
      actor:update()
    end
  end
  local x, y = self.camera:getPosition()
  if love.keyboard.isDown("w") then
    y = y - 2
  end
  if love.keyboard.isDown("s") then
    y = y + 2
  end
  if love.keyboard.isDown("a") then
    x = x - 2
  end
  if love.keyboard.isDown("d") then
    x = x + 2
  end
  self.camera:setPosition(x, y)
end

function world:draw()
  self.camera:draw(function(l,t,w,h)
    for _,actor in ipairs(self.actors) do
      if (actor.draw and type(actor.draw) == "function") then
        actor:draw()
      end
    end
  end)
end

function world:add_actor(actor)
  assert(actor.id ~= nil, "Failed to insert actor with unknown ID")
  if (actor.init and type(actor.init) == "function") then
    actor:init()
  end
  table.insert(self.actors, actor)
  print(string.format("INFO: Inserted actor with ID %i", actor.id))
end

function world:remove_actor(actor)
  assert(actor.id ~= nil, "Failed to remove actor with unknown ID")
  for i, a in ipairs(self.actors) do
    if a.id == actor.id then
      table.remove(self.actors, i)
      if (a.destroy and type(a.destroy) == "function") then
        a:destroy()
      end
      print(string.format("INFO: Removed actor with ID %i", actor.id))
      return
    end
  end
  print(string.format("WARN: Could not find actor with ID %i to remove", actor.id))
end

return world
