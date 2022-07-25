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
module press_fit_fix() {
    // widen the bottom to avoid elephant foot
    cylinder(h=3, r=(axle_dia/2)+1, center=true);
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

module inset_bolt() {
    translate([5, 5, -eps])
        cylinder(15*3, d=4, center=true);
    translate([5, 5, 10])
        cylinder(11, d=7, center=true);
}

module mount_block() {
    rotate([-90, 0, 0])
        difference() {
            cube([10, 10, 15],center=false);
            inset_bolt();
        }
}

// "625" bearing dimensions
// bore/ID = 5.0
// OD = 16.0
// width = 5.0
// "2809" bearing dimensions
// bore/ID = 8.0
// OD = 22.0
// width = 7.0
module stand(bearing_size = "625") {
    thickness = 10;

    module make_stand(b_ID, b_OD, b_w, adapter=false) {
        fit_ID = b_ID - press_fit_tol / 2;
        fit_OD = b_OD + press_fit_tol;
        a = b_OD <= 12 ? 12 : b_OD/2+3;
        b = -diameter/2-30;
        difference() {
            // body, outside shape
            linear_extrude(thickness, center=false)
                offset(r=5, delta=5, chamfer=false)
                polygon([[a-5,a-5], [-a+5,a-5], [-40+5, b+5], [40-5, b+5]]);
            // where the bearing presses in
            cylinder(thickness*3, d=fit_OD, center=true);
            // center alignment guide
            translate([0, b+5, -eps]) {
                cylinder(thickness*3, d=axle_dia, center=true);
                press_fit_fix();
            }
            // right alignment guide
            translate([30, b+5, -eps]) {
                cylinder(thickness*3, d=axle_dia, center=true);
                press_fit_fix();
            }
            // left alignment guide
            translate([-30, b+5, -eps]) {
                cylinder(thickness*3, d=axle_dia, center=true);
                press_fit_fix();
            }
            // center cutout, inner shape
            translate([0,0,-eps])
                linear_extrude(thickness+2*eps, center=false)
                    offset(r=5, delta=5, chamfer=false)
                    //       top right    top left      btm left     btm right
                    polygon([[a-5, -a-5], [-a+5, -a-5], [-20, b+20], [20, b+20]]);
            // right mount bolt
            translate([10, b, 10])
                rotate([-90, 0, 0])
                    inset_bolt();
            // left mount bolt
            translate([-20, b, 10])
                rotate([-90, 0, 0])
                    inset_bolt();
            // bearing/axle set screw
            translate([0, 0, thickness / 2])
                rotate([-90, 0, 0])
                    cylinder(a+1, d=3, center=false);
        }
        // step to press the bearing against to align it
        difference() {
            cylinder(thickness-b_w, d=b_OD+2);
            translate([0, 0, -eps])
                cylinder(5+2*eps, d=b_OD-2);
        }

        // an axle-to-bearing adapter (works poorly)
        if(adapter) {
            difference() {
                cylinder(thickness, d=fit_ID);
                translate([0, 0, -eps])
                    cylinder(thickness*3, d=axle_dia+press_fit_tol/2, center=true);
            }
        }
    }

    if( bearing_size == "625") {
        make_stand( 5.0, 16.0, 5.0, false);
    } else if( bearing_size == "2809") {
        make_stand( 8.0, 22.0, 7.0, true);
    } else if( bearing_size == "static_axle_5") {
        make_stand( 0, 4.98, 10);
    }
}

// translate([0, 0, 5]) {
//     disc();
// }

// translate([0, 0, 30]) {
//     color("yellow")
//     stand("625");
// }

translate([100, 0, 30]) {
    color("orange")
    stand("static_axle_5");
}

// translate([0, 0, 0]) {
//     color("red")
//     head_mount();
// }
