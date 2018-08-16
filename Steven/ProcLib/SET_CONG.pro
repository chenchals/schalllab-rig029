
#include C:/TEMPO/ProcLib/CHECK_PA.pro


declare SET_CONG();

process SET_CONG()
{
	/*//declare hide int randVal;
	//declare hide float cumProbs[ntDifficulties];
	//declare hide int it;
	//declare hide float equalTol = .001;
	//declare hide int lastVal;
	//declare hide int sumProbs;
	
	// Refresh angles/eccentricities
	spawnwait SET_LOCS();
	nexttick;
	
	// Commented section that was here has been spliced into SETA_TRL and ANTI_PGS
	
	
	// Refresh angles/eccentricities
	spawnwait SET_LOCS();
	nexttick;
	
	targInd = random(SetSize);
	targ_angle = Angle_list[targInd];
	targ_ecc = Eccentricity_list[targInd];
	*/
	//oppDiff = random(ndDifficulties);
	
	///////////////////////////////////////
	///////////////////////////////////////
	
	declare hide int it;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int randVal;
	declare float 		equalTol = .01;
	//declare hide int isCong;
	declare hide int nRel;
	declare hide int sumProbs;
	declare hide int sumCong;
	declare hide int myInd;
	declare hide int break;
	declare hide float cumCong[3];
	declare hide float  cumDProbs[ndDifficulties];
	declare hide int relInds[ndDifficulties];
	declare hide int relProbs[ndDifficulties];
	
	if (doCongruency)
	{
		spawnwait CHECK_PA();

		

		// First we should check if we want a congruent or incongruent distractor
		// Shoot... this requires a more involved loop for flexibility than intended... 
		//    but I suppose it's necessary
		// Get sum of relevant relative probabilities
		it = 0;
		sumCong = 0;
		while (it < 3) // I don't like that this is hard coded... but I suppose cong/incong/square are all we need?
		{
			//printf("congProb[%d] = %d\n",it,congProb[it]);
			sumCong = sumCong+congProb[it];
			it = it+1;
		}
		nexttick;
		//printf("sumCong = %d",sumCong);
		//printf("\n");
		
		// Turn relative probabilities of t difficulties into CDF*100
		it = 0;
		lastVal = 0; // Counter for CDF
		thisVal = 0;
		while (it < 3)
		{
			thisVal = congProb[it]*100;
			cumCong[it] = (thisVal/sumCong)+lastVal; // Add this percentage*100
			lastVal = cumCong[it]; // CDF so far = lastVal
			//printf("thisVal = %d\n",thisVal);
			//printf("cumCong[it] = %d",cumCong[it]);
			//printf("\n");
			it = it+1;
			
		}
		nexttick;

		// Select random value between 1 and 100 (0-99, really)
		randVal = random(100);
		isCong = 0;
		//printf("randVal = %d\n",randVal);
		
		// If our random value is past the range of the "singDifficulty"th CDF value, check the next one
		// Thought... should the below be >= or just >? I put >= because if there
		// are two alternatives, and should have 0/1 relative probabilities (i.e.,
		// exclusively use alternative 2), then if randVal = 0 then the first option
		// will be spuriously selected...
		break = 0;
		while (randVal > cumCong[isCong] && break == 0)
		{
			//printf("cumCong[%d] = %d",isCong,cumCong[isCong]);
			isCong = isCong+1;
			if (isCong == 3)
			{
				isCong = 2;
				break = 1;
			}
		}
		//printf("cumCong[%d] = %d",isCong,cumCong[isCong]);
		//printf("isCong = %d",isCong);
		//printf("\n");
		
		nexttick;
		//isCong = random(3); // This line would be if we're randomly picking congruency

		// OK, so we've picked our congruency. Now, we should go ahead and assign the "difficulty" if 
		//    the anti- distractor should be square
		if (isCong==2)
		{
			oppDiff = catchDistDiff; // Will be changed if we add catch as a "difficulty" level... commented out below
			
		} else if (isCong == 1) // If incongruent...
		{
			// We need to do this differently depending on whether target is pro or anti
			// If the target is pro, incongruent is also pro
			nRel = 0;
			//printf("reached congruency = 1\n");
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
				thisVal = 0;
				while (it < nRel)
				{
					thisVal = distDiffProbs[relInds[it]]*100;
					cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
					lastVal = cumDProbs[it]; // CDF so far = lastVal
					it = it+1;
				}
				nexttick;
				// Do we need to pick it here? Or can we save operations (potentially)
				//    and put that part outside this loop?
			} else if (tIsAnti[singDifficulty]) // if target is anti, pick an anti distractor
			{
				//printf("reached tIsAnti section\n");
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
					nexttick;
				}
				nexttick;
				
				//printf("relInds calculated\n");
				// Get CDF
				it = 0;
				sumProbs = 0;
				while (it < nRel)
				{
					sumProbs = sumProbs + distDiffProbs[relInds[it]];
					it = it+1;
					nexttick;
				}
				
				//printf("Got PDF\n");
				// Turn relative relevant probs into CDF
				it = 0;
				lastVal = 0;
				thisVal = 0;
				while (it < nRel)
				{
					thisVal = distDiffProbs[relInds[it]]*100;
					cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
					lastVal = cumDProbs[it]; // CDF so far = lastVal
					it = it+1;
					nexttick;
				}
				//printf("Got CDF\n");
				nexttick;
				// Do we need to pick it here? Or can we save operations (potentially)
				//    and put that part outside this loop?
			} else if (tIsCatch[singDifficulty]) // if target is square, pick a pro or anti distractor based on relative probs in catchDiffPerc
			{
				// We need RelInds below in order to keep it out of this particular
				//     loop, but we can just say that all distractor possibilities are relevant
				it = 0;
				nRel = 0;
				while (it < ndDifficulties)
				{
					relInds[nRel] = it;
					relProbs[nRel] = distDiffProbs[it];
					nRel = nRel+1;
					it = it+1;
				}
				nexttick;
				
				// Let's do the boilerplate CDF thing here, but on catchDiffPerc
				it = 0;
				sumProbs = 0;
				while (it < nRel)
				{
					sumProbs = sumProbs+catchDiffPerc[relInds[it]];
					it = it+1;
				}
				//printf("sumProbs = %d",sumProbs);
				//printf("\n");
				nexttick;
				
				// Turn relative probabilities of t difficulties into CDF*100
				it = 0;
				lastVal = 0; // Counter for CDF
				thisVal = 0;
				while (it < nRel)
				{
					thisVal = catchDiffPerc[relInds[it]]*100;
					cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
					lastVal = cumDProbs[it]; // CDF so far = lastVal
					it = it+1;
					//printf("cumDProbs[%d] = %d",it,cumDProbs[it]);
					//printf("\n");
				}
				nexttick;
			}
			
			// Cool. Now that we've gotten the relevant indices for either pro or anti trials,
			//    let's randomly select one of them
			randVal = random(100);
			myInd = 0;
			while (randVal > cumDProbs[myInd])
			{
				myInd = myInd+1;
			}
			nexttick;
		// We've now picked the appropriate index INTO THE RELEVANT INDICES. So let's assign the Distractor ID
			oppDiff = relInds[myInd];
			//printf("oppDiff = %d",oppDiff);
			//printf("\n");
			nexttick;
			
		} else if (isCong == 0) // If congruent...
		{
			// We need to do this differently depending on whether target is pro or anti
			// If the target is pro, incongruent is also pro
			nRel = 0;
			if (tIsPro[singDifficulty]) // if target is pro, pick an anti distractor
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
				//printf("nRel = %d, ",nRel);
				//printf("firstRel = %d",relInds[0]);
				//printf("\n");
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
				thisVal = 0;
				while (it < nRel)
				{
					thisVal = distDiffProbs[relInds[it]]*100;
					cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
					lastVal = cumDProbs[it]; // CDF so far = lastVal
					it = it+1;
				}
				nexttick;
				// Do we need to pick it here? Or can we save operations (potentially)
				//    and put that part outside this loop?
			} else if (tIsAnti[singDifficulty]) // if target is anti, pick a pro distractor
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
				thisVal = 0;
				while (it < nRel)
				{
					thisVal = distDiffProbs[relInds[it]]*100;
					cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
					lastVal = cumDProbs[it]; // CDF so far = lastVal
					it = it+1;
				}
				nexttick;
				// Do we need to pick it here? Or can we save operations (potentially)
				//    and put that part outside this loop?
			} else if (tIsCatch[singDifficulty]) // if target is square, pick a pro or anti distractor based on relative probs in catchDiffPerc
			{
				// We need RelInds below in order to keep it out of this particular
				//     loop, but we can just say that all distractor possibilities are relevant
				it = 0;
				nRel = 0;
				while (it < ndDifficulties)
				{
					relInds[nRel] = it;
					relProbs[nRel] = distDiffProbs[it];
					nRel = nRel+1;
					it = it+1;
				}
				nexttick;
				
				// Let's do the boilerplate CDF thing here, but on catchDiffPerc
				it = 0;
				sumProbs = 0;
				while (it < nRel)
				{
					sumProbs = sumProbs+catchDiffPerc[relInds[it]];
					it = it+1;
				}
				//printf("sumProbs = %d",sumProbs);
				//printf("\n");
				nexttick;
				
				// Turn relative probabilities of t difficulties into CDF*100
				it = 0;
				lastVal = 0; // Counter for CDF
				thisVal = 0;
				while (it < nRel)
				{
					thisVal = catchDiffPerc[relInds[it]]*100;
					cumDProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
					lastVal = cumDProbs[it]; // CDF so far = lastVal
					it = it+1;
					//printf("cumDProbs[%d] = %d",it,cumDProbs[it]);
					//printf("\n");
				}
				nexttick;
			}
			
			// Cool. Now that we've gotten the relevant indices for either pro or anti trials,
			//    let's randomly select one of them
			randVal = random(100);
			myInd = 0;
			break = 0;
			while (randVal > cumDProbs[myInd] && break == 0)
			{
				myInd = myInd+1;
				if (myInd == ndDifficulties)
				{
					myInd = ndDifficulties;
					break = 1;
				}
			}
		
		// We've now picked the appropriate index INTO THE RELEVANT INDICES. So let's assign the Distractor ID
			oppDiff = relInds[myInd];
			//printf("oppDiff = %d",oppDiff);
			//printf("\n");
			nexttick;
		}
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
		oppDiff= 0;
		// If our random value is past the range of the "singDifficulty"th CDF value, check the next one
		// Thought... should the below be >= or just >? I put >= because if there
		// are two alternatives, and should have 0/1 relative probabilities (i.e.,
		// exclusively use alternative 2), then if randVal = 0 then the first option
		// will be spuriously selected...
		while (randVal > cumDProbs[oppDiff])
		{
			oppDiff = oppDiff+1;
		}
		//printf("t diff = %d",distDifficulty[id]);
		//printf("\n");
	}
	//oppDiff = random(ndDifficulties);
	
}
	

