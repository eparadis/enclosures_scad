// an enclosure for a raspberry pi (model 1, 2, or 3) with a RaSCSI board and 
// a 2.5" laptop HDD connected via USB
// The particular drive I am using has a built-in USB interface, so there is
// no adapter required.

// from p19 https://www.seagate.com/www-content/support-content/samsung/internal-products/spinpoint-m-series/en-us/docs/100772113c.pdf
drive_width = 69.85;
drive_length = 100.21;
drive_height = 8.00;
edge_to_hole1 = 90.60;
edge_to_hole2 = 14.00;
hole_height = 3.00;

// from PDFs here: https://www.raspberrypi.com/documentation/computers/raspberry-pi.html
// board dimensions
rpi_board_length = 85;
rpi_board_width = 56;
// mounting holes
rpi_mt_shelf_dia = 6;
rpi_mt_spacing_length = 58;
rpi_mt_spacing_width = 49;
rpi_mt_hole_dia = 2.75;
rpi_mt_edge_offset = 3.5;

// my specs
$fs = 0.1;
epsilon = 0.01;
support_width = 3;
//box_top_height = 20;
mt_screw_dia = 3;
clr_under_drive = 3;
clr_above_drive = clr_under_drive;
clr_drive_width = 0.05;
clr_under_rpi = 3;
//clr_mt_stud = 0.05;
//mt_stud_height = 3;
//lid_width = drive_width + 2*(support_width+clr_drive_width);
//lid_length = drive_length + 2*support_width;


case_top_offset = 30; // the bottom of the "top" of the case
case_bottom_height = 25;
case_inner_width = clr_drive_width*2 + drive_width;
case_thickness = 2;
case_outer_width = case_thickness*2 + case_inner_width;
case_inner_length = drive_length + 2 + 2; // just some arbitrary clearance...
case_outer_length = case_inner_length + case_thickness*2;
case_inner_height = case_top_offset + clr_under_drive + drive_height + clr_above_drive - case_thickness;
case_outer_height = case_inner_height + case_thickness*2;
lid_thickness = case_thickness;

module case_shell() {
    difference() {
        translate([ -(case_thickness+clr_drive_width),
                    -(case_thickness),
                    0 ])
            cube([case_outer_width, case_outer_length, case_outer_height]);
        translate([0,0, case_thickness])
            cube([case_inner_width, case_inner_length, case_inner_height]);
    }
}

module case_shell_bottom() {
    difference() {
        case_shell();
        translate([-100, -100, case_top_offset+epsilon])
            cube([200, 300, 200]);
        translate([-6, 26.5, 13+clr_under_rpi + lid_thickness])
            cube([19, 53.2, 12.5]);
        translate([0, 0, clr_under_rpi + lid_thickness])
                cube([rpi_board_width, 3, 16]);
    }
}

module case_shell_top() {
    difference() {
        case_shell();
        translate([-100, -100, -200+case_top_offset])
            cube([200, 300, 200]);
    }
}

color("lightgrey") translate([epsilon, epsilon, epsilon]) case_shell_bottom();
//color("lightblue") case_shell_top();

module rpi_supports() {
    translate([rpi_mt_spacing_width/2, 0, 0])
        rpi_supports_half();
    translate([-rpi_mt_spacing_width/2, 0, 0])
        rpi_supports_half();
}

module rpi_supports_half() {
    translate([0, (rpi_board_length - rpi_mt_spacing_length) / 2, 0]) {
        cylinder(h=clr_under_rpi, d=rpi_mt_shelf_dia);
        cylinder(h=clr_under_rpi + mt_stud_height, d=rpi_mt_hole_dia - clr_mt_stud);
    }
    translate([0, rpi_board_length - (rpi_board_length - rpi_mt_spacing_length) / 2, 0]) {
        cylinder(h=clr_under_rpi, d=rpi_mt_shelf_dia);
        cylinder(h=clr_under_rpi + mt_stud_height, d=rpi_mt_hole_dia - clr_mt_stud);
    }
}

module drive_supports() {
    translate([ -clr_drive_width - support_width, 0, 0])
        drive_support();
    translate([drive_width + clr_drive_width, 0, 0])
        drive_support();
}

module drive_support() {
    color("purple")
    difference() {
        cube([support_width, lid_length, box_top_height]);
        translate([-epsilon, edge_to_hole1, hole_height + clr_under_drive+lid_thickness])
            rotate([0, 90, 0])
                cylinder(10, d=mt_screw_dia);
        translate([-epsilon, edge_to_hole2, hole_height + clr_under_drive+lid_thickness])
            rotate([0, 90, 0])
                cylinder(10, d=mt_screw_dia);
    }
}

module case_bottom() {

    translate([-support_width-clr_drive_width, -support_width, 0])
        cube([lid_width, lid_length, lid_thickness]);
    translate([-support_width-clr_drive_width, -support_width+epsilon, 0])
        cube([lid_width, support_width, case_bottom_height]);
    translate([rpi_board_width/2, 0, lid_thickness-epsilon])
        rpi_supports();
}

module case_top() {
    // top lid
    translate([-support_width-clr_drive_width, -support_width,
        case_top_offset+box_top_height])
            cube([lid_width, lid_length, lid_thickness]);

    // sides
    translate([0, 0, case_top_offset])
        drive_supports();

    // front
    translate([-support_width-clr_drive_width, -support_width, case_top_offset])
        cube([lid_width, support_width, box_top_height]);
    // TODO there needs to be a cutout in the front piece for the drive USB connector(s)
    
    // back
    translate([-support_width-clr_drive_width, lid_length - 2*support_width, case_top_offset])
        cube([lid_width, support_width, box_top_height]);
}


// mock up volumes of the drive and rpi to check fit
module laptop_hdd() {
    color("red")
        cube([drive_width, drive_length, drive_height]);

    // USB connector clearance
    color("orange")
        translate([35, -4, 0])
            cube([19, 4, 8]);

    // mounting screws
    color("green")
    translate([-10, edge_to_hole1, hole_height])
            rotate([0, 90, 0])
                cylinder(drive_width+20, d=mt_screw_dia);
    color("green")
    translate([-10, edge_to_hole2, hole_height])
            rotate([0, 90, 0])
                cylinder(drive_width+20, d=mt_screw_dia);
}

module rpi123() {
    color("yellow")
        translate([0, 3, 0])
            cube([rpi_board_width, rpi_board_length, 16]);
    color("orange")
        cube([rpi_board_width, 3, 16]); // USB and ethernet connector overhang
    color("orange")
        translate([-6, 26.5, 13])
            cube([19, 53.2, 12.5]);
}

module fit_check_volumes() {
    translate([0, 3, case_top_offset + clr_under_drive])
        laptop_hdd();
    translate([0 , 0, clr_under_rpi + lid_thickness])
        rpi123();
}

//case_top();
//case_bottom();
%fit_check_volumes();

