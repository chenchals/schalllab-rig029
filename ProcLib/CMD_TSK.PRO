//==========================================================================
// CMD_TSK.PRO
//   Description: Loads all PRO files for CMD task
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//
//==========================================================================
// Use variables on the fly - no declaration
#pragma declare = 1
// Room variables: screen, isoluminant colors, data channels
#include C:/TEMPO/ProcLib/RIG/SET_RIG.PRO
// Set monk
#include C:/TEMPO/ProcLib/MONK/SET_MONK.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
// Setup event defs so events can be sent
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO
// Setup GRAPHS
#include C:/TEMPO/ProcLib/GRAFS/GRAPHS.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_EYE.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_PD.PRO
// Send event code
#include C:/TEMPO/ProcLib/UTIL/SEND_EVT.PRO
//#include C:/TEMPO/ProcLib/UTIL/SEND_TTL.PRO
//#include C:/TEMPO/ProcLib/UTIL/QUE_TTL.PRO

#include C:/TEMPO/ProcLib/UTIL/BITSWEEP.PRO

//#include C:/TEMPO/ProcLib/TEST/DIOTEST.PRO

//==========================================================================
// The State global variable allows the control structure to run tasks...
// ...depending on the current stystem state. The beginning state is idling.
declare int TASK;
// Starts tasks after setting variables;
declare int OK;
// Give user ability to pause task with a button press
declare int PAUSE;
// Keeps track of the last task which was run to hold onto default variable values
declare int LAST_TASK;


declare IDLE();
declare SETC_TRL();

process IDLE() enabled
{
  declare int tempVar;
  int         tempTrlNumber;

  // ========== Call once =============
  spawnwait SET_RIG(29);
  spawnwait SET_SCRN();
  spawnwait SET_CLR_PALETTE();
  spawnwait SET_DEFAULT_STIM_VARS();
  spawnwait SET_MONK(AUTO_ID);

  spawn QUE_TTL();
  spawn WTCH_EYE();
  spawn WTCH_SCHMITT();

  while (1)
  {
    printf("Doing Bitsweep()\n");
    spawnwait BITSWEEP();
  }


  printf("ALLPROSC.PRO Running CMD_PGS()\n");
  spawnwait CMD_PGS();

  printf("DONE....!\n");
  printf("Showing pages....!\n");

  while (1)
  {
    //===============For each Trial=====================
    tempTrlNumber = tempTrlNumber + 1;
    spawnwait SETC_TRL();

    //================ STATE == READY ===================
    // STATE = READY
    //when monk's eye os outside the large fix window
    TRL_NUMBER = tempTrlNumber;
    printf("Trial num %d, Target pos %d\n", TRL_NUMBER, CURR_TARGET_IDX);

    dsendf("vp %d\n", PG_FIXATION_PD);
    dsendf("VW %d\n", 2);
    dsendf("vp %d\n", PG_BLANK);
    dsendf("VW %d\n", 5);
    dsendf("vp %d\n", PG_TARGET_PD);
    dsendf("VW %d\n", 5);
    dsendf("vp %d\n", PG_SIGNAL_PD);
    dsendf("VW %d\n", 1);
    dsendf("vp %d\n", PG_BLANK);
    nexttick 1000;
    CURR_TARGET_IDX = CURR_TARGET_IDX + 1;
  }
} /* IDLE */


process SETC_TRL()
{
  declare float eccX, eccY;



  // Compute fix win size
  // Fix spot center is at 0,0, so we do not need to compute
  FIX_WIN[LEFT]  = -FIX_WIN_SIZE/2;
  FIX_WIN[RIGHT] = FIX_WIN_SIZE/2;
  FIX_WIN[UP]    = -FIX_WIN_SIZE/2;
  FIX_WIN[DOWN]  = FIX_WIN_SIZE/2;
  // Larger fix win - For inaccurate eye position
  FIX_WIN_LARGE[LEFT]  = -FIX_WIN_SIZE_LARGE/2;
  FIX_WIN_LARGE[RIGHT] = FIX_WIN_SIZE_LARGE/2;
  FIX_WIN_LARGE[UP]    = -FIX_WIN_SIZE_LARGE/2;
  FIX_WIN_LARGE[DOWN]  = FIX_WIN_SIZE_LARGE/2;

  // pick current target location
  CURR_TARGET_IDX = random(N_TARG_POS);

  // Compute TARG_WIN and TARG_WIN_LARGE
  eccX            = cos(TARG_ANGLE_ARRY[CURR_TARGET_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  eccY            = -sin(TARG_ANGLE_ARRY[CURR_TARGET_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  TARG_WIN[LEFT]  = eccX - TARG_WIN_SIZE/2;
  TARG_WIN[RIGHT] = eccX + TARG_WIN_SIZE/2;
  TARG_WIN[UP]    = eccY - TARG_WIN_SIZE/2;
  TARG_WIN[DOWN]  = eccY + TARG_WIN_SIZE/2;
  // Larger target window - For inaccurate eye position
  TARG_WIN_LARGE[LEFT]  = eccX - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_LARGE[RIGHT] = eccX + TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_LARGE[UP]    = eccY - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_LARGE[DOWN]  = eccY + TARG_WIN_SIZE_LARGE/2;
  // Compute TARG_WIN_ANTI and TARG_WIN_LARGE_ANTI
  eccX                 = cos(TARG_ANGLE_ARRY[CURR_TARGET_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  eccY                 = -sin(TARG_ANGLE_ARRY[CURR_TARGET_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARGET_IDX];
  TARG_WIN_ANTI[LEFT]  = eccX - TARG_WIN_SIZE/2;
  TARG_WIN_ANTI[RIGHT] = eccX + TARG_WIN_SIZE/2;
  TARG_WIN_ANTI[UP]    = eccY - TARG_WIN_SIZE/2;
  TARG_WIN_ANTI[DOWN]  = eccY + TARG_WIN_SIZE/2;
  // Larget ANTI target window - For inaccurate Eye position
  TARG_WIN_ANTI_LARGE[LEFT]  = eccX - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_ANTI_LARGE[RIGHT] = eccX + TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_ANTI_LARGE[UP]    = eccY - TARG_WIN_SIZE_LARGE/2;
  TARG_WIN_ANTI_LARGE[DOWN]  = eccY + TARG_WIN_SIZE_LARGE/2;


	// Setup CMD PAGES
	spawnwait CMD_PGS();

} /* SETC_TRL */
