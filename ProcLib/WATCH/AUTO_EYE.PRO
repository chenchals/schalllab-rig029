//==========================================================================
// AUTO_EYE.PRO
//   Description: Create eyeX and eyeY positions for auto-monkey
//   NOTE:
//         Only works if MONK_ID s=is set to AUTO_ID
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-25
//==========================================================================
//  Revision History:
//

declare AUTO_EYE();
declare AUTO_EYE_GET_READY();
declare AUTO_EYE_FIX_ON();

declare float AUTO_EYE_A;
declare float AUTO_EYE_X_DEG;
declare float AUTO_EYE_Y_DEG;
declare int AUTO_EYE_TICS;

process AUTO_EYE()
{
	// Random eye position which is ON the screen
	// Eccentricity: Between screen degrees X, screen degrees Y
	// Angle any

	//spawnwait RAND_EYE();
	if (CURR_STAT == STAT_GET_READY )
	{
		spawnwait AUTO_EYE_GET_READY();
	}
	else if (CURR_STAT == STAT_FIX_ON)
	{
		spawnwait AUTO_EYE_FIX_ON();
	}
	// Convert to possible voltage value that we would get from atable[EYE_X_CHANNEL]
	EYE_X_VOLTS = (AUTO_EYE_X_DEG + EYE_X_OFFSET)/(( EYE_X_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);
	// Convert to possible voltage value that we would get from atable[EYE_Y_CHANNEL]
	EYE_Y_VOLTS = (AUTO_EYE_Y_DEG + EYE_Y_OFFSET)/(( EYE_Y_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);

}

process AUTO_EYE_GET_READY()
{	
	if (AUTO_EYE_TICS > 0)
	{
		AUTO_EYE_TICS = 0;
	}
	else
	{
		AUTO_EYE_TICS = AUTO_EYE_TICS + 1; 
		if (AUTO_EYE_TICS <= (STAT_ALLOWED_T) + 10)
		{
			// for eyeXdeg
			if(random(1))
			{
				AUTO_EYE_X_DEG = (FIX_WIN_SIZE + 1) - random(10)/10;
			}
			else
			{
				AUTO_EYE_X_DEG = FIX_WIN_SIZE + random(10)/10;
			}
			// for eyeYdeg
			if(random(1))
			{
				AUTO_EYE_Y_DEG = (FIX_WIN_SIZE + 1) - random(10)/10;
			}
			else
			{
				AUTO_EYE_Y_DEG = FIX_WIN_SIZE + random(10)/10;
			}

		}		
	}
}

process AUTO_EYE_FIX_ON()
{	
	if (AUTO_EYE_TICS > 0)
	{
		AUTO_EYE_TICS = 0;
	}
	else
	{
		AUTO_EYE_TICS = AUTO_EYE_TICS + 1;
		if (AUTO_EYE_TICS <= round((STAT_ALLOWED_T*0.5)))
		{
			// hold position for half the allowed fix timetime
			AUTO_EYE_X_DEG = AUTO_EYE_X_DEG;
			AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG;
		}
		else // fixate
		{
			AUTO_EYE_X_DEG = random(round(FIX_WIN_SIZE*10.0/2.0))/10.0;
			AUTO_EYE_Y_DEG = random(round(FIX_WIN_SIZE*10.0/2.0))/10.0;
		}	
	}
}
