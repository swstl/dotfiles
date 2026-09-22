--      ░▒▒▒░░░░░▓▓          ___________
--    ░░▒▒▒░░░░░▓▓        //___________/
--   ░░▒▒▒░░░░░▓▓     _   _ _    _ _____
--   ░░▒▒░░░░░▓▓▓▓▓▓ | | | | |  | |  __/
--    ░▒▒░░░░▓▓   ▓▓ | |_| | |_/ /| |___
--     ░▒▒░░▓▓   ▓▓   \__  |____/ |____/
--       ░▒▓▓   ▓▓  //____/

local home = os.getenv("HOME")
local scrPath = home .. "/.local/share/bin" -- set scripts path


-- █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
-- █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█

-- See https://wiki.hypr.land/configuring/core/autostart/
-- exec-once equivalent: runs once at compositor start (not on every reload)

hl.on("hyprland.start", function()
    hl.exec_cmd("resetxdgportal") -- reset XDPH for screenshare
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for XDPH
    hl.exec_cmd("dbus-update-activation-environment --systemd --all") -- for XDPH
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for XDPH
    hl.exec_cmd("polkitkdeauth") -- authentication dialogue for GUI apps
    hl.exec_cmd("waybar") -- launch the system bar
    hl.exec_cmd("blueman-applet") -- systray app for Bluetooth
    hl.exec_cmd("udiskie --no-automount --smart-tray") -- front-end that allows to manage removable media
    hl.exec_cmd("nm-applet --indicator") -- systray app for Network/Wifi
    hl.exec_cmd("notif_daemon") -- start notification demon
    hl.exec_cmd("wl-paste --type text --watch cliphist store") -- clipboard store text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- clipboard store image data
    hl.exec_cmd("swwwallpaper") -- start wallpaper daemon
    hl.exec_cmd("batterynotify") -- battery notification
    hl.exec_cmd("expressvpnctl connect netherlands-amsterdam") -- start VPN connection
    hl.exec_cmd("gsr-ui")
    hl.exec_cmd("nvidia-smi -pl 400")
end)


-- █▀▀ █▄░█ █░█
-- ██▄ █░▀█ ▀▄▀

-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("PATH", (os.getenv("PATH") or "") .. ":" .. scrPath)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "plasma")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")


-- █ █▄░█ █▀█ █░█ ▀█▀
-- █ █░▀█ █▀▀ █▄█ ░█░

-- See https://wiki.hypr.land/configuring/core/config-options/

hl.config({
    input = {
        kb_layout = "us,no",
        kb_options = "caps:swapescape,grp:win_space_toggle",
        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
        },

        sensitivity = 0,
        repeat_delay = 300,
        repeat_rate = 200,
        force_no_accel = 0,
    },
})

-- to not swap escape and caps on the jarne, cus we donnt want that
hl.device({ name = "jeffrey-lim-jarne-blade-left-keyboard", kb_layout = "us,no", kb_options = "grp:win_space_toggle" }) -- No caps swap
hl.device({ name = "jeffrey-lim-jarne-blade-right-keyboard", kb_layout = "us,no", kb_options = "grp:win_space_toggle" }) -- No caps swap
hl.device({ name = "jarne-blade-keyboard", kb_layout = "us,no", kb_options = "grp:win_space_toggle" }) -- No caps swap
hl.device({ name = "jeffrey-lim-jarne-left-keyboard", kb_layout = "us,no", kb_options = "grp:win_space_toggle" }) -- No caps swap
-- stupid this just goes for all keyboards:
hl.device({ name = "gsr-ui-virtual-keyboard", kb_layout = "us,no", kb_options = "grp:win_space_toggle" }) -- No caps swap
hl.device({ name = "jarne-keyboard", kb_layout = "us,no", kb_options = "grp:win_space_toggle" }) -- No caps swap

-- touchpad
hl.device({ name = "msft0001:00-06cb:ce44-touchpad", sensitivity = 0.1 })

-- See https://wiki.hypr.land/configuring/core/gestures/
-- hl.gesture({ fingers = 5, direction = "vertical", action = "workspace" })


-- █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
-- █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█

-- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/

hl.config({
    dwindle = {
        -- pseudotile = true,
        preserve_split = true,
    },
})

-- See https://wiki.hypr.land/configuring/layouts/master-layout/

-- hl.config({
--     master = {
--         new_status = "master",
--     },
-- })


-- █▀▄▀█ █ █▀ █▀▀
-- █░▀░█ █ ▄█ █▄▄

-- See https://wiki.hypr.land/configuring/core/config-options/

hl.config({
    misc = {
        vrr = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- █▀ █▀█ █▄█ █▀█ █▀▀ █▀▀
-- ▄█ █▄█ █▄█ █▀▄ █▄▄ ██▄

require("animations")
require("keybindings")
require("windowrules")
require("themes.common") -- shared theme settings
require("themes.theme") -- theme specific settings
require("themes.colors") -- wallbash color override
require("themes.blur") -- override blur
require("monitors") -- initially empty, to be configured by user and remains static
require("userprefs") -- initially empty, to be configured by user and remains static

-- Note: as userprefs is required at the end, settings configured in this file will override the defaults
