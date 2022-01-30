// a clip to hang some fluorescent grow lights on a baker's rack for starting seeds

epsilon = .1;
x1 = 0;
x2 = 8;
x3 = 10;
x4 = 0.5 * (53-24);
x5 = 53 / 2 + epsilon;

y1 = 0;
y2 = 10;
y3 = 39 / 2;
y4 = 39;
y5 = y4 + 10;

module half_clip() {
translate([-x5 + epsilon, 0, 0])
linear_extrude(10)
polygon([
    [x1, y1],
    [x1, y5],
    [x2, y5],
    [x4, y4],
    [x2, y4],
    [x2, y3],
    [x3, y3],
    [x3, y2],
    [x5, y2],
    [x5, y1]
]);
}


half_clip();
mirror([1, 0, 0])
    half_clip();