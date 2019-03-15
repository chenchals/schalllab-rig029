//---------------------------------------------------------------------------------------------------------------------
// declare FAILURE(int trial_length,
				// int inter_trl_int,
				// int trl_start_time,
				// int fixed_trl_length,
				// int failure_tone,
				// int punish_time);
// Give negative reinforcement, set variables for the next trial, 
// send all trial event codes to plexon, and impose the correct 
// inter trial interval + timeout.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare FAILURE(int trial_length,									// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int failure_tone,
				int punish_time);
				
process FAILURE(int trial_length,									// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int failure_tone,
				int punish_time)
	{
	declare hide int trl_end_time;
	
	declare hide int run_cmd_sess = 1;								// state 1 is countermanding
	declare hide int run_mg_sess = 3;								// state 3 is mem guided sacc
	declare hide int run_gonogo_sess = 4;
	declare hide int run_delayed_sess = 6;
	declare hide int run_search_sess = 7;
	declare hide int run_anti_sess = 9;

	spawn TONE(failure_tone,tone_duration);							// present negative tone
	
	Event_fifo[Set_event] = Tone_;									// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
	Event_fifo[Set_event] = Error_tone;								// ...queue strobe for Neuro Explorer...
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
	trl_end_time = time();											// record the time b/c the trial is now over
	
	Event_fifo[Set_event] = Eot_;									// ...queue strobe... for end of trial
	Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue...
	
	if (Trl_Outcome == 16)
		{
			punish_time = punish_time*4;
		}
	
	
	if (fixed_trl_length)											// Did you want a fixed trial length?
		{                                                           
		while(time() < trl_start_time + trial_length + punish_time) // Then figure out how much time has elapsed since trial start...
			{                                                       
			nexttick;                                               // ...and continue to wait until time is up + timeout.
			}                                                       
		}                                                           
	else                                                            // Did you want a fixed intertrial interval?
		{                                                           
		while (time() < trl_end_time + punish_time) // Then watch the time since trial end...
			{                                                       
			nexttick;                                               // ...and wait until time is up + timeout.
			}
			dsendf("vp %d\n",0);
			Event_fifo[Set_event] = PunishEnd_;
			Set_event = (Set_event + 1) % Event_fifo_N;
		while (time() < trl_end_time + inter_trl_int + punish_time) // Then watch the time since trial end...
			{                                                       
			nexttick;                                               // ...and wait until time is up + timeout.
			}
		}
	
	nexttick 2;								// Give TEMPO a chance to catch its breath before attempting.. 
	spawnwait INFOS();												// ...queue a big ole` pile-o-strobes for plexon
	nexttick 10;													// Give TEMPO a chance to catch its breath before attempting.. 
                                                                    // ...RDX communication with vdosync.
	                                                                // NOTE: if you add a bunch more strobes to INFOS.pro and you...
	                                                                // start getting buffer overflow errors increase the number of nextticks.
																	// Impose the correct intertrial interval and timeout based on user input
		
	
	Event_fifo[Set_event] = EVT_TASK_END_;									// queue CMand header strobe
	Set_event = (Set_event + 1) % Event_fifo_N;								// incriment event queue
	
	
	if (State == run_cmd_sess)
		{
		
		spawn SETC_TRL(n_targ_pos,			
					go_weight,				
					stop_weight,        				// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
					ignore_weight,              
					staircase,                      
					n_SSDs,                         
					min_holdtime,                   
					max_holdtime,                   
					expo_jitter);  
		
		}
	/*
	else if (State == run_search_sess)
		{
		Consec_corr = 0; //reset consecutive correct counter
		spawnwait SETS_TRL(n_targ_pos,			
					go_weight,				
					stop_weight,        				// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
					ignore_weight,              
					staircase,                      
					n_SSDs,                         
					min_holdtime,                   
					max_holdtime,                   
					expo_jitter);  
		}
	*/
	else if (State == run_mg_sess)
		{
		spawn SETMGTRL(n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				 go_weight,
				 stop_weight,
				 ignore_weight,
				 n_SOAs,
				 min_holdtime,
				 max_holdtime,
				 expo_jitter,
				 expo_jitter_soa);
		}
	else if (State == run_gonogo_sess)
		{
		spawn	SETG_TRL(n_targ_pos,				// Select variables for the first mem guided...					
				min_holdtime,           		// ...trial.  This happens once outside of the while...
				max_holdtime,           		// ...loop just to set up for the first iteration. After...
				expo_jitter,            		// ...that SETM_TRL.pro will be called by END_TRL.pro.
				min_soa,
				max_soa,
				expo_jitter_soa);
		}
		
	else if (State == run_delayed_sess)
		{
		spawn	SETD_TRL(n_targ_pos,				// Select variables for the first mem guided...					
				min_holdtime,           		// ...trial.  This happens once outside of the while...
				max_holdtime,           		// ...loop just to set up for the first iteration. After...
				expo_jitter,            		// ...that SETM_TRL.pro will be called by END_TRL.pro.
				min_soa,
				max_soa,
				expo_jitter_soa);
		}	
		
	//else if (State == run_anti_sess)
		//{
		/*spawnwait SETA_TRL(n_targ_pos,				// Select variables for the first search...
				go_weight,						// ...trial.  This happens once outside of the while...
				stop_weight,					// ...loop just to set up for the first iteration. After...
				ignore_weight,					// ...that SETC_TRL.pro will be called by END_TRL.pro.
				staircase,
				n_SSDs,
				min_holdtime,
                max_holdtime,
				expo_jitter);
		*/
		//}
	/* 
	if(LastStopOutcome != 2 && State != run_anti_sess)										// quick way to check if last trial was a stop trial
		{
		
		
		spawn UPD8_INH(curr_ssd, 									// update the inh graph
				laststopoutcome,
				decide_ssd);
		} */
				
	
	}