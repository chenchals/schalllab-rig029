//==========================================================================
// RWRD_CHK.PRO
//   Description: Process Reward state after Tone is delivered
//                Gaze is in TARG_WIN only if MIN_TARG_HOLD_TIME >
//                TONE_DELAY + TONE_DURATION.
// Gaze Check:
// Fixspot is OFF Target is ON:
// Check:
//   case 0: MIN_TARG_HOLD_TIME <= TRL_RWRD_DELAY
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: No Reward --> goto STAT_OUTCOME
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Deliver reward at TRL_RWRD_DELAY time
//   case 1: MIN_TARG_HOLD_TIME <= TRL_RWRD_DELAY + RWRD_DURATION
//                if gaze in TARG_WIN until RWRD_DURATION --> (reward alredey delivered) --> goto STAT_OUTCOME
//                if gaze not in TARG_WIN during RWRD_DURATION --> (reward already delivered) --> goto STAT_TIM_OUT
//   case 2: MIN_TARG_HOLD_TIME > TRL_RWRD_DELAY + RWRD_DURATION
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: (reward already delivered) --> goto STAT_OUTCOME
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: (reward already delivered) --> goto STAT_TIM_OUT
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

declare PROC_RWRD_CHK();

declare int TEMP_RWRD_DURATION;


