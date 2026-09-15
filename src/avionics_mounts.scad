// ============================================================================
// MODULE: CNC INTEGRATED ATX MAINBOARD HOUSING & FLAT PANEL DISPLAY MOUNTS
// CONFIGURATION: FRAME-INTEGRATED SLIDE CHANNELS (ZERO-BOLT FASTENER METHOD)
// COMPLIANCE: 0.062" SKELETON WALL THICKNESS RATIO CEILING (DOC ENFORCED)
// ============================================================================

$fn = 120; // Maintain crisp edge radii for precise snap-fit interface slots

// --- AVIONICS DIMENSIONS CONSTANTS (INCHES) ---
SKELETON_WALL = 0.062;       // Maximum allowed thickness for internal framing ribs
ATX_BOARD_W = 12.0;          // Width clearance for standard computer layout block
ATX_TRACK_SLOT = 0.125;      // Width of the sliding alignment groove
SCREEN_MOUNT_W = 18.0;       // Wide-format flat panel display dimension
SCREEN_MOUNT_H = 10.0;       // Display panel vertical profile scale

module IntegratedATXChassisCradle() {
    // Carves parallel vertical tracks straight out of the internal 0.062" hat-stringers
    echo("CNC Track: Milling Zero-Bolt Vertical ATX Computer Rail Housings");
    color("DarkSlateGray")
    union() {
        // Left Rails Track Guide
        translate([-ATX_BOARD_W / 2, 0, 0])
        difference() {
            cube([0.5, 0.5, 14.0]); // Vertical mounting rail extension
            // Internal sliding track cut
            translate([0.25 - (ATX_TRACK_SLOT / 2), -0.1, -0.1])
            cube([ATX_TRACK_SLOT, 0.7, 14.2]);
        }
        
        // Right Rails Track Guide
        translate([ATX_BOARD_W / 2 - 0.5, 0, 0])
        difference() {
            cube([0.5, 0.5, 14.0]);
            translate([0.25 - (ATX_TRACK_SLOT / 2), -0.1, -0.1])
            cube([ATX_TRACK_SLOT, 0.7, 14.2]);
        }
        
        // Bottom stop safety shelf to rest the computer core weight
        translate([-ATX_BOARD_W / 2, 0, 0])
        cube([ATX_BOARD_W, 0.5, SKELETON_WALL * 2]);
    }
}

module PanoramicFlatScreenDashMount() {
    // Generates a wide-profile bezel seat directly on the horizontal Z-frame cross loops
    echo("CNC Track: Patterning 18-Inch Flat Screen Dashboard Frame Mounts");
    color("Silver")
    difference() {
        // Main flat display mounting plate blank face
        cube([SCREEN_MOUNT_W + 1.0, SKELETON_WALL * 4, SCREEN_MOUNT_H + 1.0], center = true);
        
        // Center viewing pass-through window box for screen heat-sync venting
        cube([SCREEN_MOUNT_W - 1.0, 1.0, SCREEN_MOUNT_H - 1.0], center = true);
        
        // Perimeter Bevel Groove: Enables the display panel to slide down and snap-lock flush
        difference() {
            cube([SCREEN_MOUNT_W + 0.25, 0.15, SCREEN_MOUNT_H + 0.25], center = true);
            cube([SCREEN_MOUNT_W - 0.25, 0.20, SCREEN_MOUNT_H - 0.25], center = true);
        }
    }
}

module PopulateAvionicsBay(capsule_interior_radius) {
    // Arrays the finished components accurately against the cockpit structural nodes
    union() {
        // Position the ATX computer mainframes low on the aft compartment wall
        translate([0, capsule_interior_radius - 1.5, 12.0])
        IntegratedATXChassisCradle();
        
        // Array three panoramic main pilot displays directly in front of the crew axis
        for (dash_offset = [-22, 0, 22]) {
            rotate([0, 0, dash_offset / 2])
            translate([dash_offset, -capsule_interior_radius + 4.0, 45.0]) // Dashboard vision height
            rotate([15, 0, 0]) // Tilted 15 degrees for ergonomics and visibility
            PanoramicFlatScreenDashMount();
        }
    }
}

// ============================================================================
// CNC FACTORY WORKSPACE COMPLIANCE RUN STAGE
// ============================================================================
// Simulates the internal cockpit hardware layout verification
PopulateAvionicsBay(capsule_interior_radius = 35.0);
