

declare	int	i, j, temp;
declare int orientation;
declare float Homo_orient;	
declare hide RepDistOrients[4] = {1, 2, 3, 4};		//Possible T/L orientations
declare hide RepTargOrients[4] = {1, 2, 3, 4};		//Possible T/L orientations

declare R1_targ_orient;
declare R1_d1_orient;
declare R1_d2_orient;
declare R1_d3_orient;
declare R1_d4_orient;
declare R1_d5_orient;
declare R1_d6_orient;
declare R1_d7_orient;
declare R1_d8_orient;
declare R1_d9_orient;
declare R1_d10_orient;
declare R1_d11_orient;	

declare R2_targ_orient;
declare R2_d1_orient;
declare R2_d2_orient;
declare R2_d3_orient;
declare R2_d4_orient;
declare R2_d5_orient;
declare R2_d6_orient;
declare R2_d7_orient;
declare R2_d8_orient;
declare R2_d9_orient;
declare R2_d10_orient;
declare R2_d11_orient;

declare R3_targ_orient;
declare R3_d1_orient;
declare R3_d2_orient;
declare R3_d3_orient;
declare R3_d4_orient;
declare R3_d5_orient;
declare R3_d6_orient;
declare R3_d7_orient;
declare R3_d8_orient;
declare R3_d9_orient;
declare R3_d10_orient;
declare R3_d11_orient;

declare R4_targ_orient;
declare R4_d1_orient;
declare R4_d2_orient;
declare R4_d3_orient;
declare R4_d4_orient;
declare R4_d5_orient;
declare R4_d6_orient;
declare R4_d7_orient;
declare R4_d8_orient;
declare R4_d9_orient;
declare R4_d10_orient;
declare R4_d11_orient;

declare R5_targ_orient;
declare R5_d1_orient;
declare R5_d2_orient;
declare R5_d3_orient;
declare R5_d4_orient;
declare R5_d5_orient;
declare R5_d6_orient;
declare R5_d7_orient;
declare R5_d8_orient;
declare R5_d9_orient;
declare R5_d10_orient;
declare R5_d11_orient;

declare R6_targ_orient;
declare R6_d1_orient;
declare R6_d2_orient;
declare R6_d3_orient;
declare R6_d4_orient;
declare R6_d5_orient;
declare R6_d6_orient;
declare R6_d7_orient;
declare R6_d8_orient;
declare R6_d9_orient;
declare R6_d10_orient;
declare R6_d11_orient;

declare REP_ORT();

