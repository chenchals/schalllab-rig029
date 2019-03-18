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


    spawnwait SEND_EVT(INFOS_ZERO + TRL_TRIAL_NUMBER);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_TRIAL_TYPE);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_RUNNING);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TARG_VR_COUNT_DURATION - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_TARG_ON);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_TARG_ACQUIRED);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_FIX_ACQUIRED);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_I_IN_FLIGHT);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_XTRA_HOLD_DONE);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_TIMEOUT);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_STOP_SIGNAL_ON);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_STOP_SIGNAL_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_SSD_IDX);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_SSD_VR_COUNT);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_STOP_SIGNAL_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_NON_CANCELLED);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_CANCELLED);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_CUM_DURATION - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_TRIAL_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TRIAL_START_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_EOT_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_GET_READY_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_READY_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_GET_READY_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_FIX_ON_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ACQUIRE_FIX_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ACQUIRE_FIX_ERROR_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_USE_FIX_HOLD_DURATION- TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_FIXATE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_FIX_HOLD_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_FIX_BRK_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TARGET_PRE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TARGET_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_TARG_ON_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_DECIDE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_SACCADE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ERLY_SACCADE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_LATE_SACC_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_NO_SACCADE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_STAIRCASE_SSD);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ACQUIRE_TARGET_ERROR_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_SACC_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TARGET_ACQUIRED_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_TARG_HOLD_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TIMEOUT_START_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TIMEOUT_END_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_TIMEOUT_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_XTRA_HOLD_END_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TARG_BRK_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_PRE_TONE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_TONE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_PRE_RWRD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_RWRD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TARG_BRK_POST_RWRD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_XTRA_HOLD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_NOGO_SACCADE_PRE_SSD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_NOGO_SACCADE_POST_SSD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_NOGO_EARLY_SACCADE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_NOGO_LATE_SACCADE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_FIX_HOLD_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_FIX_MIN_SSHT_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_PRE_TONE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_TONE_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_PRE_RWRD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_RWRD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_FIX_BRK_POST_RWRD_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_BRK_CANCEL_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_CANCEL_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_FIX_REIGNITE);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_PRE_SSD_FIX_ON_DELAY);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_POST_SSD_FIX_ON_DELAY);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_FIX_MIN_SSHT);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_TONE_DELAY);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_TONE_FREQ);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_TONE_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TONE_ON_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_TONE_OFF_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_RWRD_DELAY);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_RWRD_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_REWARD_ON_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_REWARD_OFF_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_XTRA_RWRD_ON_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_XTRA_RWRD_OFF_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ITI_START_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ITI_END_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_USE_ITI_DURATION);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_START_INFOS_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_END_INFOS_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_REACTION_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_ABORT_TIME - TRL_TRIAL_START_TIME));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_TARG_VR_COUNT);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_SSD_VR_COUNT);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_LAST_STOP_OUTCOME_EVNTCODE);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_LAST_GO_OUTCOME_EVNTCODE);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_LAST_SSD_IDX);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_BLOCK_NUM);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_IS_LO_RWRD);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_LO_RWRD_TARG_IDX);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_CURR_TARG_IDX);
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_CURR_TARG_SIZE * 100));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_CURR_TARG_ANGLE * 100));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + int(TRL_CURR_TARG_ECCENTRICITY * 100));
    spawnwait WAIT_INFOS();

    spawnwait SEND_EVT(INFOS_ZERO + TRL_CURR_TARG_COLOR_IDX);
    spawnwait WAIT_INFOS();

    // Last info code
	spawnwait WAIT_INFOS();
    spawnwait SEND_EVT(INFOS_ZERO + N_INFOS);

    DONE_INFOS = 1;
} /* SEND_INFOS */


process WAIT_INFOS()
{
    N_INFOS = N_INFOS + 1;
    nexttick;
}
