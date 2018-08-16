// Sweep through each bit to make sure that TDT can read all bits for event codes

declare BITSWEEP();

process BITSWEEP()
{
//printf("Bitsweep entered\n");
declare hide int maxBits = 15;
declare hide int thisBit = 1;
declare hide int waitTime = 400;
declare hide int sentTime;
declare hide int thisVal;
declare hide int bitInc;
//printf("thisBit=%d\n",thisBit);
thisBit = 1;
	while (thisBit <= maxBits)
	{
		printf("thisBit=%d\n",thisBit);
		thisVal = 1;
		bitInc = 1;
		while (bitInc < thisBit)
		{
			thisVal = thisVal*2;
			bitInc = bitInc+1;
		}
		Event_fifo[Set_event] = thisVal;
		Set_event = (Set_event + 1) % Event_fifo_N;
		printf("Sending code: %d\n",(thisVal));
		sentTime = time();
		while (time() < (sentTime+waitTime))
		{
			nexttick;
		}

		thisBit = thisBit + 1;
		
	//State = 0;							// If we are out of the while loop the user wanted...
													// ...to stop Search.
		
	}
}