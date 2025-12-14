// Simple parametric cube generator for OpenSCAD
// Tweak the parameters below. Supports optional chamfer or fillet.

/****************************
 * User parameters
 ****************************/
size_x = 40;
size_y = 40;
size_z = 40;
center_cube = false;     // center at origin if true

// Edge treatment: choose one of none | chamfer | fillet
edge_style = "none";     // "none", "chamfer", or "fillet"
edge_amount = 3;          // chamfer size or fillet radius
$fn = 48;

/****************************
 * Helpers
 ****************************/
module base_cube(sz=[40,40,40], center=false) {
    cube(sz, center=center);
}

module chamfered_cube(sz=[40,40,40], c=2, center=false) {
    // Chamfer edges by subtracting triangular prisms at each edge
    difference() {
        cube(sz, center=center);
        // Work in a non-centered frame for simplicity
        translate(center ? [-sz[0]/2, -sz[1]/2, -sz[2]/2] : [0,0,0]) {
            // X edges
            for (y=[0, sz[1]-c], z=[0, sz[2]-c])
                translate([0, y, z]) rotate([0,90,0]) prism(c, sz[0]);
            for (y=[0, sz[1]-c], z=[0, sz[2]-c])
                translate([sz[0], y, z]) rotate([0,90,180]) prism(c, sz[0]);
            // Y edges
            for (x=[0, sz[0]-c], z=[0, sz[2]-c])
                translate([x, 0, z]) rotate([90,0,0]) prism(c, sz[1]);
            for (x=[0, sz[0]-c], z=[0, sz[2]-c])
                translate([x, sz[1], z]) rotate([90,0,180]) prism(c, sz[1]);
            // Z edges
            for (x=[0, sz[0]-c], y=[0, sz[1]-c])
                translate([x, y, 0]) rotate([0,0,0]) prism(c, sz[2]);
            for (x=[0, sz[0]-c], y=[0, sz[1]-c])
                translate([x, y, sz[2]]) rotate([180,0,0]) prism(c, sz[2]);
        }
    }
}

module prism(a=2, h=10) {
    // Right triangular prism used for chamfers; right angle at origin on XY
    linear_extrude(height=h)
        polygon(points=[[0,0],[a,0],[0,a]]);
}

module filleted_cube(sz=[40,40,40], r=3, center=false) {
    // Fillet edges via minkowski with a sphere, then crop back to original size
    // Minkowski expands all sides by r; we subtract r later with translate and intersection
    minkowski() {
        cube([max(sz[0]-2*r,0.01), max(sz[1]-2*r,0.01), max(sz[2]-2*r,0.01)], center=center);
        sphere(r=r);
    }
}

/****************************
 * Assembly
 ****************************/
module cube_generator() {
    sz = [size_x, size_y, size_z];
    if (edge_style == "none")
        base_cube(sz, center_cube);
    else if (edge_style == "chamfer")
        chamfered_cube(sz, edge_amount, center_cube);
    else if (edge_style == "fillet")
        filleted_cube(sz, edge_amount, center_cube);
    else
        base_cube(sz, center_cube);
}

// Render
cube_generator();
