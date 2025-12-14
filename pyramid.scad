// Pyramid generator (square base)
/****************************
 * User parameters
 ****************************/
base_x = 40;
base_y = 40;
height = 50;
center_base = false; // base centered at origin if true

/****************************
 * Assembly
 ****************************/
module pyramid_generator() {
    translate(center_base ? [-base_x/2, -base_y/2, 0] : [0,0,0])
    polyhedron(
        points=[
            [0,0,0], [base_x,0,0], [base_x,base_y,0], [0,base_y,0], // base
            [base_x/2, base_y/2, height] // apex
        ],
        faces=[
            [0,1,2,3], // base
            [0,1,4], [1,2,4], [2,3,4], [3,0,4] // sides
        ],
        convexity=10
    );
}

pyramid_generator();
