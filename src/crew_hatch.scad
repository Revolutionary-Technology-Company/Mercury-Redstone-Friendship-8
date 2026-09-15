// ============================================================================
// MODULE: HIGH-PRECISION CNC TRAPEZOIDAL CREW HATCH & INTEGRATED PLUG SHELF
// COMPLIANCE: 0.062" MAXIMUM SKELETON WALL CEILING (ZERO-BOLT FLANGE DESIGN)
// CONFIGURATION: 35.0 PSI ACDELCO MOLDED HOUSING / CENTRAL PRESSURE LATCH
// ============================================================================

$fn = 120; // Maintain micro-smooth edge radii for uniform gasket compression

// --- TRAPEZOIDAL HATCH DIMENSIONS (INCHES) ---
HATCH_HEIGHT = 32.0;         // Vertical opening scale
HATCH_BASE_WIDTH = 24.0;     // Wider bottom width matching capsule taper
HATCH_TOP_WIDTH = 16.0;      // Narrower top width profile
SKELETON_CEILING = 0.062;    // Regulated "Mining Hat" thickness floor
GASKET_CHANNEL_W = 0.250;    // Width of ACDelco synthetic rubber seal tracking path
GASKET_CHANNEL_D = 0.045;    // Depth required to pass the assembly auditor loop

module RawTrapezoidProfile(w_top, w_bottom, h) {
    // Generates the baseline rounded-corner trapezoidal profile geometry
    offset(r = 1.5) // Standard 1.5" radius blend to avoid stress fracturing at corners
    polygon(points=[
        [-w_bottom/2 + 1.5, -h/2 + 1.5],
        [w_bottom/2 - 1.5, -h/2 + 1.5],
        [w_top/2 - 1.5, h/2 - 1.5],
        [-w_top/2 + 1.5, h/2 - 1.5]
    ]);
}

module PressurizedHatchDoorPlug() {
    // The removable internal hatch door assembly (Inner Plug Component)
    echo("CNC Track: Fabricating Internal Pressure-Assisted Hatch Door Plug");
    color("Silver")
    difference() {
        // Main structural door body (Milled outward to clear the frame opening)
        linear_extrude(height = SKELETON_CEILING * 3)
        RawTrapezoidProfile(HATCH_TOP_WIDTH + 1.0, HATCH_BASE_WIDTH + 1.0, HATCH_HEIGHT + 1.0);
        
        // Inner weight-reduction pockets matching the interior grid design
        translate([0, 0, SKELETON_CEILING])
        linear_extrude(height = SKELETON_CEILING * 3)
        RawTrapezoidProfile(HATCH_TOP_WIDTH - 2.0, HATCH_BASE_WIDTH - 2.0, HATCH_HEIGHT - 2.0);
        
        // Perimeter tracking groove for the ACDelco compression gasket track
        translate([0, 0, (SKELETON_CEILING * 3) - GASKET_CHANNEL_D])
        linear_extrude(height = GASKET_CHANNEL_D + 0.01)
        difference() {
            RawTrapezoidProfile(HATCH_TOP_WIDTH + 0.5, HATCH_BASE_WIDTH + 0.5, HATCH_HEIGHT + 0.5);
            RawTrapezoidProfile(HATCH_TOP_WIDTH + 0.5 - GASKET_CHANNEL_W, HATCH_BASE_WIDTH + 0.5 - GASKET_CHANNEL_W, HATCH_HEIGHT - GASKET_CHANNEL_W);
        }
    }
}

module WeldedHatchFrameReceivingRim(capsule_radius) {
    // Heavy structural framing ring that TIG welds directly to the 0.062" stringers
    echo("CNC Track: Generating Reinforced Frame Cutout Profile with Internal Sealing Shelf");
    color("DarkSlateGray")
    difference() {
        // Main surrounding consolidation reinforcement pad block
        linear_extrude(height = SKELETON_CEILING * 4)
        RawTrapezoidProfile(HATCH_TOP_WIDTH + 4.0, HATCH_BASE_WIDTH + 4.0, HATCH_HEIGHT + 4.0);
        
        // Primary clear crew-clearance pass-through tunnel
        translate([0, 0, -0.5])
        linear_extrude(height = SKELETON_CEILING * 6)
        RawTrapezoidProfile(HATCH_TOP_WIDTH, HATCH_BASE_WIDTH, HATCH_HEIGHT);
        
        // Internal structural plug shelf step (Where the door door seats and locks)
        translate([0, 0, SKELETON_CEILING * 2])
        linear_extrude(height = SKELETON_CEILING * 3)
        RawTrapezoidProfile(HATCH_TOP_WIDTH + 0.8, HATCH_BASE_WIDTH + 0.8, HATCH_HEIGHT + 0.8);
    }
}

// ============================================================================
// PRODUCTION SYNCHRONIZATION ASSEMBLY STAGE
// ============================================================================
union() {
    // 1. Permanent Frame Rim (Integrates natively with the 0.062" "Honeycomb" matrix wall)
    WeldedHatchFrameReceivingRim(capsule_radius = 37.25);
    
    // 2. Removable Hatch Door Plug shown dropping inward into the compressed seal step
    translate([0, 0, SKELETON_CEILING * 2 + 0.05])
    color("LightBlue", 0.8)
    PressurizedHatchDoorPlug();
}
