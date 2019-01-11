//--------------------------------------------------------------------------------------------
// Run a search trial based on the variables calculated by SETS_TRL.pro and those 
// given by the user.
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013

declare hide int StimTm;
declare hide int Trl_Outcome;			// Global output used in END_TRL
declare hide int Trl_Start_Time;		// Global output used in END_TRL
declare hide int LastSearchOutcome;		// Global output used in END_TRL

#include C:/TEMPO/ProcLib/SETA_TRL.pro

declare ANTITR(allowed_fix_time,		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime, 			// see SETC_TRL.pro
				trl_type, 				// see SETC_TRL.pro
				max_saccade_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_ssd, 				// see SETC_TRL.pro
				cancl_time,				// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,			// see ALL_VARS.pro and DEFAULT.pro
				object_fix);			// animated graph object


process ANTITR(allowed_fix_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime,     		// see SETC_TRL.pro
				trl_type,          		// see SETC_TRL.pro
				max_saccade_time,  		// see ALL_VARS.pro and DEFAULT.pro
				curr_ssd,          		// see SETC_TRL.pro
				cancl_time,        		// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,    		// see ALL_VARS.pro and DEFAULT.pro
				object_fix)        		// animated graph object
	{
	
	//set timing parameters


	// Number the trial types to make them easier to read below
	declare hide int 	go_trl 		= 0;
	declare hide int 	stop_trl 	= 1;
	declare hide int 	ignore_trl 	= 2;
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  		= 1;
	declare hide int 	fixating_cue 	= 2;
	declare hide int 	fixating_ph		= 3;
	declare hide int 	fixating_targ	= 4;
	declare hide int 	fixating_off	= 5;
	declare hide int 	fixation_offset	= 6;
	declare hide int 	in_flight 		= 7;
	declare hide int 	on_target 		= 8;	
	declare hide int 	stage;
	
	// Number the stimuli pages to make reading easier
	declare hide int   	blank       = 0;
	declare hide int	fixation_pd = 1;
	declare hide int	fixation    = 2;
	//declare hide int 	cue_pd 		= 3;
	declare hide int 	cue 		= 3;
	//declare hide int	plac_pd   	= 4;
	//declare hide int	plac      	= 5;
	declare hide int	target_f_pd = 4;
	declare hide int	target_f    = 5;
	declare hide int	target      = 6;
	declare hide int 	targ_only   = 7;
	
	// Assign values to success and failure so they are more readable
	declare hide int	success		 = 1;
	declare hide int	failure		 = 0;
	declare hide int	nogo_success = 3;
	declare hide int	no_change	 = 2;
	
	// Code all possible outcomes
	declare hide int constant no_fix		= 1;	// never attained fixation
	declare hide int constant broke_fix		= 2;	// attained and then lost fixation before target presentation
	declare hide int constant no_saccade	= 3;	// never made saccade on a go trial
	declare hide int constant nogo_correct	= 4;	// successfully canceled trial
	declare hide int constant sacc_out		= 5;	// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;	// didn't hold fixation at the target for long enough
	declare hide int constant go_correct	= 7;	// correct saccade on a go trial
	declare hide int constant nogo_wrong	= 8;	// error noncanceled trial
	declare hide int constant body_move		= 12;	// error body movement (for training stillness)
	declare hide int constant too_fast		= 14;	// low RT while in training to slow down.
	declare hide int constant late_correct  = 15; 		// Eventually found the target but not on first saccade            
	// Timing variables which will be used to time task
	declare hide float 	fix_spot_time; 					
	declare hide float  targ_time;
	declare hide float  fix_off_Time; 						
	declare hide float  saccade_time;
	declare hide float 	aquire_fix_time;
	declare hide float 	stop_sig_time;
	declare hide float	aquire_targ_time;
		
	
	// This variable makes the while loop work
	declare hide int 	trl_running;
	declare hide int isExtinguished;
		// Stim complete?
	declare hide int 	StimDone;
	StimDone = 0;
	
	// Have to be reset on every iteration since 
	// variable declaration only occurs at load time
	trl_running 		= 1;
	isExtinguished = 0;
	stage 				= need_fix;
	
	// Tell the user what's up
	printf(" \n");
	printf("Block %d",Block_number);
	printf(" \n");
	printf("# %d",Trl_number);
	printf(" \n");
	printf("Trial Type = %d",TrialTP);
	printf(" \n");
	printf("Fix-Sch ISI = %d",Curr_holdtime);
	printf(" \n");
	//printf(" Random Trials(%d",Rand_Comp_Trl_number);

// Need to change the below to reflect Pro/Anti vars of interest...
printf("\n");
printf("SUMMARY:        # Correct (C/I/S)    %% Corr (C/I/S)    RT\n");
printf(" pro correct   = %d(%d/%d/%d)         %d(%d/%d/%d)    %d\n", Pro_Comp_Trl_number,Pro_Cong_Trl_number,Pro_ICong_Trl_number,Pro_CCong_Trl_number,ProPerAcc,ProCongAcc,ProICongAcc,ProCCongAcc, avg_pro_rt);
//printf("    %d    %d",ProPerAcc, avg_pro_rt);
//printf("\n");
printf(" anti correct  = %d(%d/%d/%d)         %d(%d/%d/%d)    %d\n", Anti_Comp_Trl_number,Anti_Cong_Trl_number,Anti_ICong_Trl_number,Anti_CCong_Trl_number,AntiPerAcc,AntiCongAcc,AntiICongAcc,AntiCCongAcc, avg_anti_rt);
//printf("    %d    %d",AntiPerAcc, avg_anti_rt);
//printf("\n");
printf(" catch correct =     %d                %d\n", Catch_Comp_Trl_number,CatchPerAcc);
//printf("    %d",CatchPerAcc);
//printf("\n");

/*if (SingMode == 0)
	{
	printf(" random correct = %d",Rand_Comp_Trl_number);
	printf("    %d",RandPerAcc);
	printf(" \n");
	printf(" repeat correct = %d",Rep_Comp_Trl_number);
	printf("    %d",RepPerAcc);
	
	printf(" \n");
	printf(" (%d",avg_rand_rt);
	printf(" random RT)\n");
	
	printf(" (%d",avg_rep_rt);
	printf(" repeated RT)\n");
	printf("soa = %d\n",search_fix_time);
	}
else if (SingMode == 1)
	{
	printf(" Sing. Abs. correct = %d",Rand_Comp_Trl_DA);
	printf("    %d",RandPerAcc_DA);
	printf(" \n");
	printf(" Sing. Pres. correct = %d",Rand_Comp_Trl_DP);
	printf("    %d",RandPerAcc_DP);
	
	printf(" \n");
	printf(" (%d",avg_rand_rt_DA);
	printf(" absent RT)\n");
	
	printf(" (%d",avg_rand_rt_DP);
	printf(" present RT)\n");
	printf("soa = %d\n",search_fix_time);
	}	
*/
	/*if (SingMode == 0)
	{
		Event_fifo[Set_event] = SearchHeader_;									// queue TrialStart_ strobe
		Set_event = (Set_event + 1) % Event_fifo_N;																			// HERE IS WHERE THE FUN BEGINS
	}
	else if (SingMode == 1)
	{
		Event_fifo[Set_event] = CaptureHeader_;									// queue TrialStart_ strobe
		Set_event = (Set_event + 1) % Event_fifo_N;																			// HERE IS WHERE THE FUN BEGINS
	}
	*/
	
	Event_fifo[Set_event] = AntiHeader_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;	
	
	Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	
	spawnwait SETA_TRL(n_targ_pos,				// Select variables for the first search...
				go_weight,						// ...trial.  This happens once outside of the while...
				stop_weight,					// ...loop just to set up for the first iteration. After...
				ignore_weight,					// ...that SETC_TRL.pro will be called by END_TRL.pro.
				staircase,
				n_SSDs,
				min_holdtime,
                max_holdtime,
				expo_jitter);
	
	//printf("sending fixation_pd... %d\n",fixation_pd);
	dsendf("vp %d\n",fixation_pd);											// flip the pg to the fixation stim with pd marker
	fix_spot_time = time();  												// record the time
	Event_fifo[Set_event] = FixSpotOn_;										// queue strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	
	dsendf("XM RFRSH:\n"); 													// wait one vertical retrace
	dsendf("vp %d\n",fixation);												// flip the pg to the fixation stim without pd marker
	oSetAttribute(object_fix, aVISIBLE); 									// turn on the fixation point in animated graph
	oSetAttribute(object_targ, aINVISIBLE); 									// turn on the fixation point in animated graph
	
	while (trl_running)														// trials ending will set trl_running = 0
		{	
		
	//--------------------------------------------------------------------------------------------
	// STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
		if (stage == need_fix)
			{		
			if (In_FixWin)													// If the eyes have entered the fixation window (before time, see below)...
			{
				aquire_fix_time = time();									// ...function call to time to note current time and...
				Trl_Start_Time = aquire_fix_time;							// Global output
				Event_fifo[Set_event] = Fixate_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				if (curr_cuetime > 0)
				{
					stage = fixating_cue;											// ...advance to the next stage.
				} else
				{
					stage = fixating_targ;
					plac_duration = 0;
				}
				
			}
			else if (time() > fix_spot_time + allowed_fix_time)				// But if time runs out...
				{
				Trl_Outcome = no_fix;    									// TRIAL OUTCOME ERROR (no fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Aborted (no fixation)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE turn on cue and photodiode (subject looking at fixation window waiting for placeholder onset
		else if (stage == fixating_cue)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)	// But if the eyes are still in the window at end of holdtime...
				{
				//printf("Sending cue screen: %d\n",cue_pd);
				Event_fifo[Set_event] = CueOn_;										// queue strobe
				Set_event = (Set_event + 1) % Event_fifo_N;
				//dsendf("vp %d\n",cue_pd);								// ...flip the pg to the placeholders with pd marker...	
				dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
				dsendf("vp %d\n",cue);									// ...flip the pg to the placeholders without pd marker.
				//dsendf("wm %d\n", plac_duration); // set as a variable in ALLVARS and add a random jitter
				stage = fixating_targ;
				plac_duration = 0;
				}	
			else if (StimDone == 0 && StimTm == 1 && In_FixWin && time() > aquire_fix_time + (curr_holdtime - 150))	// But if the eyes are still in the window at end of holdtime...
				{ 
					spawn STIM(stim_channel);
					StimDone = 1;
				}
			}
	// STAGE fixating placeholders (the subject is looking at the fixation point waiting for placeholder onset)		
		/*else if (stage == fixating_ph)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime + curr_cuetime)	// But if the eyes are still in the window at end of holdtime...
				{
				if (PlacPres == 2) // if placeholder are present (set in DEFAULT.pro), we need to present those fuckers.
					{
					Event_fifo[Set_event] = PlacOn_;										// queue strobe
					Set_event = (Set_event + 1) % Event_fifo_N;
					dsendf("vp %d\n",plac_pd);								// ...flip the pg to the placeholders with pd marker...	
					dsendf("XM RFRSH:\n"); 										// ...wait one vetical retrace...
					dsendf("vp %d\n",plac);									// ...flip the pg to the placeholders without pd marker.
					dsendf("wm %d\n", plac_duration); // set as a variable in ALLVARS and add a random jitter
					stage = fixating_targ;
					}
				else
				    {
					plac_duration = 0;
					stage = fixating_targ;
					}
				}	
			else if (StimDone == 0 && StimTm == 1 && In_FixWin && time() > aquire_fix_time + (curr_holdtime - 150))	// But if the eyes are still in the window at end of holdtime...
				{ 
					spawn STIM(stim_channel);
					StimDone = 1;
				}
			}
		*/
	//--------------------------------------------------------------------------------------------
	// STAGE fixating target(the subject is looking at the fixation point waiting for target onset)					
	else if (stage == fixating_targ)
			{			
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}	
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime + curr_cuetime)	
				{
				Event_fifo[Set_event] = Target_;										// queue strobe
				Set_event = (Set_event + 1) % Event_fifo_N;
				dsendf("vp %d\n",target_f_pd);							// ...flip the pg to target, fixation, pd
				targ_time = time(); 									// ...record the time...
				
				/*while (time() < (targ_time+200))
				{
					nexttick;
				}
				*/
				//printf("Showing target_f: %d\n",target_f);
				//printf("search_fix_time = %d\n",search_fix_time);
				dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
				dsendf("vp %d\n",target_f);								// ...and flip the pg to target plus fixation
				dsendf("wm %d\n",search_fix_time);                 //declared at beginning of file - wait until fixation offset to respond
				stage = fixating_off;
				}
			}	
	//--------------------------------------------------------------------------------------------
	// STAGE fixating offset(the subject is looking at the fixation point waiting for fixation offset)					
	
	else if (stage == fixating_off)
			{							
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = too_fast; 								// TRIAL OUTCOME TOO FAST (too fast while being trained to slow down)
				dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
				Event_fifo[Set_event] = EarlySaccade_;					// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
				oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Error (too fast)\n");							// ...tell the user whats up...
				trl_running = 0;
				}
			else if (!In_FixWin && time() < targ_time + Min_saccade_time)
				{
				Trl_Outcome = too_fast; 								// TRIAL OUTCOME TOO FAST (too fast while being trained to slow down)
				dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
				Event_fifo[Set_event] = EarlySaccade_;					// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
				oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Error (too fast)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}				
			else if (In_FixWin && time() > targ_time)
				{
				dsendf("vp %d\n",target);								// ...and flip the pg to the target without fixation.
				if (Catch == 0)
					{
					oSetAttribute(object_targ, aVISIBLE); 					// ...show target in animated graph...
					}
				oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
				stage = fixation_offset;											// Advance to the next trial stage.

				fix_off_time = time();
				
				Event_fifo[Set_event] = FixSpotOff_;					// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
					
					if (StimDone == 0 && StimTm == 2)
						{
						spawn STIM(stim_channel);
						StimDone = 1;
						}				
				}
			}
	//--------------------------------------------------------------------------------------------
	// STAGE targ_on (the fixation has been removed but the subject is still fixating - time to go!)		
		else if (stage == fixation_offset)
			{	
			if (!In_FixWin)													// If the eyes leave the fixation window...we have a saccade...				
				{															
				if (Catch == 1) //catch trial...
					{
					Trl_Outcome = nogo_wrong; 								// You dumbshit, you made a saccade on a catch trial!
					dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
					oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
					Event_fifo[Set_event] = CatchIncorrectG_;										// queue strobe
					Set_event = (Set_event + 1) % Event_fifo_N;
					lastsearchoutcome = failure;
					printf("Error (NoGo)\n");							// ...tell the user whats up...
					trl_running = 0;
					}
				else if (Catch == 0) //not a catch trial...
					{
						
					/* if (PlacPres == 2)
						{ */								
						saccade_time = time();										// ...record the time...
						Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
						Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
						printf("rt = %d\n",saccade_time - targ_time - search_fix_time - plac_duration);				// ...tell the user whats up...
						current_rt = saccade_time - targ_time - search_fix_time - plac_duration;
						
						if (extinguishTime == 1)
						{
							dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
							dsendf("vp %d\n",targ_only);									// Flip the pg to the blank screen...
						}
						stage = in_flight;											// ...and advance to the next stage.
						
						/*	if (saccade_time - fix_off_time < search_fix_time + plac_duration)
								{
								Trl_Outcome = too_fast; 								// TRIAL OUTCOME TOO FAST (too fast while being trained to slow down)
								dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
								Event_fifo[Set_event] = EarlySaccade_;							// ...queue strobe...
								Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
								oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
								oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
								lastsearchoutcome = failure;
								printf("Error (too fast)\n");							// ...tell the user whats up...
								trl_running = 0;										// ...and terminate the trial.
								}
						*/
/* 						}
					else // if placeholders not present, its just normal search and no need to account for placeholder duration
						{	
						saccade_time = time();										// ...record the time...
						Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
						Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
						printf("rt = %d\n",saccade_time - targ_time - search_fix_time);				// ...tell the user whats up...
						current_rt = saccade_time - targ_time - search_fix_time;
						stage = in_flight;											// ...and advance to the next stage.
						
							if (saccade_time - targ_time < search_fix_time)
								{
								Trl_Outcome = too_fast; 								// TRIAL OUTCOME TOO FAST (too fast while being trained to slow down)
								dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
								oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
								oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
								lastsearchoutcome = failure;
								printf("Error (too fast)\n");							// ...tell the user whats up...
								trl_running = 0;										// ...and terminate the trial.
								}
						}  */
					}
				}					
////////////////////// Code for stimulating just prior to (70ms) a saccade /////////////////////
				// else if (Catch == 0 && In_FixWin && StimDone == 0 && StimTm == 3 && time() > fix_off_time + 70)	// But if the eyes are still in the window at end of holdtime...
				// { 
				// spawn STIM(stim_channel);
				// StimDone = 1;
				// }
/////////////////////////////////////////////////////////////////////////////////////////////////
				
			else if (Catch == 0 && In_FixWin &&  											// But if no saccade occurs...
				time() > fix_off_time + search_fix_time + plac_duration + max_saccade_time)				// ...and a saccade was supposed to be made.
				{
				Trl_Outcome = no_saccade;           						// TRIAL OUTCOME ERROR - made saccade on catch trial
				dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
				if (leaveStimsPunish == 1)
				{
					dsendf("vp %d\n",targ_only);
				} else
				{
					dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				}
				Event_fifo[Set_event] = CatchIncorrectNG_;										// queue strobe
				Set_event = (Set_event + 1) % Event_fifo_N;
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = failure;
				printf("Error (no saccade)\n");								// ...tell the user whats up...
				spawn SVR_BELL();
				trl_running = 0;											// ...and terminate the trial.
				}			
			else if (Catch == 1 && In_FixWin && 
				time() > fix_off_time + search_fix_time + plac_duration + catch_hold_time)
				{
				Trl_Outcome = nogo_correct;           						// Catch trial success
				dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				Event_fifo[Set_event] = CatchCorrect_;										// queue strobe
				Set_event = (Set_event + 1) % Event_fifo_N;
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				lastsearchoutcome = nogo_success;
				printf("Catch Correct\n");								// ...tell the user whats up...
				trl_running = 0;
				}					
			}

	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)		
		else if (stage == in_flight)
			{
				
			if (In_TargWin)													// If the eyes get into the target window...
				{
				if (extinguishTime == 2)
				{
					dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
					dsendf("vp %d\n",targ_only);									// Flip the pg to the blank screen...
					//printf("Catch=%d, extTime=%d, inTargWinReached\n",Catch,extinguishTime);
				}
				aquire_targ_time = time();									// ...record the time...
				stage = on_target;											// ...and advance to the next stage of the trial.
								
				Event_fifo[Set_event] = Correct_sacc;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
				
				rewdDiscount = ((aquire_targ_time-saccade_time) - 50)/(max_sacc_duration - 50);
				if (rewdDiscount < 0)
				{
					rewdDiscount = 0;
				}
				}
			else if (time() > saccade_time + max_sacc_duration)				// But, if the eyes are out of the target window and time runs out...
				{
				Trl_Outcome = sacc_out;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				if (leaveStimsPunish == 1)
				{
					dsendf("vp %d\n",targ_only);									// Flip the pg to the blank screen...
				} else
				{
					dsendf("vp %d\n",blank);
				}
				Event_fifo[Set_event] = Error_sacc;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.				
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
				trl_running = 0; 											// ...and terminate the trial.
				}
			else if ((time() > saccade_time + helpDelay) && extinguishTime == 3 && !isExtinguished)
			{
				dsendf("XM RFRSH:\n"); 									// ...wait 1 vertical retrace...
				dsendf("vp %d\n",targ_only);
				Event_fifo[Set_event] = StimHelp_;				// Flip the pg to the blank screen...
				Set_event = (Set_event + 1) % Event_fifo_N;
				isExtinguished = 1;
				//printf("Catch=%d, extTime=%d, inTargWinReached\n",Catch,extinguishTime);
			}
			}
		
		
		
	//--------------------------------------------------------------------------------------------
	// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)	
		else if (stage == on_target)
			{
			if (!In_TargWin)												// If the eyes left the target window...
				{			
				Trl_Outcome = broke_targ;									// TRIAL OUTCOME ERROR (broke target fixation)
				if (leaveStimsPunish == 1)
				{
					dsendf("vp %d\n",targ_only);
				} else
				{
					dsendf("vp %d\n",blank);
				}
				Event_fifo[Set_event] = BreakTFix_;					// ...queue strobe for Neuro Explorer
				Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.				// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}		
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targ_hold_time)				// ...and the target hold time is up...
				{

					if (isExtinguished == 1) {
						Trl_Outcome = late_correct;
					} else
					{
						Trl_Outcome = go_correct;								//TRIAL OUTCOME CORRECT (correct go trial)
						Correct_trls = Correct_trls + 1;						// ...set a global for 1DR...
					}
					Event_fifo[Set_event] = Correct_;						// ...queue strobe...
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
					lastsearchoutcome = success;
					printf("Correct (saccade)\n");							// ...tell the user whats up...
																// Either way we are done, so...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				////////////////////// Code for stimulating when fixated on target /////////////////////
				dsendf("wm %d\n",200);
				if (StimTm == 3)	
				{ 
				spawn STIM(stim_channel);
				StimDone = 1;
				}
				/////////////////////////////////////////////////////////////////////////////////////////////////
				
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}			
			
		if (Move_ct > 0)
			{
			Trl_Outcome = body_move;   										// TRIAL OUTCOME ABORTED (the body was moving)
			dsendf("vp %d\n",blank);										// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 						// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 							// ...remove fixation point from animated graph...
			printf("Aborted (body movement)\n");							// ...tell the user whats up...
			trl_running = 0; 												// ...and terminate the trial.
			}	
			
		nexttick;
		}
	}