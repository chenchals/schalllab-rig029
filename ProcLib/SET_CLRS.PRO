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
declare int CLR_IDX_FIX         = 255;
declare int CLR_IDX_STOP_SIGNAL = 254;
declare int CLR_IDX_IGNORE      = 253;
declare int CLR_IDX_PTOTODIODE  = 247;

declare int r_ = 0;
declare int g_ = 1;
declare int b_ = 2;

process SET_CLR_PALETTE()
{
  declare int stimColorIdx;

  printf("CMD_CLRS: Setting indexed colors for default palette\n");
  // Default to gray
  dsendf("cm %d %d %d %d;\n", CLR_IDX_FIX, Fixation_color[r_], Fixation_color[g_], Fixation_color[b_]);
  dsendf("cm %d %d %d %d;\n", CLR_IDX_STOP_SIGNAL, Stop_sig_color[r_], Stop_sig_color[g_], Stop_sig_color[b_]);
  dsendf("cm %d %d %d %d;\n", CLR_IDX_STOP_SIGNAL, Ignore_sig_color[r_], Ignore_sig_color[g_], Ignore_sig_color[b_]);
  dsendf("cm %d %d %d %d;\n", CLR_IDX_PTOTODIODE, 255, 255, 255);
  // All target position colors are same see original DEFAULT.PRO
  stimColorIdx = 1;
  while (stimColorIdx <= N_targ_pos)
  {
    //35, 33, 27
    dsendf("cm %d %d %d %d;\n", stimColorIdx, Color_list[stimColorIdx-1,r_], Color_list[stimColorIdx-1,g_], Color_list[stimColorIdx-1,b_]);
    stimColorIdx = stimColorIdx + 1;
    nexttick;
  }
}


process SET_CLR(int colorIndex, int color_r, int color_g, int color_b)
{
  // Set current hardware palette color index to defined user choice
  dsendf("cm %d %d %d %d;\n", colorIndex, color_r, color_g, color_b);
}
