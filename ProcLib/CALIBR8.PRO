//==========================================================================
// CALIBR8.PRO
//   Description: Calibrate Eye position for screen size and offsets
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-11
//==========================================================================
//  Revision History:



declare constant int N_CALIB_POS    = 9;
// calibration dot position on screen: [center, N, S, W, E, NW, NE, SW, SE]
declare constant int N_CALIB_ANGLES = {0, 90, 270, 180, 0, 135, 45, 225, 315};
declare float CALIB_ECCENTRICITY = 12.0;
declare int          CALIBRATING;


declare PROC_CLIBRATE();
declare PROC_CALIB_PGS();


process PROC_CLIBRATE()
{
    printf("Eye Clibration in progress...\n");
    spawnwait SET_RIG(RIG_ID);

    while (CALIBRATING)
    {
        // cycle thorugh pages to show calibration dots on screen
    }
}
