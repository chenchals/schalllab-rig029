//Made this its own process so that I can fire a sound off from the
//server without pausing to wait for the sound to end.
//Can be used as a warning tone to alert the operator that the animal
//is doing something wrong.

declare SVR_BELL();

process SVR_BELL()
	{	
	
	sound(250);
	wait 50;
	sound(0);
	
	sound(500);
	wait 50;
	sound(0);
	
	sound(1000);
	wait 50;
	sound(0);
	
	sound(2000);
	wait 50;
	sound(0);
	
	sound(4000);
	wait 50;
	sound(0);
	
	sound(8000);
	wait 50;
	sound(0);
	
	sound(16000);
	wait 50;
	sound(0);
	
	sound(32000);
	wait 50;
	sound(0);
	
	sound(64000);
	wait 50;
	sound(0);
	
	}
