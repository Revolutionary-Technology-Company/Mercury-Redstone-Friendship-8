// ============================================================================
// MODULE: CNC INTEGRATED LAUNCH ESCAPE TOWER RECEIVING MOUNTING PADS
// SCALE: 24.0" OD UPPER ANTENNA HOUSING FORGING BLANK INTERFACE
// CONFIGURATION: THREE EQUIDISTANT DETENT SOCKETS (ZERO FASTENER DESIGN)
// COMPLIANCE: 0.062" FRAME SKELETON WALL RATIO CEILING (DOC ENFORCED)
// ============================================================================

$fn = 180; // High circular resolution for multi-axis CNC lathe and mill paths

// --- STRUCTURAL ENVELOPE SCALE (INCHES) ---
ANTENNA_RING_OD = 24.0;       // Historical McDonnell apex outer diameter
FORGING_SHOULDER_W = 1.25;    // Approved solid structural block thickness profile
SKIN_SHEET_THICKNESS = 0.025; // Stamped titanium outer skin panels baseline
PAD_SOCKET_W = 1.50;          // Width of the escape tower leg insert cavity
PAD_SOCKET_D = 0.75;          // Depth cut into the solid shoulder for leg lock

module UpperForgingWithIntegratedLETPads() {
    echo("CNC Track: Carving Three Symmetrical Launch Escape Tower Mounting Sockets");
    
    color("Silver")
    difference() {
        // 1. The core solid titanium upper neck flange forging block
        cylinder(h = 4.0, r = ANTENNA_RING_OD / 2);
        
        // 2. Central parachute storage bore leaving a rock-solid structural shoulder wall
        translate([0, 0, -0.5])
        cylinder(h = 5.0, r = (ANTENNA_RING_OD / 2) - FORGING_SHOULDER_W);
        
        // 3. Lower step shoulder to flush-weld your thin 0.025" skin panels
        translate([0, 0, -0.1])
        cylinder(h = 0.6, r = (ANTENNA_RING_OD / 2) - SKIN_SHEET_THICKNESS);
        
        // 4. THREE EQUIDISTANT HIGH-LOAD LET RECEIVING SOCKET POCKETS
        // Machined symmetrically at 0, 120, and 240 degrees directly into the thick outer wall
        for (angle =) {
            rotate([0, 0, angle])
            translate([(ANTENNA_RING_OD / 2) - PAD_SOCKET_D + 0.1, -PAD_SOCKET_W / 2, 1.5])
            union() {
                // Main rectangular insert pocket that captures the tower leg foot
                cube([PAD_SOCKET_D, PAD_SOCKET_W, 2.0]);
                
                // Transverse Detent Lockway: Captures a heavy mechanical slider pin or wedge key
                translate([-0.25, -0.1, 0.75])
                cube([0.5, PAD_SOCKET_W + 0.2, 0.50]);
            }
        }
    }
}

module LETLegEngagementFoot() {
    // Models the solid structural attachment foot on the end of the escape tower legs
    echo("Fabricating Escape Tower Leg Foot Element for Fast-Latch Detent");
    color("DarkSlateGray")
    union() {
        // The main insert tongue that drops straight into the machined forging socket
        cube([PAD_SOCKET_D - 0.02, PAD_SOCKET_W - 0.02, 1.95]);
        
        // Transverse locking tongue that aligns with the slide detent channel
        translate([-0.2, -0.05, 0.77])
        cube([0.4, PAD_SOCKET_W + 0.08, 0.46]);
    }
}

// ============================================================================
// CNC WORKSTATION GRAPHICAL COMPLIANCE STAGE
// ============================================================================
union() {
    // Permanent heavy top forging housing containing the internal parachute tracks
    UpperForgingWithIntegratedLETPads();
    
    // Visualize one escape tower leg foot descending into the 0-degree receiving pad
    translate([(ANTENNA_RING_OD / 2) - PAD_SOCKET_D + 0.11, 0, 1.52])
    LETLegEngagementFoot();
}
