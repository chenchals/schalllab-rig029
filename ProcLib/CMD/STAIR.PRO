//==========================================================================
// STAIR.PRO
//   Description: Process to pick the STAIRCASE_NEXT_SSD_IDX for the stop trial.
//                It is assumed that the SSD_ARRY contains SSDs in *increasing* order.
//
//     Case0: If lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_CANCELLED_
//               Increase the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx + (random(stepUpMax) + 1)
//     Case1: If lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_NON_CANCELLED_
//               Decrease the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx - (random(stepDownMax) + 1)
//     Case2: If lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_ERROR_
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

  if (lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_CANCELLED_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx + random(stepUpMax) + 1;
    printf("****STAIRCASE_NEXT_SSD: LastStopOutcome [%d - EVT_OUTCOME_NOGO_CANCELLED_],lastSssdIdx [%d], --> ", EVT_OUTCOME_NOGO_CANCELLED_, lastSsdIdx);
  }
  else if (lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_NON_CANCELLED_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx - (random(stepDownMax) + 1);
    printf("****STAIRCASE_NEXT_SSD: LastStopOutcome [%d - EVT_OUTCOME_NOGO_NON_CANCELLED_],lastSssdIdx [%d], --> ", EVT_OUTCOME_NOGO_NON_CANCELLED_, lastSsdIdx);
  }
  else if (lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_ERROR_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx;
    printf("****STAIRCASE_NEXT_SSD: LastStopOutcome [%d - EVT_OUTCOME_NOGO_ERROR_],lastSssdIdx [%d], --> tempVar [%d] ", EVT_OUTCOME_NOGO_ERROR_, lastSsdIdx);
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
