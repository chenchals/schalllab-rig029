//==========================================================================
// CMD_STAT.PRO
//   Description: Task states for Countermanding. All states are based
//                on EYE POSITION and current TASK PHASE (avoiding saying STATE here)
//                A STATE should ideally know about
//                1. CURR_STAT : State in currently
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
//  001: 2019/01/31 chenchal subraveti
//       Have to redifine the outcomes descriptions
//       Added STAT_TEST, STAT_TARG_ON, STAT_TARG_ACQ
//       Updated STAT vars for processing saccade


//Current State variables in the absence of structs
declare int CURR_STAT;
declare int STAT_STRT_T;
declare int STAT_STP_T;
declare int STAT_DLTA_T;
declare int STAT_ALLOWED_T;
declare int STAT_I_MOVE_DURATION;


//
declare constant int STAT_TEST = 99;
// Eyes are anywhere on the screen
declare constant int STAT_IDLE = 0;

// Fixspot is NOT ON: Waiting for subj to be ready
// Check: Eyes are hanging around the FIX_WIN_LARGE.
//        Eye has not *crossed* FIX_WIN_LARGE within REDY_T
declare constant int STAT_GET_READY = 1;

// Fixspot is ON: Waiting for subject to reach the fix window and Fixate
// Check: Eyes must get to WITHIN smaller FIX_WIN, BEFORE FIX_ACQ_T expires
declare constant int STAT_FIX_ON = 2;

// Fixspot is ON: Waiting for subject to stay on fixspot
// Check: Eyes must be WITHIN smaller FIX_WIN until FIX_TIME (HOLD_TIME) expires
declare constant int STAT_FIXATE = 3;

// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject to hold gaze till MIN_MAX_SACCADE_TIME[0]
// Check: Eyes in FIX window till MIN_SACCADE_TIME, else it is early saccade
declare constant int STAT_TARG_ON = 4;

// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject to shift gaze to target location and hold
// Check: Eyes leave fixspot and reach TARG_WIN or TARG_WIN_ANTI after MIN_SACCADE_TIME and
//        before MAX_SACCADE_TIME, within MAX_SACCADE_DURATION
declare constant int STAT_TARG_ACQ = 5;

// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject Fixate target hold for TARGET_HOLD_TIME
// Check: Eyes IN TARG_WIN for duration of TARGET_HOLD_TIME, else it is an error
//        If eye not in flight, and eye leaves Fix window, then Late saccade,
//            check for saccade duration and target acquisition, in late saccade
declare constant int STAT_TARG_FIXATE = 6;

//
declare constant int STAT_TONE = 7;
