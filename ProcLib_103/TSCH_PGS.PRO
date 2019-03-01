//--------------------------------------------------------------------------------------------------
// process TSCH_PGS(int curr_target, 
				// float fixation_size, 
				// int fixation_color, 
				// int sig_color, 
				// float scr_width, 
				// float scr_height, 
				// float pd_left, 
				// float pd_bottom, 
				// float pd_size);
// Figure out all stimuli that will be needed on the next search trial and
// place it all into video memory.
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013


declare hide float 	Size;   																	// Global output will be sent as stobes...        										
declare hide int   	Color;								
declare hide float 	Eccentricity; 
declare hide float 	Angle;        																// ...by INFOS.pro at trial end.

declare hide float 	targ_orient; 
declare hide float 	d1_orient; 
declare hide float 	d2_orient; 
declare hide float 	d3_orient; 
declare hide float 	d4_orient; 
declare hide float 	d5_orient; 
declare hide float 	d6_orient; 
declare hide float 	d7_orient; 
declare hide float 	d8_orient; 
declare hide float 	d9_orient; 
declare hide float 	d10_orient; 
declare hide float 	d11_orient; 

declare hide float 	targ_angle;
declare hide float 	d1_angle; 
declare hide float 	d2_angle; 
declare hide float 	d3_angle; 
declare hide float 	d4_angle; 
declare hide float 	d5_angle; 
declare hide float 	d6_angle; 
declare hide float 	d7_angle; 
declare hide float 	d8_angle; 
declare hide float 	d9_angle; 
declare hide float 	d10_angle; 
declare hide float 	d11_angle; 
      																
declare hide float 	targ_ecc;
declare hide float 	d1_ecc; 
declare hide float 	d2_ecc; 
declare hide float 	d3_ecc; 
declare hide float 	d4_ecc; 
declare hide float 	d5_ecc; 
declare hide float 	d6_ecc; 
declare hide float 	d7_ecc; 
declare hide float 	d8_ecc; 
declare hide float 	d9_ecc; 
declare hide float 	d10_ecc; 
declare hide float 	d11_ecc; 


