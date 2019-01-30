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
//

// Trial counters
declare int TRL_NUMBER;
declare int TRIALS_PER_BLOCK = 30;

//===========Trial types and distributions==================
declare int          TRIAL_TYPE;
declare constant int TRIAL_TYPE_GO     = 0;
declare constant int TRIAL_TYPE_STOP   = 1;
declare constant int TRIAL_TYPE_IGNORE = 2;
// Percentage of trial types (must sum to 100)
declare float        GO_WEIGHT     = 30.0;
declare float        STOP_WEIGHT   = 30.0;
declare float        IGNORE_WEIGHT = 40.0;

//============= Timing variables    ===================
// Time dialation factor to multiply all times for manual operation
// 1 = default to be used when running expreriment;
declare int TIME_DIALATION_FACTOR = 1;
// subject has this long to hang around fix-spot outside FIX_WIN_SIZE_LARGE
declare int READY_TIME = 1000;
// subject has this long to acquire fixation before a new trial is initiated
declare int ALLOWED_FIX_TIME = 1000;
// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int EXPO_JITTER = 1;
// minimum - maximum time after fixation before target presentation
declare int MIN_MAX_FIX_HOLD_TIME[2] = {500, 1000};
declare int FIX_HOLD_TIME;
// maximum time after fixation before target presentation
//declare int MAX_HOLD_TIME = 1000;
// for training subjects to slow down if necessary
declare int MIN_MAX_SACCADE_TIME[2] = {100, 700};
// subject has this long to saccade to the target
//declare int MAX_SACCADE_TIME = 700;
// once the eyes leave fixation they must be in the target before this time is up
declare int MAX_SACCADE_DURATION = 50;
// after saccade subject must hold fixation at target for this long
declare int MIN_MAX_TARGET_HOLD_TIME = {1500, 1500};
declare int TARGET_HOLD_TIME;
// maximum number of stop signal delays
declare int   N_SSD_MAX = 20;
// number of *non-zero* stop signal delays
declare int   N_SSD;
// longest SSD (in number of screen refreshes)
declare int   MAX_SSD;
// shortest SSD (in number of screen refreshes)
declare int   MIN_SSD;
// SSD for current trial (in number of screen refreshes)
declare int CURR_SSD;
// for training to cancel consistently
declare int   SSD_FLOOR = 0;
declare int   SSD_CEIL  = 0;
// do we select the next SSD based on a staircasing algorithm?
declare int   DO_STAIRCASE_NEXT_SSD = 1;
// needs to be in refresh rate units
declare float SSD_ARRY[N_SSD_MAX];
// subject must hold fixation for this long on a stop trial to be deemed canceled
declare int   CANCEL_TIME = MIN_MAX_SACCADE_TIME[1] * 2;
// Alert operator that the monk has canceled a trial (during training)
declare int   CANCEL_ALERT = 0;
// 1 for fixed trial length, 0 for fixed inter trial intervals
declare int   IS_TRL_LENGTH_FIXED = 1;
// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
declare int   TRL_LENGTH_TIME = 5000;
// Extra punish time
declare int   EXTRA_PUNISH_TIME = TRL_LENGTH_TIME;
// how long between trials (only works if Fixed_trl_length == 0)
declare int   INTER_TRL_INTERVAL_TIME = 800;
declare int   NOGO_SOA;
declare int   TARG_ON_TIME = 100;

//===========================Reward and punishment======================
// how long should the error and success tones be presented?
declare int   TONE_DURATION = 0;
// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int   REWARD_OFFSET = 600;
// how long will the juice solonoid remain open (monkeys are very interested in this varaible)
declare int   BASE_REWARD_TIME = 20;
// time out for messing up
declare int   BASE_PUNISH_TIME = 2000;
// Reward weights
declare float BIG_REWARD_WEIGHT = 0.3;
declare float MED_REWARD_WEIGHT = 0.2;
declare float SML_REWARD_WEIGHT = 0.1;
// Punishment weights
declare float SML_PUNISH_WEIGHT = 0.1;
declare float MED_PUNISH_WEIGHT = 0.2;
declare float BIG_PUNISH_WEIGHT = 0.3;

// Positive secondary reinforcer in Hz
declare int SUCCESS_TONE_BIG_REWARD = 100;
declare int SUCCESS_TONE_MED_REWARD = 200;
declare int SUCCESS_TONE_SML_REWARD = 400;
// Negative secondary reinforcer timeout (short, medium, long)
declare int FAILURE_TONE_SML_TIMEOUT = 800;
declare int FAILURE_TONE_MED_TIMEOUT = 1600;
declare int FAILURE_TONE_BIG_TIMEOUT = 3200;
// Exponential juice reward duration by reaction time
declare int EXP_JUICE_REWARD_TIME = 0;

//==========================Additional Timeouts======================
// additive timeout imposed for each body movement
//declare int BODY_MOVE_TIMEOUT;
// Output lets us know how many times the body has moved.
//declare int BODY_MOVE_COUNT;
// Setting maximum move_ct so monkey doesn't self-punish to eternity
//declare int MAX_BODY_MOVE_COUNT;
// Indicates that we are using motion detector to train the monk to be still
//declare int TRAINING_STILL;
