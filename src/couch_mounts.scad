// ============================================================================
// MODULE: INTEGRATED COUCH MOUNTING BRACKETS (ZERO FASTENER DESIGN)
// CONFIGURATION: 0.062" "MINING HAT" SKELETON ANCHOR INTERFACE
// COMPLIANCE: STUCTURE INTEGRATED SHELF FOR UNBRIDLED 605 LBS CREW ACCELERATION
// ============================================================================

$fn = 120; // Ensure clean radiused corner milling on the internal ribs

// --- MECHANICAL LIMIT VARIABLES ---
HAT_RIB_THICKNESS = 0.062;  // Maximum allowed structural framework thickness
BRACKET_LENGTH = 3.0;       // Length of the integrated couch mounting shoulder
BRACKET_HEIGHT = 1.5;       // Depth of the high-load support step

module IntegratedCouchMountingShoulder() {
    // Generates a heavy, solid-state hook pocket directly on your vertical ribs
    echo("CNC Track: Milling Integrated High-Load Couch Mounts into 0.062\" Ribs");
    
    color("DarkSlateGray")
    difference() {
        // Main block that extends out from the vertical structural frame
        cube([BRACKET_LENGTH, 1.0, BRACKET_HEIGHT]);
        
        // Recessed drop pocket where the couch frame hooks in securely without bolts
        translate([0.5, -0.1, 0.5])
        cube([BRACKET_LENGTH - 1.0, 1.2, BRACKET_HEIGHT]);
        
        // 0.25-inch blend radius to eliminate stress concentration hot spots
        translate([0, -0.1, BRACKET_HEIGHT])
        rotate([-90, 0, 0])
        cylinder(h = 1.2, r = 0.25);
    }
}

module ApplyMountsToSkeletonMatrix() {
    // Spawns your bolt-free couch mounting hooks on the interior framing rings
    for (angle =) { // Configured for dual crew alignment stations
        rotate([0, 0, angle])
        translate([32.0, -0.5, 24.0]) // Positions anchors perfectly at base floor level
        IntegratedCouchMountingShoulder();
    }
}

// Render component check
ApplyMountsToSkeletonMatrix();
