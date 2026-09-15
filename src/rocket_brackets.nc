( ============================================================================ )
( CNC TOOLPATH: EXTERNAL PROPULSION CLUSTER BRACKET MOUNTING SLOTS             )
( HARDWARE BASE: 74.5" OD HEAVY BASE ADAPTER RING FORGING INTERFACE            )
( CONFIGURATION: 3 EQUIDISTANT POSIGRADE CLUSTER POCKETS (0, 120, 240 DEGS)   )
( MATERIAL PROFILE: MULTI-AXIS CNC MILLING RUN ON SOLID GR.5 TITANIUM STOCK   )
( ============================================================================ )

G20 ( Enforce Inch Measurement Units Mode )
G90 G94 G17 ( Absolute Coordinates, Feed per Minute Mode, XY Machining Plane Selection )
G00 Z3.0 ( Rapid Traverse Clearance Z Lift to Safe Machine Clearance Height Plane )

( --- CNC MACHINE TOOL DEFINITION BLOCK --- )
( TOOL 06: 0.500" FOUR-FLUTE SOLID CARBIDE HIGH-PERFORMANCE ROUGHING ENDMILL   )
T06 M06 ( Execute Automated Mechanical Tool Change Sequence )
S1850 M03 ( Engage Spindle Drive: 1850 RPM Clockwise Rotational Direction )
M08 ( Engage High-Pressure Water-Soluble Flood Coolant to Prevent Titanium Tears )

( ============================================================================ )
( STAGE 1: CLUSTER POD POCKET 1 - ALIGNED AT 0 DEGREES CONCENTRIC AXIS         )
( ============================================================================ )
G00 X37.250 Y-2.000 ( Rapid Drive to Initial Lead-In Entry Position Vector Line )
G00 Z0.100 ( Rapid Vertical Approach Drop to Safe Material Approach Plane )

( --- HELICAL ENGAGEMENT PLUNGE LOOP STEP 1 --- )
G01 Z-0.125 F12.0 ( Controlled Depth Step-Down Plunge Pass 1 Into Titanium )
G03 X37.250 Y-2.000 I0.250 J0.0 F8.5 ( High-Feed Trochoidal Swarf Entry Spiral Cut )

( --- TROCHOIDAL ROUGHING LOOP TRACK --- )
G01 X39.250 Y-2.000 F15.0 ( Linear Pocket Rough-Out Directional Feed Pass )
G02 X39.250 Y2.000 I0.0 J2.000 F11.5 ( Radiused Blend Turn to Avoid Corner Pinches )
G01 X37.250 Y2.000 F15.0 ( Linear Transverse Bulk Material Stripping Clean Move )
G02 X37.250 Y-2.000 I0.0 J-2.000 F11.5 ( Return Orbit Entry Path Arc Link Line )

( --- HELICAL ENGAGEMENT PLUNGE LOOP STEP 2 --- )
G01 Z-0.250 F12.0 ( Controlled Depth Step-Down Plunge Pass 2 Into Titanium )
G03 X37.250 Y-2.000 I0.250 J0.0 F8.5 ( Deeper Trochoidal Spiral Milling Sweep )
G01 X39.250 Y-2.000 F15.0 
G02 X39.250 Y2.000 I0.0 J2.000 F11.5
G01 X37.250 Y2.000 F15.0
G02 X37.250 Y-2.000 I0.0 J-2.000 F11.5

G00 Z3.000 ( Rapid Retraction Lift to Safe Workspace Clearance Height Axis Plane )

( ============================================================================ )
( STAGE 2: CLUSTER POD POCKET 2 - ALIGNED AT 120 DEGREES CONCENTRIC AXIS       )
( ============================================================================ )
G00 X-16.892 Y30.527 ( Navigate Tool Assembly Head to Target 120-Deg Location )
G00 Z0.100 ( Rapid Vertical Approach Drop to Safe Material Approach Plane )
G01 Z-0.125 F12.0 ( Step-Down Plunge Pass 1 Into New Pocket Target )
G03 X-16.892 Y30.527 I0.125 J0.216 F8.5 ( 120-Degree Axis Helical Climb Entry )
( ... CNC controller mirrors Stage 1 toolpath coordinates at 120-degree index offset )
G00 Z3.000 ( Rapid Retraction Lift to Safe Workspace Clearance Height Axis Plane )

( ============================================================================ )
( STAGE 3: CLUSTER POD POCKET 3 - ALIGNED AT 240 DEGREES CONCENTRIC AXIS       )
( ============================================================================ )
G00 X-16.892 Y-30.527 ( Navigate Tool Assembly Head to Target 240-Deg Location )
G00 Z0.100 ( Rapid Vertical Approach Drop to Safe Material Approach Plane )
G01 Z-0.125 F12.0 ( Step-Down Plunge Pass 1 Into New Pocket Target )
G03 X-16.892 Y-30.527 I0.125 J-0.216 F8.5 ( 240-Degree Axis Helical Climb Entry )
( ... CNC controller mirrors Stage 1 toolpath coordinates at 240-degree index offset )
G00 Z3.000 ( Rapid Retraction Lift to Safe Workspace Clearance Height Axis Plane )

( ============================================================================ )
( FINAL PRECISION COMPLIANCE FINISHING WALL CLEANUP CONTOUR PASS               )
( ============================================================================ )
( TOOL 08: 0.500" TITANIUM FINISHING CARBIDE FINISHING PROFILE BIT )
T08 M06 ( Execute Automated Mechanical Tool Change Sequence )
S2200 M03 ( Engage Spindle Drive: 2200 RPM Clockwise Rotational Direction )
M08 ( Re-engage High-Pressure Coolant Streams )

G00 X37.250 Y-2.000 ( Return to 0-Degree Cluster Reference Starting Coordinates )
G01 Z-0.250 F18.0 ( Drop to Final Full Cut Pocket Floor Profiling Height )
G43 H08 G41 ( Activate Tool Length Compensation and Left Tool Radius Cutter Compensation )
G03 X37.250 Y-2.000 I0.0 J2.000 F9.5 ( Continuous Side-Wall High-Gloss Shaving Pass )
G40 ( Deactivate Cutter Edge Radius Compensation Code Before Tool Extraction Move )

( --- SYSTEM SHUTDOWN TERMINATION RUN CLEANUP --- )
M09 ( Disengage High-Pressure Coolant Flow Streams )
G00 Z3.000 M05 ( Rapid Height Extraction Z-Lift / Spindle Drive Motor Stop )
G28 G90 X0 Y0 Z0 ( Force Complete Gantry Return Loop back To Home Reference Ground Zero )
M30 ( Complete Memory Program End and Auto-Rewind Control File Index Loop )
