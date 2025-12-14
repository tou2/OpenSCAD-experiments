// Text-to-3D-rectangle (plaque) generator for OpenSCAD
// Creates a rectangular plate sized from the text, then embosses or engraves the text.

/****************************
 * User parameters
 ****************************/
message = "HELLO";       // text to place on the plaque
font = "Liberation Sans"; // any installed font name
size = 20;                 // text point size (OpenSCAD units)
letter_spacing = 1.0;      // spacing multiplier between letters

// Plate sizing: set explicit width/height, or leave 0 for auto estimate
plate_width = 0;           // 0 = auto width based on message length
plate_height = 0;          // 0 = auto height based on text size
margin = 6;                // margin around text on all sides
corner_radius = 4;         // rounded plate corners (0 for sharp)

plate_thickness = 4;       // thickness of the base plate
text_depth = 2;            // emboss/engrave depth
text_mode = "emboss";     // "emboss" or "engrave"

halign = "center";        // text alignment: left|center|right
valign = "center";        // text vertical alignment: top|center|baseline|bottom
$fn = 64;

/****************************
 * Helpers
 ****************************/
// Rough width/height estimate (no true bbox in OpenSCAD). Adjust factors for your font.
char_factor = 0.62;        // average width per character relative to size
height_factor = 1.25;      // text block height relative to size

function auto_w(msg, size, margin) = len(msg) * size * char_factor + 2 * margin;
function auto_h(size, margin) = size * height_factor + 2 * margin;

module rounded_rect_2d(w, h, r) {
    if (r <= 0) square([w, h], center=true);
    else offset(r=r) square([w - 2*r, h - 2*r], center=true);
}

module plate(w, h, t, r) {
    linear_extrude(height=t) rounded_rect_2d(w, h, r);
}

module text3d(msg, size, depth, font, halign, valign, spacing=1.0) {
    linear_extrude(height=depth)
        text(msg, size=size, font=font, halign=halign, valign=valign, spacing=spacing);
}

/****************************
 * Assembly
 ****************************/
module text_plate() {
    w = plate_width > 0 ? plate_width : auto_w(message, size, margin);
    h = plate_height > 0 ? plate_height : auto_h(size, margin);

    if (text_mode == "emboss") {
        union() {
            plate(w, h, plate_thickness, corner_radius);
            // place text on the top surface
            translate([0, 0, plate_thickness])
                text3d(message, size, text_depth, font, halign, valign, letter_spacing);
        }
    } else if (text_mode == "engrave") {
        difference() {
            plate(w, h, plate_thickness, corner_radius);
            // subtract text into the top face
            translate([0, 0, plate_thickness - text_depth])
                text3d(message, size, text_depth, font, halign, valign, letter_spacing);
        }
    } else {
        plate(w, h, plate_thickness, corner_radius);
    }
}

// Render
text_plate();
