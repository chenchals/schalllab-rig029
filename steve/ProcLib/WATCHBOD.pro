// For use with a simple circuit which detects when the animal shifts
// weight in the chair.
// 
// written by david.c.godlove@vanderbilt.edu 	March, 2011
// adapted from WATCHMTH.pro

//declare CheckBody	= 1;									// GLOBAL ALERT! Check body can be set to 0 to end this function
															// MOVED TO RIGSETUP.pro so that it can be toggled by rig
															
declare CheckMotion = 1;									// For turning on and off while task is running or not															
										

declare WATCHBOD();
	
process WATCHBOD()                                  		                                                                                                    
	{ 		
			
	declare body_channel	= 2;							// these should be set by rig setup but...
	declare sample_n        = 0;
	declare a_sets = 2;
			
 	while (CheckBody & CheckMotion)		
		{
		sample_n = 0;
		while (sample_n < a_sets)
			{
			
			if (ctable_set(body_channel,sample_n,0))

				{
				if (Move_ct < Max_move_ct)
					{
					Move_ct = Move_ct + 1;
					}
				spawn TONE(failure_tone,tone_duration);		// present negative tone
				}


			sample_n = sample_n + 1;
			}
		nexttick;
		}
	}