declare TSCH_PGS(int curr_target, 																// set SETC_TRL.pro
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

process TSCH_PGS(int curr_target, 																// set SETC_TRL.pro
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
	declare hide float	pd_angle;										
	declare hide float 	opposite;										
	declare hide float	adjacent;										
	declare hide float	stim_ecc_x;										
	declare hide float	stim_ecc_y;										
	declare hide int   	open        = 0;										
	declare hide int   	fill        = 1;										
	
	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;										
	declare hide int	fixation_pd = 1;										
	declare hide int	fixation    = 2;
	declare hide int	plac_pd   	= 3;										
	declare hide int	plac      	= 4;	
	declare hide int	target_f_pd = 5;										
	declare hide int	target_f  	= 6;
	declare hide int	target      = 7;										
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	size         = llength;   													// Figure out the attributes of the current target 
	color        = 250; //curr_target + 1;																// zero is reserved for black.  see SET_CLRS.pro	
		
	angle			= targ_angle; 			
	eccentricity	= targ_ecc;	
										
	stim_ecc_x		= cos(angle) * eccentricity;
	stim_ecc_y		= sin(angle) * eccentricity * -1;

	oSetAttribute(object_targ, aSIZE, size*deg2pix_X, size*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	
	opposite = ((scr_height/2)-pd_bottom);														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((scr_width/2)-pd_left);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pd_eccentricity = sqrt((opposite * opposite) + (adjacent * adjacent));
	pd_angle = rad2deg(atan (opposite / adjacent));
	pd_angle = pd_angle + 180; 																//change this for different quadrent or write some code for flexibility
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 2	  
	// print("fixation");
	dsendf("rw %d,%d;\n",fixation,fixation);   													// draw second pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 3	 
	// print("placeholders with photodiode");
	

	dsendf("rw %d,%d;\n",plac_pd,plac_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	
	if (SetSize > 0)
		{
		spawnwait DRW_PLAC(targ_angle, targ_ecc, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	if (SetSize > 1)	
		{
		spawnwait DRW_PLAC(d1_angle, d1_ecc, d1color, fill, deg2pix_X, deg2pix_Y);          	
		}
	if (SetSize > 2)
		{
		spawnwait DRW_PLAC(d2_angle, d2_ecc, color, fill, deg2pix_X, deg2pix_Y);          	      
		}
	if (SetSize > 3)	
		{
		spawnwait DRW_PLAC(d3_angle, d3_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 4)
		{
		spawnwait DRW_PLAC(d4_angle, d4_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 5)
		{
		spawnwait DRW_PLAC(d5_angle, d5_ecc, color, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 6)
		{
		spawnwait DRW_PLAC(d6_angle, d6_ecc, color, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 7)
		{
		spawnwait DRW_PLAC(d7_angle, d7_ecc, color, fill, deg2pix_X, deg2pix_Y);          
		}
	if (SetSize > 8)
		{
		spawnwait DRW_PLAC(d8_angle, d8_ecc, color, fill, deg2pix_X, deg2pix_Y);	
		}
	if (SetSize > 9)	
		{      	
		spawnwait DRW_PLAC(d9_angle, d9_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 10)	
		{
		spawnwait DRW_PLAC(d10_angle, d10_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 11)	
		{         
		spawnwait DRW_PLAC(d11_angle, d11_ecc, color, fill, deg2pix_X, deg2pix_Y);         
		}
		
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	nexttick;
		
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 4	 
	// print("placeholders");
	dsendf("rw %d,%d;\n",plac,plac);  												// draw pg 3                                        
	dsendf("cl:\n");

	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

	if (SetSize > 0)
		{
		spawnwait DRW_PLAC(targ_angle, targ_ecc, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)	
		{
		spawnwait DRW_PLAC(d1_angle, d1_ecc, d1color, fill, deg2pix_X, deg2pix_Y);          	
		}
	if (SetSize > 2)
		{
		spawnwait DRW_PLAC(d2_angle, d2_ecc, color, fill, deg2pix_X, deg2pix_Y);          	      
		}
	if (SetSize > 3)	
		{
		spawnwait DRW_PLAC(d3_angle, d3_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 4)
		{
		spawnwait DRW_PLAC(d4_angle, d4_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 5)
		{
		spawnwait DRW_PLAC(d5_angle, d5_ecc, color, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 6)
		{
		spawnwait DRW_PLAC(d6_angle, d6_ecc, color, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 7)
		{
		spawnwait DRW_PLAC(d7_angle, d7_ecc, color, fill, deg2pix_X, deg2pix_Y);          
		}
	if (SetSize > 8)
		{
		spawnwait DRW_PLAC(d8_angle, d8_ecc, color, fill, deg2pix_X, deg2pix_Y);	
		}
	if (SetSize > 9)	
		{      	
		spawnwait DRW_PLAC(d9_angle, d9_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 10)	
		{
		spawnwait DRW_PLAC(d10_angle, d10_ecc, color, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 11)	
		{         
		spawnwait DRW_PLAC(d11_angle, d11_ecc, color, fill, deg2pix_X, deg2pix_Y);         
		}
	
	nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5	 
	// print("target, fixation, and distractors with photodiode");
	dsendf("rw %d,%d;\n",target_f_pd,target_f_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		if (Catch == 0)
			{
			spawnwait DRW_T(targ_angle, targ_ecc, color, targ_orient, fill, deg2pix_X, deg2pix_Y);          	// draw target
			}
		else if (Catch == 1)
			{
			spawnwait DRW_L(targ_angle, targ_ecc, color, d1_orient, fill, deg2pix_X, deg2pix_Y);          	// draw distractor
			}
		}
	
	
	if (SetSize > 1)	
		{
		spawnwait DRW_L(d1_angle, d1_ecc, d1color, d1_orient, fill, deg2pix_X, deg2pix_Y);          	
		}
	if (SetSize > 2)
		{
		spawnwait DRW_L(d2_angle, d2_ecc, color, d2_orient, fill, deg2pix_X, deg2pix_Y);          	      
		}
	if (SetSize > 3)	
		{
		spawnwait DRW_L(d3_angle, d3_ecc, color, d3_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 4)
		{
		spawnwait DRW_L(d4_angle, d4_ecc, color, d4_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 5)
		{
		spawnwait DRW_L(d5_angle, d5_ecc, color, d5_orient, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 6)
		{
		spawnwait DRW_L(d6_angle, d6_ecc, color, d6_orient, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 7)
		{
		spawnwait DRW_L(d7_angle, d7_ecc, color, d7_orient, fill, deg2pix_X, deg2pix_Y);          
		}
	if (SetSize > 8)
		{
		spawnwait DRW_L(d8_angle, d8_ecc, color, d8_orient, fill, deg2pix_X, deg2pix_Y);	
		}
	if (SetSize > 9)	
		{      	
		spawnwait DRW_L(d9_angle, d9_ecc, color, d9_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 10)	
		{
		spawnwait DRW_L(d10_angle, d10_ecc, color, d10_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 11)	
		{         
		spawnwait DRW_L(d11_angle, d11_ecc, color, d11_orient, fill, deg2pix_X, deg2pix_Y);         
		}
	
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	 
	// print("target, fixation, and distractors");
	dsendf("rw %d,%d;\n",target_f,target_f);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		if (Catch == 0)
			{
			spawnwait DRW_T(targ_angle, targ_ecc, color, targ_orient, fill, deg2pix_X, deg2pix_Y);          	// draw target
			}
		else if (Catch == 1)
			{
			spawnwait DRW_L(targ_angle, targ_ecc, color, d1_orient, fill, deg2pix_X, deg2pix_Y);          	// draw distractor
			}
		}
	
	
	if (SetSize > 1)	
		{
		spawnwait DRW_L(d1_angle, d1_ecc, d1color, d1_orient, fill, deg2pix_X, deg2pix_Y);          	
		}
	if (SetSize > 2)
		{
		spawnwait DRW_L(d2_angle, d2_ecc, color, d2_orient, fill, deg2pix_X, deg2pix_Y);          	      
		}
	if (SetSize > 3)	
		{
		spawnwait DRW_L(d3_angle, d3_ecc, color, d3_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 4)
		{
		spawnwait DRW_L(d4_angle, d4_ecc, color, d4_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 5)
		{
		spawnwait DRW_L(d5_angle, d5_ecc, color, d5_orient, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 6)
		{
		spawnwait DRW_L(d6_angle, d6_ecc, color, d6_orient, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 7)
		{
		spawnwait DRW_L(d7_angle, d7_ecc, color, d7_orient, fill, deg2pix_X, deg2pix_Y);          
		}
	if (SetSize > 8)
		{
		spawnwait DRW_L(d8_angle, d8_ecc, color, d8_orient, fill, deg2pix_X, deg2pix_Y);	
		}
	if (SetSize > 9)	
		{      	
		spawnwait DRW_L(d9_angle, d9_ecc, color, d9_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 10)	
		{
		spawnwait DRW_L(d10_angle, d10_ecc, color, d10_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 11)	
		{         
		spawnwait DRW_L(d11_angle, d11_ecc, color, d11_orient, fill, deg2pix_X, deg2pix_Y);         
		}

	
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

    nexttick;
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 7	  
	// print("target and distractors");
	dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		if (Catch == 0)
			{
			spawnwait DRW_T(targ_angle, targ_ecc, color, targ_orient, fill, deg2pix_X, deg2pix_Y);          	// draw target
			}
		else if (Catch == 1)
			{
			spawnwait DRW_L(targ_angle, targ_ecc, color, d1_orient, fill, deg2pix_X, deg2pix_Y);          	// draw distractor
			}
		}
	
	
	if (SetSize > 1)	
		{
		spawnwait DRW_L(d1_angle, d1_ecc, d1color, d1_orient, fill, deg2pix_X, deg2pix_Y);          	
		}
	if (SetSize > 2)
		{
		spawnwait DRW_L(d2_angle, d2_ecc, color, d2_orient, fill, deg2pix_X, deg2pix_Y);          	      
		}
	if (SetSize > 3)	
		{
		spawnwait DRW_L(d3_angle, d3_ecc, color, d3_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 4)
		{
		spawnwait DRW_L(d4_angle, d4_ecc, color, d4_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 5)
		{
		spawnwait DRW_L(d5_angle, d5_ecc, color, d5_orient, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 6)
		{
		spawnwait DRW_L(d6_angle, d6_ecc, color, d6_orient, fill, deg2pix_X, deg2pix_Y); 
		}
	if (SetSize > 7)
		{
		spawnwait DRW_L(d7_angle, d7_ecc, color, d7_orient, fill, deg2pix_X, deg2pix_Y);          
		}
	if (SetSize > 8)
		{
		spawnwait DRW_L(d8_angle, d8_ecc, color, d8_orient, fill, deg2pix_X, deg2pix_Y);	
		}
	if (SetSize > 9)	
		{      	
		spawnwait DRW_L(d9_angle, d9_ecc, color, d9_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 10)	
		{
		spawnwait DRW_L(d10_angle, d10_ecc, color, d10_orient, fill, deg2pix_X, deg2pix_Y);
		}
	if (SetSize > 11)	
		{         
		spawnwait DRW_L(d11_angle, d11_ecc, color, d11_orient, fill, deg2pix_X, deg2pix_Y);         
		}

	
	if (soa_mode==1)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, open, deg2pix_X, deg2pix_Y);
		}
	else
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);		
		}
	nexttick; 
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	
	
	}