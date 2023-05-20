
// 2x16 character LCD sitting in front of a "half length" protoboard
// originally used for the climate_display prototype

// design questions
// 1. what angle should the LCD be for optimal desktop and shelftop viewing?
// 2. how much clearance should remain for a potential battery?
// 

front_face_width = 100;
depth = 100; // foot print depth
front_face_height = 40;
front_face_tilt = 30; // degrees from vertical

module side_profile() {
  points =[ [0,0], 
    [depth, 0],
    [sin(front_face_tilt)*front_face_height, cos(front_face_tilt)*front_face_height ]
  ];

  polygon(points = (points), convexity = 1);
}

module side_profile_hollow() {
  difference() {
    side_profile();
    offset(r = -2)
      side_profile();
  }
}


linear_extrude(height = front_face_width)
  side_profile_hollow();
