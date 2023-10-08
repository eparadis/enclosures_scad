//! OpenSCAD

// originally made with blockscad3d very quickly, which is why the structure is so odd
// see project: https://www.blockscad3d.com/community/projects/1244617
// I printed their STL successfully, but decided to come back and refactor this to be customizable

include <BOSL2/std.scad>

// valid between 30 and 80 mm
headband_width = 48;
// TODO tilt_angle = 0;

module _stop_customizer() { }

epsilon = 0.01;
$fn = 32;

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

module profile(width) {
    support_angle=atan2(width+5+5+5,32.4-5);
    tcmds = [
        "move",5, "left",90, "move", 5,
        "arcright",5,support_angle, "untily",6.35 + 31.75-5-1,
        "arcleftto",5,270, "arcright",5,90,
        "untilx",5+5, "arcright",5,90,
        "untily",44, "left",90, "move",5,
    ];
    path = turtle(tcmds);
    polygon(path);
}

module new_hook(width) {
    difference() {
        rotate([0,90,0]) rotate([0,0,90]) linear_extrude(15.875, convexity=10) profile(width);
        translate([ (15.875 / 2), 0, 6.35 ]) screw_clearance();
        translate([ (15.875 / 2), 0, (6.35 + 31.75) ]) screw_clearance();
    }
}

translate([20, 0, 0])
color([ 0, 1, 1])
new_hook(headband_width);

for(i = [20, 40, 60, 80, 100, 120]) {
    color( [i/120, 0.5, 0.5]) translate([-i*2, 0, 0]) new_hook(i);
}