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
declare int PG_BLANK       = 0;
declare int PG_FIXATION_PD = 1;
declare int PG_FIXATION    = 2;
declare int PG_TARGET_PD   = 3;
declare int PG_TARGET      = 4;
declare int PG_SIGNAL_PD   = 5;
declare int PG_SIGNAL      = 6;
// Attributes of Current Target
declare float CURR_TARG_SIZE;
declare float CURR_TARG_ANGLE;
declare float CURR_TARG_ECCENTRICITY;
declare int   CURR_TARG_COLOR_IDX;

declare CMD_PGS(int currTargetIdx);


process CMD_PGS(int currTargetIdx)
{
  declare float pdEccentricity;
  declare float pdAngleR;
  declare float pdAngleL;
  declare float opposite;
  declare float adjacent;
  declare float stim_ecc_x;
  declare float stim_ecc_y;
  declare int   open    = 0;
  declare int   fill    = 1;

  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // Calculate screen coordinates for stimuli on this trial
  CURR_TARG_SIZE         = TARG_SIZE_ARRY[currTargetIdx];
  CURR_TARG_ANGLE        = TARG_ANGLE_ARRY[currTargetIdx];
  CURR_TARG_ECCENTRICITY = TARG_ECCENTRICITY_ARRY[currTargetIdx];
  // Zero is black.  see SET_CLRS.pro
  CURR_TARG_COLOR_IDX     = TARG_COLOR_IDX_ARRY[currTargetIdx];
  // find the center of the box in x and y space based on the CURR_TARG_ANGLE and CURR_TARG_ECCENTRICITY...
  stim_ecc_x = cos(CURR_TARG_ANGLE) * CURR_TARG_ECCENTRICITY;                                                                                       
  stim_ecc_y = sin(CURR_TARG_ANGLE) * CURR_TARG_ECCENTRICITY * -1;
  // Update animated graph object and resize PG_FIXATION object
  //oMove(object_targ, stim_ecc_x * DEG_2_PIX_X, stim_ecc_y * DEG_2_PIX_Y);                                                           
  //oSetAttribute(object_targ, aSIZE, CURR_TARG_SIZE * DEG_2_PIX_X, CURR_TARG_SIZE * DEG_2_PIX_Y);                                                        
  //oSetAttribute(object_fix, aSIZE, 1 * DEG_2_PIX_X, 1 * DEG_2_PIX_Y);

  // For PD
  adjacent       = rad2deg(atan((SCRN_MM_X / 2) / SUBJ_DIST_MM));
  opposite       = rad2deg(atan((SCRN_MM_Y / 2) / SUBJ_DIST_MM));
  pdEccentricity = sqrt((opposite * opposite) + (adjacent * adjacent)) - 0.5;
  pdAngleL       = rad2deg(atan(opposite / adjacent)) + 180;
  pdAngleR       = -rad2deg(atan(opposite / adjacent));

  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 1 FIXATION_PD - PD is drawn on LEFT-TOP of screen only
  //printf("CMD_PGS: page %d FIX_SIZE %2.2d, PD_WIDTH_DEG %3.4d, pdAngleL %3.2d\n",PG_FIXATION_PD,FIX_SIZE_DEG,PD_WIDTH_DEG,pdAngleL);
  dsendf("rw %d,%d;\n", PG_FIXATION_PD, PG_FIXATION_PD);
  dsendf("cl:\n");
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         fill);
  spawnwait DRW_RECT(PD_WIDTH_DEG,
                         PD_WIDTH_DEG / 4,
                         pdAngleL,
                         pdEccentricity,
                         CLR_IDX_PTOTODIODE,
                         fill);

  //printf("-----------------\n");
  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 2 FIXATION - No PD
  //printf("CMD_PGS: page %d FIX_SIZE %2.2d, PD_WIDTH_DEG %3.4d\n",PG_FIXATION,FIX_SIZE_DEG);
  dsendf("rw %d,%d;\n", PG_FIXATION, PG_FIXATION);
  dsendf("cl:\n");
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         fill);
  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 3 TARGET with PD - PD is drawn on LEFT-TOP of screen only
  //printf("CMD_PGS: page %d targetSize %2.2d, PD_WIDTH_DEG %3.4d, pdAngleL %3.2d\n",PG_TARGET_PD,CURR_TARG_SIZE,PD_WIDTH_DEG,pdAngleL);
  dsendf("rw %d,%d;\n", PG_TARGET_PD, PG_TARGET_PD);
  dsendf("cl:\n");
  // draw PG_TARGET
  spawnwait DRW_RECT(CURR_TARG_SIZE,
                         CURR_TARG_SIZE,
                         CURR_TARG_ANGLE,
                         CURR_TARG_ECCENTRICITY,
                         CURR_TARG_COLOR_IDX,
                         fill);
    // draw open PG_FIXATION point
    spawnwait DRW_RECT(FIX_SIZE_DEG,
                           FIX_SIZE_DEG,
                           0.0,
                           0.0,
                           CLR_IDX_FIX,
                           open);
  // Draw left PD marker
  spawnwait DRW_RECT(PD_WIDTH_DEG,
                         PD_WIDTH_DEG / 4,
                         pdAngleL,
                         pdEccentricity,
                         CLR_IDX_PTOTODIODE,
                         fill);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 4 TARGET no PD
  //printf("CMD_PGS: page %d targetSize %2.2d\n",PG_TARGET,CURR_TARG_SIZE);
  dsendf("rw %d,%d;\n", PG_TARGET, PG_TARGET);
  dsendf("cl:\n");
  spawnwait DRW_RECT(CURR_TARG_SIZE,
                         CURR_TARG_SIZE,
                         CURR_TARG_ANGLE,
                         CURR_TARG_ECCENTRICITY,
                         CURR_TARG_COLOR_IDX,
                         fill);
  // draw open PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         open);
  nexttick;

  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 5 SIGNAL PD - PD is drawn on the right only
  //printf("CMD_PGS: page %d targetSize %2.2d, PD_WIDTH_DEG %3.4d, pdAngleR %3.2d\n",PG_SIGNAL_PD,CURR_TARG_SIZE,PD_WIDTH_DEG,pdAngleR);
  dsendf("rw %d,%d;\n", PG_SIGNAL_PD, PG_SIGNAL_PD);
  dsendf("cl:\n");
  spawnwait DRW_RECT(CURR_TARG_SIZE,
                         CURR_TARG_SIZE,
                         CURR_TARG_ANGLE,
                         CURR_TARG_ECCENTRICITY,
                         CURR_TARG_COLOR_IDX,
                         fill);
  // draw PG_TARGET
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_STOP_SIGNAL,
                         fill);
  // draw PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         open);
  // Draw right PD marker
  spawnwait DRW_RECT(PD_WIDTH_DEG,
                         PD_WIDTH_DEG / 4,
                         pdAngleR,
                         pdEccentricity,
                         CLR_IDX_PTOTODIODE,
                         fill);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 6 SIGNAL no PD
  //printf("CMD_PGS: page %d targetSize %2.2d\n",PG_SIGNAL,CURR_TARG_SIZE);
  dsendf("rw %d,%d;\n", PG_SIGNAL, PG_SIGNAL);
  dsendf("cl:\n");
  spawnwait DRW_RECT(CURR_TARG_SIZE,
                         CURR_TARG_SIZE,
                         CURR_TARG_ANGLE,
                         CURR_TARG_ECCENTRICITY,
                         CURR_TARG_COLOR_IDX,
                         fill);
  // draw PG_TARGET
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_STOP_SIGNAL,
                         fill);

  // draw PG_FIXATION point
  spawnwait DRW_RECT(FIX_SIZE_DEG,
                         FIX_SIZE_DEG,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         open);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 0 BLANK (draw last so it is displayed as default))
  //printf("CMD_PGS: page %d PG_BLANK\n", PG_BLANK);
  // draw the PG_BLANK screen last so that it shows up first
  dsendf("rw %d,%d;\n", PG_BLANK, PG_BLANK);
  dsendf("cl:\n");
  nexttick;
} /* CMD_PGS */
