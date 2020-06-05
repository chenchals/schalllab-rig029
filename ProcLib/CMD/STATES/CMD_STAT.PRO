//==========================================================================
// CMD_STAT.PRO
//   Description: Task states for Countermanding. All states are based
//                on EYE POSITION and current TASK PHASE (avoiding saying STATE here)
//                A STATE should ideally know about
//                1. CURR_STAT : State in currently
//                2. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                3. STAT_ALLOWED_T : Max time for staying in this state
//                4. STAT_I_DURATION : If saccade occurs, it must complete in this time
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
// Current state the task is currently in. When the vale of thsi changes a state-transition occurs
declare int CURR_STAT;
// Variables used in processing a given state. These variables are defined once when the sate changes.
// Every NEXTTICK (in CMD_TSK.PRO) will SPANWAIT the state defined in CURR_STAT
declare int STAT_STRT_T;
declare int STAT_DLTA_T;
declare int STAT_ALLOWED_T;
// for gating the eye pos by time
declare int STAT_I_DURATION;
declare int STAT_I_DURATION2;

// Place holder for testing and debugging a particualar state
declare constant int STAT_TEST = 99;

// Eyes are anywhere on the screen
//     Show blank page,
//     send event EVT_INFOS_START_ and send INFOS,
//     wait for send infos to complete,
//     end event EVT_INFOS_END_
//     set TRL_IS_RUNNING and PROCESS_STATE to 0
declare constant int STAT_IDLE = 0;

// Bootstrapping of Task:
// PROCLIB/CMD_TSK.PRO bootstraps the following when RUN_TASK = 1,
//        which is set in PROCLIB/CMD_TSK.dcf when menu item "Run CND Task" is clicked.
//        Before entering this state, CMD_TSK.PRO
//           Initializes all trials trial
//           sends event EVT_IDENTIFY_ROOM_ and RIG_ID  when trial number is 1
//           sets PROCESS_STATE  = 1
//           sets TRL_IS_RUNNING = 1
//           sends EVT_TASK_START_
//           sends EVT_CMAN_HEADER_
//           sets CURR_STAT   = STAT_GET_READY <- for starting the trial
// Fixspot is NOT ON: Waiting for subj to be ready
// Check: Eye has to wait outside the FIX_WIN_WIDE for the duration of TRL_GET_REDY_TIME.
//        If eye crosses the FIX_WIN_LARGE, the wait time counter resets.
//        Else Transitions to : STAT_FIX_ON
declare constant int STAT_GET_READY = 1;

// Fixspot is ON: Waiting for subject to reach the fix window and Fixate
// Check: Gaze within FIX_WIN before ALLOWED_FIX_TIME
//        If yes transition to : STAT_FIX_HOLD
//        Else transition to: STAT_IDLE
declare constant int STAT_FIX_ON = 2;

// Fixspot is ON: Waiting for subject to stay on fixspot
// Check: Gaze within FIX_WIN until TRL_USE_FIX_HOLD_DURATION expires
//        If yes transition to : TARG_ON
//        Else transition to: STAT_IDLE
declare constant int STAT_FIX_HOLD = 3;

// Fixspot is OFF Target is ON:
// Check: Gaze left FIX window before MIN_SACCADE_TIME expires
//        If yes, Early saccade transition to: STAT_OUTCOME
//        Else Gaze left FIX_WIN before MAX_SACCADE_TIME
//             If yes, correct saccade transiyion to: STAT_TARG_ACQ
//             Else no saccade transition to: STAT_OUTCOME
declare constant int STAT_TARG_ON = 4;

// Fixspot is OFF Target is ON:
// Check: Gaze in TARG_WIN before MAX_SACC_DURATION
//        If yes, check TRIAL_TYPE
//             If TRIAL_TYPE_STOP, (and TRL_NOGO_LATE_SACCADE_TIME > 0, transition to: STAT_OUTCOME
//             Else transition to: STAT_TARG_HOLD (turn on fixspot, if TRIAL_TYPE_STOP && TRL_IS_FIX_REIGNITE > 0)
//        Else late saccade, transition to: STAT_OUTCOME
declare constant int STAT_TARG_ACQ = 5;

// Fixspot is OFF Target is ON:
// Check: Gaze in TARG_WIN for the duration of TRL_USE_MIN_THT_DURATION
//        If yes, transition to: STAT_TONE_CHK
//        Else saccade happened during target hold, transition to: STAT_REFIX_CHK
declare constant int STAT_TARG_HOLD = 6;

