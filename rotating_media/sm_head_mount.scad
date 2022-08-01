
// precision-related
eps = 0.01;
$fn = 100;

// these small heads are probably from pocket microcassette recorders

// mount height offset
// the head's bracket is Z shaped, with one side higher than the other
height_offset = 4.5;

// bracket hole diameter. Appears to be for M1.6
bracket_hole_dia = 1.6;

// the bracket has two holes
bracket_hole_spacing = 11.5;

// distance from the front of the head to the center line between the two holes
head_distance = 8;

difference() {
    union() {
        // the base
        cube([20, 10, 2]);
        // right support
        b = 20/2+bracket_hole_spacing/2-bracket_hole_dia;
        translate([b, 0, 2-eps])
        cube([20-b, 10, height_offset]);
    }

    // left hole
    translate([20/2-bracket_hole_spacing/2, 10-8, 0])
    cylinder(5, d=bracket_hole_dia, center= true);

    // right hole
    translate([20/2+bracket_hole_spacing/2, 10-8, 0])
    cylinder(30, d=bracket_hole_dia, center= true);
    
    // generic mounting hole to attach this somewhere
    translate([17,5,-eps])
    cylinder(20, d=3, center=true);
}