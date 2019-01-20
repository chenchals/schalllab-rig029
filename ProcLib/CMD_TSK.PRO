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
// Setup all Variables
#include C:/TEMPO/PROCLIB/VAR/SET_VARS.PRO;
// Room variables: screen, isoluminant colors, data channels
#include C:/TEMPO/ProcLib/RIG/RIG_029.PRO
// Screen parameters
#include C:/TEMPO/ProcLib/RIG/SET_SCRN.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/RIG/SET_CLRS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
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
	printf("ALLPROSC.PRO Running IDLE()\n");
	printf("ALLPROSC.PRO Running RIG_029()\n");
	spawnwait SETUP_029();
	printf("ALLPROSC.PRO Running SET_SCRN()\n");
	spawnwait SET_SCRN();
	printf("ALLPROSC.PRO Running SET_DEFAULT_STIM_VARS()\n");
	spawnwait SET_DEFAULT_STIM_VARS();
	printf("ALLPROSC.PRO Running SET_CLR_PALETTE()\n");
	spawnwait SET_CLR_PALETTE();
	printf("ALLPROSC.PRO Running CMD_PGS()\n");
	spawnwait CMD_PGS(1);
	printf("DONE....!\n");
	printf("Showing pages....!\n");
	trlNum = 1;
	while(1)
	{
		tempVar = 0;
		while (tempVar < N_TARG_POS)
		{
			printf("Trial num %d, Target pos %d\n",trlNum,tempVar);
			spawnwait CMD_PGS(tempVar);
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
			tempVar = tempVar + 1;
			trlNum = trlNum + 1;
		}
	}

}
