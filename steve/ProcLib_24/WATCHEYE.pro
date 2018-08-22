//----------------------------------------------------------------------
// WATCHEYE - This process monitors eye position.  It runs every process 
// cycle so it is important to minimize the computations done here.  
// WATCHEYE does the following:
//  1. updates ax, ay as the current analog values for X,Y position
//  2. maps ax,ay to x,y into degrees
//  3. calls LOCATE_I to monitor eyes in relation to target windows
//  4. moves the EYE object to the new x,y position
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

											
#include C:\TEMPO\ProcLib\LOCATE_I.pro

declare Eye_on_VDOSync = 0;
declare CenterEyeNow = 0;

declare WATCHEYE(int eye_X_channel, 
	int eye_Y_channel, 
	float analogUnits, 
	float maxvoltage,	
	float deg2pix_X,
	float deg2pix_Y);

process WATCHEYE(int eye_X_channel, 
	int eye_Y_channel, 
	float analogUnits, 
	float maxvoltage,
	float deg2pix_X,
	float deg2pix_Y)
    {
	
	declare hide float eye_x, eye_y, oldx, oldy;
	declare hide int lasttime, plot_x, plot_y;

	
    while (1)  														// From this moment until the end of eternity. (Did you know what you were starting?)                        
        {      
		
        eye_x = atable(eye_x_channel);             					// Get analog values
        eye_y = atable(eye_y_channel);
		
				
		eye_x = (eye_x * ((MaxVoltage*2) / AnalogUnits) * X_Gain) - X_Offset;	// Translate to degrees (x_ and y_gain values are set during calibration routine)
		eye_y = (eye_y * ((MaxVoltage*2)  / AnalogUnits) * Y_Gain) - Y_Offset;	
        
		if(CenterEyeNow)											// GLOBAL flag set by key press to center eye position
			{
			X_Offset = X_Offset + eye_x;
			Y_Offset = Y_Offset + eye_y;
			CenterEyeNow = 0;
			}
		
		plot_x = eye_x * deg2pix_X;
		plot_y = eye_Y * deg2pix_Y;
        if (plot_x != oldx || plot_y != oldy)     					// If position has changed..
            {
			
						
			spawn LOCATE_I(eye_x,									//...figure out where the eyes are in relation to stim...
						eye_y,
						fix_win_left,
						fix_win_right,
						fix_win_down, 
						fix_win_up,
						targ_win_left, 
						targ_win_right,
						targ_win_down, 
						targ_win_up);
							
		
			
			if(time() > lasttime + 16)								//...and if more than a single refresh has gone by...
				{
				
				oMove(object_eye, plot_x, plot_y);            		// ..update eye object...
				if (Eye_on_VDOSync)
					{
					dsendf("cl;\n");
					dsendf("ru %d,%d,%d,%d;\n",plot_x-4,(-1*plot_y)-4,plot_x+3,(-1*plot_y)+3); // .. and move vdosync location (could be good for debugging).
					dsendf("co %d;\n",5);
					}
				lasttime = time();
				oldx = plot_x;                   					// This is the new position.
				oldy = plot_y;
				}					
			}
            
        nexttick;
		
        }
    }