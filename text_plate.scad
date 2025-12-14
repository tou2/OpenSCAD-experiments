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

// Plate shape options
plate_shape = "rectangle"; // "rectangle", "circle", "ellipse", "rounded_rect"

halign = "center";        // text alignment: left|center|right
valign = "center";        // text vertical alignment: top|center|baseline|bottom
$fn = 64;

// International text layout (set these for Arabic or other scripts)
// For Arabic examples: font="Noto Naskh Arabic" (or "Amiri"), language="ar", script="arabic", direction="rtl"
language = "en";          // e.g., "ar" for Arabic
script = "latin";         // e.g., "arabic"
direction = "ltr";        // "ltr" (left-to-right), "rtl" (right-to-left), or "ttb"

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

module circle_2d(w, h) {
    // Use average of w and h for diameter
    d = (w + h) / 2;
    circle(d=d);
}

module ellipse_2d(w, h) {
    scale([w/h, 1, 1]) circle(d=h);
}

module plate(w, h, t, r, shape="rectangle") {
    linear_extrude(height=t) {
        if (shape == "circle")
            circle_2d(w, h);
        else if (shape == "ellipse")
            ellipse_2d(w, h);
        else if (shape == "rounded_rect")
            rounded_rect_2d(w, h, r);
        else // rectangle
            square([w, h], center=true);
    }
}

module text3d(msg, size, depth, font, halign, valign, spacing=1.0, language="en", script="latin", direction="ltr") {
    linear_extrude(height=depth)
        text(msg,
             size=size,
             font=font,
             halign=halign,
             valign=valign,
             spacing=spacing,
             language=language,
             script=script,
             direction=direction);
}

/****************************
 * Assembly
 ****************************/
module text_plate() {
    w = plate_width > 0 ? plate_width : auto_w(message, size, margin);
    h = plate_height > 0 ? plate_height : auto_h(size, margin);

    if (text_mode == "emboss") {
        union() {
            plate(w, h, plate_thickness, corner_radius, plate_shape);
            // place text on the top surface
            translate([0, 0, plate_thickness])
                text3d(message, size, text_depth, font, halign, valign, letter_spacing, language, script, direction);
        }
    } else if (text_mode == "engrave") {
        difference() {
            plate(w, h, plate_thickness, corner_radius, plate_shape);
            // subtract text into the top face
            translate([0, 0, plate_thickness - text_depth])
                text3d(message, size, text_depth, font, halign, valign, letter_spacing, language, script, direction);
        }
    } else {
        plate(w, h, plate_thickness, corner_radius, plate_shape);
    }
}

// Render
text_plate();
