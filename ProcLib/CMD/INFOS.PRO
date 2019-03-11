//==========================================================================
// EVENTDEF.PRO
//   Description: Send all infos (call during ITI_CHK or TIME_OUT state processing).
//                ALL TRL_* variables are sent.
//                This file will be used for translating the session/infos variables
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-07
//==========================================================================
declare SEND_INFOS();
declare WAIT_INFOS();

declare constant int INFOS_ZERO = 3000;
declare int          N_INFOS;
declare int          DONE_INFOS = 0;


process SEND_INFOS()
{
    N_INFOS = 0;
    printf("****INFOS.PRO: Sending infos....\n");


    spawn SEND_EVT(INFOS_ZERO + TRL_NUMBER);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TYPE);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_RUNNING);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_VR_COUNT_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_TARG_ON_FLAG);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_TARG_ACQUIRED);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_FIX_ACQUIRED);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_I_IN_FLIGHT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_TARG_MIN_THT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_TIMEOUT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_STOP_SIGNAL_ON);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_STOP_SIGNAL_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_STOP_SIGNAL_DELAY_IDX);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_STOP_SIGNAL_DELAY);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_STOP_SIGNAL_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_NON_CANCELLED);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_CANCELLED);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_CUM_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_START_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_END_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_GET_READY_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_READY_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_GET_READY_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_ON_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_ACQ_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_ACQ_ERROR_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_HOLD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIXATED_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_FIX_HOLD_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_PRE_TARG_ON_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_ON_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TARG_ON_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_DECIDE_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_SACC_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_ERLY_SACC_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_LATE_SACC_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_NO_SACC_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_STAIRCASE_SSD_FLAG);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_ACQ_ERROR_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_SACC_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_ACQ_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TARG_HOLD_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TIMEOUT_START_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TIMEOUT_END_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TIMEOUT_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_MIN_THT_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_PRE_TONE_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_TONE_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_PRE_RWRD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_RWRD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_POST_RWRD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TARG_BRK_MIN_THT_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_NOGO_SACC_PRE_SSD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_NOGO_SACC_POST_SSD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_NOGO_ERLY_SACC_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_NOGO_LATE_SACC_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_FIX_HOLD_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_MIN_SSHT_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_PRE_TONE_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_TONE_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_PRE_RWRD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_RWRD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_POST_RWRD_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_FIX_BRK_MIN_SSHT_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_CANCEL_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_FIX_REIGNITE_FLAG);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_PRE_SSD_DELAY_FIX_REIGNITE);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_POST_SSD_DELAY_FIX_REIGNITE);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_FIX_MIN_SSHT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TONE_DELAY);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TONE_FREQ);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TONE_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TONE_ON_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_TONE_OFF_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_RWRD_DELAY);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_RWRD_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_RWRD_ON_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_RWRD_OFF_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_XTRA_RWRD_ON_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_XTRA_RWRD_OFF_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_ITI_START_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_ITI_END_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_ITI_DURATION);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_START_INFOS_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_END_INFOS_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_REACTION_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + abs(TRL_ABORT_TIME - TRL_START_TIME));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_FIX_VRT_RFRSH_COUNT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TARG_VRT_RFRSH_COUNT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TARG_SSD_VRT_RFRSH_COUNT);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_LAST_STOP_OUTCOME_EVNTCODE);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_LAST_GO_OUTCOME_EVNTCODE);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_LAST_SSD_IDX);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_BLOCK_NUM);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_IS_LO_RWRD);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_LO_RWRD_TARG_IDX);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TARG_IDX);
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + int(TRL_TARG_SIZE * 100));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + int(TRL_TARG_ANGLE * 100));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + int(TRL_TARG_ECCENTRICITY * 100));
    spawnwait WAIT_INFOS();

    spawn SEND_EVT(INFOS_ZERO + TRL_TARG_COLOR_IDX);
    spawnwait WAIT_INFOS();

    // Last info code

    spawn SEND_EVT(INFOS_ZERO + N_INFOS);

    nexttick 2;
    DONE_INFOS = 1;
    nexttick 5;
} /* SEND_INFOS */


process WAIT_INFOS()
{
    N_INFOS = N_INFOS + 1;
    nexttick 2;
}
