//==========================================================================
// EVENTDEF.PRO
//   Description: Send all infos (call during ITI_CHK or TIME_OUT state processing).
//                ALL TRL_* variables are sent.
//                This file will be used for translating the session/infos variables
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-07
//==========================================================================
declare SEND_INFOS();
declare SEND_INFO_EVT(int evtVal);
declare SEND_INFO_REL_TIME(int evtVal, int offsetVal);

declare constant int INFOS_ZERO = 3000;
declare int          N_INFOS;


process SEND_INFOS()
{
    declare int TRL_RAND_NEG_NUMBER_TEST;

    N_INFOS = 0;
    printf("****INFOS.PRO: Sending infos....\n");
    TRL_RAND_NEG_NUMBER_TEST = -((random(5000) + 1) * 2);
    spawnwait SEND_INFO_EVT(TRL_RAND_NEG_NUMBER_TEST);
    spawnwait SEND_INFO_EVT(TRL_TRIAL_NUMBER);
    spawnwait SEND_INFO_EVT(TRL_BLOCK_NUM);
    spawnwait SEND_INFO_EVT(TRL_TRIAL_TYPE);
    spawnwait SEND_INFO_EVT(TRL_IS_FIX_ON);
    spawnwait SEND_INFO_EVT(TRL_IS_FIX_ACQUIRED);
    spawnwait SEND_INFO_EVT(TRL_IS_TARG_ON);
    spawnwait SEND_INFO_EVT(TRL_IS_TARG_ACQUIRED);
    spawnwait SEND_INFO_EVT(TRL_IS_STOP_SIGNAL_ON);
    spawnwait SEND_INFO_EVT(TRL_IS_XTRA_HOLD_DONE);
    spawnwait SEND_INFO_EVT(TRL_IS_MIN_THT);
    spawnwait SEND_INFO_EVT(TRL_IS_MIN_SSHT);
    spawnwait SEND_INFO_EVT(TRL_IS_TIMEOUT);
    spawnwait SEND_INFO_EVT(TRL_IS_GO_CORRECT);
    spawnwait SEND_INFO_EVT(TRL_IS_GO_ERR);
    spawnwait SEND_INFO_EVT(TRL_IS_NON_CANCELLED);
    spawnwait SEND_INFO_EVT(TRL_IS_CANCELLED);
    spawnwait SEND_INFO_EVT(TRL_IS_CANCELLED);
    spawnwait SEND_INFO_EVT(TRL_IS_NON_CANCELLED_ERR);
    spawnwait SEND_INFO_EVT(TRL_IS_NOGO_ERR);
    spawnwait SEND_INFO_EVT(TRL_IS_LO_RWRD);
    spawnwait SEND_INFO_EVT(TRL_IS_FIX_REIGNITE);
    spawnwait SEND_INFO_EVT(TRL_IS_STAIRCASE_SSD);
    spawnwait SEND_INFO_EVT(TRL_CUM_DURATION);
    spawnwait SEND_INFO_EVT(TRL_GET_READY_DURATION);
    spawnwait SEND_INFO_EVT(TRL_FIX_HOLD_DURATION);
    spawnwait SEND_INFO_EVT(TRL_MIN_SSHT_DURATION);
    spawnwait SEND_INFO_EVT(TRL_MIN_THT_DURATION);
    spawnwait SEND_INFO_EVT(TRL_TARG_ON_DURATION);
    spawnwait SEND_INFO_EVT(TRL_XTRA_HOLD_DURATION);
    spawnwait SEND_INFO_EVT(TRL_SACC_DURATION);
    spawnwait SEND_INFO_EVT(TRL_TARG_HOLD_DURATION);
    spawnwait SEND_INFO_EVT(TRL_STOP_SIGNAL_DURATION);
    spawnwait SEND_INFO_EVT(TRL_TARG_VR_COUNT);
    spawnwait SEND_INFO_EVT(TRL_SSD_VR_COUNT);
    spawnwait SEND_INFO_EVT(TRL_USE_TRIAL_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_SSD_IDX);
    spawnwait SEND_INFO_EVT(TRL_USE_STAIRCASE);
    spawnwait SEND_INFO_EVT(TRL_USE_SSD_STEP_UP);
    spawnwait SEND_INFO_EVT(TRL_USE_SSD_STEP_DOWN);
    spawnwait SEND_INFO_EVT(TRL_USE_IS_TRL_LENGTH_FIXED);
    spawnwait SEND_INFO_EVT(TRL_USE_SSD_VR_COUNT);
    spawnwait SEND_INFO_EVT(TRL_USE_FIX_HOLD_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_FIX_HOLD_ADJUST);
    spawnwait SEND_INFO_EVT(TRL_USE_MIN_THT_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_SSD_CANCEL_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_PRE_SSD_FIX_ON_DELAY);
    spawnwait SEND_INFO_EVT(TRL_USE_POST_SSD_FIX_ON_DELAY);
    spawnwait SEND_INFO_EVT(TRL_USE_TONE_DELAY);
    spawnwait SEND_INFO_EVT(TRL_USE_TONE_FREQ);
    spawnwait SEND_INFO_EVT(TRL_USE_TONE_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_RWRD_DELAY);
    spawnwait SEND_INFO_EVT(TRL_USE_RWRD_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_ITI_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_TIMEOUT_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_CORRECT_TRIALS_PER_BLOCK);
    spawnwait SEND_INFO_EVT(TRL_USE_REPEAT_LO_RWRD_ERROR_TRL);
    spawnwait SEND_INFO_EVT(TRL_USE_REPEAT_MAX);
    spawnwait SEND_INFO_EVT(TRL_USE_XTRA_HOLD_DURATION);
    spawnwait SEND_INFO_EVT(TRL_USE_XTRA_HOLD_TONE_RWRD_FLAG);
    spawnwait SEND_INFO_EVT(TRL_CURR_TARG_IDX);
    spawnwait SEND_INFO_EVT(int(TRL_CURR_TARG_SIZE * 100));
    spawnwait SEND_INFO_EVT(int(TRL_CURR_TARG_ANGLE * 100));
    spawnwait SEND_INFO_EVT(int(TRL_CURR_TARG_ECCENTRICITY * 100));
    spawnwait SEND_INFO_EVT(TRL_CURR_TARG_COLOR_IDX);
    spawnwait SEND_INFO_EVT(TRL_LO_RWRD_TARG_IDX);
    spawnwait SEND_INFO_EVT(TRL_REPEAT_COUNT);
    spawnwait SEND_INFO_EVT(TRL_LAST_STOP_OUTCOME_EVNTCODE);
    spawnwait SEND_INFO_EVT(TRL_LAST_GO_OUTCOME_EVNTCODE);
    spawnwait SEND_INFO_EVT(TRL_LAST_SSD_IDX);

    // Last info code
    spawnwait SEND_INFO_EVT(N_INFOS);
} /* SEND_INFOS */


process SEND_INFO_EVT(int evtVal)
{
    N_INFOS = N_INFOS + 1;
    if (evtVal <= 0)
    {
        evtVal = 32768 - INFOS_ZERO - evtVal;
    }
    spawn SEND_EVT(INFOS_ZERO + evtVal);

    nexttick;
}


process SEND_INFO_REL_TIME(int evtVal, int offsetVal)
{
    declare int temp;

    N_INFOS = N_INFOS + 1;
    if (evtVal == 0)
    {
        temp = 0;
    }
    else if (evtVal == -1)
    {
        temp = -1;
    }
    else
    {
        temp = evtVal - offsetVal;
    }
    if (temp <= 0)
    {
        temp = 32768 - INFOS_ZERO - temp;
    }
    spawn SEND_EVT(INFOS_ZERO + temp);

    nexttick;
}
