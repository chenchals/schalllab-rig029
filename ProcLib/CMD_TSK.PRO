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
#include C:/TEMPO/ProcLib/CLEAR_VDO.PRO
#include C:/TEMPO/ProcLib/CMD/SET_CMD.PRO
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/PRC_STAT.PRO

//==========================================================================

declare IDLE();

declare UPD8_MSG();
declare INCREMENT_TRL_TARG_VRT_RFRSH_COUNT();

declare int targVertRefreshCountTime;

declare int TEST = 100;
process IDLE() enabled
{
	// A temporary state acitivity
	declare int tempProcessState;
	// A flag for sending event only 1 time Ex. FixSpotOn (based on trigger)
	declare int sendEventOnce;
	declare int tempTrlNumber;
	declare int trlRunning;
	spawn CLEAR_VDO();
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
		spawnwait SET_CMD_TRL();
		tempProcessState = 0;
		TRL_CUM_TIME = 0;
		TRL_FIX_VRT_RFRSH_COUNT = 0;
		trlRunning = 1;
		printf("Trial running....\n");
		spawn SEND_EVT(TaskStart_);
		spawn SEND_EVT(CmanHeader_);
		spawn GRAF_HIDE_FIX_TARG();
		dsendf("vp %d\n", PG_BLANK);
		CURR_STAT = STAT_GET_READY;
		STAT_DLTA_T = 0;
		while (trlRunning)
		{		
			while(CURR_STAT == STAT_TEST)
			{
				printf("Eyes must be updating continuously...\n");
				CURR_STAT = STAT_IDLE;
				
				spawn GRAF_SHOW_FIX_WIN();
				//nexttick 5000;
				//CURR_STAT = STAT_GET_READY;
				//STAT_ALLOWED_T = READY_TIME*TIME_DILATE_FACTOR*10;
				//nexttick 5000;
				//CURR_STAT = STAT_FIX_ON;
				//STAT_ALLOWED_T = ALLOWED_FIX_TIME*TIME_DILATE_FACTOR*10;
				//spawn GRAF_SHOW_FIX(GRAF_SHOW);
				//nexttick 5000;
				//spawn GRAF_SHOW_FIX(GRAF_HIDE);

				trlRunning = 0;
				nexttick 10000;
			}

			//================= State = STAT_GET_READY===============
			if (CURR_STAT == STAT_GET_READY)
			{
				if (!tempProcessState)
				{
					sendEventOnce = 1;
					tempProcessState = 1;
					TRL_NUMBER     = TRL_NUMBER + 1;
					TRL_GET_READY_TIME = time();
					spawn SEND_EVT(TrialGetReady_);

					STAT_DLTA_T = 0;
					STAT_ALLOWED_T = READY_TIME*TIME_DILATE_FACTOR;
					spawn UPD8_MSG();
					spawn GRAF_SHOW_FIX_WIN();
				}
				STAT_DLTA_T = time() - TRL_GET_READY_TIME;				
				if (I_FIX || I_FIX_WIDE)
				{
					STAT_DLTA_T = 0;
				}
				if (STAT_DLTA_T >= STAT_ALLOWED_T)
				{
					tempProcessState = 0;
					spawn UPD8_MSG();
					TRL_READY_TIME = time();
					spawn SEND_EVT(TrialReady_);
					CURR_STAT = STAT_FIX_ON;
				}
			}
			//================= State = STAT_FIX_ON===============
			if (CURR_STAT == STAT_FIX_ON)
			{
				if (!tempProcessState) // First time showing fixspot on
				{
					sendEventOnce = 1;
					tempProcessState = 1;
					TRL_FIX_VRT_RFRSH_COUNT = 0;
					TRL_START_TIME = time();
					spawn SEND_EVT(TrialStart_);
					STAT_DLTA_T = 0;
					STAT_ALLOWED_T = ALLOWED_FIX_TIME*TIME_DILATE_FACTOR;
					spawn UPD8_MSG();
					dsendf("vp %d\n", PG_FIXATION_PD);
					spawn GRAF_SHOW_FIX(GRAF_SHOW);
				}
				STAT_DLTA_T = time() - TRL_START_TIME;
				if (PD_TRIG_L)
				{
					spawn UPD8_MSG();
					TRL_FIX_VRT_RFRSH_COUNT = TRL_FIX_VRT_RFRSH_COUNT + 1;
					printf("TRL_FIX_VRT_RFRSH_COUNT [%d]\n",TRL_FIX_VRT_RFRSH_COUNT);
					if(sendEventOnce)
					{
						// do not send event multiple times
						sendEventOnce = 0;
						TRL_FIX_ON_TIME = time();
						printf("Sending event FixSpotOn_\n");
						spawn SEND_EVT(FixSpotOn_);						
					}
					dsendf("vp %d\n", PG_FIXATION);
				}
				if (!I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
				{
					tempProcessState = 0;
					spawn UPD8_MSG();
					printf("****Fixation not acquired\n");
					//?send event abort_?
					CURR_STAT = STAT_IDLE;
					trlRunning = 0; // to go to next trial
				}
				if(I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T )
				{
					tempProcessState = 0;
					spawn UPD8_MSG();
					TRL_FIX_VRT_RFRSH_COUNT = 0;
					TRL_FIX_ACQ_TIME = time();
					spawn SEND_EVT(AcquireFix_);
					printf("****Fixation acquired\n");
					CURR_STAT = STAT_FIXATE;
				}
				
			}
			//================= State = STAT_FIXATE===============
			if (CURR_STAT == STAT_FIXATE)
			{
				if (!tempProcessState) // First time showing fixspot on
				{
					sendEventOnce = 1;
					tempProcessState = 1;
					spawn SEND_EVT(TrialStart_);
					STAT_DLTA_T = 0;
					STAT_ALLOWED_T = FIX_HOLD_TIME*TIME_DILATE_FACTOR;
					spawn UPD8_MSG();
				}
				STAT_DLTA_T = time() - TRL_FIX_ACQ_TIME;
				if (!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
				{
					tempProcessState = 0;
					spawn UPD8_MSG();
					printf("****Not fixated******\n");
					printf("Send.... event Abort_??\n");
					//?send event abort_?
					CURR_STAT = STAT_IDLE;
					trlRunning = 0; // to go to next trial
				}
				if(I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
				{
					tempProcessState = 0;
					spawn UPD8_MSG();
					TRL_FIXATED_TIME = time();
					printf("Sending event Fixate_\n");

					spawn SEND_EVT(Fixate_);
					printf("****Fixated\n");
					CURR_STAT = STAT_TARG_ON;
				}				
			}
			//================= State = STAT_TARG_ON===============
			//================= State = STAT_TARG_ON===============
			if (CURR_STAT == STAT_TARG_ON)
			{
				if(!tempProcessState)
				{
					sendEventOnce = 1;
					tempProcessState = 1;
					targVertRefreshCountTime = 0;
					TRL_TARG_VRT_RFRSH_COUNT = 0;
					TRL_PRE_TARG_ON_TIME = time();
					spawn SEND_EVT(TargetPre_);
					STAT_DLTA_T = 0;
					STAT_ALLOWED_T = MIN_MAX_SACCADE_TIME[0]*TIME_DILATE_FACTOR;
					spawn UPD8_MSG();
					dsendf("vp %d\n", PG_TARGET_PD);
					spawn GRAF_SHOW_FIX(GRAF_HIDE);
					spawn GRAF_SHOW_TARG(GRAF_SHOW);
				}
				STAT_DLTA_T = time() - TRL_PRE_TARG_ON_TIME;
				if (PD_TRIG_L)
				{
					spawn INCREMENT_TRL_TARG_VRT_RFRSH_COUNT();
					if(sendEventOnce)
					{
						// do not send event multiple times
						sendEventOnce = 0;
						TRL_TARG_ON_TIME = time();
						printf("Sending event Target_\n");
						spawn SEND_EVT(Target_);
						spawn SEND_EVT(FixSpotOff_);
					}
				}
				if(!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
				{
					// Early saccade
					tempProcessState = 0;
					spawn UPD8_MSG();
					TRL_SACCADE_TIME = time();
					spawn SEND_EVT(EarlySaccade_);
					printf("****Early Saccade\n");
					CURR_STAT = STAT_TARG_ACQ;
				}
				if(I_FIX && STAT_DLTA_T > STAT_ALLOWED_T)
				{
					// Ready for saccade...
					tempProcessState = 0;
					spawn UPD8_MSG();
					printf("****Fixated ready for saccade...\n");
					CURR_STAT = STAT_TARG_ACQ;
					dsendf("vp %d\n",PG_BLANK);
					nexttick 2000;
					trlRunning = 0;
				}
			}
			//================= State = STAT_TARG_FIXATE===============
			
			TRL_CUM_TIME = TRL_CUM_TIME + 1;
			nexttick;
		}/*while(trlRunning)*/
		nexttick;
	}/*while(1)*/
}/*IDLE()*/

process UPD8_MSG()
{
	printf("TRL_NUMUMBR [%d], TRL_CUM_TIME [%d], CURR_STAT [%d], STAT_DLTA_T [%d]\n", TRL_NUMBER, TRL_CUM_TIME,CURR_STAT,STAT_DLTA_T);
}

// Do not double count same trigger
process INCREMENT_TRL_TARG_VRT_RFRSH_COUNT()
{
	declare int trigWidth = 3;
	if (TRL_TARG_VRT_RFRSH_COUNT == 0)
	{
		TRL_TARG_VRT_RFRSH_COUNT = 1;
		spawn UPD8_MSG();
		printf("TRL_TARG_VRT_RFRSH_COUNT [%d]\n",TRL_TARG_VRT_RFRSH_COUNT);
	}
	else if ((STAT_DLTA_T - targVertRefreshCountTime) > trigWidth)
	{
		TRL_TARG_VRT_RFRSH_COUNT = TRL_TARG_VRT_RFRSH_COUNT + 1;
		spawn UPD8_MSG();
		printf("TRL_TARG_VRT_RFRSH_COUNT [%d]\n",TRL_TARG_VRT_RFRSH_COUNT);
	}
	targVertRefreshCountTime = STAT_DLTA_T;

}
