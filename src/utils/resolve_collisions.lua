local find_collisions = require('src.utils.find_collisions')

local function resolve_collisions(world, actor, actor_pos_before, axis, debug)
  if (actor_pos_before.x == actor.pos.x and axis == 'x') then
    return
  end
  if (actor_pos_before.y == actor.pos.y and axis == 'y') then
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
  local new_pos = {
    x = actor.pos.x,
    y = actor.pos.y
  }
  for _, other_actor in pairs(collisions) do
    if other_actor.id == actor.id then
      goto continue
    end
    for _, type in ipairs(GLOBALS.moving_objects) do
      if other_actor.type == type then
        goto continue
      end
    end
    local other_box = other_actor:getBoundingBox()
    if (axis == "y") then
      if (actor_box.y1 < actor_box_before.y1) then
        ---moving up
        if (actor_box.y1 < other_box.y2) then
          new_pos.y = other_box.y2
        end
      else
        ---moving down
        if (actor_box.y2 > other_box.y1) then
          new_pos.y = other_box.y1 - actor.height
        end
      end
    end
    if (axis == "x") then
      if (actor_box.x1 < actor_box_before.x1) then
        ---moving left
        if (actor_box.x1 < other_box.x2) then
          new_pos.x = other_box.x2
        end
      else
        ---moving right
        if (actor_box.x2 > other_box.x1) then
          new_pos.x = other_box.x1 - actor.width
        end
      end
    end
    ::continue::
  end
  if (debug ~= true and (new_pos.x ~= actor.pos.x or new_pos.y ~= actor.pos.y)) then
    actor.pos.x = new_pos.x
    actor.pos.y = new_pos.y
  end
  if (debug == true) then
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("line", new_pos.x, new_pos.y, actor.width, actor.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", actor_box.x1, actor_box.y1, actor.width, actor.height)
  end
end
return resolve_collisions
