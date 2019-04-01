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
    // See VAR_CMD.PRO
    SSD_ARRY[0] = 4;
    SSD_ARRY[1] = 9;
    SSD_ARRY[2] = 14;
    SSD_ARRY[3] = 19;
    SSD_ARRY[4] = 24;
    SSD_ARRY[5] = 29;
    SSD_ARRY[6] = 34;
    SSD_ARRY[7] = 39;
    SSD_ARRY[8] = 44;
    SSD_ARRY[9] = 49;

    tempVar = 10;
    while (tempVar < N_SSD_MAX)
    {
        SSD_ARRY[tempVar] = 0;
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
    // This will be CLR_IDX_TARG_1
    COLOR_ARRY[0, R_IDX] = 35;
    COLOR_ARRY[0, G_IDX] = 33;
    COLOR_ARRY[0, B_IDX] = 27;

    // Check VAR_STIM.PRO --> SET_DEFAULT_STIM_VARS()
    N_TARG_POS = 2;
    tempVar    = 0;
    while (tempVar < MAX_TARG_POS)
    {
        if (tempVar >= N_TARG_POS)
        {
            TARG_SIZE_ARRY[tempVar]         = 0.0;
            TARG_ANGLE_ARRY[tempVar]        = 0.0;
            TARG_ECCENTRICITY_ARRY[tempVar] = 0;
        }
        else
        {
            TARG_SIZE_ARRY[tempVar]         = 0.5;
            TARG_ANGLE_ARRY[tempVar]        = tempVar * (360.0/N_TARG_POS);
            TARG_ECCENTRICITY_ARRY[tempVar] = 15.0;
        }
        FIX_WIN_SIZE       = 8;
        FIX_WIN_SIZE_LARGE = FIX_WIN_SIZE * 1.5;

        TARG_WIN_SIZE       = 12;
        TARG_WIN_SIZE_LARGE = TARG_WIN_SIZE * 1.5;

        tempVar = tempVar + 1;
    }
} /* JOULE */
