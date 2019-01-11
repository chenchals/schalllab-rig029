//Modified by Namsoo	5/23/2012

#include C:/TEMPO/ProcLib/DEL_PGS.pro						// sets all pgs of video memory up for the impending trial

declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Curr_soa;									// next trial time between target onset and fixation offset
declare hide int soa;
//declare hide int SOA_list[11];

declare SETD_TRL(int n_targ_pos,							// see DEFAULT.pro and M_VARS.pro for explanations of these globals
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int min_soa,
				int max_soa,
				int expo_jitter_soa);

process SETD_TRL(int n_targ_pos,							// see DEFAULT.pro and M_VARS.pro for explanations of these globals
				int min_holdtime,
				int max_holdtime,
				int expo_jitter,
				int min_soa,
				int max_soa,
				int expo_jitter_soa)
	{
	
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff, soa_diff;
	declare hide int fixation_color 	= 255;				// see SET_CLRS.pro
	
	
	// -----------------------------------------------------------------------------------------------
	// 1) Pick a target

	Curr_target = random(n_targ_pos);						// 	COULD WEIGHT THIS IF NEED BE (see logic below)
	


	
	// -----------------------------------------------------------------------------------------------
	// 2) Set up all vdosync pages for the upcoming trial using globals defined by user and setc_trl
	spawnwait DEL_PGS(curr_target,							// set above
				fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
				fixation_color, 							// see SET_CLRS.pro
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
		
	//soa_diff = max_soa - min_soa;
	
/* 	if (expo_jitter_soa)
		{		
		//	decide_jitter 	= (random(1001))/1000.0;
		//	per_jitter 		= exp(-1.0*(decide_jitter/0.25));	
		//	Curr_soa = round(-333.33 * ln(decide_jitter))+600;
		//	while (Curr_soa > 1101)
		//	{
		//		decide_jitter 	= (random(1001))/1000.0;
		//		Curr_soa = round(-333.33 * ln(decide_jitter))+600;
		//	}
		
		per_jitter = poisson(0.6);
		while (per_jitter > 5)
		{
			per_jitter = poisson(0.6);
		}
		Curr_soa = 300;//SOA_list[per_jitter];
		
		}
	else */
		{
		//per_jitter 	= random(1001) / 1000.0;				// random number 0-100 (percentages)
		//jitter 			= soa_diff * per_jitter;
		//Curr_soa 		= round(min_soa + jitter);
		
		
		//per_jitter = random(11);
		per_jitter = random(5);  //returns random number between 0 and n-1
		
		//Curr_soa = 300; 
		
		Curr_soa = SOA_list[per_jitter];
		
		
		}
	
		
	}
	
	