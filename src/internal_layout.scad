// ============================================================================
// MODULE: TWO-SEATER COUCH MOUNT SEATS & HEXADECIMAL COMPUTER ROUTING WAYS
// SKELETON STANDARD: 0.062" FRAME CEILING RESTRICTION / ZERO-BOLT HOLE INTERFACE
// COMPLIANCE: SOLID INTERLOCK MATRIX ANCHOR FOR 605 LBS PAYLOAD VELOCITY LOADS
// ============================================================================

$fn = 120; // High resolution rendering for precise internal CNC toolpath modeling

// --- INTERIOR DESIGN PARAMETERS (INCHES) ---
BASE_RING_INNER_D = 72.0;    // Inner diameter clearance of the heavy base forging
SKELETON_RIB_THICK = 0.062;  // Maximum allowed "Mining Hat" structural framework floor
COUCH_ANCHOR_W = 4.0;        // Width of the slide-in couch locking step bracket
BUS_CHANNEL_W = 0.250;       // Width of the recessed Snap Circuit fiber-optic bus paths
BUS_CHANNEL_D = 0.030;       // Depth of trace tracks (Safely below structural ceiling)

module HeavyFloorSupportRingSteps() {
    // Generates the massive circular tiered shoulder step where the floor matrix locks in
    echo("CNC Track: Milling Integrated 1.25\" Base Ring Structural Step Shelf");
    color("Silver")
    difference() {
        // Main block resting directly on top of the 1.25" thick base ring forge
        cylinder(h = 1.5, r = BASE_RING_INNER_D / 2, center = true);
        
        // Internal hollow cutout clearing space for the crew's footwell and cargo bay
        translate([0, 0, -0.1])
        cylinder(h = 1.7, r = (BASE_RING_INNER_D / 2) - 1.5, center = true);
        
        // Machined interlocking shelf cutout to accept the flanged 0.025" pressure floor
        translate([0, 0, 0.50])
        cylinder(h = 0.51, r = (BASE_RING_INNER_D / 2) - 0.25);
    }
}

module BoltFreeCouchLockBrackets() {
    // Patterns four symmetrical slide-wedges to lock the twin support couches down without fasteners
    echo("CNC Track: Carving 4 Symmetrical Slide-Lock Couch Brackets");
    color("DarkSlateGray")
    for (angle = [-45, 45, 135, 225]) {
        rotate([0, 0, angle])
        translate([(BASE_RING_INNER_D / 2) - 1.45, -COUCH_ANCHOR_W / 2, 0.5])
        difference() {
            // Main solid bracket shoulder blocking block
            cube([1.5, COUCH_ANCHOR_W, 2.0]);
            
            // Tapered slide keyway: The couch frame foot slides forward and locks under compression
            translate([-0.1, 0.5, 0.5])
            cube([1.2, COUCH_ANCHOR_W - 1.0, 1.6]);
            
            // 0.25" radiused fillets to eliminate stress cracking lines under launch loads
            translate([0, -0.1, 2.0])
            rotate([-90, 0, 0])
            cylinder(h = COUCH_ANCHOR_W + 0.2, r = 0.25);
        }
    }
}

module Hexadecimal16StateBusRoutingWays() {
    // Carves the routing channels for your non-penetrating Snap Circuit data matrix
    echo("CNC Track: Engraving 16-State Hexadecimal Analog Bus Cable Tracks");
    color("Gold")
    translate([0, 0, -0.7]) // Positioned safely underneath the cockpit floor plates
    difference() {
        // Main routing plate ring layout running from the computer bay up to the dashboard
        cylinder(h = BUS_CHANNEL_D, r = (BASE_RING_INNER_D / 2) - 1.8);
        cylinder(h = BUS_CHANNEL_D + 0.1, r = (BASE_RING_INNER_D / 2) - 1.8 - BUS_CHANNEL_W);
        
        // 16 discrete parallel trace isolation separators cut inside the channel loop
        for (trace = [0 : 1 : 15]) {
            rotate([0, 0, trace * (360 / 16)])
            translate([0, -0.02, -0.05])
            cube([BASE_RING_INNER_D, 0.04, BUS_CHANNEL_D + 0.1]);
        }
    }
}

// ============================================================================
// CNC FACTORY WORKSPACE SYNCHRONIZATION STAGE
// ============================================================================
union() {
    // 1. Heavy structural foundation ledge ring
    HeavyFloorSupportRingSteps();
    
    // 2. High-load, bolt-free slide-in couch retention seats
    BoltFreeCouchLockBrackets();
    
    // 3. 16-state multi-level analog voltage routing bus lines
    Hexadecimal16StateBusRoutingWays();
}
