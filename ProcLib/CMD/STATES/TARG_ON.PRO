//==========================================================================
// TARG_ON.PRO
//   Description: Process Target On State
//                Eye has to HOLD fixation till MIN_SACC_TIME before saccade.
//                If MAX_SACC_TOME expires, then no saccade
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

declare PROC_TARG_ON();


process PROC_TARG_ON()
{
    if (PROCESS_STATE)
    {
        TRL_PRE_TARG_ON_TIME     = time();
        spawn SEND_EVT(TargetPre_);

        dsendf("vp %d\n", PG_TARGET_PD);
        spawn GRAF_SHOW_FIX(GRAF_HIDE);
        spawn GRAF_SHOW_TARG(GRAF_SHOW);

        printf("****STAT_TARG_ON[%d]: Processing Target On\n", STAT_TARG_ON);

        PROCESS_STATE        = 0;
        STAT_STRT_T          = TRL_PRE_TARG_ON_TIME;
        STAT_DLTA_T          = 0;
        STAT_I_MOVE_DURATION = MIN_SACC_TIME * TIME_DILATE_FACTOR;
        STAT_ALLOWED_T       = MAX_SACC_TIME * TIME_DILATE_FACTOR;
    }

    spawnwait CHECK_TARG_VERT_RFRSH();

    if (TRL_TARG_VRT_RFRSH_COUNT == 1 && !TRL_TARG_ON_TIME)
    {
        TRL_TARG_ON_TIME = time();
        spawn SEND_EVT(Target_);
        printf("****STAT_TARG_ON[%d]: Sending Event Target_[%d]\n", STAT_TARG_ON, Target_);

        printf("****STAT_TARG_ON[%d]: Sending Event FixSpotOff_[%d]\n", STAT_TARG_ON, FixSpotOff_);
        spawn SEND_EVT(FixSpotOff_);
    }
    // Before MIN_SACCADE_TIME
    if (STAT_DLTA_T <= STAT_I_MOVE_DURATION)
    {
        if (!I_FIX)
        {
            TRL_I_IN_FLIGHT    = 1;
            TRL_ERLY_SACC_TIME = time();
            spawn SEND_EVT(EarlySaccade_);

            printf("****STAT_TARG_ON[%d]: ERR sent Event: EarlySaccade_[%d]\n", STAT_TARG_ON, EarlySaccade_);
            printf("****STAT_TARG_ON[%d]: ERR (*Early Saccade*)[%d]/[%d] (MIN_SACC_TIME)\n", STAT_TARG_ON, STAT_DLTA_T, STAT_I_MOVE_DURATION);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_OUTCOME;
            printf("**********Compute timeout for aborting****************\n");
        }
    }
    else if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (!I_FIX)
        {
            TRL_I_IN_FLIGHT = 1;
            TRL_SACC_TIME   = time();
            spawn SEND_EVT(Saccade_);

            printf("****STAT_TARG_ON[%d]: OK sent Event: Saccade_[%d]\n", STAT_TARG_ON, Saccade_);
            printf("****STAT_TARG_ON[%d]: OK (Correct Saccade)[%d]/([%d],[%d]) (MAX_SACC_TIME)\n", STAT_TARG_ON, STAT_DLTA_T, STAT_I_MOVE_DURATION, STAT_ALLOWED_T);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_TARG_ACQ;
        }
    }
    else
    {
        if (I_FIX)
        {
            TRL_I_IN_FLIGHT = 0;
            TRL_NO_SACC_TIME = time();
            spawn SEND_EVT(NoSaccade_);
            //spawn SEND_EVT(GoError_);

            printf("****STAT_TARG_ON[%d]: ERR sent Event: NoSaccade_[%d]\n", STAT_TARG_ON, NoSaccade_);
            printf("****STAT_TARG_ON[%d]: ERR (No Saccade)[%d]/[%d] (MAX_SACCADE_TIME)\n", STAT_TARG_ON, STAT_DLTA_T, STAT_ALLOWED_T);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_OUTCOME;
        }
    }
} /* PROC_TARG_ON */
