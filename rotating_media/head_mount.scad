
axle_press_fit = 5;

// precision-related
eps = 0.01;
$fn = 100;
thread_M3 = 3.0; // diameter where an M3 will self thread

module frame(diameter, thickness, axial_length, radial_width) {
    difference() {
        // outside
        cube([axial_length, radial_width, thickness]);
        // inside cutout for drum
        translate([thickness, thickness, -eps])
            cube([axial_length-thickness*2, radial_width-thickness*2, thickness+2*eps]);
    }

    module axle_mount() {
        difference() {
            // body
            cube([thickness, thickness, thickness*1.5]);
            // hole for axle
            translate([-eps, thickness/2, thickness/2])
            rotate([0, 90, 0])
                cylinder(thickness+2*eps, d=axle_press_fit, center=false);
            // hole for set screw
            translate([thickness/2, thickness/2, thickness/2])
                cylinder(thickness*1.5, d=thread_M3, center=false);
        }
    }

    // left axle mount
    translate([0, radial_width/2-thickness/2, thickness-eps])
        axle_mount();
    // right axle mount
    translate([axial_length-thickness, radial_width/2-thickness/2, thickness-eps])
        axle_mount();
}
module frame_with_adapter_mounts(diameter) {
    thickness = 10;
    distance_above_cylinder = 3;
    axial_length = 70;
    radial_width = diameter + thickness*2 + distance_above_cylinder * 2;
    mount_spacing = 10; // dist between mounting holes
    translate([0, -radial_width/2, -thickness*1.5])
    difference() {
        frame(50, thickness, axial_length, radial_width);
        for (axl_offset=[0:mount_spacing:40]) {
            translate([axl_offset+thickness+mount_spacing/2, thickness/2, -eps]) {
                cylinder(thickness+2*eps, d=thread_M3, center=false);
                translate([0, radial_width-thickness, 0])
                    cylinder(thickness+2*eps, d=thread_M3, center=false);
            }
        }
        translate([thickness, -eps, 5])
            cube([axial_length-2*thickness, radial_width+2*eps, 5+eps]);
    }
}

module nortronics_adapter() {
    // aluminum block is 15.76
    // threaded mounting holes aligned with R/W head are centered, so 15.76/2
    // head surface is 16.47 from back of aluminum block
    // mount
    difference() {
        union() {
            cube([30, 20, 2]);
            translate([0,0,2])
                cube([10, 20, 15]);
        }
        // holes in plate
        translate([5, 15, -eps])
            cylinder(15, d=thread_M3, center=true);
        translate([25, 15, -eps])
            cylinder(5, d=thread_M3, center=true);
        translate([5, 5, -eps])
            cylinder(15, d=thread_M3, center=true);
        translate([25, 5, -eps])
            cylinder(5, d=thread_M3, center=true);
        // slot
        hull(){
            translate([-eps, 15, 15.76/2+2])
            rotate([0, 90, 0])
                cylinder(10+2*eps, d=2.25, center=false);
            translate([-eps, 5, 15.76/2+2])
            rotate([0, 90, 0])
                cylinder(10+2*eps, d=2.25, center=false);
        }
    }
}

module arc_mount(diameter) {
    rotate([90,0,90])
    rotate_extrude(angle = 180, convexity = 2)
    translate([diameter/2+3, 0, 0])
    square(10, center=false);

    module foot() {
        translate([0,diameter/2+3, -10+eps])
        difference() {
            cube([30, 10, 10]);
            for(i=[0:10:20])
                translate([5+i, 5, -eps])
                cylinder(10+2*eps, d=3, center=false);
        }
    }

    mirror([0,1,0])
    foot();

    foot();
}

use <multipart_drum.scad>

color("blue")
frame_with_adapter_mounts(50);

color("green")
translate([30, 0, 0])
rotate([0, 90, 0])
center_drum(10, 50);

color("DarkTurquoise")
translate([10,0,0])
arc_mount(50);