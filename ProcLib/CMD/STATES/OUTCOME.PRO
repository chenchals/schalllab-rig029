//==========================================================================
// OUTCOME.PRO
//  Description: Determine trial outcome and appropriate EXTRA_TIMEOUT_DURATION in ms
//
// See CmdOutcomes.xls file in DOC folder
// EVT_ACQUIRE_FIX_ERROR_ does not result in timeout. This outcome is sent in STATES/FIX_ON.PRO
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| DEF_TRL_TIME_VAR	             | TRL_TIME_VAR_not_0	       | EVENT_SENT	    | OUTCOME_GO_TRIAL | OUTCOME_NOGO_TRIAL_NO_SS | OUTCOME_NOGO_TRIAL_SS |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Fix win before allowed time    |	TRL_ACQUIRE_FIX_ERROR_TIME	     | *EVT_ACQUIRE_FIX_ERROR_	| *EVT_OUTCOME_FIX_ERROR_	| *EVT_OUTCOME_FIX_ERROR_	    | *EVT_OUTCOME_FIX_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Fix win for fix hold time	   | TRL_FIX_BREAK_TIME	       | EVT_FIX_BREAK_	    | EVT_OUTCOME_FIX_BREAK_	| EVT_OUTCOME_FIX_BREAK_	    | EVT_OUTCOME_FIX_BREAK_    |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze out of Fix win before Min sac time	   | TRL_ERLY_SACCADE_TIME	       | EVT_EARLY_SACCADE_	  | EVT_OUTCOME_GO_ERROR_	| EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze in Fix win after Max sac time	     | TRL_NO_SACCADE_TIME	       | EVT_NO_SACCADE_	    | EVT_OUTCOME_GO_ERROR_	| *trial still evolving*  | *trial still evolving* |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Targ win before max sac duration | TRL_ACQUIRE_TARGET_ERROR_TIME	     | EVT_ACQUIRE_TARGET_ERROR_ | EVT_OUTCOME_GO_ERROR_	| EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during tone delay	   | TRL_BRK_PRE_TONE_TIME    | EVT_PRE_TONE_BREAK_ | EVT_OUTCOME_GO_ERROR_	| EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during tone duration	 | TRL_BRK_TONE_TIME	     | EVT_TONE_BREAK_   | EVT_OUTCOME_GO_ERROR_	| EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during reward delay	  | TRL_BRK_PRE_RWRD_TIME	 | EVT_PRE_RWRD_BREAK_ | EVT_OUTCOME_GO_ERROR_	| EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during reward duration	 | TRL_BRK_RWRD_TIME	     | EVT_RWRD_BREAK_   | EVT_OUTCOME_GO_ERROR_	| EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win after reward duration  |                 |           |          |             |            |
//| min target hold time is greater than     | TRL_TARG_BRK_POST_RWRD_TIME   | TargHoldBrkPostRwrd_ | EVT_OUTCOME_GO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_  | EVT_OUTCOME_NOGO_ERROR_   |
//| tone + reward times.	           |                 |           |          |             |            |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze in targ win for min target hold time	 | TRL_XTRA_HOLD_END_TIME	     | EVT_XTRA_HOLD_END_   | EVT_OUTCOME_GO_CORRECT_ | OutcomeNoGoWrongEarly_  | OutcomeNoGoWrong_   |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//
//        All Global variables and the following state variables are available to monitor state progress
//        1. PROCESS_STATE : Setup state processing, will be done once per call
//        1. CURR_STAT :
//        2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//        3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//        4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//        5. STAT_ALLOWED_T : Max time for staying in this state
//        5. STAT_I_DURATION : If saccade occurs, it must complete in this time
//
//  NOTE:
//
//  Author: chenchal.subraveti@vanderbilt.edu
//  Date: 2019-02-13
//==========================================================================
// Revision History:

declare PROC_TRL_OUTCOME();

declare PROC_GO_OUTCOMES();
declare PROC_NOGO_PRE_CANCEL_OUTCOMES();
declare PROC_NOGO_POST_CANCEL_OUTCOMES();


