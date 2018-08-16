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

#include C:/TEMPO/ProcLib/CMD_PGS.pro						// sets all pgs of video memory up for the impending trial
#include C:/TEMPO/ProcLib/STAIR.pro							// staircases the SSD based on the last stop trial outcome
#include C:/TEMPO/ProcLib/UPD8_INH.pro

declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Sig_color;									// next signal color (could be either stop or ignore)
declare hide int Trl_type;									// stop, go, or ignore
declare hide int Curr_SSD;									// SSD on next stop or ignore trial
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Decide_SSD;
 
declare hide int constant Go_trl 		= 0;				// label these so they are easier to read below
declare hide int constant Stop_trl 		= 1;				// label these so they are easier to read below
declare hide int constant Ignore_trl 	= 2;				// label these so they are easier to read below

declare SETC_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter);

process SETC_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter)
	{

	declare hide float decide_trl_type; 							
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff;
	declare hide int fixation_color 			= 255;			// see SET_CLRS.pro
	declare hide int stop_sig_color 			= 254;			// see SET_CLRS.pro
	declare hide int ignore_sig_color 			= 253;			// see SET_CLRS.pro
	declare hide int constant nogo_correct		= 4;			// code for successfully canceled trial (see CMDTRIAL.pro)
	declare hide int constant go_correct		= 7;			// code for correct saccade on a go trial (see CMDTRIAL.pro)
	declare hide int constant nogo_wrong	    = 8;            // code for wrong saccade on a go trial (see CMDTRIAL.pro)
	declare hide int ii;
	
	// -----------------------------------------------------------------------------------------------
	// Implement Staircase
	
	//if (Staircase == 1 && Comp_Trl_number > 0)
	//{
		
		spawnwait STAIR(LastStopOutcome, n_SSDs);
	//} else
	//{
	//	Curr_SSD = SSD_List[random(n_SSDs)];
	//}

	// -----------------------------------------------------------------------------------------------
	// Update block; trls per block set in DEFAULT.pro
	if (Correct_trls == Trls_per_block)								// if we have completed the number of correct trials needed per block
		{
		Block_number = Block_number + 1;						// incriment Block_number for strobing in INFOS.pro
		Correct_trls = 0;										// reset the block counter
		}													// 	COULD WEIGHT THIS IF NEED BE (see logic below)
	
	// 1) Pick new target
	if (!DR1_flag || trl_outcome ==nogo_correct || trl_outcome == go_correct)
		{
		curr_target = random(superSetSize);
		}
		
	
	// -----------------------------------------------------------------------------------------------
	// 2) Pick a trial type
															// Pick a number and then assess user defined weights to see what type of trial will be presented.
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
	else													// Else we must be on the right of the number line.
		{													// NOTE: based on user input, ignore trials may not... 
		Trl_type  = Ignore_Trl;								// ...exist and the number line may not have anything... 
		Sig_color = ignore_sig_color;						// ...to the right of stop_weights.  (Same holds for...
		}													// ...stop trials above.
		
	if (Classic)											// We are emulating the old stop signal task
		{
		Sig_color = Fixation_Color;							// the stop signal is just the fixation point coming back on.
		}
	
	// -----------------------------------------------------------------------------------------------
	// 3) Set up all vdosync pages for the upcoming trial using globals defined by user and setc_trl
	spawnwait CMD_PGS(curr_target,							// set above
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
		
	}
	
	
	