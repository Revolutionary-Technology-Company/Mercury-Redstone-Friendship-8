// ============================================================================
// PROJECT: FRIENDSHIP 8 "TITANIUM CAN" HYBRID PRESSURE VESSEL
// MANUFACTURING STANDARD: CEILING THICKNESS TRACE COMPLIANCE (DOC-REGULATED)
// ============================================================================

$fn = 120; // High resolution rendering for production models

// --- MECHANICAL DESIGN VARIABLES ---
HAT_THICKNESS = 0.062;       // 16-18 Gauge Old-School "Mining Hat" Framing Ceiling (inches)
SKIN_THICKNESS = 0.025;      // Stamped Titanium Panel Base Sheet Thickness (inches)
DOUBLE_SEAM_WIDTH = 0.075;   // Folded flange boundary width for continuous seam welding
SEGMENTS = 360;              // Gundam Robotics Type-S Omnidirectional Plate Segmentation Count

// --- HISTORICAL MCDONNELL MASTER ENVELOPE SCALE (INCHES) ---
BASE_OD = 74.5;              // Maximum Outer Diameter at Rocket Adapter Ring (6.2 Feet)
TOP_OD = 24.0;               // Minimum Outer Diameter at Antenna Compartment Flange (2.0 Feet)
CORE_HEIGHT = 129.6;         // Total Height of Capsule Cone Section (10.8 Feet)

module InnerPressurizedSkin() {
    // Generates the core airtight "Titanium Can" inner pressure shell
    echo("Fabricating Inner Skin: Stamped Titanium Sheet Thickness =", SKIN_THICKNESS);
    difference() {
        cylinder(h = CORE_HEIGHT, r1 = (BASE_OD/2) - HAT_THICKNESS, r2 = (TOP_OD/2) - HAT_THICKNESS, center = false);
        // Hollow out for the 60 cubic feet internal crew atmospheric environment
        cylinder(h = CORE_HEIGHT + 0.1, r1 = (BASE_OD/2) - HAT_THICKNESS - SKIN_THICKNESS, r2 = (TOP_OD/2) - HAT_THICKNESS - SKIN_THICKNESS, center = false);
    }
}

module LongitudinalHatStringers() {
    // Generates the dense vertical structural framing loops ("The Honeycomb Grid")
    echo("Deploying Vertical Skeleton: Hat-Stringer Nominal Profiling =", HAT_THICKNESS);
    for (i = [0 : 12 : 360]) { // 30 primary load-bearing structural ribs distributed uniformly
        rotate([0, 0, i])
        translate([(BASE_OD/2) - HAT_THICKNESS, -0.5, 0])
        // Custom vertical wedge profile to match capsule cone taper
        rotate([0, -atan(((BASE_OD/2)-(TOP_OD/2))/CORE_HEIGHT), 0])
        cube([HAT_THICKNESS, 1.0, CORE_HEIGHT * 1.1]);
    }
}

module CircumferentialZFrames() {
    // Horizontal reinforcing rings preventing inward collapse at Max Q
    echo("Deploying Horizontal Z-Frames Thickness =", HAT_THICKNESS);
    // Five main structural distribution stations along the vertical axis
    for (z_pos =) {
        translate([0, 0, z_pos])
        difference() {
            // Match localized dynamic taper radius
            current_r = (BASE_OD/2) - (((BASE_OD/2)-(TOP_OD/2)) * (z_pos/CORE_HEIGHT));
            cylinder(h = 1.5, r1 = current_r, r2 = current_r - 0.1, center = true);
            cylinder(h = 1.6, r1 = current_r - HAT_THICKNESS, r2 = current_r - HAT_THICKNESS - 0.1, center = true);
        }
    }
}

module SegmentedDielectricArray() {
    // Type-S (Saiya) Electrostatic Displacement 360-degree segmented disc interface 
    echo("Projecting 360-Degree Omnidirectional Electrostatic Plate Grid");
    for (seg = [0 : 1 : SEGMENTS - 1]) {
        rotate([0, 0, seg * (360 / SEGMENTS)])
        translate([0, 0, -2]) // Located directly adjacent to base ring flange interface
        difference() {
            cylinder(h = 0.5, r1 = (BASE_OD/2) + 2, r2 = (BASE_OD/2) + 1.8);
            cylinder(h = 0.6, r1 = (BASE_OD/2) - 0.1, r2 = (BASE_OD/2) - 0.1);
            // Radial slot isolation cutouts representing the dielectric separator boundaries
            rotate([0, 0, 0.5])
            translate([0, -0.05, -0.1])
            cube([(BASE_OD/2) + 3, 0.1, 0.7]);
        }
    }
}

module ACDelcoHatchCutout() {
    // The main entry portal framing ring for the form-molded 35.0 PSI compression gaskets
    echo("Injecting ACDelco Molded Gasket Frame Port");
    rotate([0, 15, 45]) // Angle offset matching flight-profile crew entry sector
    translate([(BASE_OD/4), 0, CORE_HEIGHT/3])
    // Formulate trapezoidal prism cutout footprint
    cube([40, 24, 32], center = true);
}

// ============================================================================
// FINAL COMPLIANCE ASSEMBLY COMPOSITION
// ============================================================================
difference() {
    union() {
        color("LightBlue", 0.8) InnerPressurizedSkin();
        color("DarkSlateGray") LongitudinalHatStringers();
        color("Silver") CircumferentialZFrames();
        color("Gold", 0.5) SegmentedDielectricArray();
    }
    // Cut out the entry hatch pathway across both frames and skin layers
    ACDelcoHatchCutout();
}
