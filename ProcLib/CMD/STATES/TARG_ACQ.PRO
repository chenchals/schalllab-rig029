//==========================================================================
// TARG_ACQ.PRO
//   Description: Process Acquire Target State
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
//   Date: 2019-02-08
//==========================================================================
//  Revision History:

declare PROC_TARG_ACQ();


process PROC_TARG_ACQ()
{
    // Target acquired, but not fixated yet or eye still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_TARG_ACQ[%d]: Processing Target acquisition\n", STAT_TARG_ACQ);
        // Keep independent of previous state times if any.
        PROCESS_STATE  = 0;
        STAT_STRT_T    = time();
        STAT_DLTA_T    = 0;
        STAT_ALLOWED_T = MAX_SACC_DURATION * TIME_DILATE_FACTOR;

        TRL_SACC_DURATION      = 0;
        TRL_TARG_HOLD_DURATION = 0;
    }
    spawnwait CHECK_TARG_VERT_RFRSH();

    //TRL_I_IN_FLIGHT  should be true
    // Acquire target
    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        TRL_SACC_DURATION = TRL_SACC_DURATION + 1;
        if (I_TARG)
        {
            TRL_IS_TARG_ACQUIRED = 1;
            TRL_TARG_ACQ_TIME    = time();
            TRL_DECIDE_TIME      = time();
            spawn SEND_EVT(AcquireTarget_);
            spawn SEND_EVT(Decide_);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_TONE_CHK;

            printf("****STAT_TARG_ACQ[%d]: OK sent Event: AcquireTarget_[%d], Decide_[%d]\n", STAT_TARG_ACQ, AcquireTarget_, Decide_);
            printf("****STAT_TARG_ACQ[%d]: OK (AcquireTarget_ in)[%d]/[%d](MAX_SACC_DURATION)\n", STAT_TARG_ACQ, TRL_SACC_DURATION, STAT_ALLOWED_T);
        }
    }
    else
    {
        if (!I_TARG)
        {
            TRL_IS_TARG_ACQUIRED    = 0;
            TRL_TARG_ACQ_ERROR_TIME = time();
            spawn SEND_EVT(AcquireTargetError_);
            //spawn SEND_EVT(GoError_);

            // Error saccade?
            printf("****STAT_TARG_ACQ[%d]: ERR sent Event: AcquireTargetError_[%d]\n", STAT_TARG_ACQ, AcquireTargetError_);
            printf("****STAT_TARG_ACQ[%d]: ERR (*Eye elsewhere* in)[%d]/[%d](MAX_SACC_DURATION)\n", STAT_TARG_ACQ, TRL_SACC_DURATION, STAT_ALLOWED_T);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_OUTCOME;
            printf("**********Compute timeout for aborting****************\n");
        }
    }
} /* PROC_TARG_ACQ */
