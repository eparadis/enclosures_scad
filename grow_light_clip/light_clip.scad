// a clip to hang some fluorescent grow lights on a baker's rack for starting seeds

$fn = 30;
epsilon = .1;
x1 = 0;
x2 = 8;
x3 = 10;
x4 = 0.5 * (53-24);
x5 = x3 + 52 / 2;

y1 = 0;
y2 = 12;
y4 = 39.5+y2;

y5 = y4 + 10;
y3 = y4 - 9;

extrusion = 8;
hole_dia = 5;

module half_clip_pos() {
        linear_extrude(extrusion, convexity=5)
            polygon([
                [x1, y1],
                [x1, y5],
                [x2, y5],
                [x4, y4],
                [x2, y4],
                [x2, y3],
                [x3, y3],
                [x3, y2],
                [x5+epsilon, y2],
                [x5+epsilon, y1]
            ]);
}

module half_clip_neg() {
    translate([y2 / 2, y2 / 2, -epsilon])
        cylinder(h=extrusion+2*epsilon, d=hole_dia);
    translate([x5, y2 / 2, -epsilon])
        cylinder(h=extrusion+2*epsilon, d=hole_dia);

}

module half_clip() {
    translate([-x5 + epsilon, 0, 0])
    difference() {
        half_clip_pos();
        half_clip_neg();
    }
}

half_clip();
mirror([1, 0, 0])
    half_clip();