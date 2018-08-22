/* OBJECT.PRO - Definitions for use with TEMPO's object functions
** Copyright 1994-2002 Reflective Computing.  All rights reserved.
**
*/

// Graph references used in oCreate() and oSetGraph()

hide constant gLEFT           =0;             // Left graph
hide constant gRIGHT          =1;             // Right graph

// Object types for use with oCreate()

hide constant tPOINT          =1;             // A single pixel
hide constant tBOX            =2;             // A rectangle
hide constant tCROSS          =3;             // '+' Horizontal/Vertical Cross
hide constant tXCROSS         =4;             // 'x' Diagonal Cross
hide constant tELLIPSE        =5;             // An ellipse (VideoSYNC only)

// Object attributes used by oSetAttribute()

hide constant aXOR            =1;             // Erase object when moving
hide constant aREPLACE        =2;             // Replace pixels
hide constant aVISIBLE        =3;             // Make object visible
hide constant aINVISIBLE      =4;             // Don't draw object
hide constant aFILLED         =5;             // Filled rectangle
hide constant aUNFILLED       =6;             // Hollow rectangle
hide constant aSIZE           =7;             // Resize box, cross, plus

// Graph attributes used by oSetGraph()

hide constant aRANGE          =1;             // Define graph coordinate system
hide constant aTITLE          =2;             // Define graph title
hide constant aCLEAR          =3;             // Clear graph

declare hide oB, oE;                    	  // Eye and Box objects (left graph)
declare hide oB1, oE1;                        // Eye and Box objects (right graph)


declare GRAPHS(int Scr_pixX, int Scr_pixY);

process GRAPHS(int Scr_pixX, int Scr_pixY)
	{
	// SETUP UP TARGET & EYE OBJECTS IN LEFT GRAPH
	left = Scr_pixX/-2;
	right = Scr_pixX/2;
	down = Scr_pixY/-2;
	up = Scr_pixY/2;
    oSetGraph(gleft, arange, left, right, down, up); // Object graph virt. coord
    // oB = oCreate(tBOX, gLEFT, 0.5, 0.5);    // Create TARGET object
    // oSetAttribute(oB, aINVISIBLE);              // Not visible yet

    oE = oCreate(tCross, gLEFT, 50, 50);       // Create EYE object
    oSetAttribute(oE, aVISIBLE);                // It's always visible

    // dsendf("oc 1,3\n");                          // Cross hair for "eye"
    // dsendf("ow 1,20,20\n");                      // width & height
    // dsendf("oi 1,13\n");                         // color
    // dsendf("os 1\n");                            // make visible
	}