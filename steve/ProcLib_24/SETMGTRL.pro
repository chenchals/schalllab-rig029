//-----------------------------------------------------------------------------------
// process SETC_TRL(int n_targ_pos,
				// float go_weight,
				// float stop_weight,
				// float ignore_weight,
				// int stop_sig_color,
				// int ignore_sig_color,
				// int staircase,
				// int n_SSDs,
				// int min_holdtime,
				// int max_holdtime,
				// int expo_jitter);
// Calculates all variables needed to run a countermanding trial based on user defined
// space.  See DEFAULT.pro and ALL_VARS.pro for an explanation of the global input variables
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

#include C:/TEMPO/ProcLib/MG_PGS.pro						// sets all pgs of video memory up for the impending trial
//#include C:/TEMPO/ProcLib/STAIR.pro							// staircases the SSD based on the last stop trial outcome
declare hide int StimTm;									// Should we stim on this trial?

declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Sig_color;									// next signal color (could be either stop or ignore)
declare hide int Trl_type;									// stop, go, or ignore
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Curr_soa;
declare hide int per_jitter;
declare hide int soa_jitter;

declare hide int nogosoa;
declare hide int per_soa_jitter;

declare SETMGTRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int n_SOAs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int expo_jitter_soa);

process SETMGTRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int n_SOAs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int expo_jitter_soa)
	{
	
	declare hide float decide_trl_type; 							
	declare hide float jitter, decide_jitter, holdtime_diff;
	declare hide float decide_soa_jitter, per_soa_jitter, soa_diff; 
	declare hide int fixation_color 			= 255;			// see SET_CLRS.pro
	declare hide int stop_sig_color 			= 254;			// see SET_CLRS.pro
	declare hide int ignore_sig_color 			= 253;			// see SET_CLRS.pro
	declare hide int constant nogo_correct		= 4;			// code for successfully canceled trial (see CMDTRIAL.pro)
	declare hide int constant go_correct		= 7;			// code for correct saccade on a go trial (see CMDTRIAL.pro)

	declare hide int ii;
	declare hide int constant Go_trl 		= 0;				// label these so they are easier to read below
	declare hide int constant Stop_trl 		= 1;				// label these so they are easier to read below
	declare hide int constant Ignore_trl 	= 2;				// label these so they are easier to read below
	// -----------------------------------------------------------------------------------------------
	// 2) Pick a trial type
															// Pick a number and then assess user defined weights to see what type of trial will be presented.
	decide_trl_type = (1.0 + random(9999)) / 100.0;			// random number from 1-100
															// Think of the if statement below as a number line with user defined divisions (weights).
	if (decide_trl_type <= go_weight)						// If we are on the left of the number line...
		{
		nogosoa = 0;
		Trl_type = Go_Trl;									// ...its a go trial.
		}
	else if (decide_trl_type > go_weight 
			&& decide_trl_type <= go_weight + stop_weight)	// If we are in the middle of the number line...
		{
		nogosoa = 1;
		Trl_type  = Stop_Trl;								// ...it is a stop trial, and...
		Sig_color = stop_sig_color;							// ...the signal color will reflect this fact.
		}
	else													// Else we must be on the right of the number line.
		{													// NOTE: based on user input, ignore trials may not... 
		Trl_type  = Ignore_Trl;								// ...exist and the number line may not have anything... 
		Sig_color = ignore_sig_color;						// ...to the right of stop_weights.  (Same holds for...
		}													// ...stop trials above.
		
//	if (Classic)											// We are emulating the old stop signal task
//		{
//		Sig_color = Fixation_Color;							// the stop signal is just the fixation point coming back on.
//		}
	
	Curr_target = random(N_targ_pos);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
	
	// -----------------------------------------------------------------------------------------------
	// 3) Set up all vdosync pages for the upcoming trial using globals defined by user and setc_trl
	spawnwait MG_PGS(curr_target,							// set above
				fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
				fixation_color, 							// see SET_CLRS.pro
				sig_color, 									// see DEFAULT.pro and ALL_VARS.pro
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
	// 4) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(curr_target,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
				
	// -----------------------------------------------------------------------------------------------
	// 6) Select current holdtime
	
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
	// 5) Select current soa, as  (same logic as above)

		
		soa_diff = max_soa-min_soa;
		if (expo_jitter)
			{
			decide_soa_jitter 	= (random(1000) + 1)/ 1000.0;				// random number 0-100 (percentages)
			per_soa_jitter = exp(-1.0*(decide_soa_jitter/0.25));
			}
		else
			{
			per_soa_jitter = (random(1001))/1000.0;
			}
		soa_jitter 			= soa_diff * per_soa_jitter;
		Curr_soa 			= round(min_soa + soa_jitter);	
		
		//soa_jitter = random(4);
		//Curr_soa = SOA_list[soa_jitter];
		
		// stimulation variable
		if (TaskStim == 1)
			{
			StimTm = Random(4);
			}
		
	}
	