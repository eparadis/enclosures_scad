$fs=.5;

module front_panel(width=3) {
    translate([0,0,0])
        cube([width, 30, 3]);
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

top_slope = 60;
front_height = 15;


module side_support() {
    hull()
        union() {
            translate([0, cos(90-top_slope)*3, front_height])
                rotate([top_slope, 0, 0])
                    front_panel();

            scale([1, 2, 1])
                front_panel();

            translate([0, 3, 0])
            scale([1, 1, (front_height + 3*cos(top_slope))/30])
                rotate([90, 0, 0])
                    front_panel();
    }
}
module ridge_for_faceplate(width=3, side="left") {
    translate([0, cos(90-top_slope)*6, front_height-sin(90-top_slope)*3])
        rotate([top_slope, 0, 0])
            difference() {
                scale([1, .9, 1])
                    front_panel(width);
                translate([width/2, 2, -.01])
                    cylinder(5, d=2.2);
                translate([width/2, 25, -.01])
                    cylinder(5, d=2.2);
                if( side == "left")
                    translate([8, 13.5, -.01])
                        cylinder(5, d=20);
                else
                    translate([-2, 13.5, -.01])
                        cylinder(5, d=20);
            }
}

// left side
side_support();
translate([3 - .01, 0, 0])
    ridge_for_faceplate(5, "left");

// right side
translate([30, 0, 0])
    side_support();
translate([30 - 5 + .01, 0, 0])
    ridge_for_faceplate(5, "right");


