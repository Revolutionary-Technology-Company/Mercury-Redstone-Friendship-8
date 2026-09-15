// ============================================================================
// MODULE: CNC INTEGRATED BASE FORGING WITH POSIGRADE & DEFENSIVE MOUNT PODS
// THICKNESS COMPLIANCE: 1.25" SOLID TITANIUM SEWER-PLATE FORGING CEILING
// HARDWARE HOUSINGS: INTEGRATED LGM-10 CANISTER CRADLES & BROWNING PLATFORMS
// CONFIGURATION: THREE EQUIDISTANT POD CLUSTERS (ZERO FASTENER IMPLEMENTATION)
// ============================================================================

$fn = 180; // High circular interpolation for multi-axis CNC lathe turning paths

// --- INTERFACE DIMENSIONS CONSTANTS (INCHES) ---
BASE_RING_OD = 74.5;         // Historical McDonnell rocket adapter diameter
FORGING_WALL = 1.25;         // Approved solid structural thickness boundary
ROCKET_RADIUS = 2.5;         // Outer radius of the solid-propellant booster casing
LGM_CANISTER_R = 1.0;        // Radius scale for auxiliary LGM 10 micro-canisters
WEAPON_CLEVIS_W = 0.50;      // Thickness of the integrated weapon mount prongs

module HeavyBaseWithExternalPods() {
    echo("CNC Track: Milling Base Ring with 3 Symmetrical External Propulsion Clusters");
    
    color("Silver")
    difference() {
        union() {
            // 1. Core heavy-wall solid base ring foundation blank
            cylinder(h = 3.0, r = BASE_RING_OD / 2, center = true);
            
            // 2. EXTERNAL CLUSTER POD CORES (Machined at 0, 120, and 240 degrees)
            for (angle =) {
                rotate([0, 0, angle])
                translate([BASE_RING_OD / 2, 0, 0])
                union() {
                    // Main propulsion bracket foundation shoulder block
                    cube([4.0, 10.0, 3.0], center = true);
                    
                    // Browning Weapon Mount: Dual-prong solid clevis lugs
                    translate([1.5, -4.0, 0])
                    cube([1.0, WEAPON_CLEVIS_W, 2.0], center = true);
                    translate([1.5, -4.0 + WEAPON_CLEVIS_W * 2, 0])
                    cube([1.0, WEAPON_CLEVIS_W, 2.0], center = true);
                }
            }
        }
        
        // 3. Central interior borehole clearing the cockpit volume floor
        translate([0, 0, -2.0])
        cylinder(h = 6.0, r = (BASE_RING_OD / 2) - FORGING_WALL);
        
        // 4. CUTOUT POCKETS FOR HIGH-LOAD PROPULSION HARDWARE
        for (angle =) {
            rotate([0, 0, angle])
            translate([BASE_RING_OD / 2, 0, 0])
            union() {
                // Main Posigrade Rocket Cylinder Socket (Thrust track)
                translate([1.5, 2.0, 0])
                cylinder(h = 3.2, r = ROCKET_RADIUS, center = true);
                
                // Small LGM 10 Canister Cradle Pocket (Nestled between rocket and base)
                translate([-0.5, 0, 0])
                cylinder(h = 3.2, r = LGM_CANISTER_R, center = true);
                
                // Browning Pin Fast-Latch Pass: Cuts locking holes through weapon prongs
                translate([1.5, -4.0 + WEAPON_CLEVIS_W, 0])
                rotate([90, 0, 0])
                cylinder(h = 3.0, r = 0.25, center = true); // 0.50-inch quick-release pin slot
            }
        }
    }
}

// ============================================================================
// CNC WORKSTATION REPAIR MANIFEST REPRODUCTION RUN
// ============================================================================
// Displays completed heavy base forging with external cluster beds ready for TIG
HeavyBaseWithExternalPods();
