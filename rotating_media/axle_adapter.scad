// these end up being guess and check
// and after doing a pile of them manually,
// I decided I'd just print every option at once and see
// what worked

// precision-related
eps = 0.01;
$fn = 100;

thickness = 10;
press_fit_tol = 0.3;

b_ID = 8.0;
// fit_ID = b_ID - press_fit_tol * 0.75;

axle_dia = 4.98 + press_fit_tol / 2 ;  // 4.98 as measured


module adapter(inner_tweak, outer_tweak) {
    difference() {
       cylinder(thickness, d=b_ID+outer_tweak);
        translate([0, 0, -eps])
            cylinder(thickness*3, d=axle_dia+inner_tweak, center=true);
    }
}


for (i=[0:2]) {
    for (j=[-4:-2]) {
        translate([i*10, j*10, 0]) {
            adapter(i*0.1, j*0.1);
        }
    }
}

