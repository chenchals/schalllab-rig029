//==========================================================================
// CMD_STAT.PRO
//   Description: Task states for Countermanding. All states are based
//                on EYE POSITION and current TASK PHASE (avoiding saying STATE here)
//                A STATE should ideally know about
//                1. STAT_PREV : State it came from
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_NEXT : Must be able to set NEXT STATE
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-25
//==========================================================================
//  Revision History:
//

declare PROCESS_STATE(constant int state, constant int TimeOffset)

// Current State and Outcome
declare int CURR_STAT;
declare int CURR_OUTCOME;

// Eyes are anywhere on the screen
declare constant int STAT_IDLE = 0;
//
// Fixspot is NOT ON
// Check: Eyes are hanging around the FIX_WIN_LARGE.
//        Eye has not *crossed* FIX_WIN_LARGE within REDY_T
// Outcome -->go to (set)--->Next State ------> Action
//        O_REDY      --->   STAT_READY -----> Show Fixspot
//        O_NOT_REDY  --->   STAT_IDLE  ------> Do not show Fixspot
declare constant int STAT_READY = 1;
// Fixspot is ON;
// Check: Eyes must get to WITHIN smaller FIX_WIN, BEFORE FIX_ACQ_T expires
// Outcome -->go to (set)--->Next State
//        O_ACQ_FIX      --->   STAT_READY
//        O_ACQ_FIX_WIDE --->   Timeout? STAT_IDLE
//        O_ACQ_FIX_BRK  --->   Timeout? STAT_IDLE
declare constant int STAT_FIX_ON = 2;


//============== Outcomes=============
declare constant int O_NOT_REDY = 0;
declare constant int O_REDY = 1;

declare constant int O_ACQ_FIX = 10;
declare constant int O_ACQ_FIX_WIDE = 11;
declare constant int O_ACQ_FIX_BRK = 12;
