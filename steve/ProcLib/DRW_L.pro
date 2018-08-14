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
//   deg2pixX     = scaling factor to go between degrees and pixels (see SEL_COOR.pro)
//   deg2pixY     = same as above
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013

declare DRW_L(float angle, float eccentricity, int color, float orientation, int fill, float conversion_X, float conversion_Y);

//Declare Variables - now declared in ALL_VARS.pro
//declare hide constant llength = 2;
//declare hide constant lwidth = 0.1;

	
process DRW_L(float angle, float eccentricity, int color, float orientation, int fill, float conversion_X, float conversion_Y)
	{
	
	//spawnwait L_ORIENT;
	
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_length;
	declare hide float half_width;
	
	declare hide float LHx1;
	declare hide float LHy1;
	declare hide float LHx2;
	declare hide float LHy2;

	declare hide float LVx1;
	declare hide float LVy1;
	declare hide float LVx2;
	declare hide float LVy2;


	
	// find the center of the box in x and y space based on the angle and eccentricity
	stim_ecc_x = cos(angle) * eccentricity;
	stim_ecc_y = sin(angle) * eccentricity;

	// find locations of upper left and lower right corners based on location of center and size
	half_length = llength/2;
	half_width = lwidth/2;

if (orientation == 1) //Upright L 
	{
	LHx1       = ((stim_ecc_x + half_length)*conversion_X);
	LHy1       = ((stim_ecc_y - half_length)*conversion_Y);
	LHx2       = ((stim_ecc_x - half_length)*conversion_X);
	LHy2       = ((stim_ecc_y - (half_length - lwidth))*conversion_Y);
	
	LVx1       = ((stim_ecc_x - half_length)*conversion_X);
	LVy1       = ((stim_ecc_y + half_length)*conversion_Y);
	LVx2       = ((stim_ecc_x - (half_length - lwidth))*conversion_X);
	LVy2       = ((stim_ecc_y - half_length)*conversion_Y); 
	}
 else if (orientation == 2) //Inverted L
	{
	LHx1       = ((stim_ecc_x - half_length)*conversion_X);
	LHy1       = ((stim_ecc_y + half_length)*conversion_Y);
	LHx2       = ((stim_ecc_x + half_length)*conversion_X);
	LHy2       = ((stim_ecc_y + (half_length - lwidth))*conversion_Y);
	
	LVx1       = ((stim_ecc_x - half_length)*conversion_X);
	LVy1       = ((stim_ecc_y + half_length)*conversion_Y);
	LVx2       = ((stim_ecc_x - (half_length - lwidth))*conversion_X);
	LVy2       = ((stim_ecc_y - half_length)*conversion_Y);
	}
 else if (orientation == 3) //Mirror L/left tilt
	{
	LHx1       = ((stim_ecc_x + half_length)*conversion_X);
	LHy1       = ((stim_ecc_y - half_length)*conversion_Y);
	LHx2       = ((stim_ecc_x - half_length)*conversion_X);
	LHy2       = ((stim_ecc_y - (half_length - lwidth))*conversion_Y);
	
	LVx1       = ((stim_ecc_x + half_length)*conversion_X);
	LVy1       = ((stim_ecc_y - half_length)*conversion_Y);
	LVx2       = ((stim_ecc_x + (half_length - lwidth))*conversion_X);
	LVy2       = ((stim_ecc_y + half_length)*conversion_Y);
	}
else if (orientation == 4) //Mirror Inverted L/right tilt
	{
	LHx1       = ((stim_ecc_x - half_length)*conversion_X);
	LHy1       = ((stim_ecc_y + half_length)*conversion_Y);
	LHx2       = ((stim_ecc_x + half_length)*conversion_X);
	LHy2       = ((stim_ecc_y + (half_length - lwidth))*conversion_Y);
	
	LVx1       = ((stim_ecc_x + half_length)*conversion_X);
	LVy1       = ((stim_ecc_y - half_length)*conversion_Y);
	LVx2       = ((stim_ecc_x + (half_length - lwidth))*conversion_X);
	LVy2       = ((stim_ecc_y + half_length)*conversion_Y);
    }
	 

// send video sync command to draw desired T orientation
	dsendf("co %d;\n",color);
	
	if(fill == 0)
		{
		dsendf("ru %d,%d,%d,%d\n", LHx1, LHy1, LHx2, LHy2);  // Horizontal line
		dsendf("ru %d,%d,%d,%d\n", LVx1, LVy1, LVx2, LVy2);  // Vertical line 
		}
	else
		{
		dsendf("rf %d,%d,%d,%d\n", LHx1, LHy1, LHx2, LHy2);  // Horizontal line
		dsendf("rf %d,%d,%d,%d\n", LVx1, LVy1, LVx2, LVy2);  // Vertical line 
		}

	}
	
	