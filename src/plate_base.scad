// ============================================================================
// MODULE: HIGH-LOAD SEWER-PLATE THICK CNC BASE RING & FLOOR MATRIX
// MAXIMUM THICKNESS COMPLIANCE: 1.25" HEAVY FORGING BASE BOUNDARY (DOC APPROVED)
// CONFIGURATION: ZERO FASTENERS / INTEGRATED AUTOMATED TIG WELD INNER SHELF
// ============================================================================

$fn = 240; // High-resolution circular rendering for multi-axis CNC pathing

// --- TECHNICAL DIMENSIONS (INCHES) ---
BASE_OD = 74.5;              // Historical McDonnell Rocket Interface Outer Diameter
SEWER_PLATE_THICKNESS = 1.25; // DOC Approved heavy-gauge wall stock limit for base forging
FRAME_CEILING = 0.062;        // Internal "Mining Hat" stringer thickness floor
SKIN_THICKNESS = 0.025;       // Stamped titanium cabin pressure skin base sheet
MARMON_W = 0.500;             // Width of original separation clamp track
MARMON_D = 0.1875;            // Depth of original V-band clamp retention lip

module HeavyCNCBaseRing() {
    // Carves the main rocket interface loop out of a solid 1.25" thick titanium boundary block
    echo("CNC Track: Milling 74.5-Inch Base Ring from 1.25\" Sewer-Plate Thick Stock");
    color("Silver")
    difference() {
        // Main heavy-wall solid cylinder ring blank
        cylinder(h = 2.0, r = BASE_OD / 2, center = true);
        
        // Internal hollow bore leaving a rock-solid 1.25-inch shoulder wall profile
        translate([0, 0, -1.5])
        cylinder(h = 4.0, r = (BASE_OD / 2) - SEWER_PLATE_THICKNESS);
        
        // Upper CNC Step Shoulder: Creates a matching joint to weld on your thin 0.025" skin
        translate([0, 0, 0.75])
        cylinder(h = 0.51, r = (BASE_OD / 2) - SKIN_THICKNESS);
        
        // External Marmon V-Groove Channel: For the original explosive booster clamp band hooks
        translate([0, 0, -0.25])
        difference() {
            cylinder(h = MARMON_W, r = (BASE_OD / 2) + 0.1, center = true);
            cylinder(h = MARMON_W + 0.2, r = (BASE_OD / 2) - MARMON_D, center = true);
        }
    }
}

module HeavyFloorMatrix() {
    // Interlocking bottom support grid - machined to match the 1.25" base loop shoulder
    echo("CNC Track: Patterning Radial Stiffener Floor Web Matrix");
    color("DarkSlateGray")
    union() {
        // 12 primary structural load-spoke ribs radiating from the center axis
        for (spoke = [0 : 30 : 360]) {
            rotate([0, 0, spoke])
            translate([0, -FRAME_CEILING/2, -1.0])
            cube([(BASE_OD/2) - SEWER_PLATE_THICKNESS + 0.1, FRAME_CEILING, 1.0]);
        }
        
        // Inner concentric load distribution rings
        for (radius_step = [BASE_OD/4, BASE_OD/3]) {
            difference() {
                translate([0, 0, -1.0]) cylinder(h = 1.0, r = radius_step);
                translate([0, 0, -1.1]) cylinder(h = 1.2, r = radius_step - FRAME_CEILING);
            }
        }
    }
}

module HermeticFloorSkin() {
    // Airtight 0.025" floor panel that seals the cockpit environment
    color("LightBlue", 0.7)
    translate([0, 0, 0.01])
    cylinder(h = SKIN_THICKNESS, r = (BASE_OD/2) - SEWER_PLATE_THICKNESS, center = true);
}

// ============================================================================
// CNC INTEGRATED PRODUCTION VIEWPORT
// ============================================================================
union() {
    HeavyCNCBaseRing();
    
    // Floor grid nested tightly into the inner shoulder profile of the thick ring
    HeavyFloorMatrix();
    
    // Pressurized hermetic floor skin welded over the matrix assembly
    translate([0, 0, 0.01]) 
    HermeticFloorSkin();
}
