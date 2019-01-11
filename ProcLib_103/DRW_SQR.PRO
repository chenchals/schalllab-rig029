//--------------------------------------------------------------------------------------------------
// process DRW_SQR(size,angle,eccentricity,color,fill)
// Draw a square on the video sync screen
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
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare DRW_SQR(float size, float angle, float eccentricity, int color, int fill, float conversion_X, float conversion_Y);

process DRW_SQR(float size, float angle, float eccentricity, int color, int fill, float conversion_X, float conversion_Y)
	{
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
	nexttick;
	
	// find locations of upper left and lower right corners based on location of center and size
	half_size = size/2;
	ulx       = round((stim_ecc_x - half_size)*conversion_X);
	uly       = round((stim_ecc_y + half_size)*conversion_Y);
	lrx       = round((stim_ecc_x + half_size)*conversion_X);
	lry       = round((stim_ecc_y - half_size)*conversion_Y);

	printf("DRW_SQR: fixation_size %0.2d\n",fixation_size);
	printf("DRW_SQR: ulx = %d,uly = %d, lrx = %d, lry = %d\n",ulx,uly,lrx,lry);
	
	// send video sync command to draw desired square
	nexttick;
	dsendf("co %d;\n",color);
	
	if(fill == 0)
		{
		dsendf("ru %d,%d,%d,%d;\n",ulx,uly,lrx,lry);
		}
	else
		{
		dsendf("rf %d,%d,%d,%d;\n",ulx,uly,lrx,lry);
		}

	}