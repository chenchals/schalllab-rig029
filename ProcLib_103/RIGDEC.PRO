//==========================================================================
// RIGDEC.PRO
//   Description: Declare all Rig specific variables
//   Author: david.c.godlove@vanderbilt.edu
//   Date: 2011-01
//==========================================================================
//  Revision History:
//  001: 2019/01/09 chenchal subraveti
//       Reorganized and added vars for PD triggers
//
//

// viewing measurements used to compute degrees (units need to be the same)
declare float Scr_width;  // in mm
declare float Scr_height; // in mm
declare float Subj_dist;  // in mm distance from center of subject's eyeball to screen

// what is your screen resolution?
declare int   Scr_pixX;         // number of pixels across
declare int   Scr_pixY;         // number of pixels in height
declare float Refresh_rate;     // in Hz

// Screen degrees to pixel conversion factor
//OUTPUT: these conversion factors will be used throughout protocol when drawing
// (this is necessary b/c unless you are really careful with virtual coordinates
// you wil end up with stimuli which are slightly off, and what is the point of
// using virtual coordinates if you have to be super careful about it?) -- see SET_COOR.PRO
declare float Deg2Pix_X;
declare float Deg2Pix_Y;
declare float Unit2Pix_X;
declare float Unit2Pix_Y;

// what are your eye variables?
// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
declare float X_Gain;   //9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare float Y_Gain;   //11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare float X_Offset; // for zeroing x trace
declare float Y_Offset; // for zeroing y trace

// what kind of hardware configuration are you using?
declare int   Juice_channel; //9 in 029 0 in 023
declare int   Stim_channel;
declare int   Eye_X_channel;
declare int   Eye_Y_channel;
declare int   PD_Left_channel;
declare int   PD_Right_channel;
declare float MaxVoltage;  //look at das_gain and das_polarity in kped (setup tn)
//declare  float AnalogUnits    = 65536;// use this for a 64 bit AD board
declare float AnalogUnits;

declare int     pdThresh;
declare float	pd_left; //unused in CMD 									// see RIGSETUP.pro
declare float	pd_bottom; //unused in CMD 									// see RIGSETUP.pro
declare float	pd_size; //unused in CMD									// see RIGSETUP.pro

// what kind of motion detector hardware are you using?
declare int CheckMouth;            // use this if you have a motion detector on the MOUTH going into channel 3
declare int CheckBody;             // use this if you have a motion detector on the BODY going into channel 3
