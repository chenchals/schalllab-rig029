// These are the user defined global variables needed to run the search task
//
// written by joshua.d.cosman@vanderbilt.edu      July, 2013

declare int		Trl_number;
declare int		Comp_Trl_number;
declare int		Block_number;

declare int		C_early_saccades;
declare int		C_go_correct;
declare int		C_go_wrong;
declare int		C_nogo_correct;
declare int		C_nogo_wrong;


//----------------------------------------------------------------------------------------------------------------
// Trial type distributions (must sum to 100)
declare float	Go_weight;				// percentage of go trials
declare float	Stop_weight;			// percentage of stop trials
declare float	Ignore_weight;			// percentage of ignore trials

declare float	Bonus_weight;			// percentage of time that the subject is wrong but gets rewarded anyway.
declare float	Dealer_wins_weight;		// percentage of time that the subject is right but gets punished anyway.

declare float	BigR_weight;			// weights for random changes of reward size
declare float	MedR_weight;			// weights for random changes of reward size
declare float	SmlR_weight;			// weights for random changes of reward size
declare float	SmlP_weight;			// weights for random changes of punsiment size
declare float	MedP_weight;			// weights for random changes of punsiment size
declare float	BigP_weight;			// weights for random changes of punsiment size


//----------------------------------------------------------------------------------------------------------------
// Stimulus properties
declare int		Classic;				// emulates the old stop signal task
declare int		Stop_sig_color[3];		// need to make this more finely adjustable for luminance matching
declare int		Ignore_sig_color[3];	// need to make this more finely adjustable for luminance matching
declare int		Fixation_color[3];		// need to make this more finely adjustable for luminance matching
declare int		Mask_sig_color[3];
declare int		N_targ_pos;				// number of target positions (need to calculate this myself based on user input)
declare int		Color_list[9,3];		// color of each target individually (see critique above)
declare int		tColor_list[9,3];
declare float	Size_list[9];			// size of each target individually (degrees)
declare float	Angle_list[9];			// angle of each target individually (degrees)
declare float	Eccentricity_list[9];	// distance of each target from center of screen individually (degrees)
declare float	Fixation_size;			// size of the fixatoin point (degrees)
declare int		Set_Tones;				// sets up the tones to either high or low based on user input
declare int		Success_Tone_bigR;		// positive secondary reinforcer in Hz (large reward)
declare int		Success_Tone_medR;		// positive secondary reinforcer in Hz (medium reward)
declare int		Success_Tone_smlR;		// positive secondary reinforcer in Hz (small reward)		
declare int		Failure_Tone_smlP;		// negative secondary reinforcer in Hz (short timeout)
declare int		Failure_Tone_medP;		// negative secondary reinforcer in Hz (medium timeout)
declare int		Failure_Tone_bigP;		// negative secondary reinforcer in Hz (long timeout)
declare int		Fixation_Target;		// Target number for the fixation task (changed by key macros);


//----------------------------------------------------------------------------------------------------------------
// Eye related variables
declare float	Fix_win_size;			// size of fixation window (degrees)
declare float	Targ_win_size;			// size of target window (degrees)



//----------------------------------------------------------------------------------------------------------------
// Task timing paramaters (all times in ms unless otherwise specified)
declare int		Allowed_fix_time;		// subject has this long to acquire fixation before a new trial is initiated
declare int		Expo_Jitter;			// defines if exponential holdtime is used or if holdtime is sampled from rectanglular dist.
declare int		Min_Holdtime;			// minimum time after fixation before target presentation
declare int		Max_Holdtime;			// maximum time after fixation before target presentation
declare int		Max_saccade_time;		// subject has this long to saccade to the target
declare int		Max_sacc_duration;		// once the eyes leave fixation they must be in the target before this time is up
declare int		Targ_hold_time;			// after saccade subject must hold fixation at target for this long
declare int		N_SSDs;					// number of stop signal delays (need to calculate this myself)
declare int		Max_SSD;				// longest SSD
declare int		Min_SSD;				// shortest SSD
declare int		Staircase;				// do we select the next SSD based on a staircasing algorithm?
declare float	SSD_list[20];			// needs to be in refresh rate units
declare int		Cancl_time;				// subject must hold fixation for this long on a stop trial to be deemed canceled
declare int		Tone_Duration;			// how long should the error and success tones be presented?
declare int		Reward_Offset;			// how long after tone before juice is given (needed to seperate primary and secondary reinforcement)
declare int		Base_Reward_time;		// how long will the juice solonoid remain open (monkeys are very interested in this varaible)
declare int		Base_Punish_time;		// time out for messing up
declare int		Fixed_trl_length;		// 1 for fixed trial length, 0 for fixied inter trial intervals
declare int		Trial_length;			// fixed at this value (only works if Fixed_trl_length == 1) must figure out max time for this variable and include it in comments
declare int		Inter_trl_int;			// how long between trials (only works if Fixed_trl_length == 0)










