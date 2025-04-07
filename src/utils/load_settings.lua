local json = require("lib.json.json")
local function load_settings()
  if love.filesystem.getInfo("settings.json", "file") then
    local file = love.filesystem.read("settings.json")
    local settings = json.decode(file)
    if settings then
      if settings.window then
        love.window.setMode(settings.window.width, settings.window.height, {
          fullscreen = settings.window.fullscreen,
        })
      end
    else
      love.filesystem.remove("settings.json")
      print("Settings could not be loaded. Reverting to default settings.")
    end
  end
end

return load_settings
