//
// written by david.c.godlove@vanderbilt.edu  January, 2011

// Rig room number
declare constant int Room = 29;

// Screen measurements (units: mm)
declare constant float Scr_width  = 375.0;
declare constant float Scr_height = 275.0;
// Screen resolution (units: pixels)
declare constant int   Scr_pixX     = 640;
declare constant int   Scr_pixY     = 400;
// Screen refresh rate selected
declare constant float Refresh_rate = 60;

// distance from center of subjects eyeball to screen
declare float Subj_dist = 570.0;

// where does your photodiode marker need to be?
declare constant float PD_left   = 6;               // distance from left of screen (same units as above)
declare constant float PD_bottom = 7;               // distance from bottom of screen (same units as above)
declare constant float PD_size   = 25;              // minimum size for consistant triggering (same units as above)


// what are your eye variables?
// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
declare float X_Gain = 5.1;  //9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare float Y_Gain = 5.1;  //11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare float X_Offset;      // for zeroing x trace
declare float Y_Offset;      // for zeroing y trace

// what kind of hardware configuration are you using?
declare constant int   Juice_channel  = 9;       //9 in 029 0 in 023
declare constant int   Stim_channel   = 1;
declare constant int   Eye_X_channel  = 1;
declare constant int   Eye_Y_channel  = 2;
declare constant int   PD_L_channel = 4;
declare constant int   PD_R_channel = 3;
declare constant float MaxVoltage     = 10;  //look at das_gain and das_polarity in kped (setup tn)
//declare constant  float AnalogUnits     = 65536;// use this for a 64 bit AD board
declare constant float AnalogUnits = 4096;   // use this for a 12 bit AD board

// what kind of motion detector hardware are you using?
declare constant CheckMouth = 1;                                    // use this if you have a motion detector on the MOUTH going into channel 3
declare constant CheckBody  = 0;                                    // use this if you have a motion detector on the BODY going into channel 3
