//==========================================================================
// OUTCOME.PRO
//   Description: Determine trial outcome and appropriate EXTRA_TIMEOUT_DURATION in ms
//
// See CmdOutcomes.xls file in DOC folder
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| DEF_TRL_TIME_VAR	                            | TRL_TIME_VAR_not_0	             | EVENT_SENT	          | OUTCOME_GO_TRIAL  |	OUTCOME_NOGO_TRIAL_NO_SS |  OUTCOME_NOGO_TRIAL_SS |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Fix win before allowed time       |	TRL_FIX_ACQ_ERROR_TIME	         | AcquireFixError_	    | OutcomeFixError_	| OutcomeFixError_	       | OutcomeFixError_       |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Fix win for fix hold time	        | TRL_FIX_HOLD_BRK_TIME	           | BreakFix_	          | OutcomeFixBreak_	| OutcomeFixBreak_	       | OutcomeFixBreak_       |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze out of Fix win before Min sac time	      | TRL_ERLY_SACC_TIME	             | EarlySaccade_	      | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze in Fix win after Max sac time	          | TRL_NO_SACC_TIME	               | NoSaccade_	          | OutcomeGoError_	  | *trial still evolving*	 | *trial still evolving* |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Targ win before max sac duration	| TRL_TARG_ACQ_ERROR_TIME	         | AcquireTargetError_  | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during tone delay	      | TRL_TARG_HOLD_BRK_PRE_TONE_TIME  | TargHoldBrkPreTone_  | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during tone duration	    | TRL_TARG_HOLD_BRK_TONE_TIME	     | TargHoldBrkTone_     | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during reward delay	    | TRL_TARG_HOLD_BRK_PRE_RWRD_TIME	 | TargHoldBrkPreRwrd_  | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during reward duration	  | TRL_TARG_HOLD_BRK_RWRD_TIME	     | TargHoldBrkRwrd_     | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win after reward duration    |                                  |                      |                   |                          |                        |
//| min target hold time is greater than          | TRL_TARG_HOLD_BRK_POST_RWRD_TIME | TargHoldBrkPostRwrd_ | OutcomeGoError_   | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//| tone + reward times.	                        |                                  |                      |                   |                          |                        |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze in targ win for min target hold time	    | TRL_TARG_HOLD_MIN_THT_TIME	     | TargHoldMinTHT_      | OutcomeGoCorrect_ | OutcomeNoGoWrongEarly_	 | OutcomeNoGoWrong_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
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
//   Date: 2019-02-13
//==========================================================================
//  Revision History:

declare PROC_TRL_OUTCOME();

declare PROC_GO_OUTCOMES();
declare PROC_NOGO_NO_SS_OUTCOMES();
declare PROC_NOGO_SS_OUTCOMES();


process PROC_TRL_OUTCOME()
{
    // Target acquired, but not fixated yet or eye still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_OUTCOME[%d]: Processing Trial outcome\n", STAT_OUTCOME);
        // Keep independent of previous state times if any.
        PROCESS_STATE  = 0;
        STAT_STRT_T    = time();
        STAT_DLTA_T    = 0;
        STAT_ALLOWED_T = 2;
        dsendf("vp %d\n", STAT_OUTCOME, TRL_NUMBER, PG_BLANK);

        TRL_IS_TARG_ON_FLAG = 0;
        
        TIMEOUT_DURATION    = 0;
    }
    // it is big conditional depending on the current trial type and tyep of error

		if (TRIAL_TYPE == TRIAL_TYPE_GO)
		{
			spawnwait PROC_GO_OUTCOMES();
		}
		else if (TRIAL_TYPE == TRIAL_TYPE_STOP)
		{
			if (TRL_IS_STOP_SIGNAL_ON)
			{
				spawnwait PROC_NOGO_SS_OUTCOMES();
			}
			else
			{
				spawnwait PROC_NOGO_NO_SS_OUTCOMES();
			}
		}
		printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] TIMEOUT_DURATION [%d] \n", STAT_OUTCOME, TRL_NUMBER, TIMEOUT_DURATION);
		TIMEOUT_DURATION = TIMEOUT_DURATION * TRL_DURATION * TIME_DILATE_FACTOR;
		printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] (TIMEOUT_DURATION * TRL_DURATION * TIME_DILATE_FACTOR) = [%d] \n", STAT_OUTCOME, TRL_NUMBER, TIMEOUT_DURATION);
		if(TIMEOUT_DURATION > 0)
		{
			TRL_IS_TIMEOUT = 1;
		}
		// determine this in the other procs:PROC_GO_OUTCOMES
		TIMEOUT_TONE = FAILURE_TONE_SML_TIMEOUT;
		PROCESS_STATE    = 1;
		CURR_STAT        = STAT_ITI_CHK;

} /* PROC_OUTCOME */


