//--------------------------------------------------------------------------------------------------------------------------
// declare SUCCESS(int trial_length,
				// int inter_trl_int,
				// int trl_start_time,
				// int fixed_trl_length,
				// int success_tone,
				// int tone_duration,
				// int reward_offset,
				// int reward_duration);
// Give primary and secondary reinforcement, set up the variables
// for the next trial, send all trial event codes to plexon, and
// impose the correct inter trial interval.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

#include C:/TEMPO/ProcLib/JUICE.pro
#include C:/TEMPO/ProcLib/SEND_EVT.PRO

declare SUCCESS(int trial_length,						// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int success_tone,
				int tone_duration,
				int reward_offset);

process SUCCESS(int trial_length,						// see DEFAULT.pro and ALL_VARS.pro for explanations of these globals
				int inter_trl_int,
				int trl_start_time,
				int fixed_trl_length,
				int success_tone,
				int tone_duration,
				int reward_offset)
	{
	declare hide int trl_end_time, tone_time;

	declare hide int run_cmd_sess = 1;					// state 1 is countermanding
	declare hide int run_mg_sess = 3;					// state 3 is mem guided sacc
	declare hide int run_gonogo_sess = 4;
	declare hide int run_delayed_sess = 6;
	declare hide int run_search_sess = 7;
	declare hide int run_anti_sess = 9;


	//
	declare hide float decidejuice;
	declare hide int 	go_trl 		= 0;
	declare hide int 	stop_trl 	= 1;
	declare hide int 	ignore_trl 	= 2;

	spawn TONE(success_tone,tone_duration);				// give the secondary reinforcer tone
	tone_time = time();									// record the time

  spawn SEND_EVT(Tone_);

	spawn SEND_EVT(Reward_tone);
	while (time() < tone_time + reward_offset)			// wait until it is OK to give reward
		{
		nexttick;										// wait for it... wait for it...
		}
	//Reward_duration = Reward_duration;	// for setting up 1DR.

	if (State == run_search_sess)
		{
		if (Consec_corr > Consec_trl) // allows us to set how many consec trials before reward given; 0 means single correct trial is all it takes
			{
			spawn JUICE(juice_channel,reward_duration);			// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
			trl_end_time = time();								// record the time b/c this is the end of the trial events

			spawn SEND_EVT(Reward_);

			spawn SEND_EVT(Eot_);
			}
		}

	else
		{
		spawn JUICE(juice_channel,reward_duration);			// YEAH BABY!  THAT'S WHAT IT'S ALL ABOUT!
		trl_end_time = time();								// record the time b/c this is the end of the trial events

		spawn SEND_EVT(Reward_);

		spawn SEND_EVT(Eot_);
		}

	nexttick 2;								// Give TEMPO a chance to catch its breath before attempting..

	// Impose the correct intertrial interval based on user input
	if (fixed_trl_length)								// Did you want a fixed trial length?
		{
		while(time() < trl_start_time + trial_length)	// Then figure out how much time has elapsed since trial start...
			{
			nexttick;									// ...and continue to wait until time is up.
			}
		}
	else												// Did you want a fixed intertrial interval?
		{
		while (time() < trl_end_time + inter_trl_int)	// Then watch the time since trial end...
			{
			nexttick;									// ...and wait until time is up.
			}
		}

		spawnwait INFOS();									// ...queue a big ole` pile-o-strobes for plexon
		nexttick 15;

	  spawn SEND_EVT(EVT_TASK_END_);

// Setup for next trial
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

	}
