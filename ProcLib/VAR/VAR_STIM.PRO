//==========================================================================
// VAR_STIM.PRO
//   Description: Global declares for Stimulus variables
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//

// Fix vars
//=========== Window sizes (degrees) ==================

declare int          FIX_COLOR[3];
declare float        FIX_SIZE_DEG = 0.5;
declare float        FIX_WIN_SIZE = 5;
declare float        FIX_WIN[4];
declare int          EYE_IN_FIX_WIN;
declare float        FIX_WIN_SIZE_LARGE = FIX_WIN_SIZE * 1.5;
declare float        FIX_WIN_LARGE[4];
declare int          EYE_BTWN_FIX_WINS;
// Stimulus - target attributes
declare constant int MAX_TARG_POS = 12;
declare int          N_TARG_POS;
declare int          TARG_COLOR_IDX_ARRY[MAX_TARG_POS];
declare int          TARG_COLOR_ARRY[MAX_TARG_POS, 3];
declare float        TARG_SIZE_ARRY[MAX_TARG_POS];
declare float        TARG_ANGLE_ARRY[MAX_TARG_POS];
declare float        TARG_ECCENTRICITY_ARRY[MAX_TARG_POS];
declare float        TARG_WIN_SIZE = 7;
declare float        TARG_WIN[4];
declare float        TARG_WIN_ANTI[4];
declare int          EYE_IN_TARG_WIN;
declare int          EYE_IN_TARG_WIN_ANTI;
declare float        TARG_WIN_SIZE_LARGE = TARG_WIN_SIZE * 1.5;
declare float        TARG_WIN_LARGE[4];
declare float        TARG_WIN_ANTI_LARGE[4];
declare int          CURR_TARG_IDX;
declare int          EYE_BTWN_TARG_WINS;
declare int          EYE_BTWN_TARG_WINS_ANTI;

// Stop / ignore trial Cue
declare int   STOP_SIGNAL_COLOR[3];
declare int   IGNORE_SIGNAL_COLOR[3];
// Photocell marker CURR_TARG_SIZE
declare float PD_WIDTH_DEG = 4.0;

declare SET_DEFAULT_STIM_VARS();


process SET_DEFAULT_STIM_VARS()
{
  declare int   tempCounter;
  declare float targEccX, targEccY;

  FIX_COLOR[R_IDX] = RED_VAL - WR_OFF;
  FIX_COLOR[G_IDX] = GREEN_VAL - WG_OFF;
  FIX_COLOR[B_IDX] = BLUE_VAL - WB_OFF;

  STOP_SIGNAL_COLOR[R_IDX] = 17;
  STOP_SIGNAL_COLOR[G_IDX] = 13;
  STOP_SIGNAL_COLOR[B_IDX] = 14;

  IGNORE_SIGNAL_COLOR[R_IDX] = 41;
  IGNORE_SIGNAL_COLOR[G_IDX] = 42;
  IGNORE_SIGNAL_COLOR[B_IDX] = 43;

  N_TARG_POS  = MAX_TARG_POS;
  tempCounter = 0;
  // Default Target size, color, angle, eccentricity
  while (tempCounter < N_TARG_POS)
  {
    TARG_SIZE_ARRY[tempCounter] = 0.5;
    // 0 is reserved for black
    TARG_COLOR_IDX_ARRY[tempCounter]    = tempCounter + 1;
    TARG_COLOR_ARRY[tempCounter, R_IDX] = 35;
    TARG_COLOR_ARRY[tempCounter, G_IDX] = 33;
    TARG_COLOR_ARRY[tempCounter, B_IDX] = 27;
    // counter-clockwise: 0, -45, -19, -135
    TARG_ANGLE_ARRY[tempCounter]        = -tempCounter * (360.0 / N_TARG_POS);
    if (TARG_ANGLE_ARRY[tempCounter] <= -180)
    {
      // clockwise: 45, 90, 135,180
      TARG_ANGLE_ARRY[tempCounter] = TARG_ANGLE_ARRY[tempCounter] + 360;
    }
    TARG_ECCENTRICITY_ARRY[tempCounter] = 3.0;
    tempCounter                         = tempCounter + 1;
    nexttick;
  }
} /* SET_DEFAULT_STIM_VARS */
