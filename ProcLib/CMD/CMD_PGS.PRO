//==========================================================================
// CMD_PGS.PRO
//   Description: Function to setup all PAGES for CMD task
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2018-12-07
//==========================================================================
//  Revision History:
//  001: 2018/12/10 chenchal subraveti
//       Global colorIdx indices and palettes for colorIdxs
//

// Room variables
#include C:/TEMPO/ProcLib/DRW_RECT.PRO

// Virtual Page indices
declare int blank       = 0;
declare int fixation_pd = 1;
declare int fixation    = 2;
declare int target_pd   = 3;
declare int target      = 4;
declare int signal_pd   = 5;
declare int signal      = 6;
// Attributes of Current Target
declare float size;
declare float angle;
declare float eccentricity;
declare int   colorIdx;

declare CMD_PGS(int   curr_target,
                int   object_targ);


process CMD_PGS(int   curr_target,
                int   object_targ)
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
  size         = Size_list[curr_target];
  angle        = Angle_list[curr_target];
  eccentricity = Eccentricity_list[curr_target];
  // Zero is black.  see SET_CLRS.pro
  colorIdx     = curr_target + 1;

  stim_ecc_x = cos(angle) * eccentricity;                                                                                       // find the center of the box in x and y space based on the angle and eccentricity...
  stim_ecc_y = sin(angle) * eccentricity * -1;
  oMove(object_targ, stim_ecc_x * DEG_2_PIX_X, stim_ecc_y * DEG_2_PIX_Y);                                                           // ...and move the animated graph object there.
  oSetAttribute(object_targ, aSIZE, size * DEG_2_PIX_X, size * DEG_2_PIX_Y);                                                        // while we are at it, resize fixation object on animated graph
  oSetAttribute(object_fix, aSIZE, 1 * DEG_2_PIX_X, 1 * DEG_2_PIX_Y);

  // For PD
  adjacent       = rad2deg(atan((Scr_width / 2) / Subj_dist));
  opposite       = rad2deg(atan((Scr_height / 2) / Subj_dist));
  pdEccentricity = sqrt((opposite * opposite) + (adjacent * adjacent)) - 0.5;
  pdAngleL       = rad2deg(atan(opposite / adjacent)) + 180;
  pdAngleR       = -rad2deg(atan(opposite / adjacent));

  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 1 FIXATION_PD - PD is drawn on LEFT-TOP of screen only
  //printf("CMD_PGS: page %d FIX_SIZE %2.2d, pdSize %3.4d, pdAngleL %3.2d\n",fixation_pd,fixation_size,pdSize,pdAngleL);
  dsendf("rw %d,%d;\n", fixation_pd, fixation_pd);
  dsendf("cl:\n");
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         fill);
  spawnwait DRW_RECT_NEW(pdSize,
                         pdSize / 4,
                         pdAngleL,
                         pdEccentricity,
                         CLR_IDX_PTOTODIODE,
                         fill);

  printf("-----------------\n");
  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 2 FIXATION - No PD
  //printf("CMD_PGS: page %d FIX_SIZE %2.2d, pdSize %3.4d\n",fixation,fixation_size);
  dsendf("rw %d,%d;\n", fixation, fixation);
  dsendf("cl:\n");
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         fill);
  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 3 TARGET with PD - PD is drawn on LEFT-TOP of screen only
  //printf("CMD_PGS: page %d targetSize %2.2d, pdSize %3.4d, pdAngleL %3.2d\n",target_pd,size,pdSize,pdAngleL);
  dsendf("rw %d,%d;\n", target_pd, target_pd);
  dsendf("cl:\n");
  // draw target
  spawnwait DRW_RECT_NEW(size,
                         size,
                         angle,
                         eccentricity,
                         colorIdx,
                         fill);
    // draw open fixation point
    spawnwait DRW_RECT_NEW(fixation_size,
                           fixation_size,
                           0.0,
                           0.0,
                           CLR_IDX_FIX,
                           open);
  // Draw left PD marker
  spawnwait DRW_RECT_NEW(pdSize,
                         pdSize / 4,
                         pdAngleL,
                         pdEccentricity,
                         CLR_IDX_PTOTODIODE,
                         fill);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 4 TARGET no PD
  //printf("CMD_PGS: page %d targetSize %2.2d\n",target,size);
  dsendf("rw %d,%d;\n", target, target);
  dsendf("cl:\n");
  spawnwait DRW_RECT_NEW(size,
                         size,
                         angle,
                         eccentricity,
                         colorIdx,
                         fill);
  // draw open fixation point
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         open);
  nexttick;

  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 5 SIGNAL PD - PD is drawn on the right only
  //printf("CMD_PGS: page %d targetSize %2.2d, pdSize %3.4d, pdAngleR %3.2d\n",signal_pd,size,pdSize,pdAngleR);
  dsendf("rw %d,%d;\n", signal_pd, signal_pd);
  dsendf("cl:\n");
  spawnwait DRW_RECT_NEW(size,
                         size,
                         angle,
                         eccentricity,
                         colorIdx,
                         fill);
  // draw target
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         sig_color,
                         fill);
  // draw fixation point
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         open);
  // Draw right PD marker
  spawnwait DRW_RECT_NEW(pdSize,
                         pdSize / 4,
                         pdAngleR,
                         pdEccentricity,
                         CLR_IDX_PTOTODIODE,
                         fill);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 6 SIGNAL no PD
  //printf("CMD_PGS: page %d targetSize %2.2d\n",signal,size);
  dsendf("rw %d,%d;\n", signal, signal);
  dsendf("cl:\n");
  spawnwait DRW_RECT_NEW(size,
                         size,
                         angle,
                         eccentricity,
                         colorIdx,
                         fill);
  // draw target
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         sig_color,
                         fill);

  // draw fixation point
  spawnwait DRW_RECT_NEW(fixation_size,
                         fixation_size,
                         0.0,
                         0.0,
                         CLR_IDX_FIX,
                         open);

  nexttick;
  //--------------------------------------------------------------------------------------------------------------------
  // Draw pg 0 BLANK (draw last so it is displayed as default))
  //printf("CMD_PGS: page %d blank\n", blank);
  // draw the blank screen last so that it shows up first
  dsendf("rw %d,%d;\n", blank, blank);
  dsendf("cl:\n");
  nexttick;
} /* CMD_PGS */
