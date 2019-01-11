//--------------------------------------------------------------------------------------------------
// This is the main flash protocol.  
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

	
declare FLSHSCRN();						

process FLSHSCRN()     
	{
	declare hide int run_flash_sess	= 5;
	declare hide int run_idle		= 0;
	declare hide int blank			= 0;
	declare hide int flash			= 1;
	declare int		 trl_ct			= 0;
	//declare hide float flashTime;
	//declare hide float IFI;
	declare hide float flashStart;
	declare hide float offTime;
	declare hide int flashOnEv = 9999;
	declare hide int flashFailEv = 9998;
	declare hide int flashSuccEv = 9997;
	declare hide int flashSessEnd = 9991;
	declare hide int flashSessStart = 9990;
	
	// Number the trial stages to make them easier to read below
	declare hide int 	need_fix  	= 1;
	declare hide int 	wait_flash 	= 2;
	declare hide int 	waitIFI 	= 3;
	declare hide int 	stage;
	
	// This variable makes the while loop work
	declare hide int 	trl_running;
	
	trl_ct = 0;
	
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
	
	//system("dialog Flash_Vars");
		
	if (Last_task != run_flash_sess)			// Only do this if we have gone into another task or if this is first run of day.
		{
		system("dialog Select_Monkey");
		spawnwait DEFAULT(State,				// Set all globals to their default values.
						Monkey,						
						Room);	
		Last_task = run_flash_sess;
		}
	
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
			
	nexttick 10;									// to prevent buffer overflows after task reentry.
	
	// Let's identify the next section of trials as a flash session
	Event_fifo[Set_event] = flashSessStart;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
		
	system("dialog Color_Vars");
	
	while (State == run_flash_sess)					// while the user has not yet terminated the countermanding task
		{		
		
		
		spawnwait WINDOWS(fixation_target,			// GLOBAL set by F_DFAULT and KEY_TARG (key macros KEY_T_UP and KEY_T_DN)
					fix_win_size,  					// see DEFAULT.pro and ALL_VARS.pro
					targ_win_size, 					// see DEFAULT.pro and ALL_VARS.pro
					object_fixwin, 					// animated graph object
					object_targwin,					// animated graph object
					deg2pix_X,     					// see SET_COOR.pro
					deg2pix_Y);    					// see SET_COOR.pro
		oSetAttribute(object_targwin, aINVISIBLE);	
		
		spawnwait FLS_PGS(scr_width,              	// see RIGSETUP.pro
					scr_height,                   	// see RIGSETUP.pro
					pd_left,                      	// see RIGSETUP.pro
					pd_bottom,                    	// see RIGSETUP.pro
					pd_size,                      	// see RIGSETUP.pro
					deg2pix_X,                    	// see SET_COOR.pro
					deg2pix_Y,                    	// see SET_COOR.pro
					unit2pix_X,                   	// see SET_COOR.pro
					unit2pix_Y,                   	// see SET_COOR.pro
					object_targ);               	// see GRAPHS.pro
		
		// Start the trial running
		trl_running=1;
		stage = need_fix;
		while (trl_running)
			{
			// Flash the stimulus when in fix window
			if (stage == need_fix)
				{
				if (In_FixWin)
					{
					Event_fifo[Set_event] = flashOnEv;									// queue TrialStart_ strobe
					Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
					dsendf("vp %d\n",flash);
					flashStart = time();
					stage = wait_flash;
					}
				}
			// Now wait for the flash to finish, eyes need to stay in window
			if (stage == wait_flash)
				{
				if (!In_FixWin)
					{
					Event_fifo[Set_event] = flashFailEv;									// queue TrialStart_ strobe
					Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
					dsendf("vp %d\n",blank);
					stage = need_fix;
					printf("Broke fixation\n");
					//printf("Stage = %d",stage);
					trl_running = 0;
					}
				else if (In_FixWin && time() > flashStart + flashTime)
					{
						dsendf("XM RFRSH:\n");
						dsendf("vp %d\n",blank);
						//printf("Stim turned off...");
						offTime = time();
						stage = waitIFI;
						Event_fifo[Set_event] = flashSuccEv;									// queue TrialStart_ strobe
						Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
						//spawn TONE(success_Tone_medR,tone_duration);				// give the secondary reinforcer tone
						spawn JUICE(juice_channel,Base_Reward_time);				// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
						trl_ct = trl_ct + 1;
						print(trl_ct);
						//printf("Stage = %d",stage);
						//nexttick;
					}
				/*else
					{
					//printf("Waiting...");
					}
				*/
				}
			// Wait for an IFI
			if (stage == waitIFI)
				{
				if (time() > offTime + IFI)
					{
					//printf(IFI);
					//printf("Waiting for IFI\n");
					trl_running = 0;
					}
				}
				
			nexttick;									// wait at least one cycle and do it all again
			}
			
			while (Pause)
				{
				nexttick;
				}
		}
	
	Event_fifo[Set_event] = flashSessEnd;									// queue TrialStart_ strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
						
													// the State global variables allow a control structure...
													// ...to impliment the task.
	State = run_idle;								// If we are out of the while loop the user wanted...
													// ...to stop cmanding.
												
	oDestroy(object_fixwin);						// destroy all graph objects
	oDestroy(object_targwin);
	oDestroy(object_fix);
	oDestroy(object_targ);
	oDestroy(object_eye);
	
	oSetGraph(gleft,aCLEAR);						// clear the left graph
	
	system("key currt = ");							// clear right key macro
	system("key curlf = ");							// clear left key macro
	system("key curup = ");							// clear up key macro
	system("key curdn = ");							// clear down key macro
		
	spawn IDLE;										// return control to IDLE.pro
    }
	
		