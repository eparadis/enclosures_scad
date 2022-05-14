
//echo(n=($fn>0?($fn>=3?$fn:3):ceil(max(min(360/$fa,r*2*PI/$fs),5))),a_based=360/$fa,s_based=r*2*PI/$fs);

eps = 0.01;
$fn = 100;

module body()
{
    cylinder(h = 10, r = 60-1, center = true);
    
    // the outer ring
    difference() {
        cylinder(h = 20, r = 60, center = true);
        translate([0,0,10+eps])
            cylinder(h=10, r=50, center=true);
    }
    
    // the inner hub
    cylinder(h=20, r=10, center = true);
}

difference() {
    body();

    // the center axle hole
    translate([0,0,-10])
        cylinder(h=40 + 2*eps, r=5, center=true);
}
