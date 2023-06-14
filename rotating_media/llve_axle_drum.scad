// precision-related
eps = 0.01;
$fn = $preview ? 64 : 128;

press_fit_tol = 0.3;
axle_dia = 4.98 + press_fit_tol / 2 ;  // 4.98 as measured

use <multipart_drum.scad>

module center_drum() {
    ID = 30;
    l = 55;
    difference() {
        flange(l, 50, false);
        translate([0, 0, -eps])
            cylinder(l+eps*2, d=ID, false);
    }
}

module end_cap_flange(length, diameter) {

    module inner_hub(height, dia) {
        module hub_set_screws() {
            // both of these are from the TC560 handle project
            set_screw_dia = 2.6; // press fit for M3 screw
            set_screw_head_clr = 6.2;  // clearance for the head of the M3 screw
            set_screw_height = height-set_screw_head_clr/2-2;
            translate([0, 0, set_screw_height])
                rotate([90, 0, 0])
                    cylinder(h=dia*4, r=set_screw_dia/2, center=true);
            translate([0, dia/2, set_screw_height])
                rotate([90, 0, 0])
                    cylinder(h=dia/2, r=set_screw_head_clr/2, center=true);
            translate([0, -dia/2, set_screw_height])
                rotate([90, 0, 0])
                    cylinder(h=dia/2, r=set_screw_head_clr/2, center=true);
        }

        difference() {
            translate([0,0,height/2])
                cylinder(h=height, r=dia/2, center = true);
            hub_set_screws();
        }
    }

    difference() {
        union() {
            inner_hub(length+10, 15);
            flange(length, diameter, true);
        }
        translate([0,0,-eps])
            cylinder(length+10+2*eps, d=axle_dia);
    }
}


color("red")
translate([0, 0, 0])
    center_drum();

color("lightgreen")
translate([0, 0, 70])
    end_cap_flange(5, 50);