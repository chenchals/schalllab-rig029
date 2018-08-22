//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

// what room is this set up for?
//declare hide int 	Room = 0;

// viewing measurements used to compute degrees (units need to be the same)
declare hide float Scr_width; // in some units
declare hide float Scr_height; // in some units
declare 		 hide float Subj_dist; // distance from center of subjects eyeball to screen

// where does your photodiode marker need to be?
declare hide float PD_left;	// distance from left of screen (same units as above)
declare hide float PD_bottom;	// distance from bottom of screen (same units as above)
declare hide float PD_size;	// minimum size for consistant triggering (same units as above)

// what is your screen resolution?
declare hide int   Scr_pixX;	// number of pixels across
declare hide int   Scr_pixY;	// number of pixels in height
declare hide float	Refresh_rate;	// in Hz

// what are your eye variables?
// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
declare float	X_Gain;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare float	Y_Gain;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
declare float	X_Offset; 							// for zeroing x trace
declare float	Y_Offset;							// for zeroing y trace

// what kind of hardware configuration are you using?
declare hide int Juice_channel; //9 in 029 0 in 023
declare hide int Stim_channel;
declare hide int Eye_X_channel;
declare hide int Eye_Y_channel;
declare hide int PhotoD_channel;
declare hide float MaxVoltage; 	//look at das_gain and das_polarity in kped (setup tn)
//declare hide float AnalogUnits   	= 65536;// use this for a 64 bit AD board
declare hide float AnalogUnits;// use this for a 12 bit AD board

// what kind of motion detector hardware are you using?
declare hide int CheckMouth;            // use this if you have a motion detector on the MOUTH going into channel 3
declare hide int CheckBody;            // use this if you have a motion detector on the BODY going into channel 3