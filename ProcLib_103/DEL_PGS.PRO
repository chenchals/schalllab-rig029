//modifed by Namsoo 5/23/2012

declare hide float 	Size;   																	// Global output will be sent as stobes...        										
declare hide float 	Angle;        																// ...by INFOS.pro at trial end.
declare hide float 	Eccentricity; 
declare hide int   	Color;								

declare DEL_PGS(int curr_target, 																// set SETC_TRL.pro
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
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

process DEL_PGS(int curr_target, 																// set SETC_TRL.pro
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ)	                       										// see GRAPHS.pro
	{										
											
	declare hide float 	pd_eccentricity;										
	declare hide float	pd_angle;										
	declare hide float 	opposite;										
	declare hide float	adjacent;										
	declare hide float	stim_ecc_x;										
	declare hide float	stim_ecc_y;										
	declare hide int   	open        = 0;										
	declare hide int   	fill        = 1;										
	
	// number the pgs that need to be drawn
	declare hide int   	blank       		= 0;	
	declare hide int	fixation_pd			= 1;										
	declare hide int	fixation    		= 2;
	declare hide int	fixation_target_pd	= 3;	
	declare hide int    fixation_target		= 4;
	declare hide int	target_pd   		= 5;	
	declare hide int	target       		= 6;	

	
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
	
	opposite = ((scr_height/2)-pd_bottom);														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((scr_width/2)-pd_left);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pd_eccentricity = sqrt((opposite * opposite) + (adjacent * adjacent));
	pd_angle = rad2deg(atan (opposite / adjacent));
	pd_angle = pd_angle + 180; 																	//change this for different quadrent or write some code for flexibility
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw second pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 2	  
	// print("fixation");
	dsendf("rw %d,%d;\n",fixation,fixation);   													// draw 3rd pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 3	  
	// print("fixation and target with photodiode");
	dsendf("rw %d,%d;\n",fixation_target_pd,fixation_target_pd);   								// draw 4th pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 4	 
	// print("fixation and target");
	dsendf("rw %d,%d;\n",fixation_target,fixation_target);  												// draw pg 5                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
    nexttick;
	
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5	  
	// print("target_pd");
	dsendf("rw %d,%d;\n",target_pd,target_pd);  														// draw pg 6                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);         	// draw target
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	  
	// print("target_pd");
	dsendf("rw %d,%d;\n",target,target);  														// draw pg 6                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(size, angle, eccentricity, color, fill, deg2pix_X, deg2pix_Y);         	// draw target
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	nexttick;
	}
	
	
	
	