//==========================================================================
// CMD_TSK.PRO
//   Description[%d]: Loads all PRO files for CMD task
//   Author[%d]: chenchal.subraveti@vanderbilt.edu
//   Date[%d]: 2019-01-14
//==========================================================================
//  Revision History:
//
//==========================================================================
// Use variables on the fly - no declaration
#pragma declare = 1
#include C:/TEMPO/ProcLib/CLEAR_VDO.PRO
#include C:/TEMPO/ProcLib/CMD/SET_CMD.PRO
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO
// State flow
#include C:/TEMPO/ProcLib/CMD/STATES/GET_REDY.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/FIX_ON.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/FIX_HOLD.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_VR.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_ON.PRO
#include C:/TEMPO/ProcLib/CMD/STATES/TARG_HLD.PRO

//==========================================================================

declare IDLE();

declare UPD8_MSG();

declare TONE(int freq, int duration);
declare TONESWEP();
declare JUICE(int channel, int duration);

declare int TEST = 100;

process IDLE() enabled
{
	declare int tempTrlNumber;

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
	printf("Setting GRAPHS\n");
	spawn GRAPHS();

	printf("Setting QUE_TTL\n");
	spawn QUE_TTL();

	printf("Setting WTCH_EYE\n");
	spawn WTCH_EYE();

	printf("Setting WTCH_SCHMITT\n");
	spawn WTCH_SCHMITT();

	CURR_STAT  = STAT_IDLE;
	TRL_NUMBER = 0;
	printf("Sending Identify_Room_\n");
	spawn SEND_EVT(Identify_Room_);
	printf("Sending RIG_ID\n");
	spawn SEND_EVT(RIG_ID);

	while (1)
	{
		//===============For each Trial=====================
		printf("Setting TRIAL variables\n");
		spawnwait SET_CMD_TRL();
		printf("Done Setting TRIAL variables\n");

		PROCESS_STATE            = 1;
		TRL_CUM_TIME             = 0;
		TRL_FIX_VRT_RFRSH_COUNT  = 0;
		TRL_TARG_VRT_RFRSH_COUNT = 0;
		TRL_RUNNING              = 1;
		printf("Trial running....\n");
		spawn SEND_EVT(TaskStart_);

		spawn SEND_EVT(CmanHeader_);
		spawn GRAF_HIDE_FIX_TARG();
		
		printf("Sending BLANK page\n");
		dsendf("vp %d\n", PG_BLANK);
		CURR_STAT   = STAT_GET_READY;
		STAT_DLTA_T = 0;
		CURR_STAT=STAT_TEST;
		while (TRL_RUNNING)
		{
			while (CURR_STAT == STAT_TEST)
			{
				CURR_STAT = STAT_TEST;
				/*
				printf("SUCCESS_TONE_BIG_REWARD [%d]\n",SUCCESS_TONE_BIG_REWARD);
                spawnwait TONE(SUCCESS_TONE_BIG_REWARD,TONE_DURATION);
				nexttick 1000;
				printf("SUCCESS_TONE_MED_REWARD [%d]\n",SUCCESS_TONE_MED_REWARD);
                spawnwait TONE(SUCCESS_TONE_MED_REWARD,TONE_DURATION);
				nexttick 1000;
				printf("SUCCESS_TONE_SML_REWARD [%d]\n",SUCCESS_TONE_SML_REWARD);
                spawnwait TONE(SUCCESS_TONE_SML_REWARD,TONE_DURATION);
				nexttick 1000;
				printf("Doing TONESWEP()\n");
				spawnwait TONESWEP();
				nexttick 1000;
				*/
				printf("Giving JUICE\n");
				spawnwait JUICE(JUICE_CHANNEL,BASE_REWARD_TIME+100);
				nexttick 1000;
				//nexttick 5000;
				//CURR_STAT = STAT_GET_READY;
				//STAT_ALLOWED_T = READY_TIME*TIME_DILATE_FACTOR*10;
				//nexttick 5000;
				//CURR_STAT = STAT_FIX_ON;
				//STAT_ALLOWED_T = ALLOWED_FIX_TIME*TIME_DILATE_FACTOR*10;
				//spawn GRAF_SHOW_FIX(GRAF_SHOW);
				//nexttick 5000;
				//spawn GRAF_SHOW_FIX(GRAF_HIDE);

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
			//================= State = STAT_FIXATE===============
			if (CURR_STAT == STAT_FIXATE)
			{
				spawnwait PROC_FIX_HOLD();
			}
			//================= State = STAT_TARG_ON===============
			if (CURR_STAT == STAT_TARG_ON)
			{
				spawnwait PROC_TARG_ON();
			}
			//================= State = STAT_TARG_ACQ===============
			//================= State = STAT_TARG_FIXATE===============
			if (CURR_STAT == STAT_TARG_FIXATE)
			{
				spawnwait PROC_TARG_HOLD();
			}
			//================= State = STAT_FEEDBACK===============
			if (CURR_STAT == STAT_FEEDBACK)
			{
				dsendf("vp %d\n", PG_BLANK);
				printf(">>>>>>>>>>STAT_FEEDBACK:..... NOT YET... NOT YET....>>>>>>>>>>\n");
				printf(">>>>>>>>>>GOING TO NEXT TRIAL AFTER 2000 MS>>>>>>>>>>\n");
				nexttick 2000;
				TRL_RUNNING = 0;
			}
			//================= State = xxxxxx===============
			if (IS_TARG_ON_FLAG)
			{
				TRL_TARG_ON_DURATION = TRL_TARG_ON_DURATION + 1;
			}
			STAT_DLTA_T  = STAT_DLTA_T + 1;
			TRL_CUM_TIME = TRL_CUM_TIME + 1;
			nexttick;
		} /*while(TRL_RUNNING)*/
		nexttick;
	}     /*while(1)*/
}         /*IDLE()*/


process UPD8_MSG()
{
	declare int dummy = 0;

	dummy = 1;
	printf("TRL_NUM [%d], TRL_CUM_TIME [%d], CURR_STAT [%d], STAT_DLTA_T [%d]\n", TRL_NUMBER, TRL_CUM_TIME, CURR_STAT, STAT_DLTA_T);
}

//------------------------------------------------------------------------
// process Tone(int frequency, int duration)
// Play a tone for the specified frequency and duration
// INPUT
//	 frequency = frequency of tone (hz) to be played
//	 duration  = amount of time (in ms) to pay tone
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

//declare TONE(int frequency, int duration);

process TONE(int frequency, int duration)
	{
	declare hide count;			// Count down for the pulse generator to change state (see below)
	declare hide int off = 0;	// To turn tone off at end
	
	/*  A call to the PCI-DAS-1602 analog pulse generator is in the 
		form of...
		mio_fout(count) 
		where "count" specifies a count down in 10 MHz clock cycles 
		before the square wave switches states.
		Converting that to frequency is done by...
		frequency(Hz) = 10,000,000 / count
		therefore...
		count = 10,000,000 / frequency(Hz)
	*/
	count = 10000000/frequency; // See above
	//sound(frequency);
	mio_fout(count);			// Start sending the tone
	wait(duration);				// Wait for user defined period of time (ms)
	//sound(0);
	mio_fout(off);				// Stop sending the tone
	}
//declare TONESWEP();

process TONESWEP()
	{
	spawnwait TONE(64000,10);
	
	spawnwait TONE(32000,10);
	
	spawnwait TONE(16000,10);
	
	spawnwait TONE(8000,10);
	
	spawnwait TONE(4000,10);
	
	spawnwait TONE(2000,10);
	
	spawnwait TONE(1000,10);
	
	spawnwait TONE(500,10);
	
	spawnwait TONE(250,10);	
	}
	
//------------------------------------------------------------------------
// process JUICE(int channel, int duration)
// Deliver a juice reward to the animal
// INPUT
//	 channel  = rig specific TTL channel connected to solenoid (channel 9 in 028)
//	 duration = amount of time (in ms) to leave solenoid open
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

//declare JUICE(int channel, int duration);

process JUICE(int channel, int duration)
	{
	declare hide int open   = 1;	
	declare hide int closed = 0;	
	
	spawn SEND_EVT(JuiceStart_);
	
	mio_dig_set(channel,open);		// Start sending the TTL
	wait(duration);					// Wait for user defined period of time (ms)
	mio_dig_set(channel,closed);	// Stop sending the TTL
	
	spawn SEND_EVT(JuiceEnd_);
	}