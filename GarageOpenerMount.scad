/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  Gladiator_GearWall_Prints: GarageOpenerMount.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/Gladiator_GearWall_Prints
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  GNU GPLv3
&&
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/





/*?????????????????????????????????????????????????????????????????
??
/*???????????????????????????????????????????????????????
?? Section: Customizer
??
    Description:
        The Customizer feature provides a graphic user interface for editing model parameters.
??
???????????????????????????????????????????????????????*/
/* [Global] */
// Display Verbose Output?
$VERBOSE=1; // [0:No,1:Level=1,2:Level=2,3:Developer]

/* [Mounting Plate Parameters] */
// Plate Width (X-Axis)
x=173;                  // [45:0.1:250]
// Plate Depth (Y-Axis)
y=93.3;                 // [60:0.1:150]
// Plate Thickness (Z-Axis)
z=7.5;                  // [2:0.1:10]

/* [Mounting Hole Parameters] */
// Bolt Hole Diameter
hole_diameter=6.5;      // [3:0.1:8]
// Bolt Hole Depth
hole_depth=9.5;         // [4:0.1:10]
// Bolt Inset (From Mounting Plate Edge)
inset=2.5;              // [0:0.1:5]
// Bolt Hole Distance (From Center)
hole_distance=50.35;    // [25:0.01:75
// Bolt Tab Diameter
tab_diameter=12.5;      // [6:0.1:15]

/* [Miscellaneous] */
// "Offset" value to round corners on Mounting Bracket
o=5;
/*
?????????????????????????????????????????????????????????????????*/





/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section: Defined/Derived Variables
*/
/* [Hidden] */
// Width of Imported Reference Bracket
bracket_x=20;
// Depth of Imported Reference Bracket
bracket_y=105;
// Height of Imported Reference Bracket
bracket_z=21;
// Shift Mounting Plate to align screw holes to Imported Reference Bracket
shift=1.5;

// Constant: EPSILON
// Description: Represents the smallest positive value > 0
FLT_TRUE_MIN=1.401298e-45;
//EPSILON=FLT_TRUE_MIN;
EPSILON=1/128;
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/





/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subection: Main Object
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*/////////////////////////////////////////////////////*/
// Module: GarageOpenerMount()
// Usage:
//   GarageOpenerMount()
// Description:
//   Creates GarageOpenerMount Bracket
// Arguments:
//
///////////////////////////////////////////////////////*/
if($preview) {
    GarageOpenerMount();
}else{
    translate([0,0,x]) rotate([0,90,0]){
        GarageOpenerMount();
    }
}
module GarageOpenerMount(){
    difference(){
        union(){
            translate([0,0,bracket_z]){
                mounting_plate(x,y,z, o);
                translate([x/2,-tab_diameter/2,0])
                    mounting_tab(z, tab_diameter);
            }
            scale([x/bracket_x,1,1])
                gearwall_bracket(bracket_x,bracket_y,bracket_z);
        }
        translate([0,(shift-inset),bracket_z+z-hole_depth+EPSILON])
            top_mounting_holes(x,y,hole_depth, hole_diameter);
        // Bottom Center
        translate([x/2,-tab_diameter/2,bracket_z+hole_depth/2])
            cylinder(h=hole_depth,d=hole_diameter,center=true, $fn=360);
    }
}


//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subection: Reference Object(s) - "Derivative(s)"
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*/////////////////////////////////////////////////////*/
// Module: gearwall_bracket()
// Usage:
//   gearwall_bracket()
// Description:
//   Extracts the remainder of the bracket to be use in the new box mount
// Arguments:
//
///////////////////////////////////////////////////////*/
module gearwall_bracket(x,y,z){
    difference(){
        // https://www.thingiverse.com/make:495249
        import("./resources/BUM_GLADIATOR_6001_Simple_hook.STL");
        translate([-1,0,bracket_z])
            cube([x+2,y,z*3]);
    }
}



//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subection: "Mounting Plate" Object Module
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*/////////////////////////////////////////////////////*/
// Module: mounting_plate()
// Usage:
//   mounting_plate(x,y,z, o)
// Description:
//   Creates primary mounting plate structure
// Arguments:
//
// Example:
//   !mounting_plate(x,y,z, o);
//
///////////////////////////////////////////////////////*/
module mounting_plate(x,y,z, o){
    translate([x/2,y/2,0]){
        linear_extrude(z)
            offset(r=o, $fn=360) square([x-2*o,y-2*o], center=true);
    }
}
/*/////////////////////////////////////////////////////*/
// Module: mounting_tab()
// Usage:
//   mounting_tab(h,d)
// Description:
//   Creates Secondary tab used to hold mount in place
// Arguments:
//
// Example:
//   !mounting_tab(z, tab_diameter);
//
///////////////////////////////////////////////////////*/
module mounting_tab(h,d) {
    hull(){
        translate([0,d/2,h/2])
            cube([1.5*d,EPSILON,h],center=true);
        translate([0,d/4,h/2])
            cube([1.2*d,EPSILON,h],center=true);
    }
    hull(){
        translate([0,d/4,h/2])
            cube([1.2*d,EPSILON,h],center=true);
        cylinder(h=h,d=d, $fn=360);
    }
}
/*/////////////////////////////////////////////////////*/
// Module: top_mounting_holes()
// Usage:
//   top_mounting_holes(x,y,z, d)
// Description:
//   Creates relief holes for heat-set inserts
// Arguments:
//
// Example:
//   !top_mounting_holes(x,y,hole_depth, hole_diameter);
//
///////////////////////////////////////////////////////*/
module top_mounting_holes(x,y,z, d){
    translate([x/2,0,z/2]){
        // Top Center
        translate([0,y-d,0])
            cylinder(h=z,d=d,center=true, $fn=360);
        // Top Left
        translate([0-hole_distance,y-d,0]) 
            cylinder(h=z,d=d,center=true, $fn=360);
        // Top Right
        translate([0+hole_distance,y-d,0])
            cylinder(h=z,d=d,center=true, $fn=360);
    }
}
/*
/////////////////////////////////////////////////////////////////*/