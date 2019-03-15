//--------------------------------------------------------------------------------------------------
// This is the main CMANDING protocol.  It works like this.
// 1) Define all varialbes
// 2) Setup random variables needed for a trial
// start loop
// 3) Run a trial
// 4) End the trial
// 		a) deliver rewards and punishments
//		b) take care of ITI
// 		c) set up variables for next run
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare CMANDING();

process CMANDING()
	{
	declare hide int run_cmd_sess	= 1;
	declare hide int run_idle		= 0;

	Trl_number				= 1;
	Comp_Trl_number			= 0;
	Block_number			= 1;
	if (Last_task != run_cmd_sess)				// Only do this if we have gone into another task or if this is first run of day.
		{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,
						Room);
		Last_task = run_cmd_sess;
		}

	dsend("DM RFRSH");                			// This code sets up a vdosync macro definition to wait a specified ...
	if (Room == 23)                   			// ...number of vertical retraces based on the room in which we are    ...
		{                             			// ...recording.  This kluge is necessary because vdosync operates     ...
		dsendf("vw %d:\n",1);         			// ...differently in the different rooms.  In 028 a command to wait    ...
		}                             			// ...2 refresh cycles usually only waits for one and a command to     ...
	else                              			// ...wait for 1 usually only waits for 0.  Room 029 and 023 appear to ...
		{                             			// ...work properly.
		dsendf("vw %d:\n",2);
		}
	dsend("EM RFRSH");

	while(!OK)
		{
		nexttick;
		if(Set_monkey)
			{
			spawnwait DEFAULT(State,			// Set all globals to their default values for a particular monkey.
						Monkey,
						Room);
			Set_monkey = 0;
			}
		}

	spawnwait GOODVARS(State);

	spawnwait SET_INH(max_ssd, 					// Set up the right graph for INH f(x).
					min_ssd,
					n_ssds);

	spawnwait SET_CLRS(n_targ_pos);

	spawnwait SETC_TRL(n_targ_pos,				// Select variables for the first countermanding...
				go_weight,						// ...trial.  This happens once outside of the while...
				stop_weight,					// ...loop just to set up for the first iteration. After...
				ignore_weight,					// ...that SETC_TRL.pro will be called by END_TRL.pro.
				staircase,
				n_SSDs,
				min_holdtime,
        max_holdtime,
				expo_jitter);

	spawn SEND_EVT(SessionStart_);
	spawn SEND_EVT(EVT_IDENTIFY_ROOM_);
	spawn SEND_EVT(Room);

	nexttick 10;								// to prevent buffer overflows after task reentry.

	CheckMotion = 1;							// set global for watching the motion detector
	spawn WATCHMTH;								// start watching the mouth motion detector if present
	spawn WATCHBOD;								// start watching motion detector for body if present
	while (State == run_cmd_sess)				// while the user has not yet terminated the countermanding task
		{

		 spawnwait CMDTRIAL(allowed_fix_time, 	// run a trial with variables defined in SETC_TRL.pro
							curr_holdtime,
							trl_type,
							max_saccade_time,
							curr_ssd,
							cancl_time,
							max_sacc_duration,
							targ_hold_time,
							object_fix);

		spawnwait END_TRL(trl_outcome);			// end a trial with trl_outcome set in CMDTRIAL.pro



		while(Pause)							// gives the user the ability to pause the task without ending it
			{
			nexttick;
			}

		}

												// the State global variables allow a control structure...
												// ...to impliment the task.
	State = run_idle;							// If we are out of the while loop the user wanted...
												// ...to stop cmanding.
	CheckMotion = 0;							// stop watching for motion detector.

	oDestroy(object_fixwin);					// destroy all task graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);

	oSetGraph(gleft,aCLEAR);					// clear the left graph

	oDestroy(object_ssd0);						// destroy all inh f(x) graph objects
	oDestroy(object_ssd1);
	oDestroy(object_ssd2);
	oDestroy(object_ssd3);
	oDestroy(object_ssd4);
	oDestroy(object_ssd5);
	oDestroy(object_ssd6);
	oDestroy(object_ssd7);
	oDestroy(object_ssd8);
	oDestroy(object_ssd9);
	oDestroy(object_ssd10);
	oDestroy(object_ssd11);
	oDestroy(object_ssd12);
	oDestroy(object_ssd13);
	oDestroy(object_ssd14);
	oDestroy(object_ssd15);
	oDestroy(object_ssd16);
	oDestroy(object_ssd17);
	oDestroy(object_ssd18);
	oDestroy(object_ssd19);
	oDestroy(object_30_70);

	oSetGraph(gleft,aCLEAR);					// clear the left graph

	spawn IDLE;									// return control to IDLE.pro

	}
