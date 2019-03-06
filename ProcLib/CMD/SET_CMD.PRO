//==========================================================================
// SET_CMD.PRO
//   Description: Setup All variables, procs for Countermanding task.
//
//   NOTE:
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-24
//==========================================================================
//  Revision History:

// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/CONSTNTS.PRO
// CMD Vars only...?
#include C:/TEMPO/ProcLib/CMD/VAR_CMD.PRO
// State defs
#include C:/TEMPO/ProcLib/CMD/STATES/CMD_STAT.PRO
// Rig specific vars for colors, mainly
#include C:/TEMPO/ProcLib/RIG/VAR_RIG.PRO
// Stimulus Variables: fixation, target, photodiode
#include C:/TEMPO/ProcLib/CMD/VAR_STIM.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/CMD/SET_CLRS.PRO
// Setup GRAPHS - referenced by _PGS
#include C:/TEMPO/ProcLib/GRAFS/GRAPHS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
// Setup event defs so events can be sent
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO

//=====Now do monk specific========
// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/RIG/SET_RIG.PRO
// Set monk
#include C:/TEMPO/ProcLib/MONK/SET_MONK.PRO

//========other utils=============
// Send event processes
#include C:/TEMPO/ProcLib/UTIL/SEND_EVT.PRO
// Jitter utils
#include C:/TEMPO/ProcLib/UTIL/JITTER.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_EYE.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_PD.PRO

declare SET_CMD_TRL();
declare INIT_TRL_VARS();
declare PCK_TRL_TYPE();
declare COMPUTE_FIX_HOLD();
declare SET_TARGET();
declare SET_WINS();
declare PICK_TRL_SSD();
declare SET_TONE_DELAY();
declare SET_RWRD_DELAY();

// min stop signal hold time
declare COMPUTE_MIN_SSHT();

// set FIX_HOLD_FOR_CANCEL from SSD_CANCEL_TIME
declare SET_MIN_MAX_SSD();
declare SET_CANCEL_TIME();

// min target hold time
declare COMPUTE_MIN_THT();

// Compute the max. trial duration
declare COMPUTE_TRL_DURATION();

// A temporary state acitivity
declare int PROCESS_STATE;
declare int TRL_NUMBER = 0;
declare int TRL_TYPE;
declare int TRL_RUNNING;
declare int TRL_TARG_VR_COUNT_TIME;
// increment trial target on duration flag
// =1 first time PD_TRIG_L is detected for Target on page
// =0 first rime PD_TRIG_R is detected for Stop signal page
// =0 when blank page for GO trial?
declare int TRL_IS_TARG_ON_FLAG;
declare int TRL_IS_TARG_ACQUIRED;
declare int TRL_IS_FIX_ACQUIRED;
declare int TRL_I_IN_FLIGHT;
// gaze fulfilled min_targ_hold_time
declare int TRL_IS_TARG_MIN_THT;

declare int TRL_IS_TIMEOUT;
declare int TRL_IS_STOP_SIGNAL_ON;
declare int TRL_STOP_SIGNAL_TIME;
declare int TRL_STOP_SIGNAL_DELAY;
declare int TRL_STOP_SIGNAL_DURATION;

declare int TRL_IS_NON_CANCELLED;
declare int TRL_IS_CANCELLED;

// Trial Timees
declare int TRL_CUM_TIME;
// Computed Trial length using max times as defined in VAR_CMD
// This variable is used for every trial to determine:
// if IS_TRL_LENGTH_FIXED = 1 then ITI =  TRL_DURATION - TRL_CUM_TIME
// if IS_TRL_LENGTH_FIXED = 0 then ITI = BASE_ITI_TIME
declare int TRL_DURATION;
// time trial started
declare int TRL_START_TIME;
// time trial ended same as Eot_?
declare int TRL_END_TIME;
// time monitoring eye to be outside Fix window wide
declare int TRL_GET_READY_TIME;
// gaze outside fix window for the duration of READY_TIME
declare int TRL_READY_TIME;
// how long gaze was outside FIX_WIN_LARGE
declare int TRL_GET_READY_DURATION;
// time fixspot was first ON
declare int TRL_FIX_ON_TIME;
// gaze on fixspot
declare int TRL_FIX_ACQ_TIME;
// gaze NOT on fixspot
declare int TRL_FIX_ACQ_ERROR_TIME;
// Fix hold time for this trial
declare int TRL_FIX_HOLD_TIME;
// fixation achieved gaze in FIX_WIN for FIXTIME
declare int TRL_FIXATED_TIME;
// how long gaze was in fix window
declare int TRL_FIX_HOLD_DURATION;
// when was gaze broken before TARG_ON
declare int TRL_FIX_BRK_TIME;

