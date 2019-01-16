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

#include C:/TEMPO/ProcLib/SEND_EVT.pro

declare WATCHPD(int PhotoD_channel);

process WATCHPD(int PhotoD_channel)
{

	declare int lastTriggerOn;
	declare int ip;
	declare int pdCount;
	declare float pdSum;
	declare int maxPdVal = -900;
  declare int nextRefreshIn;

	while (1)
	{
		declare int pd1 = 0
		nextRefreshIn = Int(floor(1000.0/Refresh_rate)) + 1;
		pdVal = atable(PhotoD_channel);

		if (pdVal > maxPdVal)
		{
			maxPdVal = pdVal;
		}

		if ((pdIsOn == 0) && (pdVal > pdThresh))
		{
			pdIsOn = 1;
			lastTriggerOn = time();
      spawn SEND_EVT(PDTrigger_);
			//printf("maxPdVal = %d, pdVal = %d, pdThresh = %d\n", maxPdVal, pdVal, pdThresh);
		}
		// Unset pdTrigger flag
		if ((pdIsOn == 1) && (pdVal < pdThresh) && ((time() - lastTriggerOn) > nextRefreshIn))
		{
			pdIsOn = 0;
			maxPdVal = -900;
		}
		writef("watchpd.log %d,%d,%d\n",pdVect[0],pdVect[1],pdVect[2]);
		nexttick;
	}
}