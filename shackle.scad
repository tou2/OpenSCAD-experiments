// D-shackle (bow shackle) generator for OpenSCAD
// Dimensions can be entered in inches (default here). OpenSCAD units are arbitrary.

/****************************
 * User parameters
 ****************************/
// Reference drawing dimensions (inches)
inch = 25.4;               // if you prefer mm, multiply outputs by this scale
A_bow_diameter = 0.50;     // Bow diameter (tube OD)
B_pin_diameter = 0.625;    // Pin diameter
C_inside_height = 1.88;    // Inside height (clear from pin center to crown inside)
D_jaw_opening = 0.81;      // Inside width at pin (gap between legs)
E_ear_width = 1.31;        // External overall width at pin region
H_inside_width = 1.25;     // Inside width near crown (label may vary)

// Build parameters derived from drawing
bow_radius = (A_bow_diameter/2) * inch;       // tube radius
pin_diameter = B_pin_diameter * inch;         // pin OD
throat_width = D_jaw_opening * inch;          // clear gap between inner leg faces
leg_outer_to_outer = E_ear_width * inch;      // overall width including leg thickness
leg_wall = (leg_outer_to_outer - throat_width) / 2; // leg wall thickness each side
leg_height = C_inside_height * inch;          // distance from pin axis to crown inside
bow_segments = 192;                           // smoothness
leg_end_cap_radius = bow_radius * 0.18;       // small fillet

// Pin (runs along Y between legs)
pin_clearance = 0.25 * inch; // subtract from available span to ensure fit
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
    // Crown arc using rotate_extrude for smooth curvature
    // We sweep a semicircle in the XZ plane to form the bulbous crown.
    crown_centerline = (H_inside_width/2) + bow_radius; // crown centerline radius
    rotate([0,90,0]) // orient profile for rotate_extrude around Z
    rotate_extrude(angle=180, $fn=bow_segments)
        translate([crown_centerline, 0, 0]) circle(r=bow_radius, $fn=64);

    // Legs: vertical tubes from crown ends down to pin axis (leg_height)
    for (side=[-1,1]) {
        x_leg_center = side * (throat_width/2 + bow_radius);
        // leg tube
        translate([x_leg_center, 0, 0])
            cylinder(h=leg_height, r=bow_radius, center=false);
        // flatten inner face slightly to resemble forged leg faces
        translate([x_leg_center - side*bow_radius*0.3, 0, 0])
            cube([bow_radius*0.6, leg_outer_to_outer, leg_height], center=false);
        // soft cap
        translate([x_leg_center, 0, leg_height]) sphere(r=leg_end_cap_radius);
    }
}

module pin() {
    span = throat_width + 2*leg_wall; // overall outer-to-outer minus walls matches E width
    // Pin runs along Y, centered at x=0,z=0
    union() {
        rotate([90,0,0]) cylinder(h=span, r=pin_diameter/2, center=true);
        // Head at negative Y leg face (rounded cap)
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
    for (side=[-1,1]) {
        x_leg_center = side * (throat_width/2 + bow_radius);
        translate([x_leg_center, 0, leg_height])
            rotate([90,0,0]) cylinder(h=leg_outer_to_outer, r=pin_diameter/2 + pin_clearance/2, center=true);
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