// when command sent to vdosync
declare int TRL_PRE_TARG_ON_TIME;
// when PD trigger occurs
declare int TRL_TARG_ON_TIME;
// Actively count how long target was on
declare int TRL_TARG_ON_DURATION;
// saccade entered target window
declare int TRL_DECIDE_TIME;
// saccde left Fix window between MIN_MAX saccade time
declare int TRL_SACC_TIME;
// saccade left Fix window before MIN saccade time
declare int TRL_ERLY_SACC_TIME;
// saccade left Fix window after MAX saccade time
declare int TRL_LATE_SACC_TIME;
// should make a saccade, but eye still in Fix window
declare int TRL_NO_SACC_TIME;
// falg to know if saccade was OK, and it landed on Target regardless on NONCANCELLED outcome
declare int TRL_STAIRCASE_SSD_FLAG;
// saccade left Fix window, but eye not in Target window
declare int TRL_TARG_ACQ_ERROR_TIME;
// saccade dutation
declare int TRL_SACC_DURATION;
// saccade made within max saccade duration
declare int TRL_TARG_ACQ_TIME;
// target was fixated for this amount of time
declare int TRL_TARG_HOLD_DURATION;
// Punishment DURATION
declare int TRL_TIMEOUT_START_TIME;
declare int TRL_TIMEOUT_END_TIME;
declare int TRL_TIMEOUT_DURATION;

// target fixation broken or not
declare int TRL_TARG_MIN_THT_TIME;
declare int TRL_TARG_BRK_TIME;
declare int TRL_TARG_BRK_PRE_TONE_TIME;
declare int TRL_TARG_BRK_TONE_TIME;
declare int TRL_TARG_BRK_PRE_RWRD_TIME;
declare int TRL_TARG_BRK_RWRD_TIME;
declare int TRL_TARG_BRK_POST_RWRD_TIME;
declare int TRL_TARG_BRK_MIN_THT_TIME;
// Stop signal task
// saccde left Fix window between MIN_MAX saccade time
declare int TRL_NOGO_SACC_PRE_SSD_TIME;
declare int TRL_NOGO_SACC_POST_SSD_TIME;
// saccade left Fix window before MIN saccade time
declare int TRL_NOGO_ERLY_SACC_TIME;
// saccade left Fix window after MAX saccade time
declare int TRL_NOGO_LATE_SACC_TIME;
// fixspot was fixated for this amount of time *After* Cancel time
declare int TRL_FIX_HOLD_DURATION;
declare int TRL_FIX_MIN_SSHT_TIME;
declare int TRL_FIX_BRK_PRE_TONE_TIME;
declare int TRL_FIX_BRK_TONE_TIME;
declare int TRL_FIX_BRK_PRE_RWRD_TIME;
declare int TRL_FIX_BRK_RWRD_TIME;
declare int TRL_FIX_BRK_POST_RWRD_TIME;
declare int TRL_FIX_BRK_MIN_SSHT_TIME;
declare int TRL_CANCEL_TIME;
// gaze fulfilled min_stop_signal_hold_time
declare int TRL_IS_FIX_MIN_SSHT;
// Tone and reward times
declare int TRL_TONE_DELAY;
declare int TRL_TONE_FREQ;
declare int TRL_TONE_DURATION;
declare int TRL_TONE_ON_TIME;
declare int TRL_TONE_OFF_TIME;
declare int TRL_RWRD_DELAY;
declare int TRL_RWRD_DURATION;
declare int TRL_RWRD_ON_TIME;
declare int TRL_RWRD_OFF_TIME;
declare int TRL_XTRA_RWRD_ON_TIME;
declare int TRL_XTRA_RWRD_OFF_TIME;
declare int TRL_ITI_START_TIME;
declare int TRL_ITI_END_TIME;
declare int TRL_ITI_DURATION;
// TRL_TARG_ACQ_TIME - TRL_SACC_TIME (When subject made a saccade to target)
declare int TRL_REACTION_TIME;
// any break fixations?
declare int TRL_ABORT_TIME;
// number of vertical refreshs FIX with PD was on
declare int TRL_FIX_VRT_RFRSH_COUNT;
// number of vertical refreshs TARGET with PD was on
declare int TRL_TARG_VRT_RFRSH_COUNT;
// number of vertical refreshs TARGET with PD was on when stop-signal page was shown
declare int TRL_TARG_SSD_VRT_RFRSH_COUNT;
// code trial outcome as event code
declare int TRL_OUTCOME_EVNTCODE;
// Other variables for trial to use for staircasing in next session
declare int TRL_PREV_TRL_TYPE;
declare int TRL_PREV_OUTCOME_EVNTCODE;
declare int TRL_LAST_STOP_OUTCOME_EVNTCODE;
declare int TRL_LAST_GO_OUTCOME_EVNTCODE;
// Trial counts for session
declare int SESS_N_GO_TRLS;
declare int SESS_N_GO_CORRECT_TRLS;
declare int SESS_N_GO_ERROR_TRLS;
declare int SESS_N_STOP_TRLS;
declare int SESS_N_CANCEL_TRLS;
declare int SESS_N_NON_CANCEL_TRLS;
declare int SESS_N_NOGO_ERROR_TRLS;


