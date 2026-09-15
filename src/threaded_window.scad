// ============================================================================
// MODULE: THREADED COLLAR SCREW-IN WINDOW MECHANISM
// COMPLIANCE: ZERO FASTENERS / FAST PRESSURE LATCH ORIENTATION
// ============================================================================

$fn = 180; // Ultra-high resolution circles for precise thread/collar interface

// --- THREADED ASSEMBLY DIMENSIONS (INCHES) ---
WINDOW_APERTURE_RADIUS = 5.0; // 10-inch total clear viewing opening
HUB_WALL_THICKNESS = 0.062;   // Regulated "Mining Hat" structural floor ceiling
COLLAR_OVERLAP = 0.500;       // Mechanical overlap ring width for torque load
SEAL_GROOVE_WIDTH = 0.125;    // Recessed channel width for ACDelco profile
SEAL_GROOVE_DEPTH = 0.040;    // Depth required to clear 35.0 PSI compliance threshold

module TransparentCirclePane() {
    // Structural transparent disc (Fused Silica or Aerospace Polycarbonate)
    color("Teal", 0.4)
    cylinder(h = 0.375, r = WINDOW_APERTURE_RADIUS + COLLAR_OVERLAP, center = true);
}

module ACDelcoO_RingTrack() {
    // Concentric tracking channel for the synthetic rubber pressure gasket
    color("Black")
    difference() {
        cylinder(h = SEAL_GROOVE_DEPTH, r = WINDOW_APERTURE_RADIUS + (COLLAR_OVERLAP / 2) + (SEAL_GROOVE_WIDTH / 2), center = true);
        cylinder(h = SEAL_GROOVE_DEPTH + 0.1, r = WINDOW_APERTURE_RADIUS + (COLLAR_OVERLAP / 2) - (SEAL_GROOVE_WIDTH / 2), center = true);
    }
}

module WeldedReceivingHub() {
    // The main collar welded to your 0.062" stringers featuring internal thread walls
    echo("Fabricating Welded Screw-In Receiving Hub Base");
    color("DarkSlateGray")
    difference() {
        // Main block stock
        cylinder(h = 0.75, r = WINDOW_APERTURE_RADIUS + COLLAR_OVERLAP + HUB_WALL_THICKNESS + 0.25);
        
        // Internal shelf cut to receive the transparent pane and seal track
        translate([0, 0, 0.25])
        cylinder(h = 0.51, r = WINDOW_APERTURE_RADIUS + COLLAR_OVERLAP + 0.02); // Thread mating bore
        
        // Clear inner viewing tunnel
        translate([0, 0, -0.1])
        cylinder(h = 1.0, r = WINDOW_APERTURE_RADIUS);
        
        // Recessed seat loop for the ACDelco gasket beneath the glass step
        translate([0, 0, 0.25 - SEAL_GROOVE_DEPTH])
        scale([1, 1, 2]) ACDelcoO_RingTrack();
    }
}

module ScrewInLockingRing() {
    // The primary threaded pressure retainer ring. Features perimeter slot tabs for torque bars
    echo("Fabricating Threaded Torque Engagement Ring");
    color("Gold")
    difference() {
        // The core threaded collar ring
        cylinder(h = 0.35, r = WINDOW_APERTURE_RADIUS + COLLAR_OVERLAP);
        
        // Inner clearance aperture so you can see out the window
        translate([0, 0, -0.1])
        cylinder(h = 0.6, r = WINDOW_APERTURE_RADIUS + 0.05);
        
        // Torque notches: Provides structural grips for a spanner wrench to tighten the assembly down to 35.0 PSI
        for (slot = [0 : 45 : 360]) {
            rotate([0, 0, slot])
            translate([WINDOW_APERTURE_RADIUS + COLLAR_OVERLAP - 0.1, -0.125, 0.15])
            cube([0.2, 0.25, 0.25]);
        }
    }
}

// ============================================================================
// PRODUCTION EXPLOITATION ASSEMBLY STAGE
// ============================================================================
union() {
    // 1. Fixed base frame element (Welds straight onto your capsule can skeleton)
    WeldedReceivingHub();
    
    // 2. Drop-in gasket matrix
    translate([0, 0, 0.25 - (SEAL_GROOVE_DEPTH / 2)])
    ACDelcoO_RingTrack();
    
    // 3. Drop-in transparent window core
    translate([0, 0, 0.25 + 0.1875])
    TransparentCirclePane();
    
    // 4. Threaded compression cap (Drives downwards into the hub to cinch the seal)
    translate([0, 0, 0.50])
    ScrewInLockingRing();
}
