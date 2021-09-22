

module material() {
    w=7*10.5+1.5;
    l=110;
    cube([w, l, 50]);
}

module small_cutouts() {
    d=10;
    x0=d/2+1;
    y0=x0;
    xstep=10.5;
    ystep=xstep;
 
    $fn=30;
    for (y=[0:4]) {
        for (x=[0:6]) {
            translate([x*xstep+x0, y*ystep+y0, 53]) {
                // cylinder(h=100, d=d);
                cube([d,d,100], center=true);
            }    
        }
    }
}

module large_cutouts() {
    d=15;
    x0=d/2+3;
    y0=63;
    xstep=d+3;
    ystep=xstep;

    $fn=30;
    for (y=[0:2]) {
        for (x=[0:3]) {
            translate([x*xstep+x0, y*ystep+y0, 53]) {
                // cylinder(h=100, d=d);
                cube([d+2,d+1,100], center=true);
            }
        }
    }    
    
}

difference() {
    material();
    union() {
        small_cutouts();
        large_cutouts();
    }
}