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
#include C:/TEMPO/ProcLib/UTIL/TONE.PRO
#include C:/TEMPO/ProcLib/UTIL/JUICE.PRO

// State flow
#include C:/TEMPO/ProcLib/CMD/STATES/GET_REDY.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/FIX_ON.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/FIX_HOLD.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_VR.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_ON.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_SSD.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_ACQ.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TONE_CHK.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TONE_SSD.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/RWRD_CHK.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/RWRD_SSD.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/OUTCOME.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/ITI_CHK.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TIME_OUT.PRO
//==========================================================================
declare IDLE();
declare UPD8_MSG();
declare WRITE_TO_FILE();

declare int WRITE_TO_FILE_FLAG = 1;
declare int WROTE_HEADER = 0;
declare int TEST = 100;
declare int SHOW_PAGES = 0;

process IDLE() enabled
{
	declare int tempCount;

	spawn CLEAR_VDO();

	seed1(time());
	// activate seed by drawing a number from some distribution
	random(5);

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
	printf("Setting GRAPHS\n");
	spawn GRAPHS();

	printf("Setting QUE_TTL\n");
	spawn QUE_TTL();

	printf("Setting WTCH_EYE\n");
	spawn WTCH_EYE();

	printf("Setting WTCH_SCHMITT\n");
	spawn WTCH_SCHMITT();

	printf("Sending Identify_Room_\n");
	spawn SEND_EVT(Identify_Room_);

	printf("Sending RIG_ID\n");
	spawn SEND_EVT(RIG_ID);
	while (1)
	{
		//===============For each Trial=====================
		printf("=============Setting TRIAL variables\n==================");
		spawnwait SET_CMD_TRL();
		printf("Done Setting TRIAL variables\n");
        if (SHOW_PAGES)
		{
			TRL_RUNNING = 0;
			printf("Showing Virtual Pages for COUNTERMANDING TASK\n");
			tempCount = 0;
			while (tempCount <= PG_MAX_PAGE_IDX)
			{
				dsendf("vp %d\n", tempCount);
				tempCount = tempCount + 1;
				nexttick 1000;
			}
			dsendf("vp %d\n", 0);
			printf("****Done showing Virtual Pages for COUNTERMANDING TASK\n\n");
		}
		else
		{
			PROCESS_STATE = 1;
			TRL_RUNNING   = 1;
			printf("Trial running....\n");
			spawn SEND_EVT(TaskStart_);

			spawn SEND_EVT(CmanHeader_);

			//spawn GRAF_HIDE_FIX_TARG();

			printf("Sending BLANK page\n");
			dsendf("vp %d\n", PG_BLANK);
			CURR_STAT   = STAT_GET_READY;
			STAT_DLTA_T = 0;
		}
		//CURR_STAT=STAT_TEST;
		while (TRL_RUNNING)
		{
			while (CURR_STAT == STAT_TEST)
			{
				CURR_STAT = STAT_TEST;
				/*
				* printf("SUCCESS_TONE_BIG_REWARD [%d]\n",SUCCESS_TONE_BIG_REWARD);
				* spawnwait TONE(SUCCESS_TONE_BIG_REWARD,TONE_DURATION);
				* nexttick 1000;
				* printf("SUCCESS_TONE_MED_REWARD [%d]\n",SUCCESS_TONE_MED_REWARD);
				* spawnwait TONE(SUCCESS_TONE_MED_REWARD,TONE_DURATION);
				* nexttick 1000;
				* printf("SUCCESS_TONE_SML_REWARD [%d]\n",SUCCESS_TONE_SML_REWARD);
				* spawnwait TONE(SUCCESS_TONE_SML_REWARD,TONE_DURATION);
				* nexttick 1000;
				* printf("Doing TONESWEP()\n");
				* spawnwait TONESWEP();
				* nexttick 1000;
				*/
				//printf("Giving JUICE\n");
				//spawnwait JUICE(JUICE_CHANNEL, TRL_RWRD_DURATION + 100);

				//nexttick 1000;
				//nexttick 5000;
				//CURR_STAT = STAT_GET_READY;
				//STAT_ALLOWED_T = READY_TIME*TIME_DILATE_FACTOR*10;
				//nexttick 5000;
				//CURR_STAT = STAT_FIX_ON;
				//STAT_ALLOWED_T = ALLOWED_FIX_TIME*TIME_DILATE_FACTOR*10;
				//spawn GRAF_SHOW_FIX(GRAF_SHOW);
				//nexttick 5000;
				//spawn GRAF_SHOW_FIX(GRAF_HIDE);

				dsendf("vp %d\n",PG_TARGET_PD);
				nexttick 64;
				dsendf("vp %d\n",PG_SIGNAL_PD);
				dsendf("vw 1\n");
				nexttick 4;
				dsendf("vp %d\n",PG_BLANK);

				TRL_RUNNING = 0;
				nexttick 1000;
			}

			//================= State = STAT_GET_READY===============
			if (CURR_STAT == STAT_GET_READY)
			{
				spawnwait PROC_GET_REDY();
			}
			//================= State = STAT_FIX_ON===============
			if (CURR_STAT == STAT_FIX_ON)
			{
				spawnwait PROC_FIX_ON();
			}
			//================= State = STAT_FIX_HOLD===============
			if (CURR_STAT == STAT_FIX_HOLD)
			{
				spawnwait PROC_FIX_HOLD();
			}
			//================= State = STAT_TARG_ON===============
			if (CURR_STAT == STAT_TARG_ON)
			{
				if(TRIAL_TYPE == TRIAL_TYPE_STOP)
				{
					CURR_STAT = STAT_TARG_SSD;
					spawnwait PROC_TARG_SSD();
				}
				else
				{
					spawnwait PROC_TARG_ON();
				}
			}
			if (CURR_STAT == STAT_TARG_SSD)
			{
				spawnwait PROC_TARG_SSD();
			}
			//================= State = STAT_TARG_ACQ===============
			if (CURR_STAT == STAT_TARG_ACQ)
			{
				spawnwait PROC_TARG_ACQ();
			}
			//================= State = STAT_TONE_CHK===============
			if (CURR_STAT == STAT_TONE_CHK)
			{
				spawnwait PROC_TONE_CHK();
			}
			//================= State = STAT_RWRD_CHK===============
			if (CURR_STAT == STAT_RWRD_CHK)
			{
				spawnwait PROC_RWRD_CHK();
			}
			//================= State = STAT_TONE_SSD===============
			if (CURR_STAT == STAT_TONE_SSD)
			{
				spawnwait PROC_TONE_SSD();
			}
			//================= State = STAT_RWRD_SSD===============
			if (CURR_STAT == STAT_RWRD_SSD)
			{
				spawnwait PROC_RWRD_SSD();
			}
			//================= State = STAT_OUTCOME===============
			if (CURR_STAT == STAT_OUTCOME)
			{
				spawnwait PROC_TRL_OUTCOME();
			}
			//================= State = STAT_ITI_CHK===============
			if (CURR_STAT == STAT_ITI_CHK)
			{
				spawnwait PROC_ITI_CHK();
			}
			//================= State = STAT_TIM_OUT===============
			if (CURR_STAT == STAT_TIM_OUT)
			{
				spawnwait PROC_TIMEOUT_CHK();
			}
			if(CURR_STAT == STAT_IDLE)
			{
				spawn SEND_EVT(TaskEnd_);
				printf("****CMD_TSK: OK (Ending Task) sent Event: TaskEnd_[%d]\n", TaskEnd_);
				printf("****CMD_TSK: OK (Ending Task) TRL_NUMBER [%d], TRL_CUM_TIME[%d]\n", TRL_NUMBER, TRL_CUM_TIME);
				TRL_RUNNING = 0;
				PROCESS_STATE = 0;
			}
			//================= State = xxxxxx===============
			if (TRL_IS_TARG_ON_FLAG)
			{
				TRL_TARG_ON_DURATION = TRL_TARG_ON_DURATION + 1;
			}
			STAT_DLTA_T  = STAT_DLTA_T + 1;
			if(TRL_START_TIME)
			{
				TRL_CUM_TIME = TRL_CUM_TIME + 1;
			}
			nexttick;
		} /*while(TRL_RUNNING)*/
		spawnwait WRITE_TO_FILE();
		printf("============================NEXT TRIAL========================\n");
		nexttick;
	}     /*while(1)*/
} /*IDLE()*/


