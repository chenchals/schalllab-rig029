//-----------------------------------------------------------------------------------
// process SETS_TRL(int n_targ_pos,
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
// Calculates all variables needed to run a search trial based on user defined
// space.  See DEFAULT.pro and ALL_VARS.pro for an explanation of the global input variables
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013

#include C:/TEMPO/ProcLib/TSCH_PGS.pro						// sets all pgs of video memory up for the impending trial
#include C:/TEMPO/ProcLib/LSCH_PGS.pro						// sets all pgs of video memory up for the impending trial 

declare hide int StimTm;									// Should we stim on this trial?
declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Sig_color;									// next signal color (could be either stop or ignore)
declare hide int Trl_type;									// stop, go, or ignore
declare hide int Curr_SSD;									// SSD on next stop or ignore trial
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int EVT_DECIDE_SSD;
 
declare hide int DistFix;

declare SETS_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter);

process SETS_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
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
	declare hide float CatchNum;	
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff, plac_diff, plac_jitter;
	declare hide int fixation_color 			= 255;			// see SET_CLRS.pro
	declare hide int constant nogo_correct		= 4;			// code for successfully canceled trial (see CMDTRIAL.pro)
	declare hide int constant go_correct		= 7;			// code for correct saccade on a go trial (see CMDTRIAL.pro)
	
	declare hide int ii;
		
	// -----------------------------------------------------------------------------------------------
	// Update block; trls per block set in DEFAULT.pro
	if (Comp_Trl_number == Trls_per_block)								// if we have completed the number of correct trials needed per block
		{
		Block_number = Block_number + 1;						// incriment Block_number for strobing in INFOS.pro
		Comp_Trl_number = 0;										// reset the block counter
		}	

	// -----------------------------------------------------------------------------------------------
	// 1) Set up catch trial based on Perc_catch parameter in DEFAULT.pro
	

	CatchNum = random(100);
	if (CatchNum > Perc_catch)
		{
		Catch = 0;
		CatchCode = 500;
		}
	else	
		{
		Catch = 1;
		CatchCode = 501;
		} 
	
	// -----------------------------------------------------------------------------------------------
	// 2) Set up all vdosync pages for the upcoming trial using globals defined by user and sets_trl.pro
	
	
	if(SingMode == 1)
		{ //selecting different fixed distractor color for each block
		if(Block_number == 1 || Block_number == 11 || Block_number == 21)
			{ 
			DistFix = 1; //fixed distractor
			SingCol = 0;
			}
		else if(Block_number == 3 || Block_number == 13 || Block_number == 23)
			{ 
			DistFix = 1; //fixed distractor
			SingCol = 1;
			}
		else if(Block_number == 5 || Block_number == 15 || Block_number == 25)
			{ 
			DistFix = 1; //fixed distractor
			SingCol = 2;
			}
		else if(Block_number == 7 || Block_number == 17 || Block_number == 27)
			{ 
			DistFix = 1; //fixed distractor
			SingCol = 3;
			}
		else if(Block_number == 9 || Block_number == 19 || Block_number == 29)
			{ 
			DistFix = 1; //fixed distractor
			SingCol = 4;
			}
		else //after 2900 trials, all blocks become random
			{
			DistFix = 2; //random distractor	
			SingCol = random(5); //pick a distractor color at random
			}
		}
	
	spawnwait SET_CLRS(n_targ_pos); //selects distractor/target colors for this trial
	
	spawnwait RAND_ORT;	// sets orientations of random stimuli
	
	
	/////////////// Logic allowing us to choose locations differently on the basis of whether we are running probability search task //////////////
	if(ProbCue == 0) //probability cueing on
		{
		spawnwait LOC_RAND;	// sets locations of stimuli
		}
	else if(ProbCue == 1) //probability cueing on
		{
		spawnwait LOC_ASYM;	// sets locations of stimuli
		}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	spawnwait SEL_LOCS; // compiles final eccentricity, location, and orientation information for use by TSCH_PGS/LSCH_PGS below
	
	if(TargetType == 1)
		{ 
		spawnwait LSCH_PGS(curr_target,							// set above
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
		}			
	else if(TargetType == 2)
		{
		spawnwait TSCH_PGS(curr_target,							// set above
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
		} 		

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
	
	holdtime_diff 	= max_holdtime - min_holdtime;			// Min and Max holdtime defined in DEFAULT.pro
	per_jitter 		= random(1001) / 1000.0;				// random number 0-100 (percentages)	
	jitter 			= holdtime_diff * per_jitter;			// multiply range of holdtime differences by percentage above
	
	if (FixJitter == 0) 
		{
		Curr_holdtime 	= round(min_holdtime + jitter);			// gives randomly jittered holdtime between min and max holdtime 
		}
	else if(FixJitter == 1)
		{
		Curr_holdtime 	= 500;
		}
	// -----------------------------------------------------------------------------------------------
	// 5) Select current fixation offset SOA
	if (soa_mode==1)
		{
			per_jitter = random(4);  //returns random number between 0 and n-1
			search_fix_time = SOA_list[per_jitter];
		}
	else
		{
		search_fix_time = 0;
		}
	// -----------------------------------------------------------------------------------------------
	// 6) Set placeholder duration
	
	plac_diff 		= max_plactime - min_plactime;			// Min and Max holdtime defined in DEFAULT.pro
	plac_jitter 	= plac_diff * per_jitter;				// multiply range of holdtime differences by percentage above
	
	plac_duration 	= round(min_plactime + plac_jitter);	// gives randomly jittered holdtime between min and max holdtime 

	
	// -----------------------------------------------------------------------------------------------
	// 7) Choose whether to stim
	//StimTm = Random(2); //allows us to randomize the time stim is delivered; see task stages in SCHTRIAL.pro
	StimTm = 1; //Single stim time
	//StimTm = 0; //stim off
	//StimTm = 5; //For prolonged stim protocol
	// -----------------------------------------------------------------------------------------------
	// 8) Choose Eccentricity
	
	SelEcc = Random(3); //choose from four eccentricities randomly; see line 130 LOC_RAND.pro
	
	}
	
	
	