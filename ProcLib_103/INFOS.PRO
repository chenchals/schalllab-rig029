//-------------------------------------------------------------------------------------------------------------------
// Records all of the parameters for a trial.  Should be sent during the inter trial interval while
// the communication lines are clear (no rdx communication with vdosync).  
// NOTES:
// 1) The order of these params is very important.  Matlab translation code identifies these parameters based on their
// order, so if you add more events, make sure to keep them in the same order in the matlab translation code.  (
// 2) This process relies heavily on globals (since it is grabbing stuff from all over the protocol).
//
// written by joshua.d.cosman@vanderbilt.edu 	January, 2014


declare int stop_sig_color_r, stop_sig_color_g, stop_sig_color_b;
declare int ignore_sig_color_r, ignore_sig_color_g, ignore_sig_color_b;
declare int fixation_color_r, fixation_color_g, fixation_color_b;
declare int target_color_r, target_color_g, target_color_b;
declare hide int id;
declare hide int run_anti_sess = 9;
declare hide int run_color_pop = 10;
declare hide float chkTime;

declare INFOS();

	process INFOS()
			{
			//printf("State=%d\n",State);
			if ((State == run_anti_sess) || (State == run_color_pop))
			{
				Event_fifo[Set_event] = StartInfos_;
				Set_event = (Set_event + 1) % Event_fifo_N;
				
				// Loop and send stimulus angles and stim difficulties
				id = 0;
				
				printf("SetSize = %d\n",SetSize);
				while (id < SetSize)
				{
					chkTime = time();
					
					/*while (time() < chkTime + 1000)
					{
						nexttick;
					}
					*/
					//printf("This Angle = %d\n",5000 + Angle_list[id]);
					//printf("This Diff = %d\n",6000 + (100 * (id+1)) + distDifficulty[id]);
					Event_fifo[Set_event] = 5000 + Angle_list[id];
					Set_event = (Set_event + 1) % Event_fifo_N;
					
					Event_fifo[Set_event] = 6000 + (100 * (id+1)) + distDifficulty[id];
					Set_event = (Set_event + 1) % Event_fifo_N;
					
					/*while (time() < (chkTime + 500))
					{
						nexttick;
					}
					*/
					nexttick;
					
					
					id = id + 1;
					
				}
					
				Event_fifo[Set_event] = InfosZero + Trl_Outcome;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = 500 + lumOffset;
				Set_event = (Set_event + 1) % Event_fifo_N;
			
				Event_fifo[Set_event] = 400 + leaveOther;
				Set_event = (Set_event + 1) % Event_fifo_N;
				
				Event_fifo[Set_event] = 410 + extinguishTime;
				Set_event = (Set_event + 1) % Event_fifo_N;
			
				/*Event_fifo[Set_event] = InfosZero + Max_sacc_duration;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Max_saccade_time;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Punish_time;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Reward_Duration;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Reward_Offset;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Targ_hold_time;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Tone_Duration;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
				
				Event_fifo[Set_event] = InfosZero + (X_Gain * 100) + 1000;		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
				Event_fifo[Set_event] = InfosZero + (X_Offset * 100) + 1000;	// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Y_Gain * 100) + 1000;		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
				Event_fifo[Set_event] = InfosZero + (Y_Offset * 100) + 1000;	// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				*/
				Event_fifo[Set_event] = EndInfos_;									// Let Matlab know that trial infos are finished streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.	
				
			} else if (State == run_search_sess) 
				{
				Event_fifo[Set_event] = StartInfos_;								// Let Matlab know that trial infos are going to start streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.
					
				//---------------------------------------------------------------------------------------------------------------------------------------
					
					Event_fifo[Set_event] = InfosZero + 999;						// 4000'set a strobe to identify the start of Search Vars (4000) not specfic to search and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
					Event_fifo[Set_event] = ArrStruct + 4001;							// Set a strobe to identify the type of search (typical vs. contextual cue) and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
					Event_fifo[Set_event] = SearchType + 4050;						// Set a strobe to identify the type of search (homo, hetero, etc.) and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
					Event_fifo[Set_event] = SingMode + 4060;						// Set a strobe to tell us if we should expect a singleton distractor 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = SetSize + 4100;							// Set a strobe to identify Set Size and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = TargetType + 4150;						// Set a strobe to identify the identity of the target and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
				
					Event_fifo[Set_event] = TrialTp + 4200;							// Set a strobe to identify Trial Type (random vs repeated displays) (set in SEL_LOCS)	
					Set_event = (Set_event + 1) % Event_fifo_N;	
					
					Event_fifo[Set_event] = SearchEcc + 4250;						// Set a strobe to identify Trial Type (random vs repeated displays) (set in SEL_LOCS)	
					Set_event = (Set_event + 1) % Event_fifo_N;	
					
					Event_fifo[Set_event] = DistPres;								// Set a strobe to identify Singleton presence (set in LOC_RAND)	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = THemi;									// Set a strobe to identify the target hemifield (set in LOC_RAND)	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = DHemi;									// Set a strobe to identify the distractor hemifield (set in LOC_RAND)	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = Rand_targ_angle + 5000;					// Set a strobe to identify actual target location	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event
					
					Event_fifo[Set_event] = Rand_d1_angle + 5500;					// Set a strobe to identify actual distractor location	
					Set_event = (Set_event + 1) % Event_fifo_N;	
					
					Event_fifo[Set_event] = CatchCode + 3800;						// Set a strobe to identify catch trials	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event 
					
					Event_fifo[Set_event] = SingCol + 4650;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = DistOrt + 4660;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = TargOrt + 4670;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu
					
					Event_fifo[Set_event] = PercSingTrl + 4700;						// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = Perc_catch + 4800;						// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
					
					Event_fifo[Set_event] = Block_number + 4900;					// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
									
					Event_fifo[Set_event] = Curr_soa + 6000;						// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
									
					Event_fifo[Set_event] = InfosZero + Trl_Outcome;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Max_sacc_duration;			// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Max_saccade_time;			// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Punish_time;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Reward_Duration;			// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Reward_Offset;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Targ_hold_time;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + Tone_Duration;				// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + (X_Gain * 100) + 1000;		// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
					Event_fifo[Set_event] = InfosZero + (X_Offset * 100) + 1000;	// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
					Event_fifo[Set_event] = InfosZero + (Y_Gain * 100) + 1000;		// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
					Event_fifo[Set_event] = InfosZero + (Y_Offset * 100) + 1000;	// Send event and...	
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.

				    Event_fifo[Set_event] = DistFix + 4680;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu

				    Event_fifo[Set_event] = ProbCue + 4690;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu
					
				    Event_fifo[Set_event] = ProbSide + 4790;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu		

				    Event_fifo[Set_event] = StimTm + 5100;							// Send event and... 
					Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queu						
				//---------------------------------------------------------------------------------------------------------------------------------------
					
				Event_fifo[Set_event] = EndInfos_;									// Let Matlab know that trial infos are finished streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.	
				
				}

			else
				{
			
				stop_sig_color_r	= Stop_sig_color[0];
				stop_sig_color_g	= Stop_sig_color[1];
				stop_sig_color_b	= Stop_sig_color[2];
									 
				ignore_sig_color_r	= Ignore_sig_color[0];
				ignore_sig_color_g	= Ignore_sig_color[1];
				ignore_sig_color_b	= Ignore_sig_color[2];
				
				fixation_color_r	= Fixation_color[0];
				fixation_color_g	= Fixation_color[1];
				fixation_color_b	= Fixation_color[2];
									
				target_color_r		= Color_list[Curr_target,0];
				target_color_g		= Color_list[Curr_target,1];
				target_color_b		= Color_list[Curr_target,2];
				
				Event_fifo[Set_event] = StartInfos_;								// Let Matlab know that trial infos are going to start streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.
				
			//---------------------------------------------------------------------------------------------------------------------------------------
						

						
				Event_fifo[Set_event] = InfosZero + Fixed_trl_length;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Ignore_weight * 100);		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
				Event_fifo[Set_event] = InfosZero + Inter_trl_int;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Max_holdtime;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Max_sacc_duration;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Max_saccade_time;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Min_holdtime;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + N_SSDs;						// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Punish_time;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Reward_Duration;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Reward_Offset;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
							
				Event_fifo[Set_event] = InfosZero + Staircase;					// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + stop_sig_color_b;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + stop_sig_color_g;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + stop_sig_color_r;			// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Stop_weight * 100);		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Success_Tone;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Targ_win_size * 100);		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Angle;						// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.

				Event_fifo[Set_event] = InfosZero + color;						// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
				
				Event_fifo[Set_event] = InfosZero + target_color_b;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + target_color_g;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + target_color_r;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Eccentricity * 100);		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Targ_hold_time;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Size * 100);				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Tone_Duration;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Trial_length;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.	
						
				Event_fifo[Set_event] = InfosZero + Trl_Outcome;				// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + Trl_type;					// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (X_Gain * 100) + 1000;		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
				Event_fifo[Set_event] = InfosZero + (X_Offset * 100) + 1000;	// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
						
				Event_fifo[Set_event] = InfosZero + (Y_Gain * 100) + 1000;		// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
					
				Event_fifo[Set_event] = InfosZero + (Y_Offset * 100) + 1000;	// Send event and...	
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue.
				
				Event_fifo[Set_event] = InfosZero + Curr_soa;					// Send event and... <-- added by Namsoo
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
						
				Event_fifo[Set_event] = InfosZero + Block_number;				// Send event and... <-- added by DCG
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue

				Event_fifo[Set_event] = InfosZero + StimTm + 1000;				// Send event and... <-- added by DCG
				Set_event = (Set_event + 1) % Event_fifo_N;						// ...incriment event queue
				//---------------------------------------------------------------------------------------------------------------------------------------
				
				Event_fifo[Set_event] = EndInfos_;									// Let Matlab know that trial infos are finished streaming in...
				Set_event = (Set_event + 1) % Event_fifo_N;							// ...incriment event queue.	
				
			
				}
	}		