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

// Eyes are anywhere on the screen
declare constant int STAT_IDLE = 0;
//
// Fixspot is NOT ON: Waiting for subj to be ready
// Check: Eyes are hanging around the FIX_WIN_LARGE.
//        Eye has not *crossed* FIX_WIN_LARGE within REDY_T
//        Outcome -->go to (set)--->Next State ------> Action
//        O_REDY      --->   STAT_FIX_ON -----> Show Fixspot
//        O_NOT_REDY  --->   STAT_IDLE  ------> Do not show Fixspot
declare constant int STAT_WAIT_FIX = 1;
// Fixspot is ON: Waiting for subject to reach the fix window and Fixate
// Check: Eyes must get to WITHIN smaller FIX_WIN, BEFORE FIX_ACQ_T expires
//        Outcome -->go to (set)--->Next State
//        O_ACQ_FIX      --->   STAT_FIXATE
//        O_ACQ_FIX_WIDE --->   Timeout? STAT_IDLE
//        O_ACQ_FIX_BRK  --->   Timeout? STAT_IDLE
declare constant int STAT_FIX_ON = 2;
// Fixspot is ON: Waiting for subject to stay on fixspot
// Check: Eyes must be WITHIN smaller FIX_WIN until FIX_TIME (HOLD_TIME) expires
//        Outcome -->go to (set)--->Next State
//        O_FIXATE       --->   STAT_TARG_ON
//        O_FIXATE_WIDE --->   Timeout? STAT_IDLE
//        O_FIXATE_BRK  --->   Timeout? STAT_IDLE
declare constant int STAT_FIXATE = 3;
// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject to shift gaze to target location
// Check: Eyes leave fixspot and reach TARG_WIN or TARG_WIN_ANTI after MIN_SACCADE_TIME and
//        before MAX_SACCADE_TIME, within MAX_SACCADE_DURATION
//        Outcome              -->go to (set)--->Next State
//        O_ACQ_TARG           --->   STAT_FIXATE_TARG
//        O_ACQ_TARG_WIDE      --->   Timeout? next_state? STAT_IDLE?
//        O_ACQ_TARG_ANTI      --->   Timeout? tone? next_state? STAT_IDLE
//        O_ACQ_TARG_WIDE_ANTI --->   Timeout? tome? next_state? STAT_IDLE
//        O_ACQ_TARG_BRK       --->   Timeout? tone? STAT_IDLE
declare constant int STAT_TARG_ON = 4;

// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject to shift gaze to target location and hold
// Check: Eyes leave fixspot and reach TARG_WIN or TARG_WIN_ANTI after MIN_SACCADE_TIME and
//        before MAX_SACCADE_TIME, within MAX_SACCADE_DURATION and stay for TARG_HOLD_TIME
//        Outcome              -->go to (set)--->Next State
//        O_FIXATE_TARG           --->   STAT_FIXATE_TARG
//        O_FIXATE_TARG_WIDE      --->   Timeout? next_state? STAT_IDLE?
//        O_FIXATE_TARG_ANTI      --->   Timeout? tone? next_state? STAT_IDLE
//        O_FIXATE_TARG_WIDE_ANTI --->   Timeout? tome? next_state? STAT_IDLE
//        O_FIXATE_TARG_BRK       --->   Timeout? tone? STAT_IDLE
declare constant int STAT_FIXATE_TARG = 5;


//============== EYE Outcomes=============
declare constant int I_FIX = 0;
