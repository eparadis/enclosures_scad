
// there are more than one configuration:
// "opposing"
// "arc"
style = "arc";
// style = "opposing";

drum_diameter = 100;

// precision-related
eps = 0.01;
$fn = $preview ? 64 : 256;

use <head_mount.scad>
use <multipart_drum.scad>
use <head_positioner.scad>
use <nortronics_adapter.scad>

module positioner_frame_and_carriage() {
    color("orange")
    positioner_frame(15);

    color("darkorange")
    translate([3.75, 11, 0])
    positioner_carriage(15);
}

module opposing_mounts(diameter) {
    translate([27.5, diameter == 50? -58 : -83, -25])
    positioner_frame_and_carriage();

    color("red")
    translate([20, diameter==50? -40+2 - 10: -73, -10+eps])
        nortronics_adapter();
}

module nortronics_head(diameter) {
    // nortronics head bounding volume, more or less
    if($preview) {
        color("yellow", 0.5)
        translate([30, diameter == 50? -43 : -70, -15.76/2])
        union() {
            cube([14.12, 16.47, 15.76]);
            translate([-10, 2.25, 15.76/2])
                rotate([0, 90, 0])
                cylinder(20, d=2, center=false);
            translate([-10, 7.34, 15.76/2])
                rotate([0, 90, 0])
                cylinder(20, d=2, center=false);
        }
    }
}

color("blue")
frame_with_adapter_mounts(drum_diameter);

color("green")
translate([30, 0, 0])
rotate([0, 90, 0])
center_drum(7, drum_diameter);

if(style=="opposing") {
    opposing_mounts(drum_diameter);
    nortronics_head(drum_diameter);
} else if( style=="arc") {
    step = drum_diameter==50? -60 : -35;
    for( i=[-30:step:-150]) {
        rotate([i, 0, 0])
            nortronics_head(drum_diameter);

        rotate([i+90, 0, 0])
        translate([-eps, 7.5, drum_diameter==50? 50+7: 75+7])
        rotate([-90, 0, -90])
            positioner_frame_and_carriage();

        rotate([i+90, 0, 0])
        color("red")
        translate([15+eps, 15, drum_diameter==50? 47: 72])
        rotate([-90, 0, -90])
            nortronics_adapter_right_angle();
    }

    color("DarkTurquoise")
    translate([10,0,0])
    arc_mount(drum_diameter);

}