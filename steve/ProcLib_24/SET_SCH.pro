// Sets up graph for search
// NOTE: GRAPHS.pro or OBJECT.pro needs to have been run already
// to set up globals.
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013

declare FirstSearchTrial = 1; 								// GLOBAL ALERT; Lets UPD8_SCH.pro know to reset counters

declare hide object_repeat;
declare hide object_random;

declare SET_SCH();

process SET_SCH()
	{
	FirstSearchTrial = 1;											// GLOBAL ALERT; Lets UPD8_SCH.pro know to reset counters

	oSetGraph(gRIGHT, aCLEAR);
	
	oSetGraph(gRIGHT,   										// Object graph virt. coord, 4 variables following aRANGE are xmin, xmax, ymin, ymax
			aRANGE, 
			-1000,  		
			1000,
			-1000, 
			1000);			

		
	
	oSetGraph(gRIGHT, aTITLE, "*** Repeat vs. Random Display Search RT ***");	// Graph title
	
	object_repeat = oCreate(tBOX, gRIGHT, 100, 100);		// Create repeat object 3rd argument width, 4th is height
    oSetAttribute(object_repeat, aINVISIBLE);						// Not visible yet
	
	object_random = oCreate(tBOX, gRIGHT, 100, 100);		// Create random object 3rd argument width, 4th is height
    oSetAttribute(object_random, aINVISIBLE);						// Not visible yet
		
	}