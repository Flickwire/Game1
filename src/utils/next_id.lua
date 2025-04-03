G_ID = 0
local function next_id()
  G_ID = G_ID + 1
  return 'E' .. G_ID
end
return next_id