// Fixspot is OFF Target is ON:
// Check:
//   case 0: Check TRL_USE_XTRA_HOLD_DURATION <= TONE_DELAY and
//                 Gaze NOT in TARG_WIN until TRL_USE_XTRA_HOLD_DURATION expires
//         If yes, broke fixation during tone delay, transition to: STAT_REFIX_CHK
//   case 1: Check TRL_USE_XTRA_HOLD_DURATION <= TONE_DELAY + TONE_DURATION and
//                Gaze NOT in TARG_WIN until TONE_DURATION expires
//         If yes, broke fixation during tone delivery, transition to: STAT_REFIX_CHK
//   case 2: Check TRL_USE_XTRA_HOLD_DURATION > TONE_DELAY + TONE_DURATION and
//                 Gaze in TARG_WIN
//         If yes, (tone already delivered), transition to: STAT_RWRD_CHK
declare constant int STAT_TONE_CHK = 7;

// Fixspot is OFF Target is ON:
// Check:
//   case 0: Check TRL_USE_XTRA_HOLD_DURATION <= RWRD_DELAY and
//                 Gaze NOT in TARG_WIN until TRL_USE_XTRA_HOLD_DURATION expires
//         If yes, broke fixation during reward delay, transition to: STAT_REFIX_CHK
//   case 1: Check TRL_USE_XTRA_HOLD_DURATION <= RWRD_DELAY + RWRD_DURATION and
//                Gaze NOT in TARG_WIN until RWRD_DURATION expires
//         If yes, broke fixation during reward delivery, transition to: STAT_REFIX_CHK
//   case 2: Check TRL_USE_XTRA_HOLD_DURATION > RWRD_DELAY + RWRD_DURATION and
//                 Gaze in TARG_WIN
//         If yes, (reward already delivered), transition to: STAT_OUTCOME
declare constant int STAT_RWRD_CHK = 8;

// Determine the Outcome for a given trial and EXTRA_TIMEOUT_DURATION
// The following outcomes are determined for the trial whenever this state is processed
// The outcomes are defined as events in the CMD/EVENTDEF.PRO
// Outcome Codes: from 1550-1599
// did not acquire fixation
//     EVT_OUTCOME_FIX_ERR_ = 1550;
// did not hold gaze for fix hold time
//     EVT_OUTCOME_FIX_BREAK_ = 1552;
// Go trial - held fixation on target through reward
//     EVT_OUTCOME_GO_CORRECT_ = 1560;
// Go trial - after acquiring target, broke gaze on target
//     EVT_OUTCOME_GO_ERR_ = 1562;
// Stop trial - held gaze on fix/signal till reward
//     EVT_OUTCOME_NOGO_CANCEL_NO_BRK_ = 1570;
// Stop trial - held gaze on fix/signal till cancel time + xtra-hold-time, then broke fix/signal
//     EVT_OUTCOME_NOGO_CANCEL_BRK_ = 1572;
// Stop trial - after target on, gaze on target through tone and reward
//     EVT_OUTCOME_NOGO_NON_CANCEL_NO_BRK_ = 1574;
// Stop trial - after target on, gaze on target till xtra-hold-time, then broke target
//     EVT_OUTCOME_NOGO_NON_CANCEL_BRK_ = 1576;
// Stop trial - after target on, gaze elsewhere or incorrect saccade or broke min-target-hold/xtra-hold-time
//     EVT_OUTCOME_NOGO_ERR_ = 1578;
declare constant int STAT_OUTCOME = 9;

// Process ITI state:
// Compute the TRL_USE_ITI_DURATION based on TRL_USE_TRIAL_DURATION determeined in
//         CMD/SET_CMD.PRO/process COMPUTE_TRIAL_DURATION().
//         Check if trial is a timeout trial
//         If yes, send event EVT_EOT_,
//                 add TRL_USE_ITI_DURATION to TIMEOUT_DURATION (computed in CMD/STATES/OUTCOME.PRO)
//                 transition to: STAT_TIM_OUT
//         Else send event EVT_ITI_START_,
//                 wait for TRL_USE_ITI_DURATION to expire,
//                 send event EVT_ITI_END_, EVT_EOT_ and
//                 transitions to: STAT_IDLE
declare constant int STAT_ITI_CHK = 10;

// Process timeout state:
//   send event EVT_TIMEOUT_START_,
//   wait for TIMEOUT_DURATION to expire,
//   send event EVT_TIMEOUT_END_
//   transition to: STAT_IDLE
declare constant int STAT_TIM_OUT = 11;

