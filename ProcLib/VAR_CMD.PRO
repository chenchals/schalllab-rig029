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
declare int TRIAL_TYPE;
declare constant int TRIAL_TYPE_GO = 0;
declare constant int TRIAL_TYPE_STOP = 1;
declare constant int TRIAL_TYPE_IGNORE = 2;
// Percentage of trial types (must sum to 100)
declare float GO_WEIGHT = 50;
declare float STOP_WEIGHT = 50;
declare float IGNORE_WEIGHT = 0;

//=========== Window sizes (degrees) ==================
declare float FIX_WIN_SIZE = 5;
declare float TARG_WIN_SIZE = 7;

//============= Timing variables    ===================
// subject has this long to acquire fixation before a new trial is initiated
declare int ALLOWED_FIX_TIME; = 1000
// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int EXPO_JITTER;
// minimum time after fixation before target presentation
declare int MIN_HOLD_TIME;
// maximum time after fixation before target presentation
declare int MAX_HOLD_TIME;
// for training subjects to slow down if necessary
declare int MIN_SACCADE_TIME = 800;
// subject has this long to saccade to the target
declare int MAX_SACCADE_TIME;
// once the eyes leave fixation they must be in the target before this time is up
declare int MAX_SACCADE_DURATION;
// after saccade subject must hold fixation at target for this long
declare int TARGET_HOLD_TIME;

//==================Countermanding specific?=============
// number of stop signal delays
declare int   N_SSD;
// longest SSD (in number of screen refreshes)
declare int   MAX_SSD;
// shortest SSD (in number of screen refreshes)
declare int   MIN_SSD;
// for training to cancel consistently
declare int   SSD_FLOOR;
declare int   SSD_CEIL;
// do we select the next SSD based on a staircasing algorithm?
declare int   DO_STAIRCASE_NEXT_SSD;
// needs to be in refresh rate units
declare float SSD_ARRY[20];
// subject must hold fixation for this long on a stop trial to be deemed canceled
declare int   CANCEL_TIME;
// Alert operator that the monk has canceled a trial (during training)
declare int CANCEL_ALERT;
// 1 for fixed trial length, 0 for fixed inter trial intervals
declare int IS_TRL_LENGTH_FIXED;
// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
declare int TRL_LENGTH_TIME;
// how long between trials (only works if Fixed_trl_length == 0)
declare int INTER_TRL_INTERVAL_TIME;
declare int NOGO_SOA;
declare int TARG_ON_TIME;

//===========================Reward and punishment======================
// how long should the error and success tones be presented?
declare int TONE_DURATION;
// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int REWARD_OFFSET;
// how long will the juice solonoid remain open (monkeys are very interested in this varaible)
declare int BASE_REWARD_TIME = 20;
// time out for messing up
declare int BASE_PUNISH_TIME = 2000;
// Reward weights
declare float BIG_REWARD_WEIGHT = 0.3;
declare float MED_REWARD_WEIGHT = 0.2;
declare float SML_REWARD_WEIGHT = 0.1;
// Punishment weights
declare float SML_PUNISH_WEIGHT = 0.1;
declare float MED_PUNISH_WEIGHT = 0.2;
declare float BIG_PUNISH_WEIGHT = 0.3;

// Positive secondary reinforcer in Hz
declare int SUCCESS_TONE_BIG_REWARD;
declare int SUCCESS_TONE_MED_REWARD;
declare int SUCCESS_TONE_SML_REWARD;
// Negative secondary reinforcer in Hz (hort, medium, long timeout)
declare int FAILURE_TONE_SML_REWARD;
declare int FAILURE_TONE_MED_REWARD;
declare int FAILURE_TONE_BIG_REWARD;
// Exponential juice reward duration by reaction time
declare int EXP_JUICE_REWARD_TIME;

//==========================Additional Timeouts======================
// additive timeout imposed for each body movement
//declare int BODY_MOVE_TIMEOUT;
// Output lets us know how many times the body has moved.
//declare int BODY_MOVE_COUNT;
// Setting maximum move_ct so monkey doesn't self-punish to eternity
//declare int MAX_BODY_MOVE_COUNT;
// Indicates that we are using motion detector to train the monk to be still
//declare int TRAINING_STILL;
