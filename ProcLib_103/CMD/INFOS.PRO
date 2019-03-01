//==========================================================================
// INFOS.PRO
//   Description: Records all of the parameters for a trial.  Should be sent
//                during the inter trial interval while the communication lines
//                are clear (no rdx communication with vdosync).
// NOTES:
//               1) The order of these params is very important.
//                  Matlab translation code identifies these parameters based on
//                  their order, so if you add more events, make sure to keep them in the
//                  same order in the matlab translation code.
//               2) This process relies heavily on globals (since it is grabbing stuff from all over the protocol).
//   Author: joshua.d.cosman@vanderbilt.edu
//   Date: 2014-01
//==========================================================================
//  Revision History:
//  001: 2019/01/10 chenchal subraveti
//       1) Modified to use SEND_EVT()
//       2) The line pattern for SEND_EVT call is used to get the names of the info items during Matlab transltion.
//       3) Pattern for SEND_EVT is: SEND_EVT(InfosZero + info_name);
//  NOTE:
//          The *info_name* in the pattern above is captured by regular expression during Matlab transltion.
//

declare INFOS();

process INFOS()
{
  declare int stop_sig_color_r, stop_sig_color_g, stop_sig_color_b;
  declare int ignore_sig_color_r, ignore_sig_color_g, ignore_sig_color_b;
  declare int fixation_color_r, fixation_color_g, fixation_color_b;
  declare int target_color_r, target_color_g, target_color_b;
  declare int rewardOffset;
  declare int tempInfosN;
  declare int nInfos;

  stop_sig_color_r = Stop_sig_color[0];
  stop_sig_color_g = Stop_sig_color[1];
  stop_sig_color_b = Stop_sig_color[2];

  ignore_sig_color_r = Ignore_sig_color[0];
  ignore_sig_color_g = Ignore_sig_color[1];
  ignore_sig_color_b = Ignore_sig_color[2];

  fixation_color_r = Fixation_color[0];
  fixation_color_g = Fixation_color[1];
  fixation_color_b = Fixation_color[2];

  target_color_r = Color_list[Curr_target, 0];
  target_color_g = Color_list[Curr_target, 1];
  target_color_b = Color_list[Curr_target, 2];

  spawn SEND_EVT(StartInfos_);

  tempInfosN = Set_event;
  spawn SEND_EVT(InfosZero + Block_number);
  spawn SEND_EVT(InfosZero + Trl_number);
  spawn SEND_EVT(InfosZero + Trl_type);
  spawn SEND_EVT(InfosZero + Trl_Outcome);

  nexttick 5;
  spawn SEND_EVT(InfosZero + Fixed_trl_length);
  spawn SEND_EVT(InfosZero + Trial_length);
  spawn SEND_EVT(InfosZero + Inter_trl_int);
  spawn SEND_EVT(InfosZero + Max_holdtime);
  spawn SEND_EVT(InfosZero + Max_sacc_duration);
  spawn SEND_EVT(InfosZero + Max_saccade_time);
  spawn SEND_EVT(InfosZero + Min_Holdtime);

  nexttick 5;

  spawn SEND_EVT(Int(InfosZero + (X_Gain * 100)));
  spawn SEND_EVT(Int(InfosZero + (X_Offset * 100)));
  spawn SEND_EVT(Int(InfosZero + (Y_Gain * 100)));
  spawn SEND_EVT(Int(InfosZero + (Y_Offset * 100)));

  nexttick 5;

  spawn SEND_EVT(Int(InfosZero + (Ignore_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (Stop_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (Go_weight * 100)));

  spawn SEND_EVT(InfosZero + Staircase);
  spawn SEND_EVT(InfosZero + Curr_soa);
  spawn SEND_EVT(InfosZero + StimTm + 1000);
  spawn SEND_EVT(InfosZero + DR1_flag);

  nexttick 5;

  spawn SEND_EVT(Int(InfosZero + Refresh_rate));
  spawn SEND_EVT(InfosZero + N_SSDs);
  spawn SEND_EVT(InfosZero + Curr_SSD);
  spawn SEND_EVT(InfosZero + vertRefreshCountTarget);
  spawn SEND_EVT(InfosZero + expectedSsdTime);
  spawn SEND_EVT(InfosZero + actualSsdTime);

  nexttick 5;

  spawn SEND_EVT(Int(InfosZero + (Targ_win_size * 100)));
  spawn SEND_EVT(Int(InfosZero + Angle));
  spawn SEND_EVT(Int(InfosZero + (Eccentricity * 100)));
  spawn SEND_EVT(Int(InfosZero + (Size * 100)));
  spawn SEND_EVT(InfosZero + Targ_hold_time);

  nexttick 5;

  spawn SEND_EVT(Int(InfosZero + (BigR_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (MedR_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (SmlR_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (BigP_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (MedP_weight * 100)));
  spawn SEND_EVT(Int(InfosZero + (SmlP_weight * 100)));

  nexttick 5;

  spawn SEND_EVT(InfosZero + Success_Tone);
  spawn SEND_EVT(InfosZero + Tone_Duration);
  spawn SEND_EVT(InfosZero + Base_Reward_time);
  spawn SEND_EVT(InfosZero + Reward_Duration);
  spawn SEND_EVT(InfosZero + Reward_Offset);
  spawn SEND_EVT(InfosZero + rewardOffset);

  nexttick 5;

  spawn SEND_EVT(InfosZero + Base_Punish_time);
  spawn SEND_EVT(InfosZero + Punish_time);
  spawn SEND_EVT(InfosZero + Cancl_time);

  //Colors
  spawn SEND_EVT(InfosZero + color);
  spawn SEND_EVT(InfosZero + fixation_color_r);
  spawn SEND_EVT(InfosZero + fixation_color_g);
  spawn SEND_EVT(InfosZero + fixation_color_b);

  nexttick 5;

  spawn SEND_EVT(InfosZero + target_color_r);
  spawn SEND_EVT(InfosZero + target_color_g);
  spawn SEND_EVT(InfosZero + target_color_b);

  spawn SEND_EVT(InfosZero + stop_sig_color_g);
  spawn SEND_EVT(InfosZero + stop_sig_color_r);
  spawn SEND_EVT(InfosZero + stop_sig_color_b);

  nexttick 5;

  spawn SEND_EVT(InfosZero + ignore_sig_color_r);
  spawn SEND_EVT(InfosZero + ignore_sig_color_g);
  spawn SEND_EVT(InfosZero + ignore_sig_color_b);

  nInfos = Set_event - tempInfosN;
  spawn SEND_EVT(nInfos);

  spawn SEND_EVT(EndInfos_);

  printf("****Trial Infos sent to TDT.****\n");
  nexttick 10;
} /* INFOS */
