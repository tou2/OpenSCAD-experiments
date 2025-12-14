// Cone / frustum generator
/****************************
 * User parameters
 ****************************/
r1 = 30;   // bottom radius
r2 = 10;   // top radius (0 for cone)
height = 50;
center_cone = false;
$fn = 64;

/****************************
 * Assembly
 ****************************/
module cone_generator() {
    cylinder(h=height, r1=r1, r2=r2, center=center_cone);
}

cone_generator();
