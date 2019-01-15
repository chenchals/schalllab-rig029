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

process SET_CLR_PALETTE()
{
  declare int stimColorIdx;

  printf("CMD_CLRS: Setting indexed colors for default palette\n");
  // Default to gray
  dsendf("cm %d %d %d %d;\n", CLR_IDX_FIX, FIX_COLOR[RGB_R_IDX], FIX_COLOR[RGB_G_IDX], FIX_COLOR[RGB_B_IDX]);
  dsendf("cm %d %d %d %d;\n", CLR_IDX_STOP_SIGNAL, STOP_SIGNAL_COLOR[RGB_R_IDX], STOP_SIGNAL_COLOR[RGB_G_IDX], STOP_SIGNAL_COLOR[RGB_B_IDX]);
  dsendf("cm %d %d %d %d;\n", CLR_IDX_STOP_SIGNAL, IGNORE_SIGNAL_COLOR[RGB_R_IDX], IGNORE_SIGNAL_COLOR[RGB_G_IDX], IGNORE_SIGNAL_COLOR[RGB_B_IDX]);
  dsendf("cm %d %d %d %d;\n", CLR_IDX_PTOTODIODE, 255, 255, 255);
  // All target position colors are same see original DEFAULT.PRO
  stimColorIdx = 1;
  while (stimColorIdx <= N_TARG_POS)
  {
    //35, 33, 27
	TARG_COLOR_IDX_ARRY[stimColorIdx-1] = stimColorIdx;
    dsendf("cm %d %d %d %d;\n", stimColorIdx, TARG_COLOR_ARRY[stimColorIdx-1,RGB_R_IDX],TARG_COLOR_ARRY[stimColorIdx-1,RGB_G_IDX], TARG_COLOR_ARRY[stimColorIdx-1,RGB_B_IDX]);
    stimColorIdx = stimColorIdx + 1;
    nexttick;
  }
}

process SET_CLR(int colorIndex, int color_r, int color_g, int color_b)
{
  // Set current hardware palette color index to defined user choice
  dsendf("cm %d %d %d %d;\n", colorIndex, color_r, color_g, color_b);
}
