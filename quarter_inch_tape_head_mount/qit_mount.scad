// this is a mount for a Sony quarter inch tape head.
// specifically, for Sony p/n PP30-4202A
// it is a "four track" head with only track 1 and 3 populated (top and 2nd from bottom)

// with the mounting holes on the table, and the side that the tape touches facing you:
// width: 13.32mm
// height: 17.40mm
// depth: 18.97mm
// mounting screws are centered left-to-right, 11.03mm apart front-to-back
// the front mounting screw is centered about 3.5mm back from the tape contact surface

// The most important dimension when using a tapehead is it's vertical height, so that
// the tracks on the head properly align with the tracks on the tape in the transport.
// The second most important dimension is the azimuth alignment. On R2R you can generally
// assume the tape is transported perfectly level due to the tape being bidirectional.
//


module tapehead_bb() {
    translate([-13.32/2, 0,0])
        cube([13.32, 18.97, 17.40]); // bounding box of tapehead
}

module frame() {
    width = 20;
    // how far 'back' the frame starts from the very front of the tapehead bounding box. 
    // Remember, the tape surface is set back itself and needs clearance for the tape to
    // move across it with some slight deflection.
    setback = 4;
    // How far the tape head is lifted above the surface this mount is resting on.
    // Ideally, mechanically adjustable...
    lift = 2;
    translate([-width/2,setback,-lift])
        cube([width, 16, 21]);

    // mounting ears at the top of the frame
    $fs = 0.2;
    difference() {
        union() {
            translate([-20, setback, -lift+21-3])
                cube([40, 16, 3]); // ears
            translate([11, 6, -lift])
                cube([12,12,12]);
            translate([-23, 6, -lift])
                cube([12,12,12]);
        }
        translate([15,12,15])
            cylinder(13, d=4); // pass through for positioning screw
        translate([-15,12,15])
            cylinder(13, d=4); // pass through for positioning screw
        translate([15,12,-1])
            cylinder(13, d=3.5); // tapped hole for positioning screw
        translate([-15,12,-1])
            cylinder(13, d=3.5); // tapped hole for positioning screw
    }
}

module wiring_access() {
    translate([-5,10,2])
        cube([10,15,14]);
}

difference() {
    frame();
    tapehead_bb();
    wiring_access();
}



