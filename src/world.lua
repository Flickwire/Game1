local world = {
  actors = {}
}

function world:init()
  math.randomseed(os.clock())
  for _,actor in ipairs(self.actors) do
    if (actor.init and type(actor.init) == "function") then
      actor:init()
    end
  end
end

function world:update()
  for _,actor in ipairs(self.actors) do
    if (actor.update and type(actor.update) == "function") then
      actor:update()
    end
  end
end

function world:draw()
  for _,actor in ipairs(self.actors) do
    if (actor.draw and type(actor.draw) == "function") then
      actor:draw()
    end
  end
end

function world:add_actor(actor)
  assert(actor.id ~= nil, "Failed to insert actor with unknown ID")
  table.insert(self.actors, actor)
  print(string.format("INFO: Inserted actor with ID %i", actor.id))
end

function world:remove_actor(actor)
  assert(actor.id ~= nil, "Failed to remove actor with unknown ID")
  for i, a in ipairs(self.actors) do
    if a.id ~= actor.id then
      table.remove(self.actors, i)
      print(string.format("INFO: Removed actor with ID %i", actor.id))
      return
    end
  end
  print(string.format("WARN: Could not find actor with ID %i to remove", actor.id))
end

return world
