//==========================================================================
// WTCH_EYE.PRO
//   Description: Monitors position of Eye x and y analog values from Eye tracker every clock cycle.
//                Analog(x,y) data is updated and mapped to deg(x,y)
//                deg(x,y) is then resolved to target position
//                -- Not yet: moves the graphics object_eye to new eye location
//   NOTE:
//         Algorithm originally from david.c.godlove@vanderbilt.edu   January, 2011 in WATCHEYE.PRO
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-20
//==========================================================================
//  Revision History:
//

declare WTCH_EYE();
declare LOCATE_EYE(float degX, float degY);
declare COMPUTE_EYE_POS(float currX, float currY);


process WTCH_EYE()
{
	declare int   xVal, yVal;
	declare float eyeXdeg, eyeYdeg, oldXdeg, oldYdeg;
	declare int   lasttime, eyeXpixels, eyeYpixels;

	while (1)
	{
		EYE_X_VOLTS = atable(EYE_X_CHANNEL);
		EYE_Y_VOLTS = atable(EYE_Y_CHANNEL);
		if (MONK_ID == AUTO_ID)
		{
			//printf("AUTO_EYE_X_DEG [%2.3d], AUTO_EYE_Y_DEG [%2.3d]\n",AUTO_EYE_X_DEG,AUTO_EYE_Y_DEG);
			// Convert to possible voltage value that we would get from atable[EYE_X_CHANNEL]
			EYE_X_VOLTS = (AUTO_EYE_X_DEG + EYE_X_OFFSET)/(( EYE_X_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);
			// Convert to possible voltage value that we would get from atable[EYE_Y_CHANNEL]
			EYE_Y_VOLTS = (AUTO_EYE_Y_DEG + EYE_Y_OFFSET)/(( EYE_Y_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);
		}

		eyeXdeg = (EYE_X_VOLTS * ((MAX_VOLTAGE * 2.0) / ANALOG_UNITS) * EYE_X_GAIN) - EYE_X_OFFSET;
		eyeYdeg = (EYE_Y_VOLTS * ((MAX_VOLTAGE * 2.0) / ANALOG_UNITS) * EYE_Y_GAIN) - EYE_Y_OFFSET;

		if (CENTER_EYE_NOW)
		{
			EYE_X_OFFSET   = EYE_X_OFFSET + eyeXdeg;
			EYE_Y_OFFSET   = EYE_Y_OFFSET + eyeYdeg;
			CENTER_EYE_NOW = 0;
		}
		
		spawn GRAF_UPD8_EYE(eyeXdeg, eyeYdeg);

		if (eyeXdeg != oldXdeg || eyeYdeg != oldYdeg)
		{
			spawn LOCATE_EYE(eyeXdeg, eyeYdeg);

			// why should this be with screen refresh?
			if (time() > lasttime + 16)
			{

				if (EYE_ON_VDOSYNC)
				{
					eyeXpixels = eyeXdeg * DEG_2_PIX_X;
					eyeYpixels = eyeYdeg * DEG_2_PIX_Y;

					dsendf("cl;\n");
					dsendf("ru %d,%d,%d,%d;\n", eyeXpixels - 4, (-1 * eyeYpixels) - 4, eyeXpixels + 3, (-1 * eyeYpixels) + 3);
					dsendf("co %d;\n", 5);
				}
				lasttime = time();
				oldXdeg  = eyeXdeg;
				oldYdeg  = eyeYdeg;
			}
		}
		nexttick;
	}
} /* WATCHEYE */


process LOCATE_EYE(float degX, float degY)
{
	// Sets flags for 6 global variables:
	// I_FIX, I_FIX_WIDE
	// I_TARG, I_TARG_WIDE
	// I_TARG_ANTI, I_TARG_ANTI_WIDE
	// Check Eye pos in FIX window area
	if (  degX >= FIX_WIN[LEFT] && degX <= FIX_WIN[RIGHT]
			&& degY >= FIX_WIN[UP] && degY <= FIX_WIN[DOWN])
	{
		I_FIX            = 1;
		I_FIX_WIDE       = 0;
		I_TARG           = 0;
		I_TARG_WIDE      = 0;
		I_TARG_ANTI      = 0;
		I_TARG_ANTI_WIDE = 0;
	}
	else if (  degX >= FIX_WIN_LARGE[LEFT] && degX <= FIX_WIN_LARGE[RIGHT]
			&& degY >= FIX_WIN_LARGE[UP] && degY <= FIX_WIN_LARGE[DOWN])
	{
		// INACCURATE Between FIX_WIN_LARGE and FIX_WIN
		I_FIX            = 0;
		I_FIX_WIDE       = 1;
		I_TARG           = 0;
		I_TARG_WIDE      = 0;
		I_TARG_ANTI      = 0;
		I_TARG_ANTI_WIDE = 0;
	}
	else if (  degX >= TARG_WIN[LEFT] && degX <= TARG_WIN[RIGHT]
			&& degY >= TARG_WIN[UP] && degY <= TARG_WIN[DOWN])
	{
		// Check Eye pos in TARGET window area
		I_FIX            = 0;
		I_FIX_WIDE       = 0;
		I_TARG           = 1;
		I_TARG_WIDE      = 0;
		I_TARG_ANTI      = 0;
		I_TARG_ANTI_WIDE = 0;
	}
	else if (  degX >= TARG_WIN_LARGE[LEFT] && degX <= TARG_WIN_LARGE[RIGHT]
			&& degY >= TARG_WIN_LARGE[UP] && degY <= TARG_WIN_LARGE[DOWN])
	{
		// INACCURATE Between TARG_WIN_LARGE and TARG_WIN
		I_FIX            = 0;
		I_FIX_WIDE       = 0;
		I_TARG           = 0;
		I_TARG_WIDE      = 1;
		I_TARG_ANTI      = 0;
		I_TARG_ANTI_WIDE = 0;
	}
	else if (  degX >= TARG_WIN_ANTI[LEFT] && degX <= TARG_WIN_ANTI[RIGHT]
			&& degY >= TARG_WIN_ANTI[UP] && degY <= TARG_WIN_ANTI[DOWN])
	{
		// Check Eye pos in ANTI - TARGET window area
		I_FIX            = 0;
		I_FIX_WIDE       = 0;
		I_TARG           = 0;
		I_TARG_WIDE      = 0;
		I_TARG_ANTI      = 1;
		I_TARG_ANTI_WIDE = 0;
	}
	else if (  degX >= TARG_WIN_ANTI_LARGE[LEFT] && degX <= TARG_WIN_ANTI_LARGE[RIGHT]
			&& degY >= TARG_WIN_ANTI_LARGE[UP] && degY <= TARG_WIN_ANTI_LARGE[DOWN])
	{
		// INACCURATE Between TARG_WIN_ANTI_LARGE and I_TARG_ANTI_WIDE
		I_FIX            = 0;
		I_FIX_WIDE       = 0;
		I_TARG           = 0;
		I_TARG_WIDE      = 0;
		I_TARG_ANTI      = 0;
		I_TARG_ANTI_WIDE = 1;
	}
	else
	{
		I_FIX            = 0;
		I_FIX_WIDE       = 0;
		I_TARG           = 0;
		I_TARG_WIDE      = 0;
		I_TARG_ANTI      = 0;
		I_TARG_ANTI_WIDE = 0;
	}
	// We want to pass this, since the Global var
	// could change while coputation is done
	spawn COMPUTE_EYE_POS(degX, degY);
} /* LOCATE_EYE */


process COMPUTE_EYE_POS(float currX, float currY)
{
	// Write code to do arctan2d
	// see https://en.wikipedia.org/wiki/Atan2 (expression)
	declare float atanVal;

	CURR_EYE_X_DEG = currX;
	CURR_EYE_Y_DEG = currY;

	atanVal = atan(currY / currX);
	if (currX > 0)
	{
		CURR_EYE_ANGLE = rad2deg(atanVal);
	}
	else if (currX < 0 && currY >= 0)
	{
		CURR_EYE_ANGLE = rad2deg(atanVal + 22 / 7);
	}
	else if (currX < 0 && currY < 0)
	{
		CURR_EYE_ANGLE = rad2deg(atanVal - 22 / 7);
	}
	else if (currX == 0 && currY > 0)
	{
		CURR_EYE_ANGLE = rad2deg(22 / (7 / 2));
	}
	else if (currX == 0 && currY < 0)
	{
		CURR_EYE_ANGLE = rad2deg(-22 / (7 * 2));
	}
	else if (currX == 0 && currY == 0)
	{
		CURR_EYE_ANGLE = 9999999;//undefined;
	}
	CURR_EYE_ECC = sqrt((currY * currY) + (currX * currX));
	if (WRITE_FILE == 1)
	{
		writef("eyeVals.csv %d,%d,%d,%d\n", currX * 10, currY * 10, CURR_EYE_ANGLE * 10, CURR_EYE_ECC * 10);
	}
	if (DEBUG == 1)
	{
		printf("EyeVals: %d,%d,%d,%d\n", currX * 10, currY * 10, CURR_EYE_ANGLE * 10, CURR_EYE_ECC * 10);
	}
} /* COMPUTE_EYE_POS */
