//==========================================================================
// VAR_CMD.PRO
//   Description: Global declares for COUNTERMANDING trials and Default defines
//
//   TODO:
//        Separate out VAR_COMN, common for all tasks
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//  002: 2019-02-08 chenchal subraveti
//       Compute MIN_TARGTIME using USE_TONE_AND_REWRD_FOR_MIN_THT
//       if 0: then MIN_TARGTIME = BASE_TARGTIME
//       if 1: then MIN_TARGTIME = TONE_DELAY+TONE_DURATION+RWRD_DURATION+RWRD_DELAY+BASE_TARGTIME
//       MIN_TARGTIME:
//       if break gaze on target  ==> Punish, Always do TIMEOUT_TIME regardless of TONE / JUICE given
//       if gaze ob target ==> NO TIMEOUT_TIME
//

// Trial counters
declare int TRL_NUMBER;
declare int TRIALS_PER_BLOCK = 30;

//===========Trial types and distributions==================
declare int          TRIAL_TYPE;
declare constant int TRIAL_TYPE_GO   = 0;
declare constant int TRIAL_TYPE_STOP = 1;
// Percentage of trial types (must sum to 100)
declare float        GO_WEIGHT     = 100.0;
declare float        STOP_WEIGHT   = 0.0;
declare float        IGNORE_WEIGHT = 0.0;
// temporary globals to be used in state processing
declare int          TEMP_MIN_THT;
declare int          TEMP_DELY_PLUS_DURATION;

//============= Timing variables    ===================
// Time dialation factor to multiply all times for manual operation
// 1 = default to be used when running expreriment;
declare int TIME_DILATE_FACTOR = 2;
// subject has this long to hang around fix-spot outside FIX_WIN_SIZE_LARGE
declare int READY_TIME = 2000;
// subject has this long to acquire fixation before a new trial is initiated
declare int ALLOWED_FIX_TIME = 3000;
// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int EXPO_JITTER = 1;
// minimum - maximum time after fixation before target presentation
declare int MIN_MAX_FIX_HOLD_TIME[2] = { 500, 1000 };
declare int FIXTIME;
// maximum time after fixation before target presentation
//declare int MAXTIME = 1000;
// for training subjects to slow down if necessary
declare int MIN_MAX_SACCADE_TIME[2] = { 100, 800 };
// subject has this long to saccade to the target
//declare int MAX_SACCADE_TIME = 700;
// once the eyes leave fixation they must be in the target before this time is up
declare int MAX_SACCADE_DURATION = 100;
// maximum number of stop signal delays
declare int   N_SSD_MAX = 20;
// number of *non-zero* stop signal delays
declare int   N_SSD;
// longest SSD (in number of screen refreshes)
declare int   MAX_SSD;
// shortest SSD (in number of screen refreshes)
declare int   MIN_SSD;
// SSD for current trial (in number of screen refreshes)
declare int   CURR_SSD;
// for training to cancel consistently
declare int   SSD_FLOOR = 0;
declare int   SSD_CEIL  = 0;
// do we select the next SSD based on a staircasing algorithm?
declare int   DO_STAIRCASE_NEXT_SSD = 1;
// needs to be in refresh rate units
declare float SSD_ARRY[N_SSD_MAX];
// subject must hold fixation for this long on a stop trial to be deemed canceled
declare int   CANCEL_TIME = 700 * 2;
// Alert operator that the monk has canceled a trial (during training)
declare int   CANCEL_ALERT = 0;
// 1 for fixed trial length, 0 for fixed inter trial intervals
declare int   IS_TRL_LENGTH_FIXED = 1;
// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
declare int   TRL_LENGTH_TIME = 6000;
// how long between trials (only works if Fixed_trl_length == 0)
declare int   BASE_ITI_TIME = 800;
declare int   ITI_TIME      = BASE_ITI_TIME;


