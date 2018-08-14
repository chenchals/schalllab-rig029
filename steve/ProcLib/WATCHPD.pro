// 2018-08-06 Base code by Kaleb
// 2018-08-06 Chenchal - Changed the following:
//            1. Trigger only of pdIsOn is zero and pdVal crosses pdThresh
//            2. Reset pdIsOn to Zero only when
//               (a) pdIsOn is 1 and
//               (b) pdVal is below pdThresh and
//               (c) timeElapsed from lastTriggerOn is > nextRefreshIn
//                   where nextRefreshIn is set to 16 ms assuming monitor
//                   refresh to be 60Hz monitor
//            3. WAIT for nexttick before continuing while(1) loop
//
declare WATCHPD(int PhotoD_channel);

process WATCHPD(int PhotoD_channel)
{

	declare int lastTriggerOn;
	declare int ip;
	declare int pdCount;
	declare float pdSum;

	// next screen refresh approx. in ms
	// should be floor(1000/refreshRateInHz)
  // declare int nextRefreshIn = Int(floor(1000.0/Refresh_rate));
  declare int nextRefreshIn = 1;

	while (1)
	{
		pdVect[pdCount] = atable(PhotoD_channel);
		pdCount = (pdCount+1) % pdN;

		pdSum = 0;
		ip = 0;
		while (ip < pdN)
		{
			pdSum = pdSum + pdVect[ip];
			ip = ip + 1;
		}

		pdVal = pdSum/pdN;
    //set pdTrigger flag
    //printf("%-4d, %-4d, %-4d, pdSum=%-4d, pdN=%d, ip=%d, pdIsOn=%d \n ", pdVect[0], pdVect[1], pdVect[2], pdSum, pdN, ip, pdIsOn);

		if ((pdIsOn == 0) && (pdVal > pdThresh))
		{
			pdIsOn = 1;
			lastTriggerOn = time();
	
			Event_fifo[Set_event] = PDtrigger_;
			Set_event = (Set_event + 1) % Event_fifo_N;
		}
		// Unset pdTrigger flag
		else if ((pdIsOn == 1) && (pdVal < pdThresh) && ((time() - lastTriggerOn) > nextRefreshIn))
		{
			pdIsOn = 0;
		}
		printf("pdIsOn = %d \n", pdIsOn);
		printf("lastTriggerOn = %d \n", lastTriggerOn);

		nexttick;
	}
}