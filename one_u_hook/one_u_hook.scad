//! OpenSCAD

// originally made with blockscad3d very quickly, which is why the structure is so odd
// see project: https://www.blockscad3d.com/community/projects/1244617
// I printed their STL successfully, but decided to come back and refactor this to be customizable

// valid between 30 and 80 mm
headband_width = 48;
// TODO tilt_angle = 0;

module _stop_customizer() { }

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

module orig_shape(width=48) {
    module rounded_shelf_tip() {      
        translate([ 0, (width + 10), (5 + 31.75) ]) {
            rotate([ 0, 90, 0 ]) {
                cylinder(r1 = 5, r2 = 5, h = 15.875, center = false);
            }
        }
    }
    
    module shelf_cutout() {
        hull() {
            // round where the upper side of the hook connects to the frame
            translate([ 0-epsilon, 10, (5 + 31.75) ]) {
                rotate([ 0, 90, 0 ]) {
                    cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
                }
            }
            
            // the far inside edge of the hook
            translate([ 0-epsilon, width, (5 + 31.75) ]) {
                rotate([ 0, 90, 0 ]) {
                    cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
                }
            }
        }
        
        // round where the lower side of the hook connects to the frame
        translate([ 0-epsilon, 10-epsilon, 4 ]) {
            rotate([ 0, 90, 0 ]) {
                cylinder(r1 = 5, r2 = 5, h = 15.875+2*epsilon, center = false);
            }
        }
    }

    k = 2;
    difference() {
        union() {
            cube([ 15.875, 5, 44 ], center = false);
            translate([ 0, 0, 36 ]) {
                rotate([ 0, 90, 0 ]) {
                    SAS_Triangle_3D(29.25+k, width+20, 90, 15.875, true);
                }
            }

            // extra material for the lower fillet
            translate([0, 4, 5]) {
                cube([15.875, 5, 10], center = false);
            }
        }

        union() {
            shelf_cutout();
            
            // trim the tip off the triangle
            translate([ 0-epsilon, width+10, 30 ]) {
                cube([ 15.875+2*epsilon, 20, 10 ], center = false);
            }
        }
    }
    rounded_shelf_tip();
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


module hook(width) {
    difference() {
        orig_shape(width);
        translate([ (15.875 / 2), 0, 6.35 ]) screw_clearance();
        translate([ (15.875 / 2), 0, (6.35 + 31.75) ]) screw_clearance();
    }
}

color([ 1, 0.8, 0 ])
hook(headband_width);

for(i = [20, 40, 60, 80, 100, 120]) {
    color( [i/120, 0.5, 0.5]) translate([-i*2, 0, 0]) hook(i);
}