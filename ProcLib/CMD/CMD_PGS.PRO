//==========================================================================
// CMD_PGS.PRO
//   Description: Function to setup all PAGES for CMD task
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2018-12-07
//==========================================================================
//  Revision History:
//  001: 2018/12/10 chenchal subraveti
//       Global CURR_TARG_COLOR_IDX indices and palettes for colorIdxs
//

// Room variables
#include C:/TEMPO/ProcLib/UTIL/DRW_RECT.PRO

// Virtual Page indices
declare int   PG_BLANK       = 0;
declare int   PG_FIXATION_PD = 1;
declare int   PG_FIXATION    = 2;
declare int   PG_TARGET_PD   = 3;
declare int   PG_TARGET      = 4;
declare int   PG_SIGNAL_PD   = 5;
declare int   PG_SIGNAL      = 6;
// Attributes of Current Target
declare int   CURR_TARGET_IDX;
declare float CURR_TARG_SIZE;
declare float CURR_TARG_ANGLE;
declare float CURR_TARG_ECCENTRICITY;
declare int   CURR_TARG_COLOR_IDX;

declare CMD_PGS();


process CMD_PGS()
{
  declare float pdEccentricity;
  declare float pdAngleR;
  declare float pdAngleL;
  declare float opposite;
  declare float adjacent;

  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // Calculate screen coordinates for stimuli on this trial
  CURR_TARG_SIZE         = TARG_SIZE_ARRY[CURR_TARGET_IDX];
  CURR_TARG_ANGLE        = TARG_ANGLE_ARRY[CURR_TARGET_IDX];
  CURR_TARG_ECCENTRICITY = TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  // Zero is black.  see SET_CLRS.pro
  CURR_TARG_COLOR_IDX = CLR_IDX_TARG_1;
  // Update graph object for Target
  spawn GRAF_UPD8_FIX();
  spawn GRAF_UPD8_TARG();

  // For Photodiode marker
  adjacent = rad2deg(atan((SCRN_MM_X/2)/SUBJ_DIST_MM));

  opposite       = rad2deg(atan((SCRN_MM_Y/2)/SUBJ_DIST_MM));
  pdEccentricity = sqrt((opposite * opposite) + (adjacent * adjacent)) - 0.5;
  pdAngleL       = rad2deg(atan(opposite/adjacent)) + 180;
  pdAngleR       = -rad2deg(atan(opposite/adjacent));

  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 1 FIXATION_PD - PD is drawn on LEFT-TOP of screen only
  //printf("CMD_PGS: page %d FIX_SIZE %2.2d, PD_WIDTH_DEG %3.4d, pdAngleL %3.2d\n",PG_FIXATION_PD,FIX_SIZE_DEG,PD_WIDTH_DEG,pdAngleL);
  dsendf("rw %d,%d;\n", PG_FIXATION_PD, PG_FIXATION_PD);
  dsendf("cl:\n");
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_FIX, FILL);
  spawnwait DRW_RECT(PD_WIDTH_DEG, PD_WIDTH_DEG/4, pdAngleL, pdEccentricity, CLR_IDX_PTOTODIODE, FILL);

  //printf("-----------------\n");
  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 2 FIXATION - No PD
  //printf("CMD_PGS: page %d FIX_SIZE %2.2d, PD_WIDTH_DEG %3.4d\n",PG_FIXATION,FIX_SIZE_DEG);
  dsendf("rw %d,%d;\n", PG_FIXATION, PG_FIXATION);
  dsendf("cl:\n");
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_FIX, FILL);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 3 TARGET with PD - PD is drawn on LEFT-TOP of screen only
  //printf("CMD_PGS: page %d targetSize %2.2d, PD_WIDTH_DEG %3.4d, pdAngleL %3.2d\n",PG_TARGET_PD,CURR_TARG_SIZE,PD_WIDTH_DEG,pdAngleL);
  dsendf("rw %d,%d;\n", PG_TARGET_PD, PG_TARGET_PD);
  dsendf("cl:\n");
  // draw PG_TARGET
  spawnwait DRW_RECT(CURR_TARG_SIZE, CURR_TARG_SIZE, CURR_TARG_ANGLE, CURR_TARG_ECCENTRICITY, CURR_TARG_COLOR_IDX, FILL);

  // draw OPEN PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_FIX, OPEN);

  // Draw left PD marker
  spawnwait DRW_RECT(PD_WIDTH_DEG, PD_WIDTH_DEG/4, pdAngleL, pdEccentricity, CLR_IDX_PTOTODIODE, FILL);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 4 TARGET no PD
  //printf("CMD_PGS: page %d targetSize %2.2d\n",PG_TARGET,CURR_TARG_SIZE);
  dsendf("rw %d,%d;\n", PG_TARGET, PG_TARGET);
  dsendf("cl:\n");
  spawnwait DRW_RECT(CURR_TARG_SIZE, CURR_TARG_SIZE, CURR_TARG_ANGLE, CURR_TARG_ECCENTRICITY, CURR_TARG_COLOR_IDX, FILL);

  // draw OPEN PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_FIX, OPEN);

  nexttick;

  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 5 SIGNAL PD - PD is drawn on the right only
  //printf("CMD_PGS: page %d targetSize %2.2d, PD_WIDTH_DEG %3.4d, pdAngleR %3.2d\n",PG_SIGNAL_PD,CURR_TARG_SIZE,PD_WIDTH_DEG,pdAngleR);
  dsendf("rw %d,%d;\n", PG_SIGNAL_PD, PG_SIGNAL_PD);
  dsendf("cl:\n");
  spawnwait DRW_RECT(CURR_TARG_SIZE, CURR_TARG_SIZE, CURR_TARG_ANGLE, CURR_TARG_ECCENTRICITY, CURR_TARG_COLOR_IDX, FILL);

  // draw PG_TARGET
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_STOP_SIGNAL, FILL);

  // draw PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_FIX, OPEN);

  // Draw right PD marker
  spawnwait DRW_RECT(PD_WIDTH_DEG, PD_WIDTH_DEG/4, pdAngleR, pdEccentricity, CLR_IDX_PTOTODIODE, FILL);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 6 SIGNAL no PD
  //printf("CMD_PGS: page %d targetSize %2.2d\n",PG_SIGNAL,CURR_TARG_SIZE);
  dsendf("rw %d,%d;\n", PG_SIGNAL, PG_SIGNAL);
  dsendf("cl:\n");
  spawnwait DRW_RECT(CURR_TARG_SIZE, CURR_TARG_SIZE, CURR_TARG_ANGLE, CURR_TARG_ECCENTRICITY, CURR_TARG_COLOR_IDX, FILL);

  // draw PG_TARGET
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_STOP_SIGNAL, FILL);

  // draw PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG, FIX_SIZE_DEG, 0.0, 0.0, CLR_IDX_FIX, OPEN);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 0 BLANK (draw last so it is displayed as default))
  //printf("CMD_PGS: page %d PG_BLANK\n", PG_BLANK);
  // draw the PG_BLANK screen last so that it shows up first
  dsendf("rw %d,%d;\n", PG_BLANK, PG_BLANK);
  dsendf("cl:\n");
  nexttick;
} /* CMD_PGS */
