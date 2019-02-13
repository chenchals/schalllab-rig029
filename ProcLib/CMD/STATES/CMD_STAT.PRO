//==========================================================================
// CMD_STAT.PRO
//   Description: Task states for Countermanding. All states are based
//                on EYE POSITION and current TASK PHASE (avoiding saying STATE here)
//                A STATE should ideally know about
//                1. CURR_STAT : State in currently
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_ALLOWED_T : Max time for staying in this state
//                5. STAT_I_MOVE_DURATION : If saccade occurs, it must complete in this time
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-25
//==========================================================================
//  Revision History:
//  001: 2019/01/31 chenchal subraveti
//       Have to redifine the outcomes descriptions
//       Added STAT_TEST, STAT_TARG_ON, STAT_TARG_ACQ
//       Updated STAT vars for processing saccade


//Current State variables in the absence of structs
declare int CURR_STAT;
declare int STAT_STRT_T;
declare int STAT_STP_T;
declare int STAT_DLTA_T;
declare int STAT_ALLOWED_T;
declare int STAT_I_MOVE_DURATION;


//
declare constant int STAT_TEST = 99;
// Eyes are anywhere on the screen
declare constant int STAT_IDLE = 0;

// Fixspot is NOT ON: Waiting for subj to be ready
// Check: Gaze hanging around the FIX_WIN_LARGE.
//        Gaze has not *crossed* FIX_WIN_LARGE within REDY_T
declare constant int STAT_GET_READY = 1;

// Fixspot is ON: Waiting for subject to reach the fix window and Fixate
// Check: Gaze within FIX_WIN, before ALLOWED_FIX_TIME
declare constant int STAT_FIX_ON = 2;

// Fixspot is ON: Waiting for subject to stay on fixspot
// Check: Gaze within FIX_WIN until FIX_HOLD_TIME expires
declare constant int STAT_FIX_HOLD = 3;

// Fixspot is OFF Target is ON:
// Check: Gaze in FIX window until MIN_SACCADE_TIME expires, else it is early saccade
//        Gaze left FIX_WIN before MAX_SACCADE_TIME, then correct saccade, else no saccade
declare constant int STAT_TARG_ON = 4;

// Fixspot is OFF Target is ON:
// Check: Gaze in TARG_WIN before MAX_SACCADE_DURATION
declare constant int STAT_TARG_ACQ = 5;

// Fixspot is OFF Target is ON:
// Check:
//   case 0: MIN_TARG_HOLD_TIME <= TONE_DELAY
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: compute (ERROR) TONE, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Play (SUCCESS) TONE at TONE_DELAY time
//   case 1: MIN_TARG_HOLD_TIME <= TONE_DELAY + TONE_DURATION
//         if gaze in TARG_WIN until RWRD_DURATION --> (SUCCESS-tone alredey delivered), goto STAT_RWRD_CHK
//         if gaze not in TARG_WIN during RWRD_DURATION --> (SUCCESS-tone alredey delivered), compute TIMEOUT_TIME --> goto STAT_OUTCOME
//   case 2: MIN_TARG_HOLD_TIME > TONE_DELAY + TONE_DURATION
//         Goto next state (reward already delivered), goto STAT_RWRD_CHK
declare constant int STAT_TONE_CHK = 6;

// Fixspot is OFF Target is ON:
// Check:
//   case 0: MIN_TARG_HOLD_TIME <= RWRD_DELAY
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: No Reward, compute TIMEOUT_TIME, goto STAT_OUTCOME
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: Deliver reward at RWRD_DELAY time
//   case 1: MIN_TARG_HOLD_TIME <= RWRD_DELAY + RWRD_DURATION
//                if gaze in TARG_WIN until RWRD_DURATION --> (reward alredey delivered), goto STAT_OUTCOME
//                if gaze not in TARG_WIN during RWRD_DURATION --> (reward already delivered) compute TIMEOUT_TIME --> goto STAT_OUTCOME
//   case 2: MIN_TARG_HOLD_TIME > RWRD_DELAY + RWRD_DURATION
//         if gaze in TARG_WIN until MIN_TARG_HOLD_TIME expires: (reward already delivered), goto STAT_OUTCOME
//         if gaze out of TARG_WIN before MIN_TARG_HOLD_TIME expires: (reward already delivered), compute TIMEOUT_TIME, goto STAT_OUTCOME
declare constant int STAT_RWRD_CHK = 7;

// See CmdOutcomes.xls file in DOC folder
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| DEF_TRL_TIME_VAR	                            | TRL_TIME_VAR_not_0	             | EVENT_SENT	          | OUTCOME_GO_TRIAL  |	OUTCOME_NOGO_TRIAL_NO_SS |  OUTCOME_NOGO_TRIAL_SS |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Fix win before allowed time       |	TRL_FIX_ACQ_ERROR_TIME	         | AcquireFixError_	    | OutcomeFixError_	| OutcomeFixError_	       | OutcomeFixError_       |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Fix win for fix hold time	        | TRL_FIX_HOLD_BRK_TIME	           | BreakFix_	          | OutcomeFixBreak_	| OutcomeFixBreak_	       | OutcomeFixBreak_       |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze out of Fix win before Min sac time	      | TRL_ERLY_SACC_TIME	             | EarlySaccade_	      | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze in Fix win after Max sac time	          | TRL_NO_SACC_TIME	               | NoSaccade_	          | OutcomeGoError_	  | *trial still evolving*	 | *trial still evolving* |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in Targ win before max sac duration	| TRL_TARG_ACQ_ERROR_TIME	         | AcquireTargetError_  | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during tone delay	      | TRL_TARG_HOLD_BRK_PRE_TONE_TIME  | TargHoldBrkPreTone_  | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during tone duration	    | TRL_TARG_HOLD_BRK_TONE_TIME	     | TargHoldBrkTone_     | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during reward delay	    | TRL_TARG_HOLD_BRK_PRE_RWRD_TIME	 | TargHoldBrkPreRwrd_  | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win during reward duration	  | TRL_TARG_HOLD_BRK_RWRD_TIME	     | TargHoldBrkRwrd_     | OutcomeGoError_	  | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze not in targ win after reward duration    |                                  |                      |                   |                          |                        |
//| min target hold time is greater than          | TRL_TARG_HOLD_BRK_POST_RWRD_TIME | TargHoldBrkPostRwrd_ | OutcomeGoError_   | OutcomeNoGoErrorEarly_	 | OutcomeNoGoError_      |
//| tone + reward times.	                        |                                  |                      |                   |                          |                        |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|
//| Gaze in targ win for min target hold time	    | TRL_TARG_HOLD_MIN_THT_TIME	     | TargHoldMinTHT_      | OutcomeGoCorrect_ | OutcomeNoGoWrongEarly_	 | OutcomeNoGoWrong_      |
//|-----------------------------------------------|----------------------------------|----------------------|-------------------|--------------------------|------------------------|


declare constant int STAT_OUTCOME = 8;

//
declare constant int STAT_ITI_CHK = 9;
//
declare constant int STAT_TIMEOUT = 10;
