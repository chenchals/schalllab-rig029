//--------------------------------------------------------------------------------------------
// Run a memory guided saccade trial based on the variables calculated by SETM_TRL.pro and 
// those given by the user.  Adapted from CMDTRIAL.
//
// written by david.c.godlove@vanderbilt.edu 	July, 2011

declare hide int Trl_Outcome;			// Global output used in END_TRL
declare hide int Trl_Start_Time;		// Global output used in END_TRL
declare hide int LastStopOutcome = 2;	// Global output used to staircase SSD

declare GNGTRIAL(allowed_fix_time,		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime, 			// see SETM_TRL.pro
				trl_type,
				max_saccade_time,
				curr_soa,				// see SETM_TRL.pro
				cancl_time,		 		// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,			// see ALL_VARS.pro and DEFAULT.pro
				object_fix);			// animated graph object
				
							
process GNGTRIAL(allowed_fix_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime,     		// see SETM_TRL.pro
				trl_type,
				max_saccade_time,
				curr_soa,				// see SETM_TRL.pro
				cancl_time,  		// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,    		// see ALL_VARS.pro and DEFAULT.pro
				object_fix)        		// animated graph object
	{
	
	// Number the trial types to make them easier to read below
	declare hide int 	go_trl 		= 0;
	declare hide int 	stop_trl 	= 1;
	declare hide int 	ignore_trl 	= 2;
	
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
	declare hide int	fixation_pd			= 1;										
	declare hide int	fixation    		= 2;
	declare hide int	fixation_target_pd	= 3;
	declare hide int	signal_pd_T			= 4;					//temporal training
	declare hide int	signal_pd_S			= 5;					//temporal training
	declare hide int	target				= 6;					//temporal training
	declare hide int	atarget				= 7;					//temporal training
	
	//declare hide int	signal_pd			= 4;
	//declare hide int  signal				= 5;
	//declare hide int	target_pd   		= 6;										
	//declare hide int	target      		= 7;
	
	// Assign values to success and failure so they are more readable
	declare hide int	success		= 1;
	declare hide int	failure		= 0;
	declare hide int	no_change	= 2;
	
	// Code all possible outcomes (codes are shared with countermanding for efficiency)
	declare hide int constant no_fix		= 1;	// never attained fixation
	declare hide int constant broke_fix		= 2;	// attained and then lost fixation before target presentation
	declare hide int constant go_wrong		= 3;	// never made saccade on a go trial
	declare hide int constant nogo_correct	= 4;	// successfully canceled trial
	declare hide int constant sacc_out		= 5;	// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;	// didn't hold fixation at the target for long enough
	declare hide int constant go_correct	= 7;
	declare hide int constant nogo_wrong	= 8;	// error noncanceled trial
	declare hide int constant early_sacc	= 9;	// made a saccade before fixation offset
	declare hide int constant no_sacc		= 10;	// didn't make a saccade after cued to do so
	//declare hide int constant correct_sacc	= 11;	// correct saccade after cue
	  
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
	if (trl_type == go_trl)
		{
		printf("GO\n");
		printf("holdtime = %d\n",curr_holdtime);
		}
	if (trl_type == stop_trl)
		{
		printf("STOP\n");
		printf("holdtime = %d\n",curr_holdtime);
		printf("               SOA = %d\n",Curr_soa);
		}
	if (trl_type == ignore_trl)
		{
		printf("IGNORE\n");
		printf("holdtime = %d\n",curr_holdtime);
		printf("               SOA = %d\n",Curr_soa);
		}
	
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
				nexttick;
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
				stage = need_fix;
				trl_running = 0;											// ...and terminate the trial.
				nexttick;
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n",fixation_target_pd);						// ...flip the pg to the target with pd marker...	
				targ_time = time(); 										// ...record the time...
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				dsendf("vp %d\n",fixation);									// ...flip the pg to the fixation point without pd marker.
				Event_fifo[Set_event] = Target_;							// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
		
					
		
//SHOULD PROBABLY STROBE THAT THE TARGET WAS PRESENTED AT THIS POINT.
//MUST MAKE SURE IT DOESN'T SCREW UP TRANSLATION
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
				stage = need_fix;
				trl_running = 0;											// ...and terminate the trial.
				nexttick;
				}
			
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > targ_time + curr_soa && trl_type == ignore_trl )	 							// ...and the stim onset asychrony passes...
				{
				//dsendf("vp %d\n",signal_pd);								// Flip the pg to the blank screen with the photodiode marker...
				dsendf("vp %d\n",signal_pd_T); //temporal training
				fix_off_time = time();										// ...and record the time that the fixation point was extinguished.
				Event_fifo[Set_event] = FixSpotOff_;						// Queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				//dsendf("vp %d\n",signal);									// ...flip the pg to the blank screen without pd marker.
				dsendf("vp %d\n",target);
	//			oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				stage = fix_off;											// ...and advance to the next stage.
				}
			else if (In_FixWin &&  											// temporal training ....
				time() > targ_time + curr_soa && trl_type == stop_trl )	 	//						
				{															//			
				//dsendf("vp %d\n",signal_pd);								//
				dsendf("vp %d\n",signal_pd_S); //temporal training			//
				fix_off_time = time();										//
				Event_fifo[Set_event] = FixSpotOff_;						//
				Set_event = (Set_event + 1) % Event_fifo_N;					//
				dsendf("XM RFRSH:\n"); 										//
				//dsendf("vp %d\n",signal);									//
				dsendf("vp %d\n",signal_pd_S);									//
	//			oSetAttribute(object_fix, aINVISIBLE); 						//
				stage = fix_off;											// ...... temporal training
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
				printf("                          rt = %d\n",saccade_time - fix_off_time);	// ...tell the user whats up...
				stage = in_flight;											// ...and advance to the next stage.
				}
									
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > fix_off_time + max_saccade_time &&
				(trl_type == go_trl || trl_type == ignore_trl)) 			// ...and time for a saccade runs out...
				{
				Trl_Outcome = go_wrong;           							// TRIAL OUTCOME ERROR (incorrect go trial)
				LastStopOutcome = no_change;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (no saccade)\n");								// ...tell the user whats up...
				spawn SVR_BELL();
				stage = need_fix;
				trl_running = 0;											// ...and terminate the trial.
				nexttick;
				}
				
			else if (In_FixWin &&											// But if no saccade occurs...
				time() > fix_off_time + cancl_time && 						// ...and time for a saccade runs out...
				trl_type == stop_trl)										// ...and a saccade was NOT supposed to be made...
				{
				Trl_Outcome = nogo_correct;   								// TRIAL OUTCOME CORRECT (canceled trial)
				LastStopOutcome = no_change;								// set the global for staircasing...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				Event_fifo[Set_event] = Correct_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				printf("Correct (canceled)\n");								// ...tell the user whats up...
				if (Canc_alert)
					{
					spawn SVR_BEL2();										// for training purposes
					}
					stage = need_fix;
				trl_running = 0;  											// ...and terminate the trial.
				nexttick;
				}	
			}			
			
			
	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)		
		else if (stage == in_flight)
			{
			if (In_TargWin)													// If the eyes get into the target window...
				{
				//dsendf("vp %d\n",target_pd);								// ...flip the pg to the target with pd marker...	
				aquire_targ_time = time(); 									// ...record the time...
				if (trl_type == ignore_trl)
				{
				dsendf("XM RFRSH:\n"); 										// ...wait for one retrace cycle...
				dsendf("vp %d\n",atarget);									// ...flip the pg to the target without pd marker.
				}
				Event_fifo[Set_event] = Decide_;							// ...queue strobe...
				Set_event = (Set_event + 1) % Event_fifo_N;					// ...incriment event queue...
				stage = on_target;											// ...and advance to the next stage of the trial.
				if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
					{												
					Event_fifo[Set_event] = Error_sacc;						// ...queue strobe for Neuro Explorer
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.
					}
				else 														// Otherwise...
					{								
					Event_fifo[Set_event] = Correct_sacc;					// ...queue strobe for Neuro Explorer
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue.					
					}
				}
			else if (time() > saccade_time + max_sacc_duration)				// But, if the eyes are out of the target window and time runs out...
				{
				Trl_Outcome = sacc_out;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
					{												
					LastStopOutcome = no_change;								// ...record the failure.
					}
				else 														// Otherwise...
					{								
					LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.						
					}
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (inaccurate saccade)\n");						// ...tell the user whats up...
				stage = need_fix;
				trl_running = 0; 											// ...and terminate the trial.
				nexttick;
				}
			}
		
		
		
	//--------------------------------------------------------------------------------------------
	// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)	
		else if (stage == on_target)
			{
			if (!In_TargWin)												// If the eyes left the target window...
				{			
				Trl_Outcome = broke_targ;									// TRIAL OUTCOME ERROR (broke target fixation)
				if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
					{												
					LastStopOutcome = no_change;
					}
				else 														// Otherwise...
					{								
					LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.						
					}
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Error (broke target fixation)\n");					// ...tell the user whats up...
				stage = need_fix;
				trl_running = 0;											// ...and terminate the trial.
				nexttick;
				}		
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targ_hold_time)				// ...and the target hold time is up...				
				{
				if (trl_type == go_trl || trl_type == ignore_trl)			// ...and a saccade was the correct thing to do...
					{
					Trl_Outcome = go_correct;								//TRIAL OUTCOME CORRECT (correct go trial)
					LastStopOutcome = no_change;							// Don't change SSD
					Event_fifo[Set_event] = Correct_;						// ...queue strobe...
					Set_event = (Set_event + 1) % Event_fifo_N;				// ...incriment event queue...
					printf("Correct (saccade)\n");							// ...tell the user whats up...
					}
				else if (trl_type == stop_trl)								// But if a saccade was the wrong thing to do...
					{
					Trl_Outcome = nogo_wrong;								//TRIAL OUTCOME ERROR (noncanceled trial)
					LastStopOutcome = no_change;
					printf("Error (noncanceled)\n");						// ...tell the user whats up...
					}							// ...tell the user whats up...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				stage = need_fix;
				trl_running = 0;											// ...and terminate the trial.
				nexttick;
				}			
			}
		nexttick;
		}
	}