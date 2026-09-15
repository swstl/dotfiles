hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Wallbash-Gtk'")
hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

hl.config({
    general = {
        col = {
            active_border = { colors = { "rgba(B39A89ff)", "rgba(523929ff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(1D202Bff)", "rgba(2E5C69ff)" }, angle = 45 },
        },
    },

    group = {
        col = {
            border_active = { colors = { "rgba(B39A89ff)", "rgba(523929ff)" }, angle = 45 },
            border_inactive = { colors = { "rgba(1D202Bcc)", "rgba(2E5C69cc)" }, angle = 45 },
            border_locked_active = { colors = { "rgba(111111ff)", "rgba(0F1010ff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(FFFFFFcc)", "rgba(FFFFFFcc)" }, angle = 45 },
        },
    },
})
