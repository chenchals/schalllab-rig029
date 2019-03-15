// CMDTRIAL.PRO
//
// DESCRIPTION:
// Run a countermanding trial based on the variables calculated by SETC_TRL.PRO
// and those given by the user.
//
// EDIT HISTORY:
// Initial written by david.c.godlove@vanderbilt.edu    January, 2011
//
// 2018 OCT - chenchal.subraveti@vanderbilt.edu
//      Refactored code lines for sending event code and updating array index into its own process and replaced
//      those lines with a spawn call to the new process.
//      new process: SEND_EVT - See SEND_EVT.PRO
// 2018 OCT 15 - chenchal.subraveti@vanderbilt.edu
//      Refactored repeatedly called lines of code into processes and replaced with spawnwait call to these processes.
//		  Formatted code flow. Removed "hide" keyword as no longer useful. New processes in this file are:
//          USER_INFO : Show user trial progress information
//          SHOW_BLANK_UPD8_GRF : Flip to blank page on VIDEOSYNC and updated the graph object on TEMPO screen
//
// 2018 DEC 15 - chenchal.subraveti@vanderbilt.edu
//      Added TRACE_FLOW to debug different STAGES of task evolution
//      Trial information is written to an output file for debugging in USER_INFO routine
//
// 2019/01/09 chenchal subraveti
//     Rework of logic so that we can count the number if screen refreshes based on the photocell output.


declare int traceTime;
declare int trl_running;
declare int Trl_Outcome;
declare int Trl_Start_Time;
declare int LastStopOutcome = 1;
// Values to assign to LastStopOutcome
declare int lastStopOutcome_success   = 1;
declare int lastStopOutcome_failure   = 0;
declare int lastStopOutcome_no_change = 2;

// Values for Trl_outcome
declare int constant no_fix       = 1;  // never attained fixation
declare int constant broke_fix    = 2;  // attained and then lost fixation before target presentation
declare int constant go_wrong     = 3;  // never made saccade on a go trial
declare int constant nogo_correct = 4;  // successfully canceled trial
declare int constant sacc_out     = 5;  // made an inaccurate saccade out of the target box
declare int constant broke_targ   = 6;  // didn't hold fixation at the target for long enough
declare int constant go_correct   = 7;  // correct saccade on a go trial
declare int constant nogo_wrong   = 8;  // error noncanceled trial
declare int constant body_move    = 12; // error body movement (for training stillness)
declare int constant too_fast     = 14; // low RT while in training to slow down.
declare int constant returnTofix  = 16; // Eventually found the target but not on first saccade

// Trial types
declare int go_trl     = 0;
declare int stop_trl   = 1;
declare int ignore_trl = 2;

// Updare information for the user
declare USER_INFO(curr_holdtime,
                  trl_type,
                  curr_holdtime,
                  curr_ssd,
                  nostop_trl_count,
                  canceled_trl_count,
                  noncanceled_trl_count,
                  float saccade_time,
                  float targ_time);

declare TRACE_FLOW(trl_type,
                   traceNum);

// Update the animated graph
declare UPD8_GRF(targetAttrib,
                 fixspotAttrib);
declare SHOW_BLANK_UPD8_GRF();


// Check for left photocell trigger
declare ACQ_LEFT_PD();
declare ACQ_RIGHT_PD();

// Processes for
declare PROCESS_BROKE_FIX(trlOutcome,
                          evtCode);

// see ALL_VARS.PRO, DEFAULT.PRO, SETC_TRL.PRO
// animated graph object
declare CMDTRIAL(allowed_fix_time,
                 curr_holdtime,
                 trl_type,
                 max_saccade_time,
                 curr_ssd,
                 cancl_time,
                 max_sacc_duration,
                 targ_hold_time,
                 object_fix);


