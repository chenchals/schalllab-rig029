//------------------------------------------------------------------------
// process Tone(int frequency, int duration)
// Play a tone for the specified frequency and duration
// INPUT
//	 frequency = frequency of tone (hz) to be played
//	 duration  = amount of time (in ms) to pay tone
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare TONE(int frequency, int duration);

process TONE(int frequency, int duration)
	{
	declare hide count;			// Count down for the pulse generator to change state (see below)
	declare hide int off = 0;	// To turn tone off at end
	
	/*  A call to the PCI-DAS-1602 analog pulse generator is in the 
		form of...
		mio_fout(count) 
		where "count" specifies a count down in 10 MHz clock cycles 
		before the square wave switches states.
		Converting that to frequency is done by...
		frequency(Hz) = 10,000,000 / count
		therefore...
		count = 10,000,000 / frequency(Hz)
	*/
	count = 10000000/frequency; // See above
	mio_fout(count);			// Start sending the tone
	wait(duration);				// Wait for user defined period of time (ms)
	mio_fout(off);				// Stop sending the tone
	}