local function find_collisions(world, actor)
  local collisions = {}
  local actor_box = actor:getBoundingBox()
  for _, other_actor in pairs(world.collidables) do
    if other_actor.id ~= actor.id then
      local other_box = other_actor:getBoundingBox()
      if (actor_box.x1 < other_box.x2 and actor_box.x2 > other_box.x1 and
          actor_box.y1 < other_box.y2 and actor_box.y2 > other_box.y1) then
        table.insert(collisions, other_actor)
      end
    end
  end
  return collisions
end
return find_collisions
