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
declare int          EYE_BTWN_TARG_WINS;
declare int          EYE_BTWN_TARG_WINS_ANTI;

// Attributes of Current Target
declare int   CURR_TARGET_IDX;
declare float CURR_TARG_SIZE;
declare float CURR_TARG_ANGLE;
declare float CURR_TARG_ECCENTRICITY;
declare int   CURR_TARG_COLOR_IDX;


// Photocell marker CURR_TARG_SIZE
declare float PD_WIDTH_DEG = 4.0;

declare SET_DEFAULT_STIM_VARS();


process SET_DEFAULT_STIM_VARS()
{
  declare int   tempCounter;
  declare float targEccX, targEccY;

  N_TARG_POS  = MAX_TARG_POS;
  tempCounter = 0;
  // Default all target sizes to same
  TARG_SIZE_ARRY[N_TARG_POS] = 0.5;
  // Default all eccentricities to be same
  TARG_ECCENTRICITY_ARRY[N_TARG_POS] = 12.0;

  // Default Target angle
  while (tempCounter < N_TARG_POS)
  {
    // clockwise: 45, 90, 135, ...
    TARG_ANGLE_ARRY[tempCounter] = tempCounter * (360.0 / N_TARG_POS);
    if (TARG_ANGLE_ARRY[tempCounter] > 180)
    {
      // counter clockwise : -45, -90, -135, ...
      TARG_ANGLE_ARRY[tempCounter] = TARG_ANGLE_ARRY[tempCounter] - 360;
    }
    tempCounter = tempCounter + 1;
    nexttick;
  }
} /* SET_DEFAULT_STIM_VARS */
