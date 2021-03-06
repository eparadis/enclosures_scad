// parametric lens holder

axis_height = 40.00; // the center of the lens should be this high off the XY plane

// circular lenses
lens_D = 19.25; // diameter
lens_T = 9.06;  // edge thickness

// lens size constraint
assert( lens_D/2 < (axis_height-3), "lens too large for specified optical axis height!");

// the holder
plane_h = axis_height + lens_D / 2 + 2; // 2mm above the lens
plane_w = lens_D + 4; // 2mm on each side of the lens
//plane_t = min(5, max(3, lens_T)); // no thiner than 3mm, no thicker than 5
plane_t = 3;

$fn = 100;

module footing_slot() {
  width = 4;
  hull() {
    cylinder(10, d=width);
    translate([plane_h/4, 0, 0])
      cylinder(10, d=width);
  }
}

module footing() {
  difference() {
    cube([3, plane_w, plane_h / 2]);
    translate([-5, plane_w / 2, plane_h / 2 - plane_h / 8])
      rotate([0, 90, 0])
        footing_slot();
  }
}

module label_text() {
  text(text=str("D ", lens_D), size=5, font="DIN Alternate:style=Bold", halign="left", valign="baseline");
}

module label() {
  if( lens_D <= 30)
  translate([lens_D / 2 + 2, -2.3 , plane_t])
    linear_extrude(2, center=true, convexity=10)
      label_text();
  else
    translate([axis_height - 3.5, -plane_w / 2, plane_t])
      rotate([0, 0, 90])
        linear_extrude(2, center=true, convexity=10)
          label_text();
}

difference() {
  union() {
    translate([-lens_D/2 - 2, -plane_w / 2, 0])
      cube([plane_h, plane_w, plane_t]);
    translate([axis_height - 3, -plane_w / 2, 0])
      footing();
    label();
  }
  translate([0, 0, -1])
    cylinder(h=20, d=lens_D);
}





