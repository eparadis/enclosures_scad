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

// from PDFs here: https://www.raspberrypi.com/documentation/computers/raspberry-pi.html
rpi_mt_shelf_dia = 6;
rpi_mt_spacing_length = 58;
rpi_mt_spacing_width = 49;
rpi_length_of_board = 85;
rpi_width_of_board = 56;
rpi_mt_hole_dia = 2.75;
clr_under_rpi = 3;
clr_mt_stud = 0.05;
mt_stud_height = 3;

// my specs
support_width = 3;
support_height = 10;
mt_screw_dia = 3;
$fs = 0.1;
clr_under_drive = 3;
epsilon = 0.01;
clr_drive_width = 0.05;

module rpi_supports() {
    // (rpi_length_of_board - rpi_mt_spacing_length) / 2
    // rpi_mt_spacing_width/2
    translate([rpi_mt_spacing_width/2, 0, 0])
        rpi_supports_half();
    translate([-rpi_mt_spacing_width/2, 0, 0])
        rpi_supports_half();
}

module rpi_supports_half() {
    translate([0, (rpi_length_of_board - rpi_mt_spacing_length) / 2, 0]) {
        cylinder(h=clr_under_rpi, d=rpi_mt_shelf_dia);
        cylinder(h=clr_under_rpi + mt_stud_height, d=rpi_mt_hole_dia - clr_mt_stud);
    }
    translate([0, rpi_length_of_board - (rpi_length_of_board - rpi_mt_spacing_length) / 2, 0]) {
        cylinder(h=clr_under_rpi, d=rpi_mt_shelf_dia);
        cylinder(h=clr_under_rpi + mt_stud_height, d=rpi_mt_hole_dia - clr_mt_stud);
    }
}



module drive_supports() {
    translate([width_of_drive/2 + clr_drive_width, 0, 0])
        drive_support();
    translate([-width_of_drive/2 - clr_drive_width, 0, 0])
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

union() {
    translate([-width_of_drive/2 - 10, 0, 0])
        drive_supports();
    translate([rpi_width_of_board/2 + 10, 0, 0])
        rpi_supports();
}


// mock up volumes of the drive and rpi to check fit
module laptop_hdd() {
    color("red")
        cube([length_of_drive, width_of_drive, 15]);
}

module rpi123() {
    color("yellow")
        cube([rpi_length_of_board, rpi_width_of_board + 3, 16]);
}