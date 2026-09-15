-- █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
-- ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

-- See https://wiki.hypr.land/configuring/core/rules/

hl.window_rule({ match = { class = "waybar" }, no_blur = true })
hl.window_rule({ match = { class = "firefox" }, opacity = "0.96 override 0.90 override" })
hl.window_rule({ match = { class = "brave-browser" }, opacity = "0.96 override 0.90 override" })
hl.window_rule({ match = { class = "code-oss" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "Code" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "code-url-handler" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "code-insiders-url-handler" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "kitty" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.kde.dolphin" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.kde.ark" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "nwg-look" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "qt5ct" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "qt6ct" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "kvantummanager" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "blueman-manager" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "nm-applet" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "nm-connection-editor" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.kde.polkit-kde-authentication-agent-1" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "polkit-gnome-authentication-agent-1" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.freedesktop.impl.portal.desktop.gtk" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.freedesktop.impl.portal.desktop.hyprland" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "[Ss]team" }, opacity = "0.98 override 0.90 override" })
hl.window_rule({ match = { class = "spotify" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "org.godotengine.Editor" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "Godot" }, opacity = "0.96 override 0.80 override" })
hl.window_rule({ match = { class = "witch hat atelier" }, float = true, center = true, monitor = "DP-1" })

hl.window_rule({ match = { class = "com.github.rafostar.Clapper" }, opacity = "0.96 override 0.80 override" }) -- Clapper-Gtk
hl.window_rule({ match = { class = "com.github.tchx84.Flatseal" }, opacity = "0.96 override 0.80 override" }) -- Flatseal-Gtk
hl.window_rule({ match = { class = "hu.kramo.Cartridges" }, opacity = "0.96 override 0.80 override" }) -- Cartridges-Gtk
hl.window_rule({ match = { class = "com.obsproject.Studio" }, opacity = "0.96 override 0.80 override" }) -- Obs-Qt
hl.window_rule({ match = { class = "gnome-boxes" }, opacity = "0.96 override 0.80 override" }) -- Boxes-Gtk
hl.window_rule({ match = { class = "discord" }, opacity = "0.96 override 0.80 override" }) -- Discord-Electron
hl.window_rule({ match = { class = "vesktop" }, opacity = "0.96 override 0.80 override" }) -- Vencord-Electron
hl.window_rule({ match = { class = "WebCord" }, opacity = "0.96 override 0.80 override" }) -- WebCord-Electron
hl.window_rule({ match = { class = "ArmCord" }, opacity = "0.96 override 0.80 override" }) -- ArmCord-Electron
hl.window_rule({ match = { class = "app.drey.Warp" }, opacity = "0.96 override 0.80 override" }) -- Warp-Gtk
hl.window_rule({ match = { class = "net.davidotek.pupgui2" }, opacity = "0.96 override 0.80 override" }) -- ProtonUp-Qt
hl.window_rule({ match = { class = "yad" }, opacity = "0.96 override 0.80 override" }) -- Protontricks-Gtk
hl.window_rule({ match = { class = "Signal" }, opacity = "0.96 override 0.80 override" }) -- Signal-Gtk
hl.window_rule({ match = { class = "io.github.alainm23.planify" }, opacity = "0.96 override 0.80 override" }) -- planify-Gtk
hl.window_rule({ match = { class = "io.gitlab.theevilskeleton.Upscaler" }, opacity = "0.96 override 0.80 override" }) -- Upscaler-Gtk
hl.window_rule({ match = { class = "com.github.unrud.VideoDownloader" }, opacity = "0.96 override 0.80 override" }) -- VideoDownloader-Gtk
hl.window_rule({ match = { class = "io.gitlab.adhami3310.Impression" }, opacity = "0.96 override 0.80 override" }) -- Impression-Gtk
hl.window_rule({ match = { class = "io.missioncenter.MissionCenter" }, opacity = "0.96 override 0.80 override" }) -- MissionCenter-Gtk
hl.window_rule({ match = { class = "io.github.flattool.Warehouse" }, opacity = "0.96 override 0.80 override" }) -- Warehouse-Gtk
hl.window_rule({ match = { class = "obsidian" }, opacity = "0.96 override 0.80 override" }) -- Warehouse-Gtk

hl.window_rule({ match = { class = "org.kde.dolphin", title = "Progress Dialog — Dolphin" }, float = true })
hl.window_rule({ match = { class = "org.kde.dolphin", title = "Copying — Dolphin" }, float = true })
hl.window_rule({ match = { class = "firefox", title = "Picture-in-Picture" }, float = true })
hl.window_rule({ match = { class = "firefox", title = "Library" }, float = true })
hl.window_rule({ match = { class = "kitty", title = "top" }, float = true })
hl.window_rule({ match = { class = "kitty", title = "btop" }, float = true })
hl.window_rule({ match = { class = "kitty", title = "htop" }, float = true })
hl.window_rule({ match = { class = "vlc" }, float = true })
hl.window_rule({ match = { class = "kvantummanager" }, float = true })
hl.window_rule({ match = { class = "qt5ct" }, float = true })
hl.window_rule({ match = { class = "qt6ct" }, float = true })
hl.window_rule({ match = { class = "nwg-look" }, float = true })
hl.window_rule({ match = { class = "org.kde.ark" }, float = true })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "nm-applet" }, float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { class = "org.kde.polkit-kde-authentication-agent-1" }, float = true })

hl.window_rule({ match = { class = "Signal" }, float = true }) -- Signal-Gtk
hl.window_rule({ match = { class = "com.github.rafostar.Clapper" }, float = true }) -- Clapper-Gtk
hl.window_rule({ match = { class = "app.drey.Warp" }, float = true }) -- Warp-Gtk
hl.window_rule({ match = { class = "net.davidotek.pupgui2" }, float = true }) -- ProtonUp-Qt
hl.window_rule({ match = { class = "yad" }, float = true }) -- Protontricks-Gtk
hl.window_rule({ match = { class = "eog" }, float = true }) -- Imageviewer-Gtk
hl.window_rule({ match = { class = "io.github.alainm23.planify" }, float = true }) -- planify-Gtk
hl.window_rule({ match = { class = "io.gitlab.theevilskeleton.Upscaler" }, float = true }) -- Upscaler-Gtk
hl.window_rule({ match = { class = "com.github.unrud.VideoDownloader" }, float = true }) -- VideoDownloader-Gtk
hl.window_rule({ match = { class = "io.gitlab.adhami3310.Impression" }, float = true }) -- Impression-Gtk
hl.window_rule({ match = { class = "io.missioncenter.MissionCenter" }, float = true }) -- MissionCenter-Gtk

hl.window_rule({ match = { class = "steam", title = "negative:^steam$" }, float = true, center = true })


-- █░░ ▄▀█ █▄█ █▀▀ █▀█   █▀█ █░█ █░░ █▀▀ █▀
-- █▄▄ █▀█ ░█░ ██▄ █▀▄   █▀▄ █▄█ █▄▄ ██▄ ▄█

hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })


hl.workspace_rule({ workspace = "w[tv1-10]", gaps_out = 7, gaps_in = 3 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 7, gaps_in = 2 })
