local player = require('src.actors.player')
local dancing_rect = require('src.actors.dancing_rect')
local wall = require('src.actors.wall')
local gamera = require('lib.gamera.gamera')

local world = {}

function world:new()
  local instance = {
    actor_count = 0,
    actors = {},
    drawables = {},
    updatables = {},
    collidables = {},
    camera = nil,
    width = 1000,
    height = 1000
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function world:init()
  math.randomseed(os.clock())
  self.camera = gamera.new(0, 0, self.width, self.height)
  --level bounds
  self:add_actor(wall:new({pos={x=-100,y=-100}, width=self.width + 200, height=100}))
  self:add_actor(wall:new({pos={x=-100,y=self.height}, width=self.width + 200, height=100}))
  self:add_actor(wall:new({pos={x=-100,y=-100}, width=100, height=self.height + 200}))
  self:add_actor(wall:new({pos={x=self.width,y=-100}, width=100, height=self.height + 200}))
  --player
  local player_instance = player:new()
  player_instance.pos.x = self.width / 2
  player_instance.pos.y = self.height / 2
  self:add_actor(player_instance)
  --dancing rects
  for _=1,200 do
    self:add_actor(dancing_rect:new())
  end
end

function world:update(dt)
  for _,actor in pairs(self.updatables) do
    actor:update(dt)
  end
end

function world:draw()
  self.camera:draw(function(l,t,w,h)
    for _,actor in pairs(self.drawables) do
      actor:draw()
    end
  end)
end

function world:add_actor(actor)
  assert(actor.id ~= nil, "Failed to insert actor with unknown ID")
  assert(self.actors[actor.id] == nil, string.format("Actor ID collision (%s)", actor.id))
  if (actor.init and type(actor.init) == "function") then
    actor:init(self)
  end
  if (actor.update and type(actor.update) == "function") then
    self.updatables[actor.id] = actor
  end
  if (actor.draw and type(actor.draw) == "function") then
    self.drawables[actor.id] = actor
  end
  if (actor.getBoundingBox and type(actor.getBoundingBox) == "function") then
    self.collidables[actor.id] = actor
  end
  self.actors[actor.id] = actor
  self.actor_count = self.actor_count + 1
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
  self.updatables[actor.id] = nil
  self.drawables[actor.id] = nil
  self.collidables[actor.id] = nil
  self.actor_count = self.actor_count - 1
  print(string.format("INFO: Removed actor with ID %s", actor.id))
end

return world
