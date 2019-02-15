//==========================================================================
// TIME_OUT.PRO
//   Description: Process TIMEOUT state
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

declare PROC_TIMEOUT_CHK();


process PROC_TIMEOUT_CHK()
{
	if (PROCESS_STATE)
	{
		printf("****STAT_TIM_OUT[%d]: Processing Timeout interval\n", STAT_TIM_OUT);
		// Keep independent of previous state times if any.
		PROCESS_STATE  = 0;
		STAT_STRT_T    = time();
		STAT_DLTA_T    = 0;
		STAT_ALLOWED_T = TIMEOUT_DURATION;
		printf("Checking if TRL_IS_TARG_ON_FLAG...\n");
		if(TRL_IS_TARG_ON_FLAG)
		{
			dsendf("vp %d\n", PG_BLANK);
			spawn GRAF_HIDE_FIX_TARG();
			TRL_IS_TARG_ON_FLAG = 0;
		}
	}

	if(TRL_IS_TIMEOUT)
	{
		TRL_TIMEOUT_DURATION =   TRL_TIMEOUT_DURATION + 1;
	}

	if (STAT_DLTA_T >= STAT_ALLOWED_T)
	{

		if(!TRL_TIMEOUT_END_TIME)
		{
			TRL_TIMEOUT_END_TIME = time();
			spawn SEND_EVT(PunishEnd_);
			printf("****STAT_TIM_OUT[%d]: ERR sent Event: PunishEnd_[%d]\n", STAT_TIM_OUT, PunishEnd_); 		
			PROCESS_STATE = 1;
			CURR_STAT     = STAT_IDLE;
			TRL_RUNNING = 0;
		}
		printf(":-)\n");
	}
}/*PROC_TIMEOUT_CHK*/
