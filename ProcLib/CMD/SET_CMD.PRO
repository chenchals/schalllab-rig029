//==========================================================================
// SET_CMD.PRO
//   Description: Setup All variables, procs for Countermanding task.
//
//   NOTE:
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-24
//==========================================================================
//  Revision History:

// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/CONSTNTS.PRO
// CMD Vars only...?
#include C:/TEMPO/ProcLib/CMD/VAR_CMD.PRO
// State defs
#include C:/TEMPO/ProcLib/CMD/STATES/CMD_STAT.PRO
// Rig specific vars for colors, mainly
#include C:/TEMPO/ProcLib/RIG/VAR_RIG.PRO
// Stimulus Variables: fixation, target, photodiode
#include C:/TEMPO/ProcLib/CMD/VAR_STIM.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/CMD/SET_CLRS.PRO
// Setup GRAPHS - referenced by _PGS
#include C:/TEMPO/ProcLib/GRAFS/GRAPHS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
// Setup event defs so events can be sent
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO

//=====Now do monk specific========
// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/RIG/SET_RIG.PRO
// Set monk
#include C:/TEMPO/ProcLib/MONK/SET_MONK.PRO

//========other utils=============
// Send event processes
#include C:/TEMPO/ProcLib/UTIL/SEND_EVT.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_EYE.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_PD.PRO

declare SET_CMD_TRL();
declare SET_WINS();
declare PCK_TRL_TYP();


// A temporary state acitivity
declare int PROCESS_STATE;
declare int TRL_RUNNING;
declare int TARG_VR_COUNT_TIME;
// increment trial target on duration flag
// =1 first time PD_TRIG_L is detected for Target on page
// =0 first rime PD_TRIG_R is detected for Stop signal page
// =0 when blank page for GO trial?
declare int IS_TARG_ON_FLAG;
declare int IS_TARG_ACQUIRED;
declare int I_IN_FLIGHT;

// Trial Timees
declare int TRL_CUM_TIME;
// time trial started
declare int TRL_START_TIME;
// time trial ended same as Eot_?
declare int TRL_END_TIME;
// time monitoring eye to be outside Fix window wide
declare int TRL_GET_READY_TIME;
// eye outside fix window for the duration of READY_TIME
declare int TRL_READY_TIME;
// time fixspot was first ON
declare int TRL_FIX_ON_TIME;
// eye on fixspot
declare int TRL_FIX_ACQ_TIME;
// fixation achieved eye on fixspot for FIX_HOLD_TIME
declare int TRL_FIXATED_TIME;
declare int TRL_BREAK_FIX_TIME;

// when command sent to vdosync
declare int TRL_PRE_TARG_ON_TIME;
// when PD trigger occurs
declare int TRL_TARG_ON_TIME;
// Actively count how long target was on
declare int TRL_TARG_ON_DURATION;
// saccade entered target window
declare int TRL_DECIDE_TIME;
// saccde left Fix window between MIN_MAX saccade time
declare int TRL_SACC_TIME;
// saccade left Fix window before MIN saccade time
declare int TRL_ERLY_SACC_TIME;
// saccade left Fix window after MAX saccade time
declare int TRL_LATE_SACC_TIME;
// should make a saccade, but eye still in Fix window
declare int TRL_NO_SACCADE_TIME;
// saccade left Fix window, but eye not in Target window
declare int TRL_ERROR_SACCADE_TIME;
// saccade dutation
declare int TRL_SACC_DURATION;
// saccade made within max saccade duration
declare int TRL_TARG_ACQ_TIME;
// saccade took more than max saccade duration
declare int TRL_TARG_ACQ_SLOW_TIME;
// target fixation achieved time
declare int TRL_TARG_FIXATED_TIME;
// target was fixated for this amount of time
declare int TRL_TARG_HOLD_DURATION;

// target fixation broken
declare int TRL_TARG_BREAK_FIX_TIME;
declare int TRL_TARG_BRK_FIX_PRE_TONE_TIME;
declare int TRL_TARG_BRK_FIX_TONE_TIME;
declare int TRL_TARG_BRK_FIX_PRE_RWRD_TIME;
declare int TRL_TARG_BRK_FIX_RWRD_TIME;

// Tone and reward times
declare int TRL_TONE_ON_TIME;
declare int TRL_TONE_OFF_TIME;
declare int TRL_RWRD_ON_TIME;
declare int TRL_RWRD_OFF_TIME;
declare int TRL_XTRA_RWRD_ON_TIME;
declare int TRL_XTRA_RWRD_OFF_TIME;


// any break fixations?
declare int TRL_ABORT_TIME;
// number of vertical refreshs FIXSPOT with PD was on
declare int TRL_FIX_VRT_RFRSH_COUNT;
// number of vertical refreshs TARGET with PD was on
declare int TRL_TARG_VRT_RFRSH_COUNT;

