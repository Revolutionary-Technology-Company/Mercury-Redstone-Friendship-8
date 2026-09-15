// ============================================================================
// MODULE: DUAL-PANE VIEWING WINDOW ASSEMBLY & GASKET SEAT
// COMPLIANCE: 0.062" CEILING MAX THICKNESS REINFORCEMENT
// ============================================================================

$fn = 120; // Maintain circle smoothness for pressure distribution

// --- WINDOW ASSEMBLY DIMENSIONS (INCHES) ---
WINDOW_WIDTH = 12.0;         // Nominal observation width
WINDOW_HEIGHT = 10.0;        // Nominal observation height
FRAME_THICKNESS = 0.062;     // Regulated "Mining Hat" structural framework floor
GASKET_GROOVE_DEPTH = 0.030; // Recessed channel for ACDelco compression seals
PANE_THICKNESS = 0.250;      // Thickness of the structural transparent block

module TransparentPane() {
    // Models the heavy transparent pane assembly 
    color("Teal", 0.4)
    translate([0, 0, -PANE_THICKNESS/2])
    linear_extrude(height = PANE_THICKNESS)
    offset(r = 1.0) // Radiused corners to eliminate high-stress concentration points
    square([WINDOW_WIDTH - 0.5, WINDOW_HEIGHT - 0.5], center = true);
}

module MachinedGasketSeat() {
    // Generates the double-track tracking groove for the ACDelco synthetic rubber seals
    color("Black")
    difference() {
        // Outer sealing track perimeter
        square([WINDOW_WIDTH + 1.0, WINDOW_HEIGHT + 1.0], center = true);
        // Inner clearance window
        square([WINDOW_WIDTH - 0.2, WINDOW_HEIGHT - 0.2], center = true);
        
        // Track 1: Primary pressure hull loop
        square([WINDOW_WIDTH + 0.5, WINDOW_HEIGHT + 0.5], center = true);
    }
}

module StructuralWindowFrame() {
    // The heavy-gauge structural ring that isolates the window from skin flexing
    echo("Fabricating Reinforced Window Ring, Thickness =", FRAME_THICKNESS);
    
    color("DarkSlateGray")
    difference() {
        // Main structural mounting flange block
        linear_extrude(height = FRAME_THICKNESS * 3) // Layered box section for absolute rigidity
        offset(r = 2.0)
        square([WINDOW_WIDTH + 3.0, WINDOW_HEIGHT + 3.0], center = true);
        
        // The main clear vision viewing tunnel cutout
        translate([0, 0, -1])
        linear_extrude(height = FRAME_THICKNESS * 6)
        offset(r = 1.0)
        square([WINDOW_WIDTH, WINDOW_HEIGHT], center = true);
        
        // Lower recessed shelf to hold the internal pressure pane and gasket track
        translate([0, 0, FRAME_THICKNESS])
        linear_extrude(height = FRAME_THICKNESS * 3)
        offset(r = 1.2)
        square([WINDOW_WIDTH + 0.8, WINDOW_HEIGHT + 0.8], center = true);
    }
}

module CapsuleWindowPlacement(capsule_base_radius, placement_height) {
    // Positions the complete window system accurately on the tapered capsule wall
    rotate([0, 0, 180]) // Positions window directly opposite the crew entry hatch
    translate([0, capsule_base_radius - 4.5, placement_height])
    rotate([12, 0, 0]) // Tilted angle matching the 12-degree conical pitch of the hull
    union() {
        StructuralWindowFrame();
        
        // Nest the internal pressure pane safely inside the frame shelf
        translate([0, 0, FRAME_THICKNESS + 0.1])
        TransparentPane();
        
        // Inject the tracking layer for the ACDelco telemetry loop check
        translate([0, 0, FRAME_THICKNESS - GASKET_GROOVE_DEPTH])
        linear_extrude(height = GASKET_GROOVE_DEPTH + 0.01)
        MachinedGasketSeat();
    }
}

// --- VISUALIZATION STAGE ---
// Render isolated window component stack for manufacturing verification
CapsuleWindowPlacement(capsule_base_radius = 37.25, placement_height = 60.0);
