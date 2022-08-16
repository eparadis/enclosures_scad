use <gears.scad>

include <BOSL2/std.scad>
presets = import ("gears.json");

module gear_from_preset(preset){
    function raw_field(_preset, _field) = presets["parameterSets"][_preset][_field];

    // try real hard to convert a json value. BOSL2 has some other ways of doing this probably
    function from_preset(p, f) = raw_field(p,f)=="true"? true :
    raw_field(p,f)=="false"? false :
    !is_nan(parse_int(raw_field(p,f)))? parse_int(raw_field(p,f)) :
    !is_nan(parse_float(raw_field(p,f)))? parse_float(raw_field(p,f)) :
    raw_field(p,f); // just return the original string b/c it was probably just a string anyhow

    Module = from_preset(preset, "Module"); // 

    Gear_type = from_preset(preset, "Gear_type"); 

    width = from_preset(preset, "width"); // 5.0; // 0.01
    teeth = from_preset(preset, "teeth"); // 30;
    bore = from_preset(preset, "bore"); // 3; // 0.01
    straight = from_preset(preset, "straight"); // false;

    hub = from_preset(preset, "hub"); // true;
    hub_diameter = from_preset(preset, "hub_diameter"); // 6; // 0.01
    hub_thickness = from_preset(preset, "hub_thickness"); // 5; // 0.01

    optimized = from_preset(preset, "optimized"); // false;
    pressure_angle = from_preset(preset, "pressure_angle"); // 20; // 0.01
    helix_angle = from_preset(preset, "helix_angle"); // 20; // 0.01
    clearance = from_preset(preset, "clearance"); // 0.05; // 0.01

    idler_teeth = from_preset(preset, "idler_teeth"); // 36;
    idler_bore = from_preset(preset, "idler_bore"); // 3; // 0.01
    assembled = from_preset(preset, "assembled"); // true;

    rack_length = from_preset(preset, "rack_length"); // 50; // 0.01
    rack_height = from_preset(preset, "rack_height"); // 4; // 0.01

    // Worm lead angle                                                                (For final worm diameter, see also number of starts.)
    lead_angle = from_preset(preset, "lead_angle"); // 4; // 0.01
    // Number of starts                                                                (For final worm diameter, see also lead angle.)
    worm_starts = from_preset(preset, "worm_starts"); // 1;
    // Worm bore                                             (Please note: The bore in Basic Gear Parameters is used for the bore of the worm gear, not the worm.)
    worm_bore = from_preset(preset, "worm_bore"); // 3; // 0.01
    worm_length = from_preset(preset, "worm_length"); // 6; // 0.01

    bevel_angle = from_preset(preset, "bevel_angle"); // 45; // 0.01
    bevel_width = from_preset(preset, "bevel_width"); // 5; // 0.01
    shaft_angle = from_preset(preset, "shaft_angle"); // 90; // 0.01

    rim_width = from_preset(preset, "rim_width"); // 3; // 0.01

    solar_teeth = from_preset(preset, "solar_teeth"); // 20;
    planet_teeth = from_preset(preset, "planet_teeth"); // 10;
    number_of_planets = from_preset(preset, "number_of_planets"); // 3;

    // computed values
    finalHelixAngle = straight ? 0 : helix_angle;
    final_hub_diameter = hub ? hub_diameter : 0;
    final_hub_thickness = hub ? hub_thickness : 0;

    $fn = 96;

