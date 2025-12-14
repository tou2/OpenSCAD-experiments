// Sphere generator
/****************************
 * User parameters
 ****************************/
radius = 25;
center_sphere = false;
$fn = 64;

/****************************
 * Assembly
 ****************************/
module sphere_generator() {
    translate(center_sphere ? [0,0,0] : [radius, radius, radius])
        sphere(r=radius);
}

sphere_generator();
