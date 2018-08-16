////radnomly select run length
numtrials = random(8);


////list of possible run lengths (to be selected using number chosen above, numtrials
Run_Lgth_DP[8] = {1, 2, 3, 4, 5, 6, 7, 8};
Run_Lgth_DA[8] = {1, 2, 3, 4, 5, 6, 7, 8};


////set up loop that tracks number of presentation of distractor color ( or lack of in dist absent trials)
process DP_Runs() 
	{
	
	int	i;
	i = 0;
	while (i < Run_Lgth_DP[numtrials])			//Run loop while i < total # items in run
		{
		d7color = 250; 			//distractor color
		i = i + 1;
		}
	}	


process DA_Runs() 
	{
	
	int	i;
	i = 0;
	while (i < Run_Lgth_DA[numtrials])			//Run loop while i < total # items in run
		{
		d7color = 250; 			//distractor color
		}
	}
	
////spawn one of the loops above, depnding on whether its a distractor present or absent run - may require setting DP on a per 'run' timescale rather than a per trial, by puttting, e.g., everything after schtrial within the above loop
if DistPres = 1; //Present
	spawn DP_Runs
elseif DistPres = 2;
	spawn DA_Runs
	