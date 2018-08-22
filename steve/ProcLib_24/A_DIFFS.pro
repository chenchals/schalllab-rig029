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
	//declare hide int isCong;
	declare hide int sumCong;
	declare hide float cumCong[3];
	declare hide int break;
	
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
		//printf("it = %d, ",it);
		cumTProbs[it] = (thisVal/sumProbs)+lastVal; // Add this percentage*100
		lastVal = cumTProbs[it]; // CDF so far = lastVal
		//printf("cumTProbs[it] = %d\n",cumTProbs[it]);
		it = it+1;
		
	}
	nexttick;
	
	// Select random value between 1 and 100 (0-99, really)
	randVal = random(100);
	singDifficulty = 0;
	// If our random value is past the range of the "singDifficulty"th CDF value, check the next one
	// Thought... should the below be >= or just >? I put >= because if there
	// are two alternatives, and should have 0/1 relative probabilities (i.e.,
	// exclusively use alternative 2), then if randVal = 0 then the first option
	// will be spuriously selected...
	/*if (randVal > 49)
	{
		randVal = 100;
	} else 
	{
		randVal = 0;
	}
	*/
	break = 0;
	while (randVal >= cumTProbs[singDifficulty] && break == 0)
	{
		singDifficulty = singDifficulty+1;
		if (singDifficulty == ntDifficulties)
		{
			singDifficulty = ntDifficulties-1;
			break = 1;
		}
	}
	/*if (singDifficulty > ntDifficulties)
	{
		singDifficulty = ntDifficulties;
	}
	*/
	// Loop should have broken when randVal is in the range of values assigned to a particular
	// CDF/difficulty level. When it breaks, get the appropriate pro/anti mapping
	nexttick;
	//printf("randVal = %d, singDifficulty = %d\n",randVal,singDifficulty);
	
	// Send target location code       eventCode
	//Event_fifo[Set_event] = 6000 + (100*targInd) + singDifficulty;		// Set a strobe to identify this file as a Search session and...	
	//Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	
	if (SearchType == 2)
	{
		spawnwait SET_CONG();
		nexttick;
		//printf("oppDiff = %d\n",oppDiff);
		if ((distV[oppDiff] - distH[oppDiff]) > equalTol)
			{
			isCong = 0;
			}
		else if ((distH[oppDiff] - distV[oppDiff]) > equalTol)
			{
			isCong = 1;
			}
		// This if statement should work because it's in an else... a negative value < -equaltol
		// should have been caught by the first if
		else if (((distH[oppDiff] - distV[oppDiff]) < equalTol) || ((distV[oppDiff] - distH[oppDiff]) < equalTol))
			{
			isCong = 2;
			}
		nexttick;
		id = 0;
		while (id < SetSize)
		{
			if (id == targInd)
			{
				distDifficulty[id] = singDifficulty;
			} else
			{
				distDifficulty[id] = oppDiff;
			}
			id = id+1;
		}
	} else
	{
		spawnwait SET_CONG();
		nexttick;
		if ((distV[oppDiff] - distH[oppDiff]) > equalTol)
			{
			isCong = 0;
			}
		else if ((distH[oppDiff] - distV[oppDiff]) > equalTol)
			{
			isCong = 1;
			}
		// This if statement should work because it's in an else... a negative value < -equaltol
		// should have been caught by the first if
		else if (((distH[oppDiff] - distV[oppDiff]) < equalTol) || ((distV[oppDiff] - distH[oppDiff]) < equalTol))
			{
			isCong = 2;
			}
		//printf("in A_DIFFS - oppDiff = %d",oppDiff);
		nexttick;
		id = 0;
		while (id < SetSize)
		{
			// The below attempts to add probabilistic stuff for target
			// Get sum of relevant relative probabilities
			
			// Now let's add the if statement for congruency
			if (id == ((targInd + (SetSize/2)) % SetSize))
			{
				//printf("targInd = %d, Angle = %d",targInd,Angle_list[targInd]);
				//printf("opposite = %d, Angle = %d",id,Angle_list[id]);
				//printf("\n");
				// Start out by just making the opposite stimulus random...
				// Really here we're just testing the if/else
				//distDifficulty[id] = random(ndDifficulties);
				//spawnwait SET_CONG();
				distDifficulty[id] = oppDiff;
				//printf("t diff = %d",distDifficulty[id]);
				//printf("\n");
			} else if (id == targInd)
			{
				distDifficulty[id] = singDifficulty; // This makes decoding easier if we make the distractor in the singleton location (which won't be shown) the same as the singleton
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
				// If our random value is past the range of the "singDifficulty"th CDF value, check the next one
				// Thought... should the below be >= or just >? I put >= because if there
				// are two alternatives, and should have 0/1 relative probabilities (i.e.,
				// exclusively use alternative 2), then if randVal = 0 then the first option
				// will be spuriously selected...
				break = 0;
				while (randVal >= cumDProbs[distDifficulty[id]] && break == 0)
				{
					distDifficulty[id] = distDifficulty[id]+1;
					if (distDifficulty[id] == ndDifficulties)
					{
						distDifficulty[id] = ndDifficulties-1;
						break = 1;
					}
				}
				
			}
			// Send distractor location and difficulty code       eventCode
			//Event_fifo[Set_event] = 6000 + (100*id) + distDifficulty[id];		// Set a strobe to identify this file as a Search session and...	
			//Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
			nexttick;
			
			id = id+1;
		}
	}
}