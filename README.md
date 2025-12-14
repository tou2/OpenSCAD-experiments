# OpenSCAD Bag Experiment

This repository contains OpenSCAD experiments. Current generators:

- `bag.scad` — soft-sided bag with tunable dimensions and pockets.
- `cat.scad` — stylized parametric cat with adjustable body, head, tail, ears, and legs.
- `shackle.scad` — D/bow shackle with adjustable bow thickness, gap, and pin.
 - `cube.scad` — simple parametric cube with optional chamfer or fillet.
 - `sphere.scad` — sphere with radius and optional centering.
 - `cylinder.scad` — cylinder with radius/height and centering.
 - `cone.scad` — cone/frustum with `r1`, `r2`, height.
 - `torus.scad` — torus via rotate_extrude with major/minor radii.
 - `pyramid.scad` — square-base pyramid with base size and height.
 - `prism.scad` — right triangular prism with base and height.
 - `text_plate.scad` — make a rectangular plaque with embossed/engraved text.

## Quick start
1. Open any `.scad` in OpenSCAD (e.g., `cube.scad`, `sphere.scad`, `cylinder.scad`, `cone.scad`, `torus.scad`, `pyramid.scad`, `prism.scad`).
2. Tweak the variables in the **User parameters** section.
3. Press F5 to preview, F6 to render.

## Text Plate (`text_plate.scad`)
- `message`, `font`, `size`: Text content, font, and size.
- `plate_width`, `plate_height`: Set explicit size; leave `0` for auto estimate.
- `margin`, `corner_radius`: Plate padding and rounded corners.
- `plate_thickness`, `text_depth`, `text_mode`: Base thickness, emboss/engrave depth, and mode.
- `plate_shape`: Shape of the plate: `"rectangle"`, `"circle"`, `"ellipse"`, or `"rounded_rect"`.
- `halign`, `valign`: Text alignment within the plate.
- `language`, `script`, `direction`: International text shaping. For Arabic, use `language = "ar"`, `script = "arabic"`, `direction = "rtl"`, and pick a font that supports Arabic (e.g., `"Noto Naskh Arabic"`, `"Amiri"`, `"Scheherazade"`).Example (Arabic):

```
message = "مرحبا";
font = "Noto Naskh Arabic";
language = "ar";
script = "arabic";
direction = "rtl";
halign = "center"; // or "right" for right-aligned text
text_mode = "emboss";
```

## Bag key parameters (`bag.scad`)
- `bag_width`, `bag_height`, `bag_depth`: Overall body dimensions.
- `wall_thickness`, `corner_radius`: Shell thickness and edge rounding.
- `outside_pocket_*`: Count, size, spacing, and height for exterior pockets on the front face.
- `inside_pocket_*`: Count and size for interior pockets against the front inner wall.
- `tab_*`: Small carry loops on the front edge near the top.

## Cat key parameters (`cat.scad`)
- `body_length`, `body_width`, `body_height`, `body_roundness`: Core torso shape.
- `head_*`, `ear_*`: Head dimensions, tilt, and ear size/spread.
- `leg_radius`, `leg_height`, `leg_spread_*`, `leg_taper`: Leg size and stance width.
- `tail_length`, `tail_radius`, `tail_lift`, `tail_curl`, `tail_side_offset`: Tail length, thickness, lift, curl, and side offset.
- `nose_radius`, `eye_radius`: Small facial details.

## Shackle key parameters (`shackle.scad`)
- `bow_radius`: Tube thickness of the U-shaped body.
- `throat_width`, `leg_height`: Gap between legs and height to pin centerline.
- `pin_diameter`, `pin_clearance`: Pin size and fit allowance.
- `pin_head_*`, `pin_nut_*`, `pin_eye_diameter`: Head, nut, and through-hole sizing.

## Cube key parameters (`cube.scad`)
- `size_x`, `size_y`, `size_z`: Cube dimensions.
- `center_cube`: Center the cube at the origin.
- `edge_style`: `none`, `chamfer`, or `fillet`.
- `edge_amount`: Chamfer size or fillet radius.

## How the bag is built
- The body uses a rounded rectangular prism shell, hollowed with a thickness offset.
- Pockets are small hollow prisms attached to the front (outside) and inner face (inside).
- Tabs are simple rectangular loops you can swap for strap anchors.

## Ideas to extend
- Add a top flap or zipper lip using another rounded prism.
- Parameterize pocket placement per face (front/back/sides).
- Add shoulder straps or buckles using cylinders and difference cuts.
