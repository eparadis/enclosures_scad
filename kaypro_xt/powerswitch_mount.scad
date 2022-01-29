$fn = 100;

panel_hole = 28.7+.2; // add .2 for tighter fit
panel_thickness = 1;

// kco-117
width = 12.32; // flange 14.95
height = 19.66; // flange 20.93


difference() {
  union(){
    cylinder(h=3, d=panel_hole);
    translate([0,0,0])
      cylinder(h=1, d=panel_hole+2);
    translate([0,0,2])
      cylinder(h=1, d=panel_hole+.4);  // add .4 as a snap ring
  }
  cube([width, height, 10], center=true);
  translate([0, 0, 4])
    cube([width+2, height+2, 6], center=true);
}


