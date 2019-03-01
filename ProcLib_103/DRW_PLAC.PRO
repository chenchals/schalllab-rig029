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

declare DRW_PLAC(float angle, float eccentricity, int color, int fill, float conversion_X, float conversion_Y);

process DRW_PLAC(float angle, float eccentricity, int color, int fill, float conversion_X, float conversion_Y)
	{
	
	
	/////////////////////////Below code is identical to DRW_SQR.pro. If using smaller width stimuli should revert to commented code
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_size;
	declare hide int ulx;
	declare hide int uly;
	declare hide int lrx;
	declare hide int lry;
	
	// find the center of the box in x and y space based on the angle and eccentricity
	stim_ecc_x = cos(angle) * eccentricity;
	stim_ecc_y = sin(angle) * eccentricity;

	// find locations of upper left and lower right corners based on location of center and size

		half_size = llength/2;

	
	ulx       = round((stim_ecc_x - half_size)*conversion_X);
	uly       = round((stim_ecc_y + half_size)*conversion_Y);
	lrx       = round((stim_ecc_x + half_size)*conversion_X);
	lry       = round((stim_ecc_y - half_size)*conversion_Y);

	
	// send video sync command to draw desired square
	dsendf("co %d;\n",color);
	
	if(fill == 0)
		{
		dsendf("ru %d,%d,%d,%d;\n",ulx,uly,lrx,lry);
		}
	else
		{
		dsendf("rf %d,%d,%d,%d;\n",ulx,uly,lrx,lry);
		}
		
		
		
		
		
	/* 
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_length;
	declare hide float half_width;
	//top horizontal placeholder line
	declare hide float PH1x1;
	declare hide float PH1y1;
	declare hide float PH1x2;
	declare hide float PH1y2;
	//middle horizontal placeholder line
	declare hide float PH2x1;
	declare hide float PH2y1;
	declare hide float PH2x2;
	declare hide float PH2y2;
	//bottom horizontal placeholder line
	declare hide float PH3x1;
	declare hide float PH3y1;
	declare hide float PH3x2;
	declare hide float PH3y2;
	//left vertical placeholder line
	declare hide float PV1x1;
	declare hide float PV1y1;
	declare hide float PV1x2;
	declare hide float PV1y2;
	//middle vertical placeholder line
	declare hide float PV2x1;
	declare hide float PV2y1;
	declare hide float PV2x2;
	declare hide float PV2y2;
	//right vertical placeholder line
	declare hide float PV3x1;
	declare hide float PV3y1;
	declare hide float PV3x2;
	declare hide float PV3y2;	
	
	// find the center of the box in x and y space based on the angle and eccentricity
	stim_ecc_x = cos(angle) * eccentricity;
	stim_ecc_y = sin(angle) * eccentricity;

	// find locations of upper left and lower right corners based on location of center and size
	half_length = llength/2;
	half_width = lwidth/2;


// top horizontal
	PH1x1       = ((stim_ecc_x - half_length)*conversion_X);
	PH1y1       = ((stim_ecc_y + half_length)*conversion_Y);
	PH1x2       = ((stim_ecc_x + half_length)*conversion_X);
	PH1y2       = ((stim_ecc_y + (half_length - lwidth))*conversion_Y);
// middle horizontal
	PH2x1       = ((stim_ecc_x - half_length)*conversion_X);
	PH2y1       = ((stim_ecc_y + half_width)*conversion_Y);
	PH2x2       = ((stim_ecc_x + half_length)*conversion_X);
	PH2y2       = ((stim_ecc_y - half_width)*conversion_Y);
//bottom horizontal
	PH3x1       = ((stim_ecc_x + half_length)*conversion_X);
	PH3y1       = ((stim_ecc_y - half_length)*conversion_Y);
	PH3x2       = ((stim_ecc_x - half_length)*conversion_X);
	PH3y2       = ((stim_ecc_y - (half_length - lwidth))*conversion_Y);
//left vertical	
	PV1x1       = ((stim_ecc_x - half_length)*conversion_X);
	PV1y1       = ((stim_ecc_y + half_length)*conversion_Y);
	PV1x2       = ((stim_ecc_x - (half_length - lwidth))*conversion_X);
	PV1y2       = ((stim_ecc_y - half_length)*conversion_Y); 
//middle vertical
	PV2x1       = ((stim_ecc_x - half_width)*conversion_X);
	PV2y1       = ((stim_ecc_y - half_length)*conversion_Y);
	PV2x2       = ((stim_ecc_x + half_width)*conversion_X);
	PV2y2       = ((stim_ecc_y + half_length)*conversion_Y);
//right vertical
	PV3x1       = ((stim_ecc_x + half_length)*conversion_X);
	PV3y1       = ((stim_ecc_y - half_length)*conversion_Y);
	PV3x2       = ((stim_ecc_x + (half_length - lwidth))*conversion_X);
	PV3y2       = ((stim_ecc_y + half_length)*conversion_Y);

	
// send video sync command to draw desired T orientation
	dsendf("co %d;\n",color);
	
	if(fill == 0)
		{
		dsendf("ru %d,%d,%d,%d\n", PH1x1, PH1y1, PH1x2, PH1y2);  // top horizontal line
		dsendf("ru %d,%d,%d,%d\n", PH2x1, PH2y1, PH2x2, PH2y2);  // middle horizontal line
		dsendf("ru %d,%d,%d,%d\n", PH3x1, PH3y1, PH3x2, PH3y2);  // bottom horizontal line
		
		dsendf("ru %d,%d,%d,%d\n", PV1x1, PV1y1, PV1x2, PV1y2);  // left vertical line
		dsendf("ru %d,%d,%d,%d\n", PV2x1, PV2y1, PV2x2, PV2y2);  // middle vertical line
		dsendf("ru %d,%d,%d,%d\n", PV3x1, PV3y1, PV3x2, PV3y2);  // right vertical line
		}
	else
		{
		dsendf("rf %d,%d,%d,%d\n", PH1x1, PH1y1, PH1x2, PH1y2);  // top horizontal line
		dsendf("rf %d,%d,%d,%d\n", PH2x1, PH2y1, PH2x2, PH2y2);  // middle horizontal line
		dsendf("rf %d,%d,%d,%d\n", PH3x1, PH3y1, PH3x2, PH3y2);  // bottom horizontal line
		
		dsendf("rf %d,%d,%d,%d\n", PV1x1, PV1y1, PV1x2, PV1y2);  // left vertical line
		dsendf("rf %d,%d,%d,%d\n", PV2x1, PV2y1, PV2x2, PV2y2);  // middle vertical line
		dsendf("rf %d,%d,%d,%d\n", PV3x1, PV3y1, PV3x2, PV3y2);  // right vertical line 
		} */

	}
	
	