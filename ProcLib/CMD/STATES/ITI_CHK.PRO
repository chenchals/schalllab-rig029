//==========================================================================
// ITI_CHK.PRO
//   Description: Process ITI state
//
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

declare PROC_ITI_CHK();


process PROC_ITI_CHK()
{
    if (PROCESS_STATE)
    {
        printf("****STAT_ITI_CHK[%d]: Processing Inter trial interval\n", STAT_ITI_CHK);
        // Keep independent of previous state times if any.
        PROCESS_STATE  = 0;
        STAT_STRT_T    = time();
        STAT_DLTA_T    = 0;
        dsendf("vp %d\n", PG_BLANK);

        // assume IS_TRL_LENGTH_FIXED = 1;
        printf("****STAT_ITI_CHK[%d]: IS_TRL_LENGTH_FIXED [%d]\n", STAT_ITI_CHK, IS_TRL_LENGTH_FIXED);
        STAT_ALLOWED_T = ((TRL_DURATION - TRL_CUM_TIME) + BASE_ITI_TIME);
        if (!IS_TRL_LENGTH_FIXED)
        {
          STAT_ALLOWED_T = BASE_ITI_TIME ;
        }
        // add any remaining time from tone/reward
        TRL_PUNISH_DURATION = STAT_ALLOWED_T + TRL_PUNISH_DURATION;
        spawn SEND_EVT(ITIStart_);

        printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIStart_[%d]\n", STAT_ITI_CHK, ITIStart_);
         
        TRL_IS_TARG_ON_FLAG = 0;
    }
    if(TIMEOUT_DURATION)
    {
      TRL_PUNISH_DURATION =   TRL_PUNISH_DURATION + 1;
    }

    //TRL_I_IN_FLIGHT  should be true
    // Acquire target
    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
       if(TIMEOUT_DURATION)
       {
         spawn SEND_EVT(PunishStart_);
         printf("****STAT_ITI_CHK[%d]: OK sent Event: PunishStart_[%d]\n", STAT_ITI_CHK, PunishStart_);
         spawn SEND_EVT(PunishTone_);
         printf("****STAT_ITI_CHK[%d]: OK sent Event: PunishTone_[%d]\n", STAT_ITI_CHK, PunishTone_);

         spawn TONE(PUNISH_TONE,TRL_PUNISH_DURATION);
       }
    }
    else
    {
        printf("****STAT_ITI_CHK[%d]: Processing Inter trial interval >>>>>>> Not Yet>>>>>>>>>\n", STAT_ITI_CHK);
        spawn SEND_EVT(ITIEnd_);
        printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIEnd_[%d]\n", STAT_ITI_CHK, ITIEnd_);

        PROCESS_STATE = 1;
        CURR_STAT     = STAT_TIM_OUT;
    }
} /* PROC_ITI_CHK */
