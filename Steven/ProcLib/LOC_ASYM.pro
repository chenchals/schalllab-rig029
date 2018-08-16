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

	declare Rand_targ_ecc;
	declare Rand_d1_ecc;
	declare Rand_d2_ecc;
	declare Rand_d3_ecc;
	declare Rand_d4_ecc;
	declare Rand_d5_ecc;
	declare Rand_d6_ecc;
	declare Rand_d7_ecc;	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaring/setting up background processes that select target and distractor positions (only used in contextual cueing, since locations fixed in typical search)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

declare LOC_ASYM();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The fun begins.....	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
process LOC_ASYM
{		
		d1color = 250; // nonsalient distractor color = gray
		if (ArrStruct == 1) // structured array mode
			{	
			if (ProbCue == 0) // in this probability cueing case, 1 means probability cueing is turned on
				{
				TgAng = Random(8);
				
				if (TgAng == 0)
					{
					THemi = 0;
					Rand_targ_angle = Angle_list[0]; //Top location  
					Rand_d1_angle = Angle_list[4];	
					Rand_d2_angle = Angle_list[2];
					Rand_d3_angle = Angle_list[6]; 
					Rand_d4_angle = Angle_list[1];	
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7]; 
					}
				else if (TgAng == 1)
					{
					THemi = 1;
					Rand_targ_angle = Angle_list[1];      
					Rand_d1_angle = Angle_list[5];	
					Rand_d2_angle = Angle_list[3];
					Rand_d3_angle = Angle_list[7];
					Rand_d4_angle = Angle_list[2];	
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 	
					}
				else if (TgAng == 2)
					{
					THemi = 1;
					Rand_targ_angle = Angle_list[2];      
					Rand_d1_angle = Angle_list[6];	
					Rand_d2_angle = Angle_list[4];
					Rand_d3_angle = Angle_list[0]; 
					Rand_d4_angle = Angle_list[1];	
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7]; 
					}
				else if (TgAng == 3)
					{
					THemi = 1;
					Rand_targ_angle = Angle_list[3];      
					Rand_d1_angle = Angle_list[7];	
					Rand_d2_angle = Angle_list[5];
					Rand_d3_angle = Angle_list[1];
					Rand_d4_angle = Angle_list[2];	
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 				
					} 
				else if (TgAng == 4)
					{
					THemi = 0;
					Rand_targ_angle = Angle_list[4];      
					Rand_d1_angle = Angle_list[0];	
					Rand_d2_angle = Angle_list[2];
					Rand_d3_angle = Angle_list[6]; 
					Rand_d4_angle = Angle_list[1];	
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7]; 
					}
				else if (TgAng == 5)
					{
					THemi = 2;
					Rand_targ_angle = Angle_list[5];      
					Rand_d1_angle = Angle_list[1];	
					Rand_d2_angle = Angle_list[7];
					Rand_d3_angle = Angle_list[3];
					Rand_d4_angle = Angle_list[2];	
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 	
					}
				else if (TgAng == 6)
					{
					THemi = 2;
					Rand_targ_angle = Angle_list[6];      
					Rand_d1_angle = Angle_list[2];	
					Rand_d2_angle = Angle_list[0];
					Rand_d3_angle = Angle_list[4]; 
					Rand_d4_angle = Angle_list[1];	
					Rand_d5_angle = Angle_list[3];
					Rand_d6_angle = Angle_list[5]; 
					Rand_d7_angle = Angle_list[7]; 
					}
				else if (TgAng == 7)
					{
					THemi = 2;
					Rand_targ_angle = Angle_list[7];      
					Rand_d1_angle = Angle_list[3];	
					Rand_d2_angle = Angle_list[1];
					Rand_d3_angle = Angle_list[5];
					Rand_d4_angle = Angle_list[2];	
					Rand_d5_angle = Angle_list[4];
					Rand_d6_angle = Angle_list[6]; 
					Rand_d7_angle = Angle_list[0]; 				
					} 						
				}
			else if (ProbCue == 1) // in this probability cueing case, 1 means probability cueing is turned on
				{
				TgAng = Random(12);
				
				if (ProbSide == 0) //right side more probable					
					{
					if (TgAng <= 2)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[1];      
						Rand_d1_angle = Angle_list[5];	
						Rand_d2_angle = Angle_list[3];
						Rand_d3_angle = Angle_list[7];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng >= 3 && TgAng <= 5)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[2];      
						Rand_d1_angle = Angle_list[6];	
						Rand_d2_angle = Angle_list[4];
						Rand_d3_angle = Angle_list[0]; 
						Rand_d4_angle = Angle_list[1];	
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng >= 6 && TgAng <= 8)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[3];      
						Rand_d1_angle = Angle_list[7];	
						Rand_d2_angle = Angle_list[5];
						Rand_d3_angle = Angle_list[1];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 
					else if (TgAng == 9)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[5];      
						Rand_d1_angle = Angle_list[1];	
						Rand_d2_angle = Angle_list[7];
						Rand_d3_angle = Angle_list[3];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng == 10)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[6];      
						Rand_d1_angle = Angle_list[2];	
						Rand_d2_angle = Angle_list[0];
						Rand_d3_angle = Angle_list[4]; 
						Rand_d4_angle = Angle_list[1];	
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 11)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[7];      
						Rand_d1_angle = Angle_list[3];	
						Rand_d2_angle = Angle_list[1];
						Rand_d3_angle = Angle_list[5];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 
					}
				else if (ProbSide == 1) //left side more probable					
					{
					if (TgAng <= 2)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[5];      
						Rand_d1_angle = Angle_list[1];	
						Rand_d2_angle = Angle_list[3];
						Rand_d3_angle = Angle_list[7];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng >= 3 && TgAng <= 5)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[6];      
						Rand_d1_angle = Angle_list[2];	
						Rand_d2_angle = Angle_list[4];
						Rand_d3_angle = Angle_list[0]; 
						Rand_d4_angle = Angle_list[1];	
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng >= 6 && TgAng <= 8)
						{
						THemi = 2;
						Rand_targ_angle = Angle_list[7];      
						Rand_d1_angle = Angle_list[3];	
						Rand_d2_angle = Angle_list[5];
						Rand_d3_angle = Angle_list[1];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 
					else if (TgAng == 9)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[1];      
						Rand_d1_angle = Angle_list[5];	
						Rand_d2_angle = Angle_list[7];
						Rand_d3_angle = Angle_list[3];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 	
						}
					else if (TgAng == 10)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[2];      
						Rand_d1_angle = Angle_list[6];	
						Rand_d2_angle = Angle_list[0];
						Rand_d3_angle = Angle_list[4]; 
						Rand_d4_angle = Angle_list[1];	
						Rand_d5_angle = Angle_list[3];
						Rand_d6_angle = Angle_list[5]; 
						Rand_d7_angle = Angle_list[7]; 
						}
					else if (TgAng == 11)
						{
						THemi = 1;
						Rand_targ_angle = Angle_list[3];      
						Rand_d1_angle = Angle_list[7];	
						Rand_d2_angle = Angle_list[1];
						Rand_d3_angle = Angle_list[5];
						Rand_d4_angle = Angle_list[2];	
						Rand_d5_angle = Angle_list[4];
						Rand_d6_angle = Angle_list[6]; 
						Rand_d7_angle = Angle_list[0]; 				
						} 
					}	
				}				
			//The variable below is set in DEFAULT.PRO and can be any integer between 0 and the end of the screen
			
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