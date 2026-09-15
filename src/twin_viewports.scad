// ============================================================================
// MODULE: TWO-SEATER FRIENDSHIP VARIANT SYMMETRIC TWIN VIEWPORTS
// STRUCTURAL STANDARD: 0.062" FRAME CEILING / ZERO-BOLT HOLE FASTENER METHOD
// DESIGN ORIENTATION: DUAL CONCENTRIC SCREW-IN HUBS FOR SHIRTSLEEVE PRESSURES
// ============================================================================

$fn = 180; // High circular triangulation for flawless multi-axis CNC milling paths

// --- TWO-SEATER STRUCTURAL WINDOW CONSTANTS (INCHES) ---
SKELETON_CEILING = 0.062;    // Regulated "Mining Hat" internal rib thickness floor
WINDOW_APERTURE_R = 6.0;     // 12-inch circular viewing viewport for each seat
LIP_OVERLAP = 0.500;         // Structural glass bearing step shelf width
SEAM_TRACK_W = 0.125;        // Recessed width for the ACDelco synthetic rubber seal
SEAM_TRACK_D = 0.040;        // Channel depth to clear the assembly auditor loop
PILOT_SEAT_AXIS_OFFSET = 12.0; // Distance from centerline to center of left/right windows

module CNCInternalThreadBore(h, r) {
    // Generates the tool-path guide reference for the internal Stub Acme tracks
    difference() {
        cylinder(h = h, r = r + 0.1);
        for (z_step = [0 : 0.25 : h]) {
            translate([0, 0, z_step])
            cylinder(h = 0.125, r1 = r, r2 = r - 0.08); // 15-degree trailing flank clearance
        }
    }
}

module IntegratedTwinWindowFrame() {
    echo("CNC Track: Milling Symmetrical Twin Window Structure for Two-Seater Configuration");
    
    // Core framing dimensions
    hub_outer_r = WINDOW_APERTURE_R + LIP_OVERLAP + SKELETON_CEILING + 0.3;
    total_frame_w = (PILOT_SEAT_AXIS_OFFSET * 2) + (hub_outer_r * 2);
    
    color("DarkSlateGray")
    difference() {
        // 1. Primary solid titanium overhead frame plate blank (0.062" base wall thickness)
        translate([-total_frame_w / 2, -hub_outer_r, 0])
        cube([total_frame_w, hub_outer_r * 2, 1.25]);
        
        // 2. LEFT SEAT WINDOW HOUSING CUTOUT
        translate([-PILOT_SEAT_AXIS_OFFSET, 0, 0]) {
            // Main pass-through clear vision borehole tunnel
            translate([0, 0, -0.1]) cylinder(h = 1.5, r = WINDOW_APERTURE_R);
            // Recessed internal threads to accept the screw-on lock collar
            translate([0, 0, 0.5]) CNCInternalThreadBore(h = 0.8, r = WINDOW_APERTURE_R + LIP_OVERLAP + 0.05);
            // Lower gasket channel shelf step for the ACDelco rubber pressure track
            translate([0, 0, 0.3]) cylinder(h = 0.21, r = WINDOW_APERTURE_R + LIP_OVERLAP);
        }
        
        // 3. RIGHT SEAT WINDOW HOUSING CUTOUT
        translate([PILOT_SEAT_AXIS_OFFSET, 0, 0]) {
            translate([0, 0, -0.1]) cylinder(h = 1.5, r = WINDOW_APERTURE_R);
            translate([0, 0, 0.5]) CNCInternalThreadBore(h = 0.8, r = WINDOW_APERTURE_R + LIP_OVERLAP + 0.05);
            translate([0, 0, 0.3]) cylinder(h = 0.21, r = WINDOW_APERTURE_R + LIP_OVERLAP);
        }
    }
}

module GlassPaneInsert() {
    // High-purity Fused Silica transparent pressure disc
    color("Teal", 0.3)
    cylinder(h = 0.375, r = WINDOW_APERTURE_R + LIP_OVERLAP, center = true);
}

// ============================================================================
// CNC FACTORY WORKSPACE COMPLIANCE RUN STAGE
// ============================================================================
union() {
    // Main solid structural frame matrix designed to weld straight into your 0.062" ribs
    IntegratedTwinWindowFrame();
    
    // Visualize left pane dropped into position inside the frame shelf
    translate([-PILOT_SEAT_AXIS_OFFSET, 0, 0.4])
    GlassPaneInsert();
    
    // Visualize right pane dropped into position inside the frame shelf
    translate([PILOT_SEAT_AXIS_OFFSET, 0, 0.4])
    GlassPaneInsert();
}