process PROC_TRL_OUTCOME()
{
	declare int doOnce;
	// Target acquired, but not fixated yet or eye still in FixWin
	if (PROCESS_STATE)
	{
		printf("****STAT_OUTCOME[%d]: Processing Trial outcome\n", STAT_OUTCOME);
		// Keep independent of previous state times if any.
		PROCESS_STATE = 0;
		STAT_STRT_T  = time();
		STAT_DLTA_T  = 0;
		STAT_ALLOWED_T = 5;
		dsendf("vp %d\n", PG_BLANK);

		TRL_IS_TARG_ON = 0;

		TIMEOUT_DURATION = 0;
		// set this as default and change to
		// TRL_IS_TIMEOUT = 0; when not error
		TRL_IS_TIMEOUT = 1;
		doOnce = 1;
	}
	// it is big conditional depending on the current trial type and tyep of error

	if(STAT_DLTA_T <= STAT_ALLOWED_T)
	{
		if(doOnce)
		{
			doOnce = 0;
			if (TRL_TRIAL_TYPE == TRIAL_TYPE_GO)
			{
				// Assume it is an error and adjust if not
				TRL_LAST_GO_OUTCOME_EVNTCODE = EVT_OUTCOME_GO_ERROR_;
				SESS_N_GO_ERROR_TRLS = SESS_N_GO_ERROR_TRLS + 1;
				spawn PROC_GO_OUTCOMES();
			}
			else if (TRL_TRIAL_TYPE == TRIAL_TYPE_STOP)
			{
				// Assume it is a non-cancelled error trial and adjust if not
				TRL_LAST_STOP_OUTCOME_EVNTCODE = EVT_OUTCOME_NOGO_ERROR_;
				SESS_N_NOGO_ERROR_TRLS = SESS_N_NOGO_ERROR_TRLS + 1;
				if (TRL_CANCEL_TIME > 0)
				{
					spawn PROC_NOGO_POST_CANCEL_OUTCOMES();
				}
				else
				{
					spawn PROC_NOGO_PRE_CANCEL_OUTCOMES();
				}
			}
		}	
	}
	else
	{
		if (TRL_IS_TIMEOUT > 0)
		{
			if (TRL_TRIAL_TYPE == TRIAL_TYPE_GO)
			{
				TIMEOUT_TONE = GO_ERROR_TONE_HZ;
			}
			else if (TRL_TRIAL_TYPE == TRIAL_TYPE_STOP)
			{
				TIMEOUT_TONE = NOGO_ERROR_TONE_HZ;
			}
		}

		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] TIMEOUT_DURATION [%d] \n", STAT_OUTCOME, TRL_TRIAL_NUMBER, TIMEOUT_DURATION);
		TIMEOUT_DURATION = TIMEOUT_DURATION * TRL_USE_TRIAL_DURATION * TIME_DILATE_FACTOR;
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] (TIMEOUT_DURATION * TRL_USE_TRIAL_DURATION * TIME_DILATE_FACTOR) = [%d] \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, TIMEOUT_DURATION);
		PROCESS_STATE = 1;
		CURR_STAT   = STAT_ITI_CHK;		
	}
} /* PROC_OUTCOME */