//===========================Reward and punishment======================
// timeout time for punishment computed
declare int TIMEOUT_DURATION;
declare int TIMEOUT_TONE;
// See ProcLib/DOC/CmdOutcomes.xlsx
// Extra punish time for diferent outcomes in number of Trial lengths
// The value must be an integer
// TIMEOUT_TIME = TRL_DURATION (see SET_CMD.PRO) * XTRA_TIMEOUT
// GoTrial = TIMEOUT_xxx[0]
// NoGoTrial_No_StopSignal = TIMEOUT_xxx[1]
// NoGoTrial_StopSignal = TIMEOUT_xxx[2]
declare int TIMEOUT_FIX_ACQ_ERROR[3]      = { 1, 1, 1 };
declare int TIMEOUT_FIXBRK[3]             = { 1, 1, 1 };
declare int TIMEOUT_ERLY_SACC[3]          = { 1, 1, 1 };
declare int TIMEOUT_NO_SACC[3]            = { 1, 1, 1 };
declare int TIMEOUT_TARG_ACQ_ERROR[3]     = { 1, 1, 1 };
declare int TIMEOUT_TARG_BRK_MIN_THT[3]   = { 1, 1, 1 };  
declare int TIMEOUT_TARG_BRK_PRE_TONE[3]  = { 1, 1, 1 };
declare int TIMEOUT_TARG_BRK_TONE[3]      = { 1, 1, 1 };
declare int TIMEOUT_TARG_BRK_PRE_RWRD[3]  = { 1, 1, 1 };
declare int TIMEOUT_TARG_BRK_POST_RWRD[3] = { 1, 1, 1 };
// Only valid for NoGo Trial, the 0 index is not used for GoTrial
// Gaze *in* targ_win for the duration of min Targ. hold time
declare int TIMEOUT_TARG_MIN_THT[3]       = { 0, 2, 2 };

// Base Minimum time subject should hold gaze on TARGET
declare int BASE_TARGTIME = 2005;
// Use TONE_DELAY and RWRD_DELAY for computing MIN_TARGETTIME
// if = 0, then MIN_TARGETTIME = BASE_TARGTIME
// if = 1, then MIN_TARGETTIME = TONE_DELAY+TONE_DURATION+RWRD_DELAY+RWRD_DURATION+BASE_TARGTIME
declare int USE_TONE_AND_REWRD_FOR_MIN_THT = 0;
// after saccade subject must hold gaze on target for this long
// if not, then TIMEOUT is imposed regardless of TONE or REWARD
declare int   MIN_TARGTIME;
// how long after IS_TARG_ACQUIRED before tone is played (primary reinforcement)
declare int   TONE_DELAY = 2000;
// how long should the error and success tones be presented?
// this will be recomputed during trial
// Actual used will be TRL_TONE_DURATION, TRL_TONE_FREQ
declare int   TONE_DURATION = 2000;
// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int   RWRD_DELAY = 6000;
// how long will the juice solenoid remain open (monkeys are very interested in this varaible)
// this will be recomputed during trial
// Actual used will be TRL_RWRD_DURATION
declare int   RWRD_DURATION = 20;
// time out for messing up
declare int   BASE_PUNISH_TIME = 2000;

// Positive secondary reinforcer in Hz
declare int SUCCESS_TONE_BIG_REWARD = 300;
declare int SUCCESS_TONE_MED_REWARD = 400;
declare int SUCCESS_TONE_SML_REWARD = 500;
// Negative secondary reinforcer timeout (short, medium, long)
declare int FAILURE_TONE_SML_TIMEOUT = 800;
declare int FAILURE_TONE_MED_TIMEOUT = 1600;
declare int FAILURE_TONE_BIG_TIMEOUT = 3200;

// Exponential juice reward duration by reaction time
declare int EXP_JUICE_RWRD_TIME = 0;

//==========================Additional Timeouts======================
// additive timeout imposed for each body movement
//declare int BODY_MOVE_TIMEOUT;
// Output lets us know how many times the body has moved.
//declare int BODY_MOVE_COUNT;
// Setting maximum move_ct so monkey doesn't self-punish to eternity
//declare int MAX_BODY_MOVE_COUNT;
// Indicates that we are using motion detector to train the monk to be still
//declare int TRAINING_STILL;
