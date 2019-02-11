//==========================================================================
// TARG_VR.PRO
//   Description: Process to count target vertical refresh
//                EPD Marker set on the top-left of Target page
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-02-06
//==========================================================================
//  Revision History:


declare CHECK_TARG_VERT_RFRSH();


// For counting Target vertical refresh for both GO and STOP trials
process CHECK_TARG_VERT_RFRSH()
{
    declare int trigWidth = 3;

    if (PD_TRIG_L)
    {
        if (TRL_TARG_VRT_RFRSH_COUNT == 0)
        {
            TRL_IS_TARG_ON_FLAG      = 1;
            TRL_TARG_VRT_RFRSH_COUNT = 1;
        }
        else if ((STAT_DLTA_T - TARG_VR_COUNT_TIME) > trigWidth)
        {
            TRL_TARG_VRT_RFRSH_COUNT = TRL_TARG_VRT_RFRSH_COUNT + 1;
        }
        TARG_VR_COUNT_TIME = STAT_DLTA_T;
    }
} /* CHECK_TARG_VERT_RFRSH */
