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
		PROCESS_STATE  = 0;
		STAT_STRT_T    = time();
		STAT_DLTA_T    = 0;
		dsendf("vp %d\n", PG_BLANK);
		spawn GRAF_HIDE_FIX_TARG();
		TRL_IS_TARG_ON_FLAG = 0;
		if (!IS_TRL_LENGTH_FIXED)
		{
			TRL_ITI_DURATION = BASE_ITI_TIME * TIME_DILATE_FACTOR ;
			printf("****STAT_ITI_CHK[%d]: OK TRL_CUM_TIME[%d]\n", STAT_ITI_CHK,TRL_CUM_TIME);
			printf("****STAT_ITI_CHK[%d]: OK IS_TRL_LENGTH_FIXED [%d]; TRL_ITI_DURATION[%d]\n", STAT_ITI_CHK,IS_TRL_LENGTH_FIXED, TRL_ITI_DURATION);
		}
		else
		{
			printf("****STAT_ITI_CHK[%d]: OK TRL_CUM_TIME[%d]\n", STAT_ITI_CHK,TRL_CUM_TIME);
			printf("****STAT_ITI_CHK[%d]: OK; TRL_ITI_DURATION = (TRL_DURATION * TIME_DILATE_FACTOR)  - TRL_CUM_TIME\n");			
			TRL_ITI_DURATION = (TRL_DURATION * TIME_DILATE_FACTOR)  - TRL_CUM_TIME;			
			printf("****STAT_ITI_CHK[%d]: OK; TRL_ITI_DURATION [%d] = (%d * %d) - %d\n",STAT_ITI_CHK,TRL_ITI_DURATION,TRL_DURATION,TIME_DILATE_FACTOR,TRL_CUM_TIME);
			printf("****STAT_ITI_CHK[%d]: OK IS_TRL_LENGTH_FIXED [%d]; TRL_ITI_DURATION[%d]\n", STAT_ITI_CHK,IS_TRL_LENGTH_FIXED, TRL_ITI_DURATION);
		}
		// add any remaining time from tone/reward
		if (TRL_IS_TIMEOUT)
		{
			TRL_TONE_DURATION = TIMEOUT_DURATION + TRL_ITI_DURATION;
			TRL_TONE_FREQ = TIMEOUT_TONE;
			TRL_TIMEOUT_DURATION =   TRL_TIMEOUT_DURATION + 1;
		}
		STAT_ALLOWED_T = TRL_ITI_DURATION;
		TRL_ITI_START_TIME = time();
		spawn SEND_EVT(ITIStart_);
		printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIStart_[%d]\n", STAT_ITI_CHK, ITIStart_);		   
		
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

			//spawn PLAY_WHITE_NOISE(TRL_TONE_DURATION);
			spawn TONE(400,TRL_TONE_DURATION);
		}
	}
	else
	{
		TRL_ITI_END_TIME = time();
		spawn SEND_EVT(ITIEnd_);
		printf("****STAT_ITI_CHK[%d]: OK sent Event: ITIEnd_[%d]\n", STAT_ITI_CHK, ITIEnd_);
		PROCESS_STATE = 1;
		if(TRL_IS_TIMEOUT)
		{	
			PROCESS_STATE = 1;
			TRL_RUNNING = 1;
			CURR_STAT     = STAT_TIM_OUT;
		}
		else
		{
			PROCESS_STATE = 1;
			TRL_RUNNING = 1;
			CURR_STAT     = STAT_IDLE;
		}
	}
} /* PROC_ITI_CHK */
