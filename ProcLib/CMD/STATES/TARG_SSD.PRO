//==========================================================================
// TARG_SSD.PRO
//   Description: Process Target On State for STOP Trial
//                Eye has to HOLD fixation till TRL_STOP_SIGNAL_DELAY, and TRL_IS_STOP_SIGNAL_ON.
//                If Gaze out of Fix win before time expires, then TRL_IS_NON_CANCELLED
//
//                All Global variables and the following state variables are available to monitor state progress
//                1. PROCESS_STATE : Setup state processing, will be done once per call
//                1. CURR_STAT :
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_ALLOWED_T : Max time for staying in this state
//                5. STAT_I_MOVE_DURATION : If saccade occurs, it must complete in this time
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-25
//==========================================================================
//  Revision History:

declare PROC_TARG_SSD();


process PROC_TARG_SSD()
{
	if (PROCESS_STATE)
	{
		TRL_PRE_TARG_ON_TIME = time();
		spawn SEND_EVT(TargetPre_);

		dsendf("vp %d\n", PG_TARGET_PD);
		spawn GRAF_SHOW_FIX(GRAF_HIDE);
		spawn GRAF_SHOW_TARG(GRAF_SHOW);

		printf("****STAT_TARG_SSD[%d]: STOP TRIAL Processing Target On SSD\n", STAT_TARG_SSD);
		TRL_IS_STOP_SIGNAL_ON = 0;
		PROCESS_STATE = 0;
		STAT_DLTA_T = 0;
		STAT_STRT_T   = TRL_PRE_TARG_ON_TIME;
		STAT_ALLOWED_T = ceil(TRL_STOP_SIGNAL_DELAY * REFRESH_RATE * TIME_DILATE_FACTOR);
	}

	spawnwait CHECK_TARG_VERT_RFRSH();
	if(!TRL_IS_STOP_SIGNAL_ON && TRL_TARG_VRT_RFRSH_COUNT > 0)
	{
		TRL_STOP_SIGNAL_DURATION = TRL_STOP_SIGNAL_DURATION + 1;
	}
	if (TRL_TARG_VRT_RFRSH_COUNT == 1 && !TRL_TARG_ON_TIME)
	{
		TRL_TARG_ON_TIME = time();
		printf("****STAT_TARG_SSD[%d]: Sending Event Target_[%d]\n", STAT_TARG_SSD, TRL_TARG_ON_TIME);
		spawn SEND_EVT(Target_);

		printf("****STAT_TARG_SSD[%d]: Sending Event FixSpotOff_[%d]\n", STAT_TARG_SSD, TRL_TARG_ON_TIME);
		spawn SEND_EVT(FixSpotOff_);
	}
	if (!TRL_STOP_SIGNAL_TIME && TRL_IS_STOP_SIGNAL_ON)
	{
		TRL_TARG_SSD_VRT_RFRSH_COUNT = TRL_TARG_VRT_RFRSH_COUNT;
		TRL_STOP_SIGNAL_TIME = time();
		spawn SEND_EVT(StopSignal_);
		spawn GRAF_SHOW_FIX(GRAF_SHOW);

		printf("****STAT_FIX_ON[%d]: OK sent Event: StopSignal_[%d]\n", STAT_FIX_ON, StopSignal_);
	}

	if (STAT_DLTA_T <= STAT_ALLOWED_T)
	{
		if (!I_FIX)
		{
			TRL_I_IN_FLIGHT = 1;
			TRL_SACC_TIME   = time();
			spawn SEND_EVT(Saccade_);

			printf("********LATE SACCADE?????********LATE SACCADE?????********LATE SACCADE????? for STOP TRIAL????\n");
			printf("****STAT_TARG_SSD[%d]: ERR STOP TRIAL; sent Event: Saccade_[%d]\n", STAT_TARG_SSD, Saccade_);
			printf("****STAT_TARG_SSD[%d]: ERR STOP TRIAL; (Error Saccade in STOP trial)[%d]/([%d],[%d]) (MAX_SACC_TIME)\n", STAT_TARG_SSD, STAT_DLTA_T, STAT_I_MOVE_DURATION, STAT_ALLOWED_T);
			PROCESS_STATE = 1;
			CURR_STAT     = STAT_TARG_ACQ;
		}
	}
	else
	{
		if (!TRL_IS_STOP_SIGNAL_ON)
		{
			printf("****STAT_TARG_SSD[%d]: OK STOP TRIAL; STAT_DLTA_T [%d] / TRL_STOP_SIGNAL_DELAY[%d] \n", STAT_TARG_SSD, STAT_DLTA_T,TRL_STOP_SIGNAL_DELAY );
			printf("****STAT_TARG_SSD[%d]: OK STOP TRIAL; STAT_DLTA_T [%d] / TRL_STOP_SIGNAL_DELAY * REFRESH_RATE * TIME_DILATE_FACTOR [%d] \n", STAT_TARG_SSD, STAT_DLTA_T, STAT_ALLOWED_T );
			printf("****STAT_TARG_SSD[%d]: Actual Delay   = TRL_TARG_VRT_RFRSH_COUNT[%d, %dms] \n", STAT_TARG_SSD, TRL_TARG_VRT_RFRSH_COUNT);
			printf("****STAT_TARG_SSD[%d]: Actual Delay   = TRL_STOP_SIGNAL_DURATION[%d, %dms] \n", STAT_TARG_SSD, TRL_STOP_SIGNAL_DURATION);
			printf("****STAT_TARG_SSD[%d]: Actual Delay   = TRL_TARG_ON_DURATION [%dms]  \n", STAT_TARG_SSD, TRL_TARG_ON_DURATION);

			dsendf("vp %d\n", PG_SIGNAL_PD);
			// show for only 1 screen refresh
			//dsendf("vw 1\n");
			//dsendf("vp %d\n", PG_SIGNAL);
			printf("****STAT_TARG_SSD[%d]: OK STOP TRIAL; Sent PG_SIGNAL_PD \n", STAT_TARG_SSD);
			printf("****STAT_TARG_SSD[%d]: OK STOP TRIAL; Sent PG_SIGNAL_PD \n", STAT_TARG_SSD);
		}

		if (TRL_IS_STOP_SIGNAL_ON)
		{
			printf("****STAT_TARG_SSD[%d]: OK STOP TRIAL; \n", STAT_TARG_SSD, TRL_STOP_SIGNAL_DELAY, (TRL_STOP_SIGNAL_DELAY * REFRESH_RATE));
			printf("****STAT_TARG_SSD[%d]: Expected Delay = TRL_STOP_SIGNAL_DELAY[%d, %dms]\n", STAT_TARG_SSD, TRL_STOP_SIGNAL_DELAY, ceil(TRL_STOP_SIGNAL_DELAY * REFRESH_RATE));
			printf("****STAT_TARG_SSD[%d]: Actual Delay   = TRL_TARG_VRT_RFRSH_COUNT[%d, %dms],  \n", STAT_TARG_SSD, TRL_TARG_VRT_RFRSH_COUNT, ceil(TRL_TARG_VRT_RFRSH_COUNT * REFRESH_RATE));
			printf("****STAT_TARG_SSD[%d]: Actual Delay   = TRL_STOP_SIGNAL_DURATION[%d, %dms],  \n", STAT_TARG_SSD, TRL_TARG_VRT_RFRSH_COUNT, TRL_STOP_SIGNAL_DURATION);
			printf("****STAT_TARG_SSD[%d]: Actual Delay   = TRL_TARG_ON_DURATION [%dms],  \n", STAT_TARG_SSD, TRL_TARG_ON_DURATION);
			if (I_FIX)
			{
				TRL_I_IN_FLIGHT  = 0;
				TRL_NO_SACC_TIME = time();
				spawn SEND_EVT(NoSaccade_);

				printf("****STAT_TARG_SSD[%d]: OK STOP TRIAL; sent Event: NoSaccade_[%d]\n", STAT_TARG_SSD, NoSaccade_);
				PROCESS_STATE = 1;
				CURR_STAT     = STAT_TONE_CHK;
			}
			else
			{
				// broke fix...
				printf("****STAT_TARG_SSD[%d]:.....ERR STOP TRIAL; Broke fix before tone?.......(((((((NOT YET.... Confused)))))))");
				PROCESS_STATE = 1;
				CURR_STAT     = STAT_TARG_ACQ;
			}
		}


	}

} /* PROC_TARG_ON */