    if(Gear_type == "rack") {
        zahnstange(modul=Module, laenge=rack_length, hoehe=rack_height, breite=width, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle);
    } else if(Gear_type == "spur_gear" ) {
        stirnrad (modul=Module, zahnzahl=teeth, breite=width, bohrung=bore, nabendurchmesser=final_hub_diameter, nabendicke=final_hub_thickness, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, optimiert=optimized);
    } else if(Gear_type == "herringbone_gear" ) {
        pfeilrad (modul=Module, zahnzahl=teeth, breite=width, bohrung=bore, nabendicke=final_hub_thickness, nabendurchmesser=final_hub_diameter, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, optimiert=optimized);
    } else if(Gear_type == "rack_and_pinion" ) {
        zahnstange_und_rad (modul=Module, laenge_stange=rack_length, zahnzahl_rad=teeth, hoehe_stange=rack_height, bohrung_rad=bore, breite=width, nabendicke=final_hub_thickness, nabendurchmesser=final_hub_diameter, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, zusammen_gebaut=assembled, optimiert=optimized);
    } else if(Gear_type == "annular_spur_gear" || Gear_type == "internal_spur_gear") {
        hohlrad (modul=Module, zahnzahl=teeth, breite=width, randbreite=rim_width, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle);
    } else if(Gear_type == "annular_herringbone_gear" || Gear_type == "internal_herringbone_gear" ) {
        pfeilhohlrad (modul=Module, zahnzahl=teeth, breite=width, randbreite=rim_width, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle);
    } else if(Gear_type == "planetary_gear" ) {
        planetengetriebe(modul=Module, zahnzahl_sonne=solar_teeth, zahnzahl_planet=planet_teeth, anzahl_planeten=number_of_planets, breite=width, randbreite=rim_width, bohrung=bore, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, zusammen_gebaut=assembled, optimiert=optimized);
    } else if(Gear_type == "bevel_gear" ) {
        kegelrad(modul=Module, zahnzahl=teeth,  teilkegelwinkel=bevel_angle, zahnbreite=bevel_width, bohrung=bore, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle);
    } else if(Gear_type == "herringbone_bevel_gear" ) {
        pfeilkegelrad(modul=Module, zahnzahl=teeth, teilkegelwinkel=bevel_angle, zahnbreite=bevel_width, bohrung=bore, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle);
    } else if(Gear_type == "bevel_gears" ) {
        kegelradpaar(modul=Module, zahnzahl_rad=idler_teeth, zahnzahl_ritzel=teeth, achsenwinkel=shaft_angle, zahnbreite=bevel_width, bohrung_rad=idler_bore, bohrung_ritzel=bore, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, zusammen_gebaut=assembled);
    } else if(Gear_type == "herringbone_bevel_gears" ) {
        pfeilkegelradpaar(modul=Module, zahnzahl_rad=idler_teeth, zahnzahl_ritzel=teeth, achsenwinkel=shaft_angle, zahnbreite=bevel_width, bohrung_rad=idler_bore, bohrung_ritzel=bore, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, zusammen_gebaut=assembled);
    } else if(Gear_type == "worm" ) {
        schnecke(modul=Module, gangzahl=worm_starts, laenge=worm_length, bohrung=worm_bore, eingriffswinkel=pressure_angle, steigungswinkel=lead_angle, zusammen_gebaut=assembled);
    } else if(Gear_type == "worm_drive" ) {
        schneckenradsatz(modul=Module, zahnzahl=teeth, gangzahl=worm_starts, breite=width, laenge=worm_length, bohrung_schnecke=worm_bore, bohrung_rad=bore, nabendicke=final_hub_thickness, nabendurchmesser=final_hub_diameter, eingriffswinkel=pressure_angle, steigungswinkel=lead_angle, optimiert=optimized, zusammen_gebaut=assembled);
    }
}

difference() {
    // the gear(s)
    translate([50,0,0])
    gear_from_preset("drum_drive_worm_1");

    // the mounting bolt pattern
    bolt_pattern_radius = 18;
    thickness = 5; // i think this could be loaded from the preset as "width"
    // precision-related
    eps = 0.01;
    $fn = $preview ? 64 : 128;
    for( rot = [0 : 360/6 : 360])
        rotate([0,0, rot]) {
                translate([bolt_pattern_radius, 0, -eps])
                    cylinder(h=thickness*3, d=3, center=false);
        }
}