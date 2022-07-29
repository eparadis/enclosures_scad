
press_fit_tol = 0.3;
bolt_pattern_radius = 18;

// precision-related
eps = 0.01;
$fn = 100;

function bearing_outer_fit() = 16.0 + press_fit_tol;

module end_cap(thickness, diameter) {
    difference() {
        // body
        cylinder(thickness, d=diameter, center = false);
        // where the bearing presses into
        translate([0,0,2])
            cylinder(thickness, d=bearing_outer_fit(), center=false);
        // hole in the middle for inner bearing race clearance
        cylinder(thickness*2, d=10, center=true);
        // holes to mount the cap to something
        echo(str("bolt_pattern_radius=", bolt_pattern_radius));
        for( rot = [0 : 360/6 : 360])
            rotate([0, 0, rot])
            translate([bolt_pattern_radius, 0, -eps])
                cylinder(h=thickness*3, d=4, center=true);
    }
}

module center_drum(thickness, diameter) {
    // middle portion between hub and rim. the 'spokes' i guess
    difference() {
        // disc
        cylinder(thickness/2, d=diameter, center=false);
        // clearance for hub
        cylinder(thickness*2, d=50-eps, center=true);
        for( rot = [0 : 360/6 : 360])
            rotate([0,0, rot+30])
            translate([diameter/2*0.71, 0, -eps])
                cylinder(h=thickness*3, d=20, center=true);
    }
    // the rim
    difference() {
        cylinder(thickness, d=diameter, center=false);
        cylinder(thickness*3, d=diameter-thickness, center=true);
    }
    // the hub
    difference() {
        // body
        cylinder(thickness, d=50, center=false);
        // hollow center
        translate([0, 0, -eps])
            cylinder(thickness+2*eps, d=16+24*.4, center=false);
        // holes to mount end cap
        for( rot = [0 : 360/6 : 360])
            rotate([0,0, rot])
            translate([bolt_pattern_radius, 0, -eps])
                cylinder(h=thickness*3, d=3, center=true);
    }
}

module pulley(diameter) {
    thickness = 4;
    groove_width = 1.6;
    difference() {
        // body
        cylinder(thickness, d=diameter, center=false);
        // clearance for axle
        cylinder(thickness*3, d=10, center=true);
        // // holes to mount end cap
        // for( rot = [0 : 360/6 : 360])
        //     rotate([0,0, rot])
        //     translate([bolt_pattern_radius, 0, -eps])
        //         cylinder(h=thickness*3, d=3, center=true);
        // groove for belt
        rotate_extrude()
            translate([diameter/2-1, thickness/2-groove_width/2, 0])
            square([5, groove_width], center=false);
    }
}

// this makes a flange with 6 recessed bolts
// 
module flange(thickness, diameter) {
    difference() {
        // body
        cylinder(thickness, d=diameter, center=false);
        // clearance for axle
        cylinder(thickness*3, d=10, center=true);
        // holes to mount end cap
        for( rot = [0 : 360/6 : 360])
            rotate([0,0, rot]) {
                translate([bolt_pattern_radius, 0, -eps])
                    cylinder(h=2+2*eps, d=3, center=false);
                translate([bolt_pattern_radius, 0, 2])
                    cylinder(h=thickness-2+2*eps, d=6, center=false);
            }
    }
}

// translate([0, 0, -50])
//     end_cap(7, 50);

translate([0, 0, -25])
    center_drum(7, 100);

translate([0, 0, -75]) {
    translate([0, 0, eps-6])
        flange(6, 50);
    pulley(20);
}


