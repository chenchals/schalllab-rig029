//Made this its own process so that I can fire a sound off from the
//server without pausing to wait for the sound to end.
//Can be used as a warning tone to alert the operator that the animal
//is doing something wrong.

declare SVR_BEL2();

process SVR_BEL2()
	{
	
	sound(4000);
	wait 100;
	sound(0);
	
	}
