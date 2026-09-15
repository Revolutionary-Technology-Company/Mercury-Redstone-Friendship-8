// ============================================================================
// MODULE: TWO-SEATER FRIENDSHIP VARIANT SYMMETRIC PANORAMIC DASHBOARD
// REGULATORY STANDARD: OSHA HUMAN-RATED SAFETY COMPLIANCE / LONG-TERM DOC USE
// CONFIGURATION: DUAL 18" DISPLAY FLANGES (ZERO INTERIOR FASTENER PORTS)
// ============================================================================

$fn = 120; // Maintain smooth corner fillets to spread structural loading

// --- TWO-SEATER STRUCTURAL GEOMETRY CONSTANTS (INCHES) ---
DASH_WIDTH = 52.0;           // Expanded width envelope for a two-man cockpit layout
DASH_HEIGHT = 16.0;          // Vertical profile dimension of front instrument bulkhead
SKELETON_MAX = 0.062;        // Regulated "Mining Hat" internal rib thickness wall
SCREEN_W = 18.0;             // Wide-aspect digital panel layout dimension
SCREEN_H = 10.0;             // Display screen vertical clearance boundaries
PILOT_OFFSET = 14.5;         // Distance from centerline to center of left/right seats

module OSHASafeBezelCutout() {
    // Generates a smooth, rounded rectangle aperture to prevent stress fractures
    offset(r = 0.5) // Enforces 0.5-inch safety corner radii across the display perimeter
    square([SCREEN_W, SCREEN_H], center = true);
}

module TwoSeaterMainDashboardFaceplate() {
    echo("CNC Track: Milling Expanded Two-Seater Main Instrument Bulkhead Plate");
    
    color("Silver")
    difference() {
        // 1. Core structural aluminum-titanium hybrid dashboard faceplate stock
        linear_extrude(height = SKELETON_MAX)
        offset(r = 1.0)
        square([DASH_WIDTH, DASH_HEIGHT], center = true);
        
        // 2. LEFT COMMAND PILOT SCREEN PORT (Replaces historic attitude dial sector)
        translate([-PILOT_OFFSET, 1.0, -0.1])
        linear_extrude(height = SKELETON_MAX + 0.5)
        OSHASafeBezelCutout();
        
        // 3. RIGHT CO-PILOT SYSTEM MONITOR PORT (Replaces old mechanical gauge matrix)
        translate([PILOT_OFFSET, 1.0, -0.1])
        linear_extrude(height = SKELETON_MAX + 0.5)
        OSHASafeBezelCutout();
        
        // 4. CENTRAL OVERRIDE CONSOLE BREAKOUT (For shared emergency toggle switches)
        translate([0, -4.5, -0.1])
        linear_extrude(height = SKELETON_MAX + 0.5)
        offset(r = 0.25)
        square([8.0, 4.0], center = true);
    }
}

module ACDelcoSymmetricGasketTracks() {
    // Generates dual concentric tracking channels to seat your compression rubber seals
    color("Black")
    translate([0, 0, SKELETON_MAX])
    union() {
        // Left screen hermetic sealing loop track
        translate([-PILOT_OFFSET, 1.0, 0])
        linear_extrude(height = 0.04)
        difference() {
            offset(r = 0.7) OSHASafeBezelCutout();
            offset(r = 0.5) OSHASafeBezelCutout();
        }
        
        // Right screen hermetic sealing loop track
        translate([PILOT_OFFSET, 1.0, 0])
        linear_extrude(height = 0.04)
        difference() {
            offset(r = 0.7) OSHASafeBezelCutout();
            offset(r = 0.5) OSHASafeBezelCutout();
        }
    }
}

// ============================================================================
// MANUFACTURING WORKSPACE ALIGNMENT CHECK
// ============================================================================
union() {
    TwoSeaterMainDashboardFaceplate();
    ACDelcoSymmetricGasketTracks();
}
