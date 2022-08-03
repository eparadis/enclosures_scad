
// precision-related
eps = 0.01;
$fn = $preview ? 64 : 128;

// M3 x 20
// threaded portion OD 2.92 ("3")
// threaded portion length 19.96 ("20")
// head OD 5.39
// head length 2.91
// hex driver clearance diameter 2.90

module bolt_clearance() {
    cylinder(2.91, d=5.39+1, center=false);
    translate([0, 0, 2.91-eps])
        cylinder(20, d=3+0.2, center=false);
}

module body() {
    bolt_length = 2.91 + 19.96;
    difference() {
        cube([10, bolt_length, 10]);
        translate([10/2, -eps, 10/2])
        rotate([-90,0,0])
            bolt_clearance();
        translate([10/4, 5, -eps])
            cube([10/2, 15, 15]);
    }
}

body();