process SET_CMD_TRL()
{
    declare int tempCount;

    // Initialize all trial variables
    spawnwait INIT_TRL_VARS();

    // Setup trial type
    spawnwait PCK_TRL_TYPE();

    // Compute TRL_FIX_HOLD_TIME;
    spawnwait COMPUTE_FIX_HOLD();

    // Setup TARGET
    spawnwait SET_TARGET();

    // Update graph object for Target
    // Show the windows - without the fixspot or target to cue user
    spawnwait GRAF_UPD8_FIX();
    spawnwait GRAF_UPD8_TARG();

    spawnwait SET_TONE_DELAY();
    spawnwait SET_RWRD_DELAY();

    TRL_TONE_DURATION = TONE_DURATION;
    TRL_RWRD_DURATION = RWRD_DURATION;

    if (TRL_TYPE == TRIAL_TYPE_STOP)
    {
        SESS_N_STOP_TRLS = SESS_N_STOP_TRLS + 1;
        spawnwait SET_CANCEL_TIME();

        // Compute MIN_STOP_SIGNAL_HOLD_TIME
        spawnwait COMPUTE_MIN_SSHT();
        spawnwait PICK_TRL_SSD();
    }
    else
    {
        SESS_N_GO_TRLS        = SESS_N_GO_TRLS + 1;
        TRL_STOP_SIGNAL_DELAY = 0;
    }
    // Compute this for both STOP and GO trials
    // Compute MIN_TARG_HOLD_TIME
    spawnwait COMPUTE_MIN_THT();

    // Setup CMD PAGES
    //printf("Calling CMD-PGS\n");
    spawnwait CMD_PGS();

    // compute trial duration (mainly for fixed trial length)
    spawnwait COMPUTE_TRL_DURATION();

    //printf("TRL_TYPE %d, CURR_TARG_IDX %d, CURR_TARG_ANGLE %d\n", TRL_TYPE, CURR_TARG_IDX, CURR_TARG_ANGLE);
} /* SET_CMD_TRL */


