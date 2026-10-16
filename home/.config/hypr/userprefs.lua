-- █░█ █▀ █▀▀ █▀█   █▀█ █▀█ █▀▀ █▀▀ █▀
-- █▄█ ▄█ ██▄ █▀▄   █▀▀ █▀▄ ██▄ █▀░ ▄█

hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("kded6")
end)

-- white active window border (overrides wallbash colors.lua)
hl.config({
    general = {
        col = {
            active_border = { colors = { "rgba(ffffffff)", "rgba(ffffffff)" }, angle = 45 },
        },
    },
})
