
axle_press_fit = 5 - 0.2;

// precision-related
eps = 0.01;
$fn = 100;

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
                cylinder(thickness*1.5, d=3, center=false);
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
    distance_above_cylinder = 3;
    axial_length = 70;
    radial_width = diameter + distance_above_cylinder * 2;
    thickness = 10;
    mount_spacing = 10; // dist between mounting holes
    difference() {
        frame(50, thickness, axial_length, radial_width);
        for (axl_offset=[0:mount_spacing:40]) {
            translate([axl_offset+thickness+mount_spacing/2, thickness/2, -eps]) {
                cylinder(thickness+2*eps, d=3, center=false);
                translate([0, diameter-thickness/2+1.5, 0])
                    cylinder(thickness+2*eps, d=3, center=false);
            }
        }
        translate([thickness, -eps, 5])
            cube([axial_length-2*thickness, radial_width+2*eps, 5+eps]);
    }
}

frame_with_adapter_mounts(50);
