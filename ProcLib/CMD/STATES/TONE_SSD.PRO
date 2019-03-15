//==========================================================================
// TONE_SSD.PRO
//   Description: Process Tone state after CANCEL time has expired for a STOP trial.
//                Eye is already in FIX window
//                Gaze is in FIX_WIN. Check gaze until  TRL_USE_TONE_DELAY+ TRL_USE_TONE_DURATION expires,
//                play TONE depending on gaze and TRL_USE_XTRA_HOLD_DURATION
// Gaze check:
// Signal is ON Target is ON:
// Check:
//   case 0: TRL_USE_XTRA_HOLD_DURATION <=  TRL_USE_TONE_DELAY
//         if gaze out of FIX_WIN before TRL_USE_XTRA_HOLD_DURATION expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in FIX_WIN until TRL_USE_XTRA_HOLD_DURATION expires: Play (SUCCESS) TONE at  TRL_USE_TONE_DELAY time
//   case 1: TRL_USE_XTRA_HOLD_DURATION <=  TRL_USE_TONE_DELAY+ TRL_USE_TONE_DURATION
//         if gaze in FIX_WIN until TRL_USE_TONE_DURATION --> (SUCCESS-tone alredey delivered), goto STAT_RWRD_SSD
//         if gaze not in FIX_WIN during TRL_USE_TONE_DURATION --> (SUCCESS-tone alredey delivered), compute TIMEOUT_TIME --> goto STAT_OUTCOME
//   case 2: TRL_USE_XTRA_HOLD_DURATION >  TRL_USE_TONE_DELAY+ TRL_USE_TONE_DURATION
//         Goto next state (reward already delivered), goto STAT_RWRD_SSD
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
//   Date: 2019-02-08
//==========================================================================
//  Revision History:

declare PROC_TONE_SSD();

declare int TEMP_TONE_DURATION;


