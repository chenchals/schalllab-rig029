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
        spawn GRAF_HIDE_FIX_TARG();

        TRL_IS_TARG_ON_FLAG = 0;
        // assume IS_TRL_LENGTH_FIXED = 1;
        printf("****STAT_ITI_CHK[%d]: IS_TRL_LENGTH_FIXED [%d]\n", STAT_ITI_CHK, IS_TRL_LENGTH_FIXED);
        TRL_ITI_DURATION = ((TRL_DURATION + BASE_ITI_TIME) * TIME_DILATE_FACTOR) - (time()-TRL_START_TIME);
        if (!IS_TRL_LENGTH_FIXED)
        {
          TRL_ITI_DURATION = BASE_ITI_TIME * TIME_DILATE_FACTOR ;
        }
        // add any remaining time from tone/reward
		if (TRL_IS_TIMEOUT)
		{
			TRL_TONE_DURATION = TIMEOUT_DURATION + TRL_ITI_DURATION;
			TRL_TONE_FREQ = TIMEOUT_TONE;
		}
		STAT_ALLOWED_T = TRL_ITI_DURATION;
        printf("****STAT_ITI_CHK[%d]: OK TRL_ITI_DURATION[%d]\n", STAT_ITI_CHK, TRL_ITI_DURATION);
        
    }
    if(TRL_IS_TIMEOUT)
    {
      TRL_TIMEOUT_DURATION =   TRL_TIMEOUT_DURATION + 1;
    }

    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
       if(TRL_IS_TIMEOUT && !TRL_TIMEOUT_START_TIME)
       {
		 TRL_TIMEOUT_START_TIME = time();
         spawn SEND_EVT(PunishStart_);
         printf("****STAT_ITI_CHK[%d]: OK sent Event: PunishStart_[%d]\n", STAT_ITI_CHK, PunishStart_);
         spawn SEND_EVT(PunishTone_);
         printf("****STAT_ITI_CHK[%d]: OK sent Event: PunishTone_[%d]\n", STAT_ITI_CHK, PunishTone_);
         //spawn TONE(TRL_TONE_FREQ,TRL_TONE_DURATION);
		 spawn PLAY_WHITE_NOISE(TRL_TONE_DURATION);
       }
	   else if(!TRL_IS_TIMEOUT && !TRL_ITI_START_TIME)
	   {
		   TRL_ITI_START_TIME = time();
           spawn SEND_EVT(ITIStart_);
           printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIStart_[%d]\n", STAT_ITI_CHK, ITIStart_);		   
	   }
    }
    else
    {
		if(TRL_IS_TIMEOUT)
		{
			PROCESS_STATE = 1;
			CURR_STAT     = STAT_TIM_OUT;	
		}
		else if(!TRL_IS_TIMEOUT && !TRL_ITI_END_TIME)
		{
			TRL_ITI_END_TIME = time();
			spawn SEND_EVT(ITIEnd_);
			printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIEnd_[%d]\n", STAT_ITI_CHK, ITIEnd_);
			spawn SEND_EVT(TaskEnd_);
			printf("****STAT_ITI_CHK[%d]: OK sent Event: TaskEnd_[%d]\n", STAT_ITI_CHK, TaskEnd_);

			PROCESS_STATE = 0;
			CURR_STAT     = STAT_IDLE;
			TRL_RUNNING = 0;
		}
    }
} /* PROC_ITI_CHK */
