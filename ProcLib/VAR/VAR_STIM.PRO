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
// Stimulus - target attributes
declare constant int MAX_TARG_POS = 12;
declare int          N_TARG_POS;
declare int          TARG_COLOR_IDX_ARRY[MAX_TARG_POS];
declare int          TARG_COLOR_ARRY[MAX_TARG_POS, 3];
declare float        TARG_SIZE_ARRY[MAX_TARG_POS];
declare float        TARG_ANGLE_ARRY[MAX_TARG_POS];
declare float        TARG_ECCENTRICITY_ARRY[MAX_TARG_POS];
declare float        TARG_WIN_SIZE = 7;
declare float        TARG_WIN[MAX_TARG_POS, 4];
declare int          EYE_IN_TARG_WIN;

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
  // Fix spot center is at 0,0
  FIX_WIN[LEFT]  = -FIX_WIN_SIZE / 2;
  FIX_WIN[RIGHT] = FIX_WIN_SIZE / 2;
  FIX_WIN[UP]    = -FIX_WIN_SIZE / 2;
  FIX_WIN[DOWN]  = FIX_WIN_SIZE / 2;

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
    TARG_ANGLE_ARRY[tempCounter]        = -tempCounter * (360.0 / N_TARG_POS);
    TARG_ECCENTRICITY_ARRY[tempCounter] = 3.0;
    tempCounter                         = tempCounter + 1;
    nexttick;
  }

  tempCounter = 0;
  while (tempCounter < N_TARG_POS)
  {
    targEccX                     = cos(TARG_ANGLE_ARRY[tempCounter]) * TARG_ECCENTRICITY_ARRY[tempCounter];
    targEccY                     = -sin(TARG_ANGLE_ARRY[tempCounter]) * TARG_ECCENTRICITY_ARRY[tempCounter];
    TARG_WIN[tempCounter, LEFT]  = targEccX - TARG_WIN_SIZE / 2;
    TARG_WIN[tempCounter, RIGHT] = targEccX + TARG_WIN_SIZE / 2;
    TARG_WIN[tempCounter, UP]    = targEccY - TARG_WIN_SIZE / 2;
    TARG_WIN[tempCounter, DOWN]  = targEccY + TARG_WIN_SIZE / 2;
    tempCounter                  = tempCounter + 1;
    nexttick;
  }
} /* SET_DEFAULT_STIM_VARS */
