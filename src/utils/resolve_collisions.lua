local find_collisions = require('src.utils.find_collisions')

local function resolve_collisions(world, actor, actor_pos_before)
  if (actor_pos_before.x == actor.pos.x and
      actor_pos_before.y == actor.pos.y) then
    return
  end
  local collisions = find_collisions(world, actor)
  for _, other_actor in pairs(collisions) do
    local actor_box = actor:getBoundingBox()
    local other_box = other_actor:getBoundingBox()
    if (actor_box.x1 < other_box.x2 and actor_box.x2 > other_box.x1 and
        actor_box.y1 < other_box.y2 and actor_box.y2 > other_box.y1) then
      if (actor_box.x1 < other_box.x1) then
        actor.pos.x = other_box.x1 - actor.width
      elseif (actor_box.x2 > other_box.x2) then
        actor.pos.x = other_box.x2
      end
      if (actor_box.y1 < other_box.y1) then
        actor.pos.y = other_box.y1 - actor.height
      elseif (actor_box.y2 > other_box.y2) then
        actor.pos.y = other_box.y2
      end
    end
  end
end
return resolve_collisions
