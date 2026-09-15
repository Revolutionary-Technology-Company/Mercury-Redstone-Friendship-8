// ============================================================================
// MODULE: LAUNCH ESCAPE TOWER (LET) CLEARANCE LEGS & FAST-LATCH FEET
// DESIGN CONFIGURATION: THREE EQUIDISTANT FLUX LEGS (ZERO FASTENER DESIGN)
// COMPLIANCE: 24.0" OD APEX MOUNTING JUNCTION WITH FLUSH WINDOW CLEARANCE
// ============================================================================

$fn = 120;

// --- TOWERS STRUCTURAL DIMENSIONS (INCHES) ---
TOP_RING_OD = 24.0;          // Upper neck forging outer diameter
LEG_ANGLE = 14.5;            // Structural flare angle to clear the capsule wall conical slope
LEG_HEIGHT = 180.0;          // Total vertical height of the escape tower assembly
LEG_THICKNESS = 1.75;        // Diameter of solid titanium structural leg struts

module EscapeTowerLegStrut() {
    // Generates a single angled structural leg strut tracking down the capsule profile
    color("Silver")
    rotate([0, LEG_ANGLE, 0])
    cylinder(h = LEG_HEIGHT, r = LEG_THICKNESS / 2, center = false);
}

module FastLatchEngagementFoot() {
    // Models the heavy interlocking foot block that drops into the upper neck forging socket
    color("DarkSlateGray")
    union() {
        cube([0.70, 1.48, 1.95], center = true); // Main slide insert wedge key
        translate([-0.1, 0, 0])
        cube([0.38, 1.56, 0.44], center = true); // Transverse lock-pin tongue
    }
}

module AssembleTowerSkeleton() {
    echo("CNC Track: Aligning 3-Leg Launch Escape Tower Attachment Assembly");
    for (leg_angle =) {
        rotate([0, 0, leg_angle])
        translate([TOP_RING_OD / 2 - 0.65, 0, 0])
        union() {
            // Anchor the mechanical engagement foot right at the upper neck boundary line
            translate([0, 0, 0.975]) FastLatchEngagementFoot();
            // Project the structural strut upward and outward past the viewports
            translate([0, 0, 1.95]) EscapeTowerLegStrut();
        }
    }
}

// Render check
AssembleTowerSkeleton();
