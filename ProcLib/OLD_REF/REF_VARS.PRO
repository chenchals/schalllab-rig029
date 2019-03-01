// These are the user defined global variables needed to run the countermanding task
// These are the user defined global variables needed to run the countermanding task
//
// written by david.c.godlove@vanderbilt.edu  January, 2011; modified by joshua.d.cosman@vanderbilt.edu, July 2013

// Room selection
declare int Room;

// Trial counters
declare int   Trl_number;
declare int   Comp_Trl_number;
declare float Rand_Comp_Trl_number_DP;  //search specific - gives correct number of dist pres trials; see END_TRL.pro
declare float Rand_Comp_Trl_number_DA;  //search specific - gives correct number of dist abs trials
declare float Rep_Comp_Trl_number;      //search specific - gives correct number of repeat trials; see END_TRL.pro
declare float Rand_Comp_Trl_number;     //search specific - gives correct number of random trials
declare float Rand_Comp_NG_Trl;         //search specific - gives correct number of random NOGO/catch trials
declare float Rand_Comp_Trl_DA;         //search specific - gives correct number of random NOGO/catch trials for sing. session
declare float Rand_Comp_Trl_DP;         //search specific - gives correct number of random NOGO/catch trials
declare float Rep_Comp_NG_Trl;          //search specific - gives correct number of repeat NOGO/catch trials

// Below section is pro/anti specific
declare float Pro_Comp_Trl_number   = 0;
declare float pro_inacc_sacc        = 0;
declare float ProPerAcc             = 0;
declare float cum_pro_rt            = 0;
declare float avg_pro_rt            = 0;
declare float Anti_Comp_Trl_number  = 0;
declare float anti_inacc_sacc       = 0;
declare float AntiPerAcc            = 0;
declare float avg_anti_rt           = 0;
declare float cum_anti_rt           = 0;
declare float Catch_Comp_Trl_number = 0;
declare float catch_inacc_sacc      = 0;
declare float CatchPerAcc           = 0;
declare float Pro_Cong_Trl_number   = 0;
declare float pro_cong_inacc        = 0;
declare float ProCongAcc            = 0;
declare float Pro_ICong_Trl_number  = 0;
declare float pro_icong_inacc       = 0;
declare float ProICongAcc           = 0;
declare float Pro_CCong_Trl_number  = 0;
declare float pro_ccong_inacc       = 0;
declare float ProCCongAcc           = 0;
declare float Anti_Cong_Trl_number  = 0;
declare float anti_cong_inacc       = 0;
declare float AntiCongAcc           = 0;
declare float Anti_ICong_Trl_number = 0;
declare float anti_icong_inacc      = 0;
declare float AntiICongAcc          = 0;
declare float Anti_CCong_Trl_number = 0;
declare float anti_ccong_inacc      = 0;
declare float AntiCCongAcc          = 0;


//----------------------------------------------------------------------------------------------------------------
// Online analysis variables
declare int   RandPerAcc;
declare int   RepPerAcc;
declare int   RandPerAcc_DA;
declare int   RandPerAcc_DP;
declare float rand_inacc_sacc;
declare float rep_inacc_sacc;
declare float rand_inacc_sacc_DA;
declare float rand_inacc_sacc_DP;
declare float current_rt;                       //search specific - gives current RT for use in graph calculations
declare float cum_rep_rt;
declare float avg_rep_rt;
declare float graph_rep_rt;
declare float cum_rand_rt;
declare float avg_rand_rt;
declare float cum_rand_rt_DA;
declare float avg_rand_rt_DA;
declare float cum_rand_rt_DP;
declare float avg_rand_rt_DP;
declare float graph_rand_rt;
declare int   Correct_trls;
declare float Consec_corr;
declare int   Block_number;
declare int   Trls_per_block;                           // for one directional reward paradigm


//----------------------------------------------------------------------------------------------------------------
// Trial type distributions (must sum to 100)
declare float Go_weight;                        // percentage of go trials
declare float Stop_weight;                      // percentage of stop trials
declare float Ignore_weight;                    // percentage of ignore trials

declare int   DR1_flag;                         // shows that we are doing 1DR version of task

declare float Bonus_weight;                     // percentage of time that the subject is wrong but gets rewarded anyway.
declare float Dealer_wins_weight;               // percentage of time that the subject is right but gets punished anyway.

declare float BigR_weight = 0.3;                // weights for random changes of reward size
declare float MedR_weight = 0.2;                // weights for random changes of reward size
declare float SmlR_weight = 0.1;                // weights for random changes of reward size
declare float SmlP_weight = 0.1;                // weights for random changes of punsiment size
declare float MedP_weight = 0.2;                // weights for random changes of punsiment size
declare float BigP_weight = 0.3;                // weights for random changes of punsiment size


