//------------------------------------------------------------------------
// process STIM(int channel, int duration)
// send a TTL pulse to the stimulator and send a strobe to plexon.
// INPUT
//	 channel  = rig specific TTL channel connected stimulator
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare STIM(int channel, int Npulse, int PulseGap);

process STIM(int channel, int Npulse, int PulseGap)
	{
	declare hide int on   = 1;	
	declare hide int off  = 0;	
	declare hide int pcnt = 0;	

	while(pcnt < Npulse)
		{
		mio_dig_set(channel,on);		// Start sending the TTL
		wait(2);						// Wait one ms
		mio_dig_set(channel,off);		// Stop sending the TTL
		wait(PulseGap-2)
		pcnt = pcnt+1;
		
		Event_fifo[Set_event] = Stimulation_;		// queue strobe, and ...
		Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		}
	}