process UPD8_MSG()
{
	declare int dummy = 0;

	dummy = 1;
	printf("TRL_NUM [%d], TRL_CUM_TIME [%d], CURR_STAT [%d], STAT_DLTA_T [%d]\n", TRL_NUMBER, TRL_CUM_TIME, CURR_STAT, STAT_DLTA_T);
}

process WRITE_TO_FILE()
{
	if(WRITE_TO_FILE_FLAG)
	{
		printf("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",TRL_NUMBER,TRL_STOP_SIGNAL_DELAY,TRL_TARG_SSD_VRT_RFRSH_COUNT,TRL_TARG_ON_TIME,
		       TRL_STOP_SIGNAL_TIME,TRL_STOP_SIGNAL_DURATION, TRL_FIX_ON_TIME, TRL_FIX_ACQ_TIME, TRL_FIX_HOLD_TIME, TRL_FIX_HOLD_DURATION);
		if(!WROTE_HEADER)
		{
			writef("stopSig.csv TRL_NUMBER,TRL_STOP_SIGNAL_DELAY,TRL_TARG_SSD_VRT_RFRSH_COUNT,TRL_TARG_ON_TIME,");
			writef("stopSig.csv TRL_STOP_SIGNAL_TIME,TRL_STOP_SIGNAL_DURATION,TRL_FIX_ON_TIME,TRL_FIX_ACQ_TIME,TRL_FIX_HOLD_TIME,TRL_FIX_HOLD_DURATION\n");
			WROTE_HEADER = 1;
		}
		writef("stopSig.csv %d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",TRL_NUMBER,TRL_STOP_SIGNAL_DELAY,TRL_TARG_SSD_VRT_RFRSH_COUNT,TRL_TARG_ON_TIME,
		      TRL_STOP_SIGNAL_TIME,TRL_STOP_SIGNAL_DURATION,TRL_FIX_ON_TIME,TRL_FIX_ACQ_TIME,TRL_FIX_HOLD_TIME,TRL_FIX_HOLD_DURATION);
	}
}
