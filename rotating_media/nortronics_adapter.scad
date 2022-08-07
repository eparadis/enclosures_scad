
// precision-related
eps = 0.01;
$fn = 100;
thread_M3 = 3.0; // diameter where an M3 will self thread

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

module nortronics_adapter_right_angle() {
    // aluminum block is 15.76
    // threaded mounting holes aligned with R/W head are centered, so 15.76/2
    // head surface is 16.47 from back of aluminum block
    
    module plate() {
        difference() {
            cube([30, 20, 2]);
            // mounting holes to frame or positioner
            translate([5, 15, -eps])
                cylinder(15, d=thread_M3, center=true);
            translate([25, 15, -eps])
                cylinder(5, d=thread_M3, center=true);
            translate([5, 5, -eps])
                cylinder(15, d=thread_M3, center=true);
            translate([25, 5, -eps])
                cylinder(5, d=thread_M3, center=true);
            // cutout to allow reaching head mounting bolts
            hull(){
                a = -eps;
                b = 15;
                translate([b, 15, a])
                    cylinder(100, d=6, center=false);
                translate([b, 5, a])
                    cylinder(100, d=6, center=false);
            }
        }
    }

    plate();
    
    // mount
    difference() {
        translate([10,0,2])
            cube([10, 20, 10]);
        
        // slot
        hull() {
            a = 2-eps;
            b = 15;
            translate([b, 15, a])
                cylinder(10+2*eps, d=2.5, center=false);
            translate([b, 5, a])
                cylinder(10+2*eps, d=2.5, center=false);
        }
    
        // cutout to allow reaching head mounting bolts
        hull() {
            a = -5;
            b = 15;
            translate([b, 15, a])
                cylinder(10+2*eps, d=6, center=false);
            translate([b, 5, a])
                cylinder(10+2*eps, d=6, center=false);
        }
    }
}



translate([0, 0, 0])
    nortronics_adapter_right_angle();

translate([100, 0, 0])
    nortronics_adapter();