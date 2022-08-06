
// precision-related
eps = 0.01;
$fn = $preview ? 64 : 256;

use <head_mount.scad>
use <multipart_drum.scad>
use <head_positioner.scad>

color("orange")
translate([27.5, -58, -25])
positioner_frame(15);

color("darkorange")
translate([31.25, -47, -25])
positioner_carriage(15);

color("blue")
frame_with_adapter_mounts(50);

color("green")
translate([30, 0, 0])
rotate([0, 90, 0])
end_cap_flange(7, 50);

color("red")
translate([20, -40+2 - 10, -10+eps])
    nortronics_adapter();

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