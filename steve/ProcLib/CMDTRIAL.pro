//--------------------------------------------------------------------------------------------
// Run a countermanding trial based on the variables calculated by SETC_TRL.pro and those
// given by the user.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare hide int Trl_Outcome;			// Global output used in END_TRL
declare hide int Trl_Start_Time;		// Global output used in END_TRL
declare hide int LastStopOutcome = 1;	// Global output used to staircase SSD

#include C:/TEMPO/ProcLib/DEVELOP/WAIT_VS.PRO
#include C:/TEMPO/ProcLib/SEND_EVT.pro


declare CMDTRIAL(allowed_fix_time,		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime, 			// see SETC_TRL.pro
				trl_type, 				// see SETC_TRL.pro
				max_saccade_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_ssd, 				// see SETC_TRL.pro
				cancl_time,				// see ALL_VARS.pro and DEFAULT.pro
				max_sacc_duration, 		// see ALL_VARS.pro and DEFAULT.pro
				targ_hold_time,			// see ALL_VARS.pro and DEFAULT.pro
				object_fix);			// animated graph object

process CMDTRIAL(allowed_fix_time, 		// see ALL_VARS.pro and DEFAULT.pro
				curr_holdtime,     		// see SETC_TRL.pro
				trl_type,          		// see SETC_TRL.pro
				max_saccade_time,  		// see ALL_VARS.pro and DEFAULT.pro
				curr_ssd,          		// see SETC_TRL.pro
				cancl_time,        		// see ALL_VARS.pro and DEFAULT.pro
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
	declare hide int 	in_flight 	= 4;
	declare hide int 	on_target 	= 5;
	declare hide int 	return_fix_check = 6;
	declare hide int 	stage;
	declare hide int 	test = 10;

	// Number the stimuli pages to make reading easier
	declare hide int   	blank       = 0;
	declare hide int	fixation_pd = 1;
	declare hide int	fixation    = 2;
	declare hide int	target_pd   = 3;
	declare hide int	target      = 4;
	declare hide int	signal_pd   = 5;
	declare hide int	signal      = 6;

	// Assign values to success and failure so they are more readable
	declare hide int	success		= 1;
	declare hide int	failure		= 0;
	declare hide int	no_change	= 2;
	
	// Code all possible outcomes
	declare hide int constant no_fix		= 1;	// never attained fixation
	declare hide int constant broke_fix		= 2;	// attained and then lost fixation before target presentation
	declare hide int constant go_wrong		= 3;	// never made saccade on a go trial
	declare hide int constant nogo_correct	= 4;	// successfully canceled trial
	declare hide int constant sacc_out		= 5;	// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;	// didn't hold fixation at the target for long enough
	declare hide int constant go_correct	= 7;	// correct saccade on a go trial
	declare hide int constant nogo_wrong	= 8;	// error noncanceled trial
	declare hide int constant body_move		= 12;	// error body movement (for training stillness)
	declare hide int constant too_fast		= 14;	// low RT while in training to slow down.
	declare hide int constant returnTofix    = 16; 		// Eventually found the target but not on first saccade
	                                        
	// Timing variables which will be used to time task
	declare hide float 	fix_spot_time;
	declare hide float  targ_time;
	declare hide float  saccade_time;
	declare hide float 	aquire_fix_time;
	declare hide float 	brokeTargTime;
	declare hide float 	stop_sig_time;
	declare hide float	aquire_targ_time;
	declare hide int	noncanceled_trl_count;
	declare hide int	canceled_trl_count;
	declare hide int	nostop_trl_count;
	declare hide int	tempPDvalue;
	declare hide float	tempTime;

	// This variable makes the while loop work
	declare hide int 	trl_running;

	// Have to be reset on every iteration since
	// variable declaration only occurs at load time
	trl_running 		= 1;
	//stage 				= need_fix;
	stage 				= test;

	// Tell the user what's up
	printf(" \n");
	printf(" *********************************\n");
	printf("Block: %d / # %d ",Block_number, Trl_number);
	printf(" (%d",Comp_Trl_number);
	printf(" correct; GO = %d; C = %d; NC = %d)\n",nostop_trl_count,canceled_trl_count, noncanceled_trl_count);



		if (trl_type == go_trl)
			{
			printf("Trial Type: NO-STOP\n");
			printf("Holdtime = %d\n",curr_holdtime);
			}
		if (trl_type == stop_trl)
			{
			printf("Trial Type: STOP\n");
			printf("Holdtime = %d\n",curr_holdtime);
			printf("     SSD = %d\n",round(curr_ssd * (1000.0/Refresh_rate)));
			}
		if (trl_type == ignore_trl)
			{
			printf("Trial Type: IGNORE\n");
			printf("Holdtime = %d\n",curr_holdtime);
			printf("     ISD = %d\n",round(curr_ssd * (1000.0/Refresh_rate)));
			}

		spawn SEND_EVT(CmanHeader_);
		spawn SEND_EVT(TrialStart_);
    // Show fixation with white boxes for photocell
		dsendf("vp %d\n",fixation_pd);
		while(!pdIsOn)
		{
			spawnwait WAIT_VS();
		}
		fix_spot_time = time();
		dsendf("vp %d\n",fixation);
		spawn SEND_EVT(FixSpotOn_);
		oSetAttribute(object_fix, aVISIBLE);

	while (trl_running)
		{

	//--------------------------------------------------------------------------------------------
	// STAGE test

		if (stage == test)
		{
			while(1)
			{
				dsendf("vp %d\n",fixation_pd);
				while (!pdIsOn) {spawnwait WAIT_VS();}
				dsendf("vp %d\n",fixation);
				spawn SEND_EVT(FixSpotOn_);

				wait 100;

				dsendf("vp %d\n",target_pd);
				while (!pdIsOn) {spawnwait WAIT_VS();}
				dsendf("vp %d\n",target);
				spawn SEND_EVT(Target_);

				wait 100;

			}
		}
	//--------------------------------------------------------------------------------------------
	// STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
		if (stage == need_fix)
			{
			if (In_FixWin)													// If the eyes have entered the fixation window (before time, see below)...
				{
				aquire_fix_time = time();									// ...function call to time to note current time and...
				Trl_Start_Time = aquire_fix_time;							// Global output
				spawn SEND_EVT(Fixate_);
				stage = fixating;											// ...advance to the next stage.
				}
			else if (time() > fix_spot_time + allowed_fix_time)				// But if time runs out...
				{
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen,...
				Trl_Outcome = no_fix;    									// TRIAL OUTCOME ERROR (no fixation)
				LastStopOutcome = no_change;								// Don't change SSD
				spawn SEND_EVT(FixError_);
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Trial Outcome: Aborted (no fixation)\n");							// ...tell the user whats up...
				trl_running = 0;											// ...and terminate the trial.
				}
			}



	//--------------------------------------------------------------------------------------------
	// STAGE fixating (the subject is looking at the fixation point waiting for target onset)
		else if (stage == fixating)
			{
			if (!In_FixWin)													// If the eyes stray out of the fixation window...
				{
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
				LastStopOutcome = no_change;								// Don't change SSD
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Trial Outcome: Aborted (broke fixation)\n");						// ...tell the user whats up...
				spawn SEND_EVT(FixError_);
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)	// But if the eyes are still in the window at end of holdtime...
				{
				dsendf("vp %d\n",target_pd);								// ...flip the pg to the target with pd marker...
				while (!pdIsOn && trl_running) 
				{
				if (!In_FixWin)
					{
							Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
							LastStopOutcome = no_change;								// Don't change SSD
							dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
							oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
							oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
							printf("Trial Outcome: Aborted (broke fixation)\n");						// ...tell the user whats up...
							spawn SEND_EVT(FixError_);
							trl_running = 0;											// ...and terminate the trial.
							
						}	
					nexttick;
					}
				targ_time = time();
				spawn SEND_EVT(Target_);									// ...flip the pg to the target without pd marker.
				dsendf("vp %d\n",target);
				
				spawn SEND_EVT(FixSpotOff_);									// ...flip the pg to the target without pd marker.
				if (trl_type == go_trl)										// If the trial is a go trial...
					{
					oSetAttribute(object_targ, aVISIBLE); 					// ...show target in animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph.
					}
				else if (trl_type == ignore_trl)							// But if the trial is an ignore trial
					{
					oSetAttribute(object_targ, aVISIBLE); 					// ...just show target in animated graph (fixation point stays on).
					}														// If it is a stop trial the target just never comes up in the animated graph.
					
				else if (trl_type == stop_trl ||									// If it is a stop or ignore trial present the signal.
					trl_type == ignore_trl)										// This happens here so that no overhead intervenes between commands.
					{														// That way the # of vertical retraces remains independant of incidental processing time.

					printf("Target time = %d\n",targ_time);														// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)

					dsendf("vw %d\n",curr_ssd-1);					// Wait so many vertical retraces (one is waited implicitly b/c photodiode marker above)...
					tempTime = time();
					printf("time after target before signal_pd = %d\n",tempTime);														// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)
					dsendf("vp %d\n",signal_pd);							// ...flip the pg to the signal with the pd marker...
					
				while (!pdIsOn && trl_running)
						{
						if (!In_FixWin)
							{
								Trl_Outcome = broke_fix;									// TRIAL OUTCOME ERROR (broke fixation)
								LastStopOutcome = no_change;								// Don't change SSD
								dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
								oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
								oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
								printf("Trial Outcome: Aborted (broke fixation)\n");						// ...tell the user whats up...
								spawn SEND_EVT(FixError_);
								trl_running = 0;											// ...and terminate the trial.

							}
						spawn WAIT_VS();
						}
					tempTime = time();
					printf("time after target after signal_pd = %d\n",tempTime);														// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)
					printf("ssd in # refresh = %d\n",curr_ssd);														// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)

					spawn SEND_EVT(StopSignal_);

					stop_sig_time = targ_time + 
						(round(curr_ssd * (1000.0 / Refresh_rate))); 		// ...record TEMPO time of presentation...
					printf("stop_sig_time = %d\n",stop_sig_time);														// (Even so, sometimes we will accidentally wait n+1 retraces. Such is vdosync.)
						
					dsendf("vp %d\n",signal);								// ...and flip the pg to the signal without pd marker.
					}

				stage = targ_on;											// Advance to the next trial stage.
				}
			}



	//--------------------------------------------------------------------------------------------
	// STAGE targ_on (the target has been presented but the subject is still fixating)
		else if (stage == targ_on)
			{
			if (!In_FixWin)													// If the eyes leave the fixation window...
				{															// ...we have a saccade, so...
				saccade_time = time();										// ...record the time...
				spawn SEND_EVT(Saccade_);
				printf("     Reaction Time = %d\n",saccade_time - targ_time);	// ...tell the user whats up...
				stage = in_flight;											// ...and advance to the next stage.


				if (saccade_time - targ_time < Min_saccade_time)
					{
					Trl_Outcome = too_fast; 								// TRIAL OUTCOME TOO FAST (too fast while being trained to slow down)
					LastStopOutcome = no_change;							// Don't change SSD
					dsendf("vp %d\n",blank);								// Flip the pg to the blank screen...
					oSetAttribute(object_targ, aINVISIBLE); 				// ...remove target from animated graph...
					oSetAttribute(object_fix, aINVISIBLE); 					// ...remove fixation point from animated graph...
					printf("Trial Outcome: Error (too fast)\n");							// ...tell the user whats up...
					trl_running = 0;										// ...and terminate the trial.
					}
				}
			else if (In_FixWin &&  											// But if no saccade occurs...
				time() > targ_time + max_saccade_time && 					// ...and time for a saccade runs out...
				(trl_type == go_trl || trl_type == ignore_trl))				// ...and a saccade was supposed to be made.
				{
				Trl_Outcome = go_wrong;           							// TRIAL OUTCOME ERROR (incorrect go trial)
				LastStopOutcome = no_change;								// Don't change SSD
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Trial Outcome: Error (no saccade)\n");								// ...tell the user whats up...
				// spawn SVR_BELL();
				spawn TONE(failure_tone,tone_duration);   					// Amir: I want to train Jo with the same failure tone, regardless of how he failed.
				trl_running = 0;											// ...and terminate the trial.
				}
			else if (In_FixWin &&											// But if no saccade occurs...
				time() > targ_time + curr_ssd + cancl_time && 				// ...and time for a saccade runs out...
				trl_type == stop_trl)										// ...and a saccade was NOT supposed to be made...
				{
				Trl_Outcome = nogo_correct;   								// TRIAL OUTCOME CORRECT (canceled trial)
				LastStopOutcome = success;									// set the global for staircasing...
				Correct_trls = Correct_trls + 1;							// ...set a global for 1DR...
				dsendf("vp %d\n",blank);									// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				spawn SEND_EVT(Correct_);
				printf("Trial Outcome: Correct (canceled)\n");				// ...tell the user whats up...

				canceled_trl_count = canceled_trl_count + 1;

				if (Canc_alert)
					{
					spawn SVR_BEL2();										// for training purposes
					}
				trl_running = 0;  											// ...and terminate the trial.
				}
			}



	//--------------------------------------------------------------------------------------------
	// STAGE in_flight (eyes have left fixation window but have not entered target window)
		else if (stage == in_flight)
			{
			if (In_TargWin)													// If the eyes get into the target window...
				{
				aquire_targ_time = time();									// ...record the time...
				spawn SEND_EVT(Decide_);
				stage = on_target;											// ...and advance to the next stage of the trial.
				if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
					{
					spawn SEND_EVT(Error_sacc);
					
					dsendf("vp %d\n",target_pd);								// ...flip the pg to the target with pd marker...
				while (!pdIsOn && trl_running)
						{
						if (!In_TargWin)
							{
							brokeTargTime = time();
							Trl_Outcome = broke_targ;									// TRIAL OUTCOME ERROR (broke target fixation)
							if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
								{
								LastStopOutcome = failure;
								}
							else 														// Otherwise...
								{
								LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.
								}

								stage = return_fix_check;
							}

						spawnwait WAIT_VS();
						}

					dsendf("vp %d\n",target);								// ...flip the pg to the target with pd marker...
					}
				else 														// Otherwise...
					{
					spawn SEND_EVT(Correct_);
					}
				}
			else if (time() > saccade_time + max_sacc_duration)				// But, if the eyes are out of the target window and time runs out...
				{
				Trl_Outcome = sacc_out;   									// TRIAL OUTCOME ERROR (innacurrate saccade)
				if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
					{
					LastStopOutcome = failure;								// ...record the failure.
					}
				else 														// Otherwise...
					{
					LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.
					}
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				printf("Trial Outcome: Error (inaccurate saccade)\n");						// ...tell the user whats up...
				trl_running = 0; 											// ...and terminate the trial.
				}
			}



	//--------------------------------------------------------------------------------------------
	// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)
		else if (stage == on_target)
			{
			if (!In_TargWin)												// If the eyes left the target window...
				{
				brokeTargTime = time();
				Trl_Outcome = broke_targ;									// TRIAL OUTCOME ERROR (broke target fixation)
				if (trl_type == stop_trl)									// But if a saccade was the wrong thing to do...
					{
					LastStopOutcome = failure;
					}
				else 														// Otherwise...
					{
					LastStopOutcome = no_change;							// ...make sure that the last outcome is cleared.
					}

				stage = return_fix_check;
				}
			else if (In_TargWin  											// But if the eyes are still in the target window...
				&&  time() > aquire_targ_time + targ_hold_time)				// ...and the target hold time is up...
				{
				if (trl_type == go_trl || trl_type == ignore_trl)			// ...and a saccade was the correct thing to do...
					{
					Trl_Outcome = go_correct;								//TRIAL OUTCOME CORRECT (correct go trial)
					LastStopOutcome = no_change;							// Don't change SSD
					Correct_trls = Correct_trls + 1;						// ...set a global for 1DR...
					spawn SEND_EVT(Correct_);
					printf("Trial Outcome: Correct (saccade)\n");							// ...tell the user whats up...
					nostop_trl_count = nostop_trl_count + 1;

					}
				else if (trl_type == stop_trl)								// But if a saccade was the wrong thing to do...
					{
					Trl_Outcome = nogo_wrong;								//TRIAL OUTCOME ERROR (noncanceled trial)
					LastStopOutcome = failure;
					printf("Trial Outcome: Error (noncanceled)\n");					// ...tell the user whats up...
					noncanceled_trl_count = noncanceled_trl_count + 1;
					}														// Either way we are done, so...
				dsendf("vp %d\n",blank);		                 			// ...flip the pg to the blank screen...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				trl_running = 0;											// ...and terminate the trial.
				}
			}

		else if (stage == return_fix_check)
		{
			if (In_FixWin && time() < max_sacc_duration + brokeTargTime)
			{
				spawn SEND_EVT(ReturnToFix_);
				Trl_Outcome = returnTofix;								//TRIAL OUTCOME ERROR (noncanceled trial)
				printf("Trial Outcome: Error (Return to Fixation)\n");						// ...tell the user whats up...
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				trl_running = 0;
			}

			else if (time() > max_sacc_duration + brokeTargTime)
			{
				Trl_Outcome = broke_targ;								//TRIAL OUTCOME ERROR (noncanceled trial)	
				oSetAttribute(object_targ, aINVISIBLE); 					// ...remove target from animated graph...
				oSetAttribute(object_fix, aINVISIBLE); 						// ...remove fixation point from animated graph...
				dsendf("vp %d\n",blank);									// Flip the pg to the blank screen...
				trl_running = 0;
				
				spawn SEND_EVT(BreakTFix_);
				printf("Trial Outcome: Error (broke target fixation)\n");					// ...tell the user whats up...
			}
		}

		if (Move_ct > 0)
			{
			Trl_Outcome = body_move;   										// TRIAL OUTCOME ABORTED (the body was moving)
			LastStopOutcome = no_change;									// ...make sure that the last outcome is cleared.
			dsendf("vp %d\n",blank);										// Flip the pg to the blank screen...
			oSetAttribute(object_targ, aINVISIBLE); 						// ...remove target from animated graph...
			oSetAttribute(object_fix, aINVISIBLE); 							// ...remove fixation point from animated graph...
			printf("Trial Outcome: Aborted (body movement)\n");							// ...tell the user whats up...
			trl_running = 0; 												// ...and terminate the trial.
			}

		nexttick;
		}


	}