// an adapter tube to use a surplus projector lens ("WIKO 100-150mm f3.5") and surplus eyepiece ("H-6mm")

eps = 0.01;

proj_lens_OD = 52.5;
proj_lens_ID = 46.0;
proj_lens_inner_clr = 23.3;
proj_lens_outer_clr = 5;

eyepiece_OD = 24.47;
eyepiece_ID = 21.7;
eyepiece_inner_clr = 6.31;
eyepiece_outer_clr = 22.1;

// approx spacing between end of tubes is 40mm
// max clearance would then be ~70mm

/*
      _    _
     / |  | \         \___ (inner) flat surface for mating with eyepiece
    /  |  |  \        /
   /  /    \  \
  /  /      \  \
 |  /        \  |     \____ flat surface for mating with ID of projector lens
 |_/          \_|     /

(diagram not to scale)
*/

// TODO
// 1. taper outside to save material
// 2. reverse taper inside to increase optical freespace
// 3. ensure flat surface for mating with ID of projector lens
// 4. ensure flat surface for mating with OD of eyepiece
// 5. consider method to change length for focusing
// as-is, this takes 21.4g / 7m of filament and 1h16m to print
difference() {
    $fa=1;
    cylinder(h=60, r=proj_lens_ID/2);
    cylinder(h=60+2*eps, r=eyepiece_OD/2);
}