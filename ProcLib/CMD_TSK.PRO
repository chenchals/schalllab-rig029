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
declare CHECK_TARG_ACQUIRED();


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

        PROCESS_STATE            = 1;
        TRL_CUM_TIME             = 0;
        TRL_FIX_VRT_RFRSH_COUNT  = 0;
        TRL_TARG_VRT_RFRSH_COUNT = 0;
        TRL_RUNNING              = 1;
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
                spawnwait PROC_FIX_ON();
            }
            //================= State = STAT_FIXATE===============
            if (CURR_STAT == STAT_FIXATE)
            {
							spawnwait PROC_FIX_ON();;
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
            TRL_DECIDE_TIME   = time();                                  //?
            spawn SEND_EVT(AcquireTarget_);
            spawn SEND_EVT(Decide_);

            printf("		CHECK_TARG_ACQUIRED[%d]: OK (AcquireTarget_); Within: MAX_SACC_DURATION[%d]\n", TRL_SACC_DURATION, STAT_I_MOVE_DURATION);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_TARG_FIXATE;
        }
        else if (TRL_SACC_DURATION > STAT_I_MOVE_DURATION)
        {
            TRL_TARG_ACQ_SLOW_TIME = time();
            TRL_DECIDE_TIME        = time();                             //?
            spawn SEND_EVT(AcquireTargetSlow_);
            spawn SEND_EVT(Decide_);

            printf("		CHECK_TARG_ACQUIRED[%d]:OK? (AcquireTargetSlow_); After: MAX_SACC_DURATION[%d]\n", TRL_SACC_DURATION, STAT_I_MOVE_DURATION);

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
            spawn SEND_EVT(GoError_);                                    //??? Check

            // Error saccade?
            printf("		CHECK_TARG_ACQUIRED[%d]:ERR? (Eye elsewhere); After: MAX_SACC_TIME[%d]\n", STAT_DLTA_T, STAT_ALLOWED_T);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_FEEDBACK;
        }
    }
} /* CHECK_TARG_ACQUIRED */
