press_fit_tol = 0.3;
diameter = 100;  // diamter of the whole thing
axle_dia = 4.98 + press_fit_tol / 2 ;  // 4.98 as measured


// precision-related
eps = 0.01;
$fn = 100;

include <common.scad>

// "625" bearing dimensions
// bore/ID = 5.0
// OD = 16.0
// width = 5.0
// "2809" bearing dimensions
// bore/ID = 8.0
// OD = 22.0
// width = 7.0
module stand(bearing_size = "625") {
    thickness = 10;

    module make_stand(b_ID, b_OD, b_w, adapter=false) {
        fit_ID = b_ID - press_fit_tol / 2;
        fit_OD = b_OD + press_fit_tol;
        a = b_OD <= 12 ? 12 : b_OD/2+3;
        b = -diameter/2-30;
        difference() {
            // body, outside shape
            linear_extrude(thickness, center=false)
                offset(r=5, delta=5, chamfer=false)
                polygon([[a-5,a-5], [-a+5,a-5], [-40+5, b+5], [40-5, b+5]]);
            // where the bearing presses in
            cylinder(thickness*3, d=fit_OD, center=true);
            // center alignment guide
            translate([0, b+5, -eps]) {
                cylinder(thickness*3, d=axle_dia, center=true);
                press_fit_fix();
            }
            // right alignment guide
            translate([30, b+5, -eps]) {
                cylinder(thickness*3, d=axle_dia, center=true);
                press_fit_fix();
            }
            // left alignment guide
            translate([-30, b+5, -eps]) {
                cylinder(thickness*3, d=axle_dia, center=true);
                press_fit_fix();
            }
            // center cutout, inner shape
            translate([0,0,-eps])
                linear_extrude(thickness+2*eps, center=false)
                    offset(r=5, delta=5, chamfer=false)
                    //       top right    top left      btm left     btm right
                    polygon([[a-5, -a-5], [-a+5, -a-5], [-20, b+20], [20, b+20]]);
            // right mount bolt
            translate([10, b, 10])
                rotate([-90, 0, 0])
                    inset_bolt();
            // left mount bolt
            translate([-20, b, 10])
                rotate([-90, 0, 0])
                    inset_bolt();
            // bearing/axle set screw
            translate([0, 0, thickness / 2])
                rotate([-90, 0, 0])
                    cylinder(a+1, d=2.9, center=false);
        }
        // step to press the bearing against to align it
        difference() {
            cylinder(thickness-b_w, d=b_OD+2);
            translate([0, 0, -eps])
                cylinder(5+2*eps, d=b_OD-2);
        }

        // an axle-to-bearing adapter (works poorly)
        if(adapter) {
            difference() {
                cylinder(thickness, d=fit_ID);
                translate([0, 0, -eps])
                    cylinder(thickness*3, d=axle_dia+press_fit_tol/2, center=true);
            }
        }
    }

    if( bearing_size == "625") {
        make_stand( 5.0, 16.0, 5.0, false);
    } else if( bearing_size == "2809") {
        make_stand( 8.0, 22.0, 7.0, true);
    } else if( bearing_size == "static_axle_5") {
        make_stand( 0, 4.98, 10);
    }
}

translate([0, 0, 30]) {
    color("yellow")
    stand("625");
}

translate([100, 0, 30]) {
    color("orange")
    stand("static_axle_5");
}