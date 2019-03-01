// This code sets the difficulty levels for the singleton and non-singletons for Pro/Anti

declare A_DIFFS();

process A_DIFFS()
{
	
	declare hide int 	distDifficulty[12];
	declare hide int 	distCode;
	declare hide int 	randVal;
	declare hide float 	cumDProbs[ndDifficulties];
	declare hide float 	cumTProbs[ndDifficulties];
	declare hide int 	it;
	declare hide int 	ic;
	declare hide int 	lastVal;
	declare hide int 	sumProbs;
	declare hide int 	sumCong;
	declare hide int 	cumCong[ndDifficulties];
	declare hide int 	isCong;
	declare hide int 	nRel;
	declare hide int 	relInds[ndDifficulties];
	declare hide int 	relProbs[ndDifficulties];
	declare hide int 	myInd;
	declare float 		equalTol = .01;
	
	// First, let's see which Ts or Ds imply pro or anti
	// Let's check which singleton difficulties imply pro vs anti
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
		/*
		// This if statement should work because it's in an else... a negative value < -equaltol
		// should have been caught by the first if
		else if (((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) < equalTol) || ((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) < equalTol))
			{
			//tIsPro[it] = 0;
			//tIsAnti[it] = 0;
			tIsCatch[it] = 1;
			}
		*/
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
		/*
		// This if statement should work because it's in an else... a negative value < -equaltol
		// should have been caught by the first if
		else if (((distH[singDifficulty] - distV[singDifficulty]) < equalTol) || ((distV[singDifficulty] - distH[singDifficulty]) < equalTol))
			{
			//dIsPro[it] = 0;
			//dIsAnti[it] = 0;
			dIsCatch[it] = 1;
			}
		*/
		it = it+1;
	}
	nexttick;
	
	
	// Let's start with the target
	
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
	while (it < ntDifficulties)
	{
		cumTProbs[it] = (targDiffProbs[it]/sumProbs)*100+lastVal; // Add this percentage*100
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
	
	
	
	
	
	// Now for distractors
	id = 0;
	while (id < SetSize)
	{
		//if (isCatch)
		//{
		//	distDifficulty[id] = catchDifficulty;
		//} else
		//{
		//	distDifficulty[id] = random(ndDifficulties); // This line commented back out because we want to also probabilistically assign distDifficulty
		//}
		
		// OK, let's think about this. We don't want to do too many processes,
		// but we also don't want to drop irrelevant distractor codes. Where does
		// an "if" regarding congruency want to live? And how do we do it while declaring
		// the fewest number of variables? I suppose the relevant variables will be
		// sumProbs and cumDProbs... a long version could declare "relInds" and "relProbs"?
		
		if ((id == ((targInd + (SetSize/2)) % SetSize)) && (tIsCatch[targInd] == 0)) // If we're discussing the anti- location...
		// the above if statement also passes the below section if the singleton is a catch (no move)
		//    that is, if the singleton is a no-move, don't bother with congruency of the anti-distractor
		{
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
				distDifficulty[id] = catchDistDiff; // Will be changed if we add catch as a "difficulty" level... commented out below
				
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
				distDifficulty[id] = relInds[id];
			}
			else if (isCong == 0) // If congruent...
			{
				// We need to do this differently depending on whether target is pro or anti
				// If the target is pro, incongruent is also pro
				nRel = 0;
				if (tIsPro[targInd]) // if target is pro, pick an anti distractor
				{
					it = 0;
					while (it < ndDifficulties)
					{
						if (dIsAnti[it]) // Only pick pro-distractors
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
				else if (tIsAnti[targInd]) // if target is anti, pick a pro distractor
				{
					it = 0;
					while (it < ndDifficulties)
					{
						if (dIsPro[it]) // Only pick anti-distractors
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
				distDifficulty[id] = relInds[id];
			}
			nexttick;
					
		}			
		else // if the distractor in question is not opposite the singleton, don't bother with congruency
		{
			// Get sum of relevant relative probabilities
			it = 0;
			sumProbs = 0;
			while (it < ndDifficulties)
			{
				sumProbs = sumProbs+distDiffProbs[it];
				it = it+1;
			}
			
			// Turn relative probabilities of t difficulties into CDF*100
			it = 0;
			lastVal = 0; // Counter for CDF
			while (it < ndDifficulties)
			{
				cumDProbs[it] = (distDiffProbs[it]/sumProbs)*100+lastVal; // Add this percentage*100
				lastVal = cumDProbs[it]; // CDF so far = lastVal
				it = it+1;
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
			// Loop should have broken when randVal is in the range of values assigned to a particular
			// CDF/difficulty level. When it breaks, get the appropriate difficulty level		
			
		}
		id = id+1;
	}
}