
// code for use with PELCO MD2001 Motion Detector
// when inactive (still)+10v. when active (moving) motion is detected and ~0v 
// the unit will automatically reset to inactive after motion ceases.
// the dip switches on the rear of the unit define the reset interval.
// currently set to 1/2 sec (shortest interval availible). so motions 
// less than 1/2 second apart will not be detected as separate events.
// 
// written by david.c.godlove@vanderbilt.edu 	March, 2011
// borrowed heavily from code by EEE

// declare CheckMouth = 1;									// GLOBAL ALERT! Check mouth can be set to 0 to end this function
															// MOVED TO RIGSETUP.pro so can be toggled in different rigs.
															
declare CheckMotion = 1;									// For turning on and off while task is running or not

declare WATCHMTH();
	
process WATCHMTH()                                  		                                                                                                    
	{ 		
			
	declare mouth_channel	= 3;							// these should be set by rig setup but...
	declare mouth_thresh	= 13720;						// ...what's the point since they quit making this motion detector.
	declare still			= 0;		
	declare moving			= 1;	
	declare mouth_status	= still;		
	declare last_status		= still;
	declare mouth;
	declare mouth_time;	
			
			
	if (atable(mouth_channel) < mouth_thresh)				// check to see if mouth is already moving when WATCHMTH() is first called
		{		
		mouth_status	= moving;							// initial status is moving
		last_status		= moving;		
		}		
		
		while (CheckMouth & CheckMotion)		
			{
			mouth = atable(mouth_channel);
			if (mouth < mouth_thresh)							// what is the current status of the mouth?
				{
				mouth_status = moving;
				if (TrainingStill)								// if we are using the motion detector to train the monk to be still instead
						{
						if (time() > mouth_time + 200)
							{
							spawn TONESWEP();					// present negative tone which can be distingueshed from task tones
							if (Move_ct < Max_move_ct)
								{
								Move_ct = Move_ct + 1;			// and increase the timeout counter
								mouth_time = time();
								}						
							}					
						}
				}
			else if (mouth >= mouth_thresh)
				{
				mouth_status = still;
				}
			
			if (mouth_status != last_status)					// did a change in the status occur on this interation?
				{
				if (mouth_status == moving)
					{
					Event_fifo[Set_event] = MouthBegin_;		// queue EVT_TRIAL_START_ strobe
					Set_event = (Set_event + 1) % Event_fifo_N;	// incriment event queue
					}
				else if (mouth_status == still)
					{
					Event_fifo[Set_event] = MouthEnd_;			// queue EVT_TRIAL_START_ strobe
					Set_event = (Set_event + 1) % Event_fifo_N;	// incriment event queue
					}
				last_status = mouth_status;
				}
			nexttick;
			}
		}
