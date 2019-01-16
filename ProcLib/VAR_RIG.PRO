//==========================================================================
// VAR_RIG.PRO
// Description:Set global variable for all RIGS.
// Screen settings, isoluminant colors, data acquisition channels
// These should be defined in RIG_xxx() processes in RIGS/ subdir
// Author: chenchal.subraveti@vanderbilt.edu
// Date: 2019-01-16
//==========================================================================
// Revision History:
// 001: 2019/01/16 chenchal subraveti
// Renamed from VAR_029 as this file contains variables declarations only 
// Global variables for ALL rigs
declare int RIG;
//==========================================================================
// Screen width and height in pixels
declare int SCRN_PIX_X;
declare int SCRN_PIX_Y;
// Screen width and height in mm
declare float SCRN_MM_X;
declare float SCRN_MM_Y;
declare float REFRESH_RATE; // Distance from center of Subject's eyeball to screen
declare float SUBJ_DIST_MM; // ISOLUMINANT colors
//==========================================================================
declare int RED_VAL;
declare int GREEN_VAL;
declare int BLUE_VAL;
declare int YR_OFF;
declare int MR_OFF;
declare int MB_OFF;
declare int CG_OFF;
declare int CB_OFF;
declare int WR_OFF;
declare int WG_OFF;
declare int WB_OFF; // DATA ACQUISITION PARAMS
//==========================================================================
// Eye x scaling factor to convert eye trace voltage to degrees declare float EYE_X_GAIN;//5.1;//9.74; //50; //3.492;
// Eye y scaling factor to convert eye trace voltage to degrees
declare float EYE_X_GAIN; 
declare float EYE_Y_GAIN; 
// Hardware setup
declare int JUICE_CHANNEL;
declare int STIM_CHANNEL;
declare int EYE_X_CHANNEL;
declare int EYE_Y_CHANNEL;
declare int PHOTOCELL_L_CHANNEL;
declare int PHOTOCELL_R_CHANNEL;
//Check das_gain and das_polarity in kped (setup tn)
declare int MAX_VOLTAGE; 
// Base the number on n-bits of AD board
declare int ANALOG_UNITS; 