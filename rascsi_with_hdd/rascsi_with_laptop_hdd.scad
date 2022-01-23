// an enclosure for a raspberry pi (model 1, 2, or 3) with a RaSCSI board and 
// a 2.5" laptop HDD connected via USB
// The particular drive I am using has a built-in USB interface, so there is
// no adapter required.

// from p19 https://www.seagate.com/www-content/support-content/samsung/internal-products/spinpoint-m-series/en-us/docs/100772113c.pdf
width_of_drive = 69.85;
length_of_drive = 100.21;
edge_to_hole1 = 90.60;
edge_to_hole2 = 14.00;
height_to_holes = 3.00;

// my specs
support_width = 3;
support_height = 10;
mt_screw_dia = 3;
$fs = 0.1;
clr_under_drive = 3;
epsilon = 0.01;

module drive_supports() {
    translate([width_of_drive/2, 0, 0])
        drive_support();
    translate([-width_of_drive/2, 0, 0])
        drive_support();
}

module drive_support() {
    difference() {
        cube([support_width, length_of_drive, support_height]);
        translate([-epsilon, edge_to_hole1, height_to_holes + clr_under_drive])
            rotate([0, 90, 0])
                cylinder(10, d=mt_screw_dia);
        translate([-epsilon, edge_to_hole2, height_to_holes + clr_under_drive])
            rotate([0, 90, 0])
                cylinder(10, d=mt_screw_dia);
    }
}

module rpi_supports() {
}


union() {
    drive_supports();
    rpi_supports();
}