//-------------------------------------------------------------------------------------------------------
// 1) Look at the outcome from the last trial
// 2) Roll the dice a few times to mix up reward and punish times if the user asked for it
// 3) Call the appropriate processes to end the trial with the calculated timings
// written by david.c.godlove@vanderbilt.edu 	January, 2011

/*
#include C:/TEMPO/ProcLib/ABORT.pro
#include C:/TEMPO/ProcLib/SUCCESS.pro
#include C:/TEMPO/ProcLib/FAILURE.pro
*/
declare int constant rewardOffset = 50;

declare END_TRL(int trl_outcome);

process END_TRL(int trl_outcome)
	{	
	// Code all possible outcomes (both cmanding and mem guided)
	declare hide int constant no_fix		= 1;		// never attained fixation
	declare hide int constant broke_fix		= 2;		// attained and then lost fixation before target presentation
	declare hide int constant go_wrong		= 3;		// never made saccade on a go trial (cmanding)
	declare hide int constant nogo_correct	= 4;		// successfully canceled trial (cmanding)
	declare hide int constant sacc_out		= 5;		// made an inaccurate saccade out of the target box
	declare hide int constant broke_targ	= 6;		// didn't hold fixation at the target for long enough
	declare hide int constant go_correct	= 7;		// correct saccade on a go trial (cmanding)
	declare hide int constant nogo_wrong	= 8;		// error noncanceled trial 
	declare hide int constant early_sacc	= 9;		// made a saccade before fixation offset
	declare hide int constant no_sacc		= 10;		// didn't make a saccade after cued to do so (mem guided)
	declare hide int constant correct_sacc	= 11;		// correct saccade (mem guided)
	declare hide int constant body_move		= 12;		// error body movement (for training stillness)	
	declare hide int constant anticip_sacc  = 13;
	declare hide int constant too_fast      = 14;		// made a saccade too quickly while in training to slow down
	declare hide int constant late_correct  = 15; 		// Eventually found the target but not on first saccade
	declare hide int constant returnTofix    = 16; 		// Eventually found the target but not on first saccade

	declare					  now;			

	declare hide int 			run_anti_sess = 9;
	declare hide int 			run_color_pop = 10;
	declare hide int 			run_pop_prime = 11;
	declare hide float play_the_odds;					// see if subject will randomly be rewarded or punished on this trial and by how much
	
	
	
	 if(LastStopOutcome != 2 && 		// If the subject got the trial right...
				(trl_outcome == nogo_correct || trl_outcome == nogo_wrong)   )										// quick way to check if last trial was a stop trial
		 {
		
		spawn UPD8_INH(curr_ssd, 									// update the inh graph
				LastStopOutcome,
				decide_ssd);
		 }
		 
	//--------------------------------------------------------------------------------------------------
	// Setting up reward
	

		if (DR1_flag == 1)
			{
			if (Block_number % 2 == 0)
				{
				if (Angle == 0)
					{
					Reward_duration = Base_Reward_time+rewardOffset;				//GLOBAL for use in INFOS.pro
					Success_tone = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
					Punish_time = Base_Punish_time;					//GLOBAL for use in INFOS.pro
					Failure_tone = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
					}
				else if (Angle == 180)
					{
				    Reward_duration = Base_Reward_time-rewardOffset;				//GLOBAL for use in INFOS.pro
					Success_tone = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
					Punish_time = Base_Punish_time;					//GLOBAL for use in INFOS.pro
					Failure_tone = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
					}
				}
				
			else if (Block_number % 2 == 1)
				{
				
					if (Angle == 180)
					{
					Reward_duration = Base_Reward_time+rewardOffset;				//GLOBAL for use in INFOS.pro
					Success_tone = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
					Punish_time = Base_Punish_time;					//GLOBAL for use in INFOS.pro
					Failure_tone = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
					}
					else if  (Angle == 0)
					{
					Reward_duration = Base_Reward_time-rewardOffset;				//GLOBAL for use in INFOS.pro
					Success_tone = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
					Punish_time = Base_Punish_time;					//GLOBAL for use in INFOS.pro
					Failure_tone = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
					}
				}
		else if (DR1_flag == 0)
		{
			Reward_duration = Base_Reward_time-(Base_Reward_time*rewdDiscount);				//GLOBAL for use in INFOS.pro
			Success_tone = Success_Tone_medR;               //GLOBAL for use in INFOS.pro
		
			Punish_time = Base_Punish_time;					//GLOBAL for use in INFOS.pro
			Failure_tone = Failure_Tone_medP;               //GLOBAL for use in INFOS.pro
		}
		}
		
		

	
	
	Event_fifo[Set_event] = Block_number + 2730;					// ...queue strobe for Neuro Explorer
	Set_event = (Set_event + 1) % Event_fifo_N;	
	
	//----------------------------------------------------------------------------------------------------
	// 1) Aborted trial
	if (	trl_outcome == no_fix 			||			// If the subject failed to initiate the trial properly...
			trl_outcome == broke_fix		||
			trl_outcome == body_move)	
		{
		lastWasAbort = 1;
		spawnwait ABORT;								// ...abort the trial (no intertrial interval or punish time).
		}

	//----------------------------------------------------------------------------------------------------
	// 2) Correct trial
	else if (	trl_outcome == go_correct 	||			// If the subject got the trial right...
				trl_outcome == nogo_correct	||
				trl_outcome == correct_sacc	||
				play_the_odds < Bonus_weight)			// ...or if the trial is chosen as a surprise rewarded trial...
		{
		printf("Reward Duration = %d ms\n", Reward_duration);
  				
		if (State == run_search_sess) 
			{
			
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			Consec_corr = Consec_corr + 1; // allows me to set how many correct trials in a row to get reward
			
			if (TrialTp == 1)
				{ 
				if (SingMode == 0)
					{				
					Rand_Comp_Trl_number = Rand_Comp_Trl_number + 1;	
					}
				else if (SingMode == 1)
					{
					if (DistPres == 1111)
						{
						Rand_Comp_Trl_DA = Rand_Comp_Trl_DA + 1;	
						}
					else if (DistPres == 2222)	
						{
						Rand_Comp_Trl_DP = Rand_Comp_Trl_DP + 1;	
						}
					}
				}
		 	else
				{
				Rep_Comp_Trl_number = Rep_Comp_Trl_number + 1;
				}	 
			}	
		else if (State == run_anti_sess) 
			{
			nThisRun = (nThisRun+1) % nPerRun;
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			Consec_corr = Consec_corr + 1; // allows me to set how many correct trials in a row to get reward
			
			if (Catch == 1)
			{
				Catch_Comp_Trl_number = Catch_Comp_Trl_number + 1;
				CatchPerAcc = (Catch_Comp_Trl_number/(Catch_Comp_Trl_number + catch_inacc_sacc))*100;
			} else if (Trl_type == 1) // prosaccade
			{
				Pro_Comp_Trl_number = Pro_Comp_Trl_number + 1;
				ProPerAcc = (Pro_Comp_Trl_number/(Pro_Comp_Trl_number+pro_inacc_sacc))*100;
				if (isCong == 1)
				{
					Pro_Cong_Trl_number = Pro_Cong_Trl_number + 1;
					ProCongAcc = (Pro_Cong_Trl_number/(Pro_Cong_Trl_number+pro_cong_inacc))*100;
				} else if (isCong == 0)
				{
					Pro_ICong_Trl_number = Pro_ICong_Trl_number + 1;
					ProICongAcc = (Pro_ICong_Trl_number/(Pro_ICong_Trl_number+pro_icong_inacc))*100;
				} else if (isCong == 2)
				{
					Pro_CCong_Trl_number = Pro_CCong_Trl_number + 1;
					ProCCongAcc = (Pro_CCong_Trl_number/(Pro_CCong_Trl_number+pro_ccong_inacc))*100;
				}
				
				cum_pro_rt = cum_pro_rt + current_rt;
				avg_pro_rt = cum_pro_rt/Pro_Comp_Trl_number;
			} else if (Trl_type == 2) // antisaccade
			{
				Anti_Comp_Trl_number = Anti_Comp_Trl_number + 1;
				AntiPerAcc = (Anti_Comp_Trl_number/(Anti_Comp_Trl_number+anti_inacc_sacc))*100;
				if (isCong == 0)
				{
					Anti_Cong_Trl_number = Anti_Cong_Trl_number + 1;
					AntiCongAcc = (Anti_Cong_Trl_number/(Anti_Cong_Trl_number+anti_cong_inacc))*100;
				} else if (isCong == 1)
				{
					Anti_ICong_Trl_number = Anti_ICong_Trl_number + 1;
					AntiICongAcc = (Anti_ICong_Trl_number/(Anti_ICong_Trl_number+anti_icong_inacc))*100;
				} else if (isCong == 2)
				{
					Anti_CCong_Trl_number = Anti_CCong_Trl_number + 1;
					AntiCCongAcc = (Anti_CCong_Trl_number/(Anti_CCong_Trl_number+anti_ccong_inacc))*100;
				}
				cum_anti_rt = cum_anti_rt + current_rt;
				avg_anti_rt = cum_anti_rt/Anti_Comp_Trl_number;
			}
			/*
			if (TrialTp == 1)
				{ 
				if (SingMode == 0)
					{				
					Rand_Comp_Trl_number = Rand_Comp_Trl_number + 1;	
					}
				else if (SingMode == 1)
					{
					if (DistPres == 1111)
						{
						Rand_Comp_Trl_DA = Rand_Comp_Trl_DA + 1;	
						}
					else if (DistPres == 2222)	
						{
						Rand_Comp_Trl_DP = Rand_Comp_Trl_DP + 1;	
						}
					}
				}
			
		 	else
				{
				Rep_Comp_Trl_number = Rep_Comp_Trl_number + 1;
				}
			*/
			}	
		else if ((State == run_color_pop) || (State == run_pop_prime))
			{
			nThisRun = (nThisRun+1) % nPerRun;
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			Consec_corr = Consec_corr + 1; // allows me to set how many correct trials in a row to get reward
			
			if (Catch == 1)
			{
				Catch_Comp_Trl_number = Catch_Comp_Trl_number + 1;
				CatchPerAcc = (Catch_Comp_Trl_number/(Catch_Comp_Trl_number + catch_inacc_sacc))*100;
			} else if (Trl_type == 1) // prosaccade
			{
				Pro_Comp_Trl_number = Pro_Comp_Trl_number + 1;
				ProPerAcc = (Pro_Comp_Trl_number/(Pro_Comp_Trl_number+pro_inacc_sacc))*100;
				if (isCong == 1)
				{
					Pro_Cong_Trl_number = Pro_Cong_Trl_number + 1;
					ProCongAcc = (Pro_Cong_Trl_number/(Pro_Cong_Trl_number+pro_cong_inacc))*100;
				} else if (isCong == 0)
				{
					Pro_ICong_Trl_number = Pro_ICong_Trl_number + 1;
					ProICongAcc = (Pro_ICong_Trl_number/(Pro_ICong_Trl_number+pro_icong_inacc))*100;
				} else if (isCong == 2)
				{
					Pro_CCong_Trl_number = Pro_CCong_Trl_number + 1;
					ProCCongAcc = (Pro_CCong_Trl_number/(Pro_CCong_Trl_number+pro_ccong_inacc))*100;
				}
				
				cum_pro_rt = cum_pro_rt + current_rt;
				avg_pro_rt = cum_pro_rt/Pro_Comp_Trl_number;
			} else if (Trl_type == 2) // antisaccade
			{
				Anti_Comp_Trl_number = Anti_Comp_Trl_number + 1;
				AntiPerAcc = (Anti_Comp_Trl_number/(Anti_Comp_Trl_number+anti_inacc_sacc))*100;
				if (isCong == 0)
				{
					Anti_Cong_Trl_number = Anti_Cong_Trl_number + 1;
					AntiCongAcc = (Anti_Cong_Trl_number/(Anti_Cong_Trl_number+anti_cong_inacc))*100;
				} else if (isCong == 1)
				{
					Anti_ICong_Trl_number = Anti_ICong_Trl_number + 1;
					AntiICongAcc = (Anti_ICong_Trl_number/(Anti_ICong_Trl_number+anti_icong_inacc))*100;
				} else if (isCong == 2)
				{
					Anti_CCong_Trl_number = Anti_CCong_Trl_number + 1;
					AntiCCongAcc = (Anti_CCong_Trl_number/(Anti_CCong_Trl_number+anti_ccong_inacc))*100;
				}
				cum_anti_rt = cum_anti_rt + current_rt;
				avg_anti_rt = cum_anti_rt/Anti_Comp_Trl_number;
			}
			/*
			if (TrialTp == 1)
				{ 
				if (SingMode == 0)
					{				
					Rand_Comp_Trl_number = Rand_Comp_Trl_number + 1;	
					}
				else if (SingMode == 1)
					{
					if (DistPres == 1111)
						{
						Rand_Comp_Trl_DA = Rand_Comp_Trl_DA + 1;	
						}
					else if (DistPres == 2222)	
						{
						Rand_Comp_Trl_DP = Rand_Comp_Trl_DP + 1;	
						}
					}
				}
			
		 	else
				{
				Rep_Comp_Trl_number = Rep_Comp_Trl_number + 1;
				}
			*/
			}
		else
			{
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;			// THIS IS PLACED INCORRECTLY.  IF THE TRIAL WAS CORRECT BUT UNREWARDED THIS WILL NOT COUNT
			}											// DON'T HAVE TIME TO FIX RIGHT NOW
				
			spawnwait SUCCESS(trial_length,					// ...give rewards and wait for the proper iti.
			inter_trl_int,
			trl_start_time,
			fixed_trl_length,
			success_tone,
			tone_duration,
			reward_offset);
		
		}
		
	else if (trl_outcome == late_correct)
	{
		if (State == run_anti_sess)
		{
			nThisRun = (nThisRun+1) % nPerRun;
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			if (Catch == 1)
			{
				catch_inacc_sacc = catch_inacc_sacc + 1;
				CatchPerAcc = (Catch_Comp_Trl_number/(Catch_Comp_Trl_number + catch_inacc_sacc))*100;
			} else if (Trl_type == 1) // pro
			{
				pro_inacc_sacc = pro_inacc_sacc + 1;
				ProPerAcc = (Pro_Comp_Trl_number/(Pro_Comp_Trl_number + pro_inacc_sacc))*100;
				if (isCong == 1)
				{
					pro_cong_inacc = pro_cong_inacc + 1;
					ProCongAcc = (Pro_Cong_Trl_number/(Pro_Cong_Trl_number + pro_cong_inacc))*100;
				} else if (isCong == 0)
				{
					pro_icong_inacc = pro_icong_inacc + 1;
					ProICongAcc = (Pro_ICong_Trl_number/(Pro_ICong_Trl_number + pro_icong_inacc))*100;
				} else if (isCong == 2)
				{
					pro_ccong_inacc = pro_ccong_inacc + 1;
					ProCCongAcc = (Pro_CCong_Trl_number/(Pro_CCong_Trl_number + pro_ccong_inacc))*100;
				}
			} else if (Trl_type == 2) // anti
			{
				anti_inacc_sacc = anti_inacc_sacc + 1;
				AntiPerAcc = (Anti_Comp_Trl_number/(Anti_Comp_Trl_number + anti_inacc_sacc))*100;
				if (isCong == 0)
				{
					anti_cong_inacc = anti_cong_inacc + 1;
					AntiCongAcc = (Anti_Cong_Trl_number/(Anti_Cong_Trl_number + anti_cong_inacc))*100;
				} else if (isCong == 1)
				{
					anti_icong_inacc = anti_icong_inacc + 1;
					AntiICongAcc = (Anti_ICong_Trl_number/(Anti_ICong_Trl_number + anti_icong_inacc))*100;
				} else if (isCong == 2)
				{
					anti_ccong_inacc = anti_ccong_inacc + 1;
					AntiCCongAcc = (Anti_CCong_Trl_number/(Anti_CCong_Trl_number + anti_ccong_inacc))*100;
				}
			}
		}
		else if ((State == run_color_pop) || (State == run_pop_prime))
		{
			if (countIncorrect == 1)
			{
				nThisRun = (nThisRun+1) % nPerRun;
			}
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			if (Catch == 1)
			{
				catch_inacc_sacc = catch_inacc_sacc + 1;
				CatchPerAcc = (Catch_Comp_Trl_number/(Catch_Comp_Trl_number + catch_inacc_sacc))*100;
			} else if (Trl_type == 1) // pro
			{
				pro_inacc_sacc = pro_inacc_sacc + 1;
				ProPerAcc = (Pro_Comp_Trl_number/(Pro_Comp_Trl_number + pro_inacc_sacc))*100;
				if (isCong == 1)
				{
					pro_cong_inacc = pro_cong_inacc + 1;
					ProCongAcc = (Pro_Cong_Trl_number/(Pro_Cong_Trl_number + pro_cong_inacc))*100;
				} else if (isCong == 0)
				{
					pro_icong_inacc = pro_icong_inacc + 1;
					ProICongAcc = (Pro_ICong_Trl_number/(Pro_ICong_Trl_number + pro_icong_inacc))*100;
				} else if (isCong == 2)
				{
					pro_ccong_inacc = pro_ccong_inacc + 1;
					ProCCongAcc = (Pro_CCong_Trl_number/(Pro_CCong_Trl_number + pro_ccong_inacc))*100;
				}
			} else if (Trl_type == 2) // anti
			{
				anti_inacc_sacc = anti_inacc_sacc + 1;
				AntiPerAcc = (Anti_Comp_Trl_number/(Anti_Comp_Trl_number + anti_inacc_sacc))*100;
				if (isCong == 0)
				{
					anti_cong_inacc = anti_cong_inacc + 1;
					AntiCongAcc = (Anti_Cong_Trl_number/(Anti_Cong_Trl_number + anti_cong_inacc))*100;
				} else if (isCong == 1)
				{
					anti_icong_inacc = anti_icong_inacc + 1;
					AntiICongAcc = (Anti_ICong_Trl_number/(Anti_ICong_Trl_number + anti_icong_inacc))*100;
				} else if (isCong == 2)
				{
					anti_ccong_inacc = anti_ccong_inacc + 1;
					AntiCCongAcc = (Anti_CCong_Trl_number/(Anti_CCong_Trl_number + anti_ccong_inacc))*100;
				}
			}
		}
			spawnwait SUCCESS(trial_length,					// ...give rewards and wait for the proper iti.
			inter_trl_int,
			trl_start_time,
			fixed_trl_length,
			success_tone,
			tone_duration,
			reward_offset);
	}

	//----------------------------------------------------------------------------------------------------
	// 3) Error trial
	else if (	trl_outcome	== go_wrong		||			// If the subject made an error after trial initiation...
				trl_outcome == no_sacc		||
				trl_outcome == sacc_out		||
				trl_outcome == broke_targ	||
				trl_outcome == nogo_wrong	||
				trl_outcome == early_sacc	||
				trl_outcome == anticip_sacc	||
				trl_outcome == too_fast		||
				trl_outcome == returnTofix	||
				play_the_odds < Dealer_wins_weight)		// ...or if the trial is chosen as a surprise punished trial...
		{

				
		if (State == run_search_sess) 
			{
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			if (TrialTp == 1)
				{
				if (SingMode == 0)
					{				
					rand_inacc_sacc = rand_inacc_sacc + 1;
					}
				else if (SingMode == 1)
					{
					if (DistPres == 1111)
						{
						rand_inacc_sacc_DA = rand_inacc_sacc_DA + 1;
						}
					else if (DistPres == 2222)	
						{
						rand_inacc_sacc_DP = rand_inacc_sacc_DP + 1;
						}
					}	
				}
			else
				{
					rep_inacc_sacc = rep_inacc_sacc + 1;
				}
			}	
		else if (State == run_anti_sess) 
			{
			if (countIncorrect == 1)
			{
				nThisRun = (nThisRun+1) % nPerRun;
			}
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			if (Catch == 1)
			{
				catch_inacc_sacc = catch_inacc_sacc + 1;
				CatchPerAcc = (Catch_Comp_Trl_number/(Catch_Comp_Trl_number + catch_inacc_sacc))*100;
			} else if (Trl_type == 1) // pro
			{
				pro_inacc_sacc = pro_inacc_sacc + 1;
				ProPerAcc = (Pro_Comp_Trl_number/(Pro_Comp_Trl_number + pro_inacc_sacc))*100;
				if (isCong == 1)
				{
					pro_cong_inacc = pro_cong_inacc + 1;
					ProCongAcc = (Pro_Cong_Trl_number/(Pro_Cong_Trl_number + pro_cong_inacc))*100;
				} else if (isCong == 0)
				{
					pro_icong_inacc = pro_icong_inacc + 1;
					ProICongAcc = (Pro_ICong_Trl_number/(Pro_ICong_Trl_number + pro_icong_inacc))*100;
				} else if (isCong == 2)
				{
					pro_ccong_inacc = pro_ccong_inacc + 1;
					ProCCongAcc = (Pro_CCong_Trl_number/(Pro_CCong_Trl_number + pro_ccong_inacc))*100;
				}
			} else if (Trl_type == 2) // anti
			{
				anti_inacc_sacc = anti_inacc_sacc + 1;
				AntiPerAcc = (Anti_Comp_Trl_number/(Anti_Comp_Trl_number + anti_inacc_sacc))*100;
				if (isCong == 0)
				{
					anti_cong_inacc = anti_cong_inacc + 1;
					AntiCongAcc = (Anti_Cong_Trl_number/(Anti_Cong_Trl_number + anti_cong_inacc))*100;
				} else if (isCong == 1)
				{
					anti_icong_inacc = anti_icong_inacc + 1;
					AntiICongAcc = (Anti_ICong_Trl_number/(Anti_ICong_Trl_number + anti_icong_inacc))*100;
				} else if (isCong == 2)
				{
					anti_ccong_inacc = anti_ccong_inacc + 1;
					AntiCCongAcc = (Anti_CCong_Trl_number/(Anti_CCong_Trl_number + anti_ccong_inacc))*100;
				}
			}
			/*
				if (SingMode == 0)
					{				
					rand_inacc_sacc = rand_inacc_sacc + 1;
					}
				else if (SingMode == 1)
					{
					if (DistPres == 1111)
						{
						rand_inacc_sacc_DA = rand_inacc_sacc_DA + 1;
						}
					else if (DistPres == 2222)	
						{
						rand_inacc_sacc_DP = rand_inacc_sacc_DP + 1;
						}
					}	
				}
			
			else
				{
					rep_inacc_sacc = rep_inacc_sacc + 1;
				}
			}	
			*/
			}
		else if ((State == run_color_pop) || (State == run_pop_prime))
			{
			if (countIncorrect==1)
			{
				nThisRun = (nThisRun+1) % nPerRun;
			}
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number + 1;
			if (Catch == 1)
			{
				catch_inacc_sacc = catch_inacc_sacc + 1;
				CatchPerAcc = (Catch_Comp_Trl_number/(Catch_Comp_Trl_number + catch_inacc_sacc))*100;
			} else if (Trl_type == 1) // pro
			{
				pro_inacc_sacc = pro_inacc_sacc + 1;
				ProPerAcc = (Pro_Comp_Trl_number/(Pro_Comp_Trl_number + pro_inacc_sacc))*100;
				if (isCong == 1)
				{
					pro_cong_inacc = pro_cong_inacc + 1;
					ProCongAcc = (Pro_Cong_Trl_number/(Pro_Cong_Trl_number + pro_cong_inacc))*100;
				} else if (isCong == 0)
				{
					pro_icong_inacc = pro_icong_inacc + 1;
					ProICongAcc = (Pro_ICong_Trl_number/(Pro_ICong_Trl_number + pro_icong_inacc))*100;
				} else if (isCong == 2)
				{
					pro_ccong_inacc = pro_ccong_inacc + 1;
					ProCCongAcc = (Pro_CCong_Trl_number/(Pro_CCong_Trl_number + pro_ccong_inacc))*100;
				}
			} else if (Trl_type == 2) // anti
			{
				anti_inacc_sacc = anti_inacc_sacc + 1;
				AntiPerAcc = (Anti_Comp_Trl_number/(Anti_Comp_Trl_number + anti_inacc_sacc))*100;
				if (isCong == 0)
				{
					anti_cong_inacc = anti_cong_inacc + 1;
					AntiCongAcc = (Anti_Cong_Trl_number/(Anti_Cong_Trl_number + anti_cong_inacc))*100;
				} else if (isCong == 1)
				{
					anti_icong_inacc = anti_icong_inacc + 1;
					AntiICongAcc = (Anti_ICong_Trl_number/(Anti_ICong_Trl_number + anti_icong_inacc))*100;
				} else if (isCong == 2)
				{
					anti_ccong_inacc = anti_ccong_inacc + 1;
					AntiCCongAcc = (Anti_CCong_Trl_number/(Anti_CCong_Trl_number + anti_ccong_inacc))*100;
				}
			}
			/*
				if (SingMode == 0)
					{				
					rand_inacc_sacc = rand_inacc_sacc + 1;
					}
				else if (SingMode == 1)
					{
					if (DistPres == 1111)
						{
						rand_inacc_sacc_DA = rand_inacc_sacc_DA + 1;
						}
					else if (DistPres == 2222)	
						{
						rand_inacc_sacc_DP = rand_inacc_sacc_DP + 1;
						}
					}	
				}
			
			else
				{
					rep_inacc_sacc = rep_inacc_sacc + 1;
				}
			}	
			*/
			}
		else
			{
			lastWasAbort = 0;
			Comp_Trl_number = Comp_Trl_number;			// THIS IS PLACED INCORRECTLY.  IF THE TRIAL WAS CORRECT BUT UNREWARDED THIS WILL NOT COUNT
			}	
		
		spawnwait FAILURE(trial_length,					// ...give negative reinforcement and wait for iti +  timeout.
				inter_trl_int,
				trl_start_time,
				fixed_trl_length,
				failure_tone,
				punish_time);
						
		
		}
	
	// Calculate accuracy for each type of search trial individually, used to display ACC to user in SCHTRIAL.pro
	
	
	if (SingMode == 0)
		{
		RandPerAcc = (Rand_Comp_Trl_number/(Rand_Comp_Trl_number + rand_inacc_sacc))*100;
		RepPerAcc = (Rep_Comp_Trl_number/(Rep_Comp_Trl_number + rep_inacc_sacc))*100;
		}
	else if (SingMode == 1)
		{
		RandPerAcc_DA = (Rand_Comp_Trl_DA/(Rand_Comp_Trl_DA + rand_inacc_sacc_DA))*100;
		RandPerAcc_DP = (Rand_Comp_Trl_DP/(Rand_Comp_Trl_DP + rand_inacc_sacc_DP))*100;
		RepPerAcc = (Rep_Comp_Trl_number/(Rep_Comp_Trl_number + rep_inacc_sacc))*100;
		}
	//-----------------------------------------------------------------------------------------------------
	// 4) If the animal moved, and we are training stillness, impose a punishment
	while (Move_ct > 0)
		{
		now = time();
		while (time() < now + bmove_tout)
			{
			nexttick;
			}
		Move_ct = Move_ct - 1;
		}
		
	Trl_number = Trl_number + 1;
	
	
	
	}