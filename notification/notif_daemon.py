#!/usr/bin/env python3
"""
A minimal org.freedesktop.Notifications daemon that replaces swaync's popup
role. Every incoming notification's summary+body gets perspective-projected
onto a randomly chosen character image profile (see text_profiles.json /
project_text.sh), and the resulting composited image IS the popup - no
separate icon/text drawn by the daemon itself.

Run this instead of swaync. Only one process can own the notifications bus
name at a time, so make sure swaync (or any other notification daemon) isn't
running first.
"""
import random
import re
import subprocess
import sys
import tempfile
from pathlib import Path

import dbus
import dbus.mainloop.glib
import dbus.service
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GdkPixbuf", "2.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gdk, GdkPixbuf, GLib, Gtk, GtkLayerShell

import json

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_TEXT = SCRIPT_DIR / "project_text.sh"
PROFILES_PATH = SCRIPT_DIR / "text_profiles.json"

BUS_NAME = "org.freedesktop.Notifications"
OBJECT_PATH = "/org/freedesktop/Notifications"

DEFAULT_TIMEOUT_MS = 8000
STACK_GAP = 12
STACK_MARGIN_TOP = 0
STACK_MARGIN_RIGHT = 0

TAG_RE = re.compile(r"<[^>]+>")


def strip_markup(text):
    return TAG_RE.sub("", text or "").strip()


def load_profile_names():
    with open(PROFILES_PATH) as f:
        return list(json.load(f).keys())


class Popup:
    """One on-screen notification window."""

    def __init__(self, notif_id, image_path, on_closed):
        self.notif_id = notif_id
        self.on_closed = on_closed
        self._timeout_source = None

        pixbuf = GdkPixbuf.Pixbuf.new_from_file(str(image_path))
        self.width = pixbuf.get_width()
        self.height = pixbuf.get_height()

        self.window = Gtk.Window(type=Gtk.WindowType.TOPLEVEL)
        self.window.set_decorated(False)
        self.window.set_resizable(False)
        self.window.set_default_size(self.width, self.height)

        screen = self.window.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.window.set_visual(visual)
        self.window.set_app_paintable(True)

        css = Gtk.CssProvider()
        css.load_from_data(b"window { background-color: transparent; }")
        Gtk.StyleContext.add_provider_for_screen(
            screen, css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        image = Gtk.Image.new_from_pixbuf(pixbuf)
        self.window.add(image)

        GtkLayerShell.init_for_window(self.window)
        GtkLayerShell.set_layer(self.window, GtkLayerShell.Layer.OVERLAY)
        # Ignore other layers' reserved space (e.g. waybar) so this always
        # sits flush against the true screen edge, not pushed below the bar.
        GtkLayerShell.set_exclusive_zone(self.window, -1)
        GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self.window, GtkLayerShell.Edge.TOP, STACK_MARGIN_TOP)
        GtkLayerShell.set_margin(self.window, GtkLayerShell.Edge.RIGHT, STACK_MARGIN_RIGHT)

        self.window.connect("button-press-event", lambda *_: self.close("dismissed"))

    def show(self):
        self.window.show_all()

    def set_top_margin(self, top):
        GtkLayerShell.set_margin(self.window, GtkLayerShell.Edge.TOP, top)

    def schedule_timeout(self, ms):
        self._timeout_source = GLib.timeout_add(ms, self._on_timeout)

    def _on_timeout(self):
        self._timeout_source = None
        self.close("expired")
        return False

    def close(self, reason):
        if self._timeout_source is not None:
            GLib.source_remove(self._timeout_source)
            self._timeout_source = None
        self.window.destroy()
        self.on_closed(self.notif_id, reason)


class NotifDaemon(dbus.service.Object):
    REASON_EXPIRED = 1
    REASON_DISMISSED = 2
    REASON_CLOSED_BY_CALL = 3

    def __init__(self, bus):
        super().__init__(bus, OBJECT_PATH)
        self._next_id = 1
        self._popups = {}  # id -> Popup, in stacking order (dict preserves insertion order)

    def _next_notif_id(self):
        nid = self._next_id
        self._next_id += 1
        return nid

    def _reflow(self):
        top = STACK_MARGIN_TOP
        for popup in self._popups.values():
            popup.set_top_margin(top)
            top += popup.height + STACK_GAP

    def _remove_popup(self, notif_id, reason_word):
        self._popups.pop(notif_id, None)
        self._reflow()
        reason_code = {
            "expired": self.REASON_EXPIRED,
            "dismissed": self.REASON_DISMISSED,
            "closed": self.REASON_CLOSED_BY_CALL,
        }.get(reason_word, self.REASON_EXPIRED)
        self.NotificationClosed(notif_id, reason_code)

    @dbus.service.method(
        BUS_NAME,
        in_signature="susssasa{sv}i",
        out_signature="u",
    )
    def Notify(
        self,
        app_name,
        replaces_id,
        app_icon,
        summary,
        body,
        actions,
        hints,
        expire_timeout,
    ):
        summary = strip_markup(str(summary))
        body = strip_markup(str(body))
        text = f"{summary}\n{body}".strip() if body else summary

        profiles = load_profile_names()
        profile = random.choice(profiles)

        notif_id = int(replaces_id) if replaces_id else self._next_notif_id()

        out_fd, out_path = tempfile.mkstemp(prefix="notif_", suffix=".png")
        import os

        os.close(out_fd)

        try:
            subprocess.run(
                [str(PROJECT_TEXT), profile, text, out_path],
                check=True,
                capture_output=True,
                text=True,
            )
        except subprocess.CalledProcessError as e:
            print(f"project_text.sh failed: {e.stderr}", file=sys.stderr)
            return notif_id

        # Only one notification shown at a time - a new one replaces
        # whatever's currently showing instead of stacking underneath it.
        for existing_id in list(self._popups.keys()):
            self._popups[existing_id].close("closed")

        popup = Popup(notif_id, out_path, on_closed=self._remove_popup)
        self._popups[notif_id] = popup
        popup.show()
        self._reflow()

        timeout_ms = expire_timeout if expire_timeout and expire_timeout > 0 else DEFAULT_TIMEOUT_MS
        popup.schedule_timeout(timeout_ms)

        return notif_id

    @dbus.service.method(BUS_NAME, in_signature="u")
    def CloseNotification(self, notif_id):
        popup = self._popups.get(int(notif_id))
        if popup:
            popup.close("closed")

    @dbus.service.method(BUS_NAME, out_signature="as")
    def GetCapabilities(self):
        return ["body"]

    @dbus.service.method(BUS_NAME, out_signature="ssss")
    def GetServerInformation(self):
        return ("character-notif-daemon", "dotfiles", "0.1", "1.2")

    @dbus.service.signal(BUS_NAME, signature="uu")
    def NotificationClosed(self, notif_id, reason):
        pass

    @dbus.service.signal(BUS_NAME, signature="us")
    def ActionInvoked(self, notif_id, action_key):
        pass


def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()

    try:
        bus_name = dbus.service.BusName(BUS_NAME, bus=bus, do_not_queue=True)
    except dbus.exceptions.NameExistsException:
        print(
            f"error: {BUS_NAME} is already owned by another process "
            "(is swaync/dunst/another daemon still running?)",
            file=sys.stderr,
        )
        sys.exit(1)

    NotifDaemon(bus_name)
    print("notif_daemon running")
    Gtk.main()


if __name__ == "__main__":
    main()
