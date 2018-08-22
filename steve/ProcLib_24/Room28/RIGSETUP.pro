//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
// edited by kaleb.a.lowe@vanderbilt.edu to make variables, similar to DEFAULT.pro

declare RIGSETUP(int Room)

// what room is this set up for?
//declare constant hide int 	Room			= 28;

if (Room == 23)
{
	// viewing measurements used to compute degrees (units need to be the same)
	declare constant hide float Scr_width   	= 381.0; // in some units
	declare constant hide float Scr_height  	= 291.0; // in some units
	declare 		 hide float Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen

	// where does your photodiode marker need to be?
	declare constant hide float PD_left			= 6;	// distance from left of screen (same units as above)
	declare constant hide float PD_bottom		= 7;	// distance from bottom of screen (same units as above)
	declare constant hide float PD_size			= 25;	// minimum size for consistant triggering (same units as above)

	// what is your screen resolution?
	declare constant hide int   Scr_pixX    	= 640;	// number of pixels across
	declare constant hide int   Scr_pixY    	= 400;	// number of pixels in height
	declare constant hide float	Refresh_rate	= 100;	// in Hz

	// what are your eye variables?
	// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
	declare float	X_Gain = 5.1;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	Y_Gain = 5.1;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	X_Offset; 							// for zeroing x trace
	declare float	Y_Offset;							// for zeroing y trace

	// what kind of hardware configuration are you using?
	declare constant hide int Juice_channel   	= 9; //9 in 029 0 in 023
	declare constant hide int Stim_channel		= 1;
	declare constant hide int Eye_X_channel   	= 1;
	declare constant hide int Eye_Y_channel   	= 2;
	declare constant hide int PhotoD_channel  	= 5;
	declare constant hide float MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
	//declare constant hide float AnalogUnits   	= 65536;// use this for a 64 bit AD board
	declare constant hide float AnalogUnits   = 4096;// use this for a 12 bit AD board

	// what kind of motion detector hardware are you using?
	declare constant hide CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
	declare constant hide CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
}
else if (Room == 28)
{
	// viewing measurements used to compute degrees (units need to be the same)
	declare constant hide float Scr_width   	= 381.0; // in some units
	declare constant hide float Scr_height  	= 291.0; // in some units
	declare 		 hide float Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen

	// where does your photodiode marker need to be?
	declare constant hide float PD_left			= 6;	// distance from left of screen (same units as above)
	declare constant hide float PD_bottom		= 7;	// distance from bottom of screen (same units as above)
	declare constant hide float PD_size			= 25;	// minimum size for consistant triggering (same units as above)

	// what is your screen resolution?
	declare constant hide int   Scr_pixX    	= 640;	// number of pixels across
	declare constant hide int   Scr_pixY    	= 400;	// number of pixels in height
	declare constant hide float	Refresh_rate	= 70;	// in Hz

	// what are your eye variables?
	declare float	X_Gain = 3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	Y_Gain = 3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	X_Offset; 							// for zeroing x trace
	declare float	Y_Offset;							// for zeroing y trace

	// what kind of hardware configuration are you using?
	declare constant hide int Juice_channel   	= 9;
	declare constant hide int Stim_channel		= 13;
	declare constant hide int Eye_X_channel   	= 1;
	declare constant hide int Eye_Y_channel   	= 2;
	declare constant hide int PhotoD_channel  	= 5;
	declare constant hide float MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
	declare constant hide float AnalogUnits   	= 65536;// use this for a 64 bit AD board
	// declare constant hide float AnalogUnits   = 4096;// use this for a 12 bit AD board

	// what kind of motion detector hardware are you using?
	declare constant hide CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
	declare constant hide CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
} else if (Room == 29)
{
	// viewing measurements used to compute degrees (units need to be the same)
	declare constant hide float Scr_width   	= 381.0; // in some units
	declare constant hide float Scr_height  	= 291.0; // in some units
	declare 		 hide float Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen

	// where does your photodiode marker need to be?
	declare constant hide float PD_left			= 6;	// distance from left of screen (same units as above)
	declare constant hide float PD_bottom		= 7;	// distance from bottom of screen (same units as above)
	declare constant hide float PD_size			= 25;	// minimum size for consistant triggering (same units as above)

	// what is your screen resolution?
	declare constant hide int   Scr_pixX    	= 640;	// number of pixels across
	declare constant hide int   Scr_pixY    	= 400;	// number of pixels in height
	declare constant hide float	Refresh_rate	= 100;	// in Hz

	// what are your eye variables?
	// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
	declare float	X_Gain = 5.1;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	Y_Gain = 5.1;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	X_Offset; 							// for zeroing x trace
	declare float	Y_Offset;							// for zeroing y trace

	// what kind of hardware configuration are you using?
	declare constant hide int Juice_channel   	= 0; //9 in 029 0 in 023
	declare constant hide int Stim_channel		= 1;
	declare constant hide int Eye_X_channel   	= 1;
	declare constant hide int Eye_Y_channel   	= 2;
	declare constant hide int PhotoD_channel  	= 5;
	declare constant hide float MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
	//declare constant hide float AnalogUnits   	= 65536;// use this for a 64 bit AD board
	declare constant hide float AnalogUnits   = 4096;// use this for a 12 bit AD board

	// what kind of motion detector hardware are you using?
	declare constant hide CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
	declare constant hide CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
} else if (Room == 30)
{
	// viewing measurements used to compute degrees (units need to be the same)
	declare constant hide float Scr_width   	= 381.0; // in some units
	declare constant hide float Scr_height  	= 291.0; // in some units
	declare 		 hide float Subj_dist   	= 450.0; // distance from center of subjects eyeball to screen

	// where does your photodiode marker need to be?
	declare constant hide float PD_left			= 6;	// distance from left of screen (same units as above)
	declare constant hide float PD_bottom		= 7;	// distance from bottom of screen (same units as above)
	declare constant hide float PD_size			= 25;	// minimum size for consistant triggering (same units as above)

	// what is your screen resolution?
	declare constant hide int   Scr_pixX    	= 640;	// number of pixels across
	declare constant hide int   Scr_pixY    	= 400;	// number of pixels in height
	declare constant hide float	Refresh_rate	= 100;	// in Hz

	// what are your eye variables?
	// In 023, calibration target is 12.8cm horizontal, 12.8 cm vertical. Atan(12.8/58) = 9.74 deg, Atan(12.8/58) = 11.23 deg
	declare float	X_Gain = 5.1;//9.74; //50; //3.492;						// x scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	Y_Gain = 5.1;//11.23; //50; //3.729;						// y scaling factor to convert eye trace voltage to degrees (must be calculated from calibration)
	declare float	X_Offset; 							// for zeroing x trace
	declare float	Y_Offset;							// for zeroing y trace

	// what kind of hardware configuration are you using?
	declare constant hide int Juice_channel   	= 0; //9 in 029 0 in 023
	declare constant hide int Stim_channel		= 1;
	declare constant hide int Eye_X_channel   	= 1;
	declare constant hide int Eye_Y_channel   	= 2;
	declare constant hide int PhotoD_channel  	= 5;
	declare constant hide float MaxVoltage    	= 10; 	//look at das_gain and das_polarity in kped (setup tn)
	//declare constant hide float AnalogUnits   	= 65536;// use this for a 64 bit AD board
	declare constant hide float AnalogUnits   = 4096;// use this for a 12 bit AD board

	// what kind of motion detector hardware are you using?
	declare constant hide CheckMouth			= 1;            // use this if you have a motion detector on the MOUTH going into channel 3
	declare constant hide CheckBody 			= 0;            // use this if you have a motion detector on the BODY going into channel 3
}