process SET_CMD_TRL()
{
  // setup trial type
  spawnwait PCK_TRL_TYP();
  // pick current target location AND SET WINDOWS
  CURR_TARG_IDX = CURR_TARG_IDX +1;
  CURR_TARG_IDX = (CURR_TARG_IDX) % N_TARG_POS;
  //CURR_TARG_IDX = random(N_TARG_POS);
  // Target stimulus on this trial
  CURR_TARG_SIZE         = TARG_SIZE_ARRY[CURR_TARG_IDX];
  CURR_TARG_ANGLE        = TARG_ANGLE_ARRY[CURR_TARG_IDX];
  CURR_TARG_ECCENTRICITY = TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
  // Zero is black.  see SET_CLRS.pro
  CURR_TARG_COLOR_IDX = CLR_IDX_TARG_1;

  spawnwait SET_WINS();

  // Update graph object for Target
  spawnwait GRAF_UPD8_FIX();
  spawnwait GRAF_UPD8_TARG();
  // Show the windows - without the fixspot or target to cue user

  printf("TRIAL_TYPE %d, CURR_TARG_IDX %d, CURR_TARG_ANGLE %d\n",TRIAL_TYPE,CURR_TARG_IDX, CURR_TARG_ANGLE);

  // Setup CMD PAGES
  printf("Calling CMD-PGS\n");
  spawnwait CMD_PGS();

  // Set up any timing jitters etc
  FIX_HOLD_TIME = random(MIN_MAX_FIX_HOLD_TIME[1]-MIN_MAX_FIX_HOLD_TIME[0]) + MIN_MAX_FIX_HOLD_TIME[0];

  REWARD_DURATION = BASE_REWARD_DURATION;

  MIN_TARGET_HOLD_TIME = USE_TONE_AND_REWRD_FOR_MIN_THT*(TONE_DELAY+TONE_DURATION+REWARD_DELAY+REWARD_DURATION) + BASE_TARG_HOLD_TIME;

  printf("MIN_TARGET_HOLD_TIME = %d*(%d+%d+%d+%d) + %d = %d\n",USE_TONE_AND_REWRD_FOR_MIN_THT,
        TONE_DELAY,TONE_DURATION,REWARD_DELAY,REWARD_DURATION,BASE_TARG_HOLD_TIME,MIN_TARGET_HOLD_TIME);

  ITI_TIME = BASE_ITI_TIME;

  // TRL_LENGTH_TIME
  TEMP_TRL_LENGTH_TIME = GET_REDY + ALLOWED_FIX_TIME +MIN_MAX_FIX_HOLD_TIME[1] +MIN_MAX_SACCADE_TIME[1] + MAX_SACCADE_DURATION;
  TEMP_TRL_LENGTH_TIME = TRL_LENGTH_TIME + BASE_TARG_HOLD_TIME + TONE_DELAY + TONE_DURATION+REWARD_DELAY+REWARD_DURATION+BASE_ITI_TIME;

  if (TRL_LENGTH_TIME < TEMP_TRL_LENGTH_TIME)
  {
    // error alert user that for fixed trial length duration, the computed TRL_LENGTH_TIME > than that specified
    // so adjust all times?
    printf("******Computed trial length time exceeds fixed trial length time specified******\n");
    dshow Main_menu;
  }

} /* SETC_TRL */


process PCK_TRL_TYP()
{
  declare float trlType;

  trlType = (1.0 + random(9999))/100.0;
  if (trlType <= GO_WEIGHT)
  {
    TRIAL_TYPE = TRIAL_TYPE_GO;
  }
  else
  {
    TRIAL_TYPE = TRIAL_TYPE_STOP;
  }

}/* PCK_TRL_TYP */


process SET_WINS()
{
  declare float eccX, eccY;

  // Compute fix win size
  // Fix spot center is at 0,0, so we do not need to compute
  FIX_WIN[LEFT]  = -FIX_WIN_SIZE/2;
  FIX_WIN[RIGHT] = FIX_WIN_SIZE/2;
  FIX_WIN[UP]    = -FIX_WIN_SIZE/2;
  FIX_WIN[DOWN]  = FIX_WIN_SIZE/2;
  // Larger fix win - For inaccurate eye position
  FIX_WIN_LARGE[LEFT]  = -FIX_WIN_SIZE_LARGE/2;
  FIX_WIN_LARGE[RIGHT] = FIX_WIN_SIZE_LARGE/2;
  FIX_WIN_LARGE[UP]    = -FIX_WIN_SIZE_LARGE/2;
  FIX_WIN_LARGE[DOWN]  = FIX_WIN_SIZE_LARGE/2;
  // Compute TARG_WIN and TARG_WIN_LARGE
  eccX            = cos(TARG_ANGLE_ARRY[CURR_TARG_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
  eccY            = -sin(TARG_ANGLE_ARRY[CURR_TARG_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
  TARG_WIN[LEFT]  = eccX - TARG_WIN_SIZE/2;
  TARG_WIN[RIGHT] = eccX + TARG_WIN_SIZE/2;
  TARG_WIN[UP]    = eccY - TARG_WIN_SIZE/2;
  TARG_WIN[DOWN]  = eccY + TARG_WIN_SIZE/2;
  // Larger target window - For inaccurate eye position
  TARG_WIN_LARGE[LEFT]  = eccX - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_LARGE[RIGHT] = eccX + TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_LARGE[UP]    = eccY - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_LARGE[DOWN]  = eccY + TARG_WIN_SIZE_LARGE/2;
  // Compute TARG_WIN_ANTI and TARG_WIN_LARGE_ANTI
  eccX                 = cos(TARG_ANGLE_ARRY[CURR_TARG_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
  eccY                 = -sin(TARG_ANGLE_ARRY[CURR_TARG_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
  TARG_WIN_ANTI[LEFT]  = eccX - TARG_WIN_SIZE/2;
  TARG_WIN_ANTI[RIGHT] = eccX + TARG_WIN_SIZE/2;
  TARG_WIN_ANTI[UP]    = eccY - TARG_WIN_SIZE/2;
  TARG_WIN_ANTI[DOWN]  = eccY + TARG_WIN_SIZE/2;
  // Larget ANTI target window - For inaccurate Eye position
  TARG_WIN_ANTI_LARGE[LEFT]  = eccX - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_ANTI_LARGE[RIGHT] = eccX + TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_ANTI_LARGE[UP]    = eccY - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_ANTI_LARGE[DOWN]  = eccY + TARG_WIN_SIZE_LARGE/2;
} /* SET_WINS */
