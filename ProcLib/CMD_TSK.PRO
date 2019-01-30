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
#include C:/TEMPO/ProcLib/CMD/STATES/PRC_STAT.PRO

//==========================================================================

declare IDLE();


process IDLE() enabled
{
	// A temporary state acitivity
	declare int tempProcessState;
	// A temporary counter
	declare int tempVar;
	declare int tempTrlNumber;
	declare int trlRunning;

	seed1(time());
	normal(1);

	// ========== Call once =============
	//RIG_ID = 29;
	//MONK_ID = JOULE_ID;
	printf("Setting SET_RIG\n");
	spawnwait SET_RIG(RIG_ID);
	printf("Setting SET_CLRS\n");
	spawnwait SET_CLRS();
	printf("Setting SET_DEFAULT_STIM_VARS\n");
	spawnwait SET_DEFAULT_STIM_VARS();
	printf("Setting monkID\n");
	spawnwait SET_MONK(MONK_ID);

	// Setup WATCHES
	printf("Setting QUE_TTL\n");
	spawn QUE_TTL();
	printf("Setting WTCH_EYE\n");
	spawn WTCH_EYE();
	printf("Setting WTCH_SCHMITT\n");
	spawn WTCH_SCHMITT();
	printf("Setting GRAPHS\n");
	spawn GRAPHS();

	CURR_STAT = STAT_IDLE;
	TRL_NUMBER = 0;
	printf("Setting SEND_EVT Room\n");
	spawn SEND_EVT(Identify_Room_);
	spawn SEND_EVT(RIG_ID);
	while (1)
	{
		//===============For each Trial=====================
		tempProcessState = 0;
		TRL_CUM_TIME = 0;
		TRL_FIX_VRT_RFRSH_COUNT = 0;
		trlRunning = 1;
		printf("Trial running....\n");
		spawn SEND_EVT(TaskStart_);
		spawn SEND_EVT(CmanHeader_);
		spawn GRAF_HIDE_FIX_TARG();
		dsendf("vp %d\n", PG_BLANK);
		TRL_GET_READY_TIME = time();
		spawn SEND_EVT(TrialGetReady_);
		CURR_STAT = STAT_GET_READY;
		STAT_DLTA_T = 0;
		while (trlRunning)
		{
			//================= State = STAT_GET_READY===============
			if (CURR_STAT == STAT_GET_READY)
			{
				if (!tempProcessState)
				{
					tempProcessState = 1;
					TRL_NUMBER     = TRL_NUMBER + 1;
					STAT_DLTA_T = 0;
					STAT_ALLOWED_T = READY_TIME*TIME_DILATE_FACTOR;
					printf("Trial TRL_NUMUMBR = %d, TRL_CUM_TIME = %d, CURR_STAT == STAT_GET_READY\n", TRL_NUMBER, TRL_CUM_TIME);
					spawn GRAF_SHOW_FIX_WIN();
					// Check of eyes are outside FIX_WIN_SIZE_LARGE
					printf("STAT_DLTA_T %d\n",STAT_DLTA_T);
				}
				STAT_DLTA_T = time() - TRL_GET_READY_TIME;				
				if (I_FIX || I_FIX_WIDE)
				{
					STAT_DLTA_T = 0;
					//STAT_DLTA_T = STAT_DLTA_T;
				}
				if (STAT_DLTA_T >= STAT_ALLOWED_T)
				{
					printf("Trial TRL_NUMUMBR = %d, TRL_CUM_TIME = %d, CURR_STAT == STAT_GET_READY [%d]\n", TRL_NUMBER, TRL_CUM_TIME, STAT_DLTA_T);
					TRL_READY_TIME = time();
					spawn SEND_EVT(TrialReady_);
					CURR_STAT = STAT_FIX_ON;
					tempProcessState = 0;
				}
			}
			//================= State = STAT_FIX_ON===============
			if (CURR_STAT == STAT_FIX_ON)
			{
				if (!tempProcessState) // First time showing fixspot on
				{
					tempProcessState = 1;
					tempVar = 0;
					TRL_START_TIME = time();
					spawn SEND_EVT(TrialStart_);
					STAT_DLTA_T = 0;
					STAT_ALLOWED_T = ALLOWED_FIX_TIME*TIME_DILATE_FACTOR;
					printf("Trial TRL_NUMUMBR = %d, TRL_CUM_TIME = %d, CURR_STAT == STAT_FIX_ON [%d]\n", TRL_NUMBER, TRL_CUM_TIME,STAT_DLTA_T);
					dsendf("vp %d\n", PG_FIXATION_PD);
					spawn GRAF_SHOW_FIX(GRAF_SHOW);
				}
				STAT_DLTA_T = time() - TRL_START_TIME;
				if (PD_TRIG_L)
				{
					printf("Trial TRL_NUMUMBR = %d, TRL_CUM_TIME = %d, CURR_STAT == STAT_FIX_ON [%d]\n", TRL_NUMBER, TRL_CUM_TIME,STAT_DLTA_T);

					TRL_FIX_VRT_RFRSH_COUNT = TRL_FIX_VRT_RFRSH_COUNT + 1;
					TRL_FIX_ON_TIME = time();
					spawn SEND_EVT(FixSpotOn_);
					dsendf("vp %d\n", PG_FIXATION);
				}
				if (!I_FIX && STAT_DLTA_T > STAT_ALLOWED_T)
				{
					// Not acquired fixation
					printf("Trial TRL_NUMUMBR = %d, TRL_CUM_TIME = %d, CURR_STAT == STAT_FIX_ON [%d]\n", TRL_NUMBER, TRL_CUM_TIME,STAT_DLTA_T);
					printf("Fixation not acquired\n");
					//?send event abort_?
					tempProcessState = 0;
					CURR_STAT = STAT_IDLE;
					trlRunning = 0; // to go to next trial
				}
				else if(I_FIX && STAT_DLTA_T < STAT_ALLOWED_T )
				{
					printf("*****************Next state --> fixate************\n");
					tempProcessState = 0;
					TRL_FIX_VRT_RFRSH_COUNT = 0;
					printf("Trial TRL_NUMUMBR = %d, TRL_CUM_TIME = %d, CURR_STAT == STAT_FIX_ON [%d]\n", TRL_NUMBER, TRL_CUM_TIME,STAT_DLTA_T);
					CURR_STAT = STAT_IDLE;
					trlRunning = 0; // to go to next trial
				}
			}
			//================= State = STAT_FIXATE===============
			TRL_CUM_TIME = TRL_CUM_TIME + 1;
			nexttick;
		}/*while(trlRunning)*/
		nexttick;
	}/*while(1)*/
}/*IDLE()*/
