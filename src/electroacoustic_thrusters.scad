// ============================================================================
// MODULE: CNC SOLID BASE INTEGRATED ELECTROACOUSTIC THRUSTER MOUNTS
// CONFIGURATION: THREE-SQUARE EQUIDISTANT WAVE RESONATOR CAVITIES
// COMPLIANCE: PLASMA VORTEX COMPATIBLE / 1.25" FORGING BASE CEILING
// ============================================================================

$fn = 180; // High-resolution triangulation for CNC multi-axis milling paths

// --- STRUCTURAL BOUNDARY CONSTANTS (INCHES) ---
BASE_OUTER_RADIUS = 74.5 / 2; // McDonnell historical outer baseline
BASE_WALL_STOCK = 1.25;       // "Sewer-Plate" thick approved forging limit
THRUSTER_RADIUS = 3.5;        // Aperture scale for the cymatic resonance core
RESONATOR_DEPTH = 1.5;        // Pocket depth cut for wave waveguide drivers

module BaseRingWithIntegratedThrusters() {
    echo("CNC Track: Carving Three Symmetrical Electroacoustic Thruster Pockets");
    
    color("Silver")
    difference() {
        // 1. The primary solid titanium base ring foundation forging block
        cylinder(h = 2.5, r = BASE_OUTER_RADIUS, center = true);
        
        // 2. Central hollow bore clearing the internal payload axis
        translate([0, 0, -1.0])
        cylinder(h = 5.0, r = BASE_OUTER_RADIUS - BASE_WALL_STOCK);
        
        // 3. THREE EQUIDISTANT ELECTROACOUSTIC PROPULSION CAVITIES
        // Machined symmetrically at 0, 120, and 240 degrees directly into the thick metal
        for (angle =) {
            rotate([0, 0, angle])
            translate([BASE_OUTER_RADIUS - (BASE_WALL_STOCK / 2), 0, -1.25 + (RESONATOR_DEPTH / 2)])
            union() {
                // Main acoustic resonance chamber pocket (Processes SF6 / Xenon gas)
                cylinder(h = RESONATOR_DEPTH + 0.1, r = THRUSTER_RADIUS, center = true);
                
                // Recessed stepped shelf to seat the external electrode ionization grids
                translate([0, 0, -RESONATOR_DEPTH / 2])
                cylinder(h = 0.2, r = THRUSTER_RADIUS + 0.25, center = true);
            }
        }
    }
}

module CarbonCarbonThermalShroud() {
    // Models the high-temperature RCC protective caps designed to shield the thruster exits
    echo("Fabricating Reinforced Carbon-Carbon (RCC) Vortex Thruster Nozzle Cap");
    color("DarkSlateGray")
    difference() {
        cylinder(h = 0.5, r = THRUSTER_RADIUS + 0.23);
        translate([0, 0, -0.1])
        cylinder(h = 0.7, r = THRUSTER_RADIUS - 0.1);
    }
}

// ============================================================================
// CNC MANUFACTURING INTERFACE VIEWPORT
// ============================================================================
union() {
    // Permanent heavy base forging containing the internal wave driver channels
    BaseRingWithIntegratedThrusters();
    
    // Visualize one protective RCC thermal shroud seated over the 0-degree thruster exit mouth
    translate([BASE_OUTER_RADIUS - (BASE_WALL_STOCK / 2), 0, -1.5])
    CarbonCarbonThermalShroud();
}
