//Modified by Namsoo 5/23/2012

declare DELAYED();						

process DELAYED()     
	{
	declare hide int run_delayed_sess = 6;
	declare hide int run_idle		= 0;
			
	Trl_number				= 1;
	Block_number			= 1;
	LastStopOutcome			= 2;				// This is a kluge which tells END_TRIAL.pro that no change in stop signal has occurred
	Comp_Trl_number			= 0;
	
	if (Last_task != run_delayed_sess)				// Only do this if we have gone into another task or if this is first run of day.
		{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,					// subject 0 is just default values.  no monkey
						Room);			
		Last_task = run_delayed_sess;
		}
		
	dsend("DM RFRSH");         					// This code sets up a vdosync macro definition to wait a specified ...
	if (Room == 23)            					// ...number of vertical retraces based on the room in which we are    ...
		{                      					// ...recording.  This kluge is necessary because vdosync operates     ...
		dsendf("vw %d:\n",1);  					// ...differently in the different rooms.  In 028 a command to wait    ...
		}                      					// ...2 refresh cycles usually only waits for one and a command to     ...
	else                       					// ...wait for 1 usually only waits for 0.  Room 029 and 023 appear to ...
		{                      					// ...work properly.
		dsendf("vw %d:\n",2);					
		}
	dsend("EM RFRSH");
	
	while(!OK)									
		{
		nexttick;
		if(Set_monkey)
			{
			spawnwait DEFAULT(State,			// Set all globals to their default values based on the monkey.
						Monkey,					
						Room);	
			Set_monkey = 0;
			}
		}
	
	spawnwait GOODVARS(State);


	spawnwait SET_CLRS(n_targ_pos);
	
	spawnwait SETD_TRL(n_targ_pos,				// Select variables for the first mem guided...					
				min_holdtime,           		// ...trial.  This happens once outside of the while...
				max_holdtime,           		// ...loop just to set up for the first iteration. After...
				expo_jitter,            		// ...that SETM_TRL.pro will be called by END_TRL.pro.
				min_soa,
				max_soa,
				expo_jitter_soa);
				

	Event_fifo[Set_event] = DelayedHeader_;			// Set a strobe to identify this file as a mem guided session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = Identify_Room_;		// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = Room;				// Set a strobe to identify this file as a Cmanding session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	Event_fifo[Set_event] = min_soa;			// Set a strobe to identify Min_soa		<- added by Namsoo
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = max_soa;			// Set a strobe to identify Max_soa
	Set_event = (Set_event + 1) % Event_fifo_N; //...incriment event queue.
	
	nexttick 10;								// to prevent buffer overflows after task reentry.
	
	CheckMotion = 1;							// set global for watching the motion detector
	spawn WATCHMTH;								// start watching the mouth motion detector if present
	spawn WATCHBOD;								// start watching motion detector for body if present
	
	while (State == run_delayed_sess)				// while the user has not yet terminated the mem guided task
		{
		

		spawnwait DELTRIAL(allowed_fix_time,	// run a trial with variables defined by SETM_TRL.pro
				curr_holdtime,
				curr_soa,			
				max_saccade_time, 		
				max_sacc_duration, 		
				targ_hold_time,			
				object_fix);			
		
		
		spawnwait END_TRL(trl_outcome);			// end a trial with trl_outcome set in MEMTRIAL.pro
				
		nexttick;								// wait at least one cycle and do it all again
		
		while(Pause)							// gives the user the ability to pause the task without ending it
			{
			nexttick;
			}
		
		}

												// the State global variables allow a control structure...
												// ...to impliment the task.
	State = run_idle;							// If we are out of the while loop the user wanted...
												// ...to stop mem guided.
	//CheckMotion = 0;							// stop watching for movement.
												
	oDestroy(object_fixwin);					// destroy all task graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);
	
	oSetGraph(gleft,aCLEAR);					// clear the left graph
	
		
	spawn IDLE;									// return control to IDLE.pro
    
	}