//-------------------------------------------------------------------------------------------------------------------
// Records all of the parameters for a trial.  Should be sent during the inter trial interval while
// the communication lines are clear (no rdx communication with vdosync).
// NOTES:
// 1) The order of these params is very important.  Matlab translation code identifies these parameters based on their
// order, so if you add more events, make sure to keep them in the same order in the matlab translation code.  (
// 2) This process relies heavily on globals (since it is grabbing stuff from all over the protocol).
//
// written by joshua.d.cosman@vanderbilt.edu 	January, 2014
// Modified to use SEND_EVT()
// The line pattern for SEND_EVT call is used to get the names of
// the info items during transltion of TDT Data.
// Pattern used is: SEND_EVT(InfosZero + info_name);
// the *info_name* is captured by regular expression and used for processing.

#include C:/TEMPO/ProcLib/SEND_EVT.PRO


declare int stop_sig_color_r, stop_sig_color_g, stop_sig_color_b;
declare int ignore_sig_color_r, ignore_sig_color_g, ignore_sig_color_b;
declare int fixation_color_r, fixation_color_g, fixation_color_b;
declare int target_color_r, target_color_g, target_color_b;
declare int rewardOffset;

declare hide int id;
declare hide int run_anti_sess = 9;
declare hide float chkTime;
declare int dummy = 0;


declare INFOS();

process INFOS()
{
	declare int tempInfosN;
	declare int nInfos;

	stop_sig_color_r	= Stop_sig_color[0];
	stop_sig_color_g	= Stop_sig_color[1];
	stop_sig_color_b	= Stop_sig_color[2];

	ignore_sig_color_r	= Ignore_sig_color[0];
	ignore_sig_color_g	= Ignore_sig_color[1];
	ignore_sig_color_b	= Ignore_sig_color[2];

	fixation_color_r	= Fixation_color[0];
	fixation_color_g	= Fixation_color[1];
	fixation_color_b	= Fixation_color[2];

	target_color_r		= Color_list[Curr_target,0];
	target_color_g		= Color_list[Curr_target,1];
	target_color_b		= Color_list[Curr_target,2];

	spawnwait SEND_EVT(StartInfos_);
	tempInfosN = Set_event;
	spawnwait SEND_EVT(InfosZero + Trl_number);
	spawnwait SEND_EVT(InfosZero + Fixed_trl_length);
	spawnwait SEND_EVT(Int(InfosZero + Ignore_weight * 100));
	spawnwait SEND_EVT(InfosZero + Inter_trl_int);
	spawnwait SEND_EVT(InfosZero + Max_holdtime);
  //nexttick;
	spawnwait SEND_EVT(InfosZero + Max_sacc_duration);
	spawnwait SEND_EVT(InfosZero + Max_saccade_time);
	spawnwait SEND_EVT(InfosZero + Min_Holdtime);
	spawnwait SEND_EVT(InfosZero + N_SSDs);
	spawnwait SEND_EVT(InfosZero + Punish_time);
  //nexttick;
	spawnwait SEND_EVT(InfosZero + Reward_Duration);
	spawnwait SEND_EVT(InfosZero + Reward_Offset);
	spawnwait SEND_EVT(InfosZero + Staircase);
	spawnwait SEND_EVT(InfosZero + stop_sig_color_b);
	spawnwait SEND_EVT(InfosZero + stop_sig_color_g);
  //nexttick;
	spawnwait SEND_EVT(InfosZero + stop_sig_color_r);
	spawnwait SEND_EVT(Int(InfosZero + (Stop_weight * 100)));
	spawnwait SEND_EVT(InfosZero + Success_Tone);
	spawnwait SEND_EVT(Int(InfosZero + (Targ_win_size * 100)));
	spawnwait SEND_EVT(Int(InfosZero + Angle));
  //nexttick;
	spawnwait SEND_EVT(InfosZero + color);
	spawnwait SEND_EVT(InfosZero + target_color_b);
	spawnwait SEND_EVT(InfosZero + target_color_g);
	spawnwait SEND_EVT(InfosZero + target_color_r);
	spawnwait SEND_EVT(Int(InfosZero + (Eccentricity * 100)));
  //nexttick;
	spawnwait SEND_EVT(InfosZero + Targ_hold_time);
	spawnwait SEND_EVT(Int(InfosZero + (Size * 100)));
	spawnwait SEND_EVT(InfosZero + Tone_Duration);
	spawnwait SEND_EVT(InfosZero + Trial_length);
  //nexttick;
	spawnwait SEND_EVT(InfosZero + Trl_Outcome);
	spawnwait SEND_EVT(InfosZero + Trl_type);
	spawnwait SEND_EVT(Int(InfosZero + (X_Gain * 100) + 1000));
	spawnwait SEND_EVT(Int(InfosZero + (X_Offset * 100) + 1000));
	spawnwait SEND_EVT(Int(InfosZero + (Y_Gain * 100) + 1000));
  //nexttick;
	spawnwait SEND_EVT(Int(InfosZero + (Y_Offset * 100) + 1000));
	spawnwait SEND_EVT(InfosZero + Curr_soa);
	spawnwait SEND_EVT(InfosZero + Block_number);
	spawnwait SEND_EVT(InfosZero + StimTm + 1000);
  //nexttick;
	spawnwait SEND_EVT(InfosZero + new_curr_ssd);
	spawnwait SEND_EVT(InfosZero + Curr_SSD);
	spawnwait SEND_EVT(Int(InfosZero + Refresh_rate));
	spawnwait SEND_EVT(InfosZero + ignore_sig_color_g);
	spawnwait SEND_EVT(InfosZero + ignore_sig_color_b);
  //nexttick;
	spawnwait SEND_EVT(InfosZero + fixation_color_r);
	spawnwait SEND_EVT(InfosZero + fixation_color_g);
	spawnwait SEND_EVT(InfosZero + fixation_color_b);
	spawnwait SEND_EVT(InfosZero + DR1_flag);
	spawnwait SEND_EVT(Int(InfosZero + (BigR_weight * 100)));
  //nexttick;
	spawnwait SEND_EVT(Int(InfosZero + (MedR_weight * 100)));
	spawnwait SEND_EVT(Int(InfosZero + (SmlR_weight * 100)));
	spawnwait SEND_EVT(Int(InfosZero + (BigP_weight * 100)));
	spawnwait SEND_EVT(Int(InfosZero + (MedP_weight * 100)));
	spawnwait SEND_EVT(Int(InfosZero + (SmlP_weight * 100)));
	//nexttick;
	spawnwait SEND_EVT(InfosZero + Base_Reward_time);
	spawnwait SEND_EVT(InfosZero + Base_Punish_time);
	spawnwait SEND_EVT(InfosZero + Cancl_time);
	spawnwait SEND_EVT(InfosZero + rewardOffset);
	spawnwait SEND_EVT(InfosZero + abs(pdRefract));
	//nexttick;
	spawnwait SEND_EVT(InfosZero + abs(pdThresh));
	spawnwait SEND_EVT(EndInfos_);

	printf("****Trial Infos sent to TDT.****\n");

}