process PROC_GO_OUTCOMES()
{
    if (TRL_IS_TARG_HOLD_MIN_THT)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = 0;
        spawn SEND_EVT(OutcomeGoCorrect_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoCorrect_ [%d]; Go Trial; (TRL_TARG_HOLD_MIN_THT_TIME - OK) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoCorrect_);
    }
    else if (TRL_FIX_ACQ_ERROR_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_FIX_ACQ_ERROR[0];
        spawn SEND_EVT(OutcomeFixError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeFixError_ [%d]; Go Trial; (TRL_FIX_ACQ_ERROR_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeFixError_);
    }
    else if (TRL_FIX_HOLD_BRK_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_FIX_HOLD_BRK[0];
        spawn SEND_EVT(OutcomeFixBreak_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeFixBreak_ [%d]; Go Trial; (TRL_FIX_HOLD_BRK_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeFixBreak_);
    }
    else if (TRL_ERLY_SACC_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_ERLY_SACC[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_ERLY_SACC_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_NO_SACC_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_NO_SACC[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_NO_SACC_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_TARG_ACQ_ERROR_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_ACQ_ERROR[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_TARG_ACQ_ERROR_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_PRE_TONE_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_TONE[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_TARG_HOLD_BRK_PRE_TONE_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_TONE_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_TONE[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_TARG_HOLD_BRK_TONE_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_PRE_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_RWRD[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_TARG_HOLD_BRK_PRE_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_RWRD[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_TARG_HOLD_BRK_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_POST_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_POST_RWRD[0];
        spawn SEND_EVT(OutcomeGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeGoError_ [%d]; Go Trial; (TRL_TARG_HOLD_BRK_POST_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeGoError_);
    }
} /* PROC_GO_OUTCOMES */


process PROC_NOGO_NO_SS_OUTCOMES()
{
    if (TRL_IS_TARG_HOLD_MIN_THT)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_MIN_THT[1];
        spawn SEND_EVT(OutcomeNoGoWrongEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoWrongEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_HOLD_MIN_THT_TIME - OK) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoWrongEarly_);
    }
    else if (TRL_FIX_ACQ_ERROR_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_FIX_ACQ_ERROR[1];
        spawn SEND_EVT(OutcomeFixError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeFixError_ [%d]; STOP Trial; No Stop Signal; (TRL_FIX_ACQ_ERROR_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeFixError_);
    }
    else if (TRL_FIX_HOLD_BRK_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_FIX_HOLD_BRK[1];
        spawn SEND_EVT(OutcomeFixBreak_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeFixBreak_ [%d];  No Stop Signal; (TRL_FIX_HOLD_BRK_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeFixBreak_);
    }
    else if (TRL_ERLY_SACC_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_ERLY_SACC[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_ERLY_SACC_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
    //else if (TRL_NO_SACC_TIME)
    //{//process for GO, NOGO_NO_SS, NOGO_SS
    //    TIMEOUT_DURATION = TIMEOUT_NO_SACC[1];
    //    spawn SEND_EVT(OutcomeNoGoErrorEarly_);
    //
    //    printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_NO_SACC_TIME - OK) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    //}
    else if (TRL_TARG_ACQ_ERROR_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_ACQ_ERROR[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_ACQ_ERROR_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
    else if (TRL_TARG_HOLD_BRK_PRE_TONE_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_TONE[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_HOLD_BRK_PRE_TONE_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
    else if (TRL_TARG_HOLD_BRK_TONE_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_TONE[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_HOLD_BRK_TONE_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
    else if (TRL_TARG_HOLD_BRK_PRE_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_RWRD[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_HOLD_BRK_PRE_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
    else if (TRL_TARG_HOLD_BRK_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_RWRD[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_HOLD_BRK_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
    else if (TRL_TARG_HOLD_BRK_POST_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_POST_RWRD[1];
        spawn SEND_EVT(OutcomeNoGoErrorEarly_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoErrorEarly_ [%d]; STOP Trial; No Stop Signal; (TRL_TARG_HOLD_BRK_POST_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoErrorEarly_);
    }
} /* PROC_NOGO_NO_SS_OUTCOMES */


process PROC_NOGO_SS_OUTCOMES()
{
    if (TRL_IS_TARG_HOLD_MIN_THT)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_MIN_THT[2];
        spawn SEND_EVT(OutcomeNoGoWrong_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoWrong_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_HOLD_MIN_THT_TIME - OK) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoWrong_);
    }
    else if (TRL_FIX_ACQ_ERROR_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_FIX_ACQ_ERROR[2];
        spawn SEND_EVT(OutcomeFixError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeFixError_ [%d]; STOP Trial; Stop Signal; (TRL_FIX_ACQ_ERROR_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeFixError_);
    }
    else if (TRL_FIX_HOLD_BRK_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_FIX_HOLD_BRK[2];
        spawn SEND_EVT(OutcomeFixBreak_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeFixBreak_ [%d];  STOP Trial; Stop Signal; (TRL_FIX_HOLD_BRK_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeFixBreak_);
    }
    else if (TRL_ERLY_SACC_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_ERLY_SACC[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_ERLY_SACC_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
    //else if (TRL_NO_SACC_TIME)
    //{//process for GO, NOGO_NO_SS, NOGO_SS
    //    TIMEOUT_DURATION = TIMEOUT_NO_SACC[2];
    //    spawn SEND_EVT(OutcomeNoGoError_);
    //
    //    printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; No Stop Signal; (TRL_NO_SACC_TIME - OK) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    //}
    else if (TRL_TARG_ACQ_ERROR_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_ACQ_ERROR[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_ACQ_ERROR_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_PRE_TONE_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_TONE[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_HOLD_BRK_PRE_TONE_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_TONE_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_TONE[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_HOLD_BRK_TONE_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_PRE_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_RWRD[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_HOLD_BRK_PRE_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_PRE_RWRD[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_HOLD_BRK_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
    else if (TRL_TARG_HOLD_BRK_POST_RWRD_TIME)
    {//process for GO, NOGO_NO_SS, NOGO_SS
        TIMEOUT_DURATION = TIMEOUT_TARG_HOLD_BRK_POST_RWRD[2];
        spawn SEND_EVT(OutcomeNoGoError_);

        printf("****STAT_OUTCOME[%d]: TRL_NUMBER[%d] outcome: OutcomeNoGoError_ [%d]; STOP Trial; Stop Signal; (TRL_TARG_HOLD_BRK_POST_RWRD_TIME - ERR) \n", STAT_OUTCOME, TRL_NUMBER, OutcomeNoGoError_);
    }
} /* PROC_NOGO_SS_OUTCOMES */
