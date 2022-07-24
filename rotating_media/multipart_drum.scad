
press_fit_tol = 0.3;
bolt_pattern_radius = 18;

// precision-related
eps = 0.01;
$fn = 100;

function bearing_outer_fit() = 22.0 + press_fit_tol;

module end_cap(thickness, diameter) {
    difference() {
        // body
        cylinder(thickness, d=diameter, center = false);
        // where the bearing presses into
        translate([0,0,2])
            cylinder(thickness, d=bearing_outer_fit(), center=false);
        // hole in the middle for inner bearing race clearance
        cylinder(thickness*2, d=15, center=true);
        // holes to mount the cap to something
        echo(str("bolt_pattern_radius=", bolt_pattern_radius));
        for( rot = [0 : 360/6 : 360])
            rotate([0, 0, rot])
            translate([bolt_pattern_radius, 0, -eps])
                cylinder(h=thickness*3, d=4, center=true);
    }
}

module center_drum(thickness, diameter) {
    difference() {
        // body
        cylinder(thickness, d=diameter, center=false);
        // hollow center
        translate([0, 0, -eps])
            cylinder(thickness+2*eps, d=diameter-20, center=false);
        // holes to mount end cap
        for( rot = [0 : 360/6 : 360])
            rotate([0,0, rot])
            translate([bolt_pattern_radius, 0, -eps])
                cylinder(h=thickness*3, d=3, center=true);
    }
}

translate([0, 0, -50])
    end_cap(7, 50);

center_drum(15, 50);