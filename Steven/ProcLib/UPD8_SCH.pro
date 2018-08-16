// Updates inhibition function in the animated graph online. 
// NOTE: SET_INH must have been run already to set inhibition
// function graph up.  Needed for global objects.
//
// written by joshua.d.cosman@vanderbilt.edu 	January, 2011

declare UPD8_SCH();

process UPD8_SCH()
	{

	declare int success = 1;
	declare int failure = 0;
	declare int nogo_success = 3;
	declare int random_position_x;
	declare int repeat_position_x;
	declare float random_position_y;
	declare float repeat_position_y;
/* 	declare float cum_rep_rt;
	declare float avg_rep_rt;
	declare float graph_rep_rt;
	declare float cum_rand_rt;
	declare float avg_rand_rt;
	declare float graph_rand_rt; */
	
	if (FirstSearchTrial == 1)
		{
			repeat_position_y = 1000;
			random_position_y = 1000;
			FirstSearchTrial = 0;
			cum_rep_rt = 0;
			cum_rand_rt = 0;
			avg_rep_rt = 0;
			avg_rand_rt = 0;
			graph_rep_rt = 0;
			graph_rand_rt = 0;
			rand_inacc_sacc = 0;
			rep_inacc_sacc = 0;
		}
if (SingMode == 0)		
		
	if (TrialTp == 1) //Random
		{
		if (lastsearchoutcome == success || nogo_success)
			{
			cum_rand_rt = cum_rand_rt + current_rt;
			avg_rand_rt = cum_rand_rt/Rand_Comp_Trl_number;
			graph_rand_rt = 1000 - avg_rand_rt; // 1000 minus RT because Y = 1000 is YMAX, or RT = 0ms	
			
			random_position_x = -300; //fixed position, left side of graph
			random_position_y = graph_rand_rt;
			
			//Graph updated values
			oSetAttribute(object_random,aFILLED);
			oSetAttribute(object_random,aVISIBLE);
			oMove(object_random,random_position_x,random_position_y);
			}
		}	
	else		
		{
		if (lastsearchoutcome == success || nogo_success)
			{
			cum_rep_rt = cum_rep_rt + current_rt;
			avg_rep_rt = cum_rep_rt/Rep_Comp_Trl_number;
			graph_rep_rt = 1000 - avg_rep_rt; 
			
			repeat_position_x = 300; //fixed position, right side of graph	
			repeat_position_y = graph_rep_rt;
			
			//Graph updated values
			oSetAttribute(object_repeat,aFILLED);
			oSetAttribute(object_repeat,aVISIBLE);
			oMove(object_repeat,repeat_position_x,repeat_position_y);		
			}
		}	

else if (SingMode == 1)
		{
		if (DistPres == 1111) //Random
			{
			if (lastsearchoutcome == success || nogo_success)
				{
				cum_rand_rt_DA = cum_rand_rt_DA + current_rt;
				avg_rand_rt_DA = cum_rand_rt_DA/Rand_Comp_Trl_DA;
				graph_rand_rt = 1000 - avg_rand_rt_DA; // 1000 minus RT because Y = 1000 is YMAX, or RT = 0ms	
				
				random_position_x = -300; //fixed position, left side of graph
				random_position_y = graph_rand_rt;
				
				//Graph updated values
				oSetAttribute(object_random,aFILLED);
				oSetAttribute(object_random,aVISIBLE);
				oMove(object_random,random_position_x,random_position_y);
				}
			}	
		else		
			{
			if (lastsearchoutcome == success || nogo_success)
				{
				cum_rand_rt_DP = cum_rand_rt_DP + current_rt;
				avg_rand_rt_DP = cum_rand_rt_DP/Rand_Comp_Trl_DP;
				graph_rand_rt = 1000 - avg_rand_rt_DP; 
				
				repeat_position_x = 300; //fixed position, right side of graph	
				repeat_position_y = graph_rand_rt;
				
				//Graph updated values
				oSetAttribute(object_repeat,aFILLED);
				oSetAttribute(object_repeat,aVISIBLE);
				oMove(object_repeat,repeat_position_x,repeat_position_y);		
				}
			}	
		}

	}