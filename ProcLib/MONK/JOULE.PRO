//==========================================================================
// JOULE.PRO
//   Description: Setsup default parameters subject JOULE_ID.
//
//   NOTE:
//       Create one monk_name.PRO file for each monk used.  Define
//       parameters as needed for that subject
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-15
//==========================================================================
//  Revision History:
//

declare JOULE();


process JOULE()
{
  declare int tempVar = 0;

  //SSD list is not set
  while (tempVar < N_SSD_MAX)
  {
    SSD_ARRY[tempVar] = tempVar * 2 + 2;
    tempVar           = tempVar + 1;
  }
  // See CMD_VARS and add those that you want to change.
  // Check VAR_STIM.PRO --> SET_DEFAULT_STIM_VARS()
  FIX_COLOR[R_IDX] = RED_VAL - WR_OFF;
  FIX_COLOR[G_IDX] = GREEN_VAL - WG_OFF;
  FIX_COLOR[B_IDX] = BLUE_VAL - WB_OFF;

  STOP_SIGNAL_COLOR[R_IDX] = 17;
  STOP_SIGNAL_COLOR[G_IDX] = 13;
  STOP_SIGNAL_COLOR[B_IDX] = 14;

  IGNORE_SIGNAL_COLOR[R_IDX] = 41;
  IGNORE_SIGNAL_COLOR[G_IDX] = 42;
  IGNORE_SIGNAL_COLOR[B_IDX] = 43;
  // Check VAR_STIM.PRO --> SET_DEFAULT_STIM_VARS()
  N_TARG_POS = 2;
  tempVar    = 0;
  while (tempVar < MAX_TARG_POS)
  {
    TARG_SIZE_ARRY[tempVar]         = 5.0;
    TARG_ANGLE_ARRY[tempVar]        = -tempVar * (360.0 / N_TARG_POS);
    if (TARG_ANGLE_ARRY[tempVar] <= -180)
    {
      TARG_ANGLE_ARRY[tempVar] = TARG_ANGLE_ARRY[tempVar] + 360;
    }
    TARG_ECCENTRICITY_ARRY[tempVar] = 12.0;
    TARG_COLOR_ARRY[tempVar, R_IDX] = 35;
    TARG_COLOR_ARRY[tempVar, G_IDX] = 33;
    TARG_COLOR_ARRY[tempVar, B_IDX] = 27;
    TARG_COLOR_IDX_ARRY[tempVar]    = tempVar + 1;
    if (tempVar > N_TARG_POS + 1)
    {
      TARG_SIZE_ARRY[tempVar]         = 0.0;
      TARG_ANGLE_ARRY[tempVar]        = 0.0;
      TARG_ECCENTRICITY_ARRY[tempVar] = 0;
      TARG_COLOR_ARRY[tempVar, R_IDX] = 0;
      TARG_COLOR_ARRY[tempVar, G_IDX] = 0;
      TARG_COLOR_ARRY[tempVar, B_IDX] = 0;
      TARG_COLOR_IDX_ARRY[tempVar]    = 0;
    }
    tempVar = tempVar + 1;
  }
} /* JOULE */
