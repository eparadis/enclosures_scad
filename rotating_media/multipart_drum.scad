
press_fit_tol = 0.1;
bolt_pattern_radius = 18;
b_OD = 16.0;

// precision-related
eps = 0.01;
$fn = $preview ? 64 : 128;

function bearing_outer_fit() = b_OD + press_fit_tol;

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

module center_drum(thickness, diameter, cutouts=false) {
    // middle portion between hub and rim. the 'spokes' i guess
    difference() {
        // disc
        cylinder(thickness/2, d=diameter, center=false);
        // clearance for hub
        cylinder(thickness*2, d=50-eps, center=true);
        // cutouts
        if(cutouts) {
            rad_outer = (diameter/2-thickness/2);
            rad_inner = 50/2;
            rad_mid = (rad_inner+rad_outer)/2;
            rad_mid_width = rad_outer - rad_inner;
            circ_mid = 2*rad_mid*PI;
            num_holes = floor(circ_mid/rad_mid_width)-2;
            space_between_holes = (circ_mid - rad_mid_width*num_holes)/num_holes;
            for( rot = [0 : 360/(space_between_holes<5? num_holes-2 : num_holes) : 360]) {
                rotate([0,0, rot+30])
                translate([rad_mid, 0, -eps])
                    cylinder(h=thickness*3, d=rad_mid_width, center=true);
            }
        }
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

// this makes a flange with 6 optionallyrecessed bolts
// 
module flange(thickness, diameter, recessed=true) {
    difference() {
        // body
        cylinder(thickness, d=diameter, center=false, $fn = ($preview ? 64 : 256));
        // clearance for axle
        cylinder(thickness*3, d=10, center=true);
        // holes to mount end cap
        for( rot = [0 : 360/6 : 360])
            rotate([0,0, rot]) {
                if( recessed) {
                translate([bolt_pattern_radius, 0, -eps])
                    cylinder(h=2+2*eps, d=3, center=false);
                translate([bolt_pattern_radius, 0, 2])
                    cylinder(h=thickness-2+2*eps, d=6, center=false);
                } else {
                    translate([bolt_pattern_radius, 0, -eps])
                        cylinder(h=thickness*3, d=3, center=false);
                }
            }
    }
}

module end_cap_flange(thickness, diameter, recessed=true) {
    difference() {
        flange(thickness, diameter, recessed);
        translate([0, 0, 2])
            cylinder(thickness, d=bearing_outer_fit(), center=false);

    }
}

color("green")
translate([0, 0, -50])
    end_cap_flange(7, 50);

color("lightgreen")
translate([0, 0, -25])
    center_drum(7, 100);

color("pink")
translate([0, 0, -75]) {
    translate([0, 0, eps-6])
        flange(6, 50);
    pulley(20);
}

