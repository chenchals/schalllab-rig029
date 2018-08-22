//------------------------------
// process DRW_RECT(horizLn,vertLn,angle,eccentricity,color,fill)
// Draw a rectangle on the video sync screen
//
// INPUT
// 		horizLn 		= how wide do you want the rectangle to be? (know virtual coordinate system)
//		vertLn 			= how tall do you want the rectangle to be? (know virtual coordinate system)
//		angle 			= in cartesian coordinates
// 		eccentricity 	= know virtual coordinate system
//		color 			= color of box (must know current palettes)
//		fill			= 0 (no fill) or 1 (fill)
//		deg2pixX 		= scaling factor to go between degrees and pixels
// 		deg2pixY 		= same as above
//
//  written by kaleb.a.lowe@vanderbilt.edu - started 10/3/16
// 
// Based on DRW_SQ by david.c.godlove@vanderbilt.edu

declare DRW_RECT(float horizLn, float vertLn, float angle, float eccentricity, int color, int fill, float conversion_X, float conversion_Y);

process DRW_RECT(float horizLn, float vertLn, float angle, float eccentricity, int color, int fill, float conversion_X, float conversion_Y)
{
	declare hide float stim_ecc_x;
	declare hide float stim_ecc_y;
	declare hide float half_sizeH;
	declare hide float half_sizeV;
	declare hide int ulx;
	declare hide int uly;
	declare hide int lrx;
	declare hide int lry;
	
	// find the center of the box in x and y space based on the angle and eccentricity
	stim_ecc_x = cos(angle) * eccentricity;
	stim_ecc_y = sin(angle) * eccentricity;

	// find locations of upper left and lower right corners based on location of center and size
	half_sizeH = horizLn/2;
	half_sizeV = vertLn/2;
	ulx       = round((stim_ecc_x - half_sizeH)*conversion_X);
	uly       = round((stim_ecc_y + half_sizeV)*conversion_Y);
	lrx       = round((stim_ecc_x + half_sizeH)*conversion_X);
	lry       = round((stim_ecc_y - half_sizeV)*conversion_Y);

	//printf("DRW_RECT: ulx = %d,uly = %d, lrx = %d, lry = %d\n",ulx,uly,lrx,lry);
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

}