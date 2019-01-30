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
  spawnwait CMD_PGS();

  //  while(1)
  //{
  // spawnwait PCK_TRL_TYP();
  // printf("TRIAL_TYPE : %d\n\n\n",TRIAL_TYPE);
  // nexttick 100;
  //}
  TRL_NUMBER = 0;
  while (1)
  {
    //===============For each Trial=====================
    CURR_STAT    = STAT_IDLE;
    STAT_OUTCOME = O_NOT_REDY;
    spawnwait SETC_TRL();

    trlRunning = 1;
    while (trlRunning)
    {
      //================= State = STAT_WAIT_FIX===============
      printf("Trial running....\n")
      dsendf("vp %d\n", PG_BLANK);
      // Check of eyes are outside FIX_WIN_SIZE_LARGE
      // TRL_START_TIME = time();
      spawnwait PROC_WAIT_FIX(time(), WAIT_READY_TIME);

      //================= State = STAT_FIX_ON===============
      dsendf("vp %d\n", PG_FIXATION_PD);
      spawn GRAF_SHOW_FIX(GRAF_SHOW);
      // TRL_FIX_ON_TIME = time();
      spawn SEND_EVT(FixSpotOn_);
      spawnwait PROC_FIX_ON(time(), ALLOWED_FIX_TIME);
      TRL_NUMBER = TRL_NUMBER + 1;
      if (STAT_OUTCOME != O_ACQ_FIX)
      {
        spawn GRAF_SHOW_FIX(GRAF_HIDE);
        trlRunning = 0;
        // TRL_FIX_ABORT_TIME = time();
        // do other stuff -->
        // Tone?
        // punish time...
      }
      //================= State = STAT_FIXATE===============
      if (trlRunning)
      {
        // TRL_FIX_ACQ_TIME = time();
        spawnwait PROC_FIXATE(time(), FIX_HOLD_TIUME);
        if(STAT_OUTCOME != O_FIXATE)
        {
          spawn GRAF_SHOW_FIX(GRAF_HIDE);
          trlRunning = 0;
          // TRL_BRK_FIX_TIME = time()
          spawn SEND_EVT(Abort_);
          // do other stuff -->
          // Tone?
          // punish time...
        }
      }
      //================= State = STAT_TARG_ON===============
      if(trlRunning) // and TRIAL_TYPE == TRIAL_TYPE_GO
      {
        // TRL_FIXATE_TIME = time();
        spawn SEND_EVT(Fixate_);
        dsendf("vp %d\n", PG_TARGET_PD)
        spawn SEND_EVT(Target_);
        // TRL_TARG_ON_TIME = time()
        spawn GRAF_SHOW_TARG(GRAF_SHOW);
        spawnwait PROC_TARG_ON(time(),MIN_MAX_SACCADE_TIME[1]);
        // Eye moved before MIN_SACCADE_TIME
        if(STAT_OUTCOME != O_FIXATE)
        {
          spawn GRAF_SHOW_FIX(GRAF_HIDE);
          spawn GRAF_SHOW_TARG(GRAF_HIDE);
          trlRunning = 0;
          // TRL_BRK_FIX_TIME = time()
          spawn SEND_EVT(Abort_);
          // do other stuff -->
          // Tone?
          // punish time...
        }
        else
        {
           spawnwait PROC_FIXATE_TARG(time(),MIN_MAX_SACCADE_TIME[2]-MIN_MAX_SACCADE_TIME[1],TARG_HOLD_TIME);

        }


      }

      nexttick;


      //================ STATE == READY ===================
      // STATE = READY
      //when monk's eye os outside the large fix window
      //tempTrlNumber = tempTrlNumber + 1;
      //TRL_NUMBER = tempTrlNumber;
      //  printf("Trial num %d, Target pos %d\n", TRL_NUMBER, CURR_TARGET_IDX);

      //  dsendf("vp %d\n", PG_FIXATION_PD);
//	spawn GRAF_SHOW_FIX(GRAF_SHOW);
      //  nexttick 1000;
      //dsendf("VW %d\n", 2);
      //dsendf("vp %d\n", PG_BLANK);
      //dsendf("VW %d\n", 5);
      //  dsendf("vp %d\n", PG_TARGET_PD);
//	spawn GRAF_SHOW_TARG(GRAF_SHOW);
      //dsendf("VW %d\n", 20);
      //dsendf("vp %d\n", PG_SIGNAL_PD);
      //dsendf("VW %d\n", 1);
      //dsendf("vp %d\n", PG_BLANK);
      //nexttick;
    }
  }
} /* IDLE */
