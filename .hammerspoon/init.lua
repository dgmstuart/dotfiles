local appName = "Alacritty"

hs.hotkey.bind({"ctrl"}, "`", function()
  local app = hs.application.get(appName)
  if not app then
    hs.application.launchOrFocus(appName)   -- start or focus
    return
  end

  if app:isFrontmost() then
    app:hide()                              -- hide if visible/frontmost
  else
    hs.application.launchOrFocus(appName)   -- show/raise if not visible
    -- Optional: un-minimize the first window if all are minimized
    local win = app:mainWindow()
    if win and win:isMinimized() then win:unminimize() end
  end
end)

-- Toggle themes by switching the file

local home  = os.getenv("HOME")
local theme = home .. "/.cache/alacritty/theme.toml"
local dark  = home .. "/.config/alacritty/themes/solarized_dark.toml"
local light = home .. "/.config/alacritty/themes/solarized_light.toml"

local function apply(src)
  hs.execute('cp "'..src..'" "'..theme..'"')
end

local function applyForAppearance()
  hs.execute('mkdir -p "' .. home .. '/.cache/alacritty"') -- create the cache directory if it doesn't exist
  apply(hs.host.interfaceStyle() == "Dark" and dark or light)
end

applyForAppearance()  -- set correctly on Hammerspoon startup/reload

appearanceWatcher = hs.distributednotifications.new(applyForAppearance, "AppleInterfaceThemeChangedNotification")
appearanceWatcher:start()