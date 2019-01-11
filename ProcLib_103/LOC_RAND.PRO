//--------------------------------------------------------------------------------------------
// This code selects RANDOM array locations. Any task using repeated locations uses LOC_REP 
// 
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013


//declare hide int 	pos_jitter = 10;   //  1-15 pixels position jitter 
declare hide int	numTargAngles = 4;
// declare hide int	numTargEcc = 12;
declare hide int	numDistAngles = 8;
declare hide int	numDistEcc = 9;

declare hide 		TgAng;
//declare hide int	THemi; //0=vertical meridian, 1=left hemi, 2=right hemi

//move to ALLVARS.pro
	//declare Rand_targ_angle;
	declare Rand_d1_angle;
	declare Rand_d2_angle;
	declare Rand_d3_angle;
	declare Rand_d4_angle;
	declare Rand_d5_angle;
	declare Rand_d6_angle;
	declare Rand_d7_angle;
	// declare Rand_d8_angle;
	// declare Rand_d9_angle;
	// declare Rand_d10_angle;
	// declare Rand_d11_angle;

	declare Rand_targ_ecc;
	declare Rand_d1_ecc;
	declare Rand_d2_ecc;
	declare Rand_d3_ecc;
	declare Rand_d4_ecc;
	declare Rand_d5_ecc;
	declare Rand_d6_ecc;
	declare Rand_d7_ecc;
	declare Rand_d8_ecc;
	declare Rand_d9_ecc;
	declare Rand_d10_ecc;
	declare Rand_d11_ecc;	

	
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaring/setting up background processes that select target and distractor positions (only used in contextual cueing, since locations fixed in typical search)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

declare RandomizeRanDistAngles();
declare RandomizeRanDistEccentricities();
	
declare RandomizeRanTargAngles();
/* declare RandomizeRanTargEccentricities();
 */
declare LOC_RAND();


process RandomizeRanDistAngles() 
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numDistAngles)			//Run loop while i < total # items in locX array
		{
		j = random(numDistAngles) ; 			//randomly select one of six positions in X location array
		temp = Dist_Ang_list[i];			//stick one of the other locations in temp
		Dist_Ang_list[i] = Dist_Ang_list[j];
		Dist_Ang_list[j] = temp;
		i = i + 1;
		}
	}	

process RandomizeRanDistEccentricities()	
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numDistEcc)			//Run loop while i < total # items in locX array
		{
		j = random(numDistEcc); 			//randomly select one of six positions in X location array
		temp = Dist_Ecc_list[i];			//stick one of the other locations in temp
		Dist_Ecc_list[i] = Dist_Ecc_list[j];
		Dist_Ecc_list[j] = temp;
		i = i + 1;
		}
	}	
	

//////////////////////////////////////////////	
// Selecting Target ocations on each trial //	
////////////////////////////////////////////	
	


process RandomizeRanTargAngles() 
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numTargAngles)			//Run loop while i < total # items in locX array
		{
		j = random(numTargAngles) ; 			//randomly select one of six positions in X location array
		temp = RanTarg_Ang_list[i];			//stick one of the other locations in temp
		RanTarg_Ang_list[i] = RanTarg_Ang_list[j];
		RanTarg_Ang_list[j] = temp;
		i = i + 1;
		}
	}	

/* process RandomizeRanTargEccentricities()	
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numEcc)			//Run loop while i < total # items in locX array
		{
		j = random(numEcc); 			//randomly select one of six positions in X location array
		temp = Ecc_list[i];			//stick one of the other locations in temp
		Ecc_list[i] = Ecc_list[j];
		Ecc_list[j] = temp;
		i = i + 1;
		}
	} */
	


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The fun begins.....	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	

