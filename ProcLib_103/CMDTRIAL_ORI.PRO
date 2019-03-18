// CMDTRIAL.PRO
//
// DESCRIPTION:
// Run a countermanding trial based on the variables calculated by SETC_TRL.PRO
// and those given by the user.
//
// EDIT HISTORY:
// Initial written by david.c.godlove@vanderbilt.edu    January, 2011
//
// 2018 OCT - chenchal.subraveti@vanderbilt.edu
//      Refactored code lines for sending event code and updating array index into its own process and replaced
//      those lines with a spawn call to the new process.
//      new process: SEND_EVT - See SEND_EVT.PRO
// 2018 OCT 15 - chenchal.subraveti@vanderbilt.edu
//      Refactored repeatedly called lines of code into processes and replaced with spawnwait call to these processes.
//		  Formatted code flow. Removed "hide" keyword as no longer useful. New processes in this file are:
//          USER_INFO : Show user trial progress information
//          SHOW_BLANK_UPD8_GRF : Flip to blank page on VIDEOSYNC and updated the graph object on TEMPO screen
//
// 2018 DEC 15 - chenchal.subraveti@vanderbilt.edu
//      Added TRACE_FLOW to debug different STAGES of task evolution
//      Trial information is written to an output file for debugging in USER_INFO routine
//

declare int traceTime;
declare int Trl_Outcome;
declare int Trl_Start_Time;
// Global output used to staircase SSD
declare int LastStopOutcome = 1;

// Number the trial types to make them easier to read below
declare int go_trl = 0;
declare int stop_trl = 1;
declare int ignore_trl = 2;

// Updare information for the user
declare USER_INFO(curr_holdtime,
                  trl_type,
                  curr_holdtime,
                  curr_ssd,
				  nostop_trl_count,
				  canceled_trl_count,
				  noncanceled_trl_count,
				  float saccade_time,
				  float targ_time);

declare TRACE_FLOW(trl_type,
                   traceNum);

// Show blank screen and updated the animated graph
declare SHOW_BLANK_UPD8_GRF();

// see ALL_VARS.PRO, DEFAULT.PRO, SETC_TRL.PRO
// animated graph object
declare CMDTRIAL(allowed_fix_time,
                 curr_holdtime,
                 trl_type,
                 max_saccade_time,
                 curr_ssd,
                 cancl_time,
                 max_sacc_duration,
                 targ_hold_time,
                 object_fix);

