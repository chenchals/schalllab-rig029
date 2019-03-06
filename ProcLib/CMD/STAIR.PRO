//==========================================================================
// STAIR.PRO
//   Description: Process to pick the TRL_STOP_SIGNAL_DELAY_IDX for the stop trial.
//                It is assumed that the SSD_ARRY contains SSDs in *increasing* order.
//
//     Case0: If TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoCancelled_
//               Increase the SSD. TRL_STOP_SIGNAL_DELAY_IDX =  TRL_LAST_SSD_IDX + (random(SSD_STEP_UP) + 1)
//     Case1: If TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoNonCancelled_
//               Decrease the SSD. TRL_STOP_SIGNAL_DELAY_IDX =  TRL_LAST_SSD_IDX - (random(SSD_STEP_DOWN) + 1)
//     Case2: If TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoError_
//               Repeat the SSD. TRL_STOP_SIGNAL_DELAY_IDX =  TRL_LAST_SSD_IDX
//
//   Author: steven.errington@vanderbilt.edu
//   Date: 2014-01
//==========================================================================

declare STAIRCASE_SSD();


process STAIRCASE_SSD()
{
  // N_SSDs should have been set here : see SET_CMD.PRO/PICK_TRL_SSD
  declare int tempVar;

  if (TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoCancelled_)
  {
    tempVar = TRL_LAST_SSD_IDX + random(SSD_STEP_UP) + 1;
    printf("****STAIRCASE_SSD: LastStopOutcome [%d - OutcomeNoGoCancelled_],lastSssdIdx [%d], --> ", OutcomeNoGoCancelled_, TRL_LAST_SSD_IDX);
  }
  else if (TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoNonCancelled_)
  {
    tempVar = TRL_LAST_SSD_IDX - (random(SSD_STEP_DOWN) + 1);
    printf("****STAIRCASE_SSD: LastStopOutcome [%d - OutcomeNoGoNonCancelled_],lastSssdIdx [%d], --> ", OutcomeNoGoNonCancelled_, TRL_LAST_SSD_IDX);
  }
  else if (TRL_LAST_STOP_OUTCOME_EVNTCODE == OutcomeNoGoError_)
  {
    tempVar = TRL_LAST_SSD_IDX;
    printf("****STAIRCASE_SSD: LastStopOutcome [%d - OutcomeNoGoError_],lastSssdIdx [%d], --> ", OutcomeNoGoError_, TRL_LAST_SSD_IDX);
  }
  else
  {
    tempVar = random(N_SSD);
    printf("****STAIRCASE_SSD: **TRIAL NO = 1????***LastStopOutcome [**UNKNOWN**],lastSssdIdx [**UNKNOWN**]*****, random-");
  }

  if(tempVar < 0)
  {
    TRL_STOP_SIGNAL_DELAY_IDX = 0;
  }
  else if (tempVar >= N_SSD)
  {
    TRL_STOP_SIGNAL_DELAY_IDX = N_SSD - 1;
  }
  printf("trlSsdId [%d]\n",TRL_STOP_SIGNAL_DELAY_IDX);

  TRL_LAST_SSD_IDX = TRL_STOP_SIGNAL_DELAY_IDX;

}/* STAIRCASE_SSD */