//----------------------------------------------------------------------------------------------------------------
// Stimulus properties
////////////////Search Specific
declare int   Catch;                                                          // determines catch trial or not, SETS_TRL.pro
declare int   CatchCode;                                                      // determines catch trial type for event code
declare float Perc_catch;                                                     // percentage catch trials, set in DEFAULT.pro
declare int   PlacPres;                                                       // determines presence of placeholders in search task -- 0 = no placeholders,  1 = placeholders
declare int   SearchType;                                                     // determines homo/hetero distractors -- Hetero = 1, Homo = 2
declare int   TargetType;                                                     // determines Target Type -- L = 1, T = 2
declare int   TrialTp;                                                        // determines random/repeated displays
declare int   SetSize;                                                        // determines set size via following values -- SS1 = 1, SS2 = 2, SS4 = 3, SS8 = 4, SS12 = 5
declare int   soa_mode;                                                       // turns search soa mode on/off, see DEFAULT.pro
declare int   Consec_trl;                                                     // consec trials to get reward
//Contextual cue related target and distractor locations
declare float Dist_Ecc_list[9]    = { 5, 11, 14, 5, 11, 14, 5, 11, 14 };      // distance of each target from center of screen individually (degrees)	declare hide float  targ_angle;
declare float Dist_Ang_list[8]    = { 25, 65, 115, 155, 205, 245, 295, 335 }; //off cardinal coords., ensures that displays are L/R lateralized
declare float RanTarg_Ang_list[4] = { 65, 155, 245, 335 };                    //off cardinal coords., ensures that displays are L/R lateralized
declare float RepTarg_Ang_list[4] = { 25, 115, 205, 295 };                    //off cardinal coords., ensures that displays are L/R lateralized

// Target eccentricity gets hard coded in DEFAULT.pro so I can keep constant across conditions in contextual cueing

// declare float	LeftLatAng_list[3] = {225, 135, 180}; //off card inal coords.
// declare float	RightLatAng_list[3] = {45, 0, 315}; //off cardinal coords.
declare float TrAngList[4] = { 0, 90, 180, 270 }; //off cardinal coords.
declare int   ArrStruct;
declare int   ProbCue;                            //turn probability cueing mode on or off
declare int   ProbSide;                           //more probable target location
declare int   TaskStim;                           //turn task-based stimulation on or off
declare int   FixJitter;
declare int   LatStruct;
declare int   Catch_Rew;             //allows us to set how much we divide base reward by on catch trials relative to target trials
declare int   trialtype;             //selects repeat vs random displays
declare int   Singleton_color[3];    // need to make this more finely adjustable for luminance matching
declare int   NonSingleton_color[3]; // need to make this more finely adjustable for luminance matching
declare int   d1color;               // need to make this more finely adjustable for luminance matching
declare int   SingMode;              //declares presence/absence of singleton, set in DEFAULT.pro
declare int   SingFreq;              //singleton present vs absent frequency/proportion, only used in LOC_RAND.pro
declare int   DistPres;              //singleton present (1) vs. absent (0) for strobing. See EVENTDEF.pro, gets set in LOC_RAND.pro
declare int   SingCol;               //declares color of singleton, currently set in DEFAULT.pro and selected in SET_CLRS.
declare int   DistCol;               // declares color of non-singletons in anti task.
declare int   PercSingTrl;           // sets percentage of trials where singleton is present, set in DEFAULT.pro, see also usage in LOC_RAND.pro
//declare	int		TrainOrt;
declare int   sVarsSet;
declare int   TargOrt;
declare int   TargOrt1;    //specific to singleton search mode sets T1
declare int   TargOrt2;    //specific to singleton search mode sets T2
declare int   TD_Select;   //Select Target Distractor relationship for singleton search mode (i.e., which is target and which is distractor)
//declare int   TargID_Select; //Select target type from trial to trial at random in singleton search mode
declare int   DistOrt;
declare int   SearchEcc;
declare int   SelEcc;          // select eccentricity - see SETS_TRL.PRO
declare int   VarEcc;          // turn eccentricity selection on/off
declare int   TargTrainSet;
declare int   THemi;           //0=vertical meridian, 1=left hemi, 2=right hemi
declare int   DHemi;           //0=vertical meridian, 1=left hemi, 2=right hemi
declare       Rand_targ_angle;
declare       Rand_d1_angle;

