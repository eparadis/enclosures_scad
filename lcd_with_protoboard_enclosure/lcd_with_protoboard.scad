
// 2x16 character LCD sitting in front of a "half length" protoboard
// originally used for the climate_display prototype

// design questions
// 1. what angle should the LCD be for optimal desktop and shelftop viewing?
// 2. how much clearance should remain for a potential battery?
// 

hull_thickness = 2;
front_face_width = (2*44.5) + 2*hull_thickness + 2*1; // fit two AAA batteries end-to-end, accounting for the hull on the sides and a little space for a spring connector
depth = 90; // foot print depth
front_face_height = 50;
front_face_tilt = 15; // degrees from vertical
top_depth = 20; // the depth of the flat surface on top
lcd_bottom = 14; // how far from the bottom of the front face the LCD cutout sits

module side_profile_trivial() {
  points =[
    [0,0], 
    [depth, 0],
    [sin(front_face_tilt)*front_face_height+top_depth, cos(front_face_tilt)*front_face_height],
    [sin(front_face_tilt)*front_face_height, cos(front_face_tilt)*front_face_height],
  ];
  polygon(points = (points), convexity = 10);
}

module side_profile() {
  $fs = 0.01;
  offset(r = hull_thickness)
  offset(delta = -hull_thickness, chamfer=false)
  side_profile_trivial();
}

module side_profile_hollow() {
  difference() {
    side_profile();
    offset(delta = -hull_thickness)
      side_profile_trivial();
  }
}

module screen_cutout() {
  lcd_height = 24.3;
  lcd_width = 69.3;
  lcd_screen_depth = 6.86;
  lcd_pcb_height = 36;
  lcd_pcb_width = 80.5;
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

module short_protoboard() {
  color("yellow")
  translate([12, hull_thickness, hull_thickness]){
    // the protoboard itself
    cube([56.6, 9.7, 84]);
    // the stack of modules in the center
    translate([20, 9.7, 15])
      cube([16, 17, 43]); 
  }
}

module AAA_battery() {
  color("red")
  cylinder(h=44.5, d=10.5, center=false);
}


difference() {
  linear_extrude(height = front_face_width)
    side_profile_hollow();
  screen_cutout();
}

%screen_cutout();
%short_protoboard();
% translate([35, 35, 2]) AAA_battery();
% translate([35, 35, 2+1+44.5]) AAA_battery();
% translate([55, 20, 2]) AAA_battery();
% translate([55, 20, 2+1+44.5]) AAA_battery();