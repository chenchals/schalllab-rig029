// These codes are the numbers they are for historic reasons.
// Many are not currently being used and could be discarded.
// This is hold over garbage from the bad old days.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare hide constant EVT_FIX_SPOT_ON_		= 2301;
declare hide constant EVT_FIXATE_			= 2660;
declare hide constant CueOn_ 			= 2661;
declare hide constant PlacOn_			= 2320;
declare hide constant EVT_TARGET_			= 2651;
declare hide constant TargetOff_ 		= 2652; 
declare hide constant EVT_FIX_SPOT_OFF_		= 2300;
declare hide constant EVT_STOP_SIGNAL_		= 2653;
declare hide constant EVT_TRIAL_START_		= 1666;
declare hide constant FixError_			= 2750; //Must Check to be sure.
declare hide constant GoEVT_SACCADE_		= 2751; //Must Check to be sure.
declare hide constant GoError_			= 2752; //Must Check to be sure.
declare hide constant NOGOWrong_		= 2753; //Must Check to be sure.
declare hide constant GoTargFixError_	= 2754; //Must Check to be sure.
declare hide constant Abort_ 			= 2620;
declare hide constant Correct_ 			= 2600;
declare hide constant GOCorrect_ 		= 2755;
declare hide constant NOGOCorrect_ 		= 2756;
declare hide constant CatchCorrect_ 	= 2757;
declare hide constant CatchIncorrectG_ 	= 2758;
declare hide constant CatchIncorrectNG_	= 2759;
declare hide constant BreakTFix_		= 2760;
declare hide constant EVT_EARLY_SACCADE_		= 2761;
declare hide constant Reward_ 			= 2727;
declare hide constant Tone_				= 2001;
declare hide constant EVT_TIMEOUT_END_ 		= 2002;
declare hide constant Error_tone		= 776;  //Strobe for Neuro Explorer
declare hide constant Reward_tone		= 777;	//Strobe for Neuro Explorer
declare hide constant Error_sacc		= 887;  //Strobe for Neuro Explorer
declare hide constant Correct_sacc		= 888;	//Strobe for Neuro Explorer
declare hide constant SoundOnReward_ 	= 2778;
declare hide constant SoundNoReward_ 	= 2779;
declare hide constant EVT_EOT_ 				= 1667;
declare hide constant EVT_CMAN_HEADER_ 		= 1501;
declare hide constant MemHeader_		= 1502;
declare hide constant GONOGOHeader_		= 1503;
declare hide constant DelayedHeader_    = 1504;
declare hide constant SearchHeader_     = 1507;
declare hide constant CaptureHeader_     = 1508;
declare hide constant AntiHeader_ 		= 1509;
declare hide constant EVT_IDENTIFY_ROOM_	= 1500; // Room 28
declare hide constant ShamStim_ 		= 665;
declare hide constant Stimulation_ 		= 666;
declare hide constant EndStim_ 			= 667;
//Note that this is followed by a 1 or a 2 if MultElectrodeStimFlag is set depending on the stim channel
declare hide constant ZeroEyePosition_ 	= 2302;
declare hide constant VSyncRefresh_		= 999;
declare hide constant EVT_SACCADE_ 			= 2810;
declare hide constant StimHelp_ 		= 2820;
//Note followed by another TTL == 2820 + trials[1] (looks like it classifies trial type)
declare hide constant EVT_DECIDE_ 			= 2811;
declare hide constant MouthBegin_ 		= 2655;
declare hide constant MouthEnd_ 		= 2656;
declare hide constant FixWindow_ 		= 2770;
declare hide constant TargetWindow_		= 2771;
declare hide constant EVT_TASK_END_ 			= 2680;
declare hide constant SessionStart_		= 2681;
declare hide constant JuiceStart_		= 2777;
declare hide constant JuiceEnd_			= 2776;
declare hide constant ReturnToFix_		= 2775;
declare hide constant EVT_ITI_START_			= 2124;
declare hide constant EVT_ITI_END_			= 2125;
declare hide constant PDTrigger_		= 2126;
declare hide constant ExtraReward_		= 2127;
declare hide constant StimFailed_ 		= 668;


/* MUST CHECK ALL THAT FOLLOWS IN TRANSLATED VARIABLES (MY VERSION DIED WITHOUT NETWORK) */
declare hide constant Staircase_ 		= 2772;
declare hide constant Neg2Reinforcement_= 2773; //?????
declare hide constant Feedback_ 		= 2774; //????? 
declare hide constant RewardSize_ 		= 2927;
declare hide constant TrialInBlock 		= 2928;
// declare hide constant SendStimInfo_ 	= 7000; // MUST CHANGE. TOO BIG
declare hide constant SendPenatrInfo_ 	= 2929;
declare hide constant EVT_TARGET_PRE_ 		= 2650; //?????
declare hide constant StopOn_ 			= 2654; //?????

declare hide constant EVT_START_INFOS_		= 2998;
declare hide constant EVT_END_INFOS_			= 2999;
declare hide float 	  InfosZero			= 3000.0;