process REP_ORT 
    {
		
	// Randomize/Shuffle orientations

	i = 0;
	while (i < 4)			//Run loop while i < total # items in Tstimorients array
		{
		j = random(4); 			//randomly select one of six positions in X location array
		temp = RepDistOrients[i];			//stick one of the other locations in temp
		RepDistOrients[i] = RepDistOrients[j];
		RepDistOrients[j] = temp;

		temp = RepTargOrients[i];			//stick one of the other locations in temp
		RepTargOrients[i] = RepTargOrients[j];
		RepTargOrients[j] = temp;
		i = i + 1;
		}
	
	// Different configurations of orientations for each array, with constraint that all but 1 orientation appears thrice
	
	if (SearchType == 1)
		{	
		R1_targ_orient = TargOrt;
		R1_d1_orient = RepDistOrients[0];
		R1_d2_orient = RepDistOrients[1];
		R1_d3_orient = RepDistOrients[2];
		R1_d4_orient = RepDistOrients[3];
		R1_d5_orient = RepDistOrients[0];
		R1_d6_orient = RepDistOrients[1];
		R1_d7_orient = RepDistOrients[2];
		R1_d8_orient = RepDistOrients[3];
		R1_d9_orient = RepDistOrients[0];
		R1_d10_orient = RepDistOrients[1];
		R1_d11_orient = RepDistOrients[2];	
		
		R2_targ_orient = TargOrt;
		R2_d1_orient = RepDistOrients[3];
		R2_d2_orient = RepDistOrients[2];
		R2_d3_orient = RepDistOrients[1];
		R2_d4_orient = RepDistOrients[0];
		R2_d5_orient = RepDistOrients[3];
		R2_d6_orient = RepDistOrients[2];
		R2_d7_orient = RepDistOrients[1];
		R2_d8_orient = RepDistOrients[0];
		R2_d9_orient = RepDistOrients[3];
		R2_d10_orient = RepDistOrients[2];
		R2_d11_orient = RepDistOrients[1];

		R3_targ_orient = TargOrt;
		R3_d1_orient = RepDistOrients[2];
		R3_d2_orient = RepDistOrients[1];
		R3_d3_orient = RepDistOrients[3];
		R3_d4_orient = RepDistOrients[0];
		R3_d5_orient = RepDistOrients[2];
		R3_d6_orient = RepDistOrients[1];
		R3_d7_orient = RepDistOrients[3];
		R3_d8_orient = RepDistOrients[0];
		R3_d9_orient = RepDistOrients[2];
		R3_d10_orient = RepDistOrients[1];
		R3_d11_orient = RepDistOrients[3];	
		
		R4_targ_orient = TargOrt;
		R4_d1_orient = RepDistOrients[1];
		R4_d2_orient = RepDistOrients[0];
		R4_d3_orient = RepDistOrients[3];
		R4_d4_orient = RepDistOrients[2];
		R4_d5_orient = RepDistOrients[1];
		R4_d6_orient = RepDistOrients[0];
		R4_d7_orient = RepDistOrients[3];
		R4_d8_orient = RepDistOrients[2];
		R4_d9_orient = RepDistOrients[1];
		R4_d10_orient = RepDistOrients[0];
		R4_d11_orient = RepDistOrients[3];	
		
		R5_targ_orient = TargOrt;
		R5_d1_orient = RepDistOrients[2];
		R5_d2_orient = RepDistOrients[0];
		R5_d3_orient = RepDistOrients[3];
		R5_d4_orient = RepDistOrients[1];
		R5_d5_orient = RepDistOrients[2];
		R5_d6_orient = RepDistOrients[0];
		R5_d7_orient = RepDistOrients[3];
		R5_d8_orient = RepDistOrients[1];
		R5_d9_orient = RepDistOrients[2];
		R5_d10_orient = RepDistOrients[0];
		R5_d11_orient = RepDistOrients[3];

		R6_targ_orient = TargOrt;
		R6_d1_orient = RepDistOrients[2];
		R6_d2_orient = RepDistOrients[3];
		R6_d3_orient = RepDistOrients[1];
		R6_d4_orient = RepDistOrients[0];
		R6_d5_orient = RepDistOrients[2];
		R6_d6_orient = RepDistOrients[3];
		R6_d7_orient = RepDistOrients[1];
		R6_d8_orient = RepDistOrients[0];
		R6_d9_orient = RepDistOrients[2];
		R6_d10_orient = RepDistOrients[3];
		R6_d11_orient = RepDistOrients[1];	
		}
		
	else if (SearchType == 2)
		{
		
		Homo_orient = random(4);
		
		R1_targ_orient = TargOrt;
		R1_d1_orient = RepDistOrients[Homo_orient];
		R1_d2_orient = RepDistOrients[Homo_orient];
		R1_d3_orient = RepDistOrients[Homo_orient];
		R1_d4_orient = RepDistOrients[Homo_orient];
		R1_d5_orient = RepDistOrients[Homo_orient];
		R1_d6_orient = RepDistOrients[Homo_orient];
		R1_d7_orient = RepDistOrients[Homo_orient];
		R1_d8_orient = RepDistOrients[Homo_orient];
		R1_d9_orient = RepDistOrients[Homo_orient];
		R1_d10_orient = RepDistOrients[Homo_orient];
		R1_d11_orient = RepDistOrients[Homo_orient];	
		
		R2_targ_orient = TargOrt;
		R2_d1_orient = RepDistOrients[Homo_orient];
		R2_d2_orient = RepDistOrients[Homo_orient];
		R2_d3_orient = RepDistOrients[Homo_orient];
		R2_d4_orient = RepDistOrients[Homo_orient];
		R2_d5_orient = RepDistOrients[Homo_orient];
		R2_d6_orient = RepDistOrients[Homo_orient];
		R2_d7_orient = RepDistOrients[Homo_orient];
		R2_d8_orient = RepDistOrients[Homo_orient];
		R2_d9_orient = RepDistOrients[Homo_orient];
		R2_d10_orient = RepDistOrients[Homo_orient];
		R2_d11_orient = RepDistOrients[Homo_orient];

		R3_targ_orient = TargOrt;
		R3_d1_orient = RepDistOrients[Homo_orient];
		R3_d2_orient = RepDistOrients[Homo_orient];
		R3_d3_orient = RepDistOrients[Homo_orient];
		R3_d4_orient = RepDistOrients[Homo_orient];
		R3_d5_orient = RepDistOrients[Homo_orient];
		R3_d6_orient = RepDistOrients[Homo_orient];
		R3_d7_orient = RepDistOrients[Homo_orient];
		R3_d8_orient = RepDistOrients[Homo_orient];
		R3_d9_orient = RepDistOrients[Homo_orient];
		R3_d10_orient = RepDistOrients[Homo_orient];
		R3_d11_orient = RepDistOrients[Homo_orient];	
		
		R4_targ_orient = TargOrt;
		R4_d1_orient = RepDistOrients[Homo_orient];
		R4_d2_orient = RepDistOrients[Homo_orient];
		R4_d3_orient = RepDistOrients[Homo_orient];
		R4_d4_orient = RepDistOrients[Homo_orient];
		R4_d5_orient = RepDistOrients[Homo_orient];
		R4_d6_orient = RepDistOrients[Homo_orient];
		R4_d7_orient = RepDistOrients[Homo_orient];
		R4_d8_orient = RepDistOrients[Homo_orient];
		R4_d9_orient = RepDistOrients[Homo_orient];
		R4_d10_orient = RepDistOrients[Homo_orient];
		R4_d11_orient = RepDistOrients[Homo_orient];	
		
		R5_targ_orient = TargOrt;
		R5_d1_orient = RepDistOrients[Homo_orient];
		R5_d2_orient = RepDistOrients[Homo_orient];
		R5_d3_orient = RepDistOrients[Homo_orient];
		R5_d4_orient = RepDistOrients[Homo_orient];
		R5_d5_orient = RepDistOrients[Homo_orient];
		R5_d6_orient = RepDistOrients[Homo_orient];
		R5_d7_orient = RepDistOrients[Homo_orient];
		R5_d8_orient = RepDistOrients[Homo_orient];
		R5_d9_orient = RepDistOrients[Homo_orient];
		R5_d10_orient = RepDistOrients[Homo_orient];
		R5_d11_orient = RepDistOrients[Homo_orient];

		R6_targ_orient = TargOrt;
		R6_d1_orient = RepDistOrients[Homo_orient];
		R6_d2_orient = RepDistOrients[Homo_orient];
		R6_d3_orient = RepDistOrients[Homo_orient];
		R6_d4_orient = RepDistOrients[Homo_orient];
		R6_d5_orient = RepDistOrients[Homo_orient];
		R6_d6_orient = RepDistOrients[Homo_orient];
		R6_d7_orient = RepDistOrients[Homo_orient];
		R6_d8_orient = RepDistOrients[Homo_orient];
		R6_d9_orient = RepDistOrients[Homo_orient];
		R6_d10_orient = RepDistOrients[Homo_orient];
		R6_d11_orient = RepDistOrients[Homo_orient];				
		}
	}

	
	