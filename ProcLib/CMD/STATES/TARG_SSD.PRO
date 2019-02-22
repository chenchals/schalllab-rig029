//==========================================================================
// TARG_SSD.PRO
//   Description: Process Target On State for STOP Trial
//                Eye has to HOLD fixation till TRL_STOP_SIGNAL_DELAY + FIX_HOLD_FOR_CANCEL.
//                After TRL_STOP_SIGNAL_DELAY, PG_SIGNAL_PD is shown (TRL_IS_STOP_SIGNAL_ON =1)
//                Gaze has to be in FIX_WIN for the whole duration for the successful Cancel trial.
//                If Gaze out of Fix win before time expires, then subject made a NoGo type Saccade
//                based on MIN_SACC_TIME and MAX_SACC_TIME
// Gaze Check:
// Fixspot is OFF Target is ON:
// Check: Gaze in FIX window until MIN_SACCADE_TIME expires, else it is early saccade
//        Gaze left FIX_WIN before MAX_SACCADE_TIME, then correct saccade, else no saccade
// Check:
//   case 0: TRL_STOP_SIGNAL_DELAY has not expired
//                   if gaze out of FIX-WIN before MIN_SACC_TIME --> NoGoEarlySaccade_, goto STAT_OUTCOME
//                   if gaze out of FIX-WIN after MIN_SACC_TIME and before MAX_SACC_TIME --> NoGoSaccade_, goto STAT_TARG_ACQ
//                   if gaze out of FIX-WIN after MAX_SACC_TIME --> NoGoLateSaccade_, goto STAT_OUTCOME
//   case 1: TRL_STOP_SIGNAL_DELAY has expired and FIX_HOLD_FOR_CANCEL has not expired
//   [Stop Signal ON] show PG_SIGNAL_PD (PD on RIGHT) for 1 screen refresh and switch to PG_SIGNAL(PD on LEFT)
//                   if gaze out of FIX-WIN before MIN_SACC_TIME --> NoGoEarlySaccade_, goto STAT_OUTCOME
//                   if gaze out of FIX-WIN after MIN_SACC_TIME and before MAX_SACC_TIME --> NoGoSaccade_, goto STAT_TARG_ACQ
//   [Stop Signal OFF] switch page from PG_SIGNAL to PG_TARGET_PD (do nto show stop signal)
//                   if gaze out of FIX-WIN after MAX_SACC_TIME --> NoGoLateSaccade_, goto STAT_OUTCOME
//
//                All Global variables and the following state variables are available to monitor state progress
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
//   Date: 2019-01-25
//==========================================================================
//  Revision History:

declare PROC_TARG_SSD();
declare PRINT_MSG();
declare SSD_CHECK_SACC();


