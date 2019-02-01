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

// For different states
declare AUTO_EYE_GET_READY();
declare AUTO_EYE_FIX_ON();
declare AUTO_EYE_FIXATE();
declare AUTO_EYE_TARG_ON();
declare AUTO_EYE_TARG_ACQ();

// Utils for eye pos
declare AUTO_EYE_POS_MARCH();
declare AUTO_EYE_POS_RAND();
declare AUTO_EYE_POS_FIX();
declare AUTO_EYE_POS_FIX_WIDE();
declare AUTO_EYE_POS_TARG();

declare float AUTO_EYE_A;
declare float AUTO_EYE_X_DEG;
declare float AUTO_EYE_Y_DEG;
declare int AUTO_EYE_TICS;

//======Flags for states======
//0= no early sacc
//1= early saccade
declare int DO_SACC_EARLY = 1;
// 0=stay in FIX (for late saccade)
// 1=goto Target within SACC_DURATION
// 2=goto Target After SACC_DURATION
// 3=goto random loc out of FIX WIN_W
declare int DO_TARG_ACQ = 1;


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
			spawnwait AUTO_EYE_POS_MARCH();
		}
		else if(CURR_STAT == STAT_IDLE)
		{
			spawnwait AUTO_EYE_POS_RAND();
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
		else if (CURR_STAT == STAT_TARG_ON)
		{
			spawnwait AUTO_EYE_TARG_ON();
		}
		else if (CURR_STAT == STAT_TARG_ACQ)
		{
			spawnwait AUTO_EYE_TARG_ACQ();
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

// State GET_READY
process AUTO_EYE_GET_READY()
{	
	if (STAT_DLTA_T <= (STAT_ALLOWED_T) + 10)
	{
		spawnwait AUTO_EYE_POS_FIX_WIDE();
	}		
}

// State FIX_ON
process AUTO_EYE_FIX_ON()
{		
	if (STAT_DLTA_T <= round(STAT_ALLOWED_T*0.8))
	{
		// hold position for half the allowed fix timetime
		AUTO_EYE_X_DEG = AUTO_EYE_X_DEG + random(10)/10.0;
		AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG + random(10)/10.0;
	}
	else // fixate
	{
		spawnwait AUTO_EYE_POS_FIX();
	}	
}

// State FIXATE
process AUTO_EYE_FIXATE()
{		
	if (STAT_DLTA_T <= round(STAT_ALLOWED_T*1.1))
	{
		// hold fix 
		AUTO_EYE_X_DEG =  random(5)/10.0;
		AUTO_EYE_Y_DEG =  random(5)/10.0;
	}
	else // break fix
	{
		spawnwait AUTO_EYE_POS_FIX_WIDE();
	}	
}

// State TARG_ON
process AUTO_EYE_TARG_ON()
{		
	declare float fracTime;
	fracTime = 1.1;
	if(DO_SACC_EARLY)
	{
		// cant use random since it changes every nexttick
		fracTime = 0.8;
	}	
	if (STAT_DLTA_T <= round(STAT_ALLOWED_T*fracTime))
	{
		// hold fix 
		spawnwait AUTO_EYE_POS_FIX();
	}
	else
	{
		spawnwait AUTO_EYE_POS_FIX_WIDE();
	}
	
}

// State TARG_ACQ
process AUTO_EYE_TARG_ACQ()
{		
	// 0=stay in FIX (for late saccade)
	// 1=goto Target within SACC_DURATION
	// 2=goto Target After SACC_DURATION
	// 3=goto random loc out of FIX WIN_W
	//declare int DO_TARG_ACQ = 1;

	// STAT_ALLOWED_T = MAX_SACC_TIME-MIN_SAC_TIME
	// STAT_I_MOVE_DURATION = MAX_SACC_DURATION
	// Case 1: Early saccade:
	if(DO_SACC_EARLY)
	{
		//DO_TARG_ACQ cannot be zero as eye in flight
		if(DO_TARG_ACQ==1 )
		{
			if (STAT_DLTA_T <= round(STAT_I_MOVE_DURATION * 0.5) )
			{
				spawnwait AUTO_EYE_POS_FIX();
			}
			else
			{
				spawnwait AUTO_EYE_POS_TARG();
			}					
		}
		else if (DO_TARG_ACQ == 2 )
		{
			if (STAT_DLTA_T <= STAT_I_MOVE_DURATION )
			{
				spawnwait AUTO_EYE_POS_FIX();
			}
			else
			{
				spawnwait AUTO_EYE_POS_TARG();
			}		
		}else // there is no 0 hereif (DO_ACQ_TARG==3)
		{
			spawnwait AUTO_EYE_POS_FIX_WIDE();  
		}
	}
	else // has till max_SAC_TIME
	{
		printf("Auto-eye normal saccade Not yet\n");
	}	
}
//Util functions

process AUTO_EYE_POS_MARCH()
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

process AUTO_EYE_POS_RAND()
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

process AUTO_EYE_POS_FIX()
{
	AUTO_EYE_X_DEG = random(10)/10.0;
	AUTO_EYE_Y_DEG = random(10)/10.0;
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

process AUTO_EYE_POS_FIX_WIDE()
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

process AUTO_EYE_POS_TARG()
{
	declare float halfWin;
	halfWin = TARG_WIN_SIZE/2.0;
	AUTO_EYE_X_DEG = halfWin + random(10)/10.0;
	AUTO_EYE_Y_DEG = halfWin + random(10)/10.0;
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

