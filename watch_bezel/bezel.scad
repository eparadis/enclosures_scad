// replacement bezel for a Timex 34320 10880

sigma = 0.01;
two_sigma = sigma * 2;
fit_clearance = 0.05;

// diameter of the clip, the widest part that the inside of the bezel touches
d2 = 34.56;

// diameter of the crystal
d3 = 30.65 + 2*fit_clearance;

// diameter closest to the body
d1 = d2 - 2 * 0.35;

// height below the clip, towards the body
h1 = 0.60;

// height from the body to the top face
h2 = 1.65;

// height above the top face that the bezel's flat band ends
h3 = 1.24;

// diameter of flat face of body
d4= 38.10 - 2*fit_clearance;

$fa = 0.01;

difference() {
  union() {
    cylinder(h1, d=d4);
  }
  translate([0,0, -sigma])
    cylinder(h1 + two_sigma, d=d1);
}

difference() {
  translate([0,0,h1])
    cylinder(h2-h1, d=d4);
  translate([0,0,h1 - sigma])
    cylinder(h2-h1+two_sigma, d=d2);
}

difference() {
  translate([0,0,h2])
    cylinder(h3, d=d4);
  translate([0,0,h2-sigma])
    cylinder(h3+two_sigma, d=d3+fit_clearance);
}