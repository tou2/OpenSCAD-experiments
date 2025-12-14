// Cylinder generator
/****************************
 * User parameters
 ****************************/
radius = 20;
height = 60;
center_cylinder = false;
$fn = 64;

/****************************
 * Assembly
 ****************************/
module cylinder_generator() {
    cylinder(h=height, r=radius, center=center_cylinder);
}

cylinder_generator();
