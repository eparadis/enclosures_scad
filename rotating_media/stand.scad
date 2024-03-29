press_fit_tol = 0.3;
diameter = 100;  // diamter of the whole thing
axle_dia = 4.98 + press_fit_tol / 2 ;  // 4.98 as measured


// precision-related
eps = 0.02;
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

    module make_stand(b_ID, b_OD, b_w, adapter=false, upper_mounting=false) {
        fit_ID = b_ID - press_fit_tol / 2;
        fit_OD = b_OD + press_fit_tol;
        a = (b_OD <= 12 ? 12 : b_OD/2+3) * (upper_mounting ? 1.5 : 1.0);
        b = -diameter/2-30;
        difference() {
            // body, outside shape
            linear_extrude(thickness, center=false)
                offset(r=5, delta=5, chamfer=false)
                if( upper_mounting)
                    //       top right   top left     btm left      btm right
                    polygon([[a-2,a-10], [-a+2,a-10], [-40+5, b+5], [40-5, b+5]]);
                else
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
            translate([0,0,-2*eps])
                linear_extrude(thickness+4*eps, center=false)
                    offset(r=5, delta=5, chamfer=false)
                    if(upper_mounting)
                    //           top right    top left      btm left     btm right
                        polygon([[a-6, -a-0], [-a+6, -a-0], [-20, b+20], [20, b+20]]);
                    else
                        polygon([[a-5, -a-5], [-a+5, -a-5], [-20, b+20], [20, b+20]]);
            // right mount bolt
            translate([10, b, 0])
                    inset_bolt();
            // left mount bolt
            translate([-20, b, 0])
                    inset_bolt();
            // bearing/axle set screw
            translate([0, 0, thickness / 2])
                rotate([-90, 0, 0])
                    cylinder(a+1, d=2.9, center=false);
            // upper mounting holes for attaching a fixed head frame
            if( upper_mounting ) {
                translate([-5-15, -5, 0])
                    inset_bolt();
                translate([-5+15, -5, 0])
                    inset_bolt();
            }
        }
        // step to press the bearing against to align it
        difference() {
            translate([0, 0, thickness/2])
              cylinder(thickness-b_w, d=b_OD+2);
            translate([0, 0, thickness/2-eps])
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
    } else if( bearing_size == "625v2") {
        make_stand( 5.0, 16.0, 5.0, false, true);
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

translate([200, 0, 30]) {
    color("green")
    stand("625v2");
}