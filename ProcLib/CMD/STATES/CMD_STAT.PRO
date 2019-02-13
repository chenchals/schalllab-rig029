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
// Check: Gaze hanging around the FIX_WIN_LARGE.
//        Gaze has not *crossed* FIX_WIN_LARGE within REDY_T
declare constant int STAT_GET_READY = 1;

// Fixspot is ON: Waiting for subject to reach the fix window and Fixate
// Check: Gaze within FIX_WIN, before ALLOWED_FIX_TIME
declare constant int STAT_FIX_ON = 2;

// Fixspot is ON: Waiting for subject to stay on fixspot
// Check: Gaze within FIX_WIN until FIX_HOLD_TIME expires
declare constant int STAT_FIX_HOLD = 3;

// Fixspot is OFF Target is ON:
// Check: Gaze in FIX window until MIN_SACCADE_TIME expires, else it is early saccade
//        Gaze left FIX_WIN before MAX_SACCADE_TIME, then correct saccade, else no saccade
declare constant int STAT_TARG_ON = 4;

// Fixspot is OFF Target is ON:
// Check: Gaze in TARG_WIN before MAX_SACCADE_DURATION
declare constant int STAT_TARG_ACQ = 5;

// Fixspot is OFF Target is ON:
// Check:
//   case 0: MIN_TARG_HOLD_TIME <= TONE_DELAY
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Play (SUCCESS) TONE at TONE_DELAY time
//   case 1: MIN_TARG_HOLD_TIME <= TONE_DELAY + TONE_DURATION
//         if gaze in TARG_WIN until RWRD_DURATION --> (SUCCESS-tone alredey delivered), goto STAT_RWRD_CHK
//         if gaze not in TARG_WIN during RWRD_DURATION --> (SUCCESS-tone alredey delivered), compute TIMEOUT_TIME --> goto STAT_OUTCOME
//   case 2: MIN_TARG_HOLD_TIME > TONE_DELAY + TONE_DURATION
//         Goto next state (reward already delivered), goto STAT_RWRD_CHK
declare constant int STAT_TONE_CHK = 6;

// Fixspot is OFF Target is ON:
// Check:
//   case 0: MIN_TARG_HOLD_TIME <= RWRD_DELAY
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: No Reward, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Deliver reward at RWRD_DELAY time
//   case 1: MIN_TARG_HOLD_TIME <= RWRD_DELAY + RWRD_DURATION
//                if gaze in TARG_WIN until RWRD_DURATION --> (reward alredey delivered), goto STAT_ITI_CHK
//                if gaze not in TARG_WIN during RWRD_DURATION --> (reward already delivered) compute TIMEOUT_TIME --> goto STAT_TIM_OUT
//   case 2: MIN_TARG_HOLD_TIME > RWRD_DELAY + RWRD_DURATION
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: (reward already delivered), goto STAT_ITI_CHK
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: (reward already delivered), compute TIMEOUT_TIME, goto STAT_TIM_OUT
declare constant int STAT_RWRD_CHK = 7;

//
declare constant int STAT_OUTCOME = 8;

//
declare constant int STAT_TIM_OUT = 9;
//
declare constant int STAT_ITI_CHK = 10;
