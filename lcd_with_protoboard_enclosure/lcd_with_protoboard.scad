
// 2x16 character LCD sitting in front of a "half length" protoboard
// originally used for the climate_display prototype

// design questions
// 1. what angle should the LCD be for optimal desktop and shelftop viewing?
// 2. how much clearance should remain for a potential battery?
// 

front_face_width = 100;
depth = 100; // foot print depth
front_face_height = 40;
front_face_tilt = 15; // degrees from vertical

module side_profile() {
  points =[ [0,0], 
    [depth, 0],
    [sin(front_face_tilt)*front_face_height, cos(front_face_tilt)*front_face_height ]
  ];

  polygon(points = (points), convexity = 10);
}

module side_profile_hollow() {
  difference() {
    side_profile();
    offset(r = -2)
      side_profile();
  }
}

module screen_cutout() {
  lcd_height = 20;
  lcd_width = 60;
  lcd_bottom = 10; // how far from the bottom of the front face the LCD cutout sits
  lcd_left = (front_face_width - lcd_width) / 2; // how far from the left side of the front face the LCD cutout sits
  cutout_depth = 5;
  color("green")
  translate([sin(front_face_tilt)*cutout_depth, cos(front_face_tilt)*lcd_bottom, lcd_left]) 
  rotate([0,0, -front_face_tilt])
  cube( size = [cutout_depth, lcd_height, lcd_width], center = false);
}


difference() {
  linear_extrude(height = front_face_width)
    side_profile_hollow();
  screen_cutout();
}