//! OpenSCAD

// made with blockscad3d very quickly ;)
// see project: https://www.blockscad3d.com/community/projects/1244617
// I printed their STL successfully

epsilon = 0.01;
$fn = 20;

module SAS_Triangle_3D(s1, s2, a, h, valid) {
    if (valid) {
        linear_extrude(height = h, twist = 0, center = false) polygon(
            points = [ [ 0, 0 ], [ s1, 0 ], [ s2 * cos(a), s2 * sin(a) ] ]);
    } else {
        cylinder(r = 0.5, $fn = 12, height = h);
        translate([ s1, 0, 0 ]) cylinder(r = 0.5, $fn = 12, height = h);
        hull() {
            cylinder(r = 0.25, $fn = 12, height = h);
            translate([ s1, 0, 0 ]) cylinder(r = 0.25, $fn = 12, height = h);
        }
        rotate([ 0, 0, a ]) {
            translate([ s2, 0, 0 ]) cylinder(r = 0.5, $fn = 12, height = h);
            hull() {
                cylinder(r = 0.25, $fn = 12, height = h);
                translate([ s2, 0, 0 ])
                    cylinder(r = 0.25, $fn = 12, height = h);
            }
        }
        linear_extrude(height = h, twist = 0, center = false)
            invalid_triangle_arc(min(s1, s2) / 4, 0.5, a);
    }
}
module basic_shape() {
    k = 2;
    color([ 1, 0.8, 0 ]) {
        difference() {
            union() {
                cube([ 15.875, 5, 44 ], center = false);
                translate([ 0, 0, 36 ]) {
                    rotate([ 0, 90, 0 ]) {
                        SAS_Triangle_3D(29.25+k, 68, 90, 15.875, true);
                    }
                }
                translate([0, 4, 5]) {
                    cube([15.875, 5, 10], center = false);
                }
            }

            union() {
                translate([ (15.875 / 2), 0, 6.35 ]) {
                    screw_clearance();
                }
                translate([ (15.875 / 2), 0, (6.35 + 31.75) ]) {
                    screw_clearance();
                }
                shelf_cutout();
                // skeletonize_cutouts();
            }
        }
    }
}

module rounded_shelf_tip() {
    color([ 1, 0.8, 0 ]) {
        translate([ 0, (48 + 10), (5 + 31.75) ]) {
            rotate([ 0, 90, 0 ]) {
                cylinder(r1 = 5, r2 = 5, h = 15.875, center = false);
            }
        }
    }
}

module screw_clearance() {
    rotate([ 270, 0, 0 ]) {
        union() {
            cylinder(r1 = 3, r2 = 3, h = 10, center = false);
            translate([ 0, 0, 5 ]) {
                cylinder(r1 = 5, r2 = 5, h = 10, center = false);
            }
        }
    }
}

module shelf_cutout() {
    hull() {
        translate([ 0-epsilon, 10, (5 + 31.75) ]) {
            rotate([ 0, 90, 0 ]) {
                cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
            }
        }
        translate([ 0-epsilon, 48, (5 + 31.75) ]) {
            rotate([ 0, 90, 0 ]) {
                cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
            }
        }
    }
    translate([ 0-epsilon, 10-epsilon, 4 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
        }
    }
}

module skeletonize_cutouts() {
    slope = 29.25 / 68; // rise over run
    zstart = 17.5;
    for (i=[0:2]) {
        translate([ 0-epsilon, 10+10*i, zstart+slope*10*i ]) {
            rotate([ 0, 90, 0 ]) {
                cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
            }
        }
    }
    translate([ 0-epsilon, 12, 26 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder(r1 = 2.5, r2 = 2.5, h = 15.875+2*epsilon, center = false);
        }
    }
    translate([ 0-epsilon, 23, 29 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder(r1 = 2, r2 = 2, h = 15.875+2*epsilon, center = false);
        }
    }
    translate([ 0-epsilon, 10+10*3, zstart+slope*8*3 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder(r1 = 2.5, r2 = 2.5, h = 15.875+2*epsilon, center = false);
        }
    }
}

union() {
    difference() {
        basic_shape();

        color([ 0.93, 0, 0 ]) {
            translate([ 0-epsilon, 58, 30 ]) {
                cube([ 15.875+2*epsilon, 20, 10 ], center = false);
            }
        }
    }
    rounded_shelf_tip();
}