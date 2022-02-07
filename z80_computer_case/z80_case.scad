
sigma = 0.001;
$fs = 0.01;

module top_board_support() {
}

module bottom_board_support(height) {
  support_dia = 8.2;
  board_hole_dia = 3.0;
  screw_hole_dia = 2.8; // TODO what should this be?
  
  hole_offset = (100.0-92.1)/2;
  %color("green")
    translate([0,0,height])
    difference() {
      cube([100.0, 100.2, 1.6]);
      union() {
        for( i=[hole_offset, 100.0-hole_offset], j=[hole_offset, 100.2-hole_offset])
          translate([i, j, -sigma])
            cylinder(h=4, d=board_hole_dia, center=true);
      }
    }
  
    for( i=[hole_offset, 100.0-hole_offset], j=[hole_offset, 100.2-hole_offset])
      translate([i, j, 0])
        difference() {
          cylinder(h=height, d=support_dia, center=true);
          translate([0,0,-sigma])
            cylinder(h=height+4*sigma, d=screw_hole_dia, center=true);
        }
}

bottom_board_support(3);