declare float catch_hold_time;
declare float search_fix_time;
declare float plac_duration;
declare float max_plactime;
declare float min_plactime;
//////////////////End Search Specific

///////// Ultrasound Vars /////////
declare int StimInterval;
declare int StimCond;
declare int LastStim;
declare int Npulse;
declare int PulseGap;

////////// Ultrasound Vars /////////

declare int   Classic;                  // emulates the old stop signal task
declare int   Stop_sig_color[3];        // need to make this more finely adjustable for luminance matching
declare int   Ignore_sig_color[3];      // need to make this more finely adjustable for luminance matching
declare int   Fixation_color[3];        // need to make this more finely adjustable for luminance matching
declare int   Cue_color[3];             // Pro/Anti only
declare int   Mask_sig_color[3];        //temporal
declare int   N_targ_pos;               // number of target positions (need to calculate this myself based on user input)
declare int   Color_list[12, 3];        // color of each stimulus individually (see critique above)
declare float Size_list[12];            // size of each stimulus individually (degrees)
declare float Angle_list[12];           // angle of each target individually (degrees)
declare float Eccentricity_list[12];    // distance of each target from center of screen individually (degrees)
declare float Fixation_size;            // size of the fixatoin point (degrees)
declare int   Set_Tones;                // sets up the tones to either high or low based on user input
declare int   Success_Tone_bigR;        // positive secondary reinforcer in Hz (large reward)
declare int   Success_Tone_medR;        // positive secondary reinforcer in Hz (medium reward)
declare int   Success_Tone_smlR;        // positive secondary reinforcer in Hz (small reward)
declare int   Failure_Tone_smlP;        // negative secondary reinforcer in Hz (short timeout)
declare int   Failure_Tone_medP;        // negative secondary reinforcer in Hz (medium timeout)
declare int   Failure_Tone_bigP;        // negative secondary reinforcer in Hz (long timeout)
declare int   Fixation_Target;          // Target number for the fixation task (changed by key macros);

// Set up Pro/Anti Variables
declare float stimHorizontal[11];   // Singleton H dimension
declare float stimVertical[11];     // Singleton V dimension
declare float distH[11];            // Non-singleton H dimension
declare float distV[11];            // Non-singleton V dimension
declare int   targDiffProbs[11];    // Relative probabilities of singleton difficulties
declare int   distDiffProbs[11];    // Relative probabilities of non-singleton difficulties
declare int   tIsPro[11];           // Decides whether the singleton is pro or anti...
declare int   tIsAnti[11];          // See above, both used for congruency of anti location
declare int   tIsCatch[11];         // See above, will be used to pick square simulus if we add this as a "difficulty" level
declare int   congProb[3];          // Will be used to set relative probabilities of congruent vs incongruent anti- distractors
declare int   dIsPro[11];           // Decides whether the singleton is pro or anti...
declare int   dIsAnti[11];          // See above, both used for congruency of anti location
declare int   dIsCatch[11];         // See above, will be used to pick square simulus if we add this as a "difficulty" level
//declare float   distAngles[12];
declare int   singColor;
declare int   distColor;
declare int   ntDifficulties = 11;
declare int   ndDifficulties = 11;
declare int   catchDifficulty;
declare int   catchDistDiff;
declare int   angleOffset;
declare int   targInd;
declare float catchH;
declare float catchV;
declare int   singDifficulty = 0;
declare int   distDifficulty[12];
declare int   catchDiffPerc[12];
declare int   oppDiff = 0;
declare int   doCongruency;
declare int   fixCue;
declare int   cueColors[3];
declare int   cueCongThresh;
declare int   curr_cuetime;
declare int   neutCueThresh;
declare int   cueType;
declare int   Min_cueTime;
declare int   Max_cueTime;
declare float rewdDiscount = 0;
declare int   oppColor[3];
declare int   lumOffset;
declare int   isCong;
declare int   targProb[8];
declare int   leaveOther     = 0;
declare int   extinguishTime = 0;
declare int   helpDelay;
declare int   leaveStimsPunish;
declare int   ghost;
declare int   nEccs;
declare int   dynamicColor;
declare int   eccProbs[8];
declare int   eccList[8];
declare int   basicPopOut;
declare int   nPerRun;
declare int   nThisRun;
declare int   switchColors = 1;
declare int   whichSwitch  = 1;
declare int   countIncorrect;
declare int   colorProbs[6];
declare int   distColProbs[6];
declare int   nClrs;
declare int   lastSwitch   = 0;
declare int   lastWasAbort = 0;
declare int   superSetSize;