process COMPUTE_TRL_DURATION()
{
    declare int tempVar;

    // TRL_DURATION is computed *after* Fixation is acquired, using all max times
    // same for GO/STOP
    TRL_DURATION = MIN_MAX_FIX_HOLD_TIME[1] + BASE_ITI_TIME;
    // Since FIX_HOLD_FOR_CANCEL must be => MAX_SACC_TIME + MAXS_SACC_DURATION
    TRL_DURATION = TRL_DURATION + FIX_HOLD_FOR_CANCEL;
    // Add max ssd delay as this will be the longest TRL duration
    TRL_DURATION = TRL_DURATION + ceil(MAX_SSD * REFRESH_RATE);

    // now check for the longest time of the following
    tempVar = TONE_DELAY_MEAN +  TONE_DELAY_VARIANCE + TONE_DURATION;
	tempVar = tempVar + RWRD_DELAY_MEAN + RWRD_DELAY_VARIANCE + RWRD_DURATION;
    if (MIN_TARG_HOLD_TIME > tempVar)
    {
        tempVar = MIN_TARG_HOLD_TIME;
    }
    if (MIN_STOP_SIGNAL_HOLD_TIME > tempVar)
    {
        tempVar = MIN_STOP_SIGNAL_HOLD_TIME;
    }
    TRL_DURATION = TRL_DURATION + tempVar;

    if (IS_TRL_LENGTH_FIXED)
    {
        if (TRL_DURATION > FIXED_TRL_LENGTH_TIME)
        {
            TRL_DURATION = TRL_DURATION;
            // error alert user that for fixed trial length duration, the computed TRL_LENGTH_TIME > than that specified
            // TRL_DURATION adjusted to
            //printf("**********FIXED_TRL_LENGTH_TIME CHANGE ALERT********************\n");
            //printf("****SET_CMD/COMPUTE_TRL_DURATION: IS_TRL_LENGTH_FIXED [%d]****\n", IS_TRL_LENGTH_FIXED);
            //printf("****SET_CMD/COMPUTE_TRL_DURATION: Computed trial length time[%d] exceeds FIXED_TRL_LENGTH_TIME [%d]****\n", TRL_DURATION, FIXED_TRL_LENGTH_TIME);
            //printf("****SET_CMD/COMPUTE_TRL_DURATION: Using TRL_DURATION of [%d] ms for computing ITI (as IS_TRL_LENGTH_FIXED = 1)****\n", TRL_DURATION, IS_TRL_LENGTH_FIXED);
        }
        else
        {
            TRL_DURATION = FIXED_TRL_LENGTH_TIME;
        }
    }
} /* COMPUTE_TRL_DURATION */


process SET_CANCEL_TIME()
{
    declare int tempVar;

    spawnwait SET_MIN_MAX_SSD();

    // shorted cancel time relative to Target on is
    // must be greater than MAX_SACC_TIME
    //declare int SSD_CANCEL_TIME = 1500;
    //declare int FIX_HOLD_FOR_CANCEL;
    //printf("****SET_CMD/SET_CANCEL_TIME: Checking min CANCEL time > MAX_SACC_TIME****\n");
    //printf("****SET_CMD/SET_CANCEL_TIME: min CANCEL time = ceil(MIN_SSD * REFRESH_RATE) + SSD_CANCEL_TIME****\n");
    tempVar = ceil(MIN_SSD * REFRESH_RATE) + SSD_CANCEL_TIME;
    if (tempVar < MAX_SACC_TIME + MAX_SACC_DURATION)
    {
        //printf("**********CANCEL_TIME CHANGE ALERT********************\n");
        //printf("****SET_CMD/SET_CANCEL_TIME: min CANCEL time [%d] is less than MAX_SACC_TIME + MAX_SACC_DURATION [%d]****\n", tempVar, MAX_SACC_TIME + MAX_SACC_DURATION);
        FIX_HOLD_FOR_CANCEL = (MAX_SACC_TIME + MAX_SACC_DURATION) - ceil(MIN_SSD * REFRESH_RATE);
        //printf("****SET_CMD/SET_CANCEL_TIME: Using CANCEL time [%d] instead of SSD_CANCEL_TIME[%d]****\n", FIX_HOLD_FOR_CANCEL, SSD_CANCEL_TIME);
    }
    else
    {
        FIX_HOLD_FOR_CANCEL = SSD_CANCEL_TIME;
        //printf("****SET_CMD/SET_CANCEL_TIME: Using CANCEL time as SSD_CANCEL_TIME[%d]****\n", SSD_CANCEL_TIME);
    }
}


