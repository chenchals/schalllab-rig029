//==========================================================================
// TARG_HLD.PRO
//   Description: Process Hold Target fixation State
//                Eye has to has to Acquire target and Hold fixation on target for TARG_HOLD_TIME.
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

declare PROC_TARG_HOLD();

process PROC_TARG_HOLD()
{
    // Target acquired, but not fixated yet or eye still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_TARG_FIXATE[%d]: OK (Check target fixated); Within: TARGET_HOLD_TIME\n", STAT_TARG_FIXATE);

        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;
        // Hold time for target
        STAT_ALLOWED_T = TARGET_HOLD_TIME;
        // Extra variable needed for saccade duration, if late saccade
        STAT_I_MOVE_DURATION = MAX_SACCADE_DURATION * TIME_DILATE_FACTOR;
        TRL_SACC_DURATION    = 0;
    }
    spawnwait CHECK_TARG_VERT_RFRSH();

    // Acquire target
    if (IN_FLIGHT && !IS_TARG_ACQUIRED)
    {
        if (I_TARG && TRL_SACC_DURATION <= STAT_I_MOVE_DURATION)
        {
            IS_TARG_ACQUIRED  = 1;
            STAT_DLTA_T       = 0;
            TRL_TARG_ACQ_TIME = time();
            TRL_DECIDE_TIME   = time();                                //?
            spawn SEND_EVT(AcquireTarget_);
            spawn SEND_EVT(Decide_);

            printf("		CHECK_TARG_ACQUIRED[%d]: OK (AcquireTarget_); Within: MAX_SACC_DURATION[%d]\n", TRL_SACC_DURATION, STAT_I_MOVE_DURATION);
        }
        TRL_SACC_DURATION = TRL_SACC_DURATION + 1;
    }
    if (IS_TARG_ACQUIRED && STAT_DLTA_T < STAT_ALLOWED_T && !I_TARG)
    {
        TRL_TARG_BREAK_FIX_TIME = time();
        spawn SEND_EVT(TargetBreakFix_);

        printf("****STAT_TARG_FIXATE[%d]: ERR (*Broke Target Fixation*); Within: TARG_HOLD_TIME\n", STAT_TARG_FIXATE);

        PROCESS_STATE = 1;
        CURR_STAT     = STAT_FEEDBACK;
    }
    if (STAT_DLTA_T >= STAT_ALLOWED_T)
    {
        if (IS_TARG_ACQUIRED && I_TARG)
        {
            // target fixated
        }
        else if (!I_FIX || !I_TARG)
        {
            TRL_ERROR_SACCADE_TIME = time();
            spawn SEND_EVT(GoError_);                              //??? Check

            // Error saccade?
            printf("		CHECK_TARG_ACQUIRED[%d]:ERR (*Eye elsewhere*); After: MAX_SACC_TIME[%d]\n", STAT_DLTA_T, STAT_ALLOWED_T);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_FEEDBACK;
        }
    }
} /* PROC_TARG_HOLD */
