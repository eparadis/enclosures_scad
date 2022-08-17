
// precision-related
eps = 0.01;
$fn = $preview ? 64 : 128;

// copper tube from UW surplus
// OD is very round - under 0.02 runout
// ID is 45.15
tube_ID = 45.15;
tube_OD = 46.93;
tube_lng = (68.55+68.58)/2; // 68.55 to 68.58

use <multipart_drum.scad>

module positioning_cap() {
    end_cap_flange(7, tube_ID, recessed=true);
    translate([0,0, -2+eps])
        end_cap_flange(2, 50, recessed=false);
}

module bearing_retainer() {
    flange(2, tube_ID-1, false);
}

module inner_spacer() {
    difference() {
        // the tube,
        //  minus the two parts of the cap that hold it on place
        //  minus 1mm to give space to compress things
        //  minus the two bearing retainer plates
        l = tube_lng-7-7-1-2-2;
        // cube([tube_lng-5*2-1, tube_ID-1, 5]);
        union() {
            flange(l, tube_ID-1, false);
            translate([0, 0, 8])
                cylinder(l-2*8, d=tube_ID-1, false);
        }
        translate([0,0,-eps])
            cylinder(tube_lng, d=30, center=false);
    }
}

// cap that positions the tube
color("red")
translate([0,0,-10])
    positioning_cap();

// a thin piece to retain the bearing on the inside of the tube
color("green")
translate([0,0, 0])
    bearing_retainer();

// spacer inside the tube to hold everything together
color("blue")
translate([0,0,8])
    inner_spacer();

// another bearing retainer
color("green")
translate([0,0, 63])
    bearing_retainer();

// another cap
color("red")
translate([0,0, 75])
rotate([180, 0, 0])
    positioning_cap();