// set FIX_HOLD_FOR_CANCEL from SSD_CANCEL_TIME
process SET_MIN_MAX_SSD()
{
    declare int tempCount;

    tempCount = 0;
    MIN_SSD   = SSD_ARRY[tempCount];
    MAX_SSD   = SSD_ARRY[tempCount];
    tempCount = 1;
    N_SSD     = 1;
    while (tempCount < N_SSD_MAX)
    {
        if (SSD_ARRY[tempCount] > 0)
        {
            N_SSD = N_SSD + 1;
            if (SSD_ARRY[tempCount] > MAX_SSD)
            {
                MAX_SSD = SSD_ARRY[tempCount];
            }
            if (SSD_ARRY[tempCount] < MIN_SSD)
            {
                MIN_SSD = SSD_ARRY[tempCount];
            }
        }
        tempCount = tempCount + 1;
    }
    //printf("****SET_CMD/SET_MIN_MAX_SSD: MIN_SSD, MAX_SSD[in vert refresh] = [%d, %d]****\n", MIN_SSD, MAX_SSD);
}


process COMPUTE_MIN_SSHT()
{
	declare int tempVar;
	tempVar = TONE_DELAY_MEAN + TONE_DELAY_VARIANCE + TONE_DURATION;
	tempVar = tempVar + RWRD_DELAY_MEAN + RWRD_DELAY_VARIANCE + RWRD_DURATION;
	
    MIN_STOP_SIGNAL_HOLD_TIME = USE_TONE_AND_RWRD_FOR_MIN_THT * (tempVar) + BASE_STOP_SIGNAL_HOLD_TIME;
}/* COMPUTE_MIN_SSHT */


process COMPUTE_MIN_THT()
{
	declare int tempVar;
	tempVar = TONE_DELAY_MEAN + TONE_DELAY_VARIANCE + TONE_DURATION;
	tempVar = tempVar + RWRD_DELAY_MEAN + RWRD_DELAY_VARIANCE + RWRD_DURATION;

    MIN_TARG_HOLD_TIME = USE_TONE_AND_RWRD_FOR_MIN_THT * (tempVar) + BASE_TARG_HOLD_TIME;
}/* COMPUTE_MIN_THT */


process SET_TONE_DELAY()
{
    if (TONE_JITTER_FLAG == JITTER_GAUSS_FLAG)
    {
        spawnwait GAUSS_JITTER(TONE_DELAY_MEAN, TONE_DELAY_VARIANCE);
    }
    else if (TONE_JITTER_FLAG == JITTER_UNIFORM_FLAG)
    {
        spawnwait UNIFORM_JITTER(TONE_DELAY_MEAN, TONE_DELAY_VARIANCE);
    }
    else if (TONE_JITTER_FLAG == JITTER_EXPONENTIAL_FLAG)
    {
        spawnwait EXPONENT_JITTER(TONE_DELAY_MEAN, TONE_DELAY_VARIANCE);
    }
    TRL_TONE_DELAY = JITTER_INT;
}/* SET_TONE_DELAY */


process SET_RWRD_DELAY()
{
    if (RWRD_JITTER_FLAG == JITTER_GAUSS_FLAG)
    {
        spawnwait GAUSS_JITTER(RWRD_DELAY_MEAN, RWRD_DELAY_VARIANCE);
    }
    else if (RWRD_JITTER_FLAG == JITTER_UNIFORM_FLAG)
    {
        spawnwait UNIFORM_JITTER(RWRD_DELAY_MEAN, RWRD_DELAY_VARIANCE);
    }
    else if (RWRD_JITTER_FLAG == JITTER_EXPONENTIAL_FLAG)
    {
        spawnwait EXPONENT_JITTER(RWRD_DELAY_MEAN, RWRD_DELAY_VARIANCE);
    }
    TRL_RWRD_DELAY = JITTER_INT;
}/* SET_RWRD_DELAY */


