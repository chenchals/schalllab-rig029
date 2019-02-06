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

//==========================================================================

declare IDLE();

declare UPD8_MSG();
declare CHECK_TARG_ACQUIRED();
declare CHECK_TARG_VERT_RFRSH();


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
	printf("Setting SEND_EVT Room\n");
	spawn SEND_EVT(Identify_Room_);
	spawn SEND_EVT(RIG_ID);

	while (1)
	{
		//===============For each Trial=====================
		spawnwait SET_CMD_TRL();

		PROCESS_STATE           = 1;
		TRL_CUM_TIME            = 0;
		TRL_FIX_VRT_RFRSH_COUNT = 0;
		TRL_TARG_VRT_RFRSH_COUNT = 0;
		TRL_RUNNING             = 1;
		printf("Trial running....\n");
		spawn SEND_EVT(TaskStart_);
		
		spawn SEND_EVT(CmanHeader_);
		spawn GRAF_HIDE_FIX_TARG();

		dsendf("vp %d\n", PG_BLANK);
		CURR_STAT   = STAT_GET_READY;
		STAT_DLTA_T = 0;
		while (TRL_RUNNING)
		{
			while (CURR_STAT == STAT_TEST)
			{
				printf("Eyes must be updating continuously...\n");

				spawn GRAF_SHOW_FIX_WIN();

				CURR_STAT = STAT_IDLE;

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
				nexttick 10000;
			}

			//================= State = STAT_GET_READY===============
			if (CURR_STAT == STAT_GET_READY)
			{
				spawnwait PROC_GET_REDY();
			}
			//================= State = STAT_FIX_ON===============
			if (CURR_STAT == STAT_FIX_ON)
			{
				if (PROCESS_STATE)
				{
					TRL_FIX_VRT_RFRSH_COUNT = 0;
					TRL_START_TIME          = time();
					spawn SEND_EVT(TrialStart_);

					dsendf("vp %d\n", PG_FIXATION_PD);
					dsendf("vw 1\n");
					spawn GRAF_SHOW_FIX(GRAF_SHOW);

					printf("****STAT_FIX_ON[%d]: OK (Trial Started)\n", STAT_FIX_ON);
					spawn UPD8_MSG();

					PROCESS_STATE  = 0;
					STAT_STRT_T    = TRL_START_TIME;
					STAT_DLTA_T    = 0;
					STAT_ALLOWED_T = ALLOWED_FIX_TIME * TIME_DILATE_FACTOR;
				}

				if (PD_TRIG_L)
				{
					TRL_FIX_VRT_RFRSH_COUNT = TRL_FIX_VRT_RFRSH_COUNT + 1;
					if (TRL_FIX_VRT_RFRSH_COUNT == 1 && !TRL_FIX_ON_TIME)
					{
						// do not send event multiple times
						TRL_FIX_ON_TIME = time();
						spawn SEND_EVT(FixSpotOn_);

						dsendf("vp %d\n", PG_FIXATION);

						printf("****STAT_FIX_ON[%d]: OK (FixSpotOn_)\n", STAT_FIX_ON);
						spawn UPD8_MSG();
					}
				}
				if (!I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
				{
					//?send event abort_?
					//TRL_FIX_ON_TIME = time();???
					spawn SEND_EVT(FixNotAcquired_);

					spawn UPD8_MSG();

					printf("****STAT_FIX_ON:ERR (Fixation not acquired); Within: ALLOWED_FIX_TIME\n", STAT_FIX_ON);

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FEEDBACK;
				}
				else if (I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
				{
					TRL_FIX_ACQ_TIME = time();
					spawn SEND_EVT(AcquireFix_);

					spawn UPD8_MSG();

					printf("****STAT_FIX_ON[%d]: OK (Fixation acquired); Within: ALLOWED_FIX_TIME\n", STAT_FIX_ON);

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FIXATE;
				}
			}
			//================= State = STAT_FIXATE===============
			if (CURR_STAT == STAT_FIXATE)
			{
				if (PROCESS_STATE)
				{
					printf("****STAT_FIXATE[%d]: OK (Check for hold fixation)\n", STAT_FIXATE);
					spawn UPD8_MSG();

					// actually TRL_FIX_ACQ_TIME, however the below is practically
					//same and it keeps this state independent of previous state
					PROCESS_STATE  = 0;
					STAT_STRT_T    = time();
					STAT_DLTA_T    = 0;
					STAT_ALLOWED_T = FIX_HOLD_TIME * TIME_DILATE_FACTOR;
				}

				if (!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
				{
					TRL_BREAK_FIX_TIME = time();
					spawn SEND_EVT(BreakFix_);

					printf("****STAT_FIXATE[%d]:ERR (Broke fixation); Within: FIX_HOLD_TIME\n", STAT_FIXATE);
					spawn UPD8_MSG();

					//?send event abort_?
					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FEEDBACK;                                                                                                                                          // to go to next trial
				}
				if (I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
				{
					TRL_FIXATED_TIME = time();
					spawn SEND_EVT(Fixate_);

					printf("****STAT_FIXATE[%d]: OK (Fixated); Expired:FIX_HOLD_TIME\n", STAT_FIXATE);
					spawn UPD8_MSG();

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_TARG_ON;
				}
			}
			//================= State = STAT_TARG_ON===============
			if (CURR_STAT == STAT_TARG_ON)
			{
				if (PROCESS_STATE)
				{
					I_IN_FLIGHT              = 0;
					TARG_VR_COUNT_TIME       = 0;
					TRL_TARG_VRT_RFRSH_COUNT = 0;
					TRL_TARG_ON_DURATION     = 0;
					IS_TARG_ON_FLAG          = 0;
					IS_TARG_ACQUIRED         = 0;
					TRL_ERLY_SACC_TIME       = 0;
					TRL_PRE_TARG_ON_TIME     = time();
					spawn SEND_EVT(TargetPre_);

					dsendf("vp %d\n", PG_TARGET_PD);
					spawn GRAF_SHOW_FIX(GRAF_HIDE);
					spawn GRAF_SHOW_TARG(GRAF_SHOW);

					printf("****STAT_TARG_ON[%d]: OK (Processing Target On); Within: MIN_SACCADE_TIME\n", STAT_TARG_ON);
					spawn UPD8_MSG();

					PROCESS_STATE  = 0;

					STAT_STRT_T    = TRL_PRE_TARG_ON_TIME;
					STAT_DLTA_T    = 0;
					STAT_ALLOWED_T = MIN_MAX_SACCADE_TIME[0] * TIME_DILATE_FACTOR;
				}

				spawnwait CHECK_TARG_VERT_RFRSH();
				if (TRL_TARG_VRT_RFRSH_COUNT == 1 && !TRL_TARG_ON_TIME)
				{
					TRL_TARG_ON_TIME = time();
					printf("Sending event Target_\n");
					spawn SEND_EVT(Target_);
					spawn SEND_EVT(FixSpotOff_);
				}

				if (!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
				{
					// Early saccade
					I_IN_FLIGHT        = 1;
					TRL_ERLY_SACC_TIME = time();
					spawn SEND_EVT(EarlySaccade_);

					printf("****STAT_TARG_ON[%d]: OK? (*Early Saccade*); Within: MIN_SACCADE_TIME\n", STAT_TARG_ON);
					spawn UPD8_MSG();

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_TARG_ACQ;
				}
				if (I_FIX && STAT_DLTA_T > STAT_ALLOWED_T)
				{
					I_IN_FLIGHT = 0;

					printf("****STAT_TARG_ON[%d]: OK (No Saccade); Expired:MIN_SACCADE_TIME\n", STAT_TARG_ON);
					spawn UPD8_MSG();

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_TARG_ACQ;
				}
			}
			//================= State = STAT_TARG_ACQ===============
			if (CURR_STAT == STAT_TARG_ACQ)
			{
				// Target not yet acquired
				if (PROCESS_STATE)
				{
					printf("****STAT_TARG_ACQ[%d]: OK (Processing target acquisition); Within: MAX_SACCADE_TIME, MAX_SACC_DURATION\n", STAT_TARG_ACQ);
					spawn UPD8_MSG();
					PROCESS_STATE = 0;
					s// Keep independent of previous state times if any.
					STAT_STRT_T       = time();
					STAT_DLTA_T       = 0;
					TRL_SACC_DURATION = 0;
					// MIN_SACC_TIME accounted for in TARG_ON
					// remaining time = difference between MIN and MAX sacc time
					STAT_ALLOWED_T = (MIN_MAX_SACCADE_TIME[1] - MIN_MAX_SACCADE_TIME[0]) * TIME_DILATE_FACTOR;
					// Extra variable needed for saccade duration
					STAT_I_MOVE_DURATION = MAX_SACCADE_DURATION * TIME_DILATE_FACTOR;
				}

				spawnwait CHECK_TARG_VERT_RFRSH();
				if (STAT_DLTA_T <= STAT_ALLOWED_T )
				{
					if (I_IN_FLIGHT && !IS_TARG_ACQUIRED)
					{
						// Eye already out of Fix window
						spawnwait CHECK_TARG_ACQUIRED();
					}
					else if (!I_IN_FLIGHT && !I_FIX)
					{
						// Trigger I_IN_FLIGHT to check targ acquisition
						I_IN_FLIGHT       = 1;
						TRL_SACC_DURATION = 0;
						// do not send event multiple times
						TRL_SACC_TIME = time();
						spawn SEND_EVT(Saccade_);
						printf("****STAT_TARG_ACQ[%d]: OK (Correct Saccade)); Within: MAX_SACCADE_TIME\n", STAT_TARG_ACQ);
						spawn UPD8_MSG();
					}
				}
				else if (I_FIX && STAT_DLTA_T > STAT_ALLOWED_T)
				{
					// Eye not in flight
					I_IN_FLIGHT = 0;
					IS_TARG_ACQUIRED = 0;
					TRL_SACC_DURATION = 0;
					// still fixating after max-sacc-time
					// check if it is Late target aquire
					// or Error no saccade for Go trial;
					printf("****STAT_TARG_ACQ[%d]: OK? (No Saccade)); After: MAX_SACCADE_TIME\n", STAT_TARG_ACQ);
					spawn UPD8_MSG();

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FEEDBACK;
				}
			}
			//================= State = STAT_TARG_FIXATE===============
			if (CURR_STAT == STAT_TARG_FIXATE)
			{
				// Target acquired, but not fixated yet or eye still in FixWin
				if (PROCESS_STATE)
				{
					printf("****STAT_TARG_FIXATE[%d]: OK (Check target fixated); Within: TARGET_HOLD_TIME\n", STAT_TARG_FIXATE);
					spawn UPD8_MSG();

					// Keep independent of previous state times if any.
					PROCESS_STATE  = 0;
					STAT_STRT_T    = time();
					STAT_DLTA_T    = 0;
					// Hold time for target
					STAT_ALLOWED_T = TARGET_HOLD_TIME;
					// Extra variable needed for saccade duration, if late saccade
					STAT_I_MOVE_DURATION = MAX_SACCADE_DURATION * TIME_DILATE_FACTOR;
					spawn UPD8_MSG();
				}
				spawnwait CHECK_TARG_VERT_RFRSH();

				if(STAT_DLTA_T <= STAT_ALLOWED_T)
				{
					if(!I_IN_FLIGHT || !IS_TARG_ACQUIRED)
					{
						if (!I_FIX)
						{
							// Eye out of Fix win
							I_IN_FLIGHT        = 1;
							TRL_SACC_DURATION  = 0;
							TRL_LATE_SACC_TIME = time();
							spawn SEND_EVT(LateSaccade_);

							printf("****STAT_TARG_FIXATE[%d]: OK? (*Late Saccade*); After: MAX_SACCADE_TIME (During[%d]: TARG_HOLD_TIME)\n", STAT_TARG_FIXATE);
							spawn UPD8_MSG();
						}
						else if (I_IN_FLIGHT)
						{
							spawnwait CHECK_TARG_ACQUIRED();
						}
					}
					else if(IS_TARG_ACQUIRED && !I_TARG) // and I_TARG
					{
						TRL_TARG_BREAK_FIX_TIME = time();
						spawn SEND_EVT(TargetBreakFix_);

						printf("****STAT_TARG_FIXATE[%d]: ERR (*Broke Target Fixation*); Within: TARG_HOLD_TIME\n", STAT_TARG_FIXATE);
						spawn UPD8_MSG();

						PROCESS_STATE = 1;
						CURR_STAT     = STAT_FEEDBACK;
					}
				}
				else if (I_TARG)
				{
					// Successful target fixation.. for GO_TRIAL
					TRL_TARG_FIXATED_TIME = time();
					spawn SEND_EVT(Target_);

					printf("****STAT_TARG_FIXATE[%d]: OK (Target Fixated); Within: TARG_HOLD_TIME\n", STAT_TARG_FIXATE);
					spawn UPD8_MSG();

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FEEDBACK;
				}
				else if (I_FIX)
				{
					// Subject did not make a saccade.
					// so, for GO_TRIAL[%d]: No_Saccade, Error
					// for STOP_TRIAL[%d]: should not come here, but of it does,
					// the trial was successfully cancelled?
					TRL_NO_SACCADE_TIME = time();
					spawn SEND_EVT(GoError_);                                                //??? Check

					printf("****STAT_TARG_FIXATE[%d]: ERR? (No Saccade, *sent GoError_?*); Within: TARG_HOLD_TIME\n", STAT_TARG_FIXATE);
					spawn UPD8_MSG();

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FEEDBACK;
				}
				else if(!I_TARG || !I_FIX)
				{
					printf("*******THIS**SHOULD**NOT**OCCUR**AS**IT**IS**CODED**ALREADY**IN**CHECK_TARG_ACQUIRED()********\n");
					TRL_ERROR_SACCADE_TIME = time();
					spawn SEND_EVT(GoError_);                        //??? Check

					// Error saccade?
					printf("		CHECK_TARG_ACQUIRED:Eye elsewhere. ErrorSaccade?????..\n");

					PROCESS_STATE = 1;
					CURR_STAT     = STAT_FEEDBACK;
				}
				
			}
			//================= State = STAT_FEEDBACK===============
			if (CURR_STAT == STAT_FEEDBACK)
			{
				dsendf("vp %d\n",PG_BLANK);
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
	declare int dummy =0;
	dummy =1;
	printf("TRL_NUM [%d], TRL_CUM_TIME [%d], CURR_STAT [%d], STAT_DLTA_T [%d]\n", TRL_NUMBER, TRL_CUM_TIME, CURR_STAT, STAT_DLTA_T);
}

// For counting Target vertical refresh for both GO and STOP trials
process CHECK_TARG_VERT_RFRSH()
{
	declare int trigWidth = 3;
	if (PD_TRIG_L)
	{
		if (TRL_TARG_VRT_RFRSH_COUNT == 0)
		{
			IS_TARG_ON_FLAG          = 1;
			TRL_TARG_VRT_RFRSH_COUNT = 1;
			//spawn UPD8_MSG();

			//printf("TRL_TARG_VRT_RFRSH_COUNT [%d], TRL_TARG_ON_DURATION[%d]\n", TRL_TARG_VRT_RFRSH_COUNT, TRL_TARG_ON_DURATION);
		}
		else if ((STAT_DLTA_T - TARG_VR_COUNT_TIME) > trigWidth)
		{
			TRL_TARG_VRT_RFRSH_COUNT = TRL_TARG_VRT_RFRSH_COUNT + 1;
			//spawn UPD8_MSG();

			//printf("TRL_TARG_VRT_RFRSH_COUNT [%d], TRL_TARG_ON_DURATION[%d]\n", TRL_TARG_VRT_RFRSH_COUNT, TRL_TARG_ON_DURATION);
		}
		TARG_VR_COUNT_TIME = STAT_DLTA_T;
	}
}

process CHECK_TARG_ACQUIRED()
{
	// EYE in flight out of FIX_WIN
	// EarlySaccade[%d]: sacBeginTime = 0
	// Normal saccade[%d]: sacBeginTime = STAT_DLTA_T when the saccade is made
	// increment everytime checked (once per cycle)
	TRL_SACC_DURATION = TRL_SACC_DURATION + 1;
	if (I_TARG)
	{
		IS_TARG_ACQUIRED = 1;

		if (TRL_SACC_DURATION <= STAT_I_MOVE_DURATION)
		{
			TRL_TARG_ACQ_TIME = time();
			TRL_DECIDE_TIME   = time();                      //?
			spawn SEND_EVT(AcquireTarget_);
			spawn SEND_EVT(Decide_);

			printf("		CHECK_TARG_ACQUIRED[%d]: OK (AcquireTarget_); Within: MAX_SACC_DURATION[%d]\n", TRL_SACC_DURATION,STAT_I_MOVE_DURATION);

			PROCESS_STATE = 1;
			CURR_STAT     = STAT_TARG_FIXATE;

		}
		else if (TRL_SACC_DURATION > STAT_I_MOVE_DURATION)
		{
			TRL_TARG_ACQ_SLOW_TIME = time();
			TRL_DECIDE_TIME        = time();                 //?
			spawn SEND_EVT(AcquireTargetSlow_);
			spawn SEND_EVT(Decide_);

			printf("		CHECK_TARG_ACQUIRED[%d]:OK? (AcquireTargetSlow_); After: MAX_SACC_DURATION[%d]\n", TRL_SACC_DURATION,STAT_I_MOVE_DURATION);

			PROCESS_STATE = 1;
			CURR_STAT     = STAT_TARG_FIXATE;
		}
		// target wide anti etc here....
	}
	else if (STAT_DLTA_T >= STAT_ALLOWED_T)
	{
		IS_TARG_ACQUIRED = 0;
		if (!I_TARG && !I_FIX)
		{
			TRL_ERROR_SACCADE_TIME = time();
			spawn SEND_EVT(GoError_);                        //??? Check

			// Error saccade?
			printf("		CHECK_TARG_ACQUIRED[%d]:ERR? (Eye elsewhere); After: MAX_SACC_TIME[%d]\n",STAT_DLTA_T,STAT_ALLOWED_T);

			PROCESS_STATE = 1;
			CURR_STAT     = STAT_FEEDBACK;
		}
	}
} /* CHECK_TARG_ACQUIRED */