//declare float	Ang_list[12] = {0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330}; //cardinal coords.
declare hide float llength = 1.6;
declare hide float lwidth  = 0.5;

//----------------------------------------------------------------------------------------------------------------
declare float Fix_win_size;                     // size of fixation window (degrees)
declare float Targ_win_size;                    // size of target window (degrees)



//----------------------------------------------------------------------------------------------------------------
// Task timing paramaters (all times in ms unless otherwise specified)
declare int   Allowed_fix_time;                         // subject has this long to acquire fixation before a new trial is initiated
declare int   Expo_Jitter;                              // defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int   Expo_Jitter_SOA;                          // defines if exponential holdtime is used for fixation offset in mem guided sacc task
declare int   Min_Holdtime;                             // minimum time after fixation before target presentation
declare int   Max_Holdtime;                             // maximum time after fixation before target presentation
declare int   Min_SOA;                                  // minimum time from target onset to fixation offset (mem guided only)
declare int   Max_SOA;                                  // maximum time from target onset to fixation offset (mem guided only)
declare int   Min_saccade_time;                         // for training subjects to slow down if necessary
declare int   Max_saccade_time;                         // subject has this long to saccade to the target
declare int   Max_sacc_duration;                        // once the eyes leave fixation they must be in the target before this time is up
declare int   Targ_hold_time;                           // after saccade subject must hold fixation at target for this long
declare int   N_SSDs;                                   // number of stop signal delays (need to calculate this myself)
declare int   Max_SSD;                                  // longest SSD
declare int   Min_SSD;                                  // shortest SSD
declare int   N_SOAs;
declare int   Max_SOA;
declare int   Min_SSD;
declare int   SSD_floor;                        // for training to cancel consistantly
declare int   SSD_ceil;                         // for training to cancel consistantly
declare int   Staircase;                        // do we select the next SSD based on a staircasing algorithm?
declare float SSD_list[20];                     // needs to be in refresh rate units
declare float SOA_list[20];                     // needs to be in refresh rate units
declare int   Cancl_time;                       // subject must hold fixation for this long on a stop trial to be deemed canceled
declare int   Tone_Duration;                    // how long should the error and success tones be presented?
declare int   RWRD_Offset;                    // how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int   Base_RWRD_time;                 // how long will the juice solonoid remain open (monkeys are very interested in this varaible)
declare int   Base_Punish_time;                 // time out for messing up
declare int   Bmove_tout;                       // additive timeout imposed for each body movement
declare int   Move_ct;                          // Output lets us know how many times the body has moved.
declare int   Max_move_ct;                      // Setting maximum move_ct so monkey doesn't self-punish to eternity
declare int   TrainingStill;                    // Indicates that we are using motion detector to train the monk to be still
declare int   Canc_alert;                       // Alert operator that the monk has canceled a trial (during training)
declare int   Fixed_trl_length;                 // 1 for fixed trial length, 0 for fixied inter trial intervals
declare int   Trial_length;                     // fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
declare int   Inter_trl_int;                    // how long between trials (only works if Fixed_trl_length == 0)
declare int   Exp_juice;                        // Exponential juice reward duration by reaction time
declare int   nogosoa;
declare int   targ_on_time;

//------------------------------------------------------------------------------------------------------------------
// Globals needed for multiple processes which must be declared here to avoid dependancy conflicts
declare int RWRD_duration;                    //GLOBAL OUTPUT FOR INFOS.pro will be set by END_TRL.pro
declare int Punish_time;                        //GLOBAL OUTPUT FOR INFOS.pro will be set by END_TRL.pro
declare int Success_tone;                       //GLOBAL OUTPUT FOR INFOS.pro will be set by END_TRL.pro
declare int Failure_tone;                       //GLOBAL OUTPUT FOR INFOS.pro will be set by END_TRL.pro

// Flash Variables
declare float IFI;
declare float flashTime;
declare int   redVal;
declare int   greenVal;
declare int   blueVal;
declare int   yrOff;
declare int   ygOff;
declare int   mrOff;
declare int   mbOff;
declare int   cgOff;
declare int   cbOff;
declare int   wrOff;
declare int   wgOff;
declare int   wbOff;

// PD Variables
declare int PD_TRIG_L        = 0;
declare int PD_TRIG_R        = 0;
declare int  Curr_SSD;               // SSD on next stop or ignore trial
declare int  vertRefreshCountTarget; // Count number of vertical refreshes for Target screen (left PhotoCell)
declare int  actualSsdTime;          // Time elapsed between Target onset and onset of stop signal (ssd)
declare int  expectedSsdTime;         // Expected SSD time based on the start protocol for stop trial

