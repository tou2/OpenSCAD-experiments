// Parametric cat generator for OpenSCAD
// Adjust the variables in the "User parameters" block to explore shapes.

/****************************
 * User parameters
 ****************************/
// Body
body_length = 140;    // X axis (nose to tail root)
body_width  = 60;     // Y axis (side to side)
body_height = 70;     // Z axis (belly to back)
body_roundness = 0.35; // 0..0.6: how domed the back is

// Head
head_width  = 45;
head_depth  = 40;
head_height = 40;
head_tilt   = 6;      // degrees, nose up/down
head_offset = [body_length * 0.45, 0, body_height * 0.6];

// Ears
ear_base    = 14;
ear_height  = 18;
ear_spread  = 18;  // separation along Y

// Legs
leg_radius  = 10;
leg_height  = 40;
leg_spread_x = body_length * 0.25;
leg_spread_y = body_width * 0.35;
leg_taper   = 0.85;  // 1 = straight, <1 tapers at the foot

// Tail
tail_length = 120;
tail_radius = 6;
tail_lift   = 50;     // how much the tail rises above the root
tail_curl   = 30;     // extra upward curl
// sideways offset; negative values place the tail slightly to the left side
// (Y axis), mimicking a natural stance.
tail_side_offset = -body_width * 0.2;

// Detail
nose_radius = 3.5;
eye_radius  = 3;

$fn = 72;

/****************************
 * Helpers
 ****************************/
module ellipsoid(sx=40, sy=20, sz=30) {
    scale([sx, sy, sz]) sphere(1);
}

module tapered_leg(h=40, r=10, taper=0.85) {
    cylinder(h=h, r1=r, r2=r * taper);
}

function tail_point(i, segments, root=[0,0,0], len=120, lift=40, curl=20) =
    let(step = len / segments)
    [root[0] - i * step,
     root[1],
     root[2] + (lift * (i / segments)) + sin((i / segments) * 90) * curl];

/****************************
 * Components
 ****************************/
module body() {
    // Two ellipsoids hulled together for a stretched, rounded body
    translate([0, 0, leg_height])
    hull() {
        translate([-body_length * 0.25, 0, body_height * 0.5])
            ellipsoid(body_length * 0.45, body_width * 0.5, body_height * (0.55 + body_roundness));
        translate([ body_length * 0.20, 0, body_height * (0.45 + body_roundness * 0.2)])
            ellipsoid(body_length * 0.35, body_width * 0.48, body_height * 0.5);
    }
}

module legs() {
    // Four legs at corners
    translate([ leg_spread_x,  leg_spread_y, 0]) tapered_leg(leg_height, leg_radius, leg_taper);
    translate([ leg_spread_x, -leg_spread_y, 0]) tapered_leg(leg_height, leg_radius, leg_taper);
    translate([-leg_spread_x,  leg_spread_y, 0]) tapered_leg(leg_height, leg_radius, leg_taper);
    translate([-leg_spread_x, -leg_spread_y, 0]) tapered_leg(leg_height, leg_radius, leg_taper);
}

module head() {
    translate([head_offset[0], head_offset[1], head_offset[2] + leg_height])
    rotate([head_tilt, 0, 0]) {
        ellipsoid(head_width * 0.55, head_depth * 0.45, head_height * 0.55);
        // Muzzle / nose
        translate([head_width * 0.35, 0, -head_height * 0.10]) sphere(r=nose_radius);
        // Eyes
        translate([head_width * 0.18,  head_depth * 0.15,  head_height * 0.05]) sphere(r=eye_radius);
        translate([head_width * 0.18, -head_depth * 0.15,  head_height * 0.05]) sphere(r=eye_radius);
        // Ears
        translate([head_width * 0.05,  ear_spread, head_height * 0.40]) rotate([0,0,10])
            cylinder(h=ear_height, r1=ear_base * 0.6, r2=0);
        translate([head_width * 0.05, -ear_spread, head_height * 0.40]) rotate([0,0,-10])
            cylinder(h=ear_height, r1=ear_base * 0.6, r2=0);
    }
}

module tail() {
    segments = 10;
    root = [-body_length * 0.45, tail_side_offset, body_height * 0.45 + leg_height];
    for (i = [0:segments-1]) {
        hull() {
            translate(tail_point(i, segments, root, tail_length, tail_lift, tail_curl)) sphere(r=tail_radius);
            translate(tail_point(i+1, segments, root, tail_length, tail_lift, tail_curl)) sphere(r=tail_radius * 0.9);
        }
    }
}

/****************************
 * Assembly
 ****************************/
module cat_model() {
    union() {
        legs();
        body();
        head();
        tail();
    }
}

// Render the cat
cat_model();
