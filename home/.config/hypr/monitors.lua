-- █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█ █▀
-- █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄ ▄█

-- Set your monitor configuration here
-- See https://wiki.hypr.land/configuring/core/monitors/

-- laptop
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
    transform = 0,
})

-- desktop
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
    transform = 0,
})
hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@144",
    position = "3840x-700",
    scale    = "1",
    transform = 1,
})
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@144",
    position = "1920x0",
    scale    = "1",
    transform = 0,
})
