//==========================================================================
// RFIX_CHK.PRO
//   Description: Process Check Refix
//                Eye has to has to Acquire target before MAX_SACCADE_DURATION.
//
//                All Global variables and the following state variables are available to monitor state progress
//                1. PROCESS_STATE : Setup state processing, will be done once per call
//                1. CURR_STAT :
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_ALLOWED_T : Max time for staying in this state
//                5. STAT_I_DURATION : If saccade occurs, it must complete in this time
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-04-01
//==========================================================================
//  Revision History:

declare PROC_REFIX_CHK();


process PROC_REFIX_CHK()
{
    // Target- Eye left target window during targ-hold onwards for Stop trial
    if (PROCESS_STATE)
    {
        printf("****STAT_REFIX_CHK[%d]: Processing Target acquisition\n", STAT_REFIX_CHK);
        // Keep independent of previous state times if any.
        PROCESS_STATE  = 0;
        STAT_STRT_T    = time();
        STAT_DLTA_T    = 0;
        STAT_ALLOWED_T = MAX_SACC_DURATION * TIME_DILATE_FACTOR;
        // initialize durations
        TRL_REFIX_SACC_DURATION = 0;
        TRL_IS_REFIX      = 0;
    }

    if (TRL_TRIAL_TYPE == TRIAL_TYPE_GO)
    {
        printf("****STAT_REFIX_CHK[%d]: GO Trial; Not checking REFIX\n", STAT_REFIX_CHK);
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_OUTCOME;
    }
    else
    {
        if (STAT_DLTA_T <= STAT_ALLOWED_T)
        {
            TRL_REFIX_SACC_DURATION = TRL_REFIX_SACC_DURATION + 1;
            if (I_FIX)
            {
                TRL_IS_REFIX   = 1;
                TRL_REFIX_TIME = time();
                spawn SEND_EVT(EVT_REFIX_);

                printf("****STAT_REFIX_CHK[%d]: ERR sent Event: EVT_REFIX_[%d]\n", STAT_REFIX_CHK, EVT_REFIX_);
                printf("****STAT_REFIX_CHK[%d]: ERR (EVT_REFIX_ in)[%d]/[%d](MAX_SACC_DURATION)\n", STAT_REFIX_CHK, TRL_REFIX_SACC_DURATION, STAT_ALLOWED_T);

                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
        else
        {
            printf("****STAT_REFIX_CHK[%d]: ERR (*Eye elsewhere* in)[%d]/[%d](MAX_SACC_DURATION)\n", STAT_REFIX_CHK, TRL_REFIX_SACC_DURATION, STAT_ALLOWED_T);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_OUTCOME;
        }
    }
} /* PROC_REFIX_CHK */