process PROC_TONE_SSD()
{
    // Target acquired, but not fixated yet or gaze still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_TONE_SSD[%d]: Processing Tone times\n", STAT_TONE_SSD);
        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;
        // Give tone after this time, unless Abort
        STAT_ALLOWED_T =  TRL_USE_TONE_DELAY * TIME_DILATE_FACTOR;
        // Tone already given, during tone check gaze
        TEMP_TONE_DURATION = TRL_USE_TONE_DURATION * TIME_DILATE_FACTOR;

        TRL_FIX_HOLD_DURATION   = 1;                      // as target was already acquired in previous state
        TEMP_XTRA_HOLD_TIME           = TRL_USE_XTRA_HOLD_DURATION * TIME_DILATE_FACTOR;
        TEMP_DELY_PLUS_DURATION = STAT_ALLOWED_T+ TEMP_TONE_DURATION;

        TRL_USE_TONE_FREQ = CANCELLED_TONE_HZ;
        printf("****STAT_TONE_SSD[%d]: Processing Tone times; STOP Trial: %d Hz\n", STAT_TONE_SSD,TRL_USE_TONE_FREQ);
    }
    spawnwait CHECK_TARG_VERT_RFRSH();

    if (I_FIX)
    {
        TRL_FIX_HOLD_DURATION = TRL_FIX_HOLD_DURATION+ 1;
    }

    if (TRL_FIX_HOLD_DURATION > TEMP_XTRA_HOLD_TIME)
    {
        if (TRL_IS_FIX_MIN_SSHT<=0)
        {
            TRL_IS_FIX_MIN_SSHT   = 1;
            TRL_FIX_MIN_SSHT_TIME = time();
            spawn SEND_EVT(FixHoldMinSSHT_);

            printf("****STAT_TONE_SSD[%d]: OK sent Event: FixHoldMinSSHT_[%d]\n", STAT_TONE_SSD, FixHoldMinSSHT_);
        }
    }
	if (TRL_FIX_HOLD_DURATION < TEMP_XTRA_HOLD_TIME)
    {
		TRL_IS_FIX_MIN_SSHT   = 0;
	}

    // Tone delay
    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (!I_FIX && TRL_IS_FIX_MIN_SSHT<=0)
        {
            if (TEMP_XTRA_HOLD_TIME <= STAT_ALLOWED_T)
            {
                TRL_BRK_CANCEL_TIME = time();
                spawn SEND_EVT(FixHoldBrkMinSSHT_);

                printf("****STAT_TONE_SSD[%d]: ERR sent Event: FixHoldBrkMinSSHT_[%d]\n", STAT_TONE_SSD, FixHoldBrkMinSSHT_);
                printf("****STAT_TONE_SSD[%d]: ERR (*Min_SSHT*Broke Fixation--PRE--*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d] (TRL_USE_TONE_DELAY), STAT_DLTA_T [%d]\n", STAT_TONE_SSD,
						TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_XTRA_HOLD_TIME > STAT_ALLOWED_T)
            {
                TRL_BRK_PRE_TONE_TIME = time();
                spawn SEND_EVT(FixHoldBrkPreTone_);

                printf("****STAT_TONE_SSD[%d]: ERR sent Event: FixHoldBrkPreTone_[%d]\n", STAT_TONE_SSD, FixHoldBrkPreTone_);
                printf("****STAT_TONE_SSD[%d]: ERR (*Pre-Tone*Broke Fixation*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d] (TRL_USE_TONE_DELAY), STAT_DLTA_T [%d]\n", STAT_TONE_SSD,
						TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    // Tone duration
    else if (STAT_DLTA_T > STAT_ALLOWED_T && STAT_DLTA_T <= TEMP_DELY_PLUS_DURATION)
    {
        // Reach here give GOOD tone, if entered this condition
        if (TRL_TONE_ON_TIME<=0)
        {
            TRL_TONE_ON_TIME = time();
            spawn TONE(TRL_USE_TONE_FREQ, TEMP_TONE_DURATION);
            spawn SEND_EVT(ToneOn_);

            printf("****STAT_TONE_SSD[%d]: OK sent Event: ToneOn_[%d]\n", STAT_TONE_SSD, ToneOn_);
        }
        if (!I_FIX && TRL_IS_FIX_MIN_SSHT<=0)
        {
            if (TEMP_XTRA_HOLD_TIME > STAT_ALLOWED_T && TEMP_XTRA_HOLD_TIME <= TEMP_DELY_PLUS_DURATION)
            {
                TRL_BRK_CANCEL_TIME = time();
                spawn SEND_EVT(FixHoldBrkMinSSHT_);

                printf("****STAT_TONE_SSD[%d]: ERR sent Event: FixHoldBrkMinSSHT_[%d]\n", STAT_TONE_SSD, FixHoldBrkMinSSHT_);
                printf("****STAT_TONE_SSD[%d]: ERR (*Min_SSHT*Broke Fixation--DURING--*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d] (TRL_USE_TONE_DELAY), STAT_DLTA_T [%d]\n", STAT_TONE_SSD,
						TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_XTRA_HOLD_TIME > TEMP_DELY_PLUS_DURATION)
            {
                TRL_BRK_TONE_TIME = time();
                spawn SEND_EVT(FixHoldBrkTone_);

                printf("****STAT_TONE_SSD[%d]: ERR sent Event: FixHoldBrkTone_[%d]\n", STAT_TONE_SSD, FixHoldBrkTone_);
                printf("****STAT_TONE_SSD[%d]: ERR (*During-Tone*Broke Fixation*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d] (TRL_USE_TONE_DELAY+TRL_USE_TONE_DURATION), STAT_DLTA_T [%d]\n", STAT_TONE_SSD,
						TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    else     // eye in Fix win until TEMP_XTRA_HOLD_TIME, or TEMP_XTRA_HOLD_TIME is greater than  TRL_USE_TONE_DELAY+TRL_USE_TONE_DURATION
    {
        printf("\n");
        TRL_TONE_OFF_TIME = time();
        spawn SEND_EVT(ToneOff_);

        printf("****STAT_TONE_SSD[%d]: OK sent Event: ToneOff_[%d]\n", STAT_TONE_SSD, ToneOff_);
        printf("****STAT_TONE_SSD[%d]: OK (*Tone* Fixation maintained*)[%d]/[%d](TEMP_XTRA_HOLD_TIME),[%d] (TRL_USE_TONE_DELAY+TRL_USE_TONE_DURATION), STAT_DLTA_T [%d]\n", STAT_TONE_SSD,
				TRL_FIX_HOLD_DURATION, TEMP_XTRA_HOLD_TIME, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_RWRD_SSD;
    }
} /* PROC_TONE_SSD */