// Fixspot may still be ON if TRIAL_TYPE_STOP
// Check: TRIAL_TYPE_STOP and gaze in FIX_WIN
//        If yes, send EVT_REFIX_, transition to: STAT_OUTCOME
//        Elase transition to: STAT_OUTCOME
declare constant int STAT_REFIX_CHK = 12;

/// Gaze Check:
// Fixspot is OFF Target is ON:
// Check: Gaze in FIX window until MIN_SACCADE_TIME expires, else it is early saccade
//        Gaze left FIX_WIN before MAX_SACCADE_TIME, then correct saccade, else no saccade
// Check:
//   case 0: [Stop signal is OFF] TRL_USE_SSD_VR_COUNT has not expired
//                   if gaze out of FIX-WIN before MIN_SACC_TIME --> EVT_NOGO_EARLY_SACCADE_, goto STAT_OUTCOME
//                   if gaze out of FIX-WIN after MIN_SACC_TIME and before MAX_SACC_TIME --> NoGoEVT_SACCADE_, goto STAT_TARG_ACQ
//                   if gaze out of FIX-WIN after MAX_SACC_TIME --> EVT_NOGO_LATE_SACCADE_, goto STAT_OUTCOME
//   case 1: [Stop Signal ON] TRL_USE_SSD_VR_COUNT has expired and
//             TRL_USE_SSD_CANCEL_DURATION has not expired then
//             show PG_SIGNAL_PD (PD on RIGHT) for 1 screen refresh and
//             switch to PG_SIGNAL(PD on LEFT)
//                   if gaze out of FIX-WIN before MIN_SACC_TIME --> EVT_NOGO_EARLY_SACCADE_, goto STAT_OUTCOME
//                   if gaze out of FIX-WIN after MIN_SACC_TIME and before MAX_SACC_TIME --> NoGoEVT_SACCADE_, goto STAT_TARG_ACQ
//   [Stop Signal OFF] switch page from PG_SIGNAL to PG_TARGET_PD (do nto show stop signal)
//                   if gaze out of FIX-WIN after MAX_SACC_TIME --> EVT_NOGO_LATE_SACCADE_, goto STAT_OUTCOME
declare constant int STAT_TARG_SSD = 40;

// Signal is ON Target is ON:
// Check:
//   case 0: TRL_USE_XTRA_HOLD_DURATION <= TONE_DELAY
//         if gaze out of FIX_WIN before TRL_USE_XTRA_HOLD_DURATION expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in FIX_WIN until TRL_USE_XTRA_HOLD_DURATION expires: Play (SUCCESS) TONE at TONE_DELAY time
//   case 1: TRL_USE_XTRA_HOLD_DURATION <= TONE_DELAY + TONE_DURATION
//         if gaze in FIX_WIN until TONE_DURATION --> (SUCCESS-tone alredey delivered), goto STAT_RWRD_SSD
//         if gaze not in FIX_WIN during TONE_DURATION --> (SUCCESS-tone alredey delivered), compute TIMEOUT_TIME --> goto STAT_OUTCOME
//   case 2: TRL_USE_XTRA_HOLD_DURATION > TONE_DELAY + TONE_DURATION
//         Goto next state (reward already delivered), goto STAT_RWRD_SSD
declare constant int STAT_TONE_SSD = 41;

// Gaze Check:
// Signal is ON Target is ON:
// Check:
//   case 0: TRL_USE_XTRA_HOLD_DURATION <= RWRD_DELAY
//         if gaze out of FIX_WIN before TRL_USE_XTRA_HOLD_DURATION expires: No Reward --> goto STAT_OUTCOME
//         if gaze in FIX_WIN until TRL_USE_XTRA_HOLD_DURATION expires: Deliver reward at RWRD_DELAY time
//   case 1: TRL_USE_XTRA_HOLD_DURATION <= RWRD_DELAY + RWRD_DURATION
//                if gaze in FIX_WIN until RWRD_DURATION --> (reward alredey delivered)--> goto STAT_OUTCOME
//                if gaze not in FIX_WIN during RWRD_DURATION --> (reward already delivered) --> goto STAT_TIM_OUT
//   case 2: TRL_USE_XTRA_HOLD_DURATION > RWRD_DELAY + RWRD_DURATION
//         if gaze in FIX_WIN until TRL_USE_XTRA_HOLD_DURATION expires: (reward already delivered) --> goto STAT_OUTCOME
//         if gaze out of FIX_WIN before TRL_USE_XTRA_HOLD_DURATION expires: (reward already delivered) --> goto STAT_TIM_OUT
declare constant int STAT_RWRD_SSD = 42;
