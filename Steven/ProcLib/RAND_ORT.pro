

declare	int	i, j, temp;
declare int orientation;
declare float RandHomo_orient;	
declare hide DistOrients[4] = {1, 2, 3, 4};		//Possible T orientations
declare hide TargOrients[4] = {1, 2, 3, 4};		//Possible T orientations

declare Rand_targ_orient;
declare Rand_d1_orient;
declare Rand_d2_orient;
declare Rand_d3_orient;
declare Rand_d4_orient;
declare Rand_d5_orient;
declare Rand_d6_orient;
declare Rand_d7_orient;
declare Rand_d8_orient;
declare Rand_d9_orient;
declare Rand_d10_orient;
declare Rand_d11_orient;	

declare RAND_ORT();

process RAND_ORT 
	{
			
		// Randomize/Shuffle orientations

		i = 0;
		while (i < 4)			//Run loop while i < total # items in Tstimorients array
			{
			j = random(4); 			//randomly select one of six positions in X location array
			temp = DistOrients[i];			//stick one of the other locations in temp
			DistOrients[i] = DistOrients[j];
			DistOrients[j] = temp;

			temp = TargOrients[i];			//stick one of the other locations in temp
			TargOrients[i] = TargOrients[j];
			TargOrients[j] = temp;
			i = i + 1;
			}
/////////////////////////////////////// Code below allows selection of random homogeneous distractor identities during training ///////////////////////		
	

		if (SearchType == 1)	
			{
			Rand_targ_orient = TargOrt;
			Rand_d1_orient = DistOrients[0];
			Rand_d2_orient = DistOrients[1];
			Rand_d3_orient = DistOrients[2];
			Rand_d4_orient = DistOrients[3];
			Rand_d5_orient = DistOrients[0];
			Rand_d6_orient = DistOrients[1];
			Rand_d7_orient = DistOrients[2];
			Rand_d8_orient = DistOrients[3];
			Rand_d9_orient = DistOrients[0];
			Rand_d10_orient = DistOrients[1];
			Rand_d11_orient = DistOrients[2];
			}
		if (SearchType == 2)	
			{		
			Rand_targ_orient = TargOrt;
			Rand_d1_orient = DistOrt;
			Rand_d2_orient = DistOrt;
			Rand_d3_orient = DistOrt;
			Rand_d4_orient = DistOrt;
			Rand_d5_orient = DistOrt;
			Rand_d6_orient = DistOrt;
			Rand_d7_orient = DistOrt;
			Rand_d8_orient = DistOrt;
			Rand_d9_orient = DistOrt;
			Rand_d10_orient = DistOrt;
			Rand_d11_orient = DistOrt;
			}
		
		if (SearchType == 3)
			{
				
			RandHomo_orient = random(4);	
			
			Rand_targ_orient = TargOrt;
			Rand_d1_orient = DistOrients[RandHomo_orient];
			Rand_d2_orient = DistOrients[RandHomo_orient];
			Rand_d3_orient = DistOrients[RandHomo_orient];
			Rand_d4_orient = DistOrients[RandHomo_orient];
			Rand_d5_orient = DistOrients[RandHomo_orient];
			Rand_d6_orient = DistOrients[RandHomo_orient];
			Rand_d7_orient = DistOrients[RandHomo_orient];
			Rand_d8_orient = DistOrients[RandHomo_orient];
			Rand_d9_orient = DistOrients[RandHomo_orient];
			Rand_d10_orient = DistOrients[RandHomo_orient];
			Rand_d11_orient = DistOrients[RandHomo_orient];	 	
			}

		if (SearchType == 4) //singleton search mode, selects orientations (based on settings in DEFAULT.pro, and target types, randomly selected on each trial using TD_Select below
			{
				
			TD_Select = random(2);	
			
			if (TD_Select == 1)
				{
				TargetType = 1; //T Target
				Rand_targ_orient = TargOrt1;
				Rand_d1_orient = TargOrt2;
				Rand_d2_orient = TargOrt2;
				Rand_d3_orient = TargOrt2;
				Rand_d4_orient = TargOrt2;
				Rand_d5_orient = TargOrt2;
				Rand_d6_orient = TargOrt2;
				Rand_d7_orient = TargOrt2;
				Rand_d8_orient = TargOrt2;
				Rand_d9_orient = TargOrt2;
				Rand_d10_orient = TargOrt2;
				Rand_d11_orient = TargOrt2;
				}
			else
				{
				TargetType = 2; //L Target
				Rand_targ_orient = TargOrt2;
				Rand_d1_orient = TargOrt1;
				Rand_d2_orient = TargOrt1;
				Rand_d3_orient = TargOrt1;
				Rand_d4_orient = TargOrt1;
				Rand_d5_orient = TargOrt1;
				Rand_d6_orient = TargOrt1;
				Rand_d7_orient = TargOrt1;
				Rand_d8_orient = TargOrt1;
				Rand_d9_orient = TargOrt1;
				Rand_d10_orient = TargOrt1;
				Rand_d11_orient = TargOrt1;
				}
			}	
			
		if (SearchType == 5) //Variable Target, for detection only; 45b pilot	
			{	
				TD_Select = random(2);
				TargOrt = random(4);
				
			if (TD_Select == 1)
				{
				TargetType = 1; //T Target
				Rand_targ_orient = TargOrt;
				}
			else
				{
				TargetType = 2; //L Target
				Rand_targ_orient = TargOrt;
				}	
				
			}	
			
		}



	
	