process CMDTRIAL(allowed_fix_time,
                 curr_holdtime,
                 trl_type,
                 max_saccade_time,
                 curr_ssd,
                 cancl_time,
                 max_sacc_duration,
                 targ_hold_time,
                 object_fix)
{
  // Number the trial stages to make them easier to read below
  declare int need_fix         = 1;
  declare int fixating         = 2;
  declare int targ_on          = 3;
  declare int in_flight        = 4;
  declare int on_target        = 5;
  declare int return_fix_check = 6;
  declare int stage;
  declare int test = 10;

  // Number the stimuli pages to make reading easier
  declare int blank       = 0;
  declare int fixation_pd = 1;
  declare int fixation    = 2;
  declare int target_pd   = 3;
  declare int target      = 4;
  declare int signal_pd   = 5;
  declare int signal      = 6;

  // Timing variables which will be used to time task
  declare float fix_spot_time;
  declare float targ_time;
  declare float saccade_time;
  declare float aquire_fix_time;
  declare float brokeTargTime;
  declare float stop_sig_time;
  declare float aquire_targ_time;
  declare int   noncanceled_trl_count;
  declare int   canceled_trl_count;
  declare int   nostop_trl_count;

  // This variable makes the while loop work
  declare int wait_n_screen_refresh;

  // Reset for every iteration
  trl_running = 1;
  stage       = need_fix;
  traceTime   = 0;
  vertRefreshCountTarget = 0;
  actualSsdTime = 0;
  expectedSsdTime = 0;
  targ_time = 0;
  saccade_time = 0;
//================================================================================================

  spawn SEND_EVT(EVT_CMAN_HEADER_);
  spawn SEND_EVT(EVT_TRIAL_START_);

  // Show fixation with pd
  dsendf("vp %d\n", fixation_pd);
  spawnwait ACQ_LEFT_PD();
  dsendf("vp %d\n", fixation);
  fix_spot_time = time();
  spawn SEND_EVT(EVT_FIX_SPOT_ON_);

  oSetAttribute(object_fix, aVISIBLE);
  while (trl_running)
  {
    //----------------------------STAGE = need_fix = 1--------------------------------------------
    // STAGE need_fix (the fixation point is on, but the subject hasn't looked at it)
    if (stage == need_fix)
    {
      // If the eyes have entered the fixation window (before time, see below)...
      if (In_FixWin)
      {
        spawn SEND_EVT(EVT_FIXATE_);

        aquire_fix_time = time();
        Trl_Start_Time  = aquire_fix_time;
        stage           = fixating;
      }
      else if (time() > fix_spot_time + allowed_fix_time)
      {
        spawnwait PROCESS_BROKE_FIX(no_fix,FixError_);

        printf("Trial Outcome: Aborted (no fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
      }
    }
    //----------------------------STAGE = fixating = 2--------------------------------------------
    // STAGE fixating (the subject is looking at the fixation point waiting for target onset)
    else if (stage == fixating)
    {
      if (!In_FixWin)
      {
        spawnwait PROCESS_BROKE_FIX(broke_fix,FixError_);

        printf("Trial Outcome: Aborted (broke fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
      }
      // But if the eyes are still in the window at end of holdtime...
      else if (In_FixWin && time() > aquire_fix_time + curr_holdtime)
      {
        dsendf("vp %d\n", target_pd);
        while (!PD_TRIG_L)
        {
          if (!In_FixWin)
          {
            spawnwait PROCESS_BROKE_FIX(broke_fix,FixError_);

            printf("Trial Outcome: Aborted (broke fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
          }
          nexttick;
        }
        vertRefreshCountTarget = vertRefreshCountTarget + 1;
        spawn SEND_EVT(EVT_TARGET_);
        spawn SEND_EVT(EVT_FIX_SPOT_OFF_);

        stage     = targ_on;
        targ_time = time();
        if (trl_type == go_trl)
        {
          // go_trial : update graph
          spawn UPD8_GRF(aVISIBLE,aINVISIBLE);
        }
        else if (trl_type == ignore_trl)
        {
          // ignore_trial : update graph
          spawn UPD8_GRF(aVISIBLE,aVISIBLE);
        }
        else if (trl_type == stop_trl)
        {
          // stop_trial : update graph
          spawn UPD8_GRF(aVISIBLE,aVISIBLE);

          // No of screen refreshes to wait is = curr_ssd
          // New logic from TEST/TEST_SSD.PRO
          while (vertRefreshCountTarget < curr_ssd && trl_running)
          {
            if (PD_TRIG_L)
            {
              vertRefreshCountTarget = vertRefreshCountTarget + 1;
              // Schmitt trig keeps the state up for about 2.5 ms so
              // avoid multiple counts for same screen
              nexttick 2;
            }
            if (!In_FixWin)
            {
              spawnwait PROCESS_BROKE_FIX(broke_fix,FixError_);

              printf("Trial Outcome: Aborted (broke fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
            }
            nexttick;
          }
          if (trl_running)
          {
            // Successfully held fixation dor curr_ssd refreshes
            dsendf("vp %d\n", signal_pd);
            spawnwait ACQ_RIGHT_PD();

            dsendf("vp %d\n", signal);
            spawn SEND_EVT(StopSignal_);

            actualSsdTime   = time() - targ_time;
            expectedSsdTime = round(curr_ssd * 1000.0 / Refresh_rate);
            printf("curr_ssd / vertRefreshCountTarget = [ %d / %d ] \n", curr_ssd, vertRefreshCountTarget);
            printf("Expected ssd_time / Actual ssd_time = [ %d / %d ] \n", expectedSsdTime, actualSsdTime);
          }
        }
      }
    }
    //----------------------------STAGE = targ_on = 3---------------------------------------------
    // STAGE targ_on (the target (followed by signal if stop trl) has been presented
    // but the subject is still fixating)
    else if (stage == targ_on)
    {
      if (!In_FixWin)
      {
        saccade_time = time();
        spawn SEND_EVT(EVT_SACCADE_);

        printf("     Reaction Time = %d\n", saccade_time - targ_time);
        stage = in_flight;
        // saccade too fast (too fast while being trained to slow down)
        if (saccade_time - targ_time < Min_saccade_time)
        {
          Trl_Outcome     = too_fast;
          LastStopOutcome = lastStopOutcome_no_change;
          spawn SHOW_BLANK_UPD8_GRF();

          printf("Trial Outcome: Error (too fast) [%d,%d]\n", Trl_number, Trl_Outcome);
          trl_running = 0;
        }
      }
      // If no saccade, and time for a saccade runs out...
      // ...and a saccade was supposed to be made.
      else if ((trl_type == go_trl || trl_type == ignore_trl) && In_FixWin && time() > targ_time + max_saccade_time)
      {
        spawn SHOW_BLANK_UPD8_GRF();

        Trl_Outcome     = go_wrong;
        LastStopOutcome = lastStopOutcome_no_change;
        spawn TONE(failure_tone,
                   tone_duration);

        printf("Trial Outcome: Error (no saccade) [%d,%d]\n", Trl_number, Trl_Outcome);
        trl_running = 0;
      }
      // But if no saccade occurs...and time for a saccade runs out...
      // ...and a saccade was NOT supposed to be made...
      else if (trl_type == stop_trl && In_FixWin && time() > targ_time + (curr_ssd * 1000.0 / Refresh_rate) + cancl_time)
      {
        spawn SHOW_BLANK_UPD8_GRF();

        Trl_Outcome = nogo_correct;
        spawn SEND_EVT(Correct_);

        LastStopOutcome = lastStopOutcome_success;
        Correct_trls    = Correct_trls + 1;
        printf("Trial Outcome: Correct (canceled) [%d,%d]\n", Trl_number, Trl_Outcome);
        canceled_trl_count = canceled_trl_count + 1;
        if (Canc_alert)
        {
          // for training purposes
          spawn SVR_BEL2();
        }
        trl_running = 0;
      }
    }
    //----------------------------STAGE = in_flight = 4-------------------------------------------
    // STAGE in_flight (eyes have left fixation window but have not entered target window)
    else if (stage == in_flight)
    {
      if (In_TargWin)
      {
        // If the eyes get into the target window...
        aquire_targ_time = time();
        spawn SEND_EVT(EVT_DECIDE_);

        stage = on_target;
        if (trl_type == go_trl || trl_type == ignore_trl)
        {
          spawn SEND_EVT(Correct_);

          LastStopOutcome = lastStopOutcome_no_change;
        }
        else if (trl_type == stop_trl)
        {
          // what shold the subject be seeing? ******
          // dsendf("vp %d\n", target_pd);
          // target_pd is still on during stop_trl, !In_FixWin
          spawn SEND_EVT(Error_sacc);

          brokeTargTime = time();
          Trl_Outcome   = broke_targ;
          printf("Trial Outcome: Error (broke target fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
          LastStopOutcome = lastStopOutcome_failure;
          stage           = return_fix_check;
        }
      }
      else if (time() > saccade_time + max_sacc_duration)
      {
        // But, if the eyes are out of the target window and time runs out...
        Trl_Outcome = sacc_out;
        if (trl_type == stop_trl)
        {
          LastStopOutcome = lastStopOutcome_failure;
        }
        else
        {
          LastStopOutcome = lastStopOutcome_no_change;
        }
        spawn SHOW_BLANK_UPD8_GRF();

        printf("Trial Outcome: Error (inaccurate saccade)[%d,%d]\n", Trl_number, Trl_Outcome);
        trl_running = 0;
      }
    }
    //----------------------------STAGE = on_target = 5-------------------------------------------
    // STAGE on_target (eyes have entered the target window)
    else if (stage == on_target)
    {
      if (!In_TargWin)
      {
        brokeTargTime = time();
        Trl_Outcome   = broke_targ;
        if (trl_type == stop_trl)
        {
          LastStopOutcome = lastStopOutcome_failure;
        }
        else
        {
          LastStopOutcome = lastStopOutcome_no_change;
        }
        stage = return_fix_check;
      }
      // Subject in target widow for targ_hold_time
      else if (In_TargWin && time() > aquire_targ_time + targ_hold_time)
      {
        if (trl_type == go_trl || trl_type == ignore_trl)
        {
          Trl_Outcome     = go_correct;
          LastStopOutcome = lastStopOutcome_no_change;
          Correct_trls    = Correct_trls + 1;
          spawn SEND_EVT(Correct_);

          printf("Trial Outcome: Correct (saccade) [%d,%d]\n", Trl_number, Trl_Outcome);
          nostop_trl_count = nostop_trl_count + 1;
        }
        else if (trl_type == stop_trl)
        {
          Trl_Outcome     = nogo_wrong;
          LastStopOutcome = lastStopOutcome_failure;
          printf("Trial Outcome: Error (noncanceled) [%d,%d]\n", Trl_number, Trl_Outcome);
          noncanceled_trl_count = noncanceled_trl_count + 1;
        }
        spawn SHOW_BLANK_UPD8_GRF();

        trl_running = 0;
      }
    }
    //----------------------------STAGE = return_fix_check = 6------------------------------------
    // STAGE return_fix_check (on stop trials, that are non-cancelled trials, subject retuns to
    // fixspot, realizing error of not stopping on stop trial)
    else if (stage == return_fix_check)
    {
      if (In_FixWin && time() < max_sacc_duration + brokeTargTime)
      {
        spawn SHOW_BLANK_UPD8_GRF();
        spawn SEND_EVT(ReturnToFix_);

        Trl_Outcome = returnTofix;
        printf("Trial Outcome: Error (Return to Fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
        trl_running = 0;
      }
      else if (time() > max_sacc_duration + brokeTargTime)
      {
        Trl_Outcome = broke_targ;
        spawn SHOW_BLANK_UPD8_GRF();

        trl_running = 0;
        spawn SEND_EVT(BreakTFix_);

        printf("Trial Outcome: Error (broke target fixation) [%d,%d]\n", Trl_number, Trl_Outcome);
      }
    }
    // ----------------------DONE ALL STAGES---------------------------------------------------------
    if (Move_ct > 0)
    {
      Trl_Outcome = body_move;
      LastStopOutcome = lastStopOutcome_no_change;
      spawn SHOW_BLANK_UPD8_GRF();
      printf("Trial Outcome: Aborted (body movement) [%d,%d]\n", Trl_number, Trl_Outcome);
      trl_running = 0;
    }
    nexttick;
  }
  spawn USER_INFO(curr_holdtime,
                  trl_type,
                  curr_holdtime,
                  curr_ssd,
                  nostop_trl_count,
                  canceled_trl_count,
                  noncanceled_trl_count,
                  saccade_time,
                  targ_time);
} /* CMDTRIAL */

//------------------------------------------SUB-PROCESSES---------------------------------------
process ACQ_LEFT_PD()
{
  while (!PD_TRIG_L)
  {
    nexttick;
  }
}


process ACQ_RIGHT_PD()
{
  while (!PD_TRIG_R)
  {
    nexttick;
  }
}


process PROCESS_BROKE_FIX(trlOutcome, evtCode)
{
  spawn SEND_EVT(evtCode);
  spawn SHOW_BLANK_UPD8_GRF();

  Trl_Outcome     = trlOutcome;
  LastStopOutcome = lastStopOutcome_no_change;
  trl_running     = 0;
}


process UPD8_GRF(targetAttrib, fixspotAttrib)
{
  // show/hide target
  oSetAttribute(object_targ, targetAttrib);
  // show/hide fixation point
  oSetAttribute(object_fix, fixspotAttrib);
}


process SHOW_BLANK_UPD8_GRF()
{
  declare int blank = 0;

  // Flip the pg to the blank screen...
  dsendf("vp %d\n", blank);
  spawn UPD8_GRF(aINVISIBLE,
                 aINVISIBLE);
}

process TRACE_FLOW(trl_type, traceNum)
{
  declare int relativeTime;

  relativeTime = time() - traceTime;
  traceTime    = time();
  writef("trkFlo.csv %d, ", traceNum);
  writef("trkFloTm.csv %d, ", relativeTime);
  if (traceNum == 10000)
  {
    writef("trkFlo.csv |%d|%d\n", Trl_number, trl_type, Trl_Outcome);
    writef("trkFloTm.csv |%d|%d\n", Trl_number, trl_type, Trl_Outcome);
  }
}

process USER_INFO(curr_holdtime,
                  trl_type,
                  curr_holdtime,
                  curr_ssd,
                  nostop_trl_count,
                  canceled_trl_count,
                  noncanceled_trl_count,
                  float saccade_time,
                  float targ_time)
{
  declare float rt;

  rt = saccade_time - targ_time;
  printf(" \n");
  printf(" *********************************\n");
  printf("Block: %d / # %d ", Block_number, Trl_number);
  printf(" (%d", Comp_Trl_number);
  printf("     Reaction Time = %d\n", rt);
  printf(" correct; GO = %d; C = %d; NC = %d)\n", nostop_trl_count, canceled_trl_count, noncanceled_trl_count);

  if (trl_type == go_trl)
  {
    printf("Trial Type: NO-STOP\n");
    printf("Holdtime = %d\n", curr_holdtime);
  }
  else if (trl_type == stop_trl)
  {
    printf("Trial Type: STOP\n");
    printf("Holdtime = %d\n", curr_holdtime);
    printf("curr_ssd / observed in # Screen refreshs = [%d / %d]\n", curr_ssd,vertRefreshCountTarget);
    printf("expected ssd time / actual ssd time = [%d / %d]\n", expectedSsdTime, actualSsdTime);
  }
  else if (trl_type == ignore_trl)
  {
    printf("Trial Type: IGNORE\n");
    printf("Holdtime = %d\n", curr_holdtime);
    printf("curr_ssd / observed in # Screen refreshs = [%d / %d]\n", curr_ssd,vertRefreshCountTarget);
    printf("expected ssd time / actual ssd time = [%d / %d]\n", expectedSsdTime, actualSsdTime);
  }
  //At the end of trial write to file the info...
  // blockNum,TrlNum,trlType,trlOutcome,rt,currSSDScreen,currSSDComputed,newCurrSSD
  writef("SSDTimes.csv %d,%d,%d,%d,%d,%d,%d,%d,%d\n", Block_number, Trl_number, trl_type, Trl_Outcome, rt, curr_ssd, vertRefreshCountTarget, expectedSsdTime, actualSsdTime);
  nexttick 5;
} /* USER_INFO */
