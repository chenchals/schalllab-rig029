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
#include C:/TEMPO/ProcLib/CMD/SET_CMD.PRO
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/CMD_STAT.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/PRC_STAT.PRO

//==========================================================================

declare IDLE();


process IDLE() enabled
{
  declare int tempVar;
  declare int tempTrlNumber;
  declare int trlRunning;

  seed1(time());
  normal(1);

  // ========== Call once =============
  //RIG_ID = 29;
  //MONK_ID = JOULE_ID;
  spawnwait SET_RIG(RIG_ID);
  spawnwait SET_CLRS();
  spawnwait SET_DEFAULT_STIM_VARS();
  spawnwait SET_MONK(MONK_ID);

  // Setup WATCHES
  spawn QUE_TTL();
  spawn WTCH_EYE();
  spawn WTCH_SCHMITT();
  spawn GRAPHS();

  TRL_NUMBER = 0;
  CURR_STAT = STAT_IDLE;
  spawn SEND_EVT(Identify_Room_);
  spawn SEND_EVT(RIG_ID);
  while (1)
  {
    //===============For each Trial=====================
    spawnwait SET_CMD_TRL();
    trlRunning = 1;
    printf("Trial running....\n")
    spawn SEND_EVT(TaskStart_);
    spawn SEND_EVT(CmanHeader_);
    dsendf("vp %d\n", PG_BLANK);
    TRL_READY_TIME = time();
    spawn GRAF_HIDE_FIX_TARG();
    CURR_STAT = STAT_WAIT_FIX;
    STAT_DLTA_T = 0;
    while (trlRunning)
    {
      //================= State = STAT_WAIT_FIX===============
      if (CURR_STAT == STAT_WAIT_FIX)
      {
        // Check of eyes are outside FIX_WIN_SIZE_LARGE
          STAT_DLTA_T = time() - TRL_READY_TIME;
          if (I_FIX || I_FIX_WIDE)
          {
            STAT_DLTA_T = 0;
          }
          else if (STAT_DLTA_T >= READY_TIME)
          {
            CURR_STAT = STAT_FIX_ON;
          }
          spawn SEND_EVT(TrialReady_);
      }
      //================= State = STAT_FIX_ON===============
      if (CURR_STAT == STAT_FIX_ON)
      {
        TRL_START_TIME = time();
        TRL_NUMBER     = TRL_NUMBER + 1;
        dsendf("vp %d\n", PG_FIXATION_PD);
        spawn GRAF_SHOW_FIX(GRAF_SHOW);
        while (!PD_TRIG_L)
        {
          nexttick;
        }
        TRL_FIX_ON_TIME = time();
        spawn SEND_EVT(FixSpotOn_);
        dsendf("vp %d\n", PG_FIXATION);
        if(I_FIX)
      }
      //================= State = STAT_FIXATE===============
      nexttick;
    }/*while(trlRunning)*/
  }/*while(1)*/
}/*IDLE()*/
