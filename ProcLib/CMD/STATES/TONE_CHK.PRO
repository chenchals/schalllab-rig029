//==========================================================================
// TONE_ST.PRO
//   Description: Process Tone state after Target is acquired
//                Gaze is in TARG_WIN. Check gaze until TONE_DELAY expires and play TONE
//	              depending on gaze and MIN_TARG_HOLD_TIME
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
//   Date: 2019-02-08
//==========================================================================
//  Revision History:

declare PROC_TONE_CHK();


process PROC_TONE_CHK()
{
    // Target acquired, but not fixated yet or eye still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_TONE_CHK[%d]: Processing Tone times\n", STAT_TONE_CHK);
        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;

        // Fixspot is OFF Target is ON:
        // Check: case: MIN_TARG_HOLD_TIME > TONE_DELAY + TONE_DURATION
        //         if gaze in TARG_WIN until TONE_DELAY expires: Play (SUCCESS) TONE, goto STAT_RWRD_CHK
        //         if gaze out of TARG_WIN before TONE_DELAY expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_ABORT
        //        case: MIN_TARG_HOLD_TIME < TONE_DELAY
        //         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Play (SUCCESS) TONE at TONE_DELAY time,
        //                if gaze in TARG_WIN until TONE_DURATION --> goto STAT_RWRD_CHK
        //                if gaze not in TARG_WIN during TONE_DURATION --> compute TIMEOUT_TIME --> goto STAT_ABORT
        //         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_ABORT

        STAT_ALLOWED_T = TONE_DELAY * TIME_DILATE_FACTOR;

        STAT_I_MOVE_DURATION = TONE_DURATION;
        // This is incremented in the CMD_TSK.PRO --> state flow controller
        TRL_TARG_HOLD_DURATION = 0;
    }
    spawnwait CHECK_TARG_VERT_RFRSH();

    if (STAT_DLTA_T <= STAT_DLTA_T)
    {
        if (!I_TARG)
        {
            TRL_TARG_BRK_FIX_PRE_TONE_TIME = time();
            spawn SEND_EVT(TargBrkFixPreTone_);

            printf("****STAT_TONE_CHK[%d]: ERR (*Pre-Tone*Broke Target Fixation*)[%d]\n", STAT_TONE_CHK, STAT_DLTA_T);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_ABORT;
            printf("**********Compute timeout for aborting****************\n");
        }
    }
    else if (STAT_DLTA_T <= STAT_ALLOWED_T + STAT_I_MOVE_DURATION)
    {
        if (!TRL_TONE_ON_TIME)
        {
            spawn TONE(SUCCESS_TONE_SML_REWARD, STAT_I_MOVE_DURATION);
            spawn SEND_EVT(ToneOn_);
        }
        if (!I_TARG && TRL_TARG_BRK_FIX_TONE_TIME)
        {
            TRL_TARG_BRK_FIX_PRE_TONE_TIME = time();
            spawn SEND_EVT(TargBrkFixTone_);

            printf("****STAT_TONE_CHK[%d]: ERR (*During Tone*Broke Target Fixation*)[%d]\n", STAT_TONE_CHK, STAT_DLTA_T);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_ABORT;
            printf("**********Compute timeout for aborting****************\n");
        }
    }
    else if (STAT_DLTA_T > STAT_ALLOWED_T + STAT_I_MOVE_DURATION)
    {
        if (!TRL_TONE_OFF_TIME)
        {
            spawn SEND_EVT(ToneOff_);
        }
				printf("****STAT_TONE_CHK[%d]: OK (*Tone*Target Fixated*)[%d]\n", STAT_TONE_CHK, STAT_DLTA_T);
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_RWRD_CHK;
    }
} /* PROC_TONE_CHK */
