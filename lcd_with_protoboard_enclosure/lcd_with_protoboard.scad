
// 2x16 character LCD sitting in front of a "half length" protoboard
// originally used for the climate_display prototype

// design questions
// 1. what angle should the LCD be for optimal desktop and shelftop viewing?
// 2. how much clearance should remain for a potential battery?
// 

front_face_width = 85;
depth = 70; // foot print depth
front_face_height = 50;
front_face_tilt = 15; // degrees from vertical
hull_thickness = 2;
top_depth = 10; // the depth of the flat surface on top

module side_profile() {
  points =[
    [0,0], 
    [depth, 0],
    [sin(front_face_tilt)*front_face_height+top_depth, cos(front_face_tilt)*front_face_height],
    [sin(front_face_tilt)*front_face_height, cos(front_face_tilt)*front_face_height],
  ];

  $fs = 0.01;
  offset(r = hull_thickness)
  offset(delta = -hull_thickness, chamfer=false)
  polygon(points = (points), convexity = 10);
}

module side_profile_hollow() {
  difference() {
    side_profile();
    offset(r = -hull_thickness)
      side_profile();
  }
}

module screen_cutout() {
  lcd_height = 24.3;
  lcd_width = 69.3;
  lcd_screen_depth = 6.86;
  lcd_pcb_height = 36;
  lcd_pcb_width = 80.5;
  lcd_bottom = 10; // how far from the bottom of the front face the LCD cutout sits
  lcd_left = (front_face_width - lcd_width) / 2; // how far from the left side of the front face the LCD cutout sits
  cutout_depth = 21;
  color("green")
  rotate([0,0, -front_face_tilt])
  translate([sin(front_face_tilt)*-0.1, cos(front_face_tilt)*lcd_bottom, lcd_left]) {
    // the screen module itself
    cube( size = [lcd_screen_depth, lcd_height, lcd_width], center = false);
    // the LCD's PCB
    translate([lcd_screen_depth, -5, -5.19])
      cube(size = [1, lcd_pcb_height, lcd_pcb_width], center = false);
    // the LCD backpack
    translate([lcd_screen_depth+1, 8.8, -5.19])
      cube(size = [8.7, 22.24, 50.3] );
    // the large screw terminals on the LCD backpack
    translate([lcd_screen_depth+1+8.7, 14.13-5, -5.19])
      cube([5.44, 6.84, 18], center=false);
  }
}


difference() {
  linear_extrude(height = front_face_width)
    side_profile_hollow();
  screen_cutout();
}

%screen_cutout();