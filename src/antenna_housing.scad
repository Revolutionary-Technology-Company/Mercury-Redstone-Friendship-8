// ============================================================================
// MODULE: HIGH-PRECISION CNC UPPER ANTENNA & PARACHUTE DECK HOUSING
// CONFIGURATION: 24.0" OD MCDONNELL APEX ENVELOPE SCALE (ZERO-FASTENER BLUEPRINT)
// COMPLIANCE: 0.062" FRAME CEILING RESTRICTION / 0.025" STAMPED PANEL BLENDS
// ============================================================================

$fn = 180; // High circular resolution for smooth lathe turning and tool paths

// --- TECHNICAL SPECS PROFILE (INCHES) ---
ANTENNA_HOUSING_OD = 24.0;    // Historical McDonnell apex outer diameter
HOUSING_HEIGHT = 30.0;        // Vertical length of the cylindrical neck segment
FRAME_MAX_CEILING = 0.062;    // Regulated "Mining Hat" structural floor thickness
SKIN_SHEET_THICK = 0.025;     // Stamped titanium skin sheet baseline
JETTISON_GROOVE_W = 0.375;    // Width of the split-ring separation track
JETTISON_GROOVE_D = 0.125;    // Depth of the recovery cap release lip

module AntennaHousingInternalSkeleton() {
    // Generates the internal 0.062" rigid hoop rings to resist tower pull forces
    echo("CNC Track: Milling 0.062\" Antenna Neck Stiffening Matrix Hoops");
    color("DarkSlateGray")
    union() {
        // Three horizontal reinforcement stations distributed along the neck axis
        for (z_hoop = [5.0, 15.0, 25.0]) {
            translate([0, 0, z_hoop])
            difference() {
                cylinder(h = 1.0, r = (ANTENNA_HOUSING_OD / 2) - SKIN_SHEET_THICK, center = true);
                cylinder(h = 1.2, r = (ANTENNA_HOUSING_OD / 2) - SKIN_SHEET_THICK - FRAME_MAX_CEILING, center = true);
            }
        }
        
        // 8 vertical structural guide ribs to distribute launch escape thrust vectors
        for (rib_angle = [0 : 45 : 360]) {
            rotate([0, 0, rib_angle])
            translate([(ANTENNA_HOUSING_OD / 2) - SKIN_SHEET_THICK - FRAME_MAX_CEILING, -0.25, 0])
            cube([FRAME_MAX_CEILING, 0.5, HOUSING_HEIGHT]);
        }
    }
}

module StampedApexSkinPanels() {
    // Models the thin 0.025" cylindrical outer canister sheets
    echo("CNC Track: Stamping 0.025\" Conical-to-Cylindrical Apex Skins");
    color("LightBlue", 0.6)
    difference() {
        cylinder(h = HOUSING_HEIGHT, r = ANTENNA_HOUSING_OD / 2);
        cylinder(h = HOUSING_HEIGHT + 0.1, r = (ANTENNA_HOUSING_OD / 2) - SKIN_SHEET_THICK);
    }
}

module ForgedJettisonFlangeCap() {
    // The heavy top rim forging featuring the split-ring path for parachute deployment
    echo("CNC Track: Carving 24-Inch Jettison Flange Release Mechanism Ring");
    color("Silver")
    difference() {
        // Solid collar stock (Bypasses sheet limits for primary load path)
        cylinder(h = 3.0, r = ANTENNA_HOUSING_OD / 2);
        
        // Internal borehole defining the parachute storage core drop vault
        translate([0, 0, -0.5])
        cylinder(h = 4.0, r = (ANTENNA_HOUSING_OD / 2) - 0.75); // Leaves a robust structural shoulder
        
        // Precision CNC groove cut into the outer face to receive the separation band hooks
        translate([0, 0, 1.5])
        difference() {
            cylinder(h = JETTISON_GROOVE_W, r = (ANTENNA_HOUSING_OD / 2) + 0.1, center = true);
            cylinder(h = JETTISON_GROOVE_W + 0.2, r = (ANTENNA_HOUSING_OD / 2) - JETTISON_GROOVE_D, center = true);
        }
        
        // Lower recessed shelf to flush-weld your thin 0.025" skin panels
        translate([0, 0, -0.1])
        cylinder(h = 0.6, r = (ANTENNA_HOUSING_OD / 2) - SKIN_SHEET_THICK);
    }
}

// ============================================================================
// CNC MANUFACTURE ASSEMBLY SYNCHRONIZATION VIEWPORT
// ============================================================================
union() {
    // 1. Core skin envelope rolled into vertical double seams
    StampedApexSkinPanels();
    
    // 2. Rigid internal frame cage supporting the thin skin lines
    AntennaHousingInternalSkeleton();
    
    // 3. Forged separation ring sitting flush at the top terminal edge
    translate([0, 0, HOUSING_HEIGHT - 0.5])
    ForgedJettisonFlangeCap();
}
