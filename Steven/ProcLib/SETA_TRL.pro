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

//#include C:/TEMPO/ProcLib/TSCH_PGS.pro						// sets all pgs of video memory up for the impending trial
//#include C:/TEMPO/ProcLib/LSCH_PGS.pro						// sets all pgs of video memory up for the impending trial 
#include C:/TEMPO/ProcLib/ANTI_PGS.pro
#include C:/TEMPO/ProcLib/A_DIFFS.pro
#include C:/TEMPO/ProcLib/SET_LOCS.pro

declare hide int StimTm;									// Should we stim on this trial?
declare hide int Curr_target;								// OUTPUT: next trial target
declare hide int Sig_color;									// next signal color (could be either stop or ignore)
declare hide int Trl_type;									// stop, go, or ignore
declare hide int Curr_SSD;									// SSD on next stop or ignore trial
declare hide int Curr_holdtime;								// next trial time between fixation and target onset
declare hide int Decide_SSD;

declare hide int TypeCode;
declare hide int DistFix;

declare hide int saccEnd;
declare SETA_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				float go_weight,
				float stop_weight,
				float ignore_weight,
				int staircase,
				int n_SSDs,
				int min_holdtime,
				int max_holdtime,
				int expo_jitter);

process SETA_TRL(int n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
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
	declare hide float per_jitter, jitter, decide_jitter, holdtime_diff, plac_diff, plac_jitter, cuetime_diff;
	declare hide int fixation_color 			= 255;			// see SET_CLRS.pro
	declare hide int cue_color 					= 249;
	declare hide int constant nogo_correct		= 4;			// code for successfully canceled trial (see CMDTRIAL.pro)
	declare hide int constant go_correct		= 7;			// code for correct saccade on a go trial (see CMDTRIAL.pro)
	declare hide float equalTol 				= .01; 			// allow for floating point errors when asking whether H > V or V > H
	declare hide int randVal;
	declare hide float cumProbs[ntDifficulties];
	declare hide int it;
	declare hide int lastVal;
	declare hide int sumProbs;
	declare hide int cumTarg[8];
	declare hide int randVal;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int sumLoc;
	//declare hide int ii;
	declare hide int break;
		
	// -----------------------------------------------------------------------------------------------
	// Update block; trls per block set in DEFAULT.pro
	if (Comp_Trl_number == Trls_per_block)								// if we have completed the number of correct trials needed per block
		{
		Block_number = Block_number + 1;						// incriment Block_number for strobing in INFOS.pro
		Comp_Trl_number = 0;										// reset the block counter
		}	

	// -----------------------------------------------------------------------------------------------
	
	// -----------------------------------------------------------------------------------------------
	// 2) Set up all vdosync pages for the upcoming trial using globals defined by user and sets_trl.pro
	
	
	//spawnwait RAND_ORT;	// sets orientations of random stimuli
	
	//spawnwait A_LOCS; // updates angles and eccentricities - assumes we want equal spacing
	
	
	// Refresh angles/eccentricities
	spawnwait SET_LOCS();
	nexttick;
	
	it = 0;
	sumLoc = 0;
	while (it < SetSize) 
	{
		//printf("congProb[%d] = %d\n",it,congProb[it]);
		sumLoc = sumLoc+targProb[it];
		it = it+1;
	}
	nexttick;
	
	it = 0;
	lastVal = 0;
	thisVal = 0;
	while (it < SetSize)
	{
		thisVal = targProb[it]*100;
		cumTarg[it] = (thisVal/sumLoc)+lastVal;
		lastVal = cumTarg[it];
		it = it+1;
	}
	randVal = random(100);
	targInd = 0;
	break = 0;
	while (randVal >= cumTarg[targInd] && break == 0)
	{
		targInd = targInd+1;
		if (targInd == SetSize)
		{
			targInd = SetSize-1;
			break = 1;
		}
	}
		
	//targInd = random(SetSize);
	targ_angle = Angle_list[targInd];
	targ_ecc = Eccentricity_list[targInd];
	
	// Send target location code    eventCode
	Event_fifo[Set_event] = 800 + targInd;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	spawnwait A_DIFFS; // selects difficulty levels for this trial
	//printf("\n\nAfter A_DIFFS, singDiff = %d\n\n",singDifficulty);
	// Now that locations have been set, figure out Set up a pro or anti trial and saccade endpoint
	
	// Now, let's test whether this difficulty is a pro or anti trial
	saccEnd = targInd;
	if (((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) > equalTol) || (basicPopOut==1))
		{
		Trl_type = 1;
		TypeCode = 600;
		Catch = 0;
		//CatchCode = 500;
		}
	else if ((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) > equalTol)
		{
		Trl_type = 2;
		TypeCode = 601;
		Catch = 0;
		//CatchCode = 500;
		saccEnd = (targInd+(SetSize/2)) % SetSize;
		}
	// This if statement should work because it's in an else... a negative value < -equaltol
	// should have been caught by the first if
	else if (((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) < equalTol) || ((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) < equalTol))
		{
		Trl_type = 3;
		TypeCode = 602;
		Catch = 1;
		//CatchCode = 501;
		}
	
	// 1) Set up catch trial based on Perc_catch parameter in DEFAULT.pro
		
	// We'll want to update this if we decide that a "catch" should be defined by a square difficulty...
	// I'll put the appropriate line down in the "if" statement below, but keep it commented for now
	if (basicPopOut == 1)
	{
		
		CatchNum = random(100);
		//printf("CatchNum = %d, Perc_catch = %d\n",CatchNum,Perc_catch);
		if (CatchNum >= Perc_catch)
			{
			Catch = 0;
			CatchCode = 500;
			Trl_type = 1;
			TypeCode = 600;
			printf("CatchNum > Perc_Catch, Catch=%d\n",Catch);
			}
		else	
			{
			Catch = 1;
			CatchCode = 501;
			Trl_type = 3;
			TypeCode = 602;
			printf("CatchNum < Perc_Catch, Catch=%d\n",Catch);
			} 
	}
	//printf("\n\nCatch = %d\n\n");	
	
	cueType = 1;
	if (fixCue && Max_cueTime > 0)
	{
		if (Trl_type == 1) // if pro
		{
			randVal = random(1000);
			//printf("neutral randVal = %d\n",randval);
			if (randVal >= neutCueThresh) // if it shouldn't stay neutral...
			{
				randVal = random(100);
				//printf("pro/anti randVal = %d\n",randVal);
				if (randVal > cueCongThresh) // if invalid
				{
					cueType = 2; // anti cue
				} else
				{
					cueType = 0; // pro cue
				}
			}
		} else if (Trl_type == 2) // if anti
		{ 
			randVal = random(1000);
			//printf("neutral randVal = %d\n",randVal);
			if (randVal >= neutCueThresh) // if it shouldn't stay neutral...
			{
				randVal = random(100);
				//printf("pro/anti randVal = %d\n",randVal);
				if (randVal > cueCongThresh) // if invalid
				{
					cueType = 0; // pro cue
				} else
				{
					cueType = 2; // anti cue
				}
			}
		}
	}
	//printf("Cue Color = %d\n",cueColors[cueType]);
	
	Event_fifo[Set_event] = 720 + cueType;										// queue strobe
	Set_event = (Set_event + 1) % Event_fifo_N;
				
	nexttick;
	
	// Set up colors
	spawnwait SET_CLRS(n_targ_pos); //selects distractor/target colors for this trial
	
		
	
	
	
		/*catchPro = random(2);
		if (catchPro)
		{
			Trl_type = 1;
			TypeCode = 600;
			
		}
		else if (!catchPro)
		{
			Trl_type = 2;
			TypeCode = 601;
			saccEnd = (targInd+(SetSize/2))% SetSize;
		}
		}
	*/
	//printf("SETA_TRL: SingDiffulty = %d\n",singDifficulty);
	//printf("Catch = %d\n",Catch);
	
	
	// Send catch code    eventCode
	//Event_fifo[Set_event] = CatchCode;		// Set a strobe to identify this file as a Search session and...	
	//Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	spawnwait ANTI_PGS(curr_target,							// set above
			singDifficulty,								// singleton difficulty - H and V set in DEFAULT.pro
			fixation_size, 								// see DEFAULT.pro and ALL_VARS.pro
			fixation_color, 							// see SET_CLRS.pro
			cue_color,
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
	// 3) Set Up Target and Fixation Windows and plot them on animated graphs
	spawnwait WINDOWS(saccEnd,							// see above
				fix_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				targ_win_size,								// see DEFAULT.pro and ALL_VARS.pro
				object_fixwin,								// animated graph object
				object_targwin,								// animated graph object
				deg2pix_X,									// see SET_COOR.pro
	            deg2pix_Y);                                 // see SET_COOR.pro
		
	// -----------------------------------------------------------------------------------------------
	// 4) Select current holdtime
	
	holdtime_diff 	= max_holdtime - min_holdtime;			// Min and Max holdtime defined in DEFAULT.pro
	if (expo_jitter)
	{
		decide_jitter = (random(1001))/1000.0;
		per_jitter = exp(-1.0*(decide_jitter/.025));
	}
	else
	{
		per_jitter 		= random(1001) / 1000.0;				// random number 0-100 (percentages)	
	}
	jitter 			= holdtime_diff * per_jitter;			// multiply range of holdtime differences by percentage above
	
	if (FixJitter == 0) 
		{
		Curr_holdtime 	= round(min_holdtime + jitter);			// gives randomly jittered holdtime between min and max holdtime 
		}
	else if(FixJitter == 1)
		{
		Curr_holdtime 	= 500;
		}
		
	cuetime_diff = Max_cueTime - Min_cueTime;
	per_jitter 	= random(1001)/1000.0;
	jitter = cuetime_diff*per_jitter;
	
	curr_cuetime = round(Min_cueTime + jitter);
	
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
	//StimTm = 1; //Single stim time
	StimTm = 0; //stim off
	//StimTm = 5; //For prolonged stim protocol
	// -----------------------------------------------------------------------------------------------
	// 8) Choose Eccentricity
	
	SelEcc = Random(3); //choose from four eccentricities randomly; see line 130 LOC_RAND.pro
	
	}
	
	
	