// Modified version of OBJECT.pro which sets globals neccessary for use with
// animated graphs and also sets graphs up for countermanding task.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

// Graph references used in oCreate() and oSetGraph()

hide constant gLEFT           =0;             						// Left graph
hide constant gRIGHT          =1;             						// Right graph
						
// Object types for use with oCreate()						
						
hide constant tPOINT          =1;             						// A single pixel
hide constant tBOX            =2;             						// A rectangle
hide constant tCROSS          =3;             						// '+' Horizontal/Vertical Cross
hide constant tXCROSS         =4;             						// 'x' Diagonal Cross
hide constant tELLIPSE        =5;             						// An ellipse (VideoSYNC only)
						
// Object attributes used by oSetAttribute()						
						
hide constant aXOR            =1;             						// Erase object when moving
hide constant aREPLACE        =2;             						// Replace pixels
hide constant aVISIBLE        =3;             						// Make object visible
hide constant aINVISIBLE      =4;             						// Don't draw object
hide constant aFILLED         =5;             						// Filled rectangle
hide constant aUNFILLED       =6;             						// Hollow rectangle
hide constant aSIZE           =7;             						// Resize box, cross, plus
			
// Graph attributes used by oSetGraph()			
			
hide constant aRANGE          =1;									// Define graph coordinate system
hide constant aTITLE          =2;									// Define graph title
hide constant aCLEAR          =3;									// Clear graph
			
declare hide object_fixwin,											// Eye and Box objects (left graph)
			object_eye,
			object_targwin,
			object_fix,
			object_targ;
			                 	  



declare GRAPHS(int scr_pixX, 
				int scr_pixY,
				float deg2pix_X,
				float deg2pix_Y);

process GRAPHS(int scr_pixX, 
				int scr_pixY,
				float deg2pix_X,
				float deg2pix_Y)
	{
	
	declare hide int left, right, down, up;
	
	
	
	oSetGraph(gleft, aCLEAR);
	
	// SETUP UP TARGET & EYE OBJECTS IN LEFT GRAPH
	left 	= Scr_pixX/-2;
	right 	= Scr_pixX/2;
	up 		= Scr_pixY/-2;
	down 	= Scr_pixY/2;
	
    oSetGraph(gleft, aRANGE, left, right, up, down);				// Object graph virt. coord
	oSetGraph(gleft, aTITLE, "*** TASK ***");						// Graph title
				
    object_fixwin = oCreate(tBOX, gLEFT, 0, 0);						// Create fix window object
    oSetAttribute(object_fixwin, aINVISIBLE);						// Not visible yet	
				
	object_targwin = oCreate(tBOX, gLEFT, 0, 0);					// Create target window object
    oSetAttribute(object_targwin, aINVISIBLE);						// Not visible yet
				
	object_fix = oCreate(tBOX, gLEFT, 0, 0);						// Create fix window object
    oSetAttribute(object_fix,aFILLED);								// Draw it filled
	oSetAttribute(object_fix, aINVISIBLE);							// Not visible yet	
				
	object_targ = oCreate(tBOX, gLEFT, 0, 0);						// Create target window object
	oSetAttribute(object_targ,aFILLED);								// Draw it filled
    oSetAttribute(object_targ, aINVISIBLE);							// Not visible yet
	
    object_eye = oCreate(tCross, gLEFT, 2*deg2pix_X, 2*deg2pix_Y);	// Create EYE object
	oSetAttribute(object_eye, aVISIBLE);							// It's always visible
	

	
	
	
	
	
	
	}		