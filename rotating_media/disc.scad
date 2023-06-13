// disc.scad
// a press-fit circular mount for rotating magnetic media

// quarter inch tape is 6.35mm

drum_width = 7; // the drum-style surface width
disc_width = 7;  // the disc-style surface width
diameter = 100;  // diamter of the whole thing
num_cutouts = 4; // the number of circular cutouts
cutout_spacing = 6; // distance between cutouts
press_fit_tol = 0.3;
axle_dia = 4.98 + press_fit_tol / 2 ;  // 4.98 as measured

hub_dia = 20;
hub_height = 20;

// precision-related
eps = 0.01;
$fn = 100;

include <common.scad>

module body()
{
    translate([0,0,drum_width/4])
    cylinder(h = drum_width/2, r = diameter/2-1, center = true);

    // the outer ring
    difference() {
        translate([0,0,drum_width/2])
            cylinder(h = drum_width, r = diameter/2, center = true);
        translate([0,0,drum_width/2+eps])
            cylinder(h=drum_width, r=diameter/2-disc_width, center=true);
    }
}

module cutouts() {
    // soh cah toa
    // sin(360/count/2) = half_side / diameter/4
    half_side = sin(360/num_cutouts/2) * diameter/4;
    cutout_dia = 2*half_side - cutout_spacing;

    for( rot = [0 : 360/num_cutouts : 360])
        rotate([0, 0, rot])
        translate([diameter/4, 0, -eps])
        cylinder(h=drum_width*2, r=cutout_dia/2, center=true);
}

module hub_set_screws() {
    // both of these are from the TC560 handle project
    set_screw_dia = 2.6; // press fit for M3 screw
    set_screw_head_clr = 6.2;  // clearance for the head of the M3 screw
    translate([0, 0, hub_height / 2])
        rotate([90, 0, 0])
            cylinder(h=hub_dia*4, r=set_screw_dia/2, center=true);
    translate([0, hub_dia/2, hub_height / 2])
        rotate([90, 0, 0])
            cylinder(h=hub_dia/2, r=set_screw_head_clr/2, center=true);
    translate([0, -hub_dia/2, hub_height / 2])
        rotate([90, 0, 0])
            cylinder(h=hub_dia/2, r=set_screw_head_clr/2, center=true);
}

module inner_hub() {
    difference() {
        translate([0,0,hub_height/2])
            cylinder(h=hub_height, r=hub_dia/2, center = true);
        hub_set_screws();
    }
}

module disc() {
    difference() {
        union() {
            difference() {
                body();
                cutouts();
            }
            inner_hub();
        }

        // the center axle hole
        translate([0,0,-drum_width/2])
            cylinder(h=drum_width*400 + 2*eps, r=axle_dia/2, center=true);

        press_fit_fix();
    }
}

module head_mount_holes(gap = 4, sweep = 15) {
    for (i=[0:6]) {
        rotate([0, 0, i*sweep-90-45])
        translate([diameter/2 + gap, 0, 0])
        //cube(5, center=true);
        cylinder(10, d=3, center=true);
    }
}

module head_mount() {
    translate([-diameter/2, -diameter+20, 0])
        cube([diameter, 3, 20]);
    difference() {
        translate([-diameter/2, -diameter+20, 0])
        cube([diameter, diameter/2, 3]);
        head_mount_holes(gap=5);
        head_mount_holes(gap=10);
        head_mount_holes(gap=15);
    }
}

module mount_block() {
    rotate([-90, 0, 0])
        difference() {
            cube([10, 10, 15],center=false);
            inset_bolt();
        }
}

translate([0, 0, 5]) {
    disc();
}

translate([0, 0, 0]) {
    color("red")
    head_mount();
}
