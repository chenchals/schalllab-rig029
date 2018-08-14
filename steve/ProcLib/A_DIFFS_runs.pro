// This code sets the difficulty levels for the singleton and non-singletons for Pro/Anti
#include C:/TEMPO/ProcLib/SET_CONG.pro
	
declare A_DIFFS();

process A_DIFFS()
{
	//#include C:/TEMPO/ProcLib/DRW_V.pro
	//#include C:/TEMPO/ProcLib/DRW_CONG.pro
	//#include C:/TEMPO/ProcLib/TST_FUN.pro
	
	declare hide int id;
	declare hide int it;
	declare hide int ic;
	declare hide int sumProbs;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int randVal;
	declare hide float 	cumTProbs[ntDifficulties];
	declare hide float  cumDProbs[ndDifficulties];
	declare float 		equalTol = .01;
	declare hide int isCong;
	declare hide int sumCong;
	declare hide float cumCong[3];
	
	
	// The below attempts to add probabilistic stuff for target
	// Get sum of relevant relative probabilities
	it = 0;
	sumProbs = 0;
	while (it < ntDifficulties)
	{
		sumProbs = sumProbs+targDiffProbs[it];
		it = it+1;
	}
	nexttick;
	
	// Turn relative probabilities of t difficulties into CDF*100
	it = 0;
	lastVal = 0; // Counter for CDF
	thisVal = 0;
	while (it < ntDifficulties)
	{
		thisVal = targDiffProbs[it]*100;
		cumTProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
		lastVal = cumTProbs[it]; // CDF so far = lastVal
		it = it+1;
	}
	nexttick;
	
	// Select random value between 1 and 100 (0-99, really)
	randVal = random(100);
	singDifficulty = 0;
	// If our random value is past the range of the "targInd"th CDF value, check the next one
	// Thought... should the below be >= or just >? I put >= because if there
	// are two alternatives, and should have 0/1 relative probabilities (i.e.,
	// exclusively use alternative 2), then if randVal = 0 then the first option
	// will be spuriously selected...
	while (randVal > cumTProbs[singDifficulty])
	{
		singDifficulty = singDifficulty+1;
	}
	// Loop should have broken when randVal is in the range of values assigned to a particular
	// CDF/difficulty level. When it breaks, get the appropriate pro/anti mapping
	nexttick;
	
	if (SearchType == 2)
	{
		spawnwait SET_CONG();
		id = 0;
		while (id < 
			
	id = 0;
	while (id < SetSize)
	{
		// The below attempts to add probabilistic stuff for target
		// Get sum of relevant relative probabilities
		
		// Now let's add the if statement for congruency
		if ((id == ((targInd + (SetSize/2)) % SetSize)) && tIsCatch[targInd] == 0)
		{
			// Start out by just making the opposite stimulus random...
			// Really here we're just testing the if/else
			//distDifficulty[id] = random(ndDifficulties);
			spawnwait SET_CONG();
			distDifficulty[id] = oppDiff;
			
			// Ok, cool, that worked. Now let's select congruency
			// Get sum of relevant relative probabilities
			//ic = 0;
			//sumCong = 0;
			//while (ic < 3) // I don't like that this is hard coded... but I suppose cong/incong/square are all we need?
			//{
				//sumCong = sumCong+congProb[ic];
				//ic = ic+1;
				//nexttick;
			//}
			//nexttick;
			
			/*
			// Turn relative probabilities of t difficulties into CDF*100
			it = 0;
			lastVal = 0; // Counter for CDF
			thisVal = 0;
			while (ic < 3)
			{
				thisVal = congProb[ic]*100;
				cumCong[ic] = (thisVal/sumCong)+lastVal; // Add this percentage*100
				lastVal = congProb[ic]; // CDF so far = lastVal
				ic = ic+1;
			}
			nexttick;
			
			// Select random value between 1 and 100 (0-99, really)
			randVal = random(100);
			isCong = 0;
			// If our random value is past the range of the "targInd"th CDF value, check the next one
			// Thought... should the below be >= or just >? I put >= because if there
			// are two alternatives, and should have 0/1 relative probabilities (i.e.,
			// exclusively use alternative 2), then if randVal = 0 then the first option
			// will be spuriously selected...
			while (randVal > cumCong[isCong])
			{
				isCong = isCong+1;
			}
			*/
			//nexttick;
			
		} else
		{
			it = 0;
			sumProbs = 0;
			while (it < ndDifficulties)
			{
				sumProbs = sumProbs+distDiffProbs[it];
				it = it+1;
			}
			//printf("sumProbs = %d",sumProbs);
			//printf("\n");
			nexttick;
			
			// Turn relative probabilities of t difficulties into CDF*100
			it = 0;
			lastVal = 0; // Counter for CDF
			thisVal = 0;
			while (it < ndDifficulties)
			{
				thisVal = distDiffProbs[it]*100;
				cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
				lastVal = cumDProbs[it]; // CDF so far = lastVal
				it = it+1;
				//printf("cumDProbs[%d] = %d",it,cumDProbs[it]);
				//printf("\n");
			}
			nexttick;
			
			// Select random value between 1 and 100 (0-99, really)
			randVal = random(100);
			distDifficulty[id] = 0;
			// If our random value is past the range of the "targInd"th CDF value, check the next one
			// Thought... should the below be >= or just >? I put >= because if there
			// are two alternatives, and should have 0/1 relative probabilities (i.e.,
			// exclusively use alternative 2), then if randVal = 0 then the first option
			// will be spuriously selected...
			while (randVal > cumDProbs[distDifficulty[id]])
			{
				distDifficulty[id] = distDifficulty[id]+1;
			}
			//printf("t diff = %d",distDifficulty[id]);
			//printf("\n");
		}
			
		
		
		id = id+1;
	}
}