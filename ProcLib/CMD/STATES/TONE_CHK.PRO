//==========================================================================
// TONE_CHK.PRO
//   Description: Process Tone state after Target is acquired. Eye is already in Target window
//                Gaze is in TARG_WIN. Check gaze until TONE_DELAY + TONE_DURATION expires,
//                play TONE depending on gaze and MIN_TARG_HOLD_TIME
// Gaze check:
// Fixspot is OFF Target is ON:
// Check:
//   case 0: MIN_TARG_HOLD_TIME <= TONE_DELAY
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Play (SUCCESS) TONE at TONE_DELAY time
//   case 1: MIN_TARG_HOLD_TIME <= TONE_DELAY + TONE_DURATION
//         if gaze in TARG_WIN until TONE_DURATION --> (SUCCESS-tone alredey delivered), goto STAT_RWRD_CHK
//         if gaze not in TARG_WIN during TONE_DURATION --> (SUCCESS-tone alredey delivered), compute TIMEOUT_TIME --> goto STAT_OUTCOME
//   case 2: MIN_TARG_HOLD_TIME > TONE_DELAY + TONE_DURATION
//         Goto next state (reward already delivered), goto STAT_RWRD_CHK
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

declare PROC_TONE_CHK();

declare int TEMP_TONE_DURATION;


process PROC_TONE_CHK()
{
    // Target acquired, but not fixated yet or gaze still in FixWin
    if (PROCESS_STATE)
    {
        printf("****STAT_TONE_CHK[%d]: Processing Tone times\n", STAT_TONE_CHK);
        // Keep independent of previous state times if any.
        PROCESS_STATE = 0;
        STAT_STRT_T   = time();
        STAT_DLTA_T   = 0;
        // Give tone after this time, unless Abort
        STAT_ALLOWED_T = TONE_DELAY * TIME_DILATE_FACTOR;
        // Tone already given, during tone check gaze
        TEMP_TONE_DURATION = TRL_TONE_DURATION * TIME_DILATE_FACTOR;

        TRL_TARG_HOLD_DURATION  = 1;                       // as target was already acquired in previous state
        TEMP_MIN_THT            = MIN_TARG_HOLD_TIME * TIME_DILATE_FACTOR;
        TEMP_DELY_PLUS_DURATION = STAT_ALLOWED_T + TEMP_TONE_DURATION;
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

            printf("****STAT_TONE_CHK[%d]: OK sent Event: TargHoldMinTHT_[%d]\n", STAT_TONE_CHK, TargHoldMinTHT_);
        }
    }

    // Tone delay
    if (STAT_DLTA_T <= STAT_ALLOWED_T)
    {
        if (!I_TARG && !TRL_IS_TARG_MIN_THT)
        {
            if (TEMP_MIN_THT <= STAT_ALLOWED_T)
            {
                TRL_TARG_BRK_MIN_THT_TIME = time();
                spawn SEND_EVT(TargHoldBrkMinTHT_);

                printf("****STAT_TONE_CHK[%d]: ERR sent Event: TargHoldBrkMinTHT_[%d]\n", STAT_TONE_CHK, TargHoldBrkMinTHT_);
                printf("****STAT_TONE_CHK[%d]: ERR (*Min_THT*Broke Target Fixation--PRE--*)[%d]/[%d](TEMP_MIN_THT),[%d](TONE_DELAY), STAT_DLTA_T [%d]\n", STAT_TONE_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_MIN_THT > STAT_ALLOWED_T)
            {
                TRL_TARG_BRK_PRE_TONE_TIME = time();
                spawn SEND_EVT(TargHoldBrkPreTone_);

                printf("****STAT_TONE_CHK[%d]: ERR sent Event: TargHoldBrkPreTone_[%d]\n", STAT_TONE_CHK, TargHoldBrkPreTone_);
                printf("****STAT_TONE_CHK[%d]: ERR (*Pre-Tone*Broke Target Fixation*)[%d]/[%d](TEMP_MIN_THT),[%d](TONE_DELAY), STAT_DLTA_T [%d]\n", STAT_TONE_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, STAT_ALLOWED_T, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    // Tone duration
    else if (STAT_DLTA_T > STAT_ALLOWED_T && STAT_DLTA_T <= TEMP_DELY_PLUS_DURATION)
    {
        // Reach here give GOOD tone, if entered this condition
        if (!TRL_TONE_ON_TIME)
        {
            TRL_TONE_ON_TIME = time();
            spawn TONE(TRL_TONE_FREQ, TEMP_TONE_DURATION);
            spawn SEND_EVT(ToneOn_);

            printf("****STAT_TONE_CHK[%d]: OK sent Event: ToneOn_[%d]\n", STAT_TONE_CHK, ToneOn_);
        }
        if (!I_TARG && !TRL_IS_TARG_MIN_THT)
        {
            if (TEMP_MIN_THT > STAT_ALLOWED_T && TEMP_MIN_THT <= TEMP_DELY_PLUS_DURATION)
            {
                TRL_TARG_BRK_MIN_THT_TIME = time();
                spawn SEND_EVT(TargHoldBrkMinTHT_);

                printf("****STAT_TONE_CHK[%d]: ERR sent Event: TargHoldBrkMinTHT_[%d]\n", STAT_TONE_CHK, TargHoldBrkMinTHT_);
                printf("****STAT_TONE_CHK[%d]: ERR (*Min_THT*Broke Target Fixation--DURING--*)[%d]/[%d](TEMP_MIN_THT),[%d](TONE_DELAY+TONE_DURATION), STAT_DLTA_T [%d]\n", STAT_TONE_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
            else if (TEMP_MIN_THT > TEMP_DELY_PLUS_DURATION)
            {
                TRL_TARG_BRK_TONE_TIME = time();
                spawn SEND_EVT(TargHoldBrkTone_);

                printf("****STAT_TONE_CHK[%d]: ERR sent Event: TargHoldBrkTone_[%d]\n", STAT_TONE_CHK, TargHoldBrkTone_);
                printf("****STAT_TONE_CHK[%d]: ERR (*During-Tone*Broke Target Fixation*)[%d]/[%d](TEMP_MIN_THT),[%d](TONE_DELAY+TONE_DURATION), STAT_DLTA_T [%d]\n", STAT_TONE_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
                PROCESS_STATE = 1;
                CURR_STAT     = STAT_OUTCOME;
            }
        }
    }
    else     // eye in Target win until TEMP_MIN_THT, or TEMP_MIN_THT is greater than TONE_DELAY+TONE_DURATION
    {
        printf("\n");
        TRL_TONE_OFF_TIME = time();
        spawn SEND_EVT(ToneOff_);

        printf("****STAT_TONE_CHK[%d]: OK sent Event: ToneOff_[%d]\n", STAT_TONE_CHK, ToneOff_);
        printf("****STAT_TONE_CHK[%d]: OK (*Tone*Target Fixated*)[%d]/[%d](TEMP_MIN_THT),[%d](TONE_DELAY+TONE_DURATION), STAT_DLTA_T [%d]\n", STAT_TONE_CHK, TRL_TARG_HOLD_DURATION, TEMP_MIN_THT, TEMP_DELY_PLUS_DURATION, STAT_DLTA_T);
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_RWRD_CHK;
    }
} /* PROC_TONE_CHK */
