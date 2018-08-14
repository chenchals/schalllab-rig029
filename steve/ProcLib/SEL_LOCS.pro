//--------------------------------------------------------------------------------------------
// This code selects actual array locations for a given trial, based on locations set up in LOC_REP.pro and LOC_RAND.pro
// 
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013


//Move to ALLVARS.pro
	
		
	declare hide float 	targ_angle;
	declare hide float 	d1_angle; 
	declare hide float 	d2_angle; 
	declare hide float 	d3_angle; 
	declare hide float 	d4_angle; 
	declare hide float 	d5_angle; 
	declare hide float 	d6_angle; 
	declare hide float 	d7_angle; 
	declare hide float 	d8_angle; 
	declare hide float 	d9_angle; 
	declare hide float 	d10_angle; 
	declare hide float 	d11_angle; 
																		// ...by INFOS.pro at trial end.
	declare hide float 	targ_ecc;
	declare hide float 	d1_ecc; 
	declare hide float 	d2_ecc; 
	declare hide float 	d3_ecc; 
	declare hide float 	d4_ecc; 
	declare hide float 	d5_ecc; 
	declare hide float 	d6_ecc; 
	declare hide float 	d7_ecc; 
	declare hide float 	d8_ecc; 
	declare hide float 	d9_ecc; 
	declare hide float 	d10_ecc; 
	declare hide float 	d11_ecc; 
	
	declare hide float 	targ_orient;
	declare hide float 	d1_orient;
	declare hide float 	d2_orient;
	declare hide float 	d3_orient;
	declare hide float 	d4_orient;
	declare hide float 	d5_orient;
	declare hide float 	d6_orient;
	declare hide float 	d7_orient;
	declare hide float 	d8_orient;
	declare hide float 	d9_orient;
	declare hide float 	d10_orient;
	declare hide float 	d11_orient;
	

declare SEL_LOCS();

