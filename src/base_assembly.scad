// ============================================================================
// MODULE: HIGH-PRECISION CNC BASE RING FLANGE & RADIAL FLOOR MATRIX
// HARDWARE REQUIREMENT: 74.5" OD ORIGINAL MARMON CLAMP COMPATIBLE (BOOSTER RING)
// COMPLIANCE: 0.062" MAX THICKNESS FRACTION SECTIONS (ZERO-BOLT CONFIGURATION)
// ============================================================================

$fn = 240; // Ultra-smooth circular triangulation mesh for flawless CNC ring lathe turning

// --- MASTER CAPSULE INTERFACE CONSTANTS (INCHES) ---
BASE_OUTER_DIAMETER = 74.5;    // Historical McDonnell Master Diameter (6.2 Feet)
CEILING_THICKNESS = 0.062;     // Regulated "Mining Hat" structural floor restriction
PRESSURE_SKIN_THICKNESS = 0.025; // Pliable stamped titanium floor base layer
MARMON_GROOVE_W = 0.500;       // Width of original separation V-band clamp channel
MARMON_GROOVE_D = 0.1875;      // Depth of retention lip machined into the base ring

module PressurizedFloorSkin() {
    // Stamped 0.025" titanium bottom floor disc
    echo("CNC Track: Stamping Pressurized Bottom Floor Skin, Thickness =", PRESSURE_SKIN_THICKNESS);
    color("LightBlue", 0.7)
    translate([0, 0, CEILING_THICKNESS])
    cylinder(h = PRESSURE_SKIN_THICKNESS, r = (BASE_OUTER_DIAMETER/2) - CEILING_THICKNESS, center = true);
}

module RadialStiffenerMatrix() {
    // The interlocking structural floor skeleton ("The Honeycomb Grid Extension")
    echo("CNC Track: Milling 0.062\" High-Load Radial Floor Framework");
    color("DarkSlateGray")
    union() {
        // 12 primary structural spoke beams pointing directly to the center dynamic axis
        for (spoke = [0 : 30 : 360]) {
            rotate([0, 0, spoke])
            translate([0, -CEILING_THICKNESS/2, 0])
            cube([(BASE_OUTER_DIAMETER/2) - CEILING_THICKNESS, CEILING_THICKNESS, CEILING_THICKNESS]);
        }
        
        // Concentric reinforcing ring loops to capture transverse shearing loads
        difference() {
            cylinder(h = CEILING_THICKNESS, r = BASE_OUTER_DIAMETER / 4, center = false);
            translate([0, 0, -0.1])
            cylinder(h = CEILING_THICKNESS + 0.2, r = (BASE_OUTER_DIAMETER / 4) - CEILING_THICKNESS, center = false);
        }
        difference() {
            cylinder(h = CEILING_THICKNESS, r = BASE_OUTER_DIAMETER / 3, center = false);
            translate([0, 0, -0.1])
            cylinder(h = CEILING_THICKNESS + 0.2, r = (BASE_OUTER_DIAMETER / 3) - CEILING_THICKNESS, center = false);
        }
    }
}

module CNCMachinedBaseRingFlange() {
    // Machined structural ring that receives the original 74.5-inch Marmon clamp band
    echo("CNC Track: Generating 74.5-Inch External Marmon V-Groove Channel Profile");
    color("Silver")
    difference() {
        // Primary solid titanium outer anchor loop ring ring blank
        cylinder(h = 1.5, r = BASE_OUTER_DIAMETER / 2, center = true);
        
        // Internal hollow bore to fit the inner capsule structure and clear payload lines
        translate([0, 0, -1.0])
        cylinder(h = 3.5, r = (BASE_OUTER_DIAMETER / 2) - CEILING_THICKNESS);
        
        // The V-Band Marmon Groove: Cut directly into the external face for booster separation hooks
        translate([0, 0, 0])
        difference() {
            cylinder(h = MARMON_GROOVE_W, r = (BASE_OUTER_DIAMETER / 2) + 0.1, center = true);
            cylinder(h = MARMON_GROOVE_W + 0.2, r = (BASE_OUTER_DIAMETER / 2) - MARMON_GROOVE_D, center = true);
        }
    }
}

// ============================================================================
// BASE ASSEMBLY MANUFACTURING INTEGRATION VIEWPORT
// ============================================================================
union() {
    // 1. External booster attachment ring (TIG welded continuously around base skin)
    translate([0, 0, 0]) 
    CNCMachinedBaseRingFlange();
    
    // 2. High-load radial reinforcement grid sitting flush inside the frame
    translate([0, 0, 0.5]) 
    RadialStiffenerMatrix();
    
    // 3. Hermetic pressurized barrier floor
    translate([0, 0, 0.5]) 
    PressurizedFloorSkin();
}
