//Modified by Namsoo 5/23/2012

declare hide int Trl_Outcome;			// Global output used in END_TRL
declare hide int Trl_Start_Time;		// Global output used in END_TRL
declare hide int ReactionTime;

declare DELTRIAL(allowed_fix_time,		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime, 			// see SETM_TRL.pro
				curr_soa,				// see SETM_TRL.pro
				max_saccade_time, 		// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,			// see ALL_VARS.pro and DEFAULT.pro
				object_fix);			// animated graph object

process DELTRIAL(allowed_fix_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime,     		// see SETM_TRL.pro
				curr_soa,				// see SETM_TRL.pro
				max_saccade_time,  		// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,    		// see ALL_VARS.pro and DEFAULT.pro
				object_fix)        		// animated graph object
	{
	
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  	= 1;
	declare hide int 	fixating  	= 2;
	declare hide int 	targ_on   	= 3;
	declare hide int	fix_off		= 4;
	declare hide int 	in_flight 	= 5;
	declare hide int 	on_target 	= 6;	
	declare hide int 	stage;
	
	// Number the stimuli pages to make reading easier
	declare hide int   	blank       		= 0;
	declare hide int	fixation_pd 		= 1;
	declare hide int	fixation    		= 2;
	declare hide int	fixation_target_pd	= 3;
	declare hide int    fixation_target     = 4;
	declare hide int	target_pd   		= 5;	
	declare hide int	target       		= 6;	
	
	// Code all possible outcomes (codes are shared with countermanding for efficiency)
	declare hide int constant no_fix		= 1;	// never attained fixation
	declare hide int constant broke_fix		= 2;	// attained and then lost fixation before target presentation
	declare hide int constant sacc_out		= 5;	// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;	// didn't hold fixation at the target for long enough
	declare hide int constant early_sacc	= 9;	// made a saccade before fixation offset
	declare hide int constant no_sacc		= 10;	// didn't make a saccade after cued to do so
	declare hide int constant correct_sacc	= 11;	// correct saccade after cue
	declare hide int constant anticip_sacc  = 13;
	
	// Timing variables which will be used to time task
	declare hide float 	fix_on_time; 	
	declare hide float 	aquire_fix_time;
	declare hide float  targ_time;	
	declare hide float	fix_off_time;
	declare hide float  saccade_time;
	declare hide float	aquire_targ_time;	
	
	// This variable makes the while loop work
	declare hide int 	trl_running;
	
	
	
	// Have to be reset on every iteration since 
	// variable declaration only occurs at load time
	trl_running 		= 1;
	stage 				= need_fix;
	
	// Tell the user what's up
	printf(" \n");
	printf("# %d",Trl_number);
	printf(" (%d",Comp_Trl_number);
	printf(" correct)\n");

	
	
																			// HERE IS WHERE THE FUN BEGINS
	Event_fifo[Set_event] = TrialStart_;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	dsendf("vp %d\n",fixation_pd);											// flip the pg to the fixation stim with pd marker
	fix_on_time = time();  													// record the time
	Event_fifo[Set_event] = FixSpotOn_;										// queue strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	dsendf("XM RFRSH:\n"); 													// wait for one retrace
	dsendf("vp %d\n",fixation);												// flip the pg to the fixation stim without pd marker
	oSetAttribute(object_fix, aVISIBLE); 									// turn on the fixation point in animated graph
	
	
	while (trl_running)														// trials ending will set trl_running = 0
		{	
		
	//--------------------------------------------------------------------------------------------
	// STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
		if (stage == need_fix)
			{		
			if (In_FixWin)													// If the eyes have entered the fixation window (before time, see below)...
				{
				aquire_fix_time = time();									// ...function call to time to note current time and...
				Trl_Start_Time = aquire_fix_time;							// Global output for timing iti
				Event_fifo[Set_event] = Fixate_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = fixating;											// ...advance to the next stage.
				}
			else if (time() > fix_on_time + allowed_fix_time)				// But if time runs out...
				{
				Trl_Outcome = no_fix;    									// TRIAL OUTCOME ABORT (no fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (no fixation)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE fixating (the subject is looking at the fixation point waiting for target onset)		
		else if (stage == fixating)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ABORT (broke fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Aborted (broke fixation)\n");						// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n",fixation_target_pd);						// ...flip the pg to the target with pd marker...	
				targ_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				dsendf("vp %d\n",fixation_target);									// ...flip the pg to the fixation point without pd marker.
				Event_fifo[Set_event] = Target_;										// queue strobe
				Set_event = (Set_event + 1) % Event_fifo_N;
				oSetAttribute(object_targ, aVISIBLE); 						// ...show target in animated graph...
														
				stage = targ_on;											// Advance to the next trial stage.				
				}
			}
			
			

	//--------------------------------------------------------------------------------------------
	// STAGE targ_on (the target has been presented but the subject is still fixating)		
		else if (stage == targ_on)
			{		
			if (!In_FixWin)													// If the eyes leave the fixation window...
				{
				Trl_Outcome = early_sacc;									// TRIAL OUTCOME ERROR (sacc before cued to do so)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (early saccade)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > targ_time + curr_soa)	 							// ...and the stim onset asychrony passes...
				{
				printf("       soa = %d\n",curr_soa);
				dsendf("vp %d\n",target_pd);										// Flip the pg to the blank screen with the photodiode marker...
				dsendf("XM RFRSH:\n"); 
				dsendf("vp %d\n",target);
				fix_off_time = time();										// ...and record the time that the fixation point was extinguished.
				Event_fifo[Set_event] = FixSpotOff_;						// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				stage = fix_off;											// ...and advance to the next stage.
				}	
			}



	//--------------------------------------------------------------------------------------------
	// STAGE fix_off (the fixation point has been turned off but the subject is still fixating)		
		else if (stage == fix_off)
			{
			if (!In_FixWin)													// If the eyes leave the fixation window...			
				{															// ...we have a saccade, so...
				saccade_time = time();										// ...record the time...
				Event_fifo[Set_event] = Saccade_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				ReactionTime = saccade_time - fix_off_time;
				printf("           rt = %d\n",ReactionTime);	// ...tell the user whats up...
				stage = in_flight;											// ...and advance to the next stage.
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > fix_off_time + max_saccade_time) 					// ...and time for a saccade runs out...
				{
				Trl_Outcome = no_sacc;           							// TRIAL OUTCOME ERROR (no saccade after cue)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (no saccade)\n");								// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}	
				
			//else if (In_FixWin && ReactionTime < 150)
			//	{
			//	Trl_Outcome = anticip_sacc;
			//	dsendf("vp %d\n",blank);
			//	oSetAttribute(object_targ, aINVISIBLE);
			//	oSetAttribute(object_fix, aINVISIBLE);
			//	printf("Error (anticipatory saccade)\n");
			}			
			
			
	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)		
		else if (stage == in_flight)
			{
			if (In_TargWin)													// If the eyes get into the target window...
				{
//				dsendf("vp %d\n",target);								// ...flip the pg to the target with pd marker...	
				aquire_targ_time = time(); 									// ...record the time...
//				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
//				dsendf("vp %d\n",target_pd);									// ...flip the pg to the target without pd marker.
				Event_fifo[Set_event] = Decide_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = on_target;											// ...and advance to the next stage of the trial.
				}
			else if (time() > saccade_time + max_sacc_duration)				// But, if the eyes are out of the target window and time runs out...
				{
				Trl_Outcome = sacc_out;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
				trl_running = 0; 											// ...and terminate the trial.
				}
			}
		
		
		
	//--------------------------------------------------------------------------------------------
	// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)	
		else if (stage == on_target)
			{
			if (!In_TargWin)												// If the eyes left the target window...
				{			
				Trl_Outcome = broke_targ;									// TRIAL OUTCOME ERROR (broke target fixation)
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}		
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targ_hold_time)				// ...and the target hold time is up...				
				{
				Trl_Outcome = correct_sacc;									//TRIAL OUTCOME CORRECT (correct sacc trial)
				Event_fifo[Set_event] = Correct_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("Correct (saccade)\n");								// ...tell the user whats up...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}			
			}
			
		nexttick;
		}
	}
	