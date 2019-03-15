//==========================================================================
// RWRD_SSD.PRO
//   Description: Process Rewarde state after Tone is delivered for STOP trial
//                Gaze is in FIX_WIN only if TRL_USE_XTRA_HOLD_DURATION >
//                TONE_DELAY + TONE_DURATION.
// Gaze Check:
// Signal is ON Target is ON:
// Check:
//   case 0: TRL_USE_XTRA_HOLD_DURATION <= RWRD_DELAY
//         if gaze out of FIX_WIN before TRL_USE_XTRA_HOLD_DURATION expires: No Reward --> goto STAT_OUTCOME
//         if gaze in FIX_WIN until TRL_USE_XTRA_HOLD_DURATION expires: Deliver reward at RWRD_DELAY time
//   case 1: TRL_USE_XTRA_HOLD_DURATION <= RWRD_DELAY + RWRD_DURATION
//                if gaze in FIX_WIN until RWRD_DURATION --> (reward alredey delivered)--> goto STAT_OUTCOME
//                if gaze not in FIX_WIN during RWRD_DURATION --> (reward already delivered) --> goto STAT_TIM_OUT
//   case 2: TRL_USE_XTRA_HOLD_DURATION > RWRD_DELAY + RWRD_DURATION
//         if gaze in FIX_WIN until TRL_USE_XTRA_HOLD_DURATION expires: (reward already delivered) --> goto STAT_OUTCOME
//         if gaze out of FIX_WIN before TRL_USE_XTRA_HOLD_DURATION expires: (reward already delivered) --> goto STAT_TIM_OUT
//
//   All Global variables and the following state variables are available to monitor state progress
//                1. PROCESS_STATE : Setup state processing, will be done once per call
//                1. CURR_STAT :
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_ALLOWED_T : Max time for staying in this state
//                5. STAT_I_DURATION : If saccade occurs, it must complete in this time
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-02-09
//==========================================================================
//  Revision History:

declare PROC_RWRD_SSD();

declare int TEMP_RWRD_DURATION;


