//--------------------------------------------------------------------------------------------------
// This is the main countermanding protocol.  It works like this.
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
	
declare VISMAP();						

process VISMAP()     
	{
	declare hide int run_vm_sess	= 8;
	declare hide int run_idle		= 0;
	declare hide int minStims 		= 5;
	declare hide int stimRange      = 5;
	declare hide int nStims 		= random(stimRange)+minStims;
	
	Trl_number				= 1;
	Comp_Trl_number			= 0;
	Block_number			= 1;
	
	
	if (Last_task != run_vm_sess)				// Only do this if we have gone into another task or if this is first run of day.
		{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,					
						Room);				
		Last_task = run_vm_sess;
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
	
	//spawnwait GOODVARS(State);
	
	spawnwait SET_SOA(max_soa, 					// Set up the right graph for INH f(x).
					min_soa,
					n_soas);
					
	spawnwait SET_CLRS(n_targ_pos);
	
	spawnwait SETMGTRL(n_targ_pos,				// Select variables for the first countermanding...
				go_weight,						// ...trial.  This happens once outside of the while...
				stop_weight,					// ...loop just to set up for the first iteration. After...
				ignore_weight,					// ...that SETC_TRL.pro will be called by END_TRL.pro.
				n_soas,
				min_holdtime,
                max_holdtime,
				expo_jitter,
				expo_jitter_soa);

	Event_fifo[Set_event] = MemHeader_;			// Set a strobe to identify this file as a MGUIDE session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = Identify_Room_;		// Set a strobe to identify this file as a MGUIDE session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	Event_fifo[Set_event] = Room;				// Set a strobe to identify this file as a MGUIDE session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	nexttick 10;								// to prevent buffer overflows after task reentry.
	
//	CheckMotion = 1;							// set global for watching the motion detector
//	spawn WATCHMTH;								// start watching the mouth motion detector if present
//	spawn WATCHBOD;								// start watching motion detector for body if present
	
	while (State == run_mg_sess)				// while the user has not yet terminated the countermanding task
		{
				
		 spawnwait VMAPTRIAL(allowed_fix_time, 	// run a trial with variables defined in SETC_TRL.pro
							curr_holdtime, 
							trl_type, 
							max_saccade_time, 
							curr_soa, 
							cancl_time, 
							max_sacc_duration, 
							targ_hold_time,
							object_fix,nStims);		
		
		spawnwait END_TRL(trl_outcome);			// end a trial with trl_outcome set in CMDTRIAL.pro
				
		nexttick;								// wait at least one cycle and do it all again
		
		while(Pause)							// gives the user the ability to pause the task without ending it
			{
			nexttick;
			}
		
		}

												// the State global variables allow a control structure...
												// ...to impliment the task.
	State = run_idle;							// If we are out of the while loop the user wanted...
												// ...to stop MGUIDE.
	CheckMotion = 0;							// stop watching for motion detector.
												
	oDestroy(object_fixwin);					// destroy all task graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);
	
	oSetGraph(gleft,aCLEAR);					// clear the left graph
	
	oDestroy(object_soa0);						// destroy all inh f(x) graph objects
	oDestroy(object_soa1);						
	oDestroy(object_soa2);						
	oDestroy(object_soa3);						
	oDestroy(object_soa4);						
	oDestroy(object_soa5);						
	oDestroy(object_soa6);						
	oDestroy(object_soa7);						
	oDestroy(object_soa8);						
	oDestroy(object_soa9);						
	oDestroy(object_soa10);						
	oDestroy(object_soa11);						
	oDestroy(object_soa12);						
	oDestroy(object_soa13);						
	oDestroy(object_soa14);						
	oDestroy(object_soa15);						
	oDestroy(object_soa16);						
	oDestroy(object_soa17);						
	oDestroy(object_soa18);						
	oDestroy(object_soa19);
//	oDestroy(object_30_70);
	
	oSetGraph(gleft,aCLEAR);					// clear the left graph
		
	spawn IDLE;									// return control to IDLE.pro
    
	}