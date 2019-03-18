//-----------------------------------------------------------------------------------------------------
// End a trial without imposing any iti or trial length, and without
// giving any rewards or punishments.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare ABORT();

process ABORT()
	{	
	
	declare hide int run_cmd_sess = 1;	// state 1 is countermanding
	declare hide int run_mg_sess = 3;	// state 3 is mem guided sacc
	declare hide int run_gonogo_sess = 4;
	declare hide int run_delayed_sess = 6;
	declare hide int run_search_sess = 7;
	declare hide int run_anti_sess = 9;
	
	Event_fifo[Set_event] = Abort_;				// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue...
	
	Event_fifo[Set_event] = EVT_EOT_;				// ...queue strobe...
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue...
	                                            
	spawnwait INFOS();							// ...queue a big ole` pile-o-strobes for plexon				
	nexttick 10;								// Give TEMPO a chance to catch its breath before attempting.. 
                                                // ...RDX communication with vdosync.
                                                // NOTE: if you add a bunch more strobes to INFOS.pro and you...
	                                            // start getting buffer overflow errors increase the number of nextticks.
	/*if (State == run_cmd_sess)
		{
		spawnwait SETC_TRL(n_targ_pos,			// notice that this is spawnwait instead of spawn b/c
					go_weight,					// ...no inter trial interval is imposed.
					stop_weight,        		// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
					ignore_weight,              
					staircase,                      
					n_SSDs,                         
					min_holdtime,                   
					max_holdtime,                   
					expo_jitter);  
		
		}
	else */ if (State == run_search_sess)
		{
		spawnwait SETS_TRL(n_targ_pos,			// notice that this is spawnwait instead of spawn b/c
					go_weight,					// ...no inter trial interval is imposed.
					stop_weight,        		// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
					ignore_weight,              
					staircase,                      
					n_SSDs,                         
					min_holdtime,                   
					max_holdtime,                   
					expo_jitter);  
		}
	
	/*else if (State == run_mg_sess)
		{
		spawnwait SETMGTRL(n_targ_pos,							// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				 go_weight,
				 stop_weight,
				 ignore_weight,
				 n_SOAs,
				 min_holdtime,
				 max_holdtime,
				 expo_jitter,
				 expo_jitter_soa);
		}
	*/	
	/*else if (State == run_gonogo_sess)
		{
		spawnwait SETG_TRL(n_targ_pos,				// Select variables for the first mem guided...					
				min_holdtime,           		// ...trial.  This happens once outside of the while...
				max_holdtime,           		// ...loop just to set up for the first iteration. After...
				expo_jitter,            		// ...that SETM_TRL.pro will be called by END_TRL.pro.
				min_soa,
				max_soa,
				expo_jitter_soa);
		}	
	*/	
	/*else if (State == run_delayed_sess)
		{
		spawnwait SETD_TRL(n_targ_pos,				// Select variables for the first mem guided...					
				min_holdtime,           		// ...trial.  This happens once outside of the while...
				max_holdtime,           		// ...loop just to set up for the first iteration. After...
				expo_jitter,            		// ...that SETM_TRL.pro will be called by END_TRL.pro.
				min_soa,
				max_soa,
				expo_jitter_soa);
		}
	*/
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
	nexttick 50; 								// this is just here to prevent vdosync buffer overflows if subject is on edge of fix window	
	                                            
	
	}
	