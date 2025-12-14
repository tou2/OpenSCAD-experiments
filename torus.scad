// Torus generator using rotate_extrude
/****************************
 * User parameters
 ****************************/
R = 50;    // major radius (distance from center to tube center)
r = 15;    // minor radius (tube radius)
angle = 360; // sweep angle for partial torus
$fn = 96;

/****************************
 * Assembly
 ****************************/
module torus_generator() {
    rotate_extrude(angle=angle)
        translate([R, 0, 0]) circle(r=r);
}

torus_generator();
