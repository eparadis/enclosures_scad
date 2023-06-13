module press_fit_fix() {
    // widen the bottom to avoid elephant foot
    cylinder(h=3, r=(axle_dia/2)+1, center=true);
}

module inset_bolt() {
    translate([5, 5, -eps])
        cylinder(15*3, d=4, center=true);
    translate([5, 5, 10])
        cylinder(11, d=7, center=true);
}