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
        printf("****STAT_FIX_ON[%d]: Processing Fixspot On\n", STAT_FIX_ON);
        TRL_FIX_VRT_RFRSH_COUNT = 0;

        dsendf("vp %d\n", PG_FIXATION_PD);
        // show for only 1 screen refresh
        dsendf("vw 1\n");

        PROCESS_STATE  = 0;
        STAT_STRT_T    = time();
        STAT_DLTA_T    = 0;
        STAT_ALLOWED_T = ALLOWED_FIX_TIME * TIME_DILATE_FACTOR;
    }

    if (PD_TRIG_L)
    {
        TRL_FIX_VRT_RFRSH_COUNT = TRL_FIX_VRT_RFRSH_COUNT + 1;
        if (TRL_FIX_VRT_RFRSH_COUNT == 1)
        {
            TRL_FIX_ON_TIME = time();
            spawn SEND_EVT(FixSpotOn_);
			spawn GRAF_SHOW_FIX(GRAF_SHOW);

            dsendf("vp %d\n", PG_FIXATION);
            printf("****STAT_FIX_ON[%d]: OK sent Event: FixSpotOn_[%d]\n", STAT_FIX_ON, FixSpotOn_);
        }
    }

    // There is about 13 ms to complete drawing the screen, so eye can still be out
    if (STAT_DLTA_T > ceil(REFRESH_RATE) &&  STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (I_FIX)
        {
            TRL_IS_FIX_ACQUIRED = 1;
            TRL_FIX_ACQ_TIME = time();
            spawn SEND_EVT(AcquireFix_);
			TRL_START_TIME   = time();
			spawn SEND_EVT(TrialStart_);
            printf("****STAT_FIX_ON[%d]: OK sent Event: AcquireFix_[%d], TrialStart_[%d]\n", STAT_FIX_ON, AcquireFix_,TrialStart_);
            printf("****STAT_FIX_ON[%d]: OK (Fixation acquired)[%d]/[%d] (ALLOWED_FIX_TIME)\n", STAT_FIX_ON, STAT_DLTA_T, STAT_ALLOWED_T);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_FIX_HOLD;
        }
    }
    else if (STAT_DLTA_T > STAT_ALLOWED_T)
    {
        if (!I_FIX)
        {
            TRL_IS_FIX_ACQUIRED = 0;
            TRL_FIX_ACQ_ERROR_TIME = time();
            spawn SEND_EVT(AcquireFixError_);

            printf("****STAT_FIX_ON[%d]: ERR sent Event: AcquireFixError_[%d]\n", STAT_FIX_ON, AcquireFixError_);
            printf("****STAT_FIX_ON[%d]: ERR (Fixation not acquired)[%d]/[%d] (ALLOWED_FIX_TIME)\n", STAT_FIX_ON, STAT_DLTA_T, STAT_ALLOWED_T);
			
			// Show blank page for about 3 secs.....No timeout or any tone
			dsendf("vp %d\n", PG_BLANK);
			spawn GRAF_HIDE_FIX_TARG();
			wait(3000);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_IDLE;
        }
    }
} /* PROC_FIX_ON */
