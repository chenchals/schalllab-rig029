//==========================================================================
// ITI_CHK.PRO
//   Description: Process ITI state. Compute the TRL_ITI_DURATION based on IS_TRL_LENGTH_FIXED
//                if IS_TRL_LENGTH_FIXED = 1 : Use TRL_DURATION and TRL_CUM_DURATION
//                if IS_TRL_LENGTH_FIXED = 0 : Use BASE_ITI_TIME
//
//                if TRL_IS_TIMEOUT = 0 : Continue processing until TRL_ITI_DURATION expires
//                If TRL_IS_TIMEOUT = 1 : Add TRL_ITI_DURATION to TIMEOUT_DURATION (from OUTCOME.PRO)
//                                        and goto STAT_TIM_OUT for further processing
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
//   Date: 2019-02-13
//==========================================================================
//  Revision History:

declare PROC_ITI_CHK();


process PROC_ITI_CHK()
{
    if (PROCESS_STATE)
    {
        printf("****STAT_ITI_CHK[%d]: Processing Inter trial interval\n", STAT_ITI_CHK);
        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;
        dsendf("vp %d\n", PG_BLANK);
        spawn GRAF_HIDE_FIX_TARG();

        TRL_IS_TARG_ON_FLAG = 0;
        if (!IS_TRL_LENGTH_FIXED)
        {
            TRL_ITI_DURATION = BASE_ITI_TIME * TIME_DILATE_FACTOR;
            printf("****STAT_ITI_CHK[%d]: OK TRL_CUM_DURATION[%d]\n", STAT_ITI_CHK, TRL_CUM_DURATION);
            printf("****STAT_ITI_CHK[%d]: OK IS_TRL_LENGTH_FIXED [%d]; TRL_ITI_DURATION[%d]\n", STAT_ITI_CHK, IS_TRL_LENGTH_FIXED, TRL_ITI_DURATION);
        }
        else
        {
            printf("****STAT_ITI_CHK[%d]: OK TRL_CUM_DURATION[%d]\n", STAT_ITI_CHK, TRL_CUM_DURATION);
            printf("****STAT_ITI_CHK[%d]: OK; TRL_ITI_DURATION = (TRL_DURATION * TIME_DILATE_FACTOR)  - TRL_CUM_DURATION\n");
            TRL_ITI_DURATION = (TRL_DURATION * TIME_DILATE_FACTOR) - TRL_CUM_DURATION;
            printf("****STAT_ITI_CHK[%d]: OK; TRL_ITI_DURATION [%d] = (%d * %d) - %d\n", STAT_ITI_CHK, TRL_ITI_DURATION, TRL_DURATION, TIME_DILATE_FACTOR, TRL_CUM_DURATION);
            printf("****STAT_ITI_CHK[%d]: OK IS_TRL_LENGTH_FIXED [%d]; TRL_ITI_DURATION[%d]\n", STAT_ITI_CHK, IS_TRL_LENGTH_FIXED, TRL_ITI_DURATION);
        }
        STAT_ALLOWED_T = TRL_ITI_DURATION;
    }

    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (TRL_IS_TIMEOUT)
        {
						TIMEOUT_DURATION = TIMEOUT_DURATION + TRL_ITI_DURATION;
            PROCESS_STATE        = 1;
            TRL_RUNNING          = 1;
            CURR_STAT            = STAT_TIM_OUT;
            TRL_END_TIME = time();
            spawn SEND_EVT(Eot_);
            printf("****STAT_ITI_CHK[%d]: **Going to TIME_OUT State** sent Event: Eot_[%d]\n", STAT_ITI_CHK, Eot_);
        }
        else if (TRL_ITI_START_TIME <= 0)
        {
            TRL_ITI_START_TIME = time();
            spawn SEND_EVT(ITIStart_);

            printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIStart_[%d]\n", STAT_ITI_CHK, ITIStart_);
        }
    }
    else
    {
        TRL_ITI_END_TIME = time();
        spawn SEND_EVT(ITIEnd_);

        printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIEnd_[%d]\n", STAT_ITI_CHK, ITIEnd_);

        PROCESS_STATE = 1;
        TRL_RUNNING   = 1;
        CURR_STAT     = STAT_IDLE;
        TRL_END_TIME = time();
        spawn SEND_EVT(Eot_);
        printf("****STAT_ITI_CHK[%d]: **Going to IDLE State** sent Event: Eot_[%d]\n", STAT_ITI_CHK, Eot_);
    }
} /* PROC_ITI_CHK */
