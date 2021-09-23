//!OpenSCAD

// control handle for a Sony TC-560D reel-to-reel tape recorder.
// (this is the control that switches between play, stop, and fast wind - forward and reverse)
// original blockscad3d sketch: https://www.blockscad3d.com/community/projects/1246199
// STL exported from blockscad3d successfully printed and installed

module material() {
  union(){
    $fn=80;
    // base
    translate([0, 0, 0]){
      cylinder(r1=23, r2=23, h=14, center=false);
    }
    // cap
    translate([0, 0, 7]){
      cylinder(r1=20, r2=20, h=10, center=false);
    }
    // handle
    translate([-17, -6, 9]){
      cube([70, 12, 18], center=false);
    }
  }
}

module cutouts() {
  union(){
    $fn=80;
    // axle/shaft
    translate([0, 0, 0]){
      cylinder(r1=3.05, r2=3.05, h=15, center=false);
    }
    // 2.6mm hole to "self tap" an M3 screw into
    translate([0, 0, 5]){
      rotate([0, 90, 0]){
        cylinder(r1=1.3, r2=1.3, h=30, center=false);
      }
    }
    // clearance for the head of the M3 screw
    translate([13, 0, 5]){
      rotate([0, 90, 0]){
        cylinder(r1=3.1, r2=3.1, h=30, center=false);
      }
    }
    // 3.6mm hole to "self tap" an M4 screw into
    translate([-15, 0, 8]){
      rotate([0, 90, 0]){
        cylinder(r1=1.8, r2=1.8, h=30, center=true);
      }
    }
    // clearance for the head of the M4 screw
    translate([-37, 0, 8]){
      rotate([0, 90, 0]){
        cylinder(r1=5, r2=5, h=24, center=false);
      }
    }
  }
}

difference() {
  material();
  cutouts();
}