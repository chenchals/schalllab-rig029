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

//#include C:/TEMPO/ProcLib/SEND_EVT.pro

declare WATCHPD(int PhotoD_channel);

process WATCHPD(int PhotoD_channel)
{


	declare int maxPdVal = -900;
  declare int nextRefreshIn;

	while (1)
	{
		nextRefreshIn = Int(floor(1000.0/Refresh_rate));
		pdVal = atable(PhotoD_channel);
        writef("PDVals.csv %d,", pdVal);
		if (pdVal > maxPdVal)
		{
			maxPdVal = pdVal;
		}

		if ((pdIsOn == 0) && (pdVal > pdThresh))
		{
			pdIsOn = 1;
			pdTriggerTime = time();
			spawn SEND_EVT(PDTrigger_);
			writef("PDVals.csv %d\n", pdTriggerTime);
		}
		// Unset pdTrigger flag
		if ((pdIsOn == 1) && ((time() - pdTriggerTime) > nextRefreshIn))
		{
			pdIsOn = 0;
			maxPdVal = -900;
		}
		nexttick;
	}
}
