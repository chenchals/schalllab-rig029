//==========================================================================
// VAR_TRL.PRO
//   Description: Global declares for Trial variables
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//

// Trial counters
declare int   Trl_number;
declare int   trialtype;
// Trial type distributions (must sum to 100)
// Percentage of trial types
declare float Go_weight;
declare float Stop_weight;
declare float Ignore_weight;

// shows that we are doing 1DR version of task ????
declare int   DR1_flag;

//=========== Window sizes (degrees) ==================
declare float Fix_win_size;
declare float Targ_win_size;
//============= Timing variables    ===================
// subject has this long to acquire fixation before a new trial is initiated
declare int   Allowed_fix_time;
// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int   Expo_Jitter;
// minimum time after fixation before target presentation
declare int   Min_Holdtime;
// maximum time after fixation before target presentation
declare int   Max_Holdtime;
// for training subjects to slow down if necessary
declare int   Min_saccade_time;
// subject has this long to saccade to the target
declare int   Max_saccade_time;
// once the eyes leave fixation they must be in the target before this time is up
declare int   Max_sacc_duration;
// after saccade subject must hold fixation at target for this long
declare int   Targ_hold_time;

//==================Memmory guided specific=============
// defines if exponential holdtime is used for fixation offset in mem guided sacc task
declare int   Expo_Jitter_SOA;
// minimum time from target onset to fixation offset (mem guided only)
declare int   Min_SOA;
// maximum time from target onset to fixation offset (mem guided only)
declare int   Max_SOA;
declare int   N_SOAs;
declare int   Max_SOA;
// needs to be in refresh rate units
declare float SOA_list[20];

//==================Countermanding specific?=============
// number of stop signal delays
declare int   N_SSDs;
// longest SSD (in number of screen refreshes)
declare int   Max_SSD;
// shortest SSD (in number of screen refreshes)
declare int   Min_SSD;
declare int   Min_SSD;
// for training to cancel consistently
declare int   SSD_floor;
declare int   SSD_ceil;
// do we select the next SSD based on a staircasing algorithm?
declare int   Staircase;
// needs to be in refresh rate units
declare float SSD_list[20];
// subject must hold fixation for this long on a stop trial to be deemed canceled
declare int   Cancl_time;

// how long should the error and success tones be presented?
declare int   Tone_Duration;
// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int   Reward_Offset;
// how long will the juice solonoid remain open (monkeys are very interested in this varaible)
declare int   Base_Reward_time;
// time out for messing up
declare int   Base_Punish_time;
// additive timeout imposed for each body movement
declare int   Bmove_tout;
// Output lets us know how many times the body has moved.
declare int   Move_ct;
// Setting maximum move_ct so monkey doesn't self-punish to eternity
declare int   Max_move_ct;
 // Indicates that we are using motion detector to train the monk to be still
declare int   TrainingStill;
// Alert operator that the monk has canceled a trial (during training)
declare int   Canc_alert;
// 1 for fixed trial length, 0 for fixed inter trial intervals
declare int   Fixed_trl_length;
// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
declare int   Trial_length;
// how long between trials (only works if Fixed_trl_length == 0)
declare int   Inter_trl_int;
// Exponential juice reward duration by reaction time
declare int   Exp_juice;
declare int   nogosoa;
declare int   targ_on_time;


//===========================Reward and punishment======================
// percentage of time that the subject is wrong but gets rewarded anyway.
declare float Bonus_weight;
// percentage of time that the subject is right but gets punished anyway.
declare float Dealer_wins_weight;
// Reward weights
declare float BigR_weight = 0.3;
declare float MedR_weight = 0.2;
declare float SmlR_weight = 0.1;
// Punishment weights
declare float SmlP_weight = 0.1;
declare float MedP_weight = 0.2;
declare float BigP_weight = 0.3;

// sets up the tones to either high or low based on user input
declare int   Set_Tones;
// Positive secondary reinforcer in Hz
declare int   Success_Tone_bigR;
declare int   Success_Tone_medR;
declare int   Success_Tone_smlR;
// Negative secondary reinforcer in Hz (hort, medium, long timeout)
declare int   Failure_Tone_smlP;
declare int   Failure_Tone_medP;
declare int   Failure_Tone_bigP;
