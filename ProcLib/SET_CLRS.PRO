//==========================================================================
// SET_CLRS.PRO
//   Description: Function to setup all colors/palettes for CMD task
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2018-12-07
//==========================================================================
//  Revision History:
//  001: 2018/09/09 chenchal subraveti
//       Global color indices and palettes for colors
//
//
declare SET_CLR_PALETTE();

declare SET_CLR(int colorIndex,
                int color_r,
                int color_g,
                int color_b);

// Global color Variables
// Default palettes
declare int constant PAL_DEFAULT = 0;
// There are 255 color indices in a palatte
// 0 is reserved for BLACK
// Use indices 1 to N for Target colorIndex etc
// Fill Indices from 255 backwards for other colors
int CLR_IDX_FIX         = 255;
int CLR_IDX_STOP_SIGNAL = 254;
int CLR_IDX_IGNORE      = 253;
int CLR_IDX_PTOTODIODE  = 247;


process SET_CLR_PALETTE()
{
  declare int r_, g_, b_;
  declare     stimColorIdx;
  declare     nTargets;
  declare int fixation_color[3];
  declare int stop_sig_color[3];
  declare int ignore_sig_color[3];

  r_ = 0;
  g_ = 1;
  b_ = 2;

  printf("CMD_CLRS: Setting indexed colors for default palette\n");

  // Default to gray

  dsendf("cm %d %d %d %d;\n", CLR_IDX_FIX, fixation_color[r_], fixation_color[g_], fixation_color[b_]);


  dsendf("cm %d %d %d %d;\n", CLR_IDX_STOP_SIGNAL, stop_sig_color[r_], stop_sig_color[g_], stop_sig_color[b_]);

  dsendf("cm %d %d %d %d;\n", CLR_IDX_STOP_SIGNAL, ignore_sig_color[r_], ignore_sig_color[g_], ignore_sig_color[b_]);

  dsendf("cm %d %d %d %d;\n", CLR_IDX_PTOTODIODE, 255, 255, 255);


  // All target position colors are same see original DEFAULT.PRO
  stimColorIdx = 1;
  nTargets     = 8;
  while (stimColorIdx <= nTargets)
  {
    //35, 33, 27
    dsendf("cm %d %d %d %d;\n", stimColorIdx, Color_list[r_], Color_list[g_], Color_list[b_]);
    stimColorIdx = stimColorIdx + 1;
    nexttick;
  }
}


process SET_CLR(int colorIndex, int color_r, int color_g, int color_b)
{
  // Set current hardware palette color index to defined user choice
  dsendf("cm %d %d %d %d;\n", colorIndex, color_r, color_g, color_b);
}
