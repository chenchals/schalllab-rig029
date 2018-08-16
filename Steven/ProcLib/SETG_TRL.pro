//-----------------------------------------------------------------------------------
// process SETM_TRL(int n_targ_pos,
				// int min_holdtime,
				// int max_holdtime,
				// int expo_jitter,
				// int min_soa,
				// int max_soa,
				// int expo_jitter_soa);
// Calculates all variables needed to run a mem guided sacc trial based on user defined
// space.  See DEFAULT.pro and M_VARS.pro for an explanation of the global input variables
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011

#include C:/TEMPO/ProcLib/GNG_PGS.pro					// sets all pgs of video memory up for the impending trial
#include C:/TEMPO/ProcLib/STAIR.pro							// staircases the SSD based on the last stop trial outcome

declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Curr_soa;									// next trial time between target onset and fixation offset
declare hide int soa;

declare SETG_TRL(int n_targ_pos,							// see DEFAULT.pro and M_VARS.pro for explanations of these globals
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int min_soa,
				int max_soa,
				int expo_jitter_soa);

process SETG_TRL(int n_targ_pos,							// see DEFAULT.pro and M_VARS.pro for explanations of these globals
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int min_soa,
				int max_soa,
				int expo_jitter_soa)
	{
	declare hide float decide_trl_type;
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff, soa_diff;
	declare hide int fixation_color 	= 255;				// see SET_CLRS.pro
	declare hide int stop_sig_color 	= 254;				// see SET_CLRS.pro
	declare hide int ignore_sig_color 	= 253;				// see SET_CLRS.pro
	declare hide int maskcolor			= 252;
	
	declare hide int constant Go_trl 		= 0;				// label these so they are easier to read below
	declare hide int constant Stop_trl 		= 1;				// label these so they are easier to read below
	declare hide int constant Ignore_trl 	= 2;				// label these so they are easier to read below
	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target
	
	Curr_target = random(n_targ_pos);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
	
	decide_trl_type = (1.0 + random(9999)) / 100.0;			// random number from 1-100
															// Think of the if statement below as a number line with user defined divisions (weights).
	if (decide_trl_type <= go_weight)						// If we are on the left of the number line...
		{
		Trl_type = Go_Trl;									// ...its a go trial.
		}
	else if (decide_trl_type > go_weight 
			&& decide_trl_type <= go_weight + stop_weight)	// If we are in the middle of the number line...
		{
		Trl_type  = Stop_Trl;								// ...it is a stop trial, and...
		Sig_color = stop_sig_color;							// ...the signal color will reflect this fact.
		}
	else 													// Else we must be on the right of the number line.
		{													// NOTE: based on user input, ignore trials may not... 
		Trl_type  = Ignore_Trl;								// ...exist and the number line may not have anything... 
		Sig_color = ignore_sig_color;						// ...to the right of stop_weights.  (Same holds for...
		}													// ...stop trials above.
		
//		
//	if (Classic)											// We are emulating the old stop signal task
//		{
//		Sig_color = Fixation_Color;							// the stop signal is just the fixation point coming back on.
//		}
	// -----------------------------------------------------------------------------------------------
	// 2) Set up all vdosync pages for the upcoming trial using globals defined by user and setc_trl
	spawnwait GNG_PGS(curr_target,							// set above
				fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
				fixation_color, 							// see SET_CLRS.pro
				sig_color,
				maskcolor,
				scr_width, 									// see RIGSETUP.pro
				scr_height, 								// see RIGSETUP.pro
				pd_left, 									// see RIGSETUP.pro
				pd_bottom, 									// see RIGSETUP.pro
				pd_size,									// see RIGSETUP.pro
				deg2pix_X,									// see SET_COOR.pro
				deg2pix_Y,									// see SET_COOR.pro
				unit2pix_X,									// see SET_COOR.pro
				unit2pix_Y,									// see SET_COOR.pro
				object_targ);								// see GRAPHS.pro
		
		
	

	// -----------------------------------------------------------------------------------------------
	// 3) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(curr_target,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
				

				
	
	// -----------------------------------------------------------------------------------------------
	// 4) Select current holdtime
	
	holdtime_diff = max_holdtime - min_holdtime;
	if (expo_jitter)
		{		
		decide_jitter 	= (random(1001))/1000.0;				
		per_jitter 		= exp(-1.0*(decide_jitter/0.25));	
		}
	else
		{
		per_jitter 	= random(1001) / 1000.0;				// random number 0-100 (percentages)
		}
	jitter 			= holdtime_diff * per_jitter;
	Curr_holdtime 	= round(min_holdtime + jitter);
	
	
	
	
	// -----------------------------------------------------------------------------------------------
	// 5) Select current soa (same logic as above)
	
	soa_diff = max_soa - min_soa;
	if (expo_jitter_soa)
		{		
		decide_jitter 	= (random(1001))/1000.0;
	//	per_jitter 		= exp(-1.0*(decide_jitter/0.25));	
		Curr_soa = floor((-333.33 * ln(decide_jitter)+min_soa) / 100) * 100;
		while (Curr_soa > max_soa + 1)
		{
			decide_jitter 	= (random(1001))/1000.0;
			Curr_soa = floor((-333.33 * ln(decide_jitter)+min_soa) / 100) * 100;
		}
		}
	else
		{
		per_jitter 	= random(1099) / 1000.0;				// random number 0-100 (percentages)
		jitter 			= soa_diff * per_jitter;
		Curr_soa 		= floor((min_soa + jitter) / 100) * 100;
		}
	
		
	}
	
	
	