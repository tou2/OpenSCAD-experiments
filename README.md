# OpenSCAD Bag Experiment

This repository contains OpenSCAD experiments. Current generators:

- `bag.scad` — soft-sided bag with tunable dimensions and pockets.
- `cat.scad` — stylized parametric cat with adjustable body, head, tail, ears, and legs.

## Quick start
1. Open `bag.scad` or `cat.scad` in OpenSCAD.
2. Tweak the variables in the **User parameters** section.
3. Press F5 to preview, F6 to render.

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

## How the bag is built
- The body uses a rounded rectangular prism shell, hollowed with a thickness offset.
- Pockets are small hollow prisms attached to the front (outside) and inner face (inside).
- Tabs are simple rectangular loops you can swap for strap anchors.

## Ideas to extend
- Add a top flap or zipper lip using another rounded prism.
- Parameterize pocket placement per face (front/back/sides).
- Add shoulder straps or buckles using cylinders and difference cuts.
