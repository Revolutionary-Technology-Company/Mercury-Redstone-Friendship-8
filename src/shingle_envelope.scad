// ============================================================================
// MODULE: TWO-SEATER HYBRID CANISTER - TWIN VIEWPORTS & THERMAL SHINGLES
// STANDARD: 38.5" RADIUS CYLINDRICAL WINDOW CURVE / EXPANSION RECEPTACLES
// COMPLIANCE: 0.062" CEILING FRAME SKELETON WITH ZERO-BOLT COARSE LAYOUT
// ============================================================================

$fn = 180; // High circular accuracy for CNC path sweeps and tool tracking

// --- ENGINE MECHANICAL CONSTANTS (INCHES) ---
CAPSULE_BASE_OD = 74.5;       // Wide aft base forging diameter
CAPSULE_TOP_OD = 24.0;        // Narrow apex parachute flange diameter
CAPSULE_HEIGHT = 129.6;       // Vertical axis height of conical shell
WALL_CEILING = 0.062;         // Maximum allowed structural framework thickness
WINDOW_ARC_RADIUS = 38.5;     // Curvature rating for the Fused Silica pressure panes
SHINGLE_THICKNESS = 0.016;    // René 41 heat shield material profile thickness

module ConicalPressureCan() {
    // Generates the baseline tapered "Titanium Can" profile
    difference() {
        cylinder(h = CAPSULE_HEIGHT, r1 = CAPSULE_BASE_OD/2, r2 = CAPSULE_TOP_OD/2, center = false);
        translate([0, 0, -0.1])
        cylinder(h = CAPSULE_HEIGHT + 0.2, r1 = (CAPSULE_BASE_OD/2) - 0.5, r2 = (CAPSULE_TOP_OD/2) - 0.5, center = false);
    }
}

module CurvaceousTwinViewports() {
    // Carves dual windows matching the precise 38.5-inch cylindrical distortion radius
    for (side = [-1, 1]) {
        scale()
        translate([side * 12.0, CAPSULE_BASE_OD/2 - 4.5, 75.0]) // Positioned at astronaut eye level
        rotate([0, 12, 0]) // Adjust for 12-degree conical pitch angle
        difference() {
            // Main receiving collar block
            cylinder(h = 1.5, r = 7.0, center = true);
            // 38.5-inch radius curved core vision cutout pass
            translate([0, -WINDOW_ARC_RADIUS + 0.5, 0])
            cylinder(h = 2.0, r = WINDOW_ARC_RADIUS, center = true);
        }
    }
}

module ThermalShingleMatrix() {
    // Simulates the overlapping outer René 41 cloak rows running up the canister walls
    echo("CNC Track: Programming toolpaths for 30-column tapered heat shingles");
    color("DarkSlateGray", 0.4)
    difference() {
        // Outer dead-air insulation layer boundary cloak
        cylinder(h = CAPSULE_HEIGHT, r1 = (CAPSULE_BASE_OD/2) + 0.5, r2 = (CAPSULE_TOP_OD/2) + 0.5);
        cylinder(h = CAPSULE_HEIGHT + 0.1, r1 = (CAPSULE_BASE_OD/2) + 0.5 - SHINGLE_THICKNESS, r2 = (CAPSULE_TOP_OD/2) + 0.5 - SHINGLE_THICKNESS);
        
        // Clear out slots around the window zones to expose the screw-in locking collars
        CurvaceousTwinViewports();
    }
}

// ============================================================================
// CNC WORKSTATION COMPLIANCE RUN GRAPHICAL DISPLAY
// ============================================================================
union() {
    // 1. Inner airtight pressure hull (Your flanged, seam-welded structure)
    color("LightBlue", 0.5) ConicalPressureCan();
    
    // 2. Heavy-gauge twin window receiving collars (0.062" frame integrated)
    CurvaceousTwinViewports();
    
    // 3. Outer overlapping nickel-alloy shingle matrix containing expansion gaps
    ThermalShingleMatrix();
}
