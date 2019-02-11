//==========================================================================
// GET_REDY.PRO
//   Description: Process GET_REDY State
//                Eye has to wait outside the FIX_WIN_WIDE for the duration of TRL_GET_REDY_TIME.
//                If eye crosses the FIX_WIN_LARGE, the wait time counter resets.
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

declare PROC_GET_REDY();

process PROC_GET_REDY()
{
    if (PROCESS_STATE)
    {
        printf("****STAT_GET_READY[%d]: Processing Get ready\n", STAT_GET_READY);
        printf("****STAT_GET_READY[%d]: Waiting for Eye to be outside FIX_WIN_WIDE\n", STAT_GET_READY);
        TRL_GET_READY_TIME = time();
        spawn SEND_EVT(TrialGetReady_);
        spawn GRAF_SHOW_FIX_WIN();

        TRL_NUMBER = TRL_NUMBER + 1;
        PROCESS_STATE  = 0;
        STAT_STRT_T    = time();
        STAT_DLTA_T    = 0;
        STAT_ALLOWED_T = READY_TIME * TIME_DILATE_FACTOR;
    }
    if (STAT_DLTA_T < STAT_ALLOWED_T && (I_FIX || I_FIX_WIDE))
    {
        STAT_DLTA_T = 0;
    }
    else if ((!I_FIX || !I_FIX_WIDE) && STAT_DLTA_T >= STAT_ALLOWED_T)
    {
        if (!TRL_READY_TIME)
        {
            TRL_READY_TIME = time();
            spawn SEND_EVT(TrialReady_);
        }
        printf("****STAT_GET_READY[%d]: OK (Ready)[%d]\n", STAT_GET_READY,STAT_DLTA_T);

        PROCESS_STATE = 1;
        CURR_STAT     = STAT_FIX_ON;
    }
}
