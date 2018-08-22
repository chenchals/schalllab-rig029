// Sets up Inhibition function graph for cmanding 
// NOTE: GRAPHS.pro or OBJECT.pro needs to have been run already
// to set up globals.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare FirstStopTrial = 1; 								// GLOBAL ALERT; Lets UPD8_INH.pro know to reset counters

declare hide object_ssd0 ;
declare hide object_ssd1 ;
declare hide object_ssd2 ;
declare hide object_ssd3 ;
declare hide object_ssd4 ;
declare hide object_ssd5 ;
declare hide object_ssd6 ;
declare hide object_ssd7 ;
declare hide object_ssd8 ;
declare hide object_ssd9 ;
declare hide object_ssd10;
declare hide object_ssd11;
declare hide object_ssd12;
declare hide object_ssd13;
declare hide object_ssd14;
declare hide object_ssd15;
declare hide object_ssd16;
declare hide object_ssd17;
declare hide object_ssd18;
declare hide object_ssd19;
declare hide object_30_70;

declare SET_INH(int max_ssd, 
				int min_ssd,
				int n_ssds);

process SET_INH(int max_ssd, 
				int min_ssd,
				int n_ssds)
	{
	declare int ssd_range;
	declare int inh_left;
	declare int inh_right;
	declare int inh_box_size;
	
	FirstStopTrial = 1;											// GLOBAL ALERT; Lets UPD8_INH.pro know to reset counters

	ssd_range = (max_ssd - min_ssd) * 1000;
	
	oSetGraph(gRIGHT, aCLEAR);
	
	if (min_ssd == max_ssd)
		{
		ssd_range = 200000;
		}
		
	inh_left = (min_ssd * 1000) - (ssd_range/40);
	inh_right = (max_ssd * 1000) + (ssd_range/40);
	
	oSetGraph(gRIGHT,   										// Object graph virt. coord
			aRANGE, 
			inh_left,  		
			inh_right,
			1025, 
			-25);			

	inh_box_size = (ssd_range/20);		
	
	oSetGraph(gRIGHT, aTITLE, "*** INHIBITION FUNCTION ***");	// Graph title
	
	object_ssd0 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object (20 is max b/c defaults.  could be changed.)
    oSetAttribute(object_ssd0, aINVISIBLE);						// Not visible yet
	
	object_ssd1 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd1, aINVISIBLE);						// Not visible yet
	
	object_ssd2 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd2, aINVISIBLE);						// Not visible yet
	
	object_ssd3 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd3, aINVISIBLE);						// Not visible yet
	
	object_ssd4 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd4, aINVISIBLE);						// Not visible yet
	
	object_ssd5 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd5, aINVISIBLE);						// Not visible yet
	
	object_ssd6 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd6, aINVISIBLE);						// Not visible yet
	
	object_ssd7 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd7, aINVISIBLE);						// Not visible yet
	
	object_ssd8 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd8, aINVISIBLE);						// Not visible yet
	
	object_ssd9 = oCreate(tBOX, gRIGHT, inh_box_size, 50);		// Create SSD object
    oSetAttribute(object_ssd9, aINVISIBLE);						// Not visible yet
	
	object_ssd10 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd10, aINVISIBLE);						// Not visible yet
	
	object_ssd11 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd11, aINVISIBLE);						// Not visible yet
	
	object_ssd12 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd12, aINVISIBLE);						// Not visible yet
	
	object_ssd13 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd13, aINVISIBLE);						// Not visible yet
	
	object_ssd14 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd14, aINVISIBLE);						// Not visible yet
	
	object_ssd15 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd15, aINVISIBLE);						// Not visible yet
	
	object_ssd16 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd16, aINVISIBLE);						// Not visible yet
	
	object_ssd17 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd17, aINVISIBLE);						// Not visible yet
	
	object_ssd18 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd18, aINVISIBLE);						// Not visible yet
	
	object_ssd19 = oCreate(tBOX, gRIGHT, inh_box_size, 50);	// Create SSD object
    oSetAttribute(object_ssd19, aINVISIBLE);						// Not visible yet
	
	object_30_70 = oCreate(tBOX, gRIGHT,inh_right, 400);	// Create SSD object
    oSetAttribute(object_30_70, aVISIBLE, aUNFILLED);
	oMOVE(object_30_70,inh_left + ((inh_right - inh_left) / 2), 500);
	
	}