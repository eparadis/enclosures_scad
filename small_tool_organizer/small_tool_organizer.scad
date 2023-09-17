// Small Tool Organizer
// (c) 2021, 2023 Ed Paradis

/* [Overall] */
height=50;

/* [Large pockets] */
large_pocket_size = 17;
large_pocket_rows = 3;
large_pocket_cols = 4;

/* [Small pockets] */
small_pocket_size = 10;
small_pocket_rows = 5;
small_pocket_cols = 7;

/* [Pocket shape] */
shape="square"; // [square, circle] 

module __stop_customizer__() {}

overall_x=small_pocket_cols*(small_pocket_size+0.5)+1.5;
overall_y=large_pocket_rows*(large_pocket_size+1)
  + small_pocket_rows*(small_pocket_size+0.5)
  + 3;

echo(str("overall_x=", overall_x));
echo(str("overall_y=", overall_y));

module material() {
    cube([overall_x, overall_y, height]);
}

module cutout(size) {
    if(shape=="square") {
        cube([size,size,height*2], center=true);
    } else {
        cylinder(h=height*2, d=size, center=true, $fn=64);
    }
}

module small_cutouts() {
    d=small_pocket_size;
    x0=d/2+1;
    y0=x0;
    xstep=small_pocket_size + 0.5;
    ystep=xstep;
 
    for (y=[0:small_pocket_rows-1]) {
        for (x=[0:small_pocket_cols-1]) {
            translate([x*xstep+x0, y*ystep+y0, height+3]) {
                cutout(d);
            }
        }
    }
}

module large_cutouts() {
    d=large_pocket_size;
    w=d*large_pocket_cols+(1*(large_pocket_cols-1));
    border=(overall_x - w)/2;
    x0=d/2+border;
    y0=small_pocket_rows*(small_pocket_size+0.5)+(d/2+2);
    xstep=d+1;
    ystep=xstep;

    for (y=[0:large_pocket_rows-1]) {
        for (x=[0:large_pocket_cols-1]) {
            translate([x*xstep+x0, y*ystep+y0, height+3]) {
                cutout(d);
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