#!/usr/bin/env python3
"""
Visual quad-picker for text_profiles.json.

Two phases:
  1. QUAD: click 4 points, in order: top-left, top-right, bottom-right,
     bottom-left of the area you want text projected onto.
  2. OCCLUSION (optional): click points to trace around anything that should
     stay visible IN FRONT of the projected text (e.g. fingers holding the
     book). Press 'n' to finish the current shape and start a new one if you
     need more than one (e.g. two hands). This phase starts automatically
     once the quad has 4 points.

Controls:
  scroll wheel   - zoom in/out, centered on the cursor
  middle-drag    - pan around
  left-click     - place a point (quad, then occlusion once quad is done)
  right-click    - undo the last point (current occlusion shape, then quad)
  n              - finish current occlusion shape, start a new one
  Enter          - save (quad + any occlusion shapes)
  Escape         - cancel without saving
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

MIN_ZOOM = 0.05
MAX_ZOOM = 40.0
ZOOM_STEP = 1.15


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

        self.points = []  # quad corners, in true image pixel coordinates
        self.occlusion_shapes = []  # list of completed polygons (each a list of (x,y))
        self.current_shape = []  # polygon currently being placed

        view_w, view_h = 1000, 750
        # Fit the whole image in the initial view (can upscale small images
        # so they're not tiny/hard to click on).
        self.zoom = min(view_w / self.img_w, view_h / self.img_h)
        self.pan_x = 0.0
        self.pan_y = 0.0

        self.dragging = False
        self.drag_start = (0, 0)
        self.drag_start_pan = (0.0, 0.0)

        self.area = Gtk.DrawingArea()
        self.area.set_size_request(view_w, view_h)
        self.area.connect("draw", self.on_draw)
        self.area.add_events(
            Gdk.EventMask.BUTTON_PRESS_MASK
            | Gdk.EventMask.BUTTON_RELEASE_MASK
            | Gdk.EventMask.POINTER_MOTION_MASK
            | Gdk.EventMask.SCROLL_MASK
        )
        self.area.connect("button-press-event", self.on_button_press)
        self.area.connect("button-release-event", self.on_button_release)
        self.area.connect("motion-notify-event", self.on_motion)
        self.area.connect("scroll-event", self.on_scroll)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.status = Gtk.Label(label=self.status_text())
        box.pack_start(self.status, False, False, 4)
        box.pack_start(self.area, True, True, 0)
        self.add(box)

        self.connect("key-press-event", self.on_key)
        self.connect("destroy", Gtk.main_quit)

    @property
    def quad_done(self):
        return len(self.points) >= 4

    def status_text(self):
        zoom_pct = f"{self.zoom * 100:.0f}%"
        if not self.quad_done:
            action = f"QUAD: click point {len(self.points) + 1}/4: {POINT_LABELS[len(self.points)]}"
        else:
            n_shapes = len(self.occlusion_shapes) + (1 if self.current_shape else 0)
            action = (
                f"OCCLUSION ({len(self.current_shape)} pts in current shape, "
                f"{len(self.occlusion_shapes)} shape(s) done): click to trace things "
                f"that should stay in front (e.g. fingers). 'n' = new shape. "
                f"Enter = save, Escape = cancel."
            )
        return f"{action}   |   zoom {zoom_pct} (scroll=zoom, middle-drag=pan, right-click=undo)"

    def widget_to_image(self, x, y):
        return (x / self.zoom + self.pan_x, y / self.zoom + self.pan_y)

    def on_button_press(self, widget, event):
        if event.button == 1:
            x, y = self.widget_to_image(event.x, event.y)
            point = (round(x), round(y))
            if not self.quad_done:
                self.points.append(point)
            else:
                self.current_shape.append(point)
        elif event.button == 3:
            if self.current_shape:
                self.current_shape.pop()
            elif self.occlusion_shapes:
                self.current_shape = self.occlusion_shapes.pop()
            elif self.points:
                self.points.pop()
        elif event.button == 2:
            self.dragging = True
            self.drag_start = (event.x, event.y)
            self.drag_start_pan = (self.pan_x, self.pan_y)
        self.status.set_text(self.status_text())
        self.area.queue_draw()

    def on_button_release(self, widget, event):
        if event.button == 2:
            self.dragging = False

    def on_motion(self, widget, event):
        if self.dragging:
            dx = event.x - self.drag_start[0]
            dy = event.y - self.drag_start[1]
            self.pan_x = self.drag_start_pan[0] - dx / self.zoom
            self.pan_y = self.drag_start_pan[1] - dy / self.zoom
            self.area.queue_draw()

    def on_scroll(self, widget, event):
        # Zoom in/out, keeping the image point under the cursor fixed.
        img_x, img_y = self.widget_to_image(event.x, event.y)

        if event.direction == Gdk.ScrollDirection.UP:
            factor = ZOOM_STEP
        elif event.direction == Gdk.ScrollDirection.DOWN:
            factor = 1.0 / ZOOM_STEP
        else:
            return

        self.zoom = max(MIN_ZOOM, min(MAX_ZOOM, self.zoom * factor))
        self.pan_x = img_x - event.x / self.zoom
        self.pan_y = img_y - event.y / self.zoom

        self.status.set_text(self.status_text())
        self.area.queue_draw()

    def on_key(self, widget, event):
        keyval = event.keyval
        if keyval == Gdk.KEY_Return and self.quad_done:
            self.save_and_quit()
        elif keyval == Gdk.KEY_Escape:
            print("cancelled, nothing saved", file=sys.stderr)
            Gtk.main_quit()
        elif self.quad_done and keyval in (Gdk.KEY_n, Gdk.KEY_N):
            if len(self.current_shape) >= 3:
                self.occlusion_shapes.append(self.current_shape)
                self.current_shape = []
            self.status.set_text(self.status_text())
            self.area.queue_draw()

    def on_draw(self, widget, cr):
        cr.save()
        cr.scale(self.zoom, self.zoom)
        cr.translate(-self.pan_x, -self.pan_y)

        Gdk.cairo_set_source_pixbuf(cr, self.pixbuf, 0, 0)
        cr.paint()

        cr.set_line_width(2.0 / self.zoom)
        for i, (x, y) in enumerate(self.points):
            cr.set_source_rgb(1, 0.1, 0.1)
            cr.arc(x, y, 6.0 / self.zoom, 0, 2 * 3.14159)
            cr.fill()
            cr.set_source_rgb(1, 1, 1)
            cr.move_to(x + 8.0 / self.zoom, y - 8.0 / self.zoom)
            cr.set_font_size(14.0 / self.zoom)
            cr.show_text(f"{i + 1}:{POINT_LABELS[i]}")

        if len(self.points) > 1:
            cr.set_source_rgba(0.1, 0.8, 1.0, 0.9)
            cr.move_to(*self.points[0])
            for p in self.points[1:]:
                cr.line_to(*p)
            if len(self.points) == 4:
                cr.close_path()
            cr.stroke()

        # Completed occlusion shapes: filled green, semi-transparent.
        for shape in self.occlusion_shapes:
            self._draw_polygon(cr, shape, close=True, fill=(0.1, 0.9, 0.2, 0.35), stroke=(0.1, 0.9, 0.2, 0.9))

        # Shape currently being placed: outline only, not closed yet.
        if self.current_shape:
            self._draw_polygon(cr, self.current_shape, close=False, fill=None, stroke=(1.0, 0.8, 0.0, 0.9))
            for x, y in self.current_shape:
                cr.set_source_rgb(1.0, 0.8, 0.0)
                cr.arc(x, y, 4.0 / self.zoom, 0, 2 * 3.14159)
                cr.fill()

        cr.restore()

    def _draw_polygon(self, cr, shape, close, fill, stroke):
        if len(shape) < 2:
            return
        cr.move_to(*shape[0])
        for p in shape[1:]:
            cr.line_to(*p)
        if close:
            cr.close_path()
        if fill:
            cr.set_source_rgba(*fill)
            cr.fill_preserve()
        cr.set_source_rgba(*stroke)
        cr.set_line_width(2.0 / self.zoom)
        cr.stroke()

    def save_and_quit(self):
        # Auto-close a shape that's still being placed, if it's big enough.
        if len(self.current_shape) >= 3:
            self.occlusion_shapes.append(self.current_shape)
            self.current_shape = []

        profiles = load_profiles()
        existing = profiles.get(self.profile_name, {})

        dst = []
        for x, y in self.points:
            dst.extend([x, y])

        xs = [p[0] for p in self.points]
        ys = [p[1] for p in self.points]
        bbox_w = max(xs) - min(xs)
        bbox_h = max(ys) - min(ys)

        occlusion = [[coord for point in shape for coord in point] for shape in self.occlusion_shapes]

        # Only reuse a previously fine-tuned src_width/src_height if this is
        # the same image as before (same canvas size). Otherwise stale values
        # from a different-sized image can exceed the new canvas and get
        # silently cropped instead of scaled - recompute fresh in that case.
        same_image = (
            existing.get("canvas_width") == self.img_w
            and existing.get("canvas_height") == self.img_h
        )

        profiles[self.profile_name] = {
            "image": self.image_path.name,
            "canvas_width": self.img_w,
            "canvas_height": self.img_h,
            "src_width": existing.get("src_width", max(bbox_w, 40)) if same_image else max(bbox_w, 40),
            "src_height": existing.get("src_height", max(bbox_h, 40)) if same_image else max(bbox_h, 40),
            "dst": dst,
            "occlusion_polygons": occlusion,
            "font": existing.get("font", "DejaVu-Sans-Bold"),
            "color": existing.get("color", "white"),
        }
        save_profiles(profiles)
        print(f"saved profile '{self.profile_name}' -> {PROFILES_PATH} ({len(occlusion)} occlusion shape(s))")
        Gtk.main_quit()


def main():
    if len(sys.argv) != 3:
        print("usage: profile_maker.py <profile_name> <image_filename>", file=sys.stderr)
        sys.exit(1)

    profile_name = sys.argv[1]
    image_path = SCRIPT_DIR / "baked" / sys.argv[2]
    if not image_path.exists():
        print(f"error: image not found: {image_path}", file=sys.stderr)
        sys.exit(1)

    win = PickerWindow(profile_name, image_path)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
