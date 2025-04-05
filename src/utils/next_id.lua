--TODO: Error after 100,000,000,000,000 IDs - should be ok for now
G_ID = 0
local function next_id()
  local next = string.format('E-%d',G_ID)
  G_ID = G_ID + 1
  return next
end
return next_id
