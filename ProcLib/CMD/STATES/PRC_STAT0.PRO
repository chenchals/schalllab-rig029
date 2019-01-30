//==========================================================================
// PRC_STAT.PRO
//   Description: Process states for Countermanding. All states are based
//                on EYE POSITION and current TASK PHASE
//                A STATE should ideally know about
//                1. STAT_PREV : State it came from
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_NEXT : Must be able to set NEXT STATE
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-28
//==========================================================================
//  Revision History:
//

declare SET_CURR_STAT(int inTime);
declare SET_STAT_EYE_LOC();
declare PROC_WAIT_FIX(int inTime, int inDuration);
declare PROC_FIX_ON(int inTime, int inDuration);
declare PROC_FIXATE(int inTime, int inDuration);
declare PROC_TARG_ON(int inTime, int inDuration);
declare PROC_FIXATE_TARG(int inTime, int inDuration, int holdTime);


//Current State variables in the absence of structs
declare int PREV_STAT;
declare int CURR_STAT;
declare int STAT_STRT_T;
declare int STAT_STP_T;
declare int STAT_DLTA_T;
declare int STAT_OUTCOME;


//
// Fixspot is NOT ON: Waiting for subj to be ready
// Check: Eyes are hanging around the FIX_WIN_LARGE.
//        Eye has not *crossed* FIX_WIN_LARGE within REDY_T
//        Outcome -->go to (set)--->Next State ------> Action
//        O_REDY      --->   STAT_FIX_ON -----> Show Fixspot
//        O_NOT_REDY  --->   STAT_IDLE  ------> Do not show Fixspot
process PROC_WAIT_FIX(int inTime, int inDuration)
{
  spawnwait SET_CURR_STAT(inTime);

  while (STAT_DLTA_T <= inDuration)
  {
    STAT_DLTA_T = time() - STAT_STRT_T;
    if (EYE_IN_FIX_WIN || EYE_BTWN_FIX_WINS)
    {
      //Reset counter
      STAT_DLTA_T = 0;
    }
    nexttick;
  }
  STAT_STP_T   = time();
  STAT_OUTCOME = O_REDY;
}


// Fixspot is ON: Waiting for subject to reach the fix window and Fixate
// Check: Eyes must get to WITHIN smaller FIX_WIN, BEFORE FIX_ACQ_T expires
//        Outcome -->go to (set)--->Next State
//        O_ACQ_FIX      --->   STAT_FIXATE
//        O_ACQ_FIX_WIDE --->   Timeout? STAT_IDLE
//        O_ACQ_FIX_BRK  --->   Timeout? STAT_IDLE
process PROC_FIX_ON(int inTime, int inDuration)
{
  declare int done;

  spawnwait SET_CURR_STAT(inTime);

  while (STAT_DLTA_T <= inDuration || ~done)
  {
    STAT_DLTA_T = time() - STAT_STRT_T;
    if (EYE_IN_FIX_WIN)
    {
      STAT_OUTCOME = O_ACQ_FIX;
      done         = 1;
    }
    else
    {
      done = 0;
      if (EYE_BTWN_FIX_WINS)
      {
        STAT_OUTCOME = O_ACQ_FIX_WIDE;
      }
      else
      {
        STAT_OUTCOME = O_FIXATE_BRK;
      }
    }
    nexttick;
  }
  STAT_STP_T = time();
}


// Fixspot is ON: Waiting for subject to stay on fixspot
// Check: Eyes must be WITHIN smaller FIX_WIN until FIX_TIME (HOLD_TIME) expires
//        Outcome -->go to (set)--->Next State
//        O_FIXATE       --->   STAT_TARG_ON
//        O_FIXATE_WIDE --->   Timeout? STAT_IDLE
//        O_FIXATE_BRK  --->   Timeout? STAT_IDLE
process PROC_FIXATE(int inTime, int inDuration)
{
  declare int done;

  spawnwait SET_CURR_STAT(inTime);

  while (STAT_DLTA_T <= inDuration || ~done)
  {
    STAT_DLTA_T = time() - STAT_STRT_T;
    if (EYE_IN_FIX_WIN)
    {
      STAT_OUTCOME = O_FIXATE;
      done         = 0;
    }
    else
    {
      done = 1;
      if (EYE_BTWN_FIX_WINS)
      {
        STAT_OUTCOME = O_FIXATE_WIDE;
      }
      else
      {
        STAT_OUTCOME = O_FIXATE_BRK;
      }
    }
    nexttick;
  }

  STAT_STP_T = time();
}


// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject to shift gaze to target location
// Check: Eyes leave fixspot and reach TARG_WIN or TARG_WIN_ANTI after MIN_SACCADE_TIME and
//        before MAX_SACCADE_TIME, within MAX_SACCADE_DURATION
//        Outcome              -->go to (set)--->Next State
//        O_ACQ_TARG           --->   STAT_FIXATE_TARG
//        O_ACQ_TARG_WIDE      --->   Timeout? next_state? STAT_IDLE?
//        O_ACQ_TARG_ANTI      --->   Timeout? tone? next_state? STAT_IDLE
//        O_ACQ_TARG_WIDE_ANTI --->   Timeout? tome? next_state? STAT_IDLE
//        O_ACQ_TARG_BRK       --->   Timeout? tone? STAT_IDLE
process PROC_TARG_ON(int inTime, int inDuration)
{
  declare int done;

  spawnwait SET_CURR_STAT(inTime);

  while (STAT_DLTA_T <= inDuration || ~done)
  {
    STAT_DLTA_T = time() - STAT_STRT_T;
    if (EYE_IN_FIX_WIN)
    {
      STAT_OUTCOME = O_FIXATE;
      done         = 0;
    }
    else
    {
      done = 1;
      if (EYE_BTWN_FIX_WINS)
      {
        STAT_OUTCOME = O_ACQ_TARG_BRK;
      }
      else if (EYE_IN_TARG_WIN)
      {
        STAT_OUTCOME = O_ACQ_TARG;
      }
      else if (EYE_BTWN_TARG_WINS)
      {
        STAT_OUTCOME = O_ACQ_TARG_WIDE;
      }
      else if (EYE_IN_TARG_WIN_ANTI)
      {
        STAT_OUTCOME = O_ACQ_TARG_ANTI;
      }
      else if (EYE_BTWN_TARG_WINS_ANTI)
      {
        STAT_OUTCOME = O_ACQ_TARG_WIDE_ANTI;
      }
    }
    nexttick;
  }
  STAT_STP_T = time();
} /* PROC_TARG_ON */


// Fixspot is OFF Target is ON:
//        GO_TRIAL: Waiting for subject to shift gaze to target location and hold
// Check: Eyes leave fixspot and reach TARG_WIN or TARG_WIN_ANTI after MIN_SACCADE_TIME and
//        before MAX_SACCADE_TIME, within MAX_SACCADE_DURATION and stay for TARG_HOLD_TIME
//        Outcome              -->go to (set)--->Next State
//        O_FIXATE_TARG           --->   STAT_FIXATE_TARG
//        O_FIXATE_TARG_WIDE      --->   Timeout? next_state? STAT_IDLE?
//        O_FIXATE_TARG_ANTI      --->   Timeout? tone? next_state? STAT_IDLE
//        O_FIXATE_TARG_WIDE_ANTI --->   Timeout? tome? next_state? STAT_IDLE
//        O_FIXATE_TARG_BRK       --->   Timeout? tone? STAT_IDLE
process PROC_FIXATE_TARG(int inTime, int inDuration)
{
  declare int done;

  spawnwait SET_CURR_STAT(inTime);

  while (STAT_DLTA_T <= inDuration || ~done)
  {
    STAT_DLTA_T = time() - STAT_STRT_T;
    if (EYE_IN_FIX_WIN)
    {
    }
    else
    {
    }

    nexttick;
  }
  STAT_STP_T = time();
}


process SET_CURR_STAT(int inTime)
{
  PREV_STAT   = CURR_STAT;
  CURR_STAT   = STAT_WAIT_FIX;
  STAT_STRT_T = inTime;
  STAT_DLTA_T = 0;
}
