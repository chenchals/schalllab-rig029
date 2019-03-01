//------------------------------------------------------------------------
// process SET_COOR(float scr_width, float scr_height, float subj_dist);
// determine virtual coordiates in degrees based on screen size and
// subject distance to the screen
// NOTE 1:  all measurements must be in the same units (doesn't matter what units).
// NOTE 2:  accuracy (and hence step size of stimuli) is in 0.1 degree incriments
// NOTE 3:  since accuracy is in 0.1 degree incriments, input measurements must
// 			have corresponding resolution (this depends on distance from screen)
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011



						/*OUTPUT: these conversion factors will be used throughout protocol when drawing
				         (this is necessary b/c unless you are really careful with virtual coordinates
				         you wil end up with stimuli which are slightly off, and what is the point of
				         using virtual coordinates if you have to be super careful about it?)*/


declare SET_COOR(float scr_width,						// see RIGSETUP.pro for variable explanation
				float scr_height,
				float subj_dist,
				int scr_pixX,
				int scr_pixY);

process SET_COOR(float scr_width, 						// see RIGSETUP.pro for variable explanation
				float scr_height,
				float subj_dist,
				int scr_pixX,
				int scr_pixY)
	{

	declare hide float half_width;
	declare hide float half_height;
	declare hide float deg_x;
	declare hide float deg_y;

	// get half of screen size
	half_width  = scr_width / 2;  						// right now we are thinking about cm, inches, mm, or whatever you measured in
	half_height = scr_height / 2;

	// figure out dimensions in degrees
	deg_x  = rad2deg(atan (half_width / subj_dist)); 	//tangent(theta) = opposite/adjacent
	deg_y  = rad2deg(atan (half_height / subj_dist));

	// get half of screen size in pixels
	half_width  = scr_pixX / 2;  						// now we are thinking about pixels
	half_height = scr_pixY / 2;

	// set screen in pixel coordinates with the origin in center
	dsendf("vc %d, %d, %d, %d\n",-1*half_width,half_width,half_height,-1*half_height);

	Deg2Pix_X = half_width/deg_x;
	Deg2Pix_Y = half_height/deg_y;

	Unit2Pix_X = scr_pixX/scr_width;
	Unit2Pix_Y = scr_pixY/scr_height;

	printf("Deg2Pix_X %0.4d, Deg2Pix_X %0.4d\n",Deg2Pix_X,Deg2Pix_Y);
	printf("Unit2Pix_X %0.4d, Unit2Pix_X %0.4d\n",Unit2Pix_X,Unit2Pix_X);

	}
