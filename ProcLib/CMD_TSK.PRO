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
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_EYE.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_PD.PRO

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

process IDLE() enabled
{
	declare int tempVar;
	declare int trlNum;
  // ========== Call once =============
	spawnwait RIG_029();
	spawnwait SET_SCRN();
	spawnwait SET_CLR_PALETTE();
	spawnwait SET_DEFAULT_STIM_VARS();

  spawn QUE_EVT();
	spawn WATCH_EYE();
	spawn WATCH_PD();

	printf("ALLPROSC.PRO Running CMD_PGS()\n");
	spawnwait CMD_PGS(1);
	printf("DONE....!\n");
	printf("Showing pages....!\n");
	trlNum = 1;
	while(1)
	{
		CURR_TARGET_IDX = 0;
		while (CURR_TARGET_IDX < N_TARG_POS)
		{
			printf("Trial num %d, Target pos %d\n",trlNum,CURR_TARGET_IDX);
			spawnwait CMD_PGS();
			dsendf("vp %d\n",PG_FIXATION_PD);
			dsendf("VW %d\n", 2);
			dsendf("vp %d\n",PG_BLANK);
			dsendf("VW %d\n", 5);
			dsendf("vp %d\n",PG_TARGET_PD);
			dsendf("VW %d\n", 5);
			dsendf("vp %d\n",PG_SIGNAL_PD);
			dsendf("VW %d\n", 1);
			dsendf("vp %d\n",PG_BLANK);
			nexttick 1000;
			CURR_TARGET_IDX = CURR_TARGET_IDX + 1;
			trlNum = trlNum + 1;
		}
	}

}
