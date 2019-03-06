//==========================================================================
// DISTTEST.PRO
//   Description: Test process in CMD/STAIR.PRO/STAIRCASE_SSD()
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-06
//==========================================================================

// Global variables accessed by STAIRCASR_SSD()
#include C:/TEMPO/ProcLib/CMD/VAR_CMD.PRO
#include C:/TEMPO/ProcLib/CMD/SET_CMD.PRO
#include C:/TEMPO/ProcLib/CMD/STAIR.PRO

declare STAIRCASE_SSD_TEST();

process STAIRCASE_SSD_TEST() enabled
{
  declare int nTrials = 2000;
  declare int trlNo;
  declare int stopOutcomes[3] = {OutcomeNoGoCancelled_, OutcomeNoGoNonCancelled_, OutcomeNoGoError_};
  declare int goOutcomes[2] = {OutcomeGoCorrect_, OutcomeGoError_};
  SSD_STEP_UP = 3;
  SSD_STEP_DOWN = 3;
  N_SSD = 10;

    writef("stairSsd.csv trlNo, trialType, trlLastGoOutcome, trlLastStopOutcome, trlLastSsdIdx, trlSsdIdx\n");
    while (trlNo < nTrials)
    {
        trlNo = trlNo + 1;
        TRL_TYPE = TRIAL_TYPE_GO;
        if(random(2) > 0)
        {
          TRL_TYPE = TRIAL_TYPE_STOP;
        }
        if(trlNo > 1) // dont know outcomes for trial 1
        {
          if (TRL_TYPE == TRIAL_TYPE_GO)
          {
            TRL_LAST_GO_OUTCOME_EVNTCODE = goOutcomes[random(2)];
          }
          else
          {
            if(TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoError_)
            {
              // do not change the outcome for some time
              if (random(10) > 4)
              {
                TRL_LAST_STOP_OUTCOME_EVNTCODE = OutcomeNoGoError_;
              }
            }
            else
            {
              TRL_LAST_GO_OUTCOME_EVNTCODE = stopOutcomes[random(3)];
            }
          }
        }
        // set the trl SSD
        if(TRL_TYPE == TRIAL_TYPE_STOP)
        {
          spawnwait STAIRCASE_SSD();
        }
        else
        {
          // should we put a -1?
          TRL_STOP_SIGNAL_DELAY_IDX = 0;
        }

        printf("%d,%d,%d,%d,%d,%d\n", trlNo,TRL_TYPE,TRL_LAST_GO_OUTCOME_EVNTCODE,TRL_LAST_STOP_OUTCOME_EVNTCODE,TRL_LAST_SSD_IDX,TRL_STOP_SIGNAL_DELAY_IDX);
        writef("stairSsd.csv %d,%d,%d,%d,%d,%d\n", trlNo,TRL_TYPE,TRL_LAST_GO_OUTCOME_EVNTCODE,TRL_LAST_STOP_OUTCOME_EVNTCODE,TRL_LAST_SSD_IDX,TRL_STOP_SIGNAL_DELAY_IDX);

        nexttick 2;
    }
    printf("\n****Writing file : stairSsd.csv---will complete--ONLY when you exit the TEMPO Client****\n");
}/* STAIRCASE_SSD_TEST */
