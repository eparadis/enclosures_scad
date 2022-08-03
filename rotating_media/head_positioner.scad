
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

module frame(frame_width = 15) {
    bolt_length = 2.91 + 19.96;

    module cap_mount() {
        // holes to mount cap onto frame
        translate([3/2+1, -eps, 10/4])
        rotate([-90,0,0])
            cylinder(5, d=3, center=false);
        translate([frame_width-(3/2+1), -eps, 10-10/4])
        rotate([-90,0,0])
            cylinder(5, d=3, center=false);
    }

    difference() {
        cube([frame_width, bolt_length, 10]);
        translate([frame_width/2, -eps, 10/2])
        rotate([-90,0,0])
            bolt_clearance();
        translate([frame_width/4, 5, -eps])
            cube([frame_width/2, 15, 15]);
        cap_mount();
    }

    // the cap
    translate([0, -5, 0])
    difference() {
        cube([frame_width, 2, 10]);
        // clearance for hex driver to turn bolt
        translate([frame_width/2, -eps, 5])
        rotate([-90,0,0])
            cylinder(2+2*eps, d=3+0.2, center=false);
        cap_mount();
    }
}

module carriage(frame_width=15) {
    difference() {
        translate([-frame_width/4,0,10])
            cube([frame_width, 8, 5]);
        translate([0, 8/2, 10-eps])
            cylinder(5+2*eps, d=3, center=false);
        translate([frame_width/2, 8/2, 10-eps])
            cylinder(5+2*eps, d=3, center=false);
    }
    difference() {
        cube([frame_width/2, 8, 10+eps]);
        translate([frame_width/4, -eps, 10/2])
        rotate([-90,0,0])
            cylinder(8+2*eps, d=3, center=false);
    }
}

frame(15);

color("red")
translate([15/4, -20, 0])
    carriage(15);