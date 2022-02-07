
sigma = 0.001;
$fs = 0.01;

module top_board_support(height) {
  support_side = 8.8; // the support pad areas are square
  board_hole_dia = 3.5;
  screw_hole_dia = 2.8; // TODO what should this be?
  
  hole_offset_x = (111.0-102.5)/2;
  hole_offset_y = (92.8-84.8)/2;
  
  %color("green")
    translate([0,0,height+sigma*2])
    difference() {
      cube([111.0, 92.8, 1.6]);
      for( i=[hole_offset_x, 111.0-hole_offset_x], j=[hole_offset_y, 92.8-hole_offset_y])
        translate([i,j,-sigma])
          cylinder(h=4, d=board_hole_dia, center=true);
    }
  
  difference() {
    union() {
      translate([hole_offset_x, hole_offset_y, height/2])
        cube([support_side, support_side, height], center=true);
      translate([111.0-hole_offset_x, hole_offset_y, height/2])
        cube([support_side, support_side, height], center=true);
      translate([hole_offset_x, 92.8-hole_offset_y, height/2])
        cube([support_side, support_side, height], center=true);
    }
    for( i=[hole_offset_x, 111.0-hole_offset_x], j=[hole_offset_y, 92.8-hole_offset_y])
        translate([i, j, -sigma])
          cylinder(h=height*3, d=screw_hole_dia, center=true);
  }
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
      translate([i, j, height/2])
        difference() {
          cylinder(h=height, d=support_dia, center=true);
          translate([0,0,-sigma])
            cylinder(h=height*3, d=screw_hole_dia, center=true);
        }
}

bottom_board_support(3);
//top_board_support(6);