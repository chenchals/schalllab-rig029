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
declare AUTO_EYE_FIXATE();


declare AUTO_EYE_RAND();
declare AUTO_EYE_FIX_WIDE();
declare AUTO_EYE_MARCH();

declare float AUTO_EYE_A;
declare float AUTO_EYE_X_DEG;
declare float AUTO_EYE_Y_DEG;
declare int AUTO_EYE_TICS;

process AUTO_EYE()
{
	declare int march;
	march = 1;
	while(1)
	{
		// Random eye position which is ON the screen
		// Eccentricity: Between screen degrees X, screen degrees Y
		// Angle any

		if (CURR_STAT == STAT_TEST)
		{
			spawnwait AUTO_EYE_MARCH();
		}
		else if(CURR_STAT == STAT_IDLE)
		{
			spawnwait AUTO_EYE_RAND();
		}
		else if (CURR_STAT == STAT_GET_READY )
		{
			spawnwait AUTO_EYE_GET_READY();
		}
		else if (CURR_STAT == STAT_FIX_ON)
		{
			spawnwait AUTO_EYE_FIX_ON();
		}
		else if (CURR_STAT == STAT_FIXATE)
		{
			spawnwait AUTO_EYE_FIXATE();
		}
		else
		{
			//freeze
			AUTO_EYE_X_DEG = AUTO_EYE_X_DEG;
			AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG;
		}
		nexttick;
	}

}

process AUTO_EYE_GET_READY()
{	
	if (STAT_DLTA_T <= (STAT_ALLOWED_T) + 10)
	{
		spawnwait AUTO_EYE_FIX_WIDE();
	}		
}

process AUTO_EYE_MARCH()
{
	// march along diagonal
	if (AUTO_EYE_TICS ==0)
	{
		AUTO_EYE_TICS = 1;
		AUTO_EYE_X_DEG = -15.0;
		AUTO_EYE_Y_DEG = -15.0;
	}
	else
	{
		AUTO_EYE_TICS = AUTO_EYE_TICS +1;
		if (AUTO_EYE_TICS >= 10)
		{
			AUTO_EYE_TICS = 1;
			AUTO_EYE_X_DEG = AUTO_EYE_X_DEG + 1.0;
			AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG + 1.0;
		}
		else if(AUTO_EYE_X_DEG >= 15)
		{
			AUTO_EYE_X_DEG = -15.0;
			AUTO_EYE_Y_DEG = -15.0;
		}
		else 
		{
			AUTO_EYE_TICS = AUTO_EYE_TICS + 1;
		}	
	}
}

process AUTO_EYE_RAND()
{
	AUTO_EYE_X_DEG = random(10) + random(10)/10.0;
	AUTO_EYE_Y_DEG = random(10) + random(10)/10.0;
	if(random(2))
	{
		AUTO_EYE_X_DEG = AUTO_EYE_X_DEG * -1;
	}
	if(random(2))
	{
		AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG * -1;
	}
}

process AUTO_EYE_FIX_WIDE()
{
	declare float halfWin;
	halfWin = (FIX_WIN_SIZE+2.0)/2.0;
	AUTO_EYE_X_DEG = halfWin + random(50)/10.0;
	AUTO_EYE_Y_DEG = halfWin + random(50)/10.0;
	// for eyeXdeg
	if(random(2))
	{
		AUTO_EYE_X_DEG = AUTO_EYE_X_DEG * -1.0;
	}
	// for eyeYdeg
	if(random(2))
	{
		AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG * -1.0;
	}
}

process AUTO_EYE_FIX_ON()
{		
	if (STAT_DLTA_T <= round(STAT_ALLOWED_T*0.8 ))
	{
		// hold position for half the allowed fix timetime
		AUTO_EYE_X_DEG = AUTO_EYE_X_DEG + random(10)/10.0;
		AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG + random(10)/10.0;
	}
	else // fixate
	{
		AUTO_EYE_X_DEG = 0.1;
		AUTO_EYE_Y_DEG = 0.1;
	}	
}

process AUTO_EYE_FIXATE()
{		
	if (STAT_DLTA_T <= round(STAT_ALLOWED_T*0.8))
	{
		// hold fix 
		AUTO_EYE_X_DEG =  random(5)/10.0;
		AUTO_EYE_Y_DEG =  random(5)/10.0;
	}
	else // break fix
	{
		spawnwait AUTO_EYE_FIX_WIDE();
	}	
}
