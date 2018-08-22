//----------------------------------------------------------------------------------------------------
// The most awesome operating system ever.  Built by the richest and most generous man in the world.
// 							~OR~
// Process for locating fixation and target window locations.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011;    Adapted for search by joshu.d.cosman@vanderbilt.edu July, 2013

declare hide int run_search_sess = 7;
declare hide float targ_angle;
declare hide float targ_ecc;
declare hide float Fix_win_left;	
declare hide float Fix_win_right;		
declare hide float Fix_win_down;	
declare hide float Fix_win_up;	
declare hide float Targ_win_left;		
declare hide float Targ_win_right;	
declare hide float Targ_win_down;
declare hide float Targ_win_up;
             
declare WINDOWS(int curr_target,						// see SETC_TRL
				float fix_win_size,                     // see DEFAULT.pro and ALL_VARS.pro
				float targ_win_size,                    // see DEFAULT.pro and ALL_VARS.pro
				int object_fixwin,                      // animated graph object
				int object_targwin,                     // animated graph object
				float deg2pix_X,                        // see SET_COOR.pro
				float deg2pix_Y);                       // see SET_COOR.pro

process WINDOWS(int curr_target,						// see SETC_TRL
				float fix_win_size,                     // see DEFAULT.pro and ALL_VARS.pro
				float targ_win_size,                    // see DEFAULT.pro and ALL_VARS.pro
				int object_fixwin,                      // animated graph object
				int object_targwin,                     // animated graph object
				float deg2pix_X,                        // see SET_COOR.pro
				float deg2pix_Y)				        // see SET_COOR.pro
	{
	declare hide float angle, 
					eccentricity, 
					stim_ecc_x, 
					stim_ecc_y, 
					half_size_tw,
					old_fix_win_size,
					old_targ_win_size;
	
	// calculate the params of the fixation window
	Fix_win_left 	= fix_win_size/-2;					// if you wanted to use a fixation point which
	Fix_win_right 	= fix_win_size/2;					// wasn't at 0,0 you could do so and adopt the
	Fix_win_down 	= fix_win_size/2;					// same logic as below.
	Fix_win_up		= fix_win_size/-2;
	
	// find the center of the target in x and y space based on the angle and eccentricity

	if (state == run_search_sess) 	
		{
		angle			= targ_angle; 			
		eccentricity	= targ_ecc;	
		}
	else
		{
		angle			= Angle_list[curr_target]; 			// THESE USER DEFINED GLOBALS ARE ARRAYS SO 
		eccentricity	= Eccentricity_list[curr_target];	// THEY CANNOT BE PASSED INTO PROCESSES	
		}
		
	stim_ecc_x		= cos(angle) * eccentricity;
	stim_ecc_y		= sin(angle) * eccentricity * -1;
	
	oMove(object_targwin, stim_ecc_x*deg2pix_X , stim_ecc_y*deg2pix_Y); //move the animated target window to location
	oMove(object_targ, stim_ecc_x*deg2pix_X , stim_ecc_y*deg2pix_Y); //move the animated target to location
	
	// calculate the params of the target window
	half_size_tw = targ_win_size/2;
	Targ_win_left	= stim_ecc_x - half_size_tw;
	Targ_win_down	= stim_ecc_y + half_size_tw;
	Targ_win_right	= stim_ecc_x + half_size_tw;
	Targ_win_up		= stim_ecc_y - half_size_tw;
	
	// if the user changes the size of the fix window update the graph
	if (Trl_number == 1			||
		fix_win_size != old_fix_win_size)
		{
		oSetAttribute(object_fixwin, aSIZE, fix_win_size*Deg2pix_X, fix_win_size*Deg2pix_Y);
		oSetAttribute(object_fixwin, aVISIBLE);
		old_fix_win_size = fix_win_size;
		}
		
	// if the user changes the size of the targ window update the graph
	if (Trl_number == 1			||
		targ_win_size != old_targ_win_size)
		{
		oSetAttribute(object_targwin, aSIZE, targ_win_size*Deg2pix_X, targ_win_size*Deg2pix_Y);
		oSetAttribute(object_targwin, aVISIBLE);
		old_targ_win_size = targ_win_size;
		}
		
		
	}