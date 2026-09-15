// ============================================================================
// MODULE: CNC HEAVY BASE RING WITH INTEGRATED DOUBLE-SEAM RECEIVER SHELF
// THICKNESS PROFILE: 1.25" SEWER-PLATE THICK FORGING JUNCTION
// MATRIX JUNCTION: EXTENDED FLANGE STEP TO FLUSH WELD 0.025" STAMPED SKIN
// ============================================================================

$fn = 240; // Max circular fidelity for smooth tool path tracking

// --- ENGINE CALIBRATION SPECIFICATIONS (INCHES) ---
BASE_OUTER_D = 74.5;         // Historical Project Mercury booster mating diameter
BASE_FORGING_THICK = 1.25;   // Approved "Sewer Plate" solid wall thickness ceiling
SKIN_SHEET_THICK = 0.025;    // Stamped skin thickness profile
SEAM_TRACK_WIDTH = 0.125;    // Total clearance width for the folded double-seam stack
SEAM_TRACK_DEPTH = 0.375;    // Pocket depth for the compressed seam engagement lip

module CNCHeavyBaseWithSeamReceiver() {
    echo("CNC Track: Milling Double-Seam Step Receiver into 1.25\" Base Ring");
    
    color("Silver")
    difference() {
        // 1. The primary solid titanium foundation ring blank
        cylinder(h = 2.5, r = BASE_OUTER_D / 2, center = true);
        
        // 2. Central hollow bore clearing the internal payload axis
        translate([0, 0, -2.0])
        cylinder(h = 5.0, r = (BASE_OUTER_D / 2) - BASE_FORGING_THICK);
        
        // 3. THE INTEGRATED STEP RECEIVER: The CNC pocket where your thin skin folds drop in
        translate([0, 0, 1.25 - SEAM_TRACK_DEPTH])
        cylinder(h = SEAM_TRACK_DEPTH + 0.1, r = (BASE_OUTER_D / 2) - SKIN_SHEET_THICK + 0.01);
        
        // 4. Seam Weld Tracking Groove: Provides tool path clearance for the resistance welding wheels
        translate([0, 0, 1.25 - SEAM_TRACK_DEPTH - 0.1])
        difference() {
            cylinder(h = 0.2, r = (BASE_OUTER_D / 2) - SKIN_SHEET_THICK + 0.05);
            cylinder(h = 0.3, r = (BASE_OUTER_D / 2) - SKIN_SHEET_THICK - SEAM_TRACK_WIDTH);
        }
        
        // 5. External Marmon V-Groove: For the original 74.5-inch explosive separation clamp
        translate([0, 0, -0.5])
        difference() {
            cylinder(h = 0.50, r = (BASE_OUTER_D / 2) + 0.1, center = true);
            cylinder(h = 0.52, r = (BASE_OUTER_D / 2) - 0.1875, center = true);
        }
    }
}

module StampedSkinWithExtendedSeamFlange() {
    // Models the thin 0.025" skin featuring the extended area rolled into the base shelf
    echo("Fabricating Stamped Skin Panel with Extended Seaming Margin");
    color("LightBlue", 0.6)
    difference() {
        // Extended overlap cylinder entering the machined base receiver socket
        cylinder(h = 4.0, r = (BASE_OUTER_D / 2) - SKIN_SHEET_THICK);
        cylinder(h = 4.2, r = (BASE_OUTER_D / 2) - SKIN_SHEET_THICK - SKIN_SHEET_THICK);
    }
}

// ============================================================================
// PRODUCTION SIMULATION STAGE VIEWPORT
// ============================================================================
union() {
    CNCHeavyBaseWithSeamReceiver();
    
    // Position the extended skin seam descending straight into the machined step pocket
    translate([0, 0, 0.875]) 
    StampedSkinWithExtendedSeamFlange();
}
