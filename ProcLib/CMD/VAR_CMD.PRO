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
//       Compute MIN_TARG_HOLD_TIME using USE_TONE_AND_REWRD_FOR_MIN_THT
//       if 0: then MIN_TARG_HOLD_TIME = BASE_TARG_HOLD_TIME
//       if 1: then MIN_TARG_HOLD_TIME = TONE_DELAY+TONE_DURATION+RWRD_DURATION+RWRD_DELAY+BASE_TARG_HOLD_TIME
//       MIN_TARG_HOLD_TIME:
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
declare float        GO_WEIGHT     = 0.0;
declare float        STOP_WEIGHT   = 100.0;
declare float        IGNORE_WEIGHT = 0.0;
// temporary globals to be used in state processing
declare int          TEMP_MIN_THT;
declare int          TEMP_MIN_SSHT;
declare int          TEMP_DELY_PLUS_DURATION;

//============= Timing variables    ===================
// Time dialation factor to multiply all times for manual operation
// 1 = default to be used when running expreriment;
declare int TIME_DILATE_FACTOR = 1;
// subject has this long to hang around fix-spot outside FIX_WIN_SIZE_LARGE
declare int READY_TIME = 1000;
// subject has this long to acquire fixation before a new trial is initiated
declare int ALLOWED_FIX_TIME = 1000;
// subject did not acquire fixation, show blank screen and wait before next trial
declare int FIX_NOT_ACQ_WAIT_TIME = 1000;
// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int EXPO_JITTER = 1;
// minimum - maximum time after fixation before target presentation
declare int MIN_MAX_FIX_HOLD_TIME[2] = { 500, 1000 };
// min-max saccade time is same for Go and STOP trials
declare int MIN_SACC_TIME = 100;
declare int MAX_SACC_TIME = 800;
// subject has this long to saccade to the target
//declare int MAX_SACCADE_TIME = 700;
// once the eyes leave fixation they must be in the target before this time is up
declare int MAX_SACC_DURATION = 100;
// 1 for fixed trial length, 0 for fixed inter trial intervals
declare int   IS_TRL_LENGTH_FIXED = 1;
// fixed at this value (only works if Fixed_trl_length == 1)
declare int   FIXED_TRL_LENGTH_TIME = 3000;
// how long between trials (only works if Fixed_trl_length == 0)
declare int   BASE_ITI_TIME = 500;
//========== GO TRIAL TARG HOLD TIME ======================
// Base Minimum time subject should hold gaze on TARGET
declare int BASE_TARG_HOLD_TIME = 100;
// Use TONE_DELAY and RWRD_DELAY for computing MIN_TARGETTIME
// if = 0, then MIN_TARG_HOLD_TIME = BASE_TARG_HOLD_TIME
// if = 1, then MIN_TARG_HOLD_TIME = TONE_DELAY+TONE_DURATION+RWRD_DELAY+RWRD_DURATION+BASE_TARG_HOLD_TIME
declare int USE_TONE_AND_RWRD_FOR_MIN_THT = 1;
// after saccade subject must hold gaze on target for this long
// if not, then TIMEOUT is imposed regardless of TONE or REWARD
declare int MIN_TARG_HOLD_TIME;
//========== STOP TASK SPECIFIC =============================
// maximum number of stop signal delays
declare int   N_SSD_MAX = 30;
// needs to be in refresh rate units
declare float SSD_ARRY[N_SSD_MAX];
// number of *non-zero* stop signal delays
declare int   N_SSD;
// min max ssd
declare int MIN_SSD;
declare int MAX_SSD;
// do we select the next SSD based on a staircasing algorithm?
declare int   DO_STAIRCASE_NEXT_SSD = 1;
// Minimum time *after* stop signal that subject has to fixate
// in order for trial to be considered as Cancel trial
// Relative to TRL_STOP_SIGNAL_DELAY
declare int SSD_CANCEL_TIME = 1000;
declare int FIX_HOLD_FOR_CANCEL;
// Base Minimum time subject should hold gaze on FIXSPOT *After* TRL_STOP_SIGNAL_DELAY
declare int BASE_STOP_SIGNAL_HOLD_TIME = 500;
// after TRL_STOP_SIGNAL_DELAY, subject must hold gaze on FIXSPOT for this long
// if not, then TIMEOUT is imposed regardless of TONE or REWARD
declare int MIN_STOP_SIGNAL_HOLD_TIME;
//============= TONE and REWARD periods =========================
// how long after IS_TARG_ACQUIRED before tone is played (primary reinforcement)
declare int   TONE_DELAY = 500;
// how long should the error and success tones be presented?
// this will be recomputed during trial
// Actual used will be TRL_TONE_DURATION, TRL_TONE_FREQ
declare int   TONE_DURATION = 50;
// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int   RWRD_DELAY = 500;
// how long will the juice solenoid remain open (monkeys are very interested in this varaible)
// this will be recomputed during trial
// Actual used will be TRL_RWRD_DURATION
declare int   RWRD_DURATION = 50;

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
declare int TIMEOUT_FIX_ACQ_ERROR[3]      = { 0, 0, 0 };
declare int TIMEOUT_FIXBRK[3]             = { 0, 0, 0 };
declare int TIMEOUT_ERLY_SACC[3]          = { 0, 0, 0 };
declare int TIMEOUT_NO_SACC[3]            = { 0, 0, 0 };
declare int TIMEOUT_TARG_ACQ_ERROR[3]     = { 0, 0, 0 };
declare int TIMEOUT_TARG_BRK_MIN_THT[3]   = { 0, 0, 0 };
declare int TIMEOUT_TARG_BRK_PRE_TONE[3]  = { 0, 0, 0 };
declare int TIMEOUT_TARG_BRK_TONE[3]      = { 0, 0, 0 };
declare int TIMEOUT_TARG_BRK_PRE_RWRD[3]  = { 0, 0, 0 };
declare int TIMEOUT_TARG_BRK_POST_RWRD[3] = { 0, 0, 0 };
// Only valid for NoGo Trial, the 0 index is not used for GoTrial
// Gaze *in* targ_win for the duration of min Targ. hold time
declare int TIMEOUT_TARG_MIN_THT[3]       = { 0, 0, 0 };

// Positive secondary reinforcer in Hz
declare int SUCCESS_TONE_BIG_REWARD = 300;
declare int SUCCESS_TONE_MED_REWARD = 400;
declare int SUCCESS_TONE_SML_REWARD = 500;
// Negative secondary reinforcer timeout (short, medium, long)
declare int FAILURE_TONE_SML_TIMEOUT = 800;
declare int FAILURE_TONE_MED_TIMEOUT = 1600;
declare int FAILURE_TONE_BIG_TIMEOUT = 3200;


//==========================Additional Timeouts======================
// additive timeout imposed for each body movement
//declare int BODY_MOVE_TIMEOUT;
// Output lets us know how many times the body has moved.
//declare int BODY_MOVE_COUNT;
// Setting maximum move_ct so monkey doesn't self-punish to eternity
//declare int MAX_BODY_MOVE_COUNT;
// Indicates that we are using motion detector to train the monk to be still
//declare int TRAINING_STILL;
