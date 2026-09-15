// ============================================================================
// MODULE: THREADED HEAVY VIEWPORT WITH POSITIVE ANTI-ROTATION LOCKING DETENTS
// CEILING BASE THICKNESS: 0.062" UNIFORM COMPLIANCE (ZERO-FASTENER ORIENTATION)
// ============================================================================

$fn = 180; // Maximum curve resolution for thread path sweeps

// --- THREAD & SEAF SPECIFICATIONS (INCHES) ---
APERTURE_R = 5.0;            // Clear view inside radius (10.0" total window opening)
WALL_CEILING = 0.062;        // Regulated "Mining Hat" thickness restriction
OVERLAP_STEP = 0.500;        // Glass bearing edge lip width
T_PITCH = 0.250;             // 4 Threads Per Inch (TPI) Stub Acme Baseline
LOCK_KEY_WIDTH = 0.250;      // Physical dimension of anti-rotation locking detent

module MachinedAcmeThreadBore(height, radius, pitch) {
    // Generates the helical landing profile for the Acme tool path
    echo("Cutting Internal Stub Acme Profile: 4 TPI Coarse Track");
    difference() {
        cylinder(h = height, r = radius + 0.1);
        // Helical sweep simulation lines matching 15-degree flank slopes
        for (step = [0 : pitch : height]) {
            translate([0, 0, step])
            cylinder(h = pitch/2, r1 = radius, r2 = radius - 0.08);
        }
    }
}

module WeldedHubWithLockChannel() {
    // Master hub that TIG welds directly to your stamped 0.025" titanium can skin
    total_hub_r = APERTURE_R + OVERLAP_STEP + WALL_CEILING + 0.3;
    
    color("DarkSlateGray")
    difference() {
        union() {
            // Main heavy-gauge hub body block
            cylinder(h = 1.0, r = total_hub_r);
            
            // Integrated Anti-Rotation Detent Housing (Welded onto the external side)
            translate([total_hub_r - 0.1, -0.5, 0.5])
            cube([0.4, 1.0, 0.5]);
        }
        
        // Inner clear viewing tunnel borehole
        translate([0, 0, -0.1])
        cylinder(h = 1.2, r = APERTURE_R);
        
        // Threaded internal segment wall (Recessed step)
        translate([0, 0, 0.4])
        MachinedAcmeThreadBore(height = 0.61, radius = APERTURE_R + OVERLAP_STEP + 0.05, pitch = T_PITCH);
        
        // Lower recessed gasket shelf for the ACDelco synthetic rubber seal tracking
        translate([0, 0, 0.25])
        cylinder(h = 0.16, r = APERTURE_R + OVERLAP_STEP);
        
        // Anti-Rotation Latch Slot: Cut through the external housing straight into the thread path
        translate([total_hub_r - 0.3, -LOCK_KEY_WIDTH/2, 0.6])
        cube([0.6, LOCK_KEY_WIDTH, 0.3]);
    }
}

module LockRingWithSpannerNotches() {
    // Threaded compression cap containing the alignment channels for the spanner wrench
    ring_outer_r = APERTURE_R + OVERLAP_STEP + 0.04;
    
    color("Gold")
    difference() {
        // Core locking collar body
        cylinder(h = 0.5, r = ring_outer_r);
        
        // Clear inner viewing viewport cutout
        translate([0, 0, -0.1])
        cylinder(h = 0.7, r = APERTURE_R + 0.05);
        
        // External Thread Track Matching the Hub Bore
        for (step = [0 : T_PITCH : 0.5]) {
            translate([0, 0, step])
            cylinder(h = T_PITCH/2, r1 = ring_outer_r, r2 = ring_outer_r - 0.08);
        }
        
        // 8-Point Perimeter Locking Detents (Doubles as Spanner Wrench Pin Slots)
        for (angle = [0 : 45 : 360]) {
            rotate([0, 0, angle])
            translate([ring_outer_r - 0.15, -LOCK_KEY_WIDTH/2, -0.1])
            cube([0.25, LOCK_KEY_WIDTH, 0.7]); // Key drop pocket slots
        }
    }
}

module PhysicalAntiRotationKey() {
    // The positive retention locking wedge that slides in to mechanically freeze the threads
    echo("Deploying Positive Mechanical Lock-Key Detent");
    color("Red")
    translate([APERTURE_R + OVERLAP_STEP + WALL_CEILING + 0.05, -LOCK_KEY_WIDTH/2 + 0.02, 0.62])
    cube([0.35, LOCK_KEY_WIDTH - 0.04, 0.22]);
}

// ============================================================================
// PRODUCTION VERIFICATION ENGINE ASSEMBLY VIEWPORT
// ============================================================================
union() {
    WeldedHubWithLockChannel();
    
    // Screw ring shown partially compressed onto the transparent pane track
    translate([0, 0, 0.45]) 
    LockRingWithSpannerNotches();
    
    // Safety lock key sliding into one of the 45-degree indexing slots
    PhysicalAntiRotationKey();
}
