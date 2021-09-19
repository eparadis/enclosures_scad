

module case() {
    union() {
        translate([0, 0, 4]) {
            import("cp-box-case.stl"); // from https://www.thingiverse.com/thing:2585702/files
        }

        translate([47.81/-2, 4, 0]) {
            union() {
                k = 0.4; // "resize to 0.04 to be lego compatibilal (sic)"
                scale([k, k, k]) {
                    translate([0, 200, 0]) {
                        rotate([90,0,0]) {
                            import("plate_4x6.stl"); // from https://www.thingiverse.com/thing:671044/files 
                        }
                    }
                }
                translate([0, -20, 3]) {
                    cube([47.81, 32, 2]);
                }
            }
        }
    }


}


case();