process CMDTRIAL(allowed_fix_time,
                 curr_holdtime,
                 trl_type,
                 max_saccade_time,
                 curr_ssd,
                 cancl_time,
                 max_sacc_duration,
                 targ_hold_time,
                 object_fix)
{
	declare int requested_wait_time;

	// Number the trial stages to make them easier to read below
	declare int need_fix = 1;
	declare int fixating = 2;
	declare int targ_on = 3;
	declare int in_flight = 4;
	declare int on_target = 5;
	declare int return_fix_check = 6;
	declare int stage;
	declare int test = 10;

	// Number the stimuli pages to make reading easier
	declare int blank = 0;
	declare int fixation_pd = 1;
	declare int fixation = 2;
	declare int target_pd = 3;
	declare int target = 4;
	declare int signal_pd = 5;
	declare int signal = 6;

	// Assign values to success and failure so they are more readable
	declare int success = 1;
	declare int failure = 0;
	declare int no_change = 2;

	// Code all possible outcomes
	declare int constant no_fix = 1; // never attained fixation
	declare int constant broke_fix = 2; // attained and then lost fixation before target presentation
	declare int constant go_wrong = 3; // never made saccade on a go trial
	declare int constant nogo_correct = 4; // successfully canceled trial
	declare int constant sacc_out = 5; // made an inaccurate saccade out of the target box
	declare int constant broke_targ = 6; // didn't hold fixation at the target for long enough
	declare int constant go_correct = 7; // correct saccade on a go trial
	declare int constant nogo_wrong = 8; // error noncanceled trial
	declare int constant body_move = 12; // error body movement (for training stillness)
	declare int constant too_fast = 14; // low RT while in training to slow down.
	declare int constant returnTofix = 16; // Eventually found the target but not on first saccade

	// Timing variables which will be used to time task
	declare float fix_spot_time;
	declare float targ_time;
	declare float saccade_time;
	declare float aquire_fix_time;
	declare float brokeTargTime;
	declare float stop_sig_time;
	declare float aquire_targ_time;
	declare int noncanceled_trl_count;
	declare int canceled_trl_count;
	declare int nostop_trl_count;

	// This variable makes the while loop work
	declare int trl_running;
	declare int wait_n_screen_refresh;

	// Have to be reset on every iteration since
	// variable declaration only occurs at load time
	trl_running = 1;
	stage = need_fix;
	traceTime = 0;
	
	spawn SEND_EVT(EVT_CMAN_HEADER_);
	spawn SEND_EVT(EVT_TRIAL_START_);
	// Show fixation with white boxes for photocell
	dsendf("vp %d\n", fixation_pd);
	while (!PD_TRIG_L)
	{
		nexttick;
	}
	fix_spot_time = time();
	dsendf("vp %d\n", fixation);
	spawn SEND_EVT(EVT_FIX_SPOT_ON_);
	oSetAttribute(object_fix, aVISIBLE);

	while (trl_running)
	{
		//----------------------------STAGE = test = 10-----------------------------------------------
		// STAGE test
		if (stage == test)
		{
			spawn TRACE_FLOW(trl_type,1);
			while (1)
			{
			  spawn TRACE_FLOW(trl_type,2);
			  dsendf("vp %d\n", fixation_pd);
				while (!PD_TRIG_L)
				{
					nexttick;
				}
				dsendf("vp %d\n", fixation);
				spawn SEND_EVT(EVT_FIX_SPOT_ON_);
				wait 100;
			}
		}
		//----------------------------STAGE = need_fix = 1--------------------------------------------
		// STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
		if (stage == need_fix)
		{
			// If the eyes have entered the fixation window (before time, see below)...
			if (In_FixWin)
			{
				spawn TRACE_FLOW(trl_type,3);
				// ...function call to time to note current time and...
				aquire_fix_time = time();
				Trl_Start_Time = aquire_fix_time;
				spawn SEND_EVT(EVT_FIXATE_);
				// ...advance to the next stage.
				stage = fixating;
			}
			// But if time runs out...
			else if (time() > fix_spot_time + allowed_fix_time)
			{
				spawn TRACE_FLOW(trl_type,4);
				spawn SHOW_BLANK_UPD8_GRF();
				// TRIAL OUTCOME ERROR (no fixation)
				Trl_Outcome = no_fix;
				// Don't change SSD
				LastStopOutcome = no_change;
				spawn SEND_EVT(FixError_);
				// ...tell the user whats up
				printf("Trial Outcome: Aborted (no fixation) [%d,%d]\n",Trl_number,Trl_Outcome);
				// ...and terminate the trial.
				trl_running = 0;
			}
		}
		//----------------------------STAGE = fixating = 2--------------------------------------------
		// STAGE fixating (the subject is looking at the fixation point waiting for target onset)
		else if (stage == fixating)
		{
			// If the eyes stray out of the fixation window...
			if (!In_FixWin)
			{
				spawn TRACE_FLOW(trl_type,5);
				spawn SHOW_BLANK_UPD8_GRF();
				// flip the pg to the fixation stim without pd marker
				// dsendf("vw %d\n", 1);
				// TRIAL OUTCOME ERROR (broke fixation)
				Trl_Outcome = broke_fix;
				// Don't change SSD
				LastStopOutcome = no_change;
				spawn SEND_EVT(FixError_);
				// ...tell the user whats up...
				printf("Trial Outcome: Aborted (broke fixation) [%d,%d]\n",Trl_number,Trl_Outcome);
				// ...and terminate the trial.
				trl_running = 0;
			}
			// But if the eyes are still in the window at end of holdtime...
			else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)
			{
				spawn TRACE_FLOW(trl_type,6);
				// ...flip the pg to the target with pd marker...
				dsendf("vp %d\n", target_pd);
				while (!PD_TRIG_L && trl_running)
				{
					if (!In_FixWin)
					{
						spawn SHOW_BLANK_UPD8_GRF();
						// TRIAL OUTCOME ERROR (broke fixation)
						Trl_Outcome = broke_fix;
						// Don't change SSD
						LastStopOutcome = no_change;
						spawn SEND_EVT(FixError_);
						// ...tell the user whats up...
						printf("Trial Outcome: Aborted (broke fixation) [%d,%d]\n",Trl_number,Trl_Outcome);
						// ...and terminate the trial.
						trl_running = 0;
					}
					nexttick;
				}
				spawn TRACE_FLOW(trl_type,7);
				targ_time = time();
				// ...record the time...Refresh#=1
				dsendf("vp %d\n", target);
				// ...flip the pg to the target without pd marker.
				spawn SEND_EVT(EVT_TARGET_);
				spawn SEND_EVT(EVT_FIX_SPOT_OFF_);
				// If the trial is a go trial...
				if (trl_type == go_trl)
				{
					spawn TRACE_FLOW(trl_type,8);
					// ...show target in animated graph...
					oSetAttribute(object_targ, aVISIBLE);
					// ...remove fixation point from animated graph.
					oSetAttribute(object_fix, aINVISIBLE);
				}
				// But if the trial is an ignore trial
				else if (trl_type == ignore_trl)
				{
					spawn TRACE_FLOW(trl_type,9);
					// ...just show target in animated graph
					// (fixation point stays on).
					oSetAttribute(object_targ, aVISIBLE);
				}
				// *****??If it is a stop trial the target just never comes up in the animated graph.
				// If it is a stop or ignore trial present the signal.
				else if (trl_type == stop_trl || trl_type == ignore_trl)
				// intervenes between commands.
				{
					spawn TRACE_FLOW(trl_type,10);
					// This happens here so that no overhead
					// That way the # of vertical retraces remains independant of
					// incidental processing time. (Even so, sometimes we will
					// accidentally wait n+1 retraces. Such is vdosync.)
					// dsendf("vw %d\n",curr_ssd-1);	// Wait so many vertical retraces
					// (one is waited implicitly b/c photodiode marker above)...
					//*******************  Doing a Wait *********************
					wait_n_screen_refresh = curr_ssd - 2;
					if (wait_n_screen_refresh < 1)
					{
						wait_n_screen_refresh = 1;
					}
					printf("#273- CMDTRIAL - ProcLib-010 - Doing\n  while <-> nexttick\n");
					requested_wait_time = round(wait_n_screen_refresh * (1000.0 / Refresh_rate));
					printf("requested_wait_time  = %d\n", requested_wait_time);
					while (time() < targ_time + requested_wait_time)
					{
						nexttick;
					}
					spawn TRACE_FLOW(trl_type,11);
					//*******************  Done a wait *********************
					// ...flip the pg to the signal with the pd marker...
					dsendf("vp %d\n", signal_pd);

					while (!PD_TRIG_L && trl_running)
					{
						if (!In_FixWin) {
							// TRIAL OUTCOME ERROR (broke fixation)
							Trl_Outcome = broke_fix;
							// Don't change SSD
							LastStopOutcome = no_change;
							spawn SEND_EVT(FixError_);
							spawn SHOW_BLANK_UPD8_GRF();
							// ...tell the user whats up...
							printf("#267 = #294 - Trial Outcome: Aborted (broke fixation)- trl_outcome %d\n", Trl_Outcome);
							// ...and terminate the trial.
							trl_running = 0;
						}
						nexttick;
					}
					spawn TRACE_FLOW(trl_type,12);
					spawn SEND_EVT(EVT_STOP_SIGNAL_);
					new_curr_ssd = time() - targ_time;
					// ...and flip the pg to the signal without pd marker.
					dsendf("vp %d\n", signal);
				}
				// Advance to the next trial stage.
				stage = targ_on;
			}
		}
		//----------------------------STAGE = targ_on = 3---------------------------------------------
		// STAGE targ_on (the target has been presented but the subject is still fixating)
		else if (stage == targ_on)
		{
			// If the eyes leave the fixation window...
			if (!In_FixWin)
			{
				spawn TRACE_FLOW(trl_type,13);
				// ...we have a saccade, so, record the time...
				saccade_time = time();
				spawn SEND_EVT(EVT_SACCADE_);
				// ...tell the user whats up...
				printf("     Reaction Time = %d\n", saccade_time - targ_time);
				// ...and advance to the next stage.
				stage = in_flight;
				// If TRIAL OUTCOME TOO FAST (too fast while
				// being trained to slow down)
				if (saccade_time - targ_time < Min_saccade_time)
				{
					spawn TRACE_FLOW(trl_type,14);
					Trl_Outcome = too_fast;
					// Don't change SSD
					LastStopOutcome = no_change;
					spawn SHOW_BLANK_UPD8_GRF();
					// ...tell the user whats up...
					printf("Trial Outcome: Error (too fast) [%d,%d]\n", Trl_number,Trl_Outcome);
					// ...and terminate the trial.
					trl_running = 0;
				}
			}
			// But if no saccade occurs...and time for a saccade runs out...
			// ...and a saccade was supposed to be made.
			else if (In_FixWin && time() > targ_time + max_saccade_time && (trl_type == go_trl || trl_type == ignore_trl))
			{
				spawn TRACE_FLOW(trl_type,15);
				spawn SHOW_BLANK_UPD8_GRF();
				// TRIAL OUTCOME ERROR (incorrect go trial)
				Trl_Outcome = go_wrong;
				// Don't change SSD
				LastStopOutcome = no_change;
				// spawn SVR_BELL();
				// Amir: I want to train Jo with the same
				// failure tone, regardless of how he failed.
				spawn TONE(failure_tone, tone_duration);
				// ...tell the user whats up...
				printf("Trial Outcome: Error (no saccade) [%d,%d]\n", Trl_number,Trl_Outcome);
				// ...and terminate the trial.
				trl_running = 0;
			}
			// But if no saccade occurs...and time for a saccade runs out...
			// ...and a saccade was NOT supposed to be made...
			else if (In_FixWin &&  time() > targ_time + curr_ssd + cancl_time &&  trl_type == stop_trl)
			{
				spawn TRACE_FLOW(trl_type,16);
				spawn SHOW_BLANK_UPD8_GRF();
				// TRIAL OUTCOME CORRECT (canceled trial)
				Trl_Outcome = nogo_correct;
				// set the global for staircasing...
				LastStopOutcome = success;
				// ...set a global for 1DR...
				Correct_trls = Correct_trls + 1;
				spawn SEND_EVT(Correct_);
				// ...tell the user whats up...
				printf("Trial Outcome: Correct (canceled) [%d,%d]\n", Trl_number,Trl_Outcome);
				canceled_trl_count = canceled_trl_count + 1;
				if (Canc_alert) {
					spawn TRACE_FLOW(trl_type,17);
					// for training purposes
					spawn SVR_BEL2();
				}
				// ...and terminate the trial.
				trl_running = 0;
			}
		}
		//----------------------------STAGE = in_flight = 4-------------------------------------------
		// STAGE in_flight (eyes have left fixation window but have not entered target window)
		else if (stage == in_flight)
		{
			// If the eyes get into the target window...
			if (In_TargWin)
			{
				spawn TRACE_FLOW(trl_type,18);
				// ...record the time...
				aquire_targ_time = time();
				spawn SEND_EVT(EVT_DECIDE_);
				// ...and advance to the next stage of the trial.
				stage = on_target;
				// But if a saccade was the wrong thing to do...
				if (trl_type == stop_trl)
				{
					spawn TRACE_FLOW(trl_type,19);
					// ...flip the pg to the target with pd marker...
					dsendf("vp %d\n", target_pd);
					spawn SEND_EVT(Error_sacc);
					while (!PD_TRIG_L && trl_running)
					{
						if (!In_TargWin)
						{
							spawn TRACE_FLOW(trl_type,20);
							brokeTargTime = time();
							// TRIAL OUTCOME ERROR (broke target fixation)
							Trl_Outcome = broke_targ;
							// ...tell the user whats up...
							printf("Trial Outcome: Error (broke target fixation) [%d,%d]\n", Trl_number,Trl_Outcome);

							// But if a saccade was the wrong thing to do...
							if (trl_type == stop_trl)
							{
								spawn TRACE_FLOW(trl_type,21);
								LastStopOutcome = failure;
							}
							else
							{
								spawn TRACE_FLOW(trl_type,22);
								// ...make sure that the last outcome is cleared.
								LastStopOutcome =  no_change;
							}
							stage = return_fix_check;
						}
						nexttick;
					}
					spawn TRACE_FLOW(trl_type,23);
					// ...flip the pg to the target with NO-pd marker...
					dsendf("vp %d\n", target);
				}
				else
				{
					spawn TRACE_FLOW(trl_type,24);
					spawn SEND_EVT(Correct_);
				}
			}
			// But, if the eyes are out of the
			// target window and time runs out...
			else if (time() > saccade_time + max_sacc_duration)
			{
				spawn TRACE_FLOW(trl_type,25);
				// TRIAL OUTCOME ERROR (innacurrate saccade)
				Trl_Outcome = sacc_out;
				// But if a saccade was the wrong thing to do...
				if (trl_type == stop_trl)
				{
					spawn TRACE_FLOW(trl_type,26);
					// ...record the failure.
					LastStopOutcome = failure;
				}
				// Otherwise...
				else
				{
					spawn TRACE_FLOW(trl_type,27);
					// ...make sure that the last outcome is cleared.
					LastStopOutcome = no_change;
				}
				spawn SHOW_BLANK_UPD8_GRF();
				// ...tell the user whats up...
				printf("Trial Outcome: Error (inaccurate saccade)[%d,%d]\n", Trl_number,Trl_Outcome);
				// ...and terminate the trial.
				trl_running = 0;
			}
		}
		//----------------------------STAGE = on_target = 5-------------------------------------------
		// STAGE on_target (eyes have entered the target window.  will they remain there for duration?)
		else if (stage == on_target)
		{
			// If the eyes left the target window...
			if (!In_TargWin)
			{
				spawn TRACE_FLOW(trl_type,28);
				brokeTargTime = time();
				// TRIAL OUTCOME ERROR (broke target fixation)
				Trl_Outcome = broke_targ;
				// But if a saccade was the wrong thing to do...
				if (trl_type == stop_trl)
				{
					spawn TRACE_FLOW(trl_type,29);
					LastStopOutcome = failure;
				}
				// Otherwise...
				else
				{
					spawn TRACE_FLOW(trl_type,30);
					// ...make sure that the last outcome is cleared.
					LastStopOutcome = no_change;
				}
				stage = return_fix_check;
			}
			// But if the eyes are still in the target window...
			// ...and the target hold time is up...
			else if (In_TargWin  && time() > aquire_targ_time + targ_hold_time)
			{
				spawn TRACE_FLOW(trl_type,31);
				// ...and a saccade was the correct thing to do...
				if (trl_type == go_trl || trl_type == ignore_trl)
				{
					spawn TRACE_FLOW(trl_type,32);
					// TRIAL OUTCOME CORRECT (correct go trial)
					Trl_Outcome = go_correct;
					// Don't change SSD
					LastStopOutcome = no_change;
					// ...set a global for 1DR...
					Correct_trls = Correct_trls + 1;
					spawn SEND_EVT(Correct_);
					// ...tell the user whats up...
					printf("Trial Outcome: Correct (saccade) [%d,%d]\n", Trl_number,Trl_Outcome);
					nostop_trl_count = nostop_trl_count + 1;
				}
				// But if a saccade was the wrong thing to do...
				else if (trl_type == stop_trl)
				{
					spawn TRACE_FLOW(trl_type,33);
					// TRIAL OUTCOME ERROR (noncanceled trial)
					Trl_Outcome = nogo_wrong;
					LastStopOutcome = failure;
					// ...tell the user whats up...
					printf("Trial Outcome: Error (noncanceled) [%d,%d]\n", Trl_number,Trl_Outcome);
					noncanceled_trl_count = noncanceled_trl_count + 1;
				}
				// Either way we are done, so...
				spawn SHOW_BLANK_UPD8_GRF();
				// ...and terminate the trial.
				trl_running = 0;
			}
		}
		//----------------------------STAGE = return_fix_check = 6------------------------------------
		else if (stage == return_fix_check)
		{
			if (In_FixWin && time() < max_sacc_duration + brokeTargTime)
			{
				spawn TRACE_FLOW(trl_type,34);
				spawn SHOW_BLANK_UPD8_GRF();
				spawn SEND_EVT(ReturnToFix_);
				// TRIAL OUTCOME ERROR (noncanceled trial)
				Trl_Outcome = returnTofix;
				// ...tell the user whats up...
				printf("Trial Outcome: Error (Return to Fixation) [%d,%d]\n", Trl_number,Trl_Outcome);
				trl_running = 0;
			}
			else if (time() > max_sacc_duration + brokeTargTime)
			{
				spawn TRACE_FLOW(trl_type,35);
				// TRIAL OUTCOME ERROR (noncanceled trial)
				Trl_Outcome = broke_targ;
				spawn SHOW_BLANK_UPD8_GRF();
				trl_running = 0;
				spawn SEND_EVT(BreakTFix_);
				// ...tell the user whats up...
				printf("Trial Outcome: Error (broke target fixation) [%d,%d]\n", Trl_number,Trl_Outcome);
			}
		}
		if (Move_ct > 0)
		{
			spawn TRACE_FLOW(trl_type,36);
			// TRIAL OUTCOME ABORTED (the body was moving)
			Trl_Outcome = body_move;
			// ...make sure that the last outcome is cleared.
			LastStopOutcome = no_change;
			spawn SHOW_BLANK_UPD8_GRF();
			printf("Trial Outcome: Aborted (body movement) [%d,%d]\n", Trl_number,Trl_Outcome);
			// ...and terminate the trial.
			trl_running = 0;
		}
		nexttick;
	}
	spawn USER_INFO(curr_holdtime,
                      trl_type,
                      curr_holdtime,
                      curr_ssd,
                      nostop_trl_count,
                      canceled_trl_count,
                      noncanceled_trl_count,
                      saccade_time, targ_time);
	spawn TRACE_FLOW(trl_type,10000);
}
//------------------------------------------SUB-PROCESSES---------------------------------------
process SHOW_BLANK_UPD8_GRF()
{
	declare int blank = 0;
	// Flip the pg to the blank screen...
	dsendf("vp %d\n", blank);
	// ...remove target from animated graph...
	oSetAttribute(object_targ, aINVISIBLE);
	// ...remove fixation point from animated graph...
	oSetAttribute(object_fix, aINVISIBLE);
	// ...tell the user whats up...
}

