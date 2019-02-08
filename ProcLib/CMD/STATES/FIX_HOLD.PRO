//==========================================================================
// FIX_HOLD.PRO
//   Description: Process Hold fixation State
//                Eye has to HOLD fixation for FIX_HOLD_TIME.
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


process PROC_FIX_HOLD()
{
	if (PROCESS_STATE)
	{
		printf("****STAT_FIXATE[%d]: Processing hold fixation\n", STAT_FIXATE);
		// actually TRL_FIX_ACQ_TIME, however the below is practically
		//same and it keeps this state independent of previous state
		PROCESS_STATE  = 0;
		STAT_STRT_T    = time();
		STAT_DLTA_T    = 0;
		STAT_ALLOWED_T = FIX_HOLD_TIME * TIME_DILATE_FACTOR;
	}

	if (!I_FIX && STAT_DLTA_T < STAT_ALLOWED_T)
	{
		TRL_BREAK_FIX_TIME = time();
		spawn SEND_EVT(BreakFix_);
		printf("****STAT_FIXATE[%d]:ERR (Broke fixation)[%d]\n", STAT_FIXATE,STAT_DLTA_T);
		PROCESS_STATE = 1;
		CURR_STAT     = STAT_ABORT;
		printf("**********Compute timeout for aborting****************\n");
	}
	else if (I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
	{
		TRL_FIXATED_TIME = time();
		spawn SEND_EVT(Fixate_);
		printf("****STAT_FIXATE[%d]: OK (Fixated)[%d]\n", STAT_FIXATE,STAT_DLTA_T);
		PROCESS_STATE = 1;
		CURR_STAT     = STAT_TARG_ON;
	}
} /* PROC_FIX_HOLD */