process LOC_RAND
{

////////////////// If turned on, selects eccentricity randomly from trial to trial ////////////////
if (VarEcc == 1)
	{
	if (SelEcc == 0)
		{
		SearchEcc = 6;
		}
	else if (SelEcc == 1)
		{
		SearchEcc = 8;
		}
	else if (SelEcc == 2)
		{
		SearchEcc = 12;
		}
	// else if (SelEcc == 3)
		// {
		// SearchEcc = 18;
		// }	
	}
//////////////////////////////////////////////
		
	if (SingMode == 0)
	{
		d1color = 250;
		if (ArrStruct == 1) // structured array mode
			{	
			if (TargTrainSet == 1) // random target location on each trial
				{
				if (LatStruct == 0) // here LatStruct == 0 presents items ONLY at the 4 square locations; developed for ultrasound
					{
					TgAng = Random(6);
					
					if (TgAng == 0)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[1];      
						Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[2];
						Rand_d3_angle = Angle_list[6]; 
						Rand_d4_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 1)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[2];      
						Rand_d1_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[1];
						Rand_d3_angle = Angle_list[7];
						Rand_d4_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng == 2)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[3];      
						Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[4];
						Rand_d3_angle = Angle_list[0]; 
						Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[5];
						Rand_d6_angle = Angle_list[2]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 3)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[5];      
						Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[7];
						Rand_d3_angle = Angle_list[1];
						Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 					

					else if (TgAng == 4)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[6];      
						Rand_d1_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[4];
						Rand_d3_angle = Angle_list[0]; 
						Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[2]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 5)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[7];      
						Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[5];
						Rand_d3_angle = Angle_list[1];
						Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 
						}
				if (LatStruct == 1)	
					{
						TgAng = Random(8);
					
					if (TgAng == 0)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[1];      
						Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[2];
						Rand_d3_angle = Angle_list[6]; 
						Rand_d4_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 1)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[3];      
						Rand_d1_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[1];
						Rand_d3_angle = Angle_list[7];
						Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng == 2)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[5];      
						Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[4];
						Rand_d3_angle = Angle_list[0]; 
						Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[2]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 3)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[7];      
						Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[5];
						Rand_d3_angle = Angle_list[1];
						Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 
					else if (TgAng == 4)
						{
						THemi = 0;
						Rand_targ_angle = Angle_list[0];      
						Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[2];
						Rand_d3_angle = Angle_list[6]; 
						Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 5)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[2];      
						Rand_d1_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[7];
						Rand_d3_angle = Angle_list[3];
						Rand_d4_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng == 6)
						{
						THemi = 0;
						Rand_targ_angle = Angle_list[4];      
						Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[0];
						Rand_d3_angle = Angle_list[6]; 
						Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 7)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[6];      
						Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
						Rand_d2_angle = Angle_list[1];
						Rand_d3_angle = Angle_list[5];
						Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[0]; 
						Rand_d7_angle = Angle_list[7]; 				
						} 
					}
				}
				
			else if (TargTrainSet == 2) // Target always at 12:00, etc. in clockwise fashion
				{
				THemi = 0;
					Rand_targ_angle = Angle_list[0];      
					Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[6]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7]; 
				}
			else if (TargTrainSet == 3)
				{
					Rand_targ_angle = Angle_list[1];      
					Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[5];
					Rand_d3_angle = Angle_list[7];
					Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 
				}
			else if (TargTrainSet == 4)
				{
				THemi = 1;
					Rand_targ_angle = Angle_list[2];      
					Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7]; 
				}
			else if (TargTrainSet == 5)
				{
				THemi = 1;
					Rand_targ_angle = Angle_list[3];      
					Rand_d1_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[5];
					Rand_d3_angle = Angle_list[1];
					Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 
				}
			else if (TargTrainSet == 6)
				{
				THemi = 0;
					Rand_targ_angle = Angle_list[4];      
					Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[2];
					Rand_d3_angle = Angle_list[6]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7];			
				}
			else if (TargTrainSet == 7)
				{
				THemi = 2;
					Rand_targ_angle = Angle_list[5];      
					Rand_d1_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[7];
					Rand_d3_angle = Angle_list[3];
					Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 			
				}
			else if (TargTrainSet == 8)
				{
				THemi = 2;
					Rand_targ_angle = Angle_list[6];      
					Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[0];
					Rand_d3_angle = Angle_list[4]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7];  			
				}
			else if (TargTrainSet == 9)
				{
				THemi = 2;
					Rand_targ_angle = Angle_list[7];      
					Rand_d1_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[1];
					Rand_d3_angle = Angle_list[5];
					Rand_d4_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0];			
				}
			
			//This variable is set in DEFAULT.PRO and can be any integer between 0 and the end of the screen
			Rand_targ_ecc = SearchEcc;	//Sets fixed eccentricity for all training items. See DEFAULT.pros for setting each of these variables
			Rand_d1_ecc = SearchEcc;
			Rand_d2_ecc = SearchEcc;
			Rand_d3_ecc = SearchEcc;
			Rand_d4_ecc = SearchEcc;
			Rand_d5_ecc = SearchEcc;
			Rand_d6_ecc = SearchEcc;
			Rand_d7_ecc = SearchEcc;

			}
	
		if(ArrStruct == 0) //contextual cueing mode
			{
			
			// The two processes below select random angles and eccentricities for each search item, creating an entirely unstructured search array
			// Importantly, this also selects from the angle and eccentricity lists that are housed in ALL_VARS.pro, as opposed to the above ecccs and angles, which 
			// come from DEFAULT.PRO and can be hard coded on the fly.

			spawn RandomizeRanDistAngles;                         // Runs RandomizeRanAngles
			waitforprocess RandomizeRanDistAngles;                // Waits for it to finish
			
			spawn RandomizeRanDistEccentricities;                         // Runs RandomizeREccentricities
			waitforprocess RandomizeRanDistEccentricities;                // Waits for it to finish
			
			spawn RandomizeRanTargAngles;                         // Runs RandomizeRanTargAngles
			waitforprocess RandomizeRanTargAngles;                // Waits for it to finish 
			 
			 
			// Note to self: if it ever becomes necessary for contextual cueing, can use a for loop to state that if (Ang_list[X] = Rand_targ_angle 
			// that gets selected AT THE BEGINNING OF THE SESSION, switch it to location Ang_list[setsize - 1]. would have to 
			// add a thirteenth location for this to work with setsize twelve, this would allow me to select locations for targets in the random session without acceindetal overlap between targets and later 'random' distractors
			
			//Random array angles	
			Rand_targ_angle = RanTarg_Ang_list[0];					
			Rand_d1_angle = Dist_Ang_list[1];
			Rand_d2_angle = Dist_Ang_list[2];
			Rand_d3_angle = Dist_Ang_list[3];
			Rand_d4_angle = Dist_Ang_list[4];
			Rand_d5_angle = Dist_Ang_list[5];
			Rand_d6_angle = Dist_Ang_list[6];
			Rand_d7_angle = Dist_Ang_list[7];
			// Rand_d8_angle = Ang_list[8];
			// Rand_d9_angle = Ang_list[9];
			// Rand_d10_angle = Ang_list[10];
			// Rand_d11_angle = Ang_list[11];
			
			//Random Array Eccentricities
			Rand_targ_ecc = SearchEcc;
			Rand_d1_ecc = Dist_Ecc_List[1];
			Rand_d2_ecc = Dist_Ecc_List[2];
			Rand_d3_ecc = Dist_Ecc_List[3];
			Rand_d4_ecc = Dist_Ecc_List[4];
			Rand_d5_ecc = Dist_Ecc_List[5];
			Rand_d6_ecc = Dist_Ecc_List[6];
			Rand_d7_ecc = Dist_Ecc_List[7];
			Rand_d8_ecc = Dist_Ecc_List[8];
			// Rand_d9_ecc = Dist_Ecc_List[9];
			// Rand_d10_ecc = Dist_Ecc_List[10];
			// Rand_d11_ecc = Dist_Ecc_List[11];
			} 
	}		
			
		
			
	else if (SingMode == 1)
		{	
			
			//This snippet allows us to select the proportion of trials on which a singleton appear, default is set in DEFAULT.pro
			SingFreq = Random(100); 
			if (SingFreq < PercSingTrl)
			{
			d1color = 251;
			DistPres = 2222; //singleton distractor present, for strobing
			}
			else
			{
			d1color = 250;
			DistPres = 1111; //singleton distractor absent, for strobing
			}
		if (ArrStruct == 1)
			{
			
			if (LatStruct == 0)
				{
				TgAng = Random(4); // change to 4 if we want to include up/down positions; change to 2 if just wanting lateral positions
					
				if (TgAng == 0) //Left target, right distractor
					{
					THemi = 8100;
					DHemi = 8200;
					Rand_targ_angle = Angle_list[6];      
					Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[1];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[5]; 
					}
				if (TgAng == 1) //Right target, left distractor
					{
					THemi = 8200;
					DHemi = 8100;
					Rand_targ_angle = Angle_list[2];      
					Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[5];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[3]; 
					}	
				if (TgAng == 2) //Top target, bottom distractor
					{
					THemi = 8100;
					DHemi = 8200;
					Rand_targ_angle = Angle_list[0];      
					Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[2]; 
					Rand_d4_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[1];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[5]; 
					}
				if (TgAng == 3) //Bottom target, Top distractor
					{
					THemi = 8200;
					DHemi = 8100;
					Rand_targ_angle = Angle_list[4];      
					Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[2]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[5];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[3]; 
					}		
			
							
				//Target eccentricity - This variable is set in DEFAULT.PRO and can be any integer between 0 and the end of the screen
					Rand_targ_ecc = SearchEcc;	//Sets fixed eccentricity for all training items. See DEFAULT.pros for setting each of these variables
					Rand_d1_ecc = SearchEcc;
					Rand_d2_ecc = SearchEcc;
					Rand_d3_ecc = SearchEcc;
					Rand_d4_ecc = SearchEcc;
					Rand_d5_ecc = SearchEcc;
					Rand_d6_ecc = SearchEcc;
					Rand_d7_ecc = SearchEcc;
				}
			
			else
				{
				TgAng = Random(12);
				
				if (TgAng == 0) //Top vertical target, right distractor
					{
					THemi = 8888;
					DHemi = 8200;
					Rand_targ_angle = Angle_list[0];      
					Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[4]; 
					Rand_d4_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[1];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[5]; 
					}
				if (TgAng == 1) //Top vertical target, left distractor
					{
					THemi = 8888;
					DHemi = 8100;
					Rand_targ_angle = Angle_list[0];      
					Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[2]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[5];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[3]; 
					}				
				if (TgAng == 2) //Bottom vertical target, right distractor
					{
					THemi = 8888;
					DHemi = 8200;
					Rand_targ_angle = Angle_list[4];      
					Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[1];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[7]; 
					}
				if (TgAng == 3) //Bottom vertical target, left distractor
					{
					THemi = 8888;
					DHemi = 8100;
					Rand_targ_angle = Angle_list[4];      
					Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[2];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[5];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[3]; 
					}					
				if (TgAng == 4) //Left target, vertical top distractor
					{
					THemi = 8100;
					DHemi = 8888;
					Rand_targ_angle = Angle_list[6];      
					Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[2]; 
					Rand_d4_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[1]; 
					}					
				if (TgAng == 5) //Left target, vertical bottom distractor
					{
					THemi = 8100;
					DHemi = 8888;
					Rand_targ_angle = Angle_list[6];      
					Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[2];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[5];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[1]; 
					}			
				if (TgAng == 6) //Right target, vertical top distractor
					{
					THemi = 8200;
					DHemi = 8888;
					Rand_targ_angle = Angle_list[2];      
					Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[4]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[7];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[5]; 
					}					
				if (TgAng == 7) //Right target, vertical bottom distractor
					{
					THemi = 8200;
					DHemi = 8888;
					Rand_targ_angle = Angle_list[2];      
					Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[3];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[7];
					Rand_d6_angle = Angle_list[1]; 
					Rand_d7_angle = Angle_list[5]; 
					}		
				if (TgAng == 8) //Left target, right distractor
					{
					THemi = 8100;
					DHemi = 8200;
					Rand_targ_angle = Angle_list[6];      
					Rand_d1_angle = Angle_list[2];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[1];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[5]; 
					}
				if (TgAng == 9) //Right target, left distractor
					{
					THemi = 8200;
					DHemi = 8100;
					Rand_targ_angle = Angle_list[2];      
					Rand_d1_angle = Angle_list[6];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[5];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[3]; 
					}	
				if (TgAng == 10) //Top target, bottom distractor
					{
					THemi = 8888;
					DHemi = 8888;
					Rand_targ_angle = Angle_list[0];      
					Rand_d1_angle = Angle_list[4];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[2]; 
					Rand_d4_angle = Angle_list[7];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[1];
					Rand_d6_angle = Angle_list[3]; 
					Rand_d7_angle = Angle_list[5]; 
					}
				if (TgAng == 11) //Bottom target, Top distractor
					{
					THemi = 8888;
					DHemi = 8888;
					Rand_targ_angle = Angle_list[4];      
					Rand_d1_angle = Angle_list[0];	//See DEFAULT.pros for setting each of these variables
					Rand_d2_angle = Angle_list[6];
					Rand_d3_angle = Angle_list[2]; 
					Rand_d4_angle = Angle_list[1];	//See DEFAULT.pros for setting each of these variables
					Rand_d5_angle = Angle_list[5];
					Rand_d6_angle = Angle_list[7]; 
					Rand_d7_angle = Angle_list[3]; 
					}		
			
							
				//Target eccentricity - This variable is set in DEFAULT.PRO and can be any integer between 0 and the end of the screen
					Rand_targ_ecc = SearchEcc;	//Sets fixed eccentricity for all training items. See DEFAULT.pros for setting each of these variables
					Rand_d1_ecc = SearchEcc;
					Rand_d2_ecc = SearchEcc;
					Rand_d3_ecc = SearchEcc;
					Rand_d4_ecc = SearchEcc;
					Rand_d5_ecc = SearchEcc;
					Rand_d6_ecc = SearchEcc;
					Rand_d7_ecc = SearchEcc;
			
				}
			}
		if(ArrStruct == 0) //contextual cueing mode
			{
			
			// The two processes below select random angles and eccentricities for each search item, creating an entirely unstructured search array
			// Importantly, this also selects from the angle and eccentricity lists that are housed in ALL_VARS.pro, as opposed to the above ecccs and angles, which 
			// come from DEFAULT.PRO and can be hard coded on the fly.

			spawn RandomizeRanDistAngles;                         // Runs RandomizeRanAngles
			waitforprocess RandomizeRanDistAngles;                // Waits for it to finish
			
			spawn RandomizeRanDistEccentricities;                         // Runs RandomizeREccentricities
			waitforprocess RandomizeRanDistEccentricities;                // Waits for it to finish
			
			spawn RandomizeRanTargAngles;                         // Runs RandomizeRanTargAngles
			waitforprocess RandomizeRanTargAngles;                // Waits for it to finish 
			 
			 
			// Note to self: if it ever becomes necessary for contextual cueing, can use a for loop to state that if (Ang_list[X] = Rand_targ_angle 
			// that gets selected AT THE BEGINNING OF THE SESSION, switch it to location Ang_list[setsize - 1]. would have to 
			// add a thirteenth location for this to work with setsize twelve, this would allow me to select locations for targets in the random session without acceindetal overlap between targets and later 'random' distractors
			
			//Random array angles	
			Rand_targ_angle = RanTarg_Ang_list[0];					
			Rand_d1_angle = Dist_Ang_list[1];
			Rand_d2_angle = Dist_Ang_list[2];
			Rand_d3_angle = Dist_Ang_list[3];
			Rand_d4_angle = Dist_Ang_list[4];
			Rand_d5_angle = Dist_Ang_list[5];
			Rand_d6_angle = Dist_Ang_list[6];
			Rand_d7_angle = Dist_Ang_list[7];
			// Rand_d8_angle = Ang_list[8];
			// Rand_d9_angle = Ang_list[9];
			// Rand_d10_angle = Ang_list[10];
			// Rand_d11_angle = Ang_list[11];
			
			//Random Array Eccentricities
			Rand_targ_ecc = SearchEcc;
			Rand_d1_ecc = Dist_Ecc_List[1];
			Rand_d2_ecc = Dist_Ecc_List[2];
			Rand_d3_ecc = Dist_Ecc_List[3];
			Rand_d4_ecc = Dist_Ecc_List[4];
			Rand_d5_ecc = Dist_Ecc_List[5];
			Rand_d6_ecc = Dist_Ecc_List[6];
			Rand_d7_ecc = Dist_Ecc_List[7];
			Rand_d8_ecc = Dist_Ecc_List[8];
			// Rand_d9_ecc = Dist_Ecc_List[9];
			// Rand_d10_ecc = Dist_Ecc_List[10];
			// Rand_d11_ecc = Dist_Ecc_List[11];
			}			
		}
	}	