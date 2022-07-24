motor_dia = 24.4;
clamp_gap = 1.0;

// precision-related
eps = 0.01;
$fn = 100;

module clamp(thickness) {
    difference() {
        translate([-20, -20, 0])
            cube([40, 40, thickness]);
        cylinder(thickness*3, d=motor_dia+1.0, center=true);
        translate([- clamp_gap / 2, 0, -eps])
            cube([clamp_gap, 20+eps, thickness+2*eps]);
    }
}


clamp(10);