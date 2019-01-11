//--------------------------------------------------------------------------------------------------
// process DRW_T(angle,eccentricity,color,fill)
// Draw a T on the video sync screen
//
// INPUT
//	 size         = how big do you want the square to be?  (must know your virtual coordiate system)
//	 angle 		  = in cartesian coordinates
//   eccentricity = once again you must know your virtual coordiate system
//   color        = color of box (must know the current pallettes you are using)
//   fill         = 0 (no fill) or 1 (fill)
//   deg2pixX     = scaling factor to go between degrees and pixels (see SET_COOR.pro)
//   deg2pixY     = same as above
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013

declare PA_CON(float angle, float eccentricity, int color, float orientation, int fill, float conversion_X, float conversion_Y);


//Declare Variables - now declared in ALL_VARS.pro
// declare hide constant llength = 2;
// declare hide constant lwidth = 0.1;

process PA_CON(float angle, float eccentricity, int color, float orientation, int fill, float conversion_X, float conversion_Y)
	{
	
	//spawnwait T_ORIENT;
	
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_length;
	declare hide float half_width;
	
	declare hide float THx1;
	declare hide float THy1;
	declare hide float THx2;
	declare hide float THy2;

	declare hide float TVx1;
	declare hide float TVy1;
	declare hide float TVx2;
	declare hide float TVy2;


	
	// find the center of the box in x and y space based on the angle and eccentricity
	stim_ecc_x = cos(angle) * eccentricity;
	stim_ecc_y = sin(angle) * eccentricity;

	// find locations of upper left and lower right corners based on location of center and size
	half_length = llength/2;
	half_width = lwidth/2;

if (orientation == 1) //Upright T 
	{
	THx1       = ((stim_ecc_x - half_length)*conversion_X);
	THy1       = ((stim_ecc_y + half_length)*conversion_Y);
	THx2       = ((stim_ecc_x + half_length)*conversion_X);
	THy2       = ((stim_ecc_y + (half_length - lwidth))*conversion_Y);
	
	TVx1       = ((stim_ecc_x - half_width)*conversion_X);
	TVy1       = ((stim_ecc_y - half_length)*conversion_Y);
	TVx2       = ((stim_ecc_x + half_width)*conversion_X);
	TVy2       = ((stim_ecc_y + half_length)*conversion_Y);
	}
else if (orientation == 2) //Inverted T 
	{
	THx1       = ((stim_ecc_x + half_length)*conversion_X);
	THy1       = ((stim_ecc_y - half_length)*conversion_Y);
	THx2       = ((stim_ecc_x - half_length)*conversion_X);
	THy2       = ((stim_ecc_y - (half_length - lwidth))*conversion_Y);
	
	TVx1       = ((stim_ecc_x - half_width)*conversion_X);
	TVy1       = ((stim_ecc_y - half_length)*conversion_Y);
	TVx2       = ((stim_ecc_x + half_width)*conversion_X);
	TVy2       = ((stim_ecc_y + half_length)*conversion_Y); 
	}
else if (orientation == 3) //Left Tilted T 
	{
	THx1       = ((stim_ecc_x - half_length)*conversion_X);
	THy1       = ((stim_ecc_y + half_width)*conversion_Y);
	THx2       = ((stim_ecc_x + half_length)*conversion_X);
	THy2       = ((stim_ecc_y - half_width)*conversion_Y);
	
	TVx1       = ((stim_ecc_x - half_length)*conversion_X);
	TVy1       = ((stim_ecc_y + half_length)*conversion_Y);
	TVx2       = ((stim_ecc_x - (half_length - lwidth))*conversion_X);
	TVy2       = ((stim_ecc_y - half_length)*conversion_Y); 
	}
else if (orientation == 4) //Right Tilted T 
	{
	THx1       = ((stim_ecc_x - half_length)*conversion_X);
	THy1       = ((stim_ecc_y + half_width)*conversion_Y);
	THx2       = ((stim_ecc_x + half_length)*conversion_X);
	THy2       = ((stim_ecc_y - half_width)*conversion_Y);
	
	TVx1       = ((stim_ecc_x + half_length)*conversion_X);
	TVy1       = ((stim_ecc_y - half_length)*conversion_Y);
	TVx2       = ((stim_ecc_x + (half_length - lwidth))*conversion_X);
	TVy2       = ((stim_ecc_y + half_length)*conversion_Y);
    }
	

// send video sync command to draw desired T orientation
	dsendf("co %d;\n",color);
	
	if(fill == 0)
		{
		dsendf("ru %d,%d,%d,%d\n", THx1, THy1, THx2, THy2);  // Horizontal line
		dsendf("ru %d,%d,%d,%d\n", TVx1, TVy1, TVx2, TVy2);  // Vertical line 
		}
	else
		{
		dsendf("rf %d,%d,%d,%d\n", THx1, THy1, THx2, THy2);  // Horizontal line
		dsendf("rf %d,%d,%d,%d\n", TVx1, TVy1, TVx2, TVy2);  // Vertical line 
		}

	}
	
	