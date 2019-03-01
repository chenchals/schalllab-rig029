//------------------------------------------------------------------------
// process JUICE(int channel, int duration)
// Deliver a juice reward to the animal
// INPUT
//	 channel  = rig specific TTL channel connected to solenoid (channel 9 in 028)
//	 duration = amount of time (in ms) to leave solenoid open
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare JUICE(int channel, int duration);

process JUICE(int channel, int duration)
	{
	declare hide int open   = 1;	
	declare hide int closed = 0;	
	
	Event_fifo[Set_event] = JuiceStart_;
	Set_event = (Set_event + 1) % Event_fifo_N;
	
	mio_dig_set(channel,open);		// Start sending the TTL
	wait(duration);					// Wait for user defined period of time (ms)
	mio_dig_set(channel,closed);	// Stop sending the TTL
	
	Event_fifo[Set_event] = JuiceEnd_;
	Set_event = (Set_event + 1) % Event_fifo_N;
	}