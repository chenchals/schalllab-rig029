//==========================================================================
// VAR_STIM.PRO
//   Description: Global declares for Stimulus variables
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//
// Utility Vares
declare int RGB_R_IDX = 0;
declare int RGB_G_IDX = 1;
declare int RGB_B_IDX = 2;
// Fix vars
declare float FIX_SIZE_DEG = 0.5;
declare int   FIX_COLOR[3];
// Stimulus - target attributes
declare constant int MAX_TARG_POS = 12;
declare int   N_TARG_POS;
declare int   TARG_COLOR_IDX_ARRY[MAX_TARG_POS];
declare int   TARG_COLOR_ARRY[MAX_TARG_POS, 3];
declare float TARG_SIZE_ARRY[MAX_TARG_POS];
declare float TARG_ANGLE_ARRY[MAX_TARG_POS];
declare float TARG_ECCENTRICITY_ARRY[MAX_TARG_POS];
// Stop / ignore trial Cue
declare int   STOP_SIGNAL_COLOR[3];
declare int   IGNORE_SIGNAL_COLOR[3];
// Photocell marker CURR_TARG_SIZE
declare float PD_WIDTH_DEG = 4.0;

declare SET_DEFAULT_STIM_VARS();

process SET_DEFAULT_STIM_VARS()
{
	declare int tempCounter;

	FIX_COLOR[RGB_R_IDX] = RED_VAL - WR_OFF;
	FIX_COLOR[RGB_G_IDX] = GREEN_VAL - WG_OFF;
	FIX_COLOR[RGB_B_IDX] = BLUE_VAL - WB_OFF;

	STOP_SIGNAL_COLOR[RGB_R_IDX] = 17;
	STOP_SIGNAL_COLOR[RGB_G_IDX] = 13;
	STOP_SIGNAL_COLOR[RGB_B_IDX] = 14;

	IGNORE_SIGNAL_COLOR[RGB_R_IDX] = 41;
	IGNORE_SIGNAL_COLOR[RGB_G_IDX] = 42;
	IGNORE_SIGNAL_COLOR[RGB_B_IDX] = 43;
	
	N_TARG_POS = MAX_TARG_POS;
	// Default Target size, color, angle, eccentricity
	while (tempCounter < N_TARG_POS)
	{
		TARG_SIZE_ARRY[tempCounter] = 0.5;
		TARG_COLOR_ARRY[tempCounter,RGB_R_IDX] = 35;
		TARG_COLOR_ARRY[tempCounter,RGB_G_IDX] = 33;
		TARG_COLOR_ARRY[tempCounter,RGB_B_IDX] = 27;
		TARG_ANGLE_ARRY[tempCounter] = tempCounter * (360.0/N_TARG_POS);
		TARG_ECCENTRICITY_ARRY[tempCounter] = 3.0;
		tempCounter = tempCounter + 1;
	}
	
	
}