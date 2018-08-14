//--------------------------------------------------------------------------------------------------
// process CMD_PGS(int curr_target, 
				// float fixation_size, 
				// int fixation_color, 
				// int sig_color, 
				// float scr_width, 
				// float scr_height, 
				// float pd_left, 
				// float pd_bottom, 
				// float pd_size);
// Figure out all stimuli that will be needed on the next countermanding trial and
// place it all into video memory.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011


declare hide float 	Size;   																	// Global output will be sent as stobes...        										
declare hide float 	Angle;        																// ...by INFOS.pro at trial end.
declare hide float 	Eccentricity; 
declare hide int   	Color;								

declare CMD_PGS(int curr_target, 																// set SETC_TRL.pro
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ);                       										// see GRAPHS.pro

process CMD_PGS(int curr_target, 																// set SETC_TRL.pro
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				float scr_width,                        										// see RIGSETUP.pro
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
	declare hide float	pd_angleR;										
	declare hide float	pd_angleL;										
	declare hide float 	opposite;										
	declare hide float	adjacent;										
	declare hide float	stim_ecc_x;										
	declare hide float	stim_ecc_y;										
	declare hide int   	open        = 0;										
	declare hide int   	fill        = 1;										
	declare hide int   	pd1_color =  247 ;										

	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;										
	declare hide int	fixation_pd = 1;										
	declare hide int	fixation    = 2;										
	declare hide int	target_pd   = 3;										
	declare hide int	target      = 4;										
	declare hide int	signal_pd   = 5;										
	declare hide int	signal      = 6;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	size         = Size_list[curr_target];   													// Figure out the attributes of the current target 
	angle        = Angle_list[curr_target]; 													// THESE USER DEFINED GLOBALS ARE ARRAYS SO 
	eccentricity = Eccentricity_list[curr_target];												// THEY CANNOT BE PASSED INTO PROCESSES
	color        = curr_target + 1;																// zero is reserved for black.  see SET_CLRS.pro							
													
	stim_ecc_x = cos(angle) * eccentricity;														// find the center of the box in x and y space based on the angle and eccentricity...
	stim_ecc_y = sin(angle) * eccentricity * -1;												
	oMove(object_targ, stim_ecc_x*deg2pix_X, stim_ecc_y*deg2pix_Y);								// ...and move the animated graph object there.
	oSetAttribute(object_targ, aSIZE, size*deg2pix_X, size*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	
	opposite = ((scr_height/2));														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((scr_width/2));                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pd_eccentricity = sqrt((opposite * opposite) + (adjacent * adjacent));
	pd_angleR = rad2deg(atan (-opposite/adjacent));
	pd_angleL = pd_angleR + 180; 																	//change this for different quadrent or write some code for flexibility
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
	//dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_RECT(pd_size*3.5,pd_size,pd_angleR,pd_eccentricity,pd1_color,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	spawnwait DRW_RECT(pd_size*3.5,pd_size,pd_angleL,pd_eccentricity,pd1_color,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
 	dsendf("ps 246\n");
 	dsendf("pc 247, 0, 0x00FF0000, 0x00000000, 0x00000000\n");
    nexttick;
   
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 2	  
	// print("fixation");
	dsendf("rw %d,%d;\n",fixation,fixation);   													// draw second pg of video memory                                       
	//dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 3	 
	// print("target with photodiode");
	dsendf("rw %d,%d;\n",target_pd,target_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y); // draw fixation point
		}
	spawnwait DRW_RECT(pd_size*3.5,pd_size,pd_angleR,pd_eccentricity,pd1_color,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	spawnwait DRW_RECT(pd_size*3.5,pd_size,pd_angleL,pd_eccentricity,pd1_color,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
   
	
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 4	  
	// print("target");
	dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);         	// draw target
	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y);   	// draw fixation point
		}
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5 
	// print("signal with photodiode");
	dsendf("rw %d,%d;\n",signal_pd,signal_pd);    												// draw pg 5                                      
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);         	// draw target
	if (Classic)
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, sig_color, fill, deg2pix_X, deg2pix_Y);   		// draw stop signal/ignore stim
	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y); // draw fixation point
		}
	spawnwait DRW_RECT(pd_size*3.5,pd_size,pd_angleR,pd_eccentricity,pd1_color,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	spawnwait DRW_RECT(pd_size*3.5,pd_size,pd_angleL,pd_eccentricity,pd1_color,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
   
	
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	 
	// print("signal");
	dsendf("rw %d,%d;\n",signal,signal);   														// draw pg 6                                       					
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, sig_color, fill, deg2pix_X, deg2pix_Y);   		// draw stop signal/ignore stim
	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y); // draw fixation point
		}
	nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	nexttick;
	
	}