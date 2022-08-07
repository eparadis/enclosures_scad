
// there are more than one configuration:
// "opposing"
// "arc"
style = "arc";
// style = "opposing";

// precision-related
eps = 0.01;
$fn = $preview ? 64 : 256;

use <head_mount.scad>
use <multipart_drum.scad>
use <head_positioner.scad>

module positioner_frame_and_carriage() {
    color("orange")
    positioner_frame(15);

    color("darkorange")
    translate([3.75, 11, 0])
    positioner_carriage(15);
}

module opposing_mounts() {
    translate([27.5, -58, -25])
    positioner_frame_and_carriage();

    color("red")
    translate([20, -40+2 - 10, -10+eps])
        nortronics_adapter();
}

module nortronics_head() {
    // nortronics head bounding volume, more or less
    if($preview) {
        color("yellow")
        translate([30, -42, -15.76/2])
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
frame_with_adapter_mounts(50);

color("green")
translate([30, 0, 0])
rotate([0, 90, 0])
end_cap_flange(7, 50);

if(style=="opposing") {
    opposing_mounts();
    nortronics_head();
} else if( style=="arc") {
    for( i=[-30:-60:-150]) {
        rotate([i, 0, 0])
            nortronics_head();
        rotate([i+90, 0, 0])
        translate([0, 7.5, 50+7])
        rotate([-90, 0, -90])
            positioner_frame_and_carriage();
    }

    color("DarkTurquoise")
    translate([10,0,0])
    arc_mount(50);

}