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

declare AUTO_OUTCOME = O_NOT_REDY;
declare float AUTO_EYE_A;
declare float AUTO_EYE_X_DEG_END;
declare float AUTO_EYE_Y_DEG_END;
declare int AUTO_EYE_TICS_START;

process AUTO_EYE()
{
  declare float eccX;
  declare float eccY;
  declare float eccXanti;
  declare float eccYanti;

  declare float eyeA;

  declare float eyeXdeg;
  declare float eyeYdeg;

  // Random eye position which is ON the screen
  // Eccentricity: Between screen degrees X, screen degrees Y
  // Angle any

  spawnwait RAND_EYE();



  eyeXdeg = AUTO_EYE_X_DEG_END * AUTO_EYE_TICS_START + CURR_EYE_X_DEG
  eyeYdeg = AUTO_EYE_Y_DEG_END * AUTO_EYE_TICS_START + CURR_EYE_Y_DEG

  // Convert to possible voltage value that we would get from atable[EYE_X_CHANNEL]
  EYE_X_VOLTS = (eyeXdeg + EYE_X_OFFSET)/(( EYE_X_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);
  // Convert to possible voltage value that we would get from atable[EYE_Y_CHANNEL]
  EYE_Y_VOLTS = (eyeXdeg + EYE_Y_OFFSET)/(( EYE_Y_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);

}

process RAND_EYE()
{
  declare float slope;
  if (AUTO_EYE_TICS_START <=1 || AUTO_EYE_TICS_START >= MIN_MAX_SACCADE_TIME[1])
  {
    AUTO_EYE_TICS_START = 1;
    // Auto eye Angle and destination the eye should reach within MAX_SACCADE_DURATION
    AUTO_EYE_A         = random(3600) / 10.0;
    // unit change in X, Y for each tick - Assume: CURR_EYE_X_DEG = 0, and CURR_EYE_Y_DEG = 0
    AUTO_EYE_X_DEG_END = (cos(AUTO_EYE_A) * random(SCRN_DEG_X * 10) / 10.0)/MIN_MAX_SACCADE_TIME[1];
    AUTO_EYE_Y_DEG_END = (-sin(AUTO_EYE_A) * random(SCRN_DEG_Y * 10) / 10.0)/MIN_MAX_SACCADE_TIME[1];
  }
  else if (AUTO_EYE_TICS_START < MIN_MAX_SACCADE_TIME[1])
  {
    AUTO_EYE_TICS_START = AUTO_EYE_TICS_START + 1;
  }
}
