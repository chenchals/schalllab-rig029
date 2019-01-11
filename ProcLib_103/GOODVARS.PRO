//-------------------------------------------------------------------------------------------------------------------------
// perform a few checks to try to guard against poor user input

declare GOODVARS(state);

process GOODVARS(state)
	{
	declare int i;
	//---------------------------------------------------------------------------------------------------------------------------

	if (state == run_cmd_sess)
		{
		if (Go_weight
			+ Stop_weight
			+ Ignore_weight != 100)
			{
			printf("WARNING!!!\n");
			printf("Trial weights do not sum to 100.\n");
			printf("CHANGE PARAMETERS BEFORE RECORDING\n");
			State = 0;  					// hook the user back into IDLE()
			system("dpop");					// clear dialogs
			}


		i = 0;								// count up the target locations based on Size_list
		N_targ_pos = 0;
		while(i < 8)
			{
			if(Size_list[i] != 0)
				{
				N_targ_pos = N_targ_pos + 1;
				}
			i = i + 1;
			nexttick;
			}

		i = 0;								// count up the SSDs
		N_SSDs = 0;
		while(i < 20)
			{
			if(SSD_list[i] != 0)
				{
				N_SSDs = N_SSDs + 1;
				}
			i = i + 1;
			nexttick;
			}

		Max_SSD = SSD_list[N_SSDs-1];
		Max_SSD = ceil(Max_SSD * (1000.0/Refresh_rate));
		Min_SSD = SSD_list[0];
		Min_SSD = ceil(Min_SSD * (1000.0/Refresh_rate));


		if (Max_SSD > Max_saccade_time)
			{
			printf("WARNING!!!\n");
			printf("SSDs exceed Max time allowed...\n");
			printf("...for saccade to target.\n");
			printf("CHANGE PARAMETERS BEFORE RECORDING\n");
			State = 0;  					// hook the user back into IDLE()
			system("dpop");					// clear dialogs
			}

		if(Trial_length < Max_Holdtime
						+ Max_SSD
						+ Cancl_time
						+ Tone_Duration
						+ Reward_Offset
						+ Base_Reward_time * 2
						+ 100) 				// maximum time a trial can take including 100ms for iti calculations (generous)
			{
			Trial_length = Max_Holdtime
						+ Max_SSD
						+ Cancl_time
						+ Tone_Duration
						+ Reward_Offset
						+ Base_Reward_time * 2
						+ 100;
			printf("WARNING!!!\n");
			printf("Trial length too short\n");
			printf("Extending trial length to %d\n",Trial_length);
			}

		if (Set_tones == 1)
			{
			Success_Tone_bigR		= 3200;	// positive secondary reinforcer in Hz (large reward)
			Success_Tone_medR		= 1600;	// positive secondary reinforcer in Hz (medium reward)
			Success_Tone_smlR		= 800;	// positive secondary reinforcer in Hz (small reward)
			Failure_Tone_smlP		= 400;	// negative secondary reinforcer in Hz (short timeout)
			Failure_Tone_medP		= 200;	// negative secondary reinforcer in Hz (medium timeout)
			Failure_Tone_bigP		= 100;	// negative secondary reinforcer in Hz (long timeout)
			}
		else
			{
			Success_Tone_bigR		= 100;	// positive secondary reinforcer in Hz (large reward)
			Success_Tone_medR		= 200;	// positive secondary reinforcer in Hz (medium reward)
			Success_Tone_smlR		= 400;	// positive secondary reinforcer in Hz (small reward)
			Failure_Tone_smlP		= 800;	// negative secondary reinforcer in Hz (short timeout)
			Failure_Tone_medP		= 1600;	// negative secondary reinforcer in Hz (medium timeout)
			Failure_Tone_bigP		= 3200;	// negative secondary reinforcer in Hz (long timeout)
			}
		}

	//---------------------------------------------------------------------------------------------------------------------------


	if (state == run_mg_sess)
	{
		if (Go_weight
			+ Stop_weight
			+ Ignore_weight != 100)
			{
			printf("WARNING!!!\n");
			printf("Trial weights do not sum to 100.\n");
			printf("CHANGE PARAMETERS BEFORE RECORDING\n");
			State = 0;  					// hook the user back into IDLE()
			system("dpop");					// clear dialogs
			}


		i = 0;								// count up the target locations based on Size_list
		N_targ_pos = 0;
		while(i < 8)
			{
			if(Size_list[i] != 0)
				{
				N_targ_pos = N_targ_pos + 1;
				}
			i = i + 1;
			nexttick;
			}

		i = 0;								// count up the SSDs
		N_SOAs = 0;
		while(i < 20)
			{
			if(SOA_list[i] != 0)
				{
				N_SOAs = N_SOAs + 1;
				}
			i = i + 1;
			nexttick;
			}

		Max_SOA = SOA_list[N_SOAs-1];
		Max_SOA = ceil(Max_SOA * (1000.0/Refresh_rate));
		Min_SOA = SOA_list[0];
		Min_SOA = ceil(Min_SOA * (1000.0/Refresh_rate));

		if(Trial_length < Max_Holdtime
						+ Max_SOA
						+ Cancl_time
						+ Tone_Duration
						+ Reward_Offset
						+ Base_Reward_time * 2
						+ 100) 				// maximum time a trial can take including 100ms for iti calculations (generous)
			{
			Trial_length = Max_Holdtime
						+ Max_SOA
						+ Cancl_time
						+ Tone_Duration
						+ Reward_Offset
						+ Base_Reward_time * 2
						+ 100;
			printf("WARNING!!!\n");
			printf("Trial length too short\n");
			printf("Extending trial length to %d\n",Trial_length);
			}

		if (Set_tones == 1)
			{
			Success_Tone_bigR		= 3200;	// positive secondary reinforcer in Hz (large reward)
			Success_Tone_medR		= 1600;	// positive secondary reinforcer in Hz (medium reward)
			Success_Tone_smlR		= 800;	// positive secondary reinforcer in Hz (small reward)
			Failure_Tone_smlP		= 400;	// negative secondary reinforcer in Hz (short timeout)
			Failure_Tone_medP		= 200;	// negative secondary reinforcer in Hz (medium timeout)
			Failure_Tone_bigP		= 100;	// negative secondary reinforcer in Hz (long timeout)
			}
		else
			{
			Success_Tone_bigR		= 100;	// positive secondary reinforcer in Hz (large reward)
			Success_Tone_medR		= 200;	// positive secondary reinforcer in Hz (medium reward)
			Success_Tone_smlR		= 400;	// positive secondary reinforcer in Hz (small reward)
			Failure_Tone_smlP		= 800;	// negative secondary reinforcer in Hz (short timeout)
			Failure_Tone_medP		= 1600;	// negative secondary reinforcer in Hz (medium timeout)
			Failure_Tone_bigP		= 3200;	// negative secondary reinforcer in Hz (long timeout)
			}
		}

	//---------


	}
