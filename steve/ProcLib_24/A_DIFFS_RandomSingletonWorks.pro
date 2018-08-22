// This code sets the difficulty levels for the singleton and non-singletons for Pro/Anti

declare A_DIFFS();

process A_DIFFS()
{
	declare hide int id;
	declare hide int it;
	declare hide int sumProbs;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int randVal;
	declare hide float 	cumTProbs[ntDifficulties];
	
	//singDifficulty = random(ntDifficulties); This line works but picks random
	// The below attempts to add probabilistic stuff for target
	// Get sum of relevant relative probabilities
	it = 0;
	sumProbs = 0;
	while (it < ntDifficulties)
	{
		sumProbs = sumProbs+targDiffProbs[it];
		it = it+1;
	}
	printf("sumProbs = %d",sumProbs);
	printf("\n");
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
		printf("cumTProbs[%d] = %d",it,cumTProbs[it]);
		printf("\n");
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
	printf("t diff = %d",singDifficulty);
	printf("\n");
	
	// Loop should have broken when randVal is in the range of values assigned to a particular
	// CDF/difficulty level. When it breaks, get the appropriate pro/anti mapping
	
	id = 0;
	while (id < SetSize)
	{
		distDifficulty[id] = random(ndDifficulties);
		id = id+1;
	}
}