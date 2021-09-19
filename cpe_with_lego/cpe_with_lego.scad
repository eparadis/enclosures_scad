
// see https://www.thingiverse.com/apps/customizer/run?thing_id=615256
//     https://github.com/cfinke/LEGO.scad
use <cust_lego.scad>;

module case() {
    union() {
        translate([0, 0, 3]) {
            // from https://www.thingiverse.com/thing:2585702/files
            // fixed with https://www.formware.co/onlinestlrepair
            import("cp-box-case_fixed.stl"); 
        }


        block(width=8, length=8, height=0.33333333);
    }
}

case();