process PROC_RWRD_SSD()
{
    // Target acquired, but not fixated yet or gaze still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_RWRD_SSD[%d]: Processing Reward times\n", STAT_RWRD_SSD);
        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;
        // Give reward after this time, unless Abort
        STAT_ALLOWED_T = TRL_USE_RWRD_DELAY * TIME_DILATE_FACTOR;
        // Reward already given, during reward duration check gaze
        TEMP_RWRD_DURATION = TRL_USE_RWRD_DURATION * TIME_DILATE_FACTOR;
        // This is incremented in the CMD_TSK.PRO --> state flow controller
        TEMP_XTRA_HOLD_TIME           = TRL_USE_XTRA_HOLD_DURATION * TIME_DILATE_FACTOR;
        TEMP_DELY_PLUS_DURATION = STAT_ALLOWED_T + TEMP_RWRD_DURATION;
    }
    spawnwait CHECK_TARG_VERT_RFRSH();


    if (I_FIX)
    {
        TRL_FIX_HOLD_DURATION = TRL_FIX_HOLD_DURATION + 1;
    }

    if (TRL_FIX_HOLD_DURATION > TEMP_XTRA_HOLD_TIME)
    {
        if (TRL_IS_FIX_MIN_SSHT<=0)
        {
            TRL_IS_FIX_MIN_SSHT   = 1;
            //TRL_FIX_MIN_SSHT_TIME = time();
            spawn SEND_EVT(FixHoldMinSSHT_);

            printf("****STAT_RWRD_SSD[%d]: OK sent Event: FixHoldMinSSHT_[%d]\n", STAT_RWRD_SSD, FixHoldMinSSHT_);
        }
    }
	
	if (TRL_FIX_HOLD_DURATION < TEMP_XTRA_HOLD_TIME)
    {
		TRL_IS_FIX_MIN_SSHT   = 0;
	}	

    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (!I_FIX && TRL_IS_FIX_MIN_SSHT<=0)
        {
            if (TEMP_XTRA_HOLD_TIME <= STAT_ALLOWED_T)
            {
                TRL_BRK_CANCEL_TIME = time();
                spawn SEND_EVT(FixHoldBrkMinSSHT_);

                printf("****STAT_RWRD_SSD[%d]: ERR sent Event: FixHoldBrkMinSSHT_[%d]\n", STAT_RWRD_SSD, FixHoldBrkMinSSHT_);
                printf("****STAT_RWRD_SSD[%d]: ERR (*Min_SSHT*Broke  Fixation--PRE--*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d](RWRD_DELAY), STAT_DLTA_T [%d]\n",
                       STAT_RWRD_SSD, TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_XTRA_HOLD_TIME > STAT_ALLOWED_T)
            {
                TRL_BRK_PRE_RWRD_TIME = time();
                spawn SEND_EVT(FixHoldBrkPreRwrd_);

                printf("****STAT_RWRD_SSD[%d]: ERR sent Event: FixHoldBrkPreRwrd_[%d]\n", STAT_RWRD_SSD, FixHoldBrkPreRwrd_);
                printf("****STAT_RWRD_SSD[%d]: ERR (*Pre-Reward*Broke Fixation*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d](RWRD_DELAY), STAT_DLTA_T [%d]\n",
                       STAT_RWRD_SSD, TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    // Reward duration
    else if (STAT_DLTA_T > STAT_ALLOWED_T && STAT_DLTA_T <= TEMP_DELY_PLUS_DURATION)
    {
        if (TRL_RWRD_ON_TIME<=0)
        {
            TRL_RWRD_ON_TIME = time();
            spawn JUICE(JUICE_CHANNEL, TEMP_RWRD_DURATION);
            spawn SEND_EVT(RewardOn_);

            printf("****STAT_RWRD_SSD[%d]: OK sent Event: RewardOn_[%d]\n", STAT_RWRD_SSD, RewardOn_);
        }
        if (!I_FIX && TRL_IS_FIX_MIN_SSHT<=0)
        {
            if (TEMP_XTRA_HOLD_TIME > STAT_ALLOWED_T && TEMP_XTRA_HOLD_TIME <= TEMP_DELY_PLUS_DURATION)
            {
                TRL_BRK_CANCEL_TIME = time();
                spawn SEND_EVT(FixHoldBrkMinSSHT_);

                printf("****STAT_RWRD_SSD[%d]: ERR sent Event: FixHoldBrkMinSSHT_[%d]\n", STAT_RWRD_SSD, FixHoldBrkMinSSHT_);
                printf("****STAT_RWRD_SSD[%d]: ERR (*Min_SSHT*Broke Fixation--DURING--*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d](RWRD_DELAY+RWRD_DURATION), STAT_DLTA_T [%d]\n",
                       STAT_RWRD_SSD, TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_XTRA_HOLD_TIME > TEMP_DELY_PLUS_DURATION)
            {
                TRL_BRK_RWRD_TIME = time();
                spawn SEND_EVT(FixHoldBrkRwrd_);

                printf("****STAT_RWRD_SSD[%d]: ERR sent Event: FixHoldBrkRwrd_[%d][%d]\n", STAT_RWRD_SSD, FixHoldBrkRwrd_);
                printf("****STAT_RWRD_SSD[%d]: ERR (*During-Reward*Broke Fixation*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d](RWRD_DELAY+RWRD_DURATION), STAT_DLTA_T [%d]\n",
                       STAT_RWRD_SSD, TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    else if (STAT_DLTA_T > TEMP_DELY_PLUS_DURATION)   // after reward
    {
        if (TRL_RWRD_OFF_TIME<=0)
        {
            TRL_RWRD_OFF_TIME = time();
            spawn SEND_EVT(RewardOff_);

            printf("****STAT_RWRD_SSD[%d]: OK sent Event: RewardOff_[%d]\n", STAT_RWRD_SSD, RewardOff_);
        }
        if (TRL_IS_FIX_MIN_SSHT)
        {
            printf("****STAT_RWRD_SSD[%d]: OK (*SUCCESS**TRL_USE_XTRA_HOLD_DURATION*Fixspot Fixated*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d](RWRD_DELAY+RWRD_DURATION), STAT_DLTA_T [%d]\n",
                   STAT_RWRD_SSD, TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_OUTCOME;
        }

        if (STAT_DLTA_T <= TEMP_XTRA_HOLD_TIME && TRL_IS_FIX_MIN_SSHT<=0)
        {
            if (!I_FIX)
            {
                TRL_BRK_CANCEL_TIME = time();
                spawn SEND_EVT(FixHoldBrkMinSSHT_);

                printf("****STAT_RWRD_SSD[%d]: ERR sent Event: FixHoldBrkMinSSHT_[%d]\n", STAT_RWRD_SSD, FixHoldBrkMinSSHT_);
                printf("****STAT_RWRD_SSD[%d]: ERR (*Min_SSHT*Broke Fixation--POST--*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d](RWRD_DELAY+RWRD_DURATION), STAT_DLTA_T [%d]\n",
                       STAT_RWRD_SSD, TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
} /* PROC_RWRD_SSD */
