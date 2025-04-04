local find_collisions = require('src.utils.find_collisions')

local function resolve_collisions(world, actor, actor_pos_before, ignore_types, axis)
  if (actor_pos_before.x == actor.pos.x and
      actor_pos_before.y == actor.pos.y) then
    return
  end
  local collisions = find_collisions(world, actor)
  local actor_box = actor:getBoundingBox()
  --TODO: let actor provide past bounding box
  local actor_box_before = {
    x1 = actor_pos_before.x,
    y1 = actor_pos_before.y,
    x2 = actor_pos_before.x + actor.width,
    y2 = actor_pos_before.y + actor.height
  }
  for _, other_actor in pairs(collisions) do
    if other_actor.id == actor.id then
      goto continue
    end
    if ignore_types then
      for _, type in ipairs(ignore_types) do
        if other_actor.type == type then
          goto continue
        end
      end
    end
    local other_box = other_actor:getBoundingBox()
    if (axis == "y") then
      if (actor_box.y1 < actor_box_before.y1) then
        ---moving up
        if (actor_box.y1 < other_box.y2) then
          actor.pos.y = other_box.y2
        end
      else
        ---moving down
        if (actor_box.y2 > other_box.y1) then
          actor.pos.y = other_box.y1 - actor.height
        end
      end
    end
    if (axis == "x") then
      if (actor_box.x1 < actor_box_before.x1) then
        ---moving left
        if (actor_box.x1 < other_box.x2) then
          actor.pos.x = other_box.x2
        end
      else
        ---moving right
        if (actor_box.x2 > other_box.x1) then
          actor.pos.x = other_box.x1 - actor.width
        end
      end
    end
    ::continue::
  end
end
return resolve_collisions
