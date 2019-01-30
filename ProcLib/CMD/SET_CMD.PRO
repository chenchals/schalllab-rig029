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

// Trial Timees
declare int TRL_READY_TIME;
declare int TRL_START_TIME;
declare int TRL_END_TIME;
declare int TRL_FIX_ON_TIME;
declare int TRL_FIX_ACQ_TIME;
declare int TRL_FIXATED_TIME;
declare int TRL_TARG_ON_TIME;
declare int TRL_SACCADE_TIME;
declare int TRL_TARG_ACQ_TIME;
declare int TRL_TARG_FIXATED_TIME;
declare int TRL_DECIDE_TIME;

process SET_CMD_TRL()
{
  // setup trial type
  spawnwait PCK_TRL_TYP();
  // pick current target location AND SET WINDOWS
  CURR_TARGET_IDX = (CURR_TARGET_IDX + 1) % N_TARG_POS;
  spawnwait SET_WINS();
  // Setup CMD PAGES
  spawnwait CMD_PGS();

  // Set up any timing jitters etc
  FIX_HOLD_TIME = random(MIN_MAX_FIX_HOLD_TIME[1]-MIN_MAX_FIX_HOLD_TIME[0]) + MIN_MAX_FIX_HOLD_TIME[0];
  TARGET_HOLD_TIME = random(MIN_MAX_TARGET_HOLD_TIME[1]-MIN_MAX_TARGET_HOLD_TIME[0]) + MIN_MAX_TARGET_HOLD_TIME[0];
  // ITI TIME?


  // wait 1 sec for everything to complete
  nexttick 1000;
} /* SETC_TRL */


process PCK_TRL_TYP()
{
  declare float trlType;

  trlType = (1.0 + random(9999))/100.0;
  printf("trlType %2.3d ", trlType);
  if (trlType <= GO_WEIGHT)
  {
    TRIAL_TYPE = TRIAL_TYPE_GO;
  }
  else if (trlType <= GO_WEIGHT + STOP_WEIGHT)
  {
    TRIAL_TYPE = TRIAL_TYPE_STOP;
  }
  else
  {
    TRIAL_TYPE = TRIAL_TYPE_IGNORE;
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
  eccX            = cos(TARG_ANGLE_ARRY[CURR_TARGET_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  eccY            = -sin(TARG_ANGLE_ARRY[CURR_TARGET_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
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
  eccX                 = cos(TARG_ANGLE_ARRY[CURR_TARGET_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  eccY                 = -sin(TARG_ANGLE_ARRY[CURR_TARGET_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
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
