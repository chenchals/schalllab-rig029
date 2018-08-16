declare FirstSOATrial = 1; 								// GLOBAL ALERT; Lets UPD8_INH.pro know to reset counters

declare hide object_soa0;
declare hide object_soa1;
declare hide object_soa2;
declare hide object_soa3;
declare hide object_soa4;
declare hide object_soa5;
declare hide object_soa6;
declare hide object_soa7;
declare hide object_soa8;
declare hide object_soa9;
declare hide object_soa10;
declare hide object_soa11;
declare hide object_soa12;
declare hide object_soa13;
declare hide object_soa14;
declare hide object_soa15;
declare hide object_soa16;
declare hide object_soa17;
declare hide object_soa18;
declare hide object_soa19;
declare hide object_30_70;

declare SET_SOA(int max_soa, 
				int min_soa,
				int n_soas);

process SET_SOA(int max_soa, 
				int min_soa,
				int n_soas)
	{
	declare int soa_range;
	declare int soa_left;
	declare int soa_right;
	declare int soa_box_size;
//	declare int n_soas;
	
	
	FirstSOATrial = 1;											// GLOBAL ALERT; Lets UPD8_INH.pro know to reset counters

	soa_range = (max_soa - min_soa);
	
	oSetGraph(gRIGHT, aCLEAR);
	
	if (min_soa == max_soa)
		{
		soa_range = 200000;
		}
		
	soa_left = 500;
	soa_right = 1500;
	print("x axis = %d\n",soa_left);
	print("y axis = %d\n",soa_right);
	oSetGraph(gRIGHT,   										// Object graph virt. coord
			aRANGE, 
			soa_left,  		
			soa_right,
			500, 
			100);			

	soa_box_size = 15;	
	
	oSetGraph(gRIGHT, aTITLE, "*** SOA FUNCTION ***");	// Graph title
	
	object_soa0 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object (20 is max b/c defaults.  could be changed.)
    oSetAttribute(object_soa0, aVISIBLE);						// Not visible yet
	
	object_soa1 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa1, aINVISIBLE);						// Not visible yet
	
	object_soa2 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa2, aINVISIBLE);						// Not visible yet
	
	object_soa3 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa3, aINVISIBLE);						// Not visible yet
	
	object_soa4 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa4, aINVISIBLE);						// Not visible yet
	
	object_soa5 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa5, aINVISIBLE);						// Not visible yet
	
	object_soa6 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa6, aINVISIBLE);						// Not visible yet
	
	object_soa7 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa7, aINVISIBLE);						// Not visible yet
	
	object_soa8 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa8, aINVISIBLE);						// Not visible yet
	
	object_soa9 = oCreate(tBOX, gRIGHT, soa_box_size, 15);		// Create SSD object
    oSetAttribute(object_soa9, aINVISIBLE);						// Not visible yet
	
	object_soa10 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa10, aINVISIBLE);						// Not visible yet
	
	object_soa11 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa11, aINVISIBLE);						// Not visible yet
	
	object_soa12 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa12, aINVISIBLE);						// Not visible yet
	
	object_soa13 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa13, aINVISIBLE);						// Not visible yet
	
	object_soa14 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa14, aINVISIBLE);						// Not visible yet
	
	object_soa15 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa15, aINVISIBLE);						// Not visible yet
	
	object_soa16 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa16, aINVISIBLE);						// Not visible yet
	
	object_soa17 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa17, aINVISIBLE);						// Not visible yet
	
	object_soa18 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa18, aINVISIBLE);						// Not visible yet
	
	object_soa19 = oCreate(tBOX, gRIGHT, soa_box_size, 15);	// Create SSD object
    oSetAttribute(object_soa19, aINVISIBLE);						// Not visible yet
	
	//object_30_70 = oCreate(tBOX, gRIGHT,soa_right, 200);	// Create SSD object
    //oSetAttribute(object_30_70, aVISIBLE, aUNFILLED);
	//oMOVE(object_30_70,soa_left + ((soa_right - soa_left) / 2), 100);
	}
	