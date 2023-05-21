
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

module two_AAA_batteries() {
  AAA_battery();
  translate([0, 0, 1+44.5]) AAA_battery();
}


difference() {
  linear_extrude(height = front_face_width)
    side_profile_hollow();
  screen_cutout();
}

%screen_cutout();
%short_protoboard();

// this is the angle of the rear slope. actually locating further it is beyond my comprehension
// it has to do with the use of offset()
theta = atan2(-cos(front_face_tilt)*front_face_height, depth-top_depth-sin(front_face_tilt)*front_face_height);

a = 30;

translate([depth-14, 0, 0]) 
rotate([0, 0, theta])
translate([-25, 2, 0])
two_AAA_batteries();

translate([depth-14, 0, 0]) 
rotate([0, 0, theta])
translate([-55, 2, 0])
two_AAA_batteries();


// cube(10);
//  translate([depth-a, 20,0]) rotate([0, 0, theta+180]) cube(10);
// translate([depth-a, 0,2]) rotate([0, 0, theta]) translate([-(depth-a), 0, -2]) cube(10); //two_AAA_batteries();


// % translate([55, 0, 2]) two_AAA_batteries();


// locating the rear lower inside corner
// does not work. not only does it depend on `depth` and `hull_thickness`, but it also depends on `top_depth`!!
// // x1 = depth + (2.31*hull_thickness)/tan(theta); // depth = 90, top_depth = 20
// // x1 = depth + (2.23236*hull_thickness)/tan(theta); // depth = 100, top_depth = 20
// // x1 = depth + (2.14357*hull_thickness)/tan(theta); // depth = 120, top_depth = 20
// // x1 = depth + (2.09705*hull_thickness)/tan(theta); // depth = 140, top_depth = 20
// y1 = hull_thickness-1;
// % translate([x1, y1, 0]) rotate([0,0,0]) cube([1,10,100]);

// locating the inside front lower corner. seems to always work
// x2 = (4.8637*hull_thickness)/tan(90-front_face_tilt);
// y2 = hull_thickness-1;
// % translate([x2, y2, 0]) rotate([0,0,0]) cube([1,10,100]);


// originally written with OpenSCAD version 2022.08.01 (git ea8950bd3)

