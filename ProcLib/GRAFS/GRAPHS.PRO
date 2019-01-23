//==========================================================================
// GRAPHS.PRO
//   Description: Setup graph objects for updating.
//                Adapted form GRAPHS.PRO from previous builds
//                BY david c godlove Jan 2011
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-23
//==========================================================================
//  Revision History:
//

#include C:/TEMPO/ProcLib/GRAFS/OBJECT.PRO

// graph objects for LEFT window
declare OBJ_EYE;
declare OBJ_FIX;
declare OBJ_FIX_WIN;
declare OBJ_FIX_WIN_L;
declare OBJ_TARG;
declare OBJ_TARG_WIN;

//
declare int GRF_SHOW = 1;
declare int GRF_HIDE = 0;


declare GRAPHS();
declare GRAF_UPD8_EYE(float currEyeX, float currEyeY);
declare GRAF_SHOW_FIX(int showHide);


process GRAPHS()
{
 
  oSetGraph(gLEFT, aCLEAR);
  // set LEFT graph to virtual coordinates
  oSetGraph(gLEFT, aRANGE, -SCRN_PIX_X / 2, SCRN_PIX_X / 2, -SCRN_PIX_Y / 2, SCRN_PIX_Y / 2);
  oSetGraph(gLEFT, aTITLE, "TASk PROGRESS");
  //=======EYE OBJECT============
  // Create eye as a visible + type graph
  OBJ_EYE = oCreate(tCross, gLEFT, DEG_2_PIX_X, DEG_2_PIX_Y);
  oSetAttribute(OBJ_eye, aVISIBLE);
  //=======FIX / FIX_WINDOW OBJECTS============
  // Create invisible filled box type graph for fix spot
  OBJ_FIX = oCreate(tBOX, gLEFT, 0, 0);
  oSetAttribute(OBJ_FIX, aFILLED);
  oSetAttribute(OBJ_FIX, aINVISIBLE);
  // Create invisible unfilled box type graph for fix window
  OBJ_FIX_WIN = oCreate(tBOX, gLEFT, 0, 0);
  oSetAttribute(OBJ_FIX_WIN, aUNFILLED);
  oSetAttribute(OBJ_FIX_WIN, aINVISIBLE);
  OBJ_FIX_WIN_L = oCreate(tBOX, gLEFT, 0, 0);
  oSetAttribute(OBJ_FIX_WIN_L, aUNFILLED);
  oSetAttribute(OBJ_FIX_WIN_L, aINVISIBLE);
  //=======TARGET / TARGET_WINDOW OBJECTS============
  // Create invisible filled box type graph for target
  OBJ_TARG = oCreate(tBOX, gLEFT, 0, 0);
  oSetAttribute(OBJ_TARG, aFILLED);
  oSetAttribute(OBJ_TARG, aINVISIBLE);
  // Create invisible unfilled box type graph for target window
  OBJ_TARG_WIN = oCreate(tBOX, gLEFT, 0, 0);
  oSetAttribute(OBJ_TARG_WIN, aUNFILLED);
  oSetAttribute(OBJ_TARG_WIN, aINVISIBLE);
}


process GRAF_UPD8_EYE(float currEyeX, float currEyeY)
{
  oMove(OBJ_EYE, currEyeX * DEG_2_PIX_X, currEyeY * DEG_2_PIX_Y);
}


process GRAF_SHOW_FIX(int showHide)
{
  if (showHide == GRF_SHOW)
  {
    oSetAttribute(OBJ_FIX, aSIZE, ceil(FIX_SIZE_DEG * DEG_2_PIX_X), ceil(FIX_SIZE_DEG * DEG_2_PIX_Y));
    oSetAttribute(OBJ_FIX, aVISIBLE);
    oSetAttribute(OBJ_FIX_WIN, aSIZE, FIX_WIN_SIZE * DEG_2_PIX_X, FIX_WIN_SIZE * DEG_2_PIX_Y);
    oSetAttribute(OBJ_FIX_WIN, aVISIBLE);
    oSetAttribute(OBJ_FIX_WIN_L, aSIZE, FIX_WIN_SIZE_LARGE * DEG_2_PIX_X, FIX_WIN_SIZE_LARGE * DEG_2_PIX_Y);
    oSetAttribute(OBJ_FIX_WIN_L, aVISIBLE);
  }
  else
  {
    oSetAttribute(OBJ_FIX, aINVISIBLE);
    oSetAttribute(OBJ_FIX_WIN, aINVISIBLE);
  }
}