process PROC_GO_OUTCOMES()
{
	if (TRL_IS_XTRA_HOLD_DONE > 0)
	{
		TIMEOUT_DURATION = 0;
		TRL_IS_TIMEOUT  = 0;
		spawn SEND_EVT(EVT_OUTCOME_GO_CORRECT_);
		TRL_LAST_GO_OUTCOME_EVNTCODE = EVT_OUTCOME_GO_CORRECT_;
		printf("---GO-CORRECT------GO-CORRECT------GO-CORRECT------GO-CORRECT------GO-CORRECT---\n");
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_CORRECT_ [%d]; Go Trial; (TRL_XTRA_HOLD_END_TIME - OK) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_CORRECT_);

		SESS_N_GO_CORRECT_TRLS = SESS_N_GO_CORRECT_TRLS + 1;
		// Adjust initial assumption that this was a error trial
		SESS_N_GO_ERROR_TRLS = SESS_N_GO_ERROR_TRLS - 1;
		BLOCK_N_CORRECT_TRLS = BLOCK_N_CORRECT_TRLS + 1;
	}
	else if (TRL_FIX_BREAK_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_FIX_BRK[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_FIX_BREAK_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_FIX_BREAK_ [%d]; Go Trial; (TRL_FIX_BREAK_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_FIX_BREAK_);
	}
	else if (TRL_ERLY_SACCADE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_ERLY_SACC[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_ERLY_SACCADE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_NO_SACCADE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_LATE_NO_SACC[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_NO_SACCADE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_ACQUIRE_TARGET_ERROR_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_TARG_ACQ_ERROR[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_ACQUIRE_TARGET_ERROR_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_BRK_PRE_TONE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_TONE[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_BRK_PRE_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_BRK_TONE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_TONE[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_BRK_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_BRK_PRE_RWRD_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_RWRD[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_BRK_PRE_RWRD_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_BRK_RWRD_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_RWRD[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TRL_BRK_RWRD_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
	else if (TRL_IS_XTRA_HOLD_DONE<=0)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_MIN_THT[GO_IDX];
		spawn SEND_EVT(EVT_OUTCOME_GO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_GO_ERROR_ [%d]; Go Trial; (TIMEOUT_BRK_MIN_THT - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_GO_ERROR_);
	}
} /* PROC_GO_OUTCOMES */

// if Eye left fix win Before Cancel time
process PROC_NOGO_PRE_CANCEL_OUTCOMES()
{
	declare int nogoIdx;

	if(TRL_IS_STOP_SIGNAL_ON)
	{
		nogoIdx = NOGO_POST_SSD_IDX;
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: STOP Trial; POST-SSD, PRE_CANCEL\n",STAT_OUTCOME,TRL_TRIAL_NUMBER);
	}
	else
	{
		nogoIdx = NOGO_PRE_SSD_IDX;
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: STOP Trial; PRE-SSD, PRE_CANCEL\n",STAT_OUTCOME,TRL_TRIAL_NUMBER);
	}

	if (TRL_IS_XTRA_HOLD_DONE)
	{
		TRL_IS_NON_CANCELLED = 1;
		TIMEOUT_DURATION = 0;
		TRL_IS_TIMEOUT  = 0;
		spawn SEND_EVT(EVT_OUTCOME_NOGO_NON_CANCELLED_);
		TRL_LAST_STOP_OUTCOME_EVNTCODE = EVT_OUTCOME_NOGO_NON_CANCELLED_;
		printf("---NON-CANCELLED------NON-CANCELLED------NON-CANCELLED------NON-CANCELLED------NON-CANCELLED---\n");
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: **EVT_OUTCOME_NOGO_NON_CANCELLED_** [%d]; TRL_IS_STAIRCASE_SSD [%d]; STOP Trial; (TRL_XTRA_HOLD_END_TIME - OK) \n", 
			STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_NON_CANCELLED_, TRL_IS_STAIRCASE_SSD);

		SESS_N_NON_CANCEL_TRLS = SESS_N_NON_CANCEL_TRLS + 1;
		// Adjust initial assumption that this was a non-cancelled error trial
		SESS_N_NOGO_ERROR_TRLS = SESS_N_NOGO_ERROR_TRLS - 1;
	}
	else if (TRL_FIX_BREAK_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_FIX_BRK[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_FIX_BREAK_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_FIX_BREAK_ [%d]; (TRL_FIX_BREAK_TIME - ERR) \n", 
			STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_FIX_BREAK_);
	}
	else if (TRL_NOGO_EARLY_SACCADE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_ERLY_SACC[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_NOGO_EARLY_SACCADE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_ACQUIRE_TARGET_ERROR_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_TARG_ACQ_ERROR[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_ACQUIRE_TARGET_ERROR_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_NOGO_LATE_SACCADE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_LATE_NO_SACC[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_PRE_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_PRE_TONE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_TONE[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_PRE_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_TONE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_TONE[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_PRE_RWRD_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_RWRD[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_PRE_RWRD_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_RWRD_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_RWRD[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_RWRD_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_IS_XTRA_HOLD_DONE<=0)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_MIN_THT[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; Go Trial; (TIMEOUT_BRK_MIN_THT - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
} /* PROC_NOGO_PRE_CANCEL_OUTCOMES */

// if Eye left fix win After Cancel time
process PROC_NOGO_POST_CANCEL_OUTCOMES()
{
	declare int nogoIdx;
	nogoIdx = NOGO_POST_SSD_IDX;
	printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: STOP Trial; POST-SSD, POST-CANCEL\n",STAT_OUTCOME,TRL_TRIAL_NUMBER);
	if (TRL_IS_FIX_MIN_SSHT > 0)
	{
		TRL_IS_CANCELLED = 1;
		TIMEOUT_DURATION = 0;
		TRL_IS_TIMEOUT  = 0;
		spawn SEND_EVT(EVT_OUTCOME_NOGO_CANCELLED_);
		TRL_LAST_STOP_OUTCOME_EVNTCODE = EVT_OUTCOME_NOGO_CANCELLED_;
		printf("---CANCELLED------CANCELLED------SSD [%d, %dms]------CANCELLED------CANCELLED---\n",TRL_USE_SSD_VR_COUNT, TRL_STOP_SIGNAL_DURATION);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_CANCELLED_ [%d]; TRL_IS_STAIRCASE_SSD  [%d]; STOP Trial; (TRL_IS_TARG_MIN_SSHT - OK) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_CANCELLED_,TRL_IS_STAIRCASE_SSD);

		SESS_N_CANCEL_TRLS = SESS_N_CANCEL_TRLS + 1;
		// Adjust initial assumption that this was a non-cancelled error trial
		SESS_N_NOGO_ERROR_TRLS = SESS_N_NOGO_ERROR_TRLS - 1;
		BLOCK_N_CORRECT_TRLS = BLOCK_N_CORRECT_TRLS + 1;
	}
	else if (TRL_BRK_PRE_TONE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_TONE[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_PRE_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_TONE_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_TONE[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_TONE_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_PRE_RWRD_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_RWRD[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_PRE_RWRD_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_BRK_RWRD_TIME)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_PRE_RWRD[nogoIdx];
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);
		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_BRK_RWRD_TIME - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
	else if (TRL_IS_FIX_MIN_SSHT<=0)
	{
		TIMEOUT_DURATION = TIMEOUT_BRK_MIN_SSHT[nogoIdx];
		TRL_IS_TIMEOUT  = 1;
		spawn SEND_EVT(EVT_OUTCOME_NOGO_ERROR_);

		printf("****STAT_OUTCOME[%d]: TRL_TRIAL_NUMBER[%d] outcome: EVT_OUTCOME_NOGO_ERROR_ [%d]; STOP Trial; (TRL_IS_FIX_MIN_SSHT - ERR) \n",
			 STAT_OUTCOME, TRL_TRIAL_NUMBER, EVT_OUTCOME_NOGO_ERROR_);
	}
} /* PROC_NOGO_POST_CANCEL_OUTCOMES */
