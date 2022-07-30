motor_dia = 24.4;
clamp_gap = 2.0;

// precision-related
eps = 0.01;
$fn = 100;

module clamp(thickness) {
    difference() {
        translate([-20, -20, 0])
            cube([40, 44, thickness]);
        cylinder(thickness*3, d=motor_dia+0.5, center=true);
        translate([- clamp_gap / 2, 0, -eps])
            cube([clamp_gap, 24+eps, thickness+2*eps]);
        // narrow portion of clamp screw
        translate([0, 17, thickness/2])
            rotate([0, 90, 0])
                cylinder(40+2, d=2.9, center=true);
        // recessed head for clamp screw
        translate([15, 17, thickness/2])
            rotate([0, 90, 0])
                cylinder(40/2, d=6, center=true);
    }
}

// a clamp with a simple "foot" base that has a tripod-style
// set of mounting holes in order to adjust the motor's axis alignment
module clamp_with_base() {
    clamp(10);
    difference() {
        // the foot
        translate([-20, -20, 0])
            cube([40, 5, 25]);
        // center hole for mounting
        translate([0, -15-eps, 15])
            rotate([90, 0, 0])
                cylinder(5*2, d=2.9, center=true);
        // left hole for mounting
        translate([-15, -15-eps, 20])
            rotate([90, 0, 0])
                cylinder(5*2, d=2.9, center=true);
        // right hole for mounting
        translate([15, -15-eps, 20])
            rotate([90, 0, 0])
                cylinder(5*2, d=2.9, center=true);
    }
}

clamp_with_base();