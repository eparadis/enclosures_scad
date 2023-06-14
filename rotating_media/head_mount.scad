
axle_press_fit = 5;

// precision-related
eps = 0.01;
$fn = 100;
thread_M3 = 3.0; // diameter where an M3 will self thread
cap_M3 = 6.0; // diameter where the head of an M3 will fit inside for counter sinking
horiz_thread_M3 = thread_M3 - 0.1; // horizontal holes need to smaller to properly thread. May need adjustment

module frame(diameter, thickness, axial_length, radial_width, attached_to_frame) {
    difference() {
        // outside
        cube([axial_length, radial_width, thickness]);
        // inside cutout for drum
        translate([thickness, thickness, -eps])
            cube([axial_length-thickness*2, radial_width-thickness*2, thickness+2*eps]);
    }

    module axle_mount_full() {
        difference() {
            // body
            cube([thickness, thickness*3, thickness*1.5]);
            // hole for axle
            translate([-eps, thickness/2+thickness, thickness/2])
            rotate([0, 90, 0])
                cylinder(thickness+2*eps, d=axle_press_fit, center=false);
            // hole for set screw
            translate([thickness/2, thickness/2+thickness, thickness/2])
                cylinder(thickness*10, d=thread_M3, center=false);
            // mounting screws
            translate([thickness/2, thickness/2, -eps])
                cylinder(thickness*10, d=horiz_thread_M3, center=false);
            translate([thickness/2, thickness/2+2*thickness, -eps])
                cylinder(thickness*10, d=horiz_thread_M3, center=false);
            // mounting screw counter sinks
            translate([thickness/2, thickness/2, thickness])
                cylinder(thickness/2+eps, d=cap_M3, center=false);
            translate([thickness/2, thickness/2+2*thickness, thickness])
                cylinder(thickness/2+eps, d=cap_M3, center=false);
        }
    }

    module frame_mount_full() {
        // the frame mounts are 30mm offset
        difference() {
            // body
            cube([thickness, thickness*4, thickness*1.2]);
            // hole for axle to pass through
            translate([-eps, thickness/2+thickness*1.5, thickness/2])
            rotate([0, 90, 0])
                cylinder(thickness+2*eps, d=axle_press_fit*1.5, center=false);
            // holes to mount to frame
            translate([-eps, thickness/2, thickness/2])
            rotate([0, 90, 0])
                cylinder(thickness*10, d=thread_M3, center=false);
            translate([-eps, thickness/2+30, thickness/2])
            rotate([0, 90, 0])
                cylinder(thickness*10, d=thread_M3, center=false);
        }
    }

    module split_axle_mount() {
        // bottom half
        difference() {
            axle_mount_full();
            translate([-eps,-eps,thickness/2])
                cube([thickness+2*eps, thickness*3+2*eps, thickness*1.5]);
        }

        // top half. moved upwards for printing
        translate([0,0, thickness/2])
        difference() {
            axle_mount_full();
            translate([-eps,-eps,-thickness*2/2])
                cube([thickness+2*eps, thickness*3+2*eps, thickness*1.5]);
        }
    }

    if(!attached_to_frame) {
        // left axle mount
        translate([0, radial_width/2-thickness/2-thickness, thickness-eps])
            split_axle_mount();
        // right axle mount
        translate([axial_length-thickness, radial_width/2-thickness/2-thickness, thickness-eps])
            split_axle_mount();
    } else {
        // left frame mount
        translate([0, radial_width/2-thickness*2, thickness-eps])
            frame_mount_full();
        //right frame mount
        translate([axial_length-thickness, radial_width/2-thickness*2, thickness-eps])
            frame_mount_full();
    }
}

module frame_with_adapter_mounts(diameter, attached_to_frame=false) {
    thickness = 10;
    distance_above_cylinder = 3;
    axial_length = 100+thickness*2; // 100mm inside, 10mm on each end for the frame
    radial_width = diameter + thickness*2 + distance_above_cylinder * 2;
    mount_spacing = 10; // dist between mounting holes
    translate([0, -radial_width/2, -thickness*1.5])
    difference() {
        frame(50, thickness, axial_length, radial_width, attached_to_frame);
        for (axl_offset=[0:mount_spacing:(axial_length-30)]) {
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

module arc_mount(diameter) {
    
    module arc() {
        rotate([90,0,90])
        rotate_extrude(angle = 180, convexity = 2)
        translate([diameter/2+3, 0, 0])
        square([10, 5], center=false);
    }

    module foot() {
        translate([0,diameter/2+3, -10+eps])
        difference() {
            cube([30, 10, 10]);
            for(i=[0:10:20])
                translate([5+i, 5, -eps])
                cylinder(10+2*eps, d=3, center=false);
        }
    }

    module perpendicular_mount_pattern() {
        translate([-eps, 0, diameter/2+3+4])
        rotate([0, 90, 0]) {
            cylinder(15, d=3, center=false); // center
            translate([0, -10, 0])
                cylinder(15, d=3, center=false); // left
            translate([0, 10, 0])
                cylinder(15, d=3, center=false); // right
        }
        
    }

    difference() {
        arc();
        step =diameter==50? 60 : diameter==75? 40: 35;;
        for( i=[60:-step:-60]) {
            rotate([i, 0, 0])
                perpendicular_mount_pattern(); // left
        }
    }

    // perpendicular_mount_pattern();

    mirror([0,1,0])
    foot();

    foot();
}

use <multipart_drum.scad>

color("lightblue")
frame_with_adapter_mounts(50);

color("lightgreen")
translate([0, 100, 0])
    frame_with_adapter_mounts(50, true);

// color("green")
// translate([30, 0, 0])
// rotate([0, 90, 0])
// center_drum(10, 50);

// color("DarkTurquoise")
// translate([10+eps,0,eps])
// arc_mount(50);