process PICK_TRL_SSD()
{
    declare int tempCount;

    SESS_N_STOP_TRLS = SESS_N_STOP_TRLS + 1;
    tempCount        = 0;
    N_SSD            = 0;
    while (tempCount < N_SSD_MAX)
    {
        if (SSD_ARRY[tempCount] > 0)
        {
            N_SSD = N_SSD + 1;
        }
        tempCount = tempCount + 1;
        nexttick;
    }
    // must get from SSD_ARRY; use staircasing....
    //printf("****SET_CMD/PICK_TRL_SSD: Using RANDOM CHOICE OF SSD from SSD_ARRY****\n");
    TRL_STOP_SIGNAL_DELAY = 4; //SSD_ARRY[random(N_SSD)];
    //printf("****SET_CMD/PICK_TRL_SSD: TRL_STOP_SIGNAL_DELAY[in vert refresh] = [%d]****\n", TRL_STOP_SIGNAL_DELAY);
} /* PICK_TRL_SSD */


process COMPUTE_FIX_HOLD()
{
    // Set up any timing jitters etc
    TRL_FIX_HOLD_TIME = random(MIN_MAX_FIX_HOLD_TIME[1] - MIN_MAX_FIX_HOLD_TIME[0]) + MIN_MAX_FIX_HOLD_TIME[0];
} /* COMPUTE_FIX_HOLD */


process SET_TARGET()
{
    // pick current target location AND SET WINDOWS
    // sequential...
    //CURR_TARG_IDX = CURR_TARG_IDX + 1;
    //CURR_TARG_IDX = (CURR_TARG_IDX) % N_TARG_POS;
    // random
    CURR_TARG_IDX = random(N_TARG_POS);
    // Target stimulus on this trial
    CURR_TARG_SIZE         = TARG_SIZE_ARRY[CURR_TARG_IDX];
    CURR_TARG_ANGLE        = TARG_ANGLE_ARRY[CURR_TARG_IDX];
    CURR_TARG_ECCENTRICITY = TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
    // Zero is black.  see SET_CLRS.pro
    CURR_TARG_COLOR_IDX = CLR_IDX_TARG_1;

    spawnwait SET_WINS();
} /* SET_TARGET */


