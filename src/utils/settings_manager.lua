local settings_manager = {}
local json = require("lib.json.json")

function settings_manager:new()
  local instance = {
    settings = {
      window = {
        width = 800,
        height = 600,
        fullscreen = false,
      },
      keys = {
        go_up = "w",
        go_down = "s",
        go_left = "a",
        go_right = "d",
        go_fast = "lshift",
      },
      lang = "en",
    }
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function settings_manager:load()
  if love.filesystem.getInfo("settings.json", "file") then
    local file = love.filesystem.read("settings.json")
    local settings = json.decode(file)
    if settings then
      if (settings.window == nil) then
        settings.window = {
          width = 800,
          height = 600,
          fullscreen = false,
        }
      end
      if (settings.keys ==  nil) then
        settings.keys = {
          go_up = "w",
          go_down = "s",
          go_left = "a",
          go_right = "d",
          go_fast = "lshift",
        }
      end
      if (settings.lang == nil) then
        --- TODO: Add language support
        settings.lang = "en"
      end
      self.settings = settings
    else
      love.filesystem.remove("settings.json")
      print("Settings could not be loaded. Reverting to default settings.")
    end
  end
end

function settings_manager:save()
  local settings_encoded = json.encode(self.settings)
  love.filesystem.write("settings.json", settings_encoded)
end

function settings_manager:apply()
  if self.settings.window then
    love.window.updateMode(self.settings.window.width, self.settings.window.height, {
      fullscreen = self.settings.window.fullscreen,
    })
  end
end

return settings_manager
