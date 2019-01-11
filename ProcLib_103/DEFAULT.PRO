// This sets all of the user defined global variables.
// It is needed because of the loop structure which allows multiple tasks to run
// from the same protocol.  If multiple protocols use the same variables, we may
// run into problems if we don't specifically reset them at the beginning of each
// task change.
//
// written by david.c.godlove@vanderbilt.edu  July, 2011

declare int tempVar = 0;
declare int run_cmd_sess     = 1;
declare int run_fix_sess     = 2;
declare int run_mg_sess      = 3;
declare int run_gonogo_sess  = 4;
declare int run_flash_sess   = 5;
declare int run_delayed_sess = 6;
declare int run_search_sess  = 7;
declare int run_anti_sess    = 9;
declare int run_color_pop    = 10;
declare int run_pop_prime    = 11;

declare DEFAULT(int task,
                int monkey,
                int room);


process DEFAULT(int task,
                int monkey,
                int room)
{

  declare int xena      = 1;
  declare int broca     = 3;
  declare int helmholtz = 4;
  declare int gauss     = 5;
  declare int joule     = 6;

  declare int color_num, r_, g_, b_;

  // End of all declares

  r_ = 0;
  g_ = 1;
  b_ = 2;


  Trls_per_block = 100;

  //----------------------------------------------------------------------------------------------------------------
  // Trial type distributions (MUST SUM TO 100)
  Go_weight     = 100.0;
  Stop_weight   = 0.0;
  Ignore_weight = 0.0;

  DR1_flag = 0;                                         // We don't normally want to do 1DR version.


  //----------------------------------------------------------------------------------------------------------------
  // Stimulus properties
  // White iso luminant value is 35,33,27;
  // Red iso luminant value is is 63,base_reward0,0;
  // Green iso luminant value is 0,36,0;
  // Blue iso luminant value is 0,0,59;

  // Set default colors for isoluminance
  //These values are physically isoluminant, not perceptually
  /*redVal = 46;
   * greenVal = 29;
   * blueVal = 62;
   * yrOff = 15;
   * ygOff = 9;
   * mrOff = 20;
   * mbOff = 11;
   * cgOff = 1;
   * cbOff = 41;
   * wrOff = 25;
   * wgOff = 7;
   * wbOff = 37;
   */

  //////////// Default Search Variables
  TargetType      = 1;                       //1 = L, 2 = T
  PlacPres        = 1;                       // 1 = absent, 2 = present
  SearchType      = 2;                       //Hetero = 1, Homo = 2
  SetSize         = 1;                       //SS1 = 1, SS2 = 2, SS4 = 3, SS8 = 4, SS12 = 5
  search_fix_time = 500;                     //
  plac_duration   = 1000;                    //consider adding to ALLVARS.pro
  Consec_trl      = 0;                       //min number of consecutive correct trials (minus one) required to get reward

  NonSingleton_color[r_] = redVal - wrOff;   //35;	//Default to gray
  NonSingleton_color[g_] = greenVal - wgOff; //33;
  NonSingleton_color[b_] = blueVal - wbOff;  //27;

  Singleton_color[r_] = redVal - wrOff;      //35;	//Default to gray
  Singleton_color[g_] = greenVal - wgOff;    //33;
  Singleton_color[b_] = blueVal - wbOff;     //27;
  ////////////


  Classic = 0;

  Stop_sig_color[r_] = 40;
  Stop_sig_color[g_] = 40;
  Stop_sig_color[b_] = 0;

  Ignore_sig_color[r_] = 0;
  Ignore_sig_color[g_] = 36;
  Ignore_sig_color[b_] = 0;

  Fixation_color[r_] = redVal - wrOff;          //35;	//Default to gray
  Fixation_color[g_] = greenVal - wgOff;        //33;
  Fixation_color[b_] = blueVal - wbOff;         //27;

  Cue_color[r_] = redVal - wrOff;               //35;	//Default to gray
  Cue_color[g_] = greenVal - wgOff;             //33;
  Cue_color[b_] = blueVal - wbOff;              //27;

  N_targ_pos = 2;                               // number of target positions (this is calculated below based on user input)
  // Fill color list array with same values
  while (tempVar < 12)
  {
    Color_list[tempVar, r_] = 35;                                   // color of each target individually
    Color_list[tempVar, g_] = 33;                                   // color of each target individually
    Color_list[tempVar, b_] = 27;                                   // color of each target individually
    tempVar                 = tempVar + 1;
  }
  // Fill size list array with same values, for Target size in degrees
  tempVar = 0;
  while (tempVar < 12)
  {
    Size_list[tempVar] = 0.5;                          // size of each target individually (degrees)
    tempVar            = tempVar + 1;
  }

  Angle_list[0] = 0;                            // angle of each target individually (degrees)
  Angle_list[1] = 180;
  Angle_list[2] = 90;
  Angle_list[3] = 270;
  Angle_list[4] = 180;
  Angle_list[5] = -135;
  Angle_list[6] = -90;
  Angle_list[7] = -45;

  // Fill eccentricity list array with same values for
  // distance of each target from center of screen individually (degrees)
  tempVar = 0;
  while (tempVar < 12)
  {
    Eccentricity_list[tempVar] = 12.0;                         // size of each target individually (degrees)
    tempVar                    = tempVar + 1;
  }

  Fixation_size = 0.5;                          // size of the fixatoin point (degrees)

  Success_Tone_bigR = 100;                      // positive secondary reinforcer in Hz (large reward)
  Success_Tone_medR = 200;                      // positive secondary reinforcer in Hz (medium reward)
  Success_Tone_smlR = 400;                      // positive secondary reinforcer in Hz (small reward)
  Failure_Tone_smlP = 800;                      // negative secondary reinforcer in Hz (short timeout)
  Failure_Tone_medP = 1600;                     // negative secondary reinforcer in Hz (medium timeout)
  Failure_Tone_bigP = 3200;                     // negative secondary reinforcer in Hz (long timeout)

  Fixation_Target = 0;                          // Target number for the fixation task (not used here);

  //----------------------------------------------------------------------------------------------------------------
  // Eye related variables
  Fix_win_size  = 4;                            // size of fixation window (degrees)
  Targ_win_size = 7;                            // size of target window (degrees)

  //----------------------------------------------------------------------------------------------------------------
  // Task timing paramaters (all times in ms unless otherwise specified)
  Allowed_fix_time  = 2000;                     // subject has this long to acquire fixation before a new trial is initiated
  Expo_Jitter_soa   = 1;                        // defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
  expo_jitter       = 1;
  Min_Holdtime      = 500;                      // minimum time after fixation before target presentation
  Max_Holdtime      = 1000;                     // maximum time after fixation before target presentation
  Min_SOA           = 0;                        // minimum time between target onset and fixation offset (mem guided only)
  Max_SOA           = 1000;                     // maximum time between target onset and fixation offset (mem guided only)
  Min_saccade_time  = 0;
  Max_saccade_time  = 700;                      // subject has this long to saccade to the target
  Max_sacc_duration = 50;                       // once the eyes leave fixation they must be in the target before this time is up
  Targ_hold_time    = 1500;                     // after saccade subject must hold fixation at target for this long
  Staircase         = 1;                        // do we select the next SSD based on a staircasing algorithm?
  // Fill SSD list with values ranging 2:2:40
	// In vertical retrace units
  tempVar = 0;
	while(tempVar < 20)
	{
		SSD_list[tempVar] = (tempVar * 2) + 2;
		tempVar = tempVar + 1;
	}

  SSD_floor = 0;                                // for training to cancel consistently
  SSD_ceil  = 0;                                // for training to cancel consistently

  Cancl_time       = Max_saccade_time * 2;      // subject must hold fixation for this long on a stop trial to be deemed canceled
  Tone_Duration    = 30;                        // how long should the error and success tones be presented?
  Exp_juice        = 0;                         // Exponential juice reward duration by reaction time
  Reward_Offset    = 600;                       // how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
  Base_Reward_time = 60;                        // medium time for the juice solonoid to remain open (monkeys are very interested in this varaible)
  Base_Punish_time = 2000;                      // medium time out for messing up (monkeys care less for this one)
  Max_move_ct      = 1;                         // for training to be still with a motion detector
  Bmove_tout       = 2000;                      // for training to be still with a motion detector
  TrainingStill    = 0;                         // Indicates that we are using motion detector to train the monk to be still
  Canc_alert       = 0;                         // Alert operator that the monk has canceled a trial (during training)
  Fixed_trl_length = 1;                         // 1 for fixed trial length, 0 for fixed inter trial intervals
  Trial_length     = 5000;                      // fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
  targ_on_time     = 100;

  leaveStimsPunish = 0;
  Inter_trl_int    = 800;                       // how long between trials (only works if Fixed_trl_length == 0)

  //--------------------------------------------------------------------------------------------------------------------
  // Xena
  if ((monkey == xena) || (monkey == joule))
  {
    Set_tones = 0;

    Fix_win_size  = 5;
    Targ_win_size = 7;

    Allowed_fix_time = 1000;
    Max_saccade_time = 800;
    Base_Reward_time = 20;
    Base_Punish_time = 2000;

    if (task == run_delayed_sess)
    {
      SingCol       = 6;
      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      N_targ_pos = 8;
			// Fill size list array with same values, for Target size in degrees
			tempVar = 0;
			while (tempVar < 12)
			{
				Size_list[tempVar] = 0.5;                          // size of each target individually (degrees)
				tempVar            = tempVar + 1;
			}
			// Fill SOA list array with same values, 0
			tempVar = 0;
			while (tempVar < 20)
			{
				SOA_list[tempVar] = 0;
				tempVar           = tempVar + 1;
			}
    }
    // SEARCH TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_search_sess)
    {
      Trls_per_block = 10000;

      DR1_flag = 0;

      Go_weight     = 100.0;
      Stop_weight   = 0.0;
      Ignore_weight = 0.0;

			// Fill size list array with same values, for Target size in degrees
			tempVar = 0;
			while (tempVar < 12)
			{
				Size_list[tempVar] = 0.5;                          // size of each target individually (degrees)
				tempVar            = tempVar + 1;
			}
      // What is the logic for the eccentricity?
      Eccentricity_list[0]  = 3;
      Eccentricity_list[1]  = 6;
      Eccentricity_list[2]  = 9;
      Eccentricity_list[3]  = 6;
      Eccentricity_list[4]  = 6;
      Eccentricity_list[5]  = 9;
      Eccentricity_list[6]  = 2;
      Eccentricity_list[7]  = 4;
      Eccentricity_list[8]  = 5;
      Eccentricity_list[9]  = 6;
      Eccentricity_list[10] = 8;
      Eccentricity_list[11] = 9;

			// Fill Angle list array with 0:30:330. Angle of each arget (in degrees)
			tempVar = 0;
			while (tempVar < 12)
			{
				Angle_list[tempVar] = tempVar*30;                          // size of each target individually (degrees)
				tempVar            = tempVar + 1;
			}
    }
    // STOP SIGNAL TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_cmd_sess)
    {
      superSetSize = 2;

      Trls_per_block = 30;
      N_targ_pos     = 2;
      DR1_flag       = 1;

      Go_weight     = 0;
      Stop_weight   = 100;
      Ignore_weight = 0;

      Stop_sig_color[r_] = 17;
      Stop_sig_color[g_] = 13;
      Stop_sig_color[b_] = 14;

      Ignore_sig_color[r_] = 41;
      Ignore_sig_color[g_] = 42;
      Ignore_sig_color[b_] = 43;

      SSD_list[0]  = 4;
      SSD_list[1]  = 6;
      SSD_list[2]  = 8;
      SSD_list[3]  = 10;
      SSD_list[4]  = 12;
      SSD_list[5]  = 14;
      SSD_list[6]  = 16;
      SSD_list[7]  = 18;
      SSD_list[8]  = 20;
      SSD_list[9]  = 24;
      SSD_list[10] = 28;
      SSD_list[11] = 32;
      SSD_list[12] = 36;
      SSD_list[13] = 40;
      SSD_list[14] = 44;
      SSD_list[15] = 48;
      SSD_list[16] = 52;
      SSD_list[17] = 56;
      SSD_list[18] = 60;
      SSD_list[19] = 64;

			// Fill size list array with same values, for Target size in degrees
			tempVar = 0;
			while (tempVar < 8)
			{
				Size_list[tempVar] = 0.5;                          // size of each target individually (degrees)
				tempVar            = tempVar + 1;
			}

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 180;
      Angle_list[2] = 90;
      Angle_list[3] = 270;
      Angle_list[4] = 180;
      Angle_list[5] = -135;
      Angle_list[6] = -90;
      Angle_list[7] = -45;
    }
    // Memory Guided TASK SPECIFIC--------------------------------------------------------------------------------------

    if (task == run_mg_sess)
    {
      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_SOA         = 600;
      Max_SOA         = 1400;
      Expo_Jitter_SOA = 0;
      Exp_juice       = 1;
      Trial_length    = 5000;
      Cancl_time      = 1200;
      Min_Holdtime    = 500;                                    // minimum time after fixation before target presentation
      Max_Holdtime    = 1000;                                   // maximum time after fixation before target presentation

      Max_saccade_time = 700;
      Base_Reward_time = 30;
      Base_Punish_time = 5000;

      N_targ_pos = 8;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;
			// Fill size list array with same values, for Target size in degrees
			tempVar = 0;
			while (tempVar < 8)
			{
				Size_list[tempVar] = 1.5;                          // size of each target individually (degrees)
				tempVar            = tempVar + 1;
			}

      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 0;                         //63
      Ignore_sig_color[g_] = 36;
      Ignore_sig_color[b_] = 0;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      SOA_list[0]  = 200;
      SOA_list[1]  = 300;
      SOA_list[2]  = 400;
      SOA_list[3]  = 300;
      SOA_list[4]  = 400;
      SOA_list[5]  = 400;
      SOA_list[6]  = 900;
      SOA_list[7]  = 1000;
      SOA_list[8]  = 0;
      SOA_list[9]  = 0;
      SOA_list[10] = 0;
      SOA_list[11] = 0;
      SOA_list[12] = 0;
      SOA_list[13] = 0;
      SOA_list[14] = 0;
      SOA_list[15] = 0;
      SOA_list[16] = 0;
      SOA_list[17] = 0;
      SOA_list[18] = 0;
      SOA_list[19] = 0;
    }
    // FIXATION TASK SPECIFIC----------------------------------------------------------------------------
    if (task == run_fix_sess)
    {
      N_targ_pos = 9;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      Color_list[8, r_] = 35;
      Color_list[8, g_] = 33;
      Color_list[8, b_] = 27;


      Size_list[0] = 0.5;                                       // size of each target individually (degrees)
      Size_list[1] = 0.5;
      Size_list[2] = 0.5;
      Size_list[3] = 0.5;
      Size_list[4] = 0.5;
      Size_list[5] = 0.5;
      Size_list[6] = 0.5;
      Size_list[7] = 0.5;
      Size_list[8] = 0.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 90;
      Angle_list[2] = -90;
      Angle_list[3] = 180;
      Angle_list[4] = 0;
      Angle_list[5] = 135;
      Angle_list[6] = 45;
      Angle_list[7] = -135;
      Angle_list[8] = -45;

      Eccentricity_list[0] = 0.0;                       // distance of each target from center of screen individually (degrees)
      Eccentricity_list[1] = 11.0;
      Eccentricity_list[2] = 11.0;
      Eccentricity_list[3] = 11.0;
      Eccentricity_list[4] = 11.0;
      Eccentricity_list[5] = 15.6;
      Eccentricity_list[6] = 15.6;
      Eccentricity_list[7] = 15.6;
      Eccentricity_list[8] = 15.6;


      Fix_win_size  = 0;
      Targ_win_size = 3.5;

      Allowed_fix_time = 1200;
      Max_saccade_time = 800;
      Targ_hold_time   = 600;
    }
  }


  if (monkey == broca)
  {
    Set_tones = 1;

    Fix_win_size  = 3.5;
    Targ_win_size = 6;

    Allowed_fix_time = 1000;
    Max_saccade_time = 800;
    Base_Reward_time = 50;
    Base_Punish_time = 1000;


    // STOP SIGNAL TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_cmd_sess)
    {
      Trls_per_block = 20;

      DR1_flag = 1;

      Go_weight     = 50.0;
      Stop_weight   = 50.0;
      Ignore_weight = 0.0;

      Stop_sig_color[r_] = 0;
      Stop_sig_color[g_] = 36;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 63;
      Ignore_sig_color[g_] = 0;
      Ignore_sig_color[b_] = 0;

      SSD_list[0]  = 3;
      SSD_list[1]  = 13;
      SSD_list[2]  = 23;
      SSD_list[3]  = 33;
      SSD_list[4]  = 43;
      SSD_list[5]  = 53;
      SSD_list[6]  = 63;
      SSD_list[7]  = 0;
      SSD_list[8]  = 0;
      SSD_list[9]  = 0;
      SSD_list[10] = 0;
      SSD_list[11] = 0;
      SSD_list[12] = 0;
      SSD_list[13] = 0;
      SSD_list[14] = 0;
      SSD_list[15] = 0;
      SSD_list[16] = 0;
      SSD_list[17] = 0;
      SSD_list[18] = 0;
      SSD_list[19] = 0;
    }



    if (task == run_mg_sess)
    {
      Go_weight     = 90;
      Stop_weight   = 10;
      Ignore_weight = 0;

      Min_SOA         = 600;
      Max_SOA         = 1400;
      Expo_Jitter_SOA = 0;
      Exp_juice       = 1;
      Trial_length    = 5000;
      Cancl_time      = 1200;
      Min_Holdtime    = 500;                                    // minimum time after fixation before target presentation
      Max_Holdtime    = 1000;                                   // maximum time after fixation before target presentation



      Max_saccade_time = 400;
      Base_Reward_time = 100;
      Base_Punish_time = 1000;

      N_targ_pos = 2;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 0;
      Size_list[3] = 0;
      Size_list[4] = 0;
      Size_list[5] = 0;
      Size_list[6] = 0;
      Size_list[7] = 0;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 180;
      Angle_list[2] = 90;
      Angle_list[3] = 135;
      Angle_list[4] = 180;
      Angle_list[5] = -135;
      Angle_list[6] = -90;
      Angle_list[7] = -45;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 0;                         //63
      Ignore_sig_color[g_] = 36;
      Ignore_sig_color[b_] = 0;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      SOA_list[0]  = 50;
      SOA_list[1]  = 60;
      SOA_list[2]  = 70;
      SOA_list[3]  = 80;
      SOA_list[4]  = 90;
      SOA_list[5]  = 0;
      SOA_list[6]  = 0;
      SOA_list[7]  = 0;
      SOA_list[8]  = 0;
      SOA_list[9]  = 0;
      SOA_list[10] = 0;
      SOA_list[11] = 0;
      SOA_list[12] = 0;
      SOA_list[13] = 0;
      SOA_list[14] = 0;
      SOA_list[15] = 0;
      SOA_list[16] = 0;
      SOA_list[17] = 0;
      SOA_list[18] = 0;
      SOA_list[19] = 0;
    }
  }

  if (monkey == helmholtz)
  {
    Set_tones = 1;

    Fix_win_size  = 3.5;
    Targ_win_size = 6;

    Allowed_fix_time = 1000;
    Max_saccade_time = 800;
    Base_Reward_time = 30;
    Base_Punish_time = 10000;


    // STOP SIGNAL TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_cmd_sess)
    {
      Trls_per_block = 10000;

      DR1_flag = 0;

      Go_weight     = 100.0;
      Stop_weight   = 0.0;
      Ignore_weight = 0.0;

      Stop_sig_color[r_] = 0;
      Stop_sig_color[g_] = 36;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 63;
      Ignore_sig_color[g_] = 0;
      Ignore_sig_color[b_] = 0;

      SSD_list[0]  = 3;
      SSD_list[1]  = 13;
      SSD_list[2]  = 23;
      SSD_list[3]  = 33;
      SSD_list[4]  = 43;
      SSD_list[5]  = 53;
      SSD_list[6]  = 63;
      SSD_list[7]  = 0;
      SSD_list[8]  = 0;
      SSD_list[9]  = 0;
      SSD_list[10] = 0;
      SSD_list[11] = 0;
      SSD_list[12] = 0;
      SSD_list[13] = 0;
      SSD_list[14] = 0;
      SSD_list[15] = 0;
      SSD_list[16] = 0;
      SSD_list[17] = 0;
      SSD_list[18] = 0;
      SSD_list[19] = 0;

      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 1.5;
      Size_list[3] = 1.5;
      Size_list[4] = 1.5;
      Size_list[5] = 1.5;
      Size_list[6] = 1.5;
      Size_list[7] = 1.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 45;
      Angle_list[2] = 90;
      Angle_list[3] = 135;
      Angle_list[4] = 180;
      Angle_list[5] = -135;
      Angle_list[6] = -90;
      Angle_list[7] = -45;
    }
    //GO NO-GO TASK SPECIFIC-----------------------------------------------------------------------------------
    if (task == run_gonogo_sess)
    {
      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_SOA         = 0;
      Max_SOA         = 1000;
      Expo_Jitter_SOA = 0;


      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 1.5;
      Size_list[3] = 1.5;
      Size_list[4] = 1.5;
      Size_list[5] = 1.5;
      Size_list[6] = 1.5;
      Size_list[7] = 1.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 45;
      Angle_list[2] = 135;
      Angle_list[3] = 180;
      Angle_list[4] = -135;
      Angle_list[5] = -45;
      Angle_list[6] = 0;
      Angle_list[7] = 180;

      Stop_sig_color[r_] = 0;
      Stop_sig_color[g_] = 36;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 63;                        //63
      Ignore_sig_color[g_] = 0;
      Ignore_sig_color[b_] = 0;

      Mask_sig_color[r_] = 0;                                           //63
      Mask_sig_color[g_] = 0;
      Mask_sig_color[b_] = 0;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      SSD_list[0]  = 3;
      SSD_list[1]  = 8;
      SSD_list[2]  = 13;
      SSD_list[3]  = 18;
      SSD_list[4]  = 23;
      SSD_list[5]  = 28;
      SSD_list[6]  = 33;
      SSD_list[7]  = 38;
      SSD_list[8]  = 43;
      SSD_list[9]  = 48;
      SSD_list[10] = 0;
      SSD_list[11] = 0;
      SSD_list[12] = 0;
      SSD_list[13] = 0;
      SSD_list[14] = 0;
      SSD_list[15] = 0;
      SSD_list[16] = 0;
      SSD_list[17] = 0;
      SSD_list[18] = 0;
      SSD_list[19] = 0;
    }
    // MEMORY GUIDED TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_mg_sess)
    {
      TaskStim = 1;                                                  // stimulation mode on; will auto-stim during various task periods; 0 = no stim

      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_SOA         = 600;
      Max_SOA         = 1400;
      Expo_Jitter_SOA = 0;
      Exp_juice       = 1;
      Trial_length    = 5000;
      Cancl_time      = 1200;
      Min_Holdtime    = 500;                                   // minimum time after fixation before target presentation
      Max_Holdtime    = 500;                                   // maximum time after fixation before target presentation
      targ_hold_time  = 200;


      Max_saccade_time = 500;
      Base_Reward_time = 30;
      Base_Punish_time = 2000;

      N_targ_pos = 8;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 1.5;
      Size_list[3] = 1.5;
      Size_list[4] = 1.5;
      Size_list[5] = 1.5;
      Size_list[6] = 1.5;
      Size_list[7] = 1.5;

      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 0;                         //63
      Ignore_sig_color[g_] = 36;
      Ignore_sig_color[b_] = 0;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      SOA_list[0]  = 300;
      SOA_list[1]  = 450;
      SOA_list[2]  = 600;
      SOA_list[3]  = 750;
      SOA_list[4]  = 900;
      SOA_list[5]  = 1050;
      SOA_list[6]  = 1200;
      SOA_list[7]  = 1350;
      SOA_list[8]  = 0;
      SOA_list[9]  = 0;
      SOA_list[10] = 0;
      SOA_list[11] = 0;
      SOA_list[12] = 0;
      SOA_list[13] = 0;
      SOA_list[14] = 0;
      SOA_list[15] = 0;
      SOA_list[16] = 0;
      SOA_list[17] = 0;
      SOA_list[18] = 0;
      SOA_list[19] = 0;
    }
    // SEARCH TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_search_sess)
    {
      Trls_per_block   = 100;
      Base_Punish_time = 2000;
      Catch_Rew        = 1;                          // 1 = full base reward; allows us to set how much we divide base reward by on catch trials relative to target trials

      //// Probability cueing vars /////
      ProbCue  = 0;                                               // 1= prob cue on, 0 = prob cue off
      ProbSide = 1;                                               // 0=right; 1=left more probable target location
      /// Ultrasound vars /////
      VarEcc       = 0;                                           // 0 = off, 1 = on; variable eccentricity from list line 137 LOC_RAND.pro
      LatStruct    = 1;                                           // For US detection task: 0 = search items only at lateral positions; 1 = normal search, all locations
      Npulse       = 600;                                         //number of pulses sent
      PulseGap     = 1000;                                        //gap between pulses
      StimInterval = 600000;                                      //10 minutes = 600000ms
      StimCond     = 0;                                           //0 = stim starting block 1 (min 0), 1 = stim starting block 2 (min 10)

      ////////// Training-specific variables - allow user to use fixed distractor locations and identities
      ArrStruct = 1;                                         // 1=structured arrays, 0=contextual cueing
      //TrainOrt        = 1;
      TargTrainSet = 1;                                      //1=random loc, 2= fixed pos. 1, 3 = fixed pos 2., etc. up to max location number
      DistOrt      = 1;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt      = 2;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      SearchEcc    = 8;                                      //entricity in degrees; use to make fixed eccentricity
      SingMode     = 0;                                      //0=classic search, 1=singleton present/capture task, 2=variable singleton mode
      SingCol      = 2;
      PercSingTrl  = 50;                                     //Percentage of trials where singleton is present, see LOC_RAND.pro for code
      soa_mode     = 0;                                      //fixation response soa; 1=on, 0=off
      sVarsSet     = 0;


      ///////// Use this variable to manipulate predictability of Fixation / Search ISI
      FixJitter = 0;                                              // 0 = random fixation-search ISI; 1 = Fixed; see sets_trl.pro
      //////////

      catch_hold_time = 200;
      Perc_catch      = 0;                                           //percent catch trials
      TargetType      = 1;                                           //1 = L, 2 = T
      PlacPres        = 1;                                           //1 = no placeholders,  2 = placeholders
      SetSize         = 8;                                           //SS1 = 1, SS2 = 2, etc. up to set size 12;
      // Select Search task and Target/Distractor for Singleton Search
      SearchType = 2;                                                //Hetero = 1, Homo = 2, Homo Random = 3, 4 Singleton search mode (target/dist swap trial to trial)
      TargOrt1   = 2;                                                //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt2   = 2;                                                //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT

      //search_fix_time			= 0; //equiv to SOA - amount of time the fixation point stays on after target onset; fix off = go signal
      max_plactime = 700;
      min_plactime = 1000;

      targ_hold_time    = 200;
      Max_sacc_duration = 50;
      Min_saccade_time  = 70;
      Max_saccade_time  = 300;
      Min_Holdtime      = 300;                                 // minimum time after fixation before target presentation
      Max_Holdtime      = 800;                                 // maximum time after fixation before target presentation

      Go_weight     = 100.0;
      Stop_weight   = 0.0;
      Ignore_weight = 0.0;

      NonSingleton_color[r_] = 35;
      NonSingleton_color[g_] = 33;
      NonSingleton_color[b_] = 27;

      Size_list[0]  = 1.5;                                      // size of each target individually (degrees)
      Size_list[1]  = 1.5;
      Size_list[2]  = 1.5;
      Size_list[3]  = 1.5;
      Size_list[4]  = 1.5;
      Size_list[5]  = 1.5;
      Size_list[6]  = 1.5;
      Size_list[7]  = 1.5;
      Size_list[8]  = 1.5;
      Size_list[9]  = 1.5;
      Size_list[10] = 1.5;
      Size_list[11] = 1.5;


      // angle of each location individually (degrees) - only used for training/structured array mode
      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;
    }

    SOA_list[0] = 300;
    SOA_list[1] = 450;
    SOA_list[2] = 600;
    SOA_list[3] = 750;
    // PRO/ANTI ANTI TASK SPECIFIC----------------------------------------------------------------------------
    if (task == run_anti_sess)
    {
      Trls_per_block   = 100;
      Base_Punish_time = 2000;
      Catch_Rew        = 1;                          // 1 = full base reward; allows us to set how much we divide base reward by on catch trials relative to target trials
      basicPopOut      = 0;
      Reward_Offset    = 0;                          // how long after tone before juice is given (needed to seperate primary and secondary reinforcement)

      //// Probability cueing vars /////
      ProbCue  = 0;                                               // 1= prob cue on, 0 = prob cue off
      ProbSide = 1;                                               // 0=right; 1=left more probable target location
      /// Ultrasound vars /////
      VarEcc       = 0;                                           // 0 = off, 1 = on; variable eccentricity from list line 137 LOC_RAND.pro
      LatStruct    = 1;                                           // For US detection task: 0 = search items only at lateral positions; 1 = normal search, all locations
      Npulse       = 600;                                         //number of pulses sent
      PulseGap     = 1000;                                        //gap between pulses
      StimInterval = 600000;                                      //10 minutes = 600000ms
      StimCond     = 0;                                           //0 = stim starting block 1 (min 0), 1 = stim starting block 2 (min 10)

      ////////// Training-specific variables - allow user to use fixed distractor locations and identities
      ArrStruct = 1;                                         // 1=structured arrays, 0=contextual cueing
      //TrainOrt        = 1;
      TargTrainSet = 1;                                      //1=random loc, 2= fixed pos. 1, 3 = fixed pos 2., etc. up to max location number
      DistOrt      = 1;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt      = 2;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      SearchEcc    = 6;                                      //entricity in degrees; use to make fixed eccentricity
      SingMode     = 1;                                      //0=classic search, 1=singleton present/capture task, 2=variable singleton mode
      SingCol      = 0;                                      // 0 = red - see SET_CLRS.pro
      DistCol      = 1;                                      // 1 = green
      dynamicColor = 0;
      PercSingTrl  = 50;                                     //Percentage of trials where singleton is present, see LOC_RAND.pro for code
      soa_mode     = 1;                                      //fixation response soa; 1=on, 0=off

      colorProbs[0] = 1;
      colorProbs[1] = 1;
      colorProbs[2] = 0;
      colorProbs[3] = 0;
      colorProbs[4] = 0;
      colorProbs[5] = 0;
      nClrs         = 6;

      distColProbs[0] = 1;
      distColProbs[1] = 1;
      distColProbs[2] = 0;
      distColProbs[3] = 0;
      distColProbs[4] = 0;
      distColProbs[5] = 0;

      // Multiple Eccentricities stuff
      nEccs = 8;

      eccList[0] = 3;
      eccList[1] = 4;
      eccList[2] = 5;
      eccList[3] = 6;
      eccList[4] = 7;
      eccList[5] = 8;
      eccList[6] = 9;
      eccList[7] = 10;

      eccProbs[0] = 0;
      eccProbs[1] = 0;
      eccProbs[2] = 0;
      eccProbs[3] = 0;
      eccProbs[4] = 0;
      eccProbs[5] = 1;
      eccProbs[6] = 0;
      eccProbs[7] = 0;

      ///////// Use this variable to manipulate predictability of Fixation / Search ISI
      FixJitter = 0;                                              // 0 = random fixation-search ISI; 1 = Fixed; see sets_trl.pro
      //////////

      catch_hold_time = 800;
      Perc_catch      = 0;                                           //percent catch trials
      TargetType      = 1;                                           //1 = L, 2 = T
      PlacPres        = 1;                                           //1 = no placeholders,  2 = placeholders
      SetSize         = 4;                                           //SS1 = 1, SS2 = 2, etc. up to set size 12;
      // Select Search task and Target/Distractor for Singleton Search
      SearchType = 2;                                                //Hetero = 1, Homo = 2, Homo Random = 3, 4 Singleton search mode (target/dist swap trial to trial)
      TargOrt1   = 2;                                                //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt2   = 2;                                                //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT

      // Difficulties
      ndDifficulties = 5;
      ntDifficulties = 5;
      doCongruency   = 0;
      angleOffset    = 0;
      //search_fix_time			= 0; //equiv to SOA - amount of time the fixation point stays on after target onset; fix off = go signal
      max_plactime  = 700;
      min_plactime  = 1000;
      fixCue        = 1;
      cueCongThresh = 100;                                     // Completely congruent
      //curr_cuetime      = 500;  // How long to present cue
      neutCueThresh = 333;                                     // How often we should make the cue neutral while cuing trials
      // 333 makes pro, neutral, and anti cues occur evenly and lets neutral cues be 50/50 for target type
      // This works because it calculates backwards from the trial type, not forward from cue
      // That being the case, this percentage needs to be even on both pro and anti
      // trials in order to be non-predictive of the ensuing stimulus

      targ_hold_time    = 700;
      Max_sacc_duration = 50;
      helpDelay         = 50;
      Min_saccade_time  = 70;
      Max_saccade_time  = 1000;
      Min_Holdtime      = 300;                                 // minimum time after fixation before target presentation
      Max_Holdtime      = 800;                                 // maximum time after fixation before target presentation
      Min_cueTime       = 0;
      Max_cueTime       = 0;
      Go_weight         = 100.0;
      Stop_weight       = 0.0;
      Ignore_weight     = 0.0;
      Inter_trl_int     = 2000;                                 // how long between trials (only works if Fixed_trl_length == 0)
//
      NonSingleton_color[r_] = 35;
      NonSingleton_color[g_] = 33;
      NonSingleton_color[b_] = 27;

      lumOffset        = 0;
      ghost            = 0;
      leaveStimsPunish = 0;

      // Set colors for the cue conditions
      cueColors[0] = 2;
      cueColors[1] = 5;
      cueColors[2] = 3;

      Size_list[0]  = 1.5;                                      // size of each target individually (degrees)
      Size_list[1]  = 1.5;
      Size_list[2]  = 1.5;
      Size_list[3]  = 1.5;
      Size_list[4]  = 1.5;
      Size_list[5]  = 1.5;
      Size_list[6]  = 1.5;
      Size_list[7]  = 1.5;
      Size_list[8]  = 1.5;
      Size_list[9]  = 1.5;
      Size_list[10] = 1.5;
      Size_list[11] = 1.5;


      // angle of each location individually (degrees) - only used for training/structured array mode
      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      targProb[0] = 1;                                       //12:00
      targProb[1] = 1;
      targProb[2] = 1;                                       //3:00
      targProb[3] = 1;
      targProb[4] = 1;                                       //6:00
      targProb[5] = 1;
      targProb[6] = 1;                                       //9:00
      targProb[7] = 1;

      catchDifficulty = 5;
      catchDistDiff   = 1;
      catchH          = 1;
      catchV          = 1;

      // H dimension of color singleton options
      stimHorizontal[0] = .5;
      stimHorizontal[1] = 1;
      stimHorizontal[2] = 2;
      stimHorizontal[3] = .71;
      stimHorizontal[4] = 1.5;
      stimHorizontal[5] = .5;
      stimHorizontal[6] = .5;
      stimHorizontal[7] = .5;

      // V dimension of color singleton options
      stimVertical[0] = 2;
      stimVertical[1] = 1;
      stimVertical[2] = .5;
      stimVertical[3] = 1.41;
      stimVertical[4] = .71;
      stimVertical[5] = .5;
      stimVertical[6] = .5;
      stimVertical[7] = .5;

      // Relative probability of color singleton options
      targDiffProbs[0] = 1;
      targDiffProbs[1] = 0;
      targDiffProbs[2] = 1;
      targDiffProbs[3] = 0;
      targDiffProbs[4] = 0;
      targDiffProbs[5] = 0;
      targDiffProbs[6] = 0;
      targDiffProbs[7] = 0;

      // H dimension of non-singleton
      distH[0] = .5;
      distH[1] = 1;
      distH[2] = 2;
      distH[3] = .71;
      distH[4] = 1.5;
      distH[5] = .7;
      distH[6] = .7;
      distH[7] = .7;

      // V dimension of non-singleton
      distV[0] = 2;
      distV[1] = 1;
      distV[2] = .5;
      distV[3] = 1.41;
      distV[4] = .71;
      distV[5] = .7;
      distV[6] = .7;
      distV[7] = .7;

      // Relative probability of non-singleton options
      distDiffProbs[0] = 0;
      distDiffProbs[1] = 1;
      distDiffProbs[2] = 0;
      distDiffProbs[3] = 0;
      distDiffProbs[4] = 0;
      distDiffProbs[5] = 0;
      distDiffProbs[6] = 0;
      distDiffProbs[7] = 0;

      // Set congruent/incongruent relative probabilities
      congProb[0] = 1;                    // This will be congruent
      congProb[1] = 0;                    // This will be incongruent
      congProb[2] = 0;                    // This will be square

      // Here, we put in a section that says: if the singleton is square,
      //    on what percent of trials (if doing congruency) should it be what difficulty?
      catchDiffPerc[0] = 0;
      catchDiffPerc[1] = 1;
      catchDiffPerc[2] = 0;
      catchDiffPerc[3] = 0;
      catchDiffPerc[4] = 0;
      catchDiffPerc[5] = 0;
      catchDiffPerc[6] = 0;
      catchDiffPerc[7] = 0;


      // Are SOAs even relevant here? Let's take another look later
      SOA_list[0] = 0;
      SOA_list[1] = 0;
      SOA_list[2] = 0;
      SOA_list[3] = 0;
    }

    // Basic Color Popout
    if ((task == run_color_pop) || task == run_pop_prime)
    {
      //rintf("task = %d... Setting Color Pop Defaults\n",task);
      Trls_per_block   = 100;
      Base_Punish_time = 2000;
      Catch_Rew        = 1;                          // 1 = full base reward; allows us to set how much we divide base reward by on catch trials relative to target trials
      basicPopOut      = 1;
      countIncorrect   = 1;
      Reward_Offset    = 0;                                     // how long after tone before juice is given (needed to seperate primary and secondary reinforcement)

      //// Probability cueing vars /////
      ProbCue  = 0;                                               // 1= prob cue on, 0 = prob cue off
      ProbSide = 1;                                               // 0=right; 1=left more probable target location
      /// Ultrasound vars /////
      VarEcc       = 0;                                           // 0 = off, 1 = on; variable eccentricity from list line 137 LOC_RAND.pro
      LatStruct    = 1;                                           // For US detection task: 0 = search items only at lateral positions; 1 = normal search, all locations
      Npulse       = 600;                                         //number of pulses sent
      PulseGap     = 1000;                                        //gap between pulses
      StimInterval = 600000;                                      //10 minutes = 600000ms
      StimCond     = 0;                                           //0 = stim starting block 1 (min 0), 1 = stim starting block 2 (min 10)

      ////////// Training-specific variables - allow user to use fixed distractor locations and identities
      ArrStruct = 1;                                         // 1=structured arrays, 0=contextual cueing
      //TrainOrt        = 1;
      TargTrainSet = 1;                                      //1=random loc, 2= fixed pos. 1, 3 = fixed pos 2., etc. up to max location number
      DistOrt      = 1;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt      = 2;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      SearchEcc    = 6;                                      //entricity in degrees; use to make fixed eccentricity
      SingMode     = 1;                                      //0=classic search, 1=singleton present/capture task, 2=variable singleton mode
      SingCol      = 0;                                      // 0 = red - see SET_CLRS.pro
      DistCol      = 1;                                      // 1 = green
      nPerRun      = 5;
      nThisRun     = 0;
      PercSingTrl  = 50;                                              //Percentage of trials where singleton is present, see LOC_RAND.pro for code
      soa_mode     = 1;                                               //fixation response soa; 1=on, 0=off

      colorProbs[0] = 1;
      colorProbs[1] = 0;
      colorProbs[2] = 1;
      colorProbs[3] = 0;
      colorProbs[4] = 0;
      colorProbs[5] = 0;
      nClrs         = 6;

      distColProbs[0] = 0;
      distColProbs[1] = 1;
      distColProbs[2] = 1;
      distColProbs[3] = 0;
      distColProbs[4] = 0;
      distColProbs[5] = 0;


      if (task == run_color_pop)
      {
        dynamicColor = 0;
      }
      else if (task == run_pop_prime)
      {
        dynamicColor = 2;
      }

      // Multiple Eccentricities stuff
      nEccs = 8;

      eccList[0] = 3;
      eccList[1] = 4;
      eccList[2] = 5;
      eccList[3] = 6;
      eccList[4] = 7;
      eccList[5] = 8;
      eccList[6] = 9;
      eccList[7] = 10;

      eccProbs[0] = 0;
      eccProbs[1] = 0;
      eccProbs[2] = 0;
      eccProbs[3] = 1;
      eccProbs[4] = 0;
      eccProbs[5] = 0;
      eccProbs[6] = 0;
      eccProbs[7] = 0;

      ///////// Use this variable to manipulate predictability of Fixation / Search ISI
      FixJitter = 0;                                              // 0 = random fixation-search ISI; 1 = Fixed; see sets_trl.pro
      //////////

      catch_hold_time = 800;
      Perc_catch      = 0;                                           //percent catch trials
      TargetType      = 1;                                           //1 = L, 2 = T
      PlacPres        = 1;                                           //1 = no placeholders,  2 = placeholders
      SetSize         = 8;                                           //SS1 = 1, SS2 = 2, etc. up to set size 12;
      // Select Search task and Target/Distractor for Singleton Search
      SearchType = 2;                                                //Hetero = 1, Homo = 2, Homo Random = 3, 4 Singleton search mode (target/dist swap trial to trial)
      TargOrt1   = 2;                                                //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt2   = 2;                                                //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT

      // Difficulties
      ndDifficulties = 3;
      ntDifficulties = 3;
      doCongruency   = 0;
      angleOffset    = 0;
      //search_fix_time			= 0; //equiv to SOA - amount of time the fixation point stays on after target onset; fix off = go signal
      max_plactime  = 700;
      min_plactime  = 1000;
      fixCue        = 1;
      cueCongThresh = 100;                                     // Completely congruent
      //curr_cuetime      = 500;  // How long to present cue
      neutCueThresh = 333;                                     // How often we should make the cue neutral while cuing trials
      // 333 makes pro, neutral, and anti cues occur evenly and lets neutral cues be 50/50 for target type
      // This works because it calculates backwards from the trial type, not forward from cue
      // That being the case, this percentage needs to be even on both pro and anti
      // trials in order to be non-predictive of the ensuing stimulus

      targ_hold_time    = 400;
      Max_sacc_duration = 50;
      helpDelay         = 50;
      Min_saccade_time  = 70;
      Max_saccade_time  = 1000;
      Min_Holdtime      = 300;                                 // minimum time after fixation before target presentation
      Max_Holdtime      = 800;                                 // maximum time after fixation before target presentation
      Min_cueTime       = 0;
      Max_cueTime       = 0;
      Go_weight         = 100.0;
      Stop_weight       = 0.0;
      Ignore_weight     = 0.0;
      Inter_trl_int     = 2000;                                 // how long between trials (only works if Fixed_trl_length == 0)
//
      NonSingleton_color[r_] = 35;
      NonSingleton_color[g_] = 33;
      NonSingleton_color[b_] = 27;

      lumOffset        = 0;
      ghost            = 0;
      leaveStimsPunish = 0;

      // Set colors for the cue conditions
      cueColors[0] = 2;
      cueColors[1] = 5;
      cueColors[2] = 3;

      Size_list[0]  = 1.5;                                      // size of each target individually (degrees)
      Size_list[1]  = 1.5;
      Size_list[2]  = 1.5;
      Size_list[3]  = 1.5;
      Size_list[4]  = 1.5;
      Size_list[5]  = 1.5;
      Size_list[6]  = 1.5;
      Size_list[7]  = 1.5;
      Size_list[8]  = 1.5;
      Size_list[9]  = 1.5;
      Size_list[10] = 1.5;
      Size_list[11] = 1.5;


      // angle of each location individually (degrees) - only used for training/structured array mode
      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      targProb[0] = 1;                                       //12:00
      targProb[1] = 1;
      targProb[2] = 1;                                       //3:00
      targProb[3] = 1;
      targProb[4] = 1;                                       //6:00
      targProb[5] = 1;
      targProb[6] = 1;                                       //9:00
      targProb[7] = 1;

      catchDifficulty = 5;
      catchDistDiff   = 1;
      catchH          = 1;
      catchV          = 1;

      // H dimension of color singleton options
      stimHorizontal[0] = 1;
      stimHorizontal[1] = 1;
      stimHorizontal[2] = 1;
      stimHorizontal[3] = .5;
      stimHorizontal[4] = .5;
      stimHorizontal[5] = .5;
      stimHorizontal[6] = .5;
      stimHorizontal[7] = .5;

      // V dimension of color singleton options
      stimVertical[0] = 1;
      stimVertical[1] = 1;
      stimVertical[2] = 1;
      stimVertical[3] = .5;
      stimVertical[4] = .5;
      stimVertical[5] = .5;
      stimVertical[6] = .5;
      stimVertical[7] = .5;

      // Relative probability of color singleton options
      targDiffProbs[0] = 1;
      targDiffProbs[1] = 0;
      targDiffProbs[2] = 0;
      targDiffProbs[3] = 0;
      targDiffProbs[4] = 0;
      targDiffProbs[5] = 0;
      targDiffProbs[6] = 0;
      targDiffProbs[7] = 0;

      // H dimension of non-singleton
      distH[0] = 1;
      distH[1] = 1;
      distH[2] = 1;
      distH[3] = .7;
      distH[4] = .7;
      distH[5] = .7;
      distH[6] = .7;
      distH[7] = .7;

      // V dimension of non-singleton
      distV[0] = 1;
      distV[1] = 1;
      distV[2] = 1;
      distV[3] = .7;
      distV[4] = .7;
      distV[5] = .7;
      distV[6] = .7;
      distV[7] = .7;

      // Relative probability of non-singleton options
      distDiffProbs[0] = 1;
      distDiffProbs[1] = 0;
      distDiffProbs[2] = 0;
      distDiffProbs[3] = 0;
      distDiffProbs[4] = 0;
      distDiffProbs[5] = 0;
      distDiffProbs[6] = 0;
      distDiffProbs[7] = 0;

      // Set congruent/incongruent relative probabilities
      congProb[0] = 0;                    // This will be congruent
      congProb[1] = 0;                    // This will be incongruent
      congProb[2] = 1;                    // This will be square

      // Here, we put in a section that says: if the singleton is square,
      //    on what percent of trials (if doing congruency) should it be what difficulty?
      catchDiffPerc[0] = 1;
      catchDiffPerc[1] = 0;
      catchDiffPerc[2] = 0;
      catchDiffPerc[3] = 0;
      catchDiffPerc[4] = 0;
      catchDiffPerc[5] = 0;
      catchDiffPerc[6] = 0;
      catchDiffPerc[7] = 0;


      // Are SOAs even relevant here? Let's take another look later
      SOA_list[0] = 0;
      SOA_list[1] = 0;
      SOA_list[2] = 0;
      SOA_list[3] = 0;
    }

    // FIXATION TASK SPECIFIC----------------------------------------------------------------------------

    if (task == run_fix_sess)
    {
      N_targ_pos = 9;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      Color_list[8, r_] = 35;
      Color_list[8, g_] = 33;
      Color_list[8, b_] = 27;


      Size_list[0] = 0.5;                                       // size of each target individually (degrees)
      Size_list[1] = 0.5;
      Size_list[2] = 0.5;
      Size_list[3] = 0.5;
      Size_list[4] = 0.5;
      Size_list[5] = 0.5;
      Size_list[6] = 0.5;
      Size_list[7] = 0.5;
      Size_list[8] = 0.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 90;
      Angle_list[2] = -90;
      Angle_list[3] = 180;
      Angle_list[4] = 0;
      Angle_list[5] = 135;
      Angle_list[6] = 45;
      Angle_list[7] = -135;
      Angle_list[8] = -45;

      Eccentricity_list[0] = 0.0;                       // distance of each target from center of screen individually (degrees)
      Eccentricity_list[1] = 11.0;
      Eccentricity_list[2] = 11.0;
      Eccentricity_list[3] = 11.0;
      Eccentricity_list[4] = 11.0;
      Eccentricity_list[5] = 15.6;
      Eccentricity_list[6] = 15.6;
      Eccentricity_list[7] = 15.6;
      Eccentricity_list[8] = 15.6;

      Fix_win_size  = 0;
      Targ_win_size = 2.5;

      Allowed_fix_time = 1200;
      Max_saccade_time = 800;
      Targ_hold_time   = 600;
    }

    // DELAYED SACCADE TASK SPECIFIC----------------------------------------------------------------------------

    if (task == run_delayed_sess)
    {
      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_Holdtime  = 500;                                      // minimum time after fixation before target presentation
      Max_Holdtime  = 1000;                                     // maximum time after fixation before target presentation
      Min_SOA       = 200;                                      // minimum time between target onset and fixation offset (mem guided only)
      Max_SOA       = 200;                                      // maximum time between target onset and fixation offset (mem guided only)
      Reward_Offset = 0;                                        // how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
      Exp_juice     = 0;

      N_targ_pos = 4;

      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      Size_list[0]  = 1.5;                                      // size of each target individually (degrees)
      Size_list[1]  = 1.5;
      Size_list[2]  = 1.5;
      Size_list[3]  = 1.5;
      Size_list[4]  = 1.5;
      Size_list[5]  = 1.5;
      Size_list[6]  = 1.5;
      Size_list[7]  = 1.5;
      Size_list[8]  = 1.5;
      Size_list[9]  = 1.5;
      Size_list[10] = 1.5;
      Size_list[11] = 1.5;


      SOA_list[0]  = 200;
      SOA_list[1]  = 200;
      SOA_list[2]  = 300;
      SOA_list[3]  = 300;
      SOA_list[4]  = 400;
      SOA_list[5]  = 1100;
      SOA_list[6]  = 1200;
      SOA_list[7]  = 1300;
      SOA_list[8]  = 0;
      SOA_list[9]  = 0;
      SOA_list[10] = 0;
      SOA_list[11] = 0;
      SOA_list[12] = 0;
      SOA_list[13] = 0;
      SOA_list[14] = 0;
      SOA_list[15] = 0;
      SOA_list[16] = 0;
      SOA_list[17] = 0;
      SOA_list[18] = 0;
      SOA_list[19] = 0;
    }
    //--------------------------------------------------------------------------------------------------------------------
    // Flash task
    if (task == run_flash_sess)
    {
      Success_Tone_medR = 200;
      Base_Reward_time  = 100;
      Fix_win_size      = 22;
      IFI               = 1000;
      flashTime         = 100;
    }
  }


  if (monkey == gauss)
  {
    // GENERAL ACROSS ALL TASKS---------------------------------------------------------------------------------------
    // distance from center of subjects eyeball to screen
    /*if(room == 28)
     *      {
     *      Subj_dist	= 445.0;
     *      TrainingStill = 0;
     *      }
     * else if (room == 29)
     *      {
     *      Subj_dist	= 535.0;
     *      }
     */
    // else if (room == 23)
    // {
    // }

    Set_tones = 1;

    Fix_win_size  = 3.5;
    Targ_win_size = 6;

    Allowed_fix_time = 1000;
    Max_saccade_time = 350;
    Base_Reward_time = 30;
    Base_Punish_time = 5000;


    // STOP SIGNAL TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_cmd_sess)
    {
      Trls_per_block = 10000;

      DR1_flag = 0;

      Go_weight     = 100.0;
      Stop_weight   = 0.0;
      Ignore_weight = 0.0;

      Stop_sig_color[r_] = 0;
      Stop_sig_color[g_] = 36;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 63;
      Ignore_sig_color[g_] = 0;
      Ignore_sig_color[b_] = 0;

      SSD_list[0]  = 3;
      SSD_list[1]  = 13;
      SSD_list[2]  = 23;
      SSD_list[3]  = 33;
      SSD_list[4]  = 43;
      SSD_list[5]  = 53;
      SSD_list[6]  = 63;
      SSD_list[7]  = 0;
      SSD_list[8]  = 0;
      SSD_list[9]  = 0;
      SSD_list[10] = 0;
      SSD_list[11] = 0;
      SSD_list[12] = 0;
      SSD_list[13] = 0;
      SSD_list[14] = 0;
      SSD_list[15] = 0;
      SSD_list[16] = 0;
      SSD_list[17] = 0;
      SSD_list[18] = 0;
      SSD_list[19] = 0;

      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 1.5;
      Size_list[3] = 1.5;
      Size_list[4] = 1.5;
      Size_list[5] = 1.5;
      Size_list[6] = 1.5;
      Size_list[7] = 1.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 45;
      Angle_list[2] = 90;
      Angle_list[3] = 135;
      Angle_list[4] = 180;
      Angle_list[5] = -135;
      Angle_list[6] = -90;
      Angle_list[7] = -45;
    }
    //GO NO-GO TASK SPECIFIC-----------------------------------------------------------------------------------
    if (task == run_gonogo_sess)
    {
      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_SOA         = 0;
      Max_SOA         = 1000;
      Expo_Jitter_SOA = 0;


      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 1.5;
      Size_list[3] = 1.5;
      Size_list[4] = 1.5;
      Size_list[5] = 1.5;
      Size_list[6] = 1.5;
      Size_list[7] = 1.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 45;
      Angle_list[2] = 135;
      Angle_list[3] = 180;
      Angle_list[4] = -135;
      Angle_list[5] = -45;
      Angle_list[6] = 0;
      Angle_list[7] = 180;

      Stop_sig_color[r_] = 0;
      Stop_sig_color[g_] = 36;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 63;                        //63
      Ignore_sig_color[g_] = 0;
      Ignore_sig_color[b_] = 0;

      Mask_sig_color[r_] = 0;                                           //63
      Mask_sig_color[g_] = 0;
      Mask_sig_color[b_] = 0;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      SSD_list[0]  = 3;
      SSD_list[1]  = 8;
      SSD_list[2]  = 13;
      SSD_list[3]  = 18;
      SSD_list[4]  = 23;
      SSD_list[5]  = 28;
      SSD_list[6]  = 33;
      SSD_list[7]  = 38;
      SSD_list[8]  = 43;
      SSD_list[9]  = 48;
      SSD_list[10] = 0;
      SSD_list[11] = 0;
      SSD_list[12] = 0;
      SSD_list[13] = 0;
      SSD_list[14] = 0;
      SSD_list[15] = 0;
      SSD_list[16] = 0;
      SSD_list[17] = 0;
      SSD_list[18] = 0;
      SSD_list[19] = 0;
    }
    // MEMORY GUIDED TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_mg_sess)
    {
      TaskStim = 1;                                                  // 1 = stimulation mode on; will auto-stim during various task periods; 0 = no stim

      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_SOA         = 300;
      Max_SOA         = 1400;
      Expo_Jitter_SOA = 0;
      Exp_juice       = 1;
      Trial_length    = 5000;
      Cancl_time      = 1200;
      Min_Holdtime    = 500;                                    // minimum time after fixation before target presentation
      Max_Holdtime    = 1000;                                   // maximum time after fixation before target presentation

      Max_saccade_time = 350;
      Base_Reward_time = 30;
      Base_Punish_time = 5000;

      N_targ_pos = 8;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Size_list[0] = 1.5;                                       // size of each target individually (degrees)
      Size_list[1] = 1.5;
      Size_list[2] = 1.5;
      Size_list[3] = 1.5;
      Size_list[4] = 1.5;
      Size_list[5] = 1.5;
      Size_list[6] = 1.5;
      Size_list[7] = 1.5;

      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      Stop_sig_color[r_] = 63;
      Stop_sig_color[g_] = 0;
      Stop_sig_color[b_] = 0;

      Ignore_sig_color[r_] = 0;                         //63
      Ignore_sig_color[g_] = 36;
      Ignore_sig_color[b_] = 0;

      /* Color_list[0,r_]		= 35;	// gray
       * Color_list[0,g_]		= 33;	//
       * Color_list[0,b_]		= 27;	//
       *
       * Color_list[1,r_]		= 63;	// red
       * Color_list[1,g_]		= 0;
       * Color_list[1,b_]		= 0;
       *
       * Color_list[2,r_]		= 0;	// green
       * Color_list[2,g_]		= 36;
       * Color_list[2,b_]		= 0;
       *
       * Color_list[3,r_]		= 0;	// blue
       * Color_list[3,g_]		= 0;
       * Color_list[3,b_]		= 59;
       *
       * Color_list[4,r_]		= 100;	// yellow
       * Color_list[4,g_]		= 100;
       * Color_list[4,b_]		= 0;
       *
       * Color_list[5,r_]		= 255;	// magenta
       * Color_list[5,g_]		= 33;
       * Color_list[5,b_]		= 255;
       *
       * Color_list[6,r_]		= 153;	// brown
       * Color_list[6,g_]		= 76;
       * Color_list[6,b_]		= 0;
       *
       * Color_list[7,r_]		= 255;	// white
       * Color_list[7,g_]		= 255;
       * Color_list[7,b_]		= 255;  */

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;



      SOA_list[0]  = 300;
      SOA_list[1]  = 400;
      SOA_list[2]  = 500;
      SOA_list[3]  = 600;
      SOA_list[4]  = 1200;
      SOA_list[5]  = 1400;
      SOA_list[6]  = 1600;
      SOA_list[7]  = 1800;
      SOA_list[8]  = 2000;
      SOA_list[9]  = 0;
      SOA_list[10] = 0;
      SOA_list[11] = 0;
      SOA_list[12] = 0;
      SOA_list[13] = 0;
      SOA_list[14] = 0;
      SOA_list[15] = 0;
      SOA_list[16] = 0;
      SOA_list[17] = 0;
      SOA_list[18] = 0;
      SOA_list[19] = 0;
    }

    // SEARCH TASK SPECIFIC--------------------------------------------------------------------------------------
    if (task == run_search_sess)
    {
      Trls_per_block   = 100;
      Base_Punish_time = 5000;
      Catch_Rew        = 1;                          // 1 = full base reward; allows us to set how much we divide base reward by on catch trials relative to target trials
      Consec_trl       = 0;                          //min number of consecutive correct trials (plus one) required to get reward

      //// Probability cueing vars /////
      ProbCue  = 0;                                                  // 1= prob cue on, 0 = prob cue off
      ProbSide = 1;                                                  // 0=right; 1=left more probable target location

      /// Ultrasound vars /////
      VarEcc       = 0;                                           // 0 = off, 1 = on; variable eccentricity from list line 137 LOC_RAND.pro
      LatStruct    = 1;                                           // For US detection task: 0 = search items only at 4 corners; 1 = normal search, all locations
      Npulse       = 600;                                         //number of pulses sent
      PulseGap     = 1000;                                        //gap between pulses
      StimInterval = 600000;                                      //10 minutes = 600000ms
      StimCond     = 0;                                           //0 = stim starting block 1 (min 0), 1 = stim starting block 2 (min 10)

      ////////// Training-specific variables - allow user to use fixed distractor locations and identities
      ArrStruct = 1;                                                 // 1 = Sets locations to fixed eccentricity and angle, set using SearchEcc below, 0 = contextual cueing
      //For Capture Task: 0 = normal target/dist positions, 1 = only lateral and/or up/down positions (lat only vs lat up/down depends on TgAng set in LOCRAND.pro being 2 vs 4)
      //TrainOrt        = 1; // 1 = Sets orientations to fixed orient, using TargOrt and DistOrt below//
      TargTrainSet = 1;                                      //1 = random loc, 2= fixed pos. 1, 3 = fixed pos 2., etc. up to max location number
      DistOrt      = 4;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT,
      TargOrt      = 2;                                      //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      SearchEcc    = 8;                                      //Eccentricity in degrees; use to make fixed eccentricity
      SingMode     = 0;                                      //0=classic search, 1=singleton present/capture task
      SingCol      = 1;
      PercSingTrl  = 50;                                     //Percentage of trials where singleton is present, see LOC_RAND.pro for code
      soa_mode     = 0;                                      //fixation response soa; 1=on, 0=off

      ///////// Use this variable to manipulate predictability of Fixation / Search ISI
      FixJitter = 0;                                              // 0 = Random fixation-search ISI; 1 = Fixed; see sets_trl.pro
      //////////

      catch_hold_time = 175;
      Perc_catch      = 0;                                           //percent catch trials
      TargetType      = 1;                                           //1 = L, 2 = T
      PlacPres        = 1;                                           //1 = no placeholders,  2 = placeholders
      SetSize         = 8;                                           //SS1 = 1, SS2 = 2, etc. up to set size 12
      // Select Search task and Target/Distractor for Singleton Search
      SearchType = 2;                                                //Hetero = 1, Homo = 2, Homo Random = 3, Singleton search mode = 4 (target/dist swap trial to trial), 5 = All Orientation of target, for detection only (area 45b pilot)
      //TargOrt variables below only necessary for singleton search mode
      TargOrt1 = 3;                                                  //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT
      TargOrt2 = 3;                                                  //T/L - 1=UP, 2=INV, 3=LEFT, 4=RIGHT

      //search_fix_time			= 1000; //equiv to SOA - amount of time the fixation point stays on after target onset; fix off = go signal
      max_plactime = 700;
      min_plactime = 1000;

      targ_hold_time    = 200;
      Max_sacc_duration = 50;
      Min_saccade_time  = 70;
      Max_saccade_time  = 300;
      Min_Holdtime      = 300;                                  // minimum time after fixation before target presentation
      Max_Holdtime      = 1000;                                 // maximum time after fixation before target presentation

      Go_weight     = 100.0;
      Stop_weight   = 0.0;
      Ignore_weight = 0.0;

      NonSingleton_color[r_] = 35;
      NonSingleton_color[g_] = 33;
      NonSingleton_color[b_] = 27;


      Size_list[0]  = 1.5;                                      // size of each target individually (degrees)
      Size_list[1]  = 1.5;
      Size_list[2]  = 1.5;
      Size_list[3]  = 1.5;
      Size_list[4]  = 1.5;
      Size_list[5]  = 1.5;
      Size_list[6]  = 1.5;
      Size_list[7]  = 1.5;
      Size_list[8]  = 1.5;
      Size_list[9]  = 1.5;
      Size_list[10] = 1.5;
      Size_list[11] = 1.5;

      Eccentricity_list[0]  = 3;
      Eccentricity_list[1]  = 6;
      Eccentricity_list[2]  = 9;
      Eccentricity_list[3]  = 6;
      Eccentricity_list[4]  = 6;
      Eccentricity_list[5]  = 9;
      Eccentricity_list[6]  = 2;
      Eccentricity_list[7]  = 4;
      Eccentricity_list[8]  = 5;
      Eccentricity_list[9]  = 6;
      Eccentricity_list[10] = 8;
      Eccentricity_list[11] = 9;

      Angle_list[0] = 90;                                    //12:00
      Angle_list[1] = 45;
      Angle_list[2] = 0;                                     //3:00
      Angle_list[3] = 315;
      Angle_list[4] = 270;                                   //6:00
      Angle_list[5] = 225;
      Angle_list[6] = 180;                                   //9:00
      Angle_list[7] = 135;

      SOA_list[0] = 250;
      SOA_list[1] = 300;
      SOA_list[2] = 350;
      SOA_list[3] = 400;
    }

    // FIXATION TASK SPECIFIC----------------------------------------------------------------------------

    if (task == run_fix_sess)
    {
      N_targ_pos = 9;

      Color_list[0, r_] = 35;                                   // color of each target individually
      Color_list[0, g_] = 33;                                   // color of each target individually
      Color_list[0, b_] = 27;                                   // color of each target individually

      Color_list[1, r_] = 35;
      Color_list[1, g_] = 33;
      Color_list[1, b_] = 27;

      Color_list[2, r_] = 35;
      Color_list[2, g_] = 33;
      Color_list[2, b_] = 27;

      Color_list[3, r_] = 35;
      Color_list[3, g_] = 33;
      Color_list[3, b_] = 27;

      Color_list[4, r_] = 35;
      Color_list[4, g_] = 33;
      Color_list[4, b_] = 27;

      Color_list[5, r_] = 35;
      Color_list[5, g_] = 33;
      Color_list[5, b_] = 27;

      Color_list[6, r_] = 35;
      Color_list[6, g_] = 33;
      Color_list[6, b_] = 27;

      Color_list[7, r_] = 35;
      Color_list[7, g_] = 33;
      Color_list[7, b_] = 27;

      Color_list[8, r_] = 35;
      Color_list[8, g_] = 33;
      Color_list[8, b_] = 27;


      Size_list[0] = 0.5;                                       // size of each target individually (degrees)
      Size_list[1] = 0.5;
      Size_list[2] = 0.5;
      Size_list[3] = 0.5;
      Size_list[4] = 0.5;
      Size_list[5] = 0.5;
      Size_list[6] = 0.5;
      Size_list[7] = 0.5;
      Size_list[8] = 0.5;

      Angle_list[0] = 0;                                        // angle of each target individually (degrees)
      Angle_list[1] = 90;
      Angle_list[2] = -90;
      Angle_list[3] = 180;
      Angle_list[4] = 0;
      Angle_list[5] = 135;
      Angle_list[6] = 45;
      Angle_list[7] = -135;
      Angle_list[8] = -45;

      Eccentricity_list[0] = 0.0;                       // distance of each target from center of screen individually (degrees)
      Eccentricity_list[1] = 11.0;
      Eccentricity_list[2] = 11.0;
      Eccentricity_list[3] = 11.0;
      Eccentricity_list[4] = 11.0;
      Eccentricity_list[5] = 15.6;
      Eccentricity_list[6] = 15.6;
      Eccentricity_list[7] = 15.6;
      Eccentricity_list[8] = 15.6;

      Fix_win_size  = 0;
      Targ_win_size = 2.5;

      Allowed_fix_time = 1200;
      Max_saccade_time = 800;
      Targ_hold_time   = 600;
    }

    // DELAYED SACCADE TASK SPECIFIC----------------------------------------------------------------------------

    if (task == run_delayed_sess)
    {
      Go_weight     = 100;
      Stop_weight   = 0;
      Ignore_weight = 0;

      Min_Holdtime  = 500;                                      // minimum time after fixation before target presentation
      Max_Holdtime  = 1000;                                     // maximum time after fixation before target presentation
      Min_SOA       = 200;                                      // minimum time between target onset and fixation offset (mem guided only)
      Max_SOA       = 200;                                      // maximum time between target onset and fixation offset (mem guided only)
      Reward_Offset = 0;                                        // how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
      Exp_juice     = 0;

      N_targ_pos = 8;

      Angle_list[0] = 90;                                     // angle of each target individually (degrees)
      Angle_list[1] = 270;                                    //270
      Angle_list[2] = 0;
      Angle_list[3] = 180;
      Angle_list[4] = 45;
      Angle_list[5] = 135;
      Angle_list[6] = 225;
      Angle_list[7] = 315;

      Size_list[0]  = 1.5;                                      // size of each target individually (degrees)
      Size_list[1]  = 1.5;
      Size_list[2]  = 1.5;
      Size_list[3]  = 1.5;
      Size_list[4]  = 1.5;
      Size_list[5]  = 1.5;
      Size_list[6]  = 1.5;
      Size_list[7]  = 1.5;
      Size_list[8]  = 1.5;
      Size_list[9]  = 1.5;
      Size_list[10] = 1.5;
      Size_list[11] = 1.5;

      SOA_list[0]  = 300;
      SOA_list[1]  = 300;
      SOA_list[2]  = 400;
      SOA_list[3]  = 400;
      SOA_list[4]  = 500;
      SOA_list[5]  = 400;
      SOA_list[6]  = 900;
      SOA_list[7]  = 1000;
      SOA_list[8]  = 0;
      SOA_list[9]  = 0;
      SOA_list[10] = 0;
      SOA_list[11] = 0;
      SOA_list[12] = 0;
      SOA_list[13] = 0;
      SOA_list[14] = 0;
      SOA_list[15] = 0;
      SOA_list[16] = 0;
      SOA_list[17] = 0;
      SOA_list[18] = 0;
      SOA_list[19] = 0;
    }
    //--------------------------------------------------------------------------------------------------------------------
    // Flash task
    if (task == run_flash_sess)
    {
      Success_Tone_medR = 200;
      Base_Reward_time  = 100;
      Fix_win_size      = 22;
      IFI               = 1000;
      flashTime         = 100;
      SingCol           = 6;
    }
  }
} /* DEFAULT */