process SET_WINS()
{
    declare float eccX, eccY;

    // Compute fix win size
    // Fix spot center is at 0,0, so we do not need to compute
    FIX_WIN[LEFT]  = -FIX_WIN_SIZE/2;
    FIX_WIN[RIGHT] = FIX_WIN_SIZE/2;
    FIX_WIN[UP]    = -FIX_WIN_SIZE/2;
    FIX_WIN[DOWN]  = FIX_WIN_SIZE/2;
    // Larger fix win - For inaccurate eye position
    FIX_WIN_LARGE[LEFT]  = -FIX_WIN_SIZE_LARGE/2;
    FIX_WIN_LARGE[RIGHT] = FIX_WIN_SIZE_LARGE/2;
    FIX_WIN_LARGE[UP]    = -FIX_WIN_SIZE_LARGE/2;
    FIX_WIN_LARGE[DOWN]  = FIX_WIN_SIZE_LARGE/2;
    // Compute TARG_WIN and TARG_WIN_LARGE
    eccX            = cos(TARG_ANGLE_ARRY[CURR_TARG_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
    eccY            = -sin(TARG_ANGLE_ARRY[CURR_TARG_IDX]) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
    TARG_WIN[LEFT]  = eccX - TARG_WIN_SIZE/2;
    TARG_WIN[RIGHT] = eccX + TARG_WIN_SIZE/2;
    TARG_WIN[UP]    = eccY - TARG_WIN_SIZE/2;
    TARG_WIN[DOWN]  = eccY + TARG_WIN_SIZE/2;
    // Larger target window - For inaccurate eye position
    TARG_WIN_LARGE[LEFT]  = eccX - TARG_WIN_SIZE_LARGE/2;
    TARG_WIN_LARGE[RIGHT] = eccX + TARG_WIN_SIZE_LARGE/2;
    TARG_WIN_LARGE[UP]    = eccY - TARG_WIN_SIZE_LARGE/2;
    TARG_WIN_LARGE[DOWN]  = eccY + TARG_WIN_SIZE_LARGE/2;
    // Compute TARG_WIN_ANTI and TARG_WIN_LARGE_ANTI
    eccX                 = cos(TARG_ANGLE_ARRY[CURR_TARG_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
    eccY                 = -sin(TARG_ANGLE_ARRY[CURR_TARG_IDX] + 180) * TARG_ECCENTRICITY_ARRY[CURR_TARG_IDX];
    TARG_WIN_ANTI[LEFT]  = eccX - TARG_WIN_SIZE/2;
    TARG_WIN_ANTI[RIGHT] = eccX + TARG_WIN_SIZE/2;
    TARG_WIN_ANTI[UP]    = eccY - TARG_WIN_SIZE/2;
    TARG_WIN_ANTI[DOWN]  = eccY + TARG_WIN_SIZE/2;
    // Larget ANTI target window - For inaccurate Eye position
    TARG_WIN_ANTI_LARGE[LEFT]  = eccX - TARG_WIN_SIZE_LARGE/2;
    TARG_WIN_ANTI_LARGE[RIGHT] = eccX + TARG_WIN_SIZE_LARGE/2;
    TARG_WIN_ANTI_LARGE[UP]    = eccY - TARG_WIN_SIZE_LARGE/2;
    TARG_WIN_ANTI_LARGE[DOWN]  = eccY + TARG_WIN_SIZE_LARGE/2;
} /* SET_WINS */


process PCK_TRL_TYPE()
{
    declare float trlType;

    trlType = (1.0 + random(9999))/100.0;
    if (trlType <= GO_WEIGHT)
    {
        TRL_TYPE = TRIAL_TYPE_GO;
    }
    else
    {
        TRL_TYPE = TRIAL_TYPE_STOP;
    }
}/* PCK_TRL_TYPE */


process INIT_TRL_VARS()
{
    // do not init TRL_NUMBER
    PROCESS_STATE = 0;
    //TRL_NUMBER = 0;
    TRL_TYPE                       = 0;
    TRL_RUNNING                    = 0;
    TRL_TARG_VR_COUNT_TIME         = 0;
    TRL_IS_TARG_ON_FLAG            = 0;
    TRL_IS_TARG_ACQUIRED           = 0;
    TRL_IS_FIX_ACQUIRED            = 0;
    TRL_I_IN_FLIGHT                = 0;
    TRL_IS_TARG_MIN_THT            = 0;
    TRL_IS_TIMEOUT                 = 0;
    TRL_IS_STOP_SIGNAL_ON          = 0;
    TRL_STOP_SIGNAL_TIME           = 0;
    TRL_STOP_SIGNAL_DELAY          = 0;
    TRL_STOP_SIGNAL_DURATION       = 0;
    TRL_IS_NON_CANCELLED           = 0;
    TRL_IS_CANCELLED               = 0;
    TRL_CUM_TIME                   = 0;
    TRL_DURATION                   = 0;
    TRL_START_TIME                 = 0;
    TRL_END_TIME                   = 0;
    TRL_GET_READY_TIME             = 0;
    TRL_READY_TIME                 = 0;
    TRL_GET_READY_DURATION         = 0;
    TRL_FIX_ON_TIME                = 0;
    TRL_FIX_ACQ_TIME               = 0;
    TRL_FIX_ACQ_ERROR_TIME         = 0;
    TRL_FIX_HOLD_TIME              = 0;
    TRL_FIXATED_TIME               = 0;
    TRL_FIX_HOLD_DURATION          = 0;
    TRL_FIX_BRK_TIME               = 0;
    TRL_PRE_TARG_ON_TIME           = 0;
    TRL_TARG_ON_TIME               = 0;
    TRL_TARG_ON_DURATION           = 0;
    TRL_DECIDE_TIME                = 0;
    TRL_SACC_TIME                  = 0;
    TRL_ERLY_SACC_TIME             = 0;
    TRL_LATE_SACC_TIME             = 0;
    TRL_NO_SACC_TIME               = 0;
    TRL_STAIRCASE_SSD_FLAG         = 0;
    TRL_TARG_ACQ_ERROR_TIME        = 0;
    TRL_SACC_DURATION              = 0;
    TRL_TARG_ACQ_TIME              = 0;
    TRL_TARG_HOLD_DURATION         = 0;
    TRL_TIMEOUT_START_TIME         = 0;
    TRL_TIMEOUT_END_TIME           = 0;
    TRL_TIMEOUT_DURATION           = 0;
    TRL_TARG_MIN_THT_TIME          = 0;
    TRL_TARG_BRK_TIME              = 0;
    TRL_TARG_BRK_PRE_TONE_TIME     = 0;
    TRL_TARG_BRK_TONE_TIME         = 0;
    TRL_TARG_BRK_PRE_RWRD_TIME     = 0;
    TRL_TARG_BRK_RWRD_TIME         = 0;
    TRL_TARG_BRK_POST_RWRD_TIME    = 0;
    TRL_TARG_BRK_MIN_THT_TIME      = 0;
    TRL_NOGO_SACC_PRE_SSD_TIME     = 0;
    TRL_NOGO_SACC_POST_SSD_TIME    = 0;
    TRL_NOGO_ERLY_SACC_TIME        = 0;
    TRL_NOGO_LATE_SACC_TIME        = 0;
    TRL_FIX_HOLD_DURATION          = 0;
    TRL_FIX_MIN_SSHT_TIME          = 0;
    TRL_FIX_BRK_PRE_TONE_TIME      = 0;
    TRL_FIX_BRK_TONE_TIME          = 0;
    TRL_FIX_BRK_PRE_RWRD_TIME      = 0;
    TRL_FIX_BRK_RWRD_TIME          = 0;
    TRL_FIX_BRK_POST_RWRD_TIME     = 0;
    TRL_FIX_BRK_MIN_SSHT_TIME      = 0;
    TRL_CANCEL_TIME                = 0;
    TRL_IS_FIX_MIN_SSHT            = 0;
    TRL_TONE_DELAY                 = 0;
    TRL_TONE_FREQ                  = 0;
    TRL_TONE_DURATION              = 0;
    TRL_TONE_ON_TIME               = 0;
    TRL_TONE_OFF_TIME              = 0;
    TRL_RWRD_DELAY                 = 0;
    TRL_RWRD_DURATION              = 0;
    TRL_RWRD_ON_TIME               = 0;
    TRL_RWRD_OFF_TIME              = 0;
    TRL_XTRA_RWRD_ON_TIME          = 0;
    TRL_XTRA_RWRD_OFF_TIME         = 0;
    TRL_ITI_START_TIME             = 0;
    TRL_ITI_END_TIME               = 0;
    TRL_ITI_DURATION               = 0;
    TRL_REACTION_TIME              = 0;
    TRL_ABORT_TIME                 = 0;
    TRL_FIX_VRT_RFRSH_COUNT        = 0;
    TRL_TARG_VRT_RFRSH_COUNT       = 0;
    TRL_TARG_SSD_VRT_RFRSH_COUNT   = 0;
    TRL_OUTCOME_EVNTCODE           = 0;
    TRL_PREV_TRL_TYPE              = 0;
    TRL_PREV_OUTCOME_EVNTCODE      = 0;
    TRL_LAST_STOP_OUTCOME_EVNTCODE = 0;
    TRL_LAST_GO_OUTCOME_EVNTCODE   = 0;
}   /* INIT_TRL_VARS */
