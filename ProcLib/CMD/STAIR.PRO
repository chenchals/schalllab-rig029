//==========================================================================
// STAIR.PRO
//   Description: Process to pick the STAIRCASE_NEXT_SSD_IDX for the stop trial.
//                It is assumed that the SSD_ARRY contains SSDs in *increasing* order.
//
//     Case0: If lastStopOutcomeEvntCode == OutcomeNoGoCancelled_
//               Increase the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx + (random(stepUpMax) + 1)
//     Case1: If lastStopOutcomeEvntCode == OutcomeNoGoNonCancelled_
//               Decrease the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx - (random(stepDownMax) + 1)
//     Case2: If lastStopOutcomeEvntCode == OutcomeNoGoError_
//               Repeat the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx
//
//   Author: steven.errington@vanderbilt.edu
//   Date: 2014-01
//==========================================================================

declare STAIRCASE_NEXT_SSD(int lastStopOutcomeEvntCode, int lastSsdIdx, int stepUpMax, int stepDownMax, int nSSD);

declare int STAIRCASE_NEXT_SSD_IDX;

process STAIRCASE_NEXT_SSD(int lastStopOutcomeEvntCode, int lastSsdIdx, int stepUpMax, int stepDownMax, int nSSD)
{
  // nSSDs should have been set here : see SET_CMD.PRO/PICK_TRL_SSD
  declare int tempVar;

  if (lastStopOutcomeEvntCode == OutcomeNoGoCancelled_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx + random(stepUpMax) + 1;
    printf("****STAIRCASE_NEXT_SSD: LastStopOutcome [%d - OutcomeNoGoCancelled_],lastSssdIdx [%d], --> ", OutcomeNoGoCancelled_, lastSsdIdx);
  }
  else if (lastStopOutcomeEvntCode == OutcomeNoGoNonCancelled_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx - (random(stepDownMax) + 1);
    printf("****STAIRCASE_NEXT_SSD: LastStopOutcome [%d - OutcomeNoGoNonCancelled_],lastSssdIdx [%d], --> ", OutcomeNoGoNonCancelled_, lastSsdIdx);
  }
  else if (lastStopOutcomeEvntCode == OutcomeNoGoError_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx;
    printf("****STAIRCASE_NEXT_SSD: LastStopOutcome [%d - OutcomeNoGoError_],lastSssdIdx [%d], --> tempVar [%d] ", OutcomeNoGoError_, lastSsdIdx);
  }
  else
  {
    STAIRCASE_NEXT_SSD_IDX = random(nSSD);
    printf("****STAIRCASE_NEXT_SSD: **TRIAL NO = 1????***LastStopOutcome [**UNKNOWN**],lastSssdIdx [**UNKNOWN**]*****, random-");
	printf("++++++++++++++++++++ERROR IF APPEARS MORE THAN ONCE++++++++++++++++\n");
  }
  // Check limits
  if(STAIRCASE_NEXT_SSD_IDX < 0)
  {
    STAIRCASE_NEXT_SSD_IDX = 0;
  }
  else if (STAIRCASE_NEXT_SSD_IDX >= nSSD)
  {
    STAIRCASE_NEXT_SSD_IDX = nSSD - 1;
  }

  printf("staircaseSsdIdx [%d]\n",STAIRCASE_NEXT_SSD_IDX);

}/* STAIRCASE_NEXT_SSD */
