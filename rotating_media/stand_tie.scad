// a piece that ties the two stands together at their bases

/*
TODO
post first print and test fit:
- fits well
- existing motor mount attaches well, but isn't centered because it has two 40mm offset holes instead of 30mm offset or slots.
- add some type of notch or fin to aid alignment with the stands.
- consider changing some of the mounting holes to slots. no clear need yet.
*/

// precision-related
eps = 0.01;
$fn = 100;
thread_M3 = 3.0; // diameter where an M3 will self thread
cap_M3 = 6.0; // diameter where the head of an M3 will fit inside for counter sinking
horiz_thread_M3 = thread_M3 - 0.1; // horizontal holes need to smaller to properly thread. May need adjustment

length = 100+2*10; // 100mm inside, 10mm on each end for the frame
width = 40;
height = 10;

module end_holes() {
    // far end
    translate([-eps, 5, 5])
    rotate([0, 90, 0])
        cylinder(height+eps, d=horiz_thread_M3, center=false);
    translate([-eps, 5+30, 5])
    rotate([0, 90, 0])
        cylinder(height+eps, d=horiz_thread_M3, center=false);

    // near end
    translate([length-height, 5, 5])
    rotate([0, 90, 0])
        cylinder(height+eps, d=horiz_thread_M3, center=false);
    translate([length-height, 5+30, 5])
    rotate([0, 90, 0])
        cylinder(height+eps, d=horiz_thread_M3, center=false);
}

module mounting_holes(y_offset) {
    for (i=[0:11]) {
        translate([5+10*i, y_offset, -eps])
        cylinder(height+eps*2, d=thread_M3, center=false);
    }
}

module center_holes() {
    mounting_holes(10);
    mounting_holes(20);
    mounting_holes(30);
}

difference() {
    cube([length, width, height]);
    end_holes();
    center_holes();
}