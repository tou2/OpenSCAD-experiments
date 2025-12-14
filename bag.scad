// Bag generator for OpenSCAD
// Adjust the variables in the "User parameters" section to explore variants.

/****************************
 * User parameters
 ****************************/
bag_width = 240;          // X axis (left/right)
bag_height = 300;         // Z axis (up/down)
bag_depth = 100;          // Y axis (front/back)
wall_thickness = 3;
corner_radius = 12;

// Outside pockets (front face, centered along width)
outside_pocket_count = 2;
outside_pocket_width = 80;
outside_pocket_height = 120;
outside_pocket_depth = 18;
outside_pocket_start_height = 50; // from bottom of bag
outside_pocket_radius = 6;
outside_pocket_spacing = 10; // minimum gap between pockets

// Inside pockets (against front inner face)
inside_pocket_count = 1;
inside_pocket_width = 90;
inside_pocket_height = 90;
inside_pocket_depth = 8;
inside_pocket_start_height = 80;
inside_pocket_radius = 4;
inside_pocket_spacing = 6;

// Simple carry loop tabs
tab_width = 20;
tab_height = 12;
tab_thickness = 5;
tab_offset_from_top = 20;

/****************************
 * Helpers
 ****************************/
module rounded_prism(size=[40,20,40], r=4) {
    // Creates a box with rounded edges; origin at the lower-front-left corner.
    sz = [max(size[0]-2*r, 0.01), max(size[1]-2*r, 0.01), max(size[2]-2*r, 0.01)];
    minkowski() {
        cube(sz, center=false);
        sphere(r);
    }
}

module hollow_shell(outer=[60,30,80], thickness=3, r=4) {
    inner = [outer[0]-2*thickness, outer[1]-2*thickness, outer[2]-thickness];
    difference() {
        rounded_prism(outer, r);
        translate([thickness, thickness, thickness])
            rounded_prism(inner, max(r-thickness, 0.1));
    }
}

function pocket_spacing(count, width, total_width, min_gap) =
    count == 0 ? 0 : max((total_width - (count * width)) / (count + 1), min_gap);

module pocket(width=80, height=120, depth=18, r=6, inset=1) {
    // Simple hollow pocket open at top
    difference() {
        rounded_prism([width, depth, height], r);
        translate([inset, inset, inset])
            rounded_prism([width - 2*inset, depth - 2*inset, height - inset], max(r-inset, 0.1));
    }
}

/****************************
 * Components
 ****************************/
module bag_shell() {
    hollow_shell([bag_width, bag_depth, bag_height], wall_thickness, corner_radius);
}

module outside_pockets() {
    if (outside_pocket_count > 0) {
        gap = pocket_spacing(outside_pocket_count, outside_pocket_width, bag_width, outside_pocket_spacing);
        for (i = [0:outside_pocket_count-1]) {
            x_pos = gap*(i+1) + outside_pocket_width*i;
            translate([x_pos, -outside_pocket_depth, outside_pocket_start_height])
                pocket(outside_pocket_width, outside_pocket_height, outside_pocket_depth, outside_pocket_radius, inset=1);
        }
    }
}

module inside_pockets() {
    if (inside_pocket_count > 0) {
        gap = pocket_spacing(inside_pocket_count, inside_pocket_width, bag_width - 2*wall_thickness, inside_pocket_spacing);
        for (i = [0:inside_pocket_count-1]) {
            x_pos = wall_thickness + gap*(i+1) + inside_pocket_width*i;
            translate([x_pos, wall_thickness, inside_pocket_start_height])
                pocket(inside_pocket_width, inside_pocket_height, inside_pocket_depth, inside_pocket_radius, inset=1);
        }
    }
}

module carry_tabs() {
    // Two tabs at the front edge near the top
    translate([bag_width*0.25 - tab_width/2, -tab_thickness, bag_height - tab_offset_from_top])
        cube([tab_width, tab_thickness, tab_height]);
    translate([bag_width*0.75 - tab_width/2, -tab_thickness, bag_height - tab_offset_from_top])
        cube([tab_width, tab_thickness, tab_height]);
}

/****************************
 * Assembly
 ****************************/
module bag_model() {
    union() {
        bag_shell();
        outside_pockets();
        inside_pockets();
        carry_tabs();
    }
}

// Render
bag_model();
