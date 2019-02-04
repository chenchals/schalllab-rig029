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
declare CHECK_TARG_ACQUIRED();
declare CHECK_TARG_VERT_RFRSH();

declare int TRL_RUNNING;

declare int TARG_VR_COUNT_TIME;
// A flag for sending event only 1 time Ex. FixSpotOn (based on trigger)
declare int SEND_EVNT_ONCE;
// increment trial target on duration flag
// =1 first time PD_TRIG_L is detected for Target on page
// =0 first rime PD_TRIG_R is detected for Stop signal page
// =0 when blank page for GO trial?
declare int IS_TARG_ON_FLAG;
declare int I_IN_FLIGHT;
// A temporary state acitivity
declare int SETUP_STATE;
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
    printf("Setting QUE_TTL\n");
    spawn QUE_TTL();

    printf("Setting WTCH_EYE\n");
    spawn WTCH_EYE();

    printf("Setting WTCH_SCHMITT\n");
    spawn WTCH_SCHMITT();

    printf("Setting GRAPHS\n");
    spawn GRAPHS();

    CURR_STAT  = STAT_IDLE;
    TRL_NUMBER = 0;
    printf("Setting SEND_EVT Room\n");
    spawn SEND_EVT(Identify_Room_);
    spawn SEND_EVT(RIG_ID);

    while (1)
    {
        //===============For each Trial=====================
        spawnwait SET_CMD_TRL();

        SETUP_STATE             = 0;
        TRL_CUM_TIME            = 0;
        TRL_FIX_VRT_RFRSH_COUNT = 0;
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

                TRL_RUNNING = 0;
                nexttick 10000;
            }

            //================= State = STAT_GET_READY===============
            if (CURR_STAT == STAT_GET_READY)
            {
                if (!SETUP_STATE)
                {
                    SEND_EVNT_ONCE     = 1;
                    SETUP_STATE        = 1;
                    TRL_NUMBER         = TRL_NUMBER + 1;
                    TRL_GET_READY_TIME = time();
                    spawn SEND_EVT(TrialGetReady_);

                    STAT_STRT_T    = TRL_GET_READY_TIME;
                    STAT_DLTA_T    = 0;
                    STAT_ALLOWED_T = READY_TIME * TIME_DILATE_FACTOR;
                    spawn UPD8_MSG();
                    spawn GRAF_SHOW_FIX_WIN();
                }
                if (I_FIX || I_FIX_WIDE)
                {
                    STAT_DLTA_T = 0;
                }
                if (STAT_DLTA_T >= STAT_ALLOWED_T)
                {
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();

                    TRL_READY_TIME = time();
                    spawn SEND_EVT(TrialReady_);

                    CURR_STAT = STAT_FIX_ON;
                }
            }
            //================= State = STAT_FIX_ON===============
            if (CURR_STAT == STAT_FIX_ON)
            {
                if (!SETUP_STATE)                                                                                                 // First time showing fixspot on
                {
                    SEND_EVNT_ONCE          = 1;
                    SETUP_STATE             = 1;
                    TRL_FIX_VRT_RFRSH_COUNT = 0;
                    TRL_START_TIME          = time();
                    spawn SEND_EVT(TrialStart_);

                    STAT_STRT_T    = TRL_START_TIME;
                    STAT_DLTA_T    = 0;
                    STAT_ALLOWED_T = ALLOWED_FIX_TIME * TIME_DILATE_FACTOR;
                    spawn UPD8_MSG();

                    dsendf("vp %d\n", PG_FIXATION_PD);
                    spawn GRAF_SHOW_FIX(GRAF_SHOW);
                }
                
                if (PD_TRIG_L)
                {
                    spawn UPD8_MSG();

                    TRL_FIX_VRT_RFRSH_COUNT = TRL_FIX_VRT_RFRSH_COUNT + 1;
                    printf("****STAT_FIX_ON:TRL_FIX_VRT_RFRSH_COUNT [%d]\n", TRL_FIX_VRT_RFRSH_COUNT);
                    if (SEND_EVNT_ONCE)
                    {
                        // do not send event multiple times
                        SEND_EVNT_ONCE  = 0;
                        TRL_FIX_ON_TIME = time();
                        printf("****STAT_FIX_ON:Sending event FixSpotOn_\n");
                        spawn SEND_EVT(FixSpotOn_);
                    }
                    dsendf("vp %d\n", PG_FIXATION);
                }
                if (!I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
                {
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();

                    printf("****STAT_FIX_ON:Fixation not acquired\n");
                    //?send event abort_?
                    CURR_STAT   = STAT_IDLE;
                    TRL_RUNNING = 0;                                                                                                                         // to go to next trial
                }
                if (I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
                {
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();

                    TRL_FIX_VRT_RFRSH_COUNT = 0;
                    TRL_FIX_ACQ_TIME        = time();
                    spawn SEND_EVT(AcquireFix_);

                    printf("****STAT_FIX_ON:Fixation acquired\n");
                    CURR_STAT = STAT_FIXATE;
                }
            }
            //================= State = STAT_FIXATE===============
            if (CURR_STAT == STAT_FIXATE)
            {
                if (!SETUP_STATE)                                                                                                 // First time showing fixspot on
                {
                    SEND_EVNT_ONCE = 1;
                    SETUP_STATE    = 1;
                    spawn SEND_EVT(TrialStart_);

                    // actually TRL_FIX_ACQ_TIME, however the below is practically
                    //same and it keeps this state independent of previous state
                    STAT_STRT_T    = time();
                    STAT_DLTA_T    = 0;
                    STAT_ALLOWED_T = FIX_HOLD_TIME * TIME_DILATE_FACTOR;
                    spawn UPD8_MSG();
                }
                
                if (!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
                {
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();

                    printf("****STAT_FIXATE:Not fixated******\n");
                    printf("Send.... event Abort_??\n");
                    //?send event abort_?
                    CURR_STAT   = STAT_IDLE;
                    TRL_RUNNING = 0;                                                                                                                         // to go to next trial
                }
                if (I_FIX && STAT_DLTA_T >= STAT_ALLOWED_T)
                {
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();

                    TRL_FIXATED_TIME = time();
                    printf("Sending event Fixate_\n");
                    spawn SEND_EVT(Fixate_);

                    printf("****STAT_FIXATE:Fixated\n");
                    CURR_STAT = STAT_TARG_ON;
                }
            }
            //================= State = STAT_TARG_ON===============
            if (CURR_STAT == STAT_TARG_ON)
            {
                if (!SETUP_STATE)
                {
									  I_IN_FLIGHT = 0;
                    SEND_EVNT_ONCE           = 1;
                    SETUP_STATE              = 1;
                    TARG_VR_COUNT_TIME       = 0;
                    TRL_TARG_VRT_RFRSH_COUNT = 0;
                    TRL_TARG_ON_DURATION     = 0;
                    IS_TARG_ON_FLAG          = 0;
                    TRL_ERLY_SACC_TIME       = 0;
                    TRL_PRE_TARG_ON_TIME     = time();
                    spawn SEND_EVT(TargetPre_);

                    STAT_STRT_T    = TRL_PRE_TARG_ON_TIME;
                    STAT_DLTA_T    = 0;
                    STAT_ALLOWED_T = MIN_MAX_SACCADE_TIME[0] * TIME_DILATE_FACTOR;
                    spawn UPD8_MSG();

                    dsendf("vp %d\n", PG_TARGET_PD);
                    spawn GRAF_SHOW_FIX(GRAF_HIDE);
                    spawn GRAF_SHOW_TARG(GRAF_SHOW);
                }
                
                spawnwait CHECK_TARG_VERT_RFRSH();

                if (!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
                {
                    // Early saccade
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();
										I_IN_FLIGHT = 1;
                    TRL_ERLY_SACC_TIME = time();
                    spawn SEND_EVT(EarlySaccade_);

                    printf("****STAT_TARG_ON:Early Saccade\n");
                    CURR_STAT = STAT_TARG_ACQ;
                }
                if (I_FIX && STAT_DLTA_T > STAT_ALLOWED_T)
                {
                    // Ready for saccade...
                    SETUP_STATE = 0;
                    spawn UPD8_MSG();

                    printf("****STAT_TARG_ON:MIN_SACCADE_TIME expired still fixated\n");
                    CURR_STAT = STAT_TARG_ACQ;
                }
            }
            //================= State = STAT_TARG_ACQ===============
            if (CURR_STAT == STAT_TARG_ACQ)
            {
                // Target not yet acquired
                if (!SETUP_STATE)
                {
                    SEND_EVNT_ONCE = 0;
                    SETUP_STATE    = 1;
                    // Keep independent of previous state times if any.
                    STAT_STRT_T       = time();
                    STAT_DLTA_T       = 0;
                    TRL_SACC_DURATION = 0;
                    //MIN_SACC_TIME accounted for in TARG_ON
                    // now reamining is the difference between MIN and MAX sacc time
                    STAT_ALLOWED_T = (MIN_MAX_SACCADE_TIME[1] - MIN_MAX_SACCADE_TIME[0]) * TIME_DILATE_FACTOR;
                    // Extra variable needed for saccade duration
                    STAT_I_MOVE_DURATION = MAX_SACCADE_DURATION;
                    spawn UPD8_MSG();
                }
                
                spawnwait CHECK_TARG_VERT_RFRSH();

                if (TRL_ERLY_SACC_TIME)
                {
                    // Eye already out of Fix window
                    spawnwait CHECK_TARG_ACQUIRED();
                }
                else
                {
                    if (I_FIX && STAT_DLTA_T > STAT_ALLOWED_T)
                    {
                        // still fixating after max-sacc-time
                        // check if it is Late target aquire
                        // or Error no saccade for Go trial
                        CURR_STAT = STAT_TARG_FIXATE;
                    }
                    else if (!I_FIX && STAT_DLTA_T <= STAT_ALLOWED_T)
                    {
                        // Eye out of Fix window
                        if (SEND_EVNT_ONCE)
                        {
                            // do not send event multiple times
                            SEND_EVNT_ONCE    = 0;
														I_IN_FLIGHT = 1;
                            TRL_SACC_TIME     = time();
                            TRL_SACC_DURATION = 0;
                            printf("Sending event Saccade_\n");
                            spawn SEND_EVT(Saccade_);
                        }
                        spawnwait CHECK_TARG_ACQUIRED();
                    }
                }
            }
            //================= State = STAT_TARG_FIXATE===============
            if (CURR_STAT == STAT_TARG_FIXATE)
            {
                // Target acquired, but not fixated yet or eye still in FixWin
                if (!SETUP_STATE)
                {
									 if(I_FIX)
									 {
										 I_IN_FLIGHT = 0;
									 }
                    SEND_EVNT_ONCE = 0;
                    SETUP_STATE    = 1;
                    // Keep independent of previous state times if any.
                    STAT_STRT_T       = time();
                    STAT_DLTA_T       = 0;
                    TRL_SACC_DURATION = 0;
                    // Hold time for target
                    STAT_ALLOWED_T = TARGET_HOLD_TIME;
                    // Extra variable needed for saccade duration, if late saccade
                    STAT_I_MOVE_DURATION = MAX_SACCADE_DURATION;
                    spawn UPD8_MSG();
                }
                
                spawnwait CHECK_TARG_VERT_RFRSH();

                if (!I_IN_FLIGHT && STAT_DLTA_T < STAT_ALLOWED_T)
                {
									if(!I_FIX)
									{
										I_IN_FLIGHT = 1;
										TRL_LATE_SACC_TIME = time();
										spawn SEND_EVT(LateSaccade_);
										spawnwait CHECK_TARG_ACQUIRED();
									}
                }
                else if (!I_TARG && STAT_DLTA_T < STAT_ALLOWED_T)
                {
                    TRL_TARG_BREAK_FIX_TIME = time();
                    spawn SEND_EVT(TargetBreakFix_);

                    CURR_STAT   = STAT_TONE;
                    SETUP_STATE = 0;
                }
                else if (STAT_DLTA_T >= STAT_ALLOWED_T)
                {
                    if (I_TARG)
                    {
                        // Successful target fixation.. for GO_TRIAL
                        TRL_TARG_FIXATED_TIME = time();
                        spawn SEND_EVT(Target_);

                        CURR_STAT   = STAT_TONE;
                        SETUP_STATE = 0;
                    }
                    else if (I_FIX)
                    {
                        // Subject did not make a saccade.
                        // so, for GO_TRIAL: No_Saccade, Error
                        // for STOP_TRIAL: should not come here, but of it does,
                        // the trial was successfully cancelled?
                        TRL_NO_SACCADE_TIME = time();
                        spawn SEND_EVT(GoError_);                        //??? Check

                        CURR_STAT   = STAT_TONE;
                        SETUP_STATE = 0;
                    }
                }
            }
						//================= State = STAT_TONE===============
						if(CURR_STAT == STAT_TONE)
						{
							nexttick 2000;
							TRL_RUNNING = 0;
						}
						//================= State = STAT_TONE===============
            if (IS_TARG_ON_FLAG)
            {
                // if target is on update target on duration every process cycle
                TRL_TARG_ON_DURATION = TRL_TARG_ON_DURATION + 1;
            }
			STAT_DLTA_T = STAT_DLTA_T + 1;
            TRL_CUM_TIME = TRL_CUM_TIME + 1;
            nexttick;
        } /*while(TRL_RUNNING)*/
        nexttick;
    }     /*while(1)*/
}         /*IDLE()*/


process UPD8_MSG()
{
    printf("TRL_NUMUMBR [%d], TRL_CUM_TIME [%d], CURR_STAT [%d], STAT_DLTA_T [%d]\n", TRL_NUMBER, TRL_CUM_TIME, CURR_STAT, STAT_DLTA_T);
}


// For counting Target vertical refresh for both GO and STOP trials
process CHECK_TARG_VERT_RFRSH()
{
    if (PD_TRIG_L)
    {
        spawnwait INCREMENT_TRL_TARG_VRT_RFRSH_COUNT();

        if (SEND_EVNT_ONCE)
        {
            // do not send event multiple times
            SEND_EVNT_ONCE   = 0;
            TRL_TARG_ON_TIME = time();
            printf("Sending event Target_\n");
            spawn SEND_EVT(Target_);
            spawn SEND_EVT(FixSpotOff_);
        }
    }
}


// Do not double count same trigger
process INCREMENT_TRL_TARG_VRT_RFRSH_COUNT()
{
    declare int trigWidth = 3;

    if (TRL_TARG_VRT_RFRSH_COUNT == 0)
    {
        IS_TARG_ON_FLAG          = 1;
        TRL_TARG_VRT_RFRSH_COUNT = 1;
        spawn UPD8_MSG();

        //printf("TRL_TARG_VRT_RFRSH_COUNT [%d], TRL_TARG_ON_DURATION[%d]\n", TRL_TARG_VRT_RFRSH_COUNT, TRL_TARG_ON_DURATION);
    }
    else if ((STAT_DLTA_T - TARG_VR_COUNT_TIME) > trigWidth)
    {
        TRL_TARG_VRT_RFRSH_COUNT = TRL_TARG_VRT_RFRSH_COUNT + 1;
        spawn UPD8_MSG();

        //printf("TRL_TARG_VRT_RFRSH_COUNT [%d], TRL_TARG_ON_DURATION[%d]\n", TRL_TARG_VRT_RFRSH_COUNT, TRL_TARG_ON_DURATION);
    }
    TARG_VR_COUNT_TIME = STAT_DLTA_T;
}


process CHECK_TARG_ACQUIRED()
{
    // EYE in flight out of FIX_WIN
    // EarlySaccade: sacBeginTime = 0
    // Normal saccade: sacBeginTime = STAT_DLTA_T when the saccade is made
    // increment everytime checked (once per cycle)
    TRL_SACC_DURATION = TRL_SACC_DURATION + 1;
    if (I_TARG)
    {
        if (TRL_SACC_DURATION < STAT_I_MOVE_DURATION)
        {
            TRL_TARG_ACQ_TIME = time();
            TRL_DECIDE_TIME   = time();          //?
            spawn SEND_EVT(AcquireTarget_);
            spawn SEND_EVT(Decide_);

            printf("		CHECK_TARG_ACQUIRED:AcquireTarget_(before MAX_SACC_DURATION) [%d]\n", TRL_SACC_DURATION);
            CURR_STAT   = STAT_TARG_FIXATE;
            SETUP_STATE = 0;
        }
        else if (TRL_SACC_DURATION >= STAT_I_MOVE_DURATION)
        {
            TRL_TARG_ACQ_SLOW_TIME = time();
            TRL_DECIDE_TIME        = time();     //?
            spawn SEND_EVT(AcquireTargetSlow_);
            spawn SEND_EVT(Decide_);

            printf("		CHECK_TARG_ACQUIRED:AcquireTargetSlow_(=after MAX_SACC_DURATION) [%d]\n", TRL_SACC_DURATION);
            CURR_STAT   = STAT_TARG_FIXATE;
            SETUP_STATE = 0;
        }
        // target wide anti etc here....
    }
    else if (STAT_DLTA_T >= STAT_ALLOWED_T)
    {
        if (!I_TARG && !I_FIX)
        {
            // Error saccade?
            printf("		CHECK_TARG_ACQUIRED:Eye elsewhere. ErrorSaccade?????..\n");
            TRL_ERROR_SACCADE_TIME = time();
            spawn SEND_EVT(GoError_);            //??? Check
            CURR_STAT   = STAT_TONE;
            SETUP_STATE = 0;
        }
    }
} /* CHECK_TARG_ACQUIRED */
