// Triangular prism generator
/****************************
 * User parameters
 ****************************/
base = 40;     // right triangle legs length
height = 60;   // extrusion height
center_prism = false;

/****************************
 * Assembly
 ****************************/
module prism_generator() {
    translate(center_prism ? [-base/2, -base/2, 0] : [0,0,0])
    linear_extrude(height=height)
        polygon(points=[[0,0],[base,0],[0,base]]);
}

prism_generator();
