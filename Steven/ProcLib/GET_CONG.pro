declare GET_CONG();
process GET_CONG()
{


declare hide int ic;
declare hide int lastVal;
declare hide int thisVal;
declare hide int randVal;
declare float 		equalTol = .01;
declare hide int isCong;
declare hide int sumCong;
declare hide float cumCong[3];

// Decide which difficulties are pro or anti
it = 0;
while (it < ntDifficulties)
{
	tIsPro[it] = 0;
	tIsAnti[it] = 0;
	//tIsCatch[it] = 0;
	if ((stimVertical[it] - stimHorizontal[it]) > equalTol)
		{
		tIsPro[it] = 1;
		//tIsAnti[it] = 0;
		//tIsCatch[it] = 0;
		}
	else if ((stimHorizontal[it] - stimVertical[it]) > equalTol)
		{
		//tIsPro[it] = 0;
		tIsAnti[it] = 1;
		//tIsCatch[it] = 0;
		}
	// This if statement should work because it's in an else... a negative value < -equaltol
	// should have been caught by the first if
	else if (((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) < equalTol) || ((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) < equalTol))
		{
		//tIsPro[it] = 0;
		//tIsAnti[it] = 0;
		tIsCatch[it] = 1;
		}
	it = it+1;
	
}
nexttick;

// We need to repeat the above to assign distractor pro/anti/catch diffs
it = 0;
while (it < ndDifficulties)
{
	// We need to repeat the above to assign distractor pro/anti/catch diffs
	if ((distV[it] - distH[it]) > equalTol)
		{
		dIsPro[it] = 1;
		//dIsAnti[it] = 0;
		//dIsCatch[it] = 0;
		}
	else if ((distH[it] - distV[it]) > equalTol)
		{
		//dIsPro[it] = 0;
		dIsAnti[it] = 1;
		//dIsCatch[it] = 0;
		}
	
	// This if statement should work because it's in an else... a negative value < -equaltol
	// should have been caught by the first if
	else if (((distH[singDifficulty] - distV[singDifficulty]) < equalTol) || ((distV[singDifficulty] - distH[singDifficulty]) < equalTol))
		{
		//dIsPro[it] = 0;
		//dIsAnti[it] = 0;
		dIsCatch[it] = 1;
		}
	it = it+1;
}
nexttick;




// First we should check if we want a congruent or incongruent distractor
// Shoot... this requires a more involved loop for flexibility than intended... 
//    but I suppose it's necessary
// Get sum of relevant relative probabilities
ic = 0;
sumCong = 0;
while (ic < 3) // I don't like that this is hard coded... but I suppose cong/incong/square are all we need?
{
	sumCong = sumCong+congProb[ic];
	ic = ic+1;
}
nexttick;

// Turn relative probabilities of t difficulties into CDF*100
it = 0;
lastVal = 0; // Counter for CDF
while (it < ntDifficulties)
{
	cumCong[it] = (congProb[it]/sumCong)*100+lastVal; // Add this percentage*100
	lastVal = cumDProbs[it]; // CDF so far = lastVal
	it = it+1;
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
nexttick;
//isCong = random(3); // This line would be if we're randomly picking congruency

// OK, so we've picked our congruency. Now, we should go ahead and assign the "difficulty" if 
//    the anti- distractor should be square
if (isCong==2)
{
	oppDiff = catchDistDiff; // Will be changed if we add catch as a "difficulty" level... commented out below
	
}
else if (isCong == 1) // If incongruent...
{
	// We need to do this differently depending on whether target is pro or anti
	// If the target is pro, incongruent is also pro
	nRel = 0;
	if (tIsPro[singDifficulty]) // if target is pro, pick a pro distractor
	{
		it = 0;
		while (it < ndDifficulties)
		{
			if (dIsPro[it]) // Only pick pro-distractors
			{
				relInds[nRel] = it;
				relProbs[nRel] = distDiffProbs[it];
				nRel = nRel+1;
			}
			it = it+1;
		}
		nexttick;
		
		// Get CDF
		it = 0;
		sumProbs = 0;
		while (it < nRel)
		{
			sumProbs = sumProbs + distDiffProbs[relInds[it]];
			it = it+1;
		}
		
		// Turn relative relevant probs into CDF
		it = 0;
		lastVal = 0;
		while (it < nRel)
		{
			cumDProbs[it] = (distDiffProbs[relInds[it]]/sumProbs)*100+lastVal; // Add this percentage*100
			lastVal = cumDProbs[it]; // CDF so far = lastVal
			it = it+1;
		}
		nexttick;
		// Do we need to pick it here? Or can we save operations (potentially)
		//    and put that part outside this loop?
	}
	else if (tIsAnti[targInd]) // if target is anti, pick an anti distractor
	{
		it = 0;
		while (it < ndDifficulties)
		{
			if (dIsAnti[it]) // Only pick anti-distractors
			{
				relInds[nRel] = it;
				relProbs[nRel] = distDiffProbs[it];
				nRel = nRel+1;
			}
			it = it+1;
		}
		nexttick;
		
		// Get CDF
		it = 0;
		sumProbs = 0;
		while (it < nRel)
		{
			sumProbs = sumProbs + distDiffProbs[relInds[it]];
			it = it+1;
		}
		
		// Turn relative relevant probs into CDF
		it = 0;
		lastVal = 0;
		while (it < nRel)
		{
			cumDProbs[it] = (distDiffProbs[relInds[it]]/sumProbs)*100+lastVal; // Add this percentage*100
			lastVal = cumDProbs[it]; // CDF so far = lastVal
			it = it+1;
		}
		nexttick;
		// Do we need to pick it here? Or can we save operations (potentially)
		//    and put that part outside this loop?
	}
	
	// Cool. Now that we've gotten the relevant indices for either pro or anti trials,
	//    let's randomly select one of them
	randVal = random(100);
	myInd = 0;
	while (randVal > cumDProbs[myInd])
	{
		myInd = myInd+1;
	}
	// We've now picked the appropriate index INTO THE RELEVANT INDICES. So let's assign the Distractor ID
	oppDiff = relInds[id];
	
	
}