process TRACE_FLOW(trl_type,traceNum)
{
	declare int relativeTime;
	relativeTime = time() - traceTime;
	traceTime = time();
	writef("trkFlo.csv %d, ", traceNum);
	writef("trkFloTm.csv %d, ", relativeTime);
	if (traceNum == 10000)
	{
	writef("trkFlo.csv |%d|%d\n", Trl_number,trl_type,Trl_Outcome);
	writef("trkFloTm.csv |%d|%d\n", Trl_number,trl_type,Trl_Outcome);
	}
}

process USER_INFO(curr_holdtime,
                  trl_type,
                  curr_holdtime,
                  curr_ssd,
				  nostop_trl_count,
				  canceled_trl_count,
				  noncanceled_trl_count,
				  float saccade_time,
				  float targ_time)
{
	declare float rt;
	rt = saccade_time - targ_time;
	printf(" \n");
	printf(" *********************************\n");
	printf("Block: %d / # %d ", Block_number, Trl_number);
	printf(" (%d", Comp_Trl_number);
	printf("     Reaction Time = %d\n",rt);
	printf(" correct; GO = %d; C = %d; NC = %d)\n", nostop_trl_count, canceled_trl_count, noncanceled_trl_count);

	if (trl_type == go_trl)
	{
		printf("Trial Type: NO-STOP\n");
		printf("Holdtime = %d\n", curr_holdtime);
	}
	else if (trl_type == stop_trl)
	{
		printf("Trial Type: STOP\n");
		printf("Holdtime = %d\n", curr_holdtime);
		printf("curr_ssd in # Screen refreshs = %d\n", curr_ssd);
		printf("curr_ssd computed from SSD_list and Refresh_rate = %d\n",
		       round(curr_ssd * (1000.0 / Refresh_rate)));
		printf("new_curr_ssd from targ_time and pdTriggerTime = %d\n",
		       new_curr_ssd);
	}
	else if (trl_type == ignore_trl)
	{
		printf("Trial Type: IGNORE\n");
		printf("Holdtime = %d\n", curr_holdtime);
		printf("ISD = %d\n",
		       round(curr_ssd * (1000.0 / Refresh_rate)));
		printf("curr_ssd in # Screen refreshs = %d\n", curr_ssd);
		printf("curr_ssd computed from SSD_list and Refresh_rate = %d\n",
		       round(curr_ssd * (1000.0 / Refresh_rate)));
		printf("new_curr_ssd from targ_time and pdTriggerTime    = %d\n",
		       new_curr_ssd);
	}
	//At the end of trial write to file the info...
	// blockNum,TrlNum,trlType,trlOutcome,rt,currSSDScreen,currSSDComputed,newCurrSSD
	writef("SSDTimes.csv %d,%d,%d,%d,%d,%d,%d,%d\n", Block_number, Trl_number, trl_type,Trl_Outcome,rt,curr_ssd, round(curr_ssd * (1000.0 / Refresh_rate)), new_curr_ssd);

}
