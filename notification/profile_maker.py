#!/usr/bin/env python3
"""
Visual quad-picker for text_profiles.json.

Click 4 points on the image, in order: top-left, top-right, bottom-right,
bottom-left of the area you want text projected onto. Right-click to undo
the last point. Once 4 points are placed, press Enter to save, Escape to
cancel.
"""
import json
import sys
from pathlib import Path

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GdkPixbuf", "2.0")
from gi.repository import Gdk, GdkPixbuf, Gtk

SCRIPT_DIR = Path(__file__).resolve().parent
PROFILES_PATH = SCRIPT_DIR / "text_profiles.json"

POINT_LABELS = ["top-left", "top-right", "bottom-right", "bottom-left"]


def load_profiles():
    if PROFILES_PATH.exists():
        with open(PROFILES_PATH) as f:
            return json.load(f)
    return {}


def save_profiles(profiles):
    with open(PROFILES_PATH, "w") as f:
        json.dump(profiles, f, indent=2)
        f.write("\n")


class PickerWindow(Gtk.Window):
    def __init__(self, profile_name, image_path):
        super().__init__(title=f"profile_maker: {profile_name} - click 4 corners (TL, TR, BR, BL)")
        self.profile_name = profile_name
        self.image_path = image_path

        self.pixbuf = GdkPixbuf.Pixbuf.new_from_file(str(image_path))
        self.img_w = self.pixbuf.get_width()
        self.img_h = self.pixbuf.get_height()

        # Scale down for display only if the image is bigger than a comfy
        # window size; clicks get converted back to true image pixels.
        max_display = 900
        self.scale = min(1.0, max_display / max(self.img_w, self.img_h))
        self.disp_w = round(self.img_w * self.scale)
        self.disp_h = round(self.img_h * self.scale)

        self.points = []  # in true image pixel coordinates

        self.area = Gtk.DrawingArea()
        self.area.set_size_request(self.disp_w, self.disp_h)
        self.area.connect("draw", self.on_draw)
        self.area.add_events(Gdk.EventMask.BUTTON_PRESS_MASK)
        self.area.connect("button-press-event", self.on_click)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.status = Gtk.Label(label=self.status_text())
        box.pack_start(self.status, False, False, 4)
        box.pack_start(self.area, True, True, 0)
        self.add(box)

        self.connect("key-press-event", self.on_key)
        self.connect("destroy", Gtk.main_quit)

    def status_text(self):
        if len(self.points) < 4:
            return f"Click point {len(self.points) + 1}/4: {POINT_LABELS[len(self.points)]}  (right-click = undo)"
        return "4 points placed. Press Enter to save, Escape to cancel, right-click to undo."

    def on_click(self, widget, event):
        if event.button == 1 and len(self.points) < 4:
            # Convert display coords -> true image pixel coords
            x = round(event.x / self.scale)
            y = round(event.y / self.scale)
            self.points.append((x, y))
        elif event.button == 3 and self.points:
            self.points.pop()
        self.status.set_text(self.status_text())
        self.area.queue_draw()

    def on_key(self, widget, event):
        keyval = event.keyval
        if keyval == Gdk.KEY_Return and len(self.points) == 4:
            self.save_and_quit()
        elif keyval == Gdk.KEY_Escape:
            print("cancelled, nothing saved", file=sys.stderr)
            Gtk.main_quit()

    def on_draw(self, widget, cr):
        cr.scale(self.scale, self.scale)
        Gdk.cairo_set_source_pixbuf(cr, self.pixbuf, 0, 0)
        cr.paint()

        cr.set_line_width(2.0 / self.scale)
        for i, (x, y) in enumerate(self.points):
            cr.set_source_rgb(1, 0.1, 0.1)
            cr.arc(x, y, 6.0 / self.scale, 0, 2 * 3.14159)
            cr.fill()
            cr.set_source_rgb(1, 1, 1)
            cr.move_to(x + 8.0 / self.scale, y - 8.0 / self.scale)
            cr.show_text(f"{i + 1}:{POINT_LABELS[i]}")

        if len(self.points) > 1:
            cr.set_source_rgba(0.1, 0.8, 1.0, 0.9)
            cr.move_to(*self.points[0])
            for p in self.points[1:]:
                cr.line_to(*p)
            if len(self.points) == 4:
                cr.close_path()
            cr.stroke()

    def save_and_quit(self):
        profiles = load_profiles()
        existing = profiles.get(self.profile_name, {})

        dst = []
        for x, y in self.points:
            dst.extend([x, y])

        xs = [p[0] for p in self.points]
        ys = [p[1] for p in self.points]
        bbox_w = max(xs) - min(xs)
        bbox_h = max(ys) - min(ys)

        profiles[self.profile_name] = {
            "image": self.image_path.name,
            "canvas_width": self.img_w,
            "canvas_height": self.img_h,
            "src_width": existing.get("src_width", max(bbox_w, 40)),
            "src_height": existing.get("src_height", max(bbox_h, 40)),
            "dst": dst,
            "font": existing.get("font", "DejaVu-Sans-Bold"),
            "color": existing.get("color", "white"),
        }
        save_profiles(profiles)
        print(f"saved profile '{self.profile_name}' -> {PROFILES_PATH}")
        Gtk.main_quit()


def main():
    if len(sys.argv) != 3:
        print("usage: profile_maker.py <profile_name> <image_filename>", file=sys.stderr)
        sys.exit(1)

    profile_name = sys.argv[1]
    image_path = SCRIPT_DIR / sys.argv[2]
    if not image_path.exists():
        print(f"error: image not found: {image_path}", file=sys.stderr)
        sys.exit(1)

    win = PickerWindow(profile_name, image_path)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
