// disc.scad
// a press-fit circular mount for rotating magnetic media

// quarter inch tape is 6.35mm

drum_width = 7; // the drum-style surface width
disc_width = 7;  // the disc-style surface width
diameter = 100;  // diamter of the whole thing
num_cutouts = 4; // the number of circular cutouts
cutout_spacing = 6; // distance between cutouts
axle_dia = 4.98;  // as measured

// precision-related
eps = 0.01;
$fn = 100;

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

module inner_hub() {
    translate([0,0,drum_width/2])
    cylinder(h=drum_width, r=10, center = true);
}

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
        cylinder(h=drum_width*4 + 2*eps, r=axle_dia, center=true);
}