process SEL_LOCS
    {
	
		
	trialtype = random(12); //randomly choose repeated vs. novel displays

if (ArrStruct == 1)	
	{
	if (trialtype >= 0) 
		{
		TrialTp = 1;
		
		targ_angle = Rand_targ_angle;
		d1_angle = Rand_d1_angle;
		d2_angle = Rand_d2_angle;
		d3_angle = Rand_d3_angle;
		d4_angle = Rand_d4_angle;
		d5_angle = Rand_d5_angle;
		d6_angle = Rand_d6_angle;
		d7_angle = Rand_d7_angle;
		// d8_angle = Rand_d8_angle;
		// d9_angle = Rand_d9_angle;
		// d10_angle = Rand_d10_angle;
		// d11_angle = Rand_d11_angle;
		
		targ_ecc = Rand_targ_ecc;
		d1_ecc = Rand_d1_ecc;
		d2_ecc = Rand_d2_ecc;
		d3_ecc = Rand_d3_ecc;
		d4_ecc = Rand_d4_ecc;
		d5_ecc = Rand_d5_ecc;
		d6_ecc = Rand_d6_ecc;
		d7_ecc = Rand_d7_ecc;
		d8_ecc = Rand_d8_ecc;
		d9_ecc = Rand_d9_ecc;
		d10_ecc = Rand_d10_ecc;
		d11_ecc = Rand_d11_ecc;
		
		targ_orient = Rand_targ_orient;
		d1_orient = Rand_d1_orient;
		d2_orient = Rand_d2_orient;
		d3_orient = Rand_d3_orient;
		d4_orient = Rand_d4_orient;
		d5_orient = Rand_d5_orient;
		d6_orient = Rand_d6_orient;
		d7_orient = Rand_d7_orient;
		d8_orient = Rand_d8_orient;
		d9_orient = Rand_d9_orient;
		d10_orient = Rand_d10_orient;
		d11_orient = Rand_d11_orient;
		}
	}
else
	if (trialtype < 6) // presents random array on 1/2 of all trials, randomly chosen
		{
		TrialTp = 1;
		
		targ_angle = Rand_targ_angle;
		d1_angle = Rand_d1_angle;
		d2_angle = Rand_d2_angle;
		d3_angle = Rand_d3_angle;
		d4_angle = Rand_d4_angle;
		d5_angle = Rand_d5_angle;
		d6_angle = Rand_d6_angle;
		d7_angle = Rand_d7_angle;
		// d8_angle = Rand_d8_angle;
		// d9_angle = Rand_d9_angle;
		// d10_angle = Rand_d10_angle;
		// d11_angle = Rand_d11_angle;
		
		targ_ecc = Rand_targ_ecc;
		d1_ecc = Rand_d1_ecc;
		d2_ecc = Rand_d2_ecc;
		d3_ecc = Rand_d3_ecc;
		d4_ecc = Rand_d4_ecc;
		d5_ecc = Rand_d5_ecc;
		d6_ecc = Rand_d6_ecc;
		d7_ecc = Rand_d7_ecc;
		d8_ecc = Rand_d8_ecc;
		d9_ecc = Rand_d9_ecc;
		d10_ecc = Rand_d10_ecc;
		d11_ecc = Rand_d11_ecc;
		
		targ_orient = Rand_targ_orient;
		d1_orient = Rand_d1_orient;
		d2_orient = Rand_d2_orient;
		d3_orient = Rand_d3_orient;
		d4_orient = Rand_d4_orient;
		d5_orient = Rand_d5_orient;
		d6_orient = Rand_d6_orient;
		d7_orient = Rand_d7_orient;
		// d8_orient = Rand_d8_orient;
		// d9_orient = Rand_d9_orient;
		// d10_orient = Rand_d10_orient;
		// d11_orient = Rand_d11_orient;
		}	
	else if (trialtype == 6) // presents random array on 1/2 of all trials, randomly chosen
		{
		
		TrialTp = 2;
		
		targ_angle = R1_targ_angle;
		d1_angle = R1_d1_angle;
		d2_angle = R1_d2_angle;
		d3_angle = R1_d3_angle;
		d4_angle = R1_d4_angle;
		d5_angle = R1_d5_angle;
		d6_angle = R1_d6_angle;
		d7_angle = R1_d7_angle;
		// d8_angle = R1_d8_angle;
		// d9_angle = R1_d9_angle;
		// d10_angle = R1_d10_angle;
		// d11_angle = R1_d11_angle;
		
		targ_ecc = R1_targ_ecc;
		d1_ecc = R1_d1_ecc;
		d2_ecc = R1_d2_ecc;
		d3_ecc = R1_d3_ecc;
		d4_ecc = R1_d4_ecc;
		d5_ecc = R1_d5_ecc;
		d6_ecc = R1_d6_ecc;
		d7_ecc = R1_d7_ecc;
		d8_ecc = R1_d8_ecc;
		d9_ecc = R1_d9_ecc;
		d10_ecc = R1_d10_ecc;
		d11_ecc = R1_d11_ecc;
		
		targ_orient = R1_targ_orient;
		d1_orient = R1_d1_orient;
		d2_orient = R1_d2_orient;
		d3_orient = R1_d3_orient;
		d4_orient = R1_d4_orient;
		d5_orient = R1_d5_orient;
		d6_orient = R1_d6_orient;
		d7_orient = R1_d7_orient;
		d8_orient = R1_d8_orient;
		d9_orient = R1_d9_orient;
		d10_orient = R1_d10_orient;
		d11_orient = R1_d11_orient;
		}	
		
	else if (trialtype == 7) // presents random array on 1/2 of all trials, randomly chosen
		{
		
		TrialTp = 2;
		
		targ_angle = R2_targ_angle;
		d1_angle = R2_d1_angle;
		d2_angle = R2_d2_angle;
		d3_angle = R2_d3_angle;
		d4_angle = R2_d4_angle;
		d5_angle = R2_d5_angle;
		d6_angle = R2_d6_angle;
		d7_angle = R2_d7_angle;
		// d8_angle = R2_d8_angle;
		// d9_angle = R2_d9_angle;
		// d10_angle = R2_d10_angle;
		// d11_angle = R2_d11_angle;
		
		targ_ecc = R2_targ_ecc;
		d1_ecc = R2_d1_ecc;
		d2_ecc = R2_d2_ecc;
		d3_ecc = R2_d3_ecc;
		d4_ecc = R2_d4_ecc;
		d5_ecc = R2_d5_ecc;
		d6_ecc = R2_d6_ecc;
		d7_ecc = R2_d7_ecc;
		d8_ecc = R2_d8_ecc;
		d9_ecc = R2_d9_ecc;
		d10_ecc = R2_d10_ecc;
		d11_ecc = R2_d11_ecc;
		
		targ_orient = R2_targ_orient;
		d1_orient = R2_d1_orient;
		d2_orient = R2_d2_orient;
		d3_orient = R2_d3_orient;
		d4_orient = R2_d4_orient;
		d5_orient = R2_d5_orient;
		d6_orient = R2_d6_orient;
		d7_orient = R2_d7_orient;
		d8_orient = R2_d8_orient;
		d9_orient = R2_d9_orient;
		d10_orient = R2_d10_orient;
		d11_orient = R2_d11_orient;
		
		}	
	else if (trialtype == 8) // presents random array on 1/2 of all trials, randomly chosen
		{
		
		TrialTp = 2;
		
		targ_angle = R3_targ_angle;
		d1_angle = R3_d1_angle;
		d2_angle = R3_d2_angle;
		d3_angle = R3_d3_angle;
		d4_angle = R3_d4_angle;
		d5_angle = R3_d5_angle;
		d6_angle = R3_d6_angle;
		d7_angle = R3_d7_angle;
		// d8_angle = R3_d8_angle;
		// d9_angle = R3_d9_angle;
		// d10_angle = R3_d10_angle;
		// d11_angle = R3_d11_angle;
		
		targ_ecc = R3_targ_ecc;
		d1_ecc = R3_d1_ecc;
		d2_ecc = R3_d2_ecc;
		d3_ecc = R3_d3_ecc;
		d4_ecc = R3_d4_ecc;
		d5_ecc = R3_d5_ecc;
		d6_ecc = R3_d6_ecc;
		d7_ecc = R3_d7_ecc;
		d8_ecc = R3_d8_ecc;
		d9_ecc = R3_d9_ecc;
		d10_ecc = R3_d10_ecc;
		d11_ecc = R3_d11_ecc;
		
		targ_orient = R3_targ_orient;
		d1_orient = R3_d1_orient;
		d2_orient = R3_d2_orient;
		d3_orient = R3_d3_orient;
		d4_orient = R3_d4_orient;
		d5_orient = R3_d5_orient;
		d6_orient = R3_d6_orient;
		d7_orient = R3_d7_orient;
		d8_orient = R3_d8_orient;
		d9_orient = R3_d9_orient;
		d10_orient = R3_d10_orient;
		d11_orient = R3_d11_orient;
		}			
	else if (trialtype == 9) // presents random array on 1/2 of all trials, randomly chosen
		{
		
		TrialTp = 2;
		
		targ_angle = R4_targ_angle;
		d1_angle = R4_d1_angle;
		d2_angle = R4_d2_angle;
		d3_angle = R4_d3_angle;
		d4_angle = R4_d4_angle;
		d5_angle = R4_d5_angle;
		d6_angle = R4_d6_angle;
		d7_angle = R4_d7_angle;
		// d8_angle = R4_d8_angle;
		// d9_angle = R4_d9_angle;
		// d10_angle = R4_d10_angle;
		// d11_angle = R4_d11_angle;
		
		targ_ecc = R4_targ_ecc;
		d1_ecc = R4_d1_ecc;
		d2_ecc = R4_d2_ecc;
		d3_ecc = R4_d3_ecc;
		d4_ecc = R4_d4_ecc;
		d5_ecc = R4_d5_ecc;
		d6_ecc = R4_d6_ecc;
		d7_ecc = R4_d7_ecc;
		d8_ecc = R4_d8_ecc;
		d9_ecc = R4_d9_ecc;
		d10_ecc = R4_d10_ecc;
		d11_ecc = R4_d11_ecc;
		
		targ_orient = R4_targ_orient;
		d1_orient = R4_d1_orient;
		d2_orient = R4_d2_orient;
		d3_orient = R4_d3_orient;
		d4_orient = R4_d4_orient;
		d5_orient = R4_d5_orient;
		d6_orient = R4_d6_orient;
		d7_orient = R4_d7_orient;
		d8_orient = R4_d8_orient;
		d9_orient = R4_d9_orient;
		d10_orient = R4_d10_orient;
		d11_orient = R4_d11_orient;
		}		
	else if (trialtype == 10) // presents random array on 1/2 of all trials, randomly chosen
		{
		
		TrialTp = 2;
		
		targ_angle = R5_targ_angle;
		d1_angle = R5_d1_angle;
		d2_angle = R5_d2_angle;
		d3_angle = R5_d3_angle;
		d4_angle = R5_d4_angle;
		d5_angle = R5_d5_angle;
		d6_angle = R5_d6_angle;
		d7_angle = R5_d7_angle;
		// d8_angle = R5_d8_angle;
		// d9_angle = R5_d9_angle;
		// d10_angle = R5_d10_angle;
		// d11_angle = R5_d11_angle;
		
		targ_ecc = R5_targ_ecc;
		d1_ecc = R5_d1_ecc;
		d2_ecc = R5_d2_ecc;
		d3_ecc = R5_d3_ecc;
		d4_ecc = R5_d4_ecc;
		d5_ecc = R5_d5_ecc;
		d6_ecc = R5_d6_ecc;
		d7_ecc = R5_d7_ecc;
		d8_ecc = R5_d8_ecc;
		d9_ecc = R5_d9_ecc;
		d10_ecc = R5_d10_ecc;
		d11_ecc = R5_d11_ecc;
		
		targ_orient = R5_targ_orient;
		d1_orient = R5_d1_orient;
		d2_orient = R5_d2_orient;
		d3_orient = R5_d3_orient;
		d4_orient = R5_d4_orient;
		d5_orient = R5_d5_orient;
		d6_orient = R5_d6_orient;
		d7_orient = R5_d7_orient;
		d8_orient = R5_d8_orient;
		d9_orient = R5_d9_orient;
		d10_orient = R5_d10_orient;
		d11_orient = R5_d11_orient;
		}			
	else if (trialtype == 11) // presents random array on 1/2 of all trials, randomly chosen
		{
		
		TrialTp = 2;
		
		targ_angle = R6_targ_angle;
		d1_angle = R6_d1_angle;
		d2_angle = R6_d2_angle;
		d3_angle = R6_d3_angle;
		d4_angle = R6_d4_angle;
		d5_angle = R6_d5_angle;
		d6_angle = R6_d6_angle;
		d7_angle = R6_d7_angle;
		// d8_angle = R6_d8_angle;
		// d9_angle = R6_d9_angle;
		// d10_angle = R6_d10_angle;
		// d11_angle = R6_d11_angle;
		
		targ_ecc = R6_targ_ecc;
		d1_ecc = R6_d1_ecc;
		d2_ecc = R6_d2_ecc;
		d3_ecc = R6_d3_ecc;
		d4_ecc = R6_d4_ecc;
		d5_ecc = R6_d5_ecc;
		d6_ecc = R6_d6_ecc;
		d7_ecc = R6_d7_ecc;
		d8_ecc = R6_d8_ecc;
		d9_ecc = R6_d9_ecc;
		d10_ecc = R6_d10_ecc;
		d11_ecc = R6_d11_ecc;
		
		targ_orient = R6_targ_orient;
		d1_orient = R6_d1_orient;
		d2_orient = R6_d2_orient;
		d3_orient = R6_d3_orient;
		d4_orient = R6_d4_orient;
		d5_orient = R6_d5_orient;
		d6_orient = R6_d6_orient;
		d7_orient = R6_d7_orient;
		d8_orient = R6_d8_orient;
		d9_orient = R6_d9_orient;
		d10_orient = R6_d10_orient;
		d11_orient = R6_d11_orient;
		}
}		
		