//--------------------------------------------------------------------------------------------------
// process FLS_PGS();


declare FLS_PGS(float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ);                       										// see GRAPHS.pro

process FLS_PGS(float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ)                        										// see GRAPHS.pro
	{										
											
	declare hide float 	pd_eccentricity;										
	declare hide float	pd_angle;								
	declare hide int   	fill        = 1;	
	declare hide float 	opposite;										
	declare hide float	adjacent;	
	
	// number the pgs that need to be drawn
	declare hide int   	blank	= 0;										
	declare hide int	flash	= 1;										
	
	// Give the color a number
	declare hide int 	flash_color = 251;
	
	spawnwait SET_CLRS(1);
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	
	opposite = ((scr_height/2)-pd_bottom);														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((scr_width/2)-pd_left);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pd_eccentricity = sqrt((opposite * opposite) + (adjacent * adjacent));
	pd_angle = rad2deg(atan (opposite / adjacent));
	pd_angle = pd_angle + 180; 																	//change this for different quadrent or write some code for flexibility
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",flash,flash); 															// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	//spawnwait DRW_SQR(40.0, 0.0, 0.0, 15, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	//spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	spawnwait DRW_SQR(40.0, 0.0, 0.0, flash_color, fill, deg2pix_X, deg2pix_Y);   						// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	
	
	}