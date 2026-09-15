-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█

-- See https://wiki.hypr.land/configuring/core/binds/

-- Main modifier
local mainMod = "SUPER" -- super / meta / windows key

-- Assign apps
local term = "kitty"
local editor = "nvim"
local file = "dolphin"
local browser = "brave --password-store=kwallet5"
local secondary_browser = "librewolf"

-- Commands
local capture_select = [[grim -g "$(slurp)" - | wl-copy]]
local brightness_up = "brightnessctl set 5%+"
local brightness_down = "brightnessctl set 5%-"

-- Window/Session actions
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + Delete", hl.dsp.exit())
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" })) -- toggle the window between focus and float
hl.bind(mainMod .. " + W", hl.dsp.window.center()) -- toggle the window between focus and float
hl.bind(mainMod .. " + G", hl.dsp.group.toggle()) -- toggle the window between focus and group
hl.bind(mainMod .. " + Return", hl.dsp.window.fullscreen({ mode = "maximized" })) -- toggle the window between focus and fullscreen
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- toggle the window between focus and fullscreen
hl.bind(mainMod .. " + SHIFT + Caps_Lock", hl.dsp.exec_cmd("swaylock")) -- launch lock screen
hl.bind(mainMod .. " + Caps_Lock", hl.dsp.exec_cmd("hyprlock")) -- launch lock screen
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("windowpin")) -- toggle pin on focused window
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd("logoutlaunch")) -- launch logout menu
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd("killall waybar || waybar")) -- toggle waybar
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd(capture_select)) -- takes a screenshot of selected part

-- Application shortcuts
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(term)) -- launch terminal emulator
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file)) -- launch file manager
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(editor)) -- launch text editor
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser)) -- launch web browser
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(secondary_browser)) -- launch secondary web browser
hl.bind(mainMod .. " + SHIFT + CTRL + F", hl.dsp.exec_cmd("torbrowser-launcher")) -- launch secondary web browser
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("sysmonlaunch")) -- launch system monitor (htop/btop or fallback to top)

-- Rofi menus
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("pkill -x rofi || rofilaunch d || rofi -show drun")) -- launch application launcher
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("pkill -x rofi || rofilaunch w || rofi -show drun")) -- launch window switcher
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("pkill -x rofi || rofilaunch f")) -- launch file explorer

-- Audio control
hl.bind("F1", hl.dsp.exec_cmd("volumecontrol -o m"), { locked = true }) -- toggle audio mute
hl.bind("F2", hl.dsp.exec_cmd("volumecontrol -o d"), { locked = true, repeating = true }) -- decrease volume
hl.bind("F3", hl.dsp.exec_cmd("volumecontrol -o i"), { locked = true, repeating = true }) -- increase volume
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volumecontrol -o m"), { locked = true }) -- toggle audio mute
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volumecontrol -i m"), { locked = true }) -- toggle microphone mute
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumecontrol -o d"), { locked = true, repeating = true }) -- decrease volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumecontrol -o i"), { locked = true, repeating = true }) -- increase volume

-- Media control
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- toggle between media play and pause
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- toggle between media play and pause
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true }) -- media next
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true }) -- media previous

-- Brightness control (this should be changed to a bash script later for visual indication)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightness_up), { locked = true, repeating = true }) -- increase brightness
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightness_down), { locked = true, repeating = true }) -- decrease brightness

-- Move between grouped windows
hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next())

-- Screenshot/Screencapture
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("screenshot s")) -- partial screenshot capture
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("screenshot sf")) -- partial screenshot capture (frozen screen)
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("screenshot m")) -- monitor screenshot capture
hl.bind("Print", hl.dsp.exec_cmd("screenshot p")) -- all monitors screenshot capture

-- Custom keybindings
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("toggleblur")) -- enable / disable blur
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("gamemode")) -- disable hypr effects for gamemode
hl.bind(mainMod .. " + Right", hl.dsp.exec_cmd("swwwallpaper -n")) -- next wallpaper
hl.bind(mainMod .. " + Left", hl.dsp.exec_cmd("swwwallpaper -p")) -- previous wallpaper
hl.bind(mainMod .. " + ALT + Up", hl.dsp.exec_cmd("wbarconfgen n")) -- next waybar mode
hl.bind(mainMod .. " + ALT + Down", hl.dsp.exec_cmd("wbarconfgen p")) -- previous waybar mode
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkill -x rofi || wallbashtoggle -m")) -- launch wallbash mode select menu
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("pkill -x rofi || themeselect")) -- launch theme select menu
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("pkill -x rofi || rofiselect")) -- launch select menu
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("pkill -x rofi || swwwallselect")) -- launch wallpaper select menu
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pkill -x rofi || cliphist c")) -- launch clipboard
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("keyboardswitch")) -- switch keyboard layout

-- Move/Change window focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces / move focused window to a workspace (normal + silent)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Switch workspaces to a relative workspace
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + Left", hl.dsp.focus({ workspace = "r-1" }))

-- Move to the first empty workspace
hl.bind(mainMod .. " + CTRL + Down", hl.dsp.focus({ workspace = "empty" }))

-- Resize windows
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Move focused window to a relative workspace
hl.bind(mainMod .. " + CTRL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + Left", hl.dsp.window.move({ workspace = "r-1" }))

-- Move focused window around the current workspace
hl.bind(mainMod .. " + SHIFT + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + CTRL + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + CTRL + J", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + CTRL + K", hl.dsp.window.move({ direction = "down" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/Resize focused window
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true })

-- Activate presentation mode
hl.bind(mainMod .. " + ALT + CTRL + P", hl.dsp.submap("presentation"))

-- Submap: presentation mode
hl.define_submap("presentation", function()
    hl.bind("mouse:273", hl.dsp.exec_cmd("wtype -k right"))
    hl.bind("mouse:272", hl.dsp.exec_cmd("wtype -k left"))
    hl.bind("R", hl.dsp.submap("reset")) -- Exit presentation mode
end)

-- Move/Switch to special workspace (scratchpad)
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special", follow = false }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special())

-- to exit a submap manually: hyprctl dispatch hl.dsp.submap("reset")
