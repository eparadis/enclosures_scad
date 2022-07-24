
press_fit_tol = 0.3;


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
        bolt_pattern_radius = 18;
        echo(str("bolt_pattern_radius=", bolt_pattern_radius));
        for( rot = [0 : 360/6 : 360])
            rotate([0, 0, rot])
            translate([bolt_pattern_radius, 0, -eps])
                cylinder(h=thickness*3, d=4, center=true);
    }
}

end_cap(7, 50);