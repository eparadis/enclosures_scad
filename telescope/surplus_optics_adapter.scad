// an adapter tube to use a surplus projector lens ("WIKO 100-150mm f3.5") and surplus eyepiece ("H-6mm")

eps = 0.01;

proj_lens_OD = 52.5;
proj_lens_ID = 46.0;
proj_lens_inner_clr = 23.3;
proj_lens_outer_clr = 5;

eyepiece_OD = (31.51+31.68) / 2; // it has a slight taper, and we go for the midpoint
eyepiece_ID = 27.11;
eyepiece_inner_clr = 0; // optics extend completely to end of tube
eyepiece_outer_clr = 29.6;

/*
     e_d   _
     / |  | \         \___ (inner) flat surface for mating with eyepiece
    /  c  |  \        /
   /  /    \  \
 f/  /      \  \
 |  /        \  |     \____ flat surface for mating with ID of projector lens
 a_b          \_|     /

(diagram not to scale)
*/

/*
original 0.965" 6mm eyepiece:
- approx spacing between end of tubes is 40mm ("freespace gap")
- max clearance would then be ~70mm
*/

/*
modification for new 1.25" erecting eyepiece.
original adapter needs ~5-10mm to touch projection lens and new eyepiece while focused

|----projection lens----|                  |--8 to 10mm--|
                        |---orig adapter---|             |---new eyepiece----|
                |--clr--|                                |--clr--|
                        |---------"freespace_gap"--------|
freespace_gap = 62.7 + 9mm = 69.7mm ~= 70mm
*/

module profile() {
    thickness = 2;
    freespace_gap = 70;
    proj_lens_flat_surface = proj_lens_inner_clr / 2;
    eyepiece_flat_surface = eyepiece_outer_clr / 2;
    points = [
        [-proj_lens_ID/2, 0],
        [-proj_lens_ID/2 + thickness, 0],
        [-eyepiece_OD/2, proj_lens_flat_surface+freespace_gap],
        [-eyepiece_OD/2, proj_lens_flat_surface+freespace_gap+eyepiece_flat_surface],
        [-eyepiece_OD/2-thickness, proj_lens_flat_surface+freespace_gap+eyepiece_flat_surface],
        [-proj_lens_ID/2, proj_lens_flat_surface]
    ];

    polygon(points);
}


// TODO
// 1. consider method to change length for focusing
// as-is, this takes 21.4g / 7m of filament and 1h16m to print
$fa=1;
rotate_extrude()
    profile();
