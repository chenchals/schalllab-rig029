//--------------------------------------------------------------------------------------------
// This code selects RANDOM array locations 
// 
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013


//declare hide int 	pos_jitter = 10;   //  1-15 pixels position jitter 
declare hide int	numAngles = 12;
declare hide int	numEcc = 12;

/* declare float	Ecc_list[12] = {5, 8, 11, 14, 5, 8, 11, 14, 5, 8, 11, 14};	// distance of each target from center of screen individually (degrees)	declare hide float 	targ_angle;
declare float	Ang_list[12] = {0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330}; */


//move to ALLVARS.pro
	


	
	
	declare Rand_targ_angle;
	declare R1_targ_angle;
	declare R2_targ_angle;
	declare R3_targ_angle;
	declare R4_targ_angle;
	declare R5_targ_angle;
	declare R6_targ_angle;
	
	declare Rand_targ_ecc;
	declare R1_targ_ecc;
	declare R2_targ_ecc;
	declare R3_targ_ecc;
	declare R4_targ_ecc;
	declare R5_targ_ecc;
	declare R6_targ_ecc;

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

declare RandomizeRAngles();
declare RandomizeREccentricities();
declare RAND_LOC();

declare LOC_RAND();


	
process LOC_RAND
	{
	spawnwait RandomizeRAngles;
	spawnwait RandomizeREccentricities;
	spawnwait RAND_LOC;
	}


process RandomizeRAngles() 
	{
	
	int	i, j, temp;
	i = 0;
	while (i < numAngles)			//Run loop while i < total # items in locX array
		{
		j = random(numAngles) ; 			//randomly select one of six positions in X location array
		temp = Ang_list[i];			//stick one of the other locations in temp
		Ang_list[i] = Ang_list[j];
		Ang_list[j] = temp;
		i = i + 1;
		}
	}	

process RandomizeREccentricities()	
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
	}	
	

// The processes below use the shuffled arrays, and select values from those arrays to produce either trial by trial coordinates 
// in random arrays) or experiment-wide trial coordinates (for repeated arrays, selected at beginning of trial).


process RAND_LOC
	{

	spawn RandomizeRAngles;                         // Runs RandomizeXLocations
    waitforprocess RandomizeRAngles;                // Waits for it to finish
	
	spawn RandomizeREccentricities;                         // Runs RandomizeYLocations
    waitforprocess RandomizeREccentricities;                // Waits for it to finish
	
	//Random Array Angles
	Rand_targ_angle = Ang_list[0];					// Set random target/distractor locations each trial
	Rand_d1_angle = Ang_list[1];
	Rand_d2_angle = Ang_list[2];
	Rand_d3_angle = Ang_list[3];
	Rand_d4_angle = Ang_list[4];
	Rand_d5_angle = Ang_list[5];
	Rand_d6_angle = Ang_list[6];
	Rand_d7_angle = Ang_list[7];
	Rand_d8_angle = Ang_list[8];
	Rand_d9_angle = Ang_list[9];
	Rand_d10_angle = Ang_list[10];
	Rand_d11_angle = Ang_list[11];
	
	//Random Array Eccentricities
	Rand_targ_ecc = Ecc_List[0];
	Rand_d1_ecc = Ecc_List[1];
	Rand_d2_ecc = Ecc_List[2];
	Rand_d3_ecc = Ecc_List[3];
	Rand_d4_ecc = Ecc_List[4];
	Rand_d5_ecc = Ecc_List[5];
	Rand_d6_ecc = Ecc_List[6];
	Rand_d7_ecc = Ecc_List[7];
	Rand_d8_ecc = Ecc_List[8];
	Rand_d9_ecc = Ecc_List[9];
	Rand_d10_ecc = Ecc_List[10];
	Rand_d11_ecc = Ecc_List[11];
	}