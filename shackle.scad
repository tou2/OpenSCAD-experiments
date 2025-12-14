// D-shackle (bow shackle) generator for OpenSCAD
// Adjust parameters in the User section to match your reference hardware.

/****************************
 * User parameters
 ****************************/
// Bow (the U-shaped body)
bow_radius = 8;            // tube radius (thickness of the shackle body)
throat_width = 24;         // clear gap between inner faces of the legs
leg_height = 28;           // distance from bottom curve to pin centerline
bow_segments = 64;         // smoothness for the sweep path
leg_end_cap_radius = 1.6;  // small fillet at leg ends

// Pin (runs along Y between legs)
pin_diameter = 10;
pin_clearance = 0.6;       // subtract from available span to ensure fit
pin_head_diameter = 16;
pin_head_thickness = 5;
pin_nut_diameter = 14;
pin_nut_thickness = 5;
pin_eye_diameter = 5;      // through-hole on nut side

$fn = 72;

/****************************
 * Helpers
 ****************************/
function vlen(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);

module capsule(p1=[0,0,0], p2=[0,0,10], r=2) {
    v = [p2[0]-p1[0], p2[1]-p1[1], p2[2]-p1[2]];
    len = vlen(v);
    axis = len == 0 ? [0,0,1] : cross([0,0,1], v);
    angle = len == 0 ? 0 : acos(v[2]/len) * 180 / PI;
    translate(p1) {
        if (len > 0) {
            rotate(a=angle, v=axis)
                cylinder(h=len, r=r, center=false);
        }
        sphere(r=r);
    }
    translate(p2) sphere(r=r);
}

module sweep_path(points=[], r=2) {
    for (i=[0:len(points)-2])
        capsule(points[i], points[i+1], r);
}

/****************************
 * Components
 ****************************/
module bow_body() {
    // Path in XZ plane; legs at x = +-throat_width/2
    r = throat_width/2;
    path = concat([
        [-r, 0, leg_height],
        [-r, 0, 0]
    ], [ for (a=[180:-180/bow_segments:0]) [ r*cos(a), 0, r*sin(a) ] ], [
        [ r, 0, 0],
        [ r, 0, leg_height]
    ]);
    sweep_path(path, bow_radius);
    // Soft end caps at leg tips to avoid sharp cuts
    translate([-r, 0, leg_height]) sphere(r=leg_end_cap_radius);
    translate([ r, 0, leg_height]) sphere(r=leg_end_cap_radius);
}

module pin() {
    span = throat_width + 2*bow_radius - pin_clearance;
    // Pin runs along Y, centered at x=0,z=0
    union() {
        rotate([90,0,0]) cylinder(h=span, r=pin_diameter/2, center=true);
        // Head at negative Y leg face
        translate([0, -span/2 - pin_head_thickness/2, 0])
            rotate([90,0,0]) cylinder(h=pin_head_thickness, r=pin_head_diameter/2, center=true);
        // Nut at positive Y leg face with eye hole
        translate([0,  span/2 + pin_nut_thickness/2, 0])
            difference() {
                rotate([90,0,0]) cylinder(h=pin_nut_thickness, r=pin_nut_diameter/2, center=true);
                // Eye hole drilled across nut (X direction)
                rotate([0,90,0]) cylinder(h=pin_nut_diameter, r=pin_eye_diameter/2, center=true);
            }
    }
}

module leg_holes() {
    // Drill holes in bow legs for pin clearance (along Y)
    r = throat_width/2;
    for (side=[-1,1]) {
        translate([side*r, 0, leg_height])
            rotate([90,0,0]) cylinder(h=throat_width + 2*bow_radius, r=pin_diameter/2 + pin_clearance/2, center=true);
    }
}

/****************************
 * Assembly
 ****************************/
module shackle_model() {
    // Subtract leg holes from bow, then place pin at leg height
    difference() {
        bow_body();
        leg_holes();
    }
    translate([0,0,leg_height]) pin();
}

// Render
shackle_model();
