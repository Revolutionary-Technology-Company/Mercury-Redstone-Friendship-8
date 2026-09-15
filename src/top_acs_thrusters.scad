// ============================================================================
// MODULE: CNC INTEGRATED APEX ATTITUDE CONTROL ELECTRONIC THRUSTER CAVITIES
// HARDWARE BASE: 24.0" OD UPPER ANTENNA HOUSING FORGING INTERFACE
// PROPULSION METHOD: PLASMA VORTEX CALIBRATION / CYMATIC RESONANCE THROATS
// COMPLIANCE: 0.062" FRAME CEILING PROXIMITY / ZERO-FASTENER COARSE TOOLPATH
// ============================================================================

$fn = 180; // High circular resolution for precise CNC milling vectors

// --- ATTITUDE CONTROL CONSTANTS (INCHES) ---
NECK_OUTER_RADIUS = 24.0 / 2; // Historical 24-inch apex diameter baseline
FORGING_WALL_THICK = 1.25;    // Approved "Sewer-Plate" thick solid titanium stock
ACS_CORE_RADIUS = 1.00;       // Scale of the fine cymatic wave-driver channel
ACS_CHAMBER_DEPTH = 0.75;     // Depth of the orthogonal pitch/roll/yaw pockets

module UpperNeckWithIntegratedACS() {
    echo("CNC Track: Carving Four Orthogonal Top Attitude Control Thruster Cavities");
    
    color("Silver")
    difference() {
        // 1. The solid titanium upper housing ring block blank (4.0" height)
        cylinder(h = 4.0, r = NECK_OUTER_RADIUS);
        
        // 2. Central parachute storage vault bore leaving heavy structural shoulders
        translate([0, 0, -0.5])
        cylinder(h = 5.0, r = NECK_OUTER_RADIUS - FORGING_WALL_THICK);
        
        // 3. FOUR SYMMETRICAL ATTITUDE CONTROL SYSTEM (ACS) RESIDUE POCKETS
        // Cut at 0, 90, 180, and 270 degrees directly into the thick perimeter forging
        for (axis = [0 : 90 : 270]) {
            rotate([0, 0, axis])
            translate([NECK_OUTER_RADIUS - (FORGING_WALL_THICK / 2), 0, 2.0]) // Centered at mid-height
            union() {
                // Primary cymatic gas pre-excitation cylinder throat
                rotate([0, 90, 0])
                cylinder(h = FORGING_WALL_THICK + 0.1, r = ACS_CORE_RADIUS, center = true);
                
                // Outer stepped counterbore to seat the high-heat protective RCC cap
                translate([(FORGING_WALL_THICK / 2) - 0.1, 0, 0])
                rotate([0, 90, 0])
                cylinder(h = 0.25, r = ACS_CORE_RADIUS + 0.15, center = true);
            }
        }
    }
}

module RCCTopNozzleInsert() {
    // Models the high-temperature Carbon-Carbon protective inserts for the attitude throats
    echo("Fabricating Top ACS Reinforced Carbon-Carbon (RCC) Heat Armor Insert");
    color("DarkSlateGray")
    difference() {
        cylinder(h = 0.2, r = ACS_CORE_RADIUS + 0.14, center = true);
        cylinder(h = 0.3, r = ACS_CORE_RADIUS - 0.05, center = true);
    }
}

// ============================================================================
// CNC WORKSTATION FIELD VERIFICATION VIEWPORT
// ============================================================================
union() {
    // The permanent top forged neck ring housing the internal steering pockets
    UpperNeckWithIntegratedACS();
    
    // Visualize one protective RCC thermal cap sitting flush inside the 0-degree thruster mouth
    translate([NECK_OUTER_RADIUS - 0.1, 0, 2.0])
    rotate([0, 90, 0])
    RCCTopNozzleInsert();
}
