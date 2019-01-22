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
declare WRITE_EYE2FILE(float currX, float currY);


process WTCH_EYE()
{
  declare int DEBUG = 0;
  declare int xVal, yVal;
  declare float eyeXdeg, eyeYdeg, oldXdeg, oldYdeg;
  declare int   lasttime, eyeXpixels, eyeYpixels;
  
  while (1)
  {
    xVal = atable(EYE_X_CHANNEL);
    yVal = atable(EYE_Y_CHANNEL);
    
	if (DEBUG == 1 )
	{
		xVal = random(5000)+10000;
		yVal = random(5000)+10000;
		printf("DEBUG: Eye: %d, %d\n",xVal,yVal); 		
	}
	else
	{
		printf("Eye: %d, %d\n",xVal,yVal);
	}
  
    eyeXdeg = (xVal * ((MAX_VOLTAGE * 2.0) / ANALOG_UNITS) * EYE_X_GAIN) - EYE_X_OFFSET;
    eyeYdeg = (yVal * ((MAX_VOLTAGE * 2.0) / ANALOG_UNITS) * EYE_Y_GAIN) - EYE_Y_OFFSET;
		
    if (CENTER_EYE_NOW)
    {
      EYE_X_OFFSET   = EYE_X_OFFSET + eyeXdeg;
      EYE_Y_OFFSET   = EYE_Y_OFFSET + eyeYdeg;
      CENTER_EYE_NOW = 0;
    }
	
	
    if (eyeXdeg != oldXdeg || eyeYdeg != oldYdeg)
    {
	  spawn LOCATE_EYE(eyeXdeg,eyeYdeg);

      // why should this be with screen refresh?
      if (time() > lasttime + 16)
      {
        //oMove(object_eye, eyeXpixels, eyeYpixels);
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
  // EYE_IN_FIX_WIN, EYE_BTWN_FIX_WINS
  // EYE_IN_TARG_WIN, EYE_BTWN_TARG_WINS
  // EYE_IN_TARG_WIN_ANTI, EYE_BTWN_TARG_WINS_ANTI
  CURR_EYE_X_DEG = degX;
  CURR_EYE_Y_DEG = degY;
  // Check Eye pos in FIX window area
  if (  degX >= FIX_WIN[LEFT] && degX <= FIX_WIN[RIGHT]
     && degY >= FIX_WIN[UP] && degY <= FIX_WIN[DOWN])
  {
    EYE_IN_FIX_WIN          = 1;
    EYE_BTWN_FIX_WINS       = 0;
    EYE_IN_TARG_WIN         = 0;
    EYE_BTWN_TARG_WINS      = 0;
    EYE_IN_TARG_WIN_ANTI    = 0;
    EYE_BTWN_TARG_WINS_ANTI = 0;
  }
  else if (  degX >= FIX_WIN_LARGE[LEFT] && degX <= FIX_WIN_LARGE[RIGHT]
          && degY >= FIX_WIN_LARGE[UP] && degY <= FIX_WIN_LARGE[DOWN])
  {
    // INACCURATE Between FIX_WIN_LARGE and FIX_WIN
    EYE_IN_FIX_WIN          = 0;
    EYE_BTWN_FIX_WINS       = 1;
    EYE_IN_TARG_WIN         = 0;
    EYE_BTWN_TARG_WINS      = 0;
    EYE_IN_TARG_WIN_ANTI    = 0;
    EYE_BTWN_TARG_WINS_ANTI = 0;
  }
  else if (  degX >= TARG_WIN[LEFT] && degX <= TARG_WIN[RIGHT]
          && degY >= TARG_WIN[UP] && degY <= TARG_WIN[DOWN])
  {
    // Check Eye pos in TARGET window area
    EYE_IN_FIX_WIN          = 0;
    EYE_BTWN_FIX_WINS       = 0;
    EYE_IN_TARG_WIN         = 1;
    EYE_BTWN_TARG_WINS      = 0;
    EYE_IN_TARG_WIN_ANTI    = 0;
    EYE_BTWN_TARG_WINS_ANTI = 0;
  }
  else if (  degX >= TARG_WIN_LARGE[LEFT] && degX <= TARG_WIN_LARGE[RIGHT]
          && degY >= TARG_WIN_LARGE[UP] && degY <= TARG_WIN_LARGE[DOWN])
  {
    // INACCURATE Between TARG_WIN_LARGE and TARG_WIN
    EYE_IN_FIX_WIN          = 0;
    EYE_BTWN_FIX_WINS       = 0;
    EYE_IN_TARG_WIN         = 0;
    EYE_BTWN_TARG_WINS      = 1;
    EYE_IN_TARG_WIN_ANTI    = 0;
    EYE_BTWN_TARG_WINS_ANTI = 0;
  }
  else if (  degX >= TARG_WIN_ANTI[LEFT] && degX <= TARG_WIN_ANTI[RIGHT]
          && degY >= TARG_WIN_ANTI[UP] && degY <= TARG_WIN_ANTI[DOWN])
  {
    // Check Eye pos in ANTI - TARGET window area
    EYE_IN_FIX_WIN          = 0;
    EYE_BTWN_FIX_WINS       = 0;
    EYE_IN_TARG_WIN         = 0;
    EYE_BTWN_TARG_WINS      = 0;
    EYE_IN_TARG_WIN_ANTI    = 1;
    EYE_BTWN_TARG_WINS_ANTI = 0;
  }
  else if (  degX >= TARG_WIN_ANTI_LARGE[LEFT] && degX <= TARG_WIN_ANTI_LARGE[RIGHT]
          && degY >= TARG_WIN_ANTI_LARGE[UP] && degY <= TARG_WIN_ANTI_LARGE[DOWN])
  {
    // INACCURATE Between TARG_WIN_ANTI_LARGE and EYE_BTWN_TARG_WINS_ANTI
    EYE_IN_FIX_WIN          = 0;
    EYE_BTWN_FIX_WINS       = 0;
    EYE_IN_TARG_WIN         = 0;
    EYE_BTWN_TARG_WINS      = 0;
    EYE_IN_TARG_WIN_ANTI    = 0;
    EYE_BTWN_TARG_WINS_ANTI = 1;
  }
  else
  {
    EYE_IN_FIX_WIN          = 0;
    EYE_BTWN_FIX_WINS       = 0;
    EYE_IN_TARG_WIN         = 0;
    EYE_BTWN_TARG_WINS      = 0;
    EYE_IN_TARG_WIN_ANTI    = 0;
    EYE_BTWN_TARG_WINS_ANTI = 0;
  }
  spawn WRITE_EYE2FILE(CURR_EYE_X_DEG,CURR_EYE_Y_DEG);
} /* LOCATE_EYE */

process WRITE_EYE2FILE(float currX, float currY)
{
	declare float currEyeAngle;
    declare float currEyeEcc;

	currEyeAngle = rad2deg(atan(currY/currX));
	currEyeEcc = sqrt((currY * currY) + (currX * currX));
	printf("EyeVals: %d,%d,%d,%d\n",currX*10,currY*10,currEyeAngle*10,currEyeEcc*10);
    writef("eyeVals.csv %d,%d,%d,%d\n",currX*10,currY*10,currEyeAngle*10,currEyeEcc*10);
}
