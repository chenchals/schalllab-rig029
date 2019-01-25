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
  eyeA = random(3600)/10.0;
  if (eyeA > 180.0)
  {
    eyeA = eyeA - 360.0;
  }
  eyeXdeg = cos(eyeA) * random(SCRN_DEG_X*10)/10.0;
  eyeYdeg = -sin(eyeA) * random(SCRN_DEG_Y*10)/10.0;

  // Convert to possible voltage value that we would get from atable[EYE_X_CHANNEL]
  EYE_X_VOLTS = (eyeXdeg + EYE_X_OFFSET)/(( EYE_X_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);
  // Convert to possible voltage value that we would get from atable[EYE_Y_CHANNEL]
  EYE_Y_VOLTS = (eyeXdeg + EYE_Y_OFFSET)/(( EYE_Y_GAIN * MAX_VOLTAGE * 2.0)/ANALOG_UNITS);

}
