//==========================================================================
// STAIR.PRO
//   Description: Process to pick the STAIRCASE_NEXT_SSD_IDX for the stop trial.
//                It is assumed that the SSD_ARRY contains SSDs in *increasing* order.
//
//     Case0: If lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_CANCEL_
//               Increase the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx + (random(stepUpMax) + 1)
//     Case1: If lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_NON_CANCEL_
//               Decrease the SSD. STAIRCASE_NEXT_SSD_IDX =  lastSsdIdx - (random(stepDownMax) + 1)
//     Case2: If lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_ERR_
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
  if(DEBUG_CONSOLE)
  {
	printf("****STAIR.PRO/STAIRCASE_NEXT_SSD: lastStopOutcomeEvntCode [%d], lastSsdIdx [%d], stepUpMax [%d], stepDownMax [%d], nSSD [%d]",
		lastStopOutcomeEvntCode,lastSsdIdx,stepUpMax,stepDownMax,nSSD );
  }
  if (lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_CANCEL_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx + random(stepUpMax) + 1;
    printf("****STAIR.PRO/STAIRCASE_NEXT_SSD: LastStopOutcome [%d - EVT_OUTCOME_NOGO_CANCEL_],lastSssdIdx [%d], --> ", EVT_OUTCOME_NOGO_CANCEL_, lastSsdIdx);
  }
  else if (lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_NON_CANCEL_ || lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_NON_CANCEL_ERR_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx - (random(stepDownMax) + 1);
    printf("****STAIR.PRO/STAIRCASE_NEXT_SSD: LastStopOutcome [%d - EVT_OUTCOME_NOGO_NON_CANCEL_],lastSssdIdx [%d], --> ", EVT_OUTCOME_NOGO_NON_CANCEL_, lastSsdIdx);
  }
  else if (lastStopOutcomeEvntCode == EVT_OUTCOME_NOGO_ERR_)
  {
    STAIRCASE_NEXT_SSD_IDX = lastSsdIdx;
    printf("****STAIR.PRO/STAIRCASE_NEXT_SSD: LastStopOutcome [%d - EVT_OUTCOME_NOGO_ERR_],lastSssdIdx [%d], -->  ", EVT_OUTCOME_NOGO_ERR_, lastSsdIdx);
  }
  else
  {
    STAIRCASE_NEXT_SSD_IDX = random(nSSD);
    printf("****STAIR.PRO/STAIRCASE_NEXT_SSD: **TRIAL NO = 1????***LastStopOutcome [**UNKNOWN**],lastSssdIdx [**UNKNOWN**]*****, random- ");
	printf("++++++++++++++++++++ERROR IF APPEARS MORE THAN ONCE++++++++++++++++\n");
  }
  // Check limits
  if(STAIRCASE_NEXT_SSD_IDX <= 0)
  {
    STAIRCASE_NEXT_SSD_IDX = 0;
  }
  else if (STAIRCASE_NEXT_SSD_IDX >= nSSD)
  {
    STAIRCASE_NEXT_SSD_IDX = nSSD - 1;
  }

  printf("****STAIR.PRO/STAIRCASE_NEXT_SSD: STAIRCASE_NEXT_SSD [%d]\n",STAIRCASE_NEXT_SSD_IDX);

}/* STAIRCASE_NEXT_SSD */
