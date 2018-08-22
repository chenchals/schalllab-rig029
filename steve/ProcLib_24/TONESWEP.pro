//------------------------------------------------------------------------
// process TONESWEP()
// Play something which can be differentiated from a task relevant pure
// tone.
//
// written by david.c.godlove@vanderbilt.edu 	Sept, 2011

declare TONESWEP();

process TONESWEP()
	{
	spawnwait TONE(64000,10);
	
	spawnwait TONE(32000,10);
	
	spawnwait TONE(16000,10);
	
	spawnwait TONE(8000,10);
	
	spawnwait TONE(4000,10);
	
	spawnwait TONE(2000,10);
	
	spawnwait TONE(1000,10);
	
	spawnwait TONE(500,10);
	
	spawnwait TONE(250,10);	
	}