process PROC_TARG_SSD()
{
    if (PROCESS_STATE)
    {
        printf("****STAT_TARG_SSD[%d]: STOP TRIAL Processing Target On SSD\n", STAT_TARG_SSD);
        TRL_PRE_TARG_ON_TIME = time();
        spawn SEND_EVT(TargetPre_);

        dsendf("vp %d\n", PG_TARGET_PD);
        spawn GRAF_SHOW_FIX(GRAF_HIDE);
        spawn GRAF_SHOW_TARG(GRAF_SHOW);

        PROCESS_STATE           = 0;
        STAT_DLTA_T             = 0;
        STAT_STRT_T             = TRL_PRE_TARG_ON_TIME;
        STAT_I_DURATION         = MIN_SACC_TIME * TIME_DILATE_FACTOR;
        STAT_I_DURATION2        = MAX_SACC_TIME * TIME_DILATE_FACTOR;
        STAT_ALLOWED_T          = ceil(TRL_STOP_SIGNAL_DELAY * REFRESH_RATE * TIME_DILATE_FACTOR);
        TEMP_DELY_PLUS_DURATION = STAT_ALLOWED_T + (FIX_HOLD_FOR_CANCEL * TIME_DILATE_FACTOR);
    }

    spawnwait CHECK_TARG_VERT_RFRSH();
    // keep track of stop signal duration in ms and in vertical refresh count
    if (!TRL_IS_STOP_SIGNAL_ON)
    {
        TRL_TARG_SSD_VRT_RFRSH_COUNT = TRL_TARG_VRT_RFRSH_COUNT;
        TRL_STOP_SIGNAL_DURATION     = TRL_STOP_SIGNAL_DURATION + 1;
    }
    // keep track of target vertical refresh count
    if (TRL_TARG_VRT_RFRSH_COUNT == 1 && !TRL_TARG_ON_TIME)
    {
        TRL_TARG_ON_TIME = time();
        printf("****STAT_TARG_SSD[%d]: Sending Event Target_[%d], Time [%d]\n", STAT_TARG_SSD, Target_, TRL_TARG_ON_TIME);
        spawn SEND_EVT(Target_);

        printf("****STAT_TARG_SSD[%d]: Sending Event FixSpotOff_[%d], Time [%d]\n", STAT_TARG_SSD, FixSpotOff_, TRL_TARG_ON_TIME);
        spawn SEND_EVT(FixSpotOff_);
    }
    if (STAT_DLTA_T <= STAT_ALLOWED_T)    // || TRL_TARG_VRT_RFRSH_COUNT < TRL_STOP_SIGNAL_DELAY)
    {
        // till it is time to show stop signal
        if (!I_FIX)
        {
            spawnwait SSD_CHECK_SACC();
        }
    }
    else if (STAT_DLTA_T > STAT_ALLOWED_T && STAT_DLTA_T <= TEMP_DELY_PLUS_DURATION)
    {
        // from SSD till it is time to expire Cancel time for trial to be considered successful cancel
        if (!TRL_STOP_SIGNAL_TIME)
        {
            TRL_STOP_SIGNAL_TIME = time();
            spawn SEND_EVT(StopSignal_);

            dsendf("vp %d\n", PG_SIGNAL_PD);
            dsendf("vw 1\n");
            dsendf("vp %d\n", PG_SIGNAL);
            printf("****STAT_TARG_SSD[%d]: OK sent Event: StopSignal_[%d], Time [%d]\n", STAT_TARG_SSD, StopSignal_,TRL_STOP_SIGNAL_TIME);
            printf("****STAT_TARG_SSD[%d]: OK (*Stop signal page sent*)[%d]/[%d] (TRL_STOP_SIGNAL_DURATION)\n", STAT_TARG_SSD, STAT_DLTA_T, TRL_STOP_SIGNAL_DURATION);
		}
        // till Cancel time is expired and the stop signal is shown
        if (!I_FIX && TRL_IS_STOP_SIGNAL_ON)
        {
            spawnwait SSD_CHECK_SACC();
        }
    }
    else if (STAT_DLTA_T > TEMP_DELY_PLUS_DURATION)
    {
        // if reached here then it is a successful cancel  trial
        if (I_FIX)
        {
            TRL_CANCEL_TIME = time();
            spawn SEND_EVT(Cancel_);

            PROCESS_STATE = 1;
            CURR_STAT     = STAT_TONE_SSD;

            printf("****STAT_TARG_SSD[%d]: OK sent Event: Cancel_[%d],Time [%d]\n", STAT_TARG_SSD, Cancel_,TRL_CANCEL_TIME);
            printf("****STAT_TARG_SSD[%d]: OK (Cancel_ in)[%d]/[%d](TRL_STOP_SIGNAL_DELAY + FIX_HOLD_FOR_CANCEL)\n", STAT_TARG_SSD, STAT_DLTA_T, TEMP_DELY_PLUS_DURATION);
            spawn PRINT_MSG();
        }
        else
        {
			printf("STAT_DLTA_T > TEMP_DELY_PLUS_DURATION\n");
            spawnwait SSD_CHECK_SACC();
        }
    }

} /* PROC_TARG_SSD */


process SSD_CHECK_SACC()
{
    if (STAT_DLTA_T <= STAT_I_DURATION)
    {
        // Early saccade
        TRL_I_IN_FLIGHT         = 1;
        TRL_NOGO_ERLY_SACC_TIME = time();
        spawn SEND_EVT(NoGoEarlySaccade_);

        printf("****STAT_TARG_SSD[%d]: ERR sent Event: NoGoEarlySaccade_[%d]\n", STAT_TARG_SSD, NoGoEarlySaccade_);
        printf("****STAT_TARG_SSD[%d]: ERR (*NoGo Early Saccade*)[%d]/[%d] (MIN_SACC_TIME)\n", STAT_TARG_SSD, STAT_DLTA_T, STAT_I_DURATION);
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_OUTCOME;
        spawn PRINT_MSG();
    }
    else if (STAT_DLTA_T > STAT_I_DURATION && STAT_DLTA_T <= STAT_I_DURATION2)
    {
        TRL_I_IN_FLIGHT    = 1;
        TRL_NOGO_SACC_TIME = time();
        spawn SEND_EVT(NoGoSaccade_);

        printf("****STAT_TARG_SSD[%d]: ERR sent Event: NoGoSaccade_[%d]\n", STAT_TARG_SSD, NoGoSaccade_);
        if (TRL_IS_STOP_SIGNAL_ON)
        {
            // Flip page to PG_TARG_PD and continue as a GO trial
            printf("****STAT_TARG_SSD[%d]: ERR: (*NoGo Saccade**After SSD*)[%d]/[%d, %d] (MIN_SACC_TIME, MAX_SACC_TIME)\n", STAT_TARG_SSD, STAT_DLTA_T, STAT_I_DURATION, STAT_I_DURATION2);
            printf("****STAT_TARG_SSD[%d]: ERR: (*NoGo Saccade**After SSD*). Flipping page to PG_TARGET_PD\n", STAT_TARG_SSD);
            dsendf("vp %d\n", PG_TARGET_PD);
            spawn GRAF_SHOW_FIX(GRAF_HIDE);
            spawn GRAF_SHOW_TARG(GRAF_SHOW);
			spawn PRINT_MSG();
        }
        else
        {
            printf("****STAT_TARG_SSD[%d]: ERR: (*NoGo Saccade**Before SSD*)[%d]/[%d, %d] (MIN_SACC_TIME, MAX_SACC_TIME)\n", STAT_TARG_SSD, STAT_DLTA_T, STAT_I_DURATION, STAT_I_DURATION2);
        }
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_TARG_ACQ;
        spawn PRINT_MSG();
    }
    else if (STAT_DLTA_T > STAT_I_DURATION2)
    {
        // Late saccade
        TRL_I_IN_FLIGHT         = 1;
        TRL_NOGO_LATE_SACC_TIME = time();
        spawn SEND_EVT(NoGoLateSaccade_);

        printf("****STAT_TARG_SSD[%d]: ERR sent Event: NoGoLateSaccade_[%d]\n", STAT_TARG_SSD, NoGoLateSaccade_);
        printf("****STAT_TARG_SSD[%d]: ERR (*NoGo Late Saccade*)[%d]/[%d] (MAX_SACC_TIME)\n", STAT_TARG_SSD, STAT_DLTA_T, STAT_I_DURATION2);
        PROCESS_STATE = 1;
        CURR_STAT     = STAT_OUTCOME;
        spawn PRINT_MSG();
    }
}/* SSD_CHECK_SACC */


process PRINT_MSG()
{
    printf("****STAT_TARG_SSD[%d]: STOP TRIAL; TRL_STOP_SIGNAL_DELAY = (TRL_STOP_SIGNAL_DELAY * REFRESH_RATE)\n", STAT_TARG_SSD);
    printf("****STAT_TARG_SSD[%d]: Expected SSD = TRL_STOP_SIGNAL_DELAY[%d, %dms]\n", STAT_TARG_SSD, TRL_STOP_SIGNAL_DELAY * TIME_DILATE_FACTOR, STAT_ALLOWED_T);
    printf("****STAT_TARG_SSD[%d]: SSD (using nexttick count)  = TRL_STOP_SIGNAL_DURATION[%d, %dms],  \n", STAT_TARG_SSD, TRL_TARG_VRT_RFRSH_COUNT, TRL_STOP_SIGNAL_DURATION);
    printf("****STAT_TARG_SSD[%d]: SSD (using SSD Vertical Refresh count) TRL_TARG_SSD_VRT_RFRSH_COUNT[%d, %dms] \n", STAT_TARG_SSD, TRL_TARG_SSD_VRT_RFRSH_COUNT, ceil(TRL_TARG_SSD_VRT_RFRSH_COUNT * REFRESH_RATE));
    printf("****STAT_TARG_SSD[%d]: SSD + CANCEL TIME [%d + %d] = [%dms] \n", STAT_TARG_SSD, 
	       ceil(TRL_STOP_SIGNAL_DELAY * REFRESH_RATE * TIME_DILATE_FACTOR),(FIX_HOLD_FOR_CANCEL * TIME_DILATE_FACTOR),TEMP_DELY_PLUS_DURATION );
	printf("****STAT_TARG_SSD[%d]: Target ON duration   = TRL_TARG_ON_DURATION [%dms],  \n", STAT_TARG_SSD, TRL_TARG_ON_DURATION);
    printf("****STAT_TARG_SSD[%d]: Target ON duration (using Vertical Refresh count) TRL_TARG_VRT_RFRSH_COUNT[%d, %dms] \n", STAT_TARG_SSD, TRL_TARG_VRT_RFRSH_COUNT, ceil(TRL_TARG_VRT_RFRSH_COUNT * REFRESH_RATE));
}/* PRINT_MSG */
