//==========================================================================
// RIGSETUP.PRO
//   Description: Define rig specific variables by room number
//   Author: david.c.godlove@vanderbilt.edu
//   Date: 2011-01
//==========================================================================
//  Revision History:
//  001: 2019/01/09 chenchal subraveti
//       Reorganized and added vars only for room 029. Other roooms are removed
//

declare RIGSETUP(int Room);

process RIGSETUP(int Room)
{
  if (Room == 29)
  {
    // Screen measurements in mm
    Scr_width  = 375.0;
    Scr_height = 275.0;
    Subj_dist  = 570.0;

    // Screen measurements in pixels
    Scr_pixX     = 640;
    Scr_pixY     = 400;
    Refresh_rate = 60;

    // Eye variables and calibration
    // In 023: calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
    X_Gain = 3.622;            //5.1;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
    Y_Gain = 3.837;            //5.1;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)

    // Configuration for DAS board on TEMPO
    Juice_channel = 9;  //9 in 029 0 in 023
    Stim_channel  = 1;  // Output
    Eye_X_channel = 1;  // Input
    Eye_Y_channel = 2;  // input
    PD_Right_channel  = 3;
    PD_Left_channel  = 4;
    MaxVoltage    = 10;                 //look at das_gain and das_polarity in kped (setup tn)
    AnalogUnits   = 65536;              // use this for a 16 bit AD board (2^nbits)
	
    // what kind of motion detector hardware are you using?
    CheckMouth = 1;                                             // use this if you have a motion detector on the MOUTH going into channel 3
    CheckBody  = 0;                                             // use this if you have a motion detector on the BODY going into channel 3

    redVal   = 30;
    greenVal = 19;
    blueVal  = 64;
    yrOff    = 13;
    ygOff    = 6;
    mrOff    = 9;
    mbOff    = 27;
    cgOff    = 1;
    cbOff    = 44;
    wrOff    = 13;
    wgOff    = 6;
    wbOff    = 50;
  }
} /* RIGSETUP */
