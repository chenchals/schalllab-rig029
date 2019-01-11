//------------------------------------------------------------------------
// process KEY_STIM()
// Give microstim when the button is pressed.  Had to be written
// b/c can't spawn processes with input at command prompt (stupid). 
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare KEY_STIM();

process KEY_STIM()
	{
	
	spawn STIM(stim_channel);
	
	}