//==========================================================================
// VAR_STIM.PRO
//   Description: Global declares for Stimulus variables
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//

declare float Fixation_size;
declare int   Fixation_color[3];
// Stimulus - target attributes
declare int   N_targ_pos;
declare int   Color_list[12, 3];
declare float Size_list[12];
declare float Angle_list[12];
declare float Eccentricity_list[12];
// Stop / ignore trial Cue
declare int   Stop_sig_color[3];
declare int   Ignore_sig_color[3];
// Photocell marker size
declare float pdSize = 4;
