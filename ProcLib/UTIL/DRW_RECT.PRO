//==========================================================================
// DRW_RECT.PRO
//   Description: Draw a rectangle on the video sync screen
//   Author: steven.p.errington@vanderbilt.edu
//   Date: 2018-09-03
//==========================================================================
//  Revision History:
//  002: 2018/09/07 chenchal subraveti
//       Changed to DRW_RECT.PRO
//       Compute upper-left and lower-right pixel cordinates from following rectangle dimensions
// 003: 2019/01/08 chenchal subraveti
//       Updated comments and moved the function to main ProcLib directory.
//       All sizes and angles are in degrees (no mm or pixels)
//

declare DRW_RECT(float sizeX,
                 float sizeY,
                 float CURR_TARG_ANGLE,
                 float CURR_TARG_ECCENTRICITY,
                 int   colorIndex,
                 int   fillFlag);


//
// INPUT
//	 sizeX: Width of the rectangle in visual degrees
//	 sizeY: Height of the rectangle in visual degrees
//	 CURR_TARG_ANGLE: Visual CURR_TARG_ANGLE the center of the stimulus subtends at the eye
//   CURR_TARG_ECCENTRICITY: How far from center in degrees of visual CURR_TARG_ANGLE
//   colorIndex: Color index of the palette
//
process DRW_RECT(float sizeX, float sizeY, float CURR_TARG_ANGLE, float CURR_TARG_ECCENTRICITY, int colorIndex, int fillFlag)
{
  declare float stim_ecc_x;
  declare float stim_ecc_y;
  declare int   ulx;
  declare int   uly;
  declare int   lrx;
  declare int   lry;

  // find the center of the box in x and y space based on the CURR_TARG_ANGLE and CURR_TARG_ECCENTRICITY
  stim_ecc_x = cos(CURR_TARG_ANGLE) * CURR_TARG_ECCENTRICITY;
  stim_ecc_y = sin(CURR_TARG_ANGLE) * CURR_TARG_ECCENTRICITY * -1;

  // find locations of upper left and lower right corners based on location of center and CURR_TARG_SIZE
  ulx = round((stim_ecc_x - sizeX / 2) * DEG_2_PIX_X);
  uly = round((stim_ecc_y + sizeY / 2) * DEG_2_PIX_Y);
  lrx = round((stim_ecc_x + sizeX / 2) * DEG_2_PIX_X);
  lry = round((stim_ecc_y - sizeY / 2) * DEG_2_PIX_Y);

  //printf("DRW_RECT: COLOR_INDEX %d\n", colorIndex);
  //printf("DRW_RECT: sizeX %0.2d, sizeY %0.2d, CURR_TARG_ANGLE %0.2d, CURR_TARG_ECCENTRICITY %0.2d, colorIndex %d, fillFlag %d\n",sizeX, sizeY, CURR_TARG_ANGLE, CURR_TARG_ECCENTRICITY, colorIndex, fillFlag);
  dsendf("co %d;\n", colorIndex);
  if (fillFlag == 0)
  {
    dsendf("ru %d,%d,%d,%d;\n", ulx, uly, lrx, lry);
  }
  else
  {
    dsendf("rf %d,%d,%d,%d;\n", ulx, uly, lrx, lry);
  }
}
