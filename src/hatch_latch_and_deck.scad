// ============================================================================
// MODULE: CENTRAL HATCH ROTATIONAL LATCH & FORWARD PARACHUTE COMPARTMENT FLANGE
// COMPLIANCE: 0.062" FRAME CEILING RESTRICTION (ZERO-FASTENER BLUEPRINT STANDARD)
// FABRICATION STRATEGY: STUB ACME COARSE THREAD CAM DRIVE / SOLID UPPER FORGING
// ============================================================================

$fn = 180; // High circular resolution for precise tool path step-milling

// --- CORE DIMENSIONS PROFILE (INCHES) ---
FRAME_CEILING = 0.062;        // Regulated "Mining Hat" structural floor thickness
SKIN_SHEET = 0.025;           // Stamped titanium cabin pressure panel profile
TOP_CAPSULE_OD = 24.0;        // McDonnell historical master diameter at capsule apex
LATCH_BAR_W = 1.250;          // Width of the slide locking bar stock
LATCH_BAR_T = 0.250;          // Thickness of high-torque locking bars

module CentralRotationalCamSpindle() {
    // The main internal rotational drive hub mounted to the interior face of the hatch plug
    echo("CNC Track: Milling Internal Central Rotational Cam Spindle");
    color("Gold")
    difference() {
        // Main high-torque center circular block stock
        cylinder(h = 1.25, r = 4.0, center = true);
        
        // Coarse internal drive thread bore (Simulated via concentric steps)
        for (z_step = [-0.6 : 0.25 : 0.6]) {
            translate([0, 0, z_step])
            cylinder(h = 0.125, r1 = 2.0, r2 = 1.85, center = true);
        }
        
        // Pin tracks where the four radial locking bars link to the central hub axis
        for (slot = [0 : 90 : 270]) {
            rotate([0, 0, slot])
            translate([2.5, 0, 0])
            cylinder(h = 1.5, r = 0.1875, center = true); // 3/16" linkage pins
        }
    }
}

module RadialLockingBars() {
    // Four structural locking extensions that project out to freeze the hatch plug into the wall
    echo("CNC Track: Patterning Radial Slide Locking Bar Extensions");
    color("Silver")
    for (dir = [0 : 90 : 270]) {
        rotate([0, 0, dir])
        translate([3.0, -LATCH_BAR_W/2, -LATCH_BAR_T/2])
        union() {
            // Main solid locking bar beam
            cube([12.0, LATCH_BAR_W, LATCH_BAR_T]);
            // Frame engagement wedge tongue
            translate([11.5, 0, -0.05])
            cube([0.5, LATCH_BAR_W, LATCH_BAR_T + 0.1]);
        }
    }
}

module ForwardParachuteReleaseDeckFlange() {
    // Heavy 24.0-inch structural apex ring designed to anchor recovery parachute stress lines
    echo("CNC Track: Carving 24-Inch Forward Parachute Release Deck Flange");
    color("Silver")
    difference() {
        // Primary solid titanium forging ring block (Bypasses sheet limits for primary loads)
        cylinder(h = 3.0, r = TOP_CAPSULE_OD / 2);
        
        // Internal clear borehole tunnel for parachute lines and recovery antennas
        translate([0, 0, -0.5])
        cylinder(h = 4.0, r = (TOP_CAPSULE_OD / 2) - 1.25); // 1.25-inch solid shoulder wall thickness
        
        // Step-Down Shoulder Lip: For TIG welding your thin 0.025" conical capsule skin
        translate([0, 0, -0.1])
        cylinder(h = 0.5, r = (TOP_CAPSULE_OD / 2) - SKIN_SHEET);
        
        // External Parachute Jettison Ring Track (Marmon split-band separation groove)
        translate([0, 0, 1.5])
        difference() {
            cylinder(h = 0.625, r = (TOP_CAPSULE_OD / 2) + 0.1, center = true);
            cylinder(h = 0.650, r = (TOP_CAPSULE_OD / 2) - 0.25, center = true);
        }
    }
}

// ============================================================================
// FULL MANUFACTURING SYNCHRONIZATION VIEWPORT
// ============================================================================
union() {
    // --- PART A: THE PRESSURIZED UPPER APEX INTERFACE ---
    translate([0, 0, 40.0]) 
    ForwardParachuteReleaseDeckFlange();
    
    // --- PART B: THE INTERNAL HATCH PRESSURE LATCH ENGINE ASSEMBLY ---
    // Positioned below to visualize isolated layout clear of the shell envelope
    translate([0, 0, 0]) {
        CentralRotationalCamSpindle();
        RadialLockingBars();
    }
}