process PROC_RWRD_CHK()
{
    // Target acquired, but not fixated yet or gaze still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_RWRD_CHK[%d]: Processing Reward times\n", STAT_RWRD_CHK);
        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;
        // Give reward after this time, unless Abort
        STAT_ALLOWED_T = TRL_RWRD_DELAY * TIME_DILATE_FACTOR;
        // Reward already given, during reward duration check gaze
        TEMP_RWRD_DURATION = TRL_RWRD_DURATION * TIME_DILATE_FACTOR;
        // This is incremented in the CMD_TSK.PRO --> state flow controller
        TEMP_MIN_THT            = MIN_TARG_HOLD_TIME * TIME_DILATE_FACTOR;
        TEMP_DELY_PLUS_DURATION = STAT_ALLOWED_T + STAT_I_DURATION;
    }
    spawnwait CHECK_TARG_VERT_RFRSH();

    if (I_TARG)
    {
        TRL_TARG_HOLD_DURATION = TRL_TARG_HOLD_DURATION + 1;
    }

    if (TRL_TARG_HOLD_DURATION > TEMP_MIN_THT)
    {
        if (!TRL_IS_TARG_MIN_THT)
        {
            TRL_IS_TARG_MIN_THT   = 1;
            TRL_TARG_MIN_THT_TIME = time();
            spawn SEND_EVT(TargHoldMinTHT_);

            printf("****STAT_RWRD_CHK[%d]: OK sent Event: TargHoldMinTHT_[%d]\n", STAT_RWRD_CHK, TargHoldMinTHT_);
        }
    }
	if (TRL_TARG_HOLD_DURATION < TEMP_MIN_THT)
    {
		TRL_IS_TARG_MIN_THT = 0;
	}	

    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (!I_TARG && !TRL_IS_TARG_MIN_THT)
        {
            if (TEMP_MIN_THT <= STAT_ALLOWED_T)
            {
                TRL_TARG_BRK_MIN_THT_TIME = time();
                spawn SEND_EVT(TargHoldBrkMinTHT_);

                printf("****STAT_RWRD_CHK[%d]: ERR sent Event: TargHoldBrkMinTHT_[%d]\n", STAT_RWRD_CHK, TargHoldBrkMinTHT_);
                printf("****STAT_RWRD_CHK[%d]: ERR (*Min_THT*Broke Target Fixation--PRE--*)[%d]/[%d](TEMP_MIN_THT),[%d](TRL_RWRD_DELAY), STAT_DLTA_T [%d]\n", 
						STAT_RWRD_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_MIN_THT > STAT_ALLOWED_T)
            {
                TRL_TARG_BRK_PRE_RWRD_TIME = time();
                spawn SEND_EVT(TargHoldBrkPreRwrd_);

                printf("****STAT_RWRD_CHK[%d]: ERR sent Event: TargHoldBrkPreRwrd_[%d]\n", STAT_RWRD_CHK, TargHoldBrkPreRwrd_);
                printf("****STAT_RWRD_CHK[%d]: ERR (*Pre-Reward*Broke Target Fixation*)[%d]/[%d](TEMP_MIN_THT),[%d](TRL_RWRD_DELAY), STAT_DLTA_T [%d]\n", 
						STAT_RWRD_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    // Reward duration
    else if (STAT_DLTA_T > STAT_ALLOWED_T && STAT_DLTA_T <= TEMP_DELY_PLUS_DURATION)
    {
		// DO not give juice for NOGO trial
        if (!TRL_RWRD_ON_TIME && TRL_TYPE == TRIAL_TYPE_GO)
        {
            TRL_RWRD_ON_TIME = time();
            spawn JUICE(JUICE_CHANNEL, TEMP_RWRD_DURATION);
            spawn SEND_EVT(RewardOn_);
            printf("****STAT_RWRD_CHK[%d]: OK sent Event: RewardOn_[%d]\n", STAT_RWRD_CHK, RewardOn_);
        }

        if (!I_TARG && !TRL_IS_TARG_MIN_THT)
        {
            if (TEMP_MIN_THT > STAT_ALLOWED_T && TEMP_MIN_THT <= TEMP_DELY_PLUS_DURATION)
            {
                TRL_TARG_BRK_MIN_THT_TIME = time();
                spawn SEND_EVT(TargHoldBrkMinTHT_);
                printf("****STAT_RWRD_CHK[%d]: ERR sent Event: TargHoldBrkMinTHT_[%d]\n", STAT_RWRD_CHK, TargHoldBrkMinTHT_);
				printf("****STAT_RWRD_CHK[%d]: ERR (*Min_THT*Broke Target Fixation*--DURING--*)[%d]/[%d](TEMP_MIN_THT),[%d](TRL_RWRD_DELAY+TRL_RWRD_DURATION), STAT_DLTA_T [%d]\n",
						STAT_RWRD_CHK,TRL_TARG_HOLD_DURATION,TEMP_MIN_THT,TEMP_DELY_PLUS_DURATION,STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_MIN_THT > TEMP_DELY_PLUS_DURATION)
            {
                TRL_TARG_BRK_RWRD_TIME = time();
                spawn SEND_EVT(TargHoldBrkRwrd_);

                printf("****STAT_RWRD_CHK[%d]: ERR sent Event: TargHoldBrkRwrd_[%d][%d]\n", STAT_RWRD_CHK, TargHoldBrkRwrd_);
                printf("****STAT_RWRD_CHK[%d]: ERR (*During-Reward*Broke Target Fixation*)[%d]/[%d](TEMP_MIN_THT),[%d](TRL_RWRD_DELAY+TRL_RWRD_DURATION), STAT_DLTA_T [%d]\n",
				      STAT_RWRD_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    else if (STAT_DLTA_T > TEMP_DELY_PLUS_DURATION)   // after reward
    {
        if (!TRL_RWRD_OFF_TIME)
        {
            TRL_RWRD_OFF_TIME = time();
            spawn SEND_EVT(RewardOff_);

            printf("****STAT_RWRD_CHK[%d]: OK sent Event: RewardOff_[%d]\n", STAT_RWRD_CHK, RewardOff_);
        }
        if (TRL_IS_TARG_MIN_THT)
        {
            printf("****STAT_RWRD_CHK[%d]: OK (*SUCCESS**MIN_TARG_THT*Target Fixated*)[%d]/[%d](TEMP_MIN_THT),[%d](TRL_RWRD_DELAY+TRL_RWRD_DURATION), STAT_DLTA_T [%d]\n",
					STAT_RWRD_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
            PROCESS_STATE = 1;
            CURR_STAT     = STAT_OUTCOME;
        }

        if (STAT_DLTA_T <= TEMP_MIN_THT && TEMP_MIN_THT > TEMP_DELY_PLUS_DURATION && !TRL_IS_TARG_MIN_THT)
        {
            if (!I_TARG)
            {
                TRL_TARG_BRK_MIN_THT_TIME = time();
                spawn SEND_EVT(TargHoldBrkMinTHT_);

                printf("****STAT_RWRD_CHK[%d]: ERR sent Event: TargHoldBrkMinTHT_[%d]\n", STAT_RWRD_CHK, TargHoldBrkMinTHT_);
                printf("****STAT_RWRD_CHK[%d]: ERR (*Min_THT*Broke Target Fixation--POST--*)[%d]/[%d](TEMP_MIN_THT),[%d](TRL_RWRD_DELAY+TRL_RWRD_DURATION), STAT_DLTA_T [%d]\n",
					STAT_RWRD_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
} /* PROC_RWRD_CHK */
