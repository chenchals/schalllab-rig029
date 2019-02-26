//==========================================================================
// FIX_HOLD.PRO
//   Description: Process Hold fixation State
//                Eye has to HOLD fixation for TRL_FIX_HOLD_TIME.
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
//   Date: 2019-01-25
//==========================================================================
//  Revision History:


process PROC_FIX_HOLD()
{
	declare float tempVRcount;
	declare int tempFixHoldAdjust;
	declare int offsetForVdoSync = 4;
	
	if (PROCESS_STATE)
	{
		printf("****STAT_FIX_HOLD[%d]: Processing hold fixation\n", STAT_FIX_HOLD);
		// actually TRL_FIX_ACQ_TIME, however the below is practically
		//same and it keeps this state independent of previous state
		PROCESS_STATE  = 0;
		STAT_STRT_T    = time();
		STAT_DLTA_T    = 0;
		//STAT_ALLOWED_T = TRL_FIX_HOLD_TIME * TIME_DILATE_FACTOR;
		// Dynamically adjust TRL_FIX_HOLD_TIME such that the duration from 
		// TRL_FIX_ON_TIME till the end of TRL_FIX_HOLD_TIME is a multiple of REFRESH_RATE
		// so that we sync all target presentation to vertical retrace (less offsetForVdoSync)
		// variable time when fix is acquired and the length of fix hold time
		tempVRCount = (TRL_FIX_ACQ_TIME - TRL_FIX_ON_TIME + TRL_FIX_HOLD_TIME)*1.0/REFRESH_RATE;
		tempFixHoldAdjust = round(round(tempVRCount)*REFRESH_RATE) + TRL_FIX_ON_TIME - TRL_FIX_ACQ_TIME - TRL_FIX_HOLD_TIME;
		//tempFixHoldAdjust = tempFixHoldAdjust - offsetForVdoSync;
		printf("*************tempVRCount [%8.4d], tempFixHoldAjust = [%d]\n",tempVRCount,tempFixHoldAdjust);
		printf("****STAT_FIX_HOLD[%d]: Adjusting TRL_FIX_HOLD_TIME [%d] by [%d] ms\n",STAT_FIX_HOLD,TRL_FIX_HOLD_TIME,tempFixHoldAdjust);
		//if(!tempFixHoldAdjust)
		//{
			TRL_FIX_HOLD_TIME = TRL_FIX_HOLD_TIME + tempFixHoldAdjust;
		//}
		STAT_ALLOWED_T = TRL_FIX_HOLD_TIME * TIME_DILATE_FACTOR;
	}

	TRL_FIX_HOLD_DURATION = TRL_FIX_HOLD_DURATION + 1;

	if (STAT_DLTA_T < STAT_ALLOWED_T)
	{
		if (!I_FIX )
		{
			TRL_FIX_BRK_TIME = time();
			spawn SEND_EVT(BreakFix_);

			printf("****STAT_FIX_HOLD[%d]: ERR sent Event: BreakFix_[%d]\n", STAT_FIX_HOLD, BreakFix_);
			printf("****STAT_FIX_HOLD[%d]:ERR (Broke fixation)[%d]/[%d] (TRL_FIX_HOLD_TIME)\n", STAT_FIX_HOLD, TRL_FIX_HOLD_DURATION, STAT_ALLOWED_T);
			PROCESS_STATE = 1;
			CURR_STAT     = STAT_OUTCOME;
		}
	}
	else
	{
		if (I_FIX)
		{
			TRL_FIXATED_TIME = time();
			spawn SEND_EVT(Fixate_);

			printf("****STAT_FIX_HOLD[%d]: OK sent Event: Fixate_[%d], Abort_[%d]\n", STAT_FIX_HOLD, Fixate_);
			printf("****STAT_FIX_HOLD[%d]: OK (Fixated)[%d]/[%d] (TRL_FIX_HOLD_TIME)\n", STAT_FIX_HOLD, TRL_FIX_HOLD_DURATION, STAT_ALLOWED_T);
			PROCESS_STATE = 1;
			CURR_STAT     = STAT_TARG_ON;
		}
	}
} /* PROC_FIX_HOLD */
