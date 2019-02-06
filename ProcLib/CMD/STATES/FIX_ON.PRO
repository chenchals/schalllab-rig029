//==========================================================================
// FIX_ON.PRO
//   Description: Process Fixspot on State
//                Eye has to acquire fixation within ALLOWED_FIX_TIME.
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


process PROC_FIX_ON()
{
    if (PROCESS_STATE)
    {
        TRL_FIX_VRT_RFRSH_COUNT = 0;
        TRL_START_TIME          = time();
        spawn SEND_EVT(TrialStart_);

        dsendf("vp %d\n", PG_FIXATION_PD);
        dsendf("vw 1\n");
        spawn GRAF_SHOW_FIX(GRAF_SHOW);

        printf("****STAT_FIX_ON[%d]: OK (Trial Started)\n", STAT_FIX_ON);

        PROCESS_STATE  = 0;
        STAT_STRT_T    = TRL_START_TIME;
        STAT_DLTA_T    = 0;
        STAT_ALLOWED_T = ALLOWED_FIX_TIME * TIME_DILATE_FACTOR;
    }

    if (PD_TRIG_L)
    {
        TRL_FIX_VRT_RFRSH_COUNT = TRL_FIX_VRT_RFRSH_COUNT + 1;
        if (TRL_FIX_VRT_RFRSH_COUNT == 1 && !TRL_FIX_ON_TIME)
        {
            // do not send event multiple times
            TRL_FIX_ON_TIME = time();
            spawn SEND_EVT(FixSpotOn_);

            dsendf("vp %d\n", PG_FIXATION);

            printf("****STAT_FIX_ON[%d]: OK (FixSpotOn_)\n", STAT_FIX_ON);
            spawn UPD8_MSG();
        }
    }
    if (!I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
    {
        //?send event abort_?
        //TRL_FIX_ON_TIME = time();???
        spawn SEND_EVT(FixNotAcquired_);

        printf("****STAT_FIX_ON:ERR (Fixation not acquired); Within: ALLOWED_FIX_TIME\n", STAT_FIX_ON);

        PROCESS_STATE = 1;
        CURR_STAT     = STAT_FEEDBACK;
    }
    else if (I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        TRL_FIX_ACQ_TIME = time();
        spawn SEND_EVT(AcquireFix_);

        printf("****STAT_FIX_ON[%d]: OK (Fixation acquired); Within: ALLOWED_FIX_TIME\n", STAT_FIX_ON);

        PROCESS_STATE = 1;
        CURR_STAT     = STAT_FIXATE;
    }
} /* PROC_FIX_ON */
