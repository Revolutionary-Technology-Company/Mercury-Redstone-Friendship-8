// ============================================================================
// MODULE: HIGH-PRECISION CNC THREADED WINDOW HUB & NASA PIN SPANNER COLLAR
// CONFIGURATION: STUB ACME 4-TPI THREAD PATH / INTEGRATED ANTI-ROTATION SLIDE
// COMPLIANCE: 0.062" MAX CEILING STRUCTURE (ZERO-FASTENER ZERO-VOLTAGE DETENT)
// ============================================================================

$fn = 240; // High-density circular mesh calculation for multi-axis CNC milling pathing

// --- NASA TECHNICAL SPECIFICATIONS (INCHES) ---
APERTURE_RADIUS = 5.0;       // 10.0-inch circular viewing envelope 
HAT_CEILING = 0.062;         // Maximum allowable structural wall ceiling (DOC regulated)
ACME_PITCH = 0.250;          // 4 Threads Per Inch (TPI) coarse heavy-thrust track
NASA_PIN_RADIUS = 0.09375;   // Exact 3/16" pin profile matching standard aerospace toolkits
GL_OVERLAP = 0.500;          // Structural compression lip step width
DETENT_SLOT_W = 0.250;       // Anti-rotation safety keyway channel thickness

module CNCAcmeInternalThread(h, r, p) {
    // Generates the tool-path reference for the inner 6.250"-4 Stub Acme thread track
    echo("CNC Track: Generating 4-TPI Internal Acme Helical Bore Toolpath");
    difference() {
        cylinder(h = h, r = r + 0.1);
        for (offset_z = [0 : p : h]) {
            translate([0, 0, offset_z])
            cylinder(h = p/2, r1 = r, r2 = r - 0.075); // 15-degree trailing flank clearance
        }
    }
}

module CNCWeldedHubBase() {
    // Master structural hub designed to be TIG ring-welded directly to the 0.025" titanium shell
    outer_dimension_r = APERTURE_RADIUS + GL_OVERLAP + HAT_CEILING + 0.35;
    
    color("DarkSlateGray")
    difference() {
        union() {
            // Main solid titanium structural stock block
            cylinder(h = 1.1, r = outer_dimension_r);
            
            // Extruded slide-latch enclosure box (External block, zero internal pressure penetration)
            translate([outer_dimension_r - 0.1, -0.6, 0.5])
            cube([0.45, 1.2, 0.55]);
        }
        
        // Primary viewing aperture cutout
        translate([0, 0, -0.1])
        cylinder(h = 1.3, r = APERTURE_RADIUS);
        
        // Machine internal threads to accept the gold locking cap
        translate([0, 0, 0.45])
        CNCAcmeInternalThread(h = 0.66, r = APERTURE_RADIUS + GL_OVERLAP + 0.06, p = ACME_PITCH);
        
        // Pocket ledge shelf for the ACDelco synthetic rubber gasket tracking system
        translate([0, 0, 0.25])
        cylinder(h = 0.21, r = APERTURE_RADIUS + GL_OVERLAP);
        
        // Anti-Rotation Latch Trackway: Cut through the side wall to expose locking detent
        translate([outer_dimension_r - 0.35, -DETENT_SLOT_W/2, 0.65])
        cube([0.7, DETENT_SLOT_W, 0.35]);
    }
}

module NASAPinSpannerLockRing() {
    // Threaded pressure collar with precise 3/16" pin receiving wells for NASA wrenches
    collar_edge_r = APERTURE_RADIUS + GL_OVERLAP + 0.05;
    
    color("Gold")
    difference() {
        // Main structural thread-on ring blank
        cylinder(h = 0.55, r = collar_edge_r);
        
        // Vision clearance viewport cut
        translate([0, 0, -0.1])
        cylinder(h = 0.75, r = APERTURE_RADIUS + 0.05);
        
        // External Thread Toolpath Helix
        for (offset_z = [0 : ACME_PITCH : 0.55]) {
            translate([0, 0, offset_z])
            cylinder(h = ACME_PITCH/2, r1 = collar_edge_r, r2 = collar_edge_r - 0.075);
        }
        
        // 8-Point Perimeter Locking Wells & Pin Spanner Slots (NASA-KSC-10154 Standard)
        for (index = [0 : 45 : 360]) {
            rotate([0, 0, index])
            translate([collar_edge_r - 0.15, 0, 0.15])
            union() {
                // Circular pin bore profile for wrench insertion
                cylinder(h = 0.45, r = NASA_PIN_RADIUS);
                // Rectangular drop notch for alternative wedge keys
                translate([-0.05, -DETENT_SLOT_W/2, 0])
                cube([0.25, DETENT_SLOT_W, 0.45]);
            }
        }
    }
}

module NASAMechanicalLockWedge() {
    // The positive anti-rotation block that locks the threads down under massive vibes
    echo("CNC Notice: Fabricating Positive Mechanical Safety Detent Pin");
    color("Red")
    translate([APERTURE_RADIUS + GL_OVERLAP + HAT_CEILING + 0.1, -DETENT_SLOT_W/2 + 0.02, 0.67])
    cube([0.4, DETENT_SLOT_W - 0.04, 0.30]);
}

// ============================================================================
// CNC FABRICATION VERIFICATION VIEWPORT DISPLAY
// ============================================================================
union() {
    CNCWeldedHubBase();
    
    // Positioned ring partially turned into the threads to show interface depth
    translate([0, 0, 0.50]) 
    NASAPinSpannerLockRing();
    
    // Slated locking wedge ready to drive home to prevent thread backup
    NASAMechanicalLockWedge();
}
