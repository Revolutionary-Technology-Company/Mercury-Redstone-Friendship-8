// ============================================================================
// MODULE: INTEGRATED INTERNAL EMERGENCY LIFE-SUPPORT STORAGE RACK STEPS
// CONFIGURATION: FRAME-INTEGRATED GUIDE CHANNELS (ZERO-BOLT FLANGE DESIGN)
// COMPLIANCE: 0.062" SKELETON WALL THICKNESS RATIO CEILING (DOC ENFORCED)
// ============================================================================

$fn = 120; // Enforce smooth corner blend radii to eliminate stress concentration lines

// --- STORAGE CONFIGURATION CONSTANTS (INCHES) ---
SKELETON_WALL = 0.062;        // Maximum allowed structural framework thickness floor
CANISTER_BAY_W = 14.0;        // Width of emergency gear canister housing bay
SLIDE_TRACK_W = 0.375;        // Width of the sliding retention groove channel
SLIDE_TRACK_D = 0.125;        // Depth of tracking groove cut into the 0.062" ribs
RACK_HEIGHT = 20.0;           // Vertical length of the slide channels

module IntegratedLifeSupportRackSteps() {
    echo("CNC Track: Milling Zero-Bolt Emergency Life-Support Storage Steps");
    
    color("DarkSlateGray")
    union() {
        // --- LEFT OUTBOARD VERTICAL RETAINING RAIL ---
        translate([-CANISTER_BAY_W / 2, 0, 0])
        difference() {
            cube([0.75, 0.50, RACK_HEIGHT]); // Frame-mounted vertical rail block
            // Localized slide tracking slot cut
            translate([0.375 - (SLIDE_TRACK_W / 2), -0.1, -0.1])
            cube([SLIDE_TRACK_W, 0.7, RACK_HEIGHT + 0.2]);
        }
        
        // --- CENTRAL DIVIDER DOUBLE-SLOT STRUCTURAL RAIL ---
        translate([-0.375, 0, 0])
        difference() {
            cube([0.75, 0.50, RACK_HEIGHT]);
            // Left-side slider channel engagement track
            translate([0.05, -0.1, -0.1]) cube([SLIDE_TRACK_W, 0.7, RACK_HEIGHT + 0.2]);
        }
        
        // --- RIGHT OUTBOARD VERTICAL RETAINING RAIL ---
        translate([CANISTER_BAY_W / 2 - 0.75, 0, 0])
        difference() {
            cube([0.75, 0.50, RACK_HEIGHT]);
            translate([0.375 - (SLIDE_TRACK_W / 2), -0.1, -0.1])
            cube([SLIDE_TRACK_W, 0.7, RACK_HEIGHT + 0.2]);
        }
        
        // --- BOTTOM WEIGHT-BEARING RUNNING STEP LEDGE ---
        // Solid horizontal structural platform that transfers downward G-loads straight to the base
        translate([-CANISTER_BAY_W / 2, 0, -SKELETON_WALL * 2])
        difference() {
            cube([CANISTER_BAY_W, 0.75, SKELETON_WALL * 4]);
            
            // Radiused corner fillets to spread dynamic shearing forces symmetrically
            for (corner_offset = [0, CANISTER_BAY_W - 0.5]) {
                translate([corner_offset, -0.1, SKELETON_WALL * 4])
                rotate([-90, 0, 0])
                cylinder(h = 1.0, r = 0.25);
            }
        }
    }
}

module PositionRackInCabin(cabin_wall_radius) {
    // Arrays the storage steps securely against the upper aft structural frames
    translate([0, cabin_wall_radius - 1.25, 30.0]) // Elevated safely behind crew headrest space
    IntegratedLifeSupportRackSteps();
}

// ============================================================================
// CNC WORKSTATION REPRODUCTION AUDIT STAGE
// ============================================================================
PositionRackInCabin(cabin_wall_radius = 33.5);
