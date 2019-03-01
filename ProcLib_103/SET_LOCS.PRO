declare SET_LOCS();

process SET_LOCS()
{
	declare hide int ia;
	declare hide int angDiff;
	//declare hide int targInd;
	declare hide int ie;
	declare hide int sumProbs;
	declare hide int lastVal;
	declare hide int thisVal;
	declare hide int cumEProbs[8];
	declare hide int SearchInd;
	declare hide int break;
	declare hide int randVal;
	// eventCodes     put that word in files where I drop event codes for pro/anti so it's searchable
	
	ie = 0;
	sumProbs = 0;
	while (ie < nEccs)
	{
		sumProbs = sumProbs+eccProbs[ie];
		ie = ie+1;
	}
	nexttick;
	
	//turn relative probabilities into CDF*100
	ie = 0;
	lastVal = 0;
	thisVal = 0;
	while (ie < nEccs)
	{
		thisVal = eccProbs[ie]*100;
		cumEProbs[ie] = (thisVal/sumProbs)+lastVal;
		lastVal = cumEProbs[ie];
		ie = ie+1;
	}
	nexttick;
	
	// Select random value
	randVal = random(100);
	SearchInd = 0;
	break = 0;
	while (randVal >= cumEProbs[SearchInd] && break == 0)
	{
		SearchInd = SearchInd+1;
		if (SearchInd == nEccs)
		{
			SearchInd = nEccs-1;
			break = 1;
		}
	}
	SearchEcc = eccList[SearchInd];
	
	// First, check that the set size hasn't changed
	if (SetSize > 2)
	{
		angDiff = 360/SetSize;
		ia = 0;
		while (ia < SetSize)
		{
			if (angleOffset < 0)
			{
				angleOffset = angDiff + angleOffset;
			}
			Angle_list[ia] = (90+angleOffset+(angDiff*ia)) % 360;
			Eccentricity_list[ia] = SearchEcc;
			
			//Event_fifo[Set_event] = 5000 + Angle_list[ia];		// Set a strobe to identify this file as a Search session and...	
			//Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
			
			
			ia = ia+1;
		}
	} else
	{
		ia = random(360);
		Angle_list[0] = (90 + ia) % 360;
		Angle_list[1] = (Angle_list[0] + 180) % 360;
		//printf("In SET_LOCS Angle_list[1] = %d, [2] = %d\n",Angle_list[1],Angle_list[2]);
	}
	
	Event_fifo[Set_event] = 900 + SearchEcc;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	Event_fifo[Set_event] = 300 + angleOffset;		// Set a strobe to identify this file as a Search session and...	
	Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
	
	nexttick;	
}