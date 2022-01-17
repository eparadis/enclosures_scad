

module front_panel() {
    translate([0,0,0])
        cube([25*5, 30, 3]);
}

module button_hole() {
    cylinder(80, d=16, center=true);
    rear_clearance_depth = 10;
    translate([0, 0, -2 - rear_clearance_depth])
        cylinder(rear_clearance_depth*2, d=20, center=true);
}

module button_holes() {
    x_spacing = 25;
    x_offset = x_spacing / 2;
    y_offset = 30/2;
    for(i = [0:4]) {
        translate([x_offset + x_spacing * i, y_offset, 0 ])
            button_hole();
    }
}


top_slope = 40;

difference() {
    hull() {
        translate([0, cos(90-top_slope)*3, 40])
            rotate([top_slope, 0, 0])
                front_panel();
        scale([1, 1.5, 1])
            front_panel();
    }

    translate([0, 0, 40])
        rotate([top_slope,0,0,])
            button_holes();

    translate([4, 4, 4])
        cube([25*5-2*4, 1.5*30, 40-3]);

}
