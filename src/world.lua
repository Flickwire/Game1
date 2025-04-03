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
  self.camera = require('lib.gamera.gamera').new(0, 0, 1000, 1000)
end

function world:update()
  for _,actor in pairs(self.actors) do
    if (actor.update and type(actor.update) == "function") then
      actor:update()
    end
  end
end

function world:draw()
  self.camera:draw(function(l,t,w,h)
    for _,actor in pairs(self.actors) do
      if (actor.draw and type(actor.draw) == "function") then
        actor:draw()
      end
    end
  end)
end

function world:add_actor(actor)
  assert(actor.id ~= nil, "Failed to insert actor with unknown ID")
  if (actor.init and type(actor.init) == "function") then
    actor:init(self)
  end
  self.actors[actor.id] = actor
  print(string.format("INFO: Inserted actor with ID %s", actor.id))
end

function world:remove_actor(actor)
  assert(actor.id ~= nil, "Failed to remove actor with unknown ID")
  if (self.actors[actor.id] == nil) then
    print(string.format("WARN: Actor with ID %s not found", actor.id))
    return
  end
  if (actor.destroy and type(actor.destroy) == "function") then
    actor:destroy()
  end
  self.actors[actor.id] = nil
  print(string.format("INFO: Removed actor with ID %s", actor.id))
end

return world
