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

declare WATCHEYE();
declare LOCATE_EYE(float degX,
                     float degY);


process WATCHEYE()
{
  declare float eye_x, eye_y, oldx, oldy;
  declare int   lasttime, plot_x, plot_y;


  while (1)
  {
    eye_x = atable(EYE_X_CHANNEL);
    eye_y = atable(EYE_Y_CHANNEL);


    eye_x = (eye_x * ((MAX_VOLTAGE * 2) / ANALOG_UNITS) * EYE_X_GAIN) - EYE_X_OFFSET;
    eye_y = (eye_y * ((MAX_VOLTAGE * 2) / ANALOG_UNITS) * EYE_Y_GAIN) - EYE_Y_OFFSET;

    if (CENTER_EYE_NOW)
    {
      EYE_X_OFFSET   = EYE_X_OFFSET + eye_x;
      EYE_Y_OFFSET   = EYE_Y_OFFSET + eye_y;
      CENTER_EYE_NOW = 0;
    }
    spawn LOCATE_EYE(eye_x, eye_y);

    plot_x = eye_x * DEG_2_PIX_X;
    plot_y = eye_Y * DEG_2_PIX_Y;
    if (plot_x != oldx || plot_y != oldy)
    {
      // why should this be with screen refresh?
      if (time() > lasttime + 16)
      {
        oMove(object_eye, plot_x, plot_y);
        if (EYE_ON_VDOSYNC)
        {
          dsendf("cl;\n");
          dsendf("ru %d,%d,%d,%d;\n", plot_x - 4, (-1 * plot_y) - 4, plot_x + 3, (-1 * plot_y) + 3);
          dsendf("co %d;\n", 5);
        }
        lasttime = time();
        oldx     = plot_x;
        oldy     = plot_y;
      }
    }
    nexttick;
  }
} /* WATCHEYE */


process LOCATE_EYE(float degX, float degY)
{
  if (  degX >= FIX_WIN[LEFT] && degX <= FIX_WIN[RIGHT]
     && degY >= FIX_WIN[UP] && degY <= FIX_WIN[UP])
  {
    EYE_IN_FIX_WIN = 1;
  }
  else
  {
    EYE_IN_FIX_WIN = 0;
  }
  if (  degX >= TARG_WIN[CURR_TARG_IDX, LEFT] && degX <= TARG_WIN[CURR_TARG_IDX, RIGHT]
     && degY >= TARG_WIN[CURR_TARG_IDX, UP] && degY <= TARG_WIN[CURR_TARG_IDX, UP])
  {
    EYE_IN_TARG_WIN = 1;
  }
  else
  {
    EYE_IN_TARG_WIN = 0;
  }
}
