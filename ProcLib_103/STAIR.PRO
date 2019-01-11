// simple 1, 2, or 3 up down staircasing algorithm
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

declare Curr_SSD;								// Global output
				
declare int	Decide_SSD = -1; 					// Global only sets at load time.
												// Why you ask? So that we can start
												// the SSDs out at the longest and 
												// discourage speeding at the start.
												// This is difficult to do becuase 
												// n_SSDs is unknown at load time.

declare STAIR(int laststopoutcome,
			int n_SSDs);
			
process STAIR(int laststopoutcome,
			int n_SSDs)
	{
	declare hide int	success		= 1;
	declare hide int	failure		= 0;
	declare hide int	plus_minus;
	
	if (decide_SSD == -1)
	{
		decide_SSD = n_SSDs;					// Sorry for weirdness.  See above.
	}
	
		
	
												// 1) figure out the random SSD step for the next trial
	plus_minus = 1 + random(3);  				// pick a number 1, 2, or 3
	
												// 2) add or subtrace SSD steps based on last trial performance.
	if (laststopoutcome == success)
		{
		decide_SSD = decide_SSD + plus_minus; 	// increase SSD to make it harder
		}
	else if (laststopoutcome == failure)
		{
		decide_SSD = decide_SSD - plus_minus; 	// decrease SSD to make it easier
		}
	
												// 3) set to limits if we went out of bounds
	if (decide_SSD > n_SSDs - 1)
		{
		decide_SSD = n_SSDs - 1;
		}
	if (decide_SSD < 0)
		{
		decide_SSD = 0;
		}
		
												// 4) select SSD using new index
	Curr_SSD = SSD_list[decide_SSD];			// GLOBAL ARRAY CANNOT BE PASSED
	
	// Override for testing use random regardless
	printf("*****WARNING*****\n");
	printf("*****STAIR.PRO*****\n");
	printf("*****Using random 2:60 refreshes************* \n");
	//Curr_SSD = SSD_list[random(n_SSDs)];
	Curr_SSD = 2;
	
	
	}