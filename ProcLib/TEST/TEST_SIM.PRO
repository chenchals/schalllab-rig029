//==========================================================================
// TEST_SSD.PRO
//   Description: Run a countermanding SSD test by showing sequence of related pages
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2018-09-06
//==========================================================================
//  Revision History:
//
//==========================================================================

// DECLARE PROCESS
//==========================================================================
// Use variables on the fly - no declaration
#pragma declare = 1
declare SETUP_SCRN_CLRS_PGS();
declare SETUP_DATA_ACQ_PARMS();
declare ESTMT_MS_PER_TICK();
declare WTCH_PD_SCHMITT();
declare WTCH_EYE();

declare TEST_SIM();

declare float FIX_SIZE = 0.5;
declare int PD_TRIG_L = 0;
declare int PD_TRIG_R = 0;
declare int VERT_RFRSH_COUNT = 0;
declare int VERT_RFRSH_SSD = 0;
declare int TRL_NUM = 0;

// Room variables
#include C:/TEMPO/ProcLib/TEST/ROOM_029.PRO
// Screen parameters including isoluminant colors,
#include C:/TEMPO/ProcLib/TEST/SET_SCRN.PRO
// Set palatte colors for countermanding
#include C:/TEMPO/ProcLib/TEST/CMD_CLRS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/TEST/CMD_PGS.PRO
// GLOBAL variables for color:
//==========================================================================

// Run as default
process TEST_SSD() enabled
{
   declare int maxTrialCount = 10000;
   declare int maxSsdRefresh = 30;
   declare int startTime = 0;
   declare int stopTime = 0;
   declare int ssdTime = 0;
   declare float ssdTimeExpected = 0.0;
   declare int trlRunning = 1;
   declare int ticks = 0;
   printf("Running TEST_SSD\n");
   spawnwait SETUP_SCRN_CLRS_PGS();
   spawnwait SETUP_DATA_ACQ_PARMS();
   spawn WTCH_PD_SCHMITT();
   spawn WTCH_EYE();
   TRL_NUM = 0;
   
   while (trlRunning && TRL_NUM < maxTrialCount)
   {     
 	 TRL_NUM = TRL_NUM + 1;
     dsendf("vp %d\n", PAGE_BLANK);
     VERT_RFRSH_COUNT = 0;
     VERT_RFRSH_SSD = (random(maxSsdRefresh) + 1)*2;//2-60
	 ssdTimeExpected = VERT_RFRSH_SSD * REFRESH_RATE;
	 dsendf("vp %d\n", PAGE_FIX_PD);	 
     startTime = time();
	 while (trlRunning && VERT_RFRSH_COUNT < VERT_RFRSH_SSD)
	 {
	   // queue command to VideoSYNC refresh screen
	   dsendf("VW %d\n", 1);
	   VERT_RFRSH_COUNT = VERT_RFRSH_COUNT + 1;
	   stopTime = time();
	   // expire some random no. ticks before deciding broke fix state
	   while (ticks < random(100)+1)
	   {
		   ticks = ticks + 1;
		   nexttick;
	   }
       nexttick;
	 }
   	 dsendf("vp %d\n", PAGE_STOP_SIGNAL_PD);
	 while ( !PD_TRIG_R)
	 {
		nexttick;
	 }
	 stopTime = time();
	 dsendf("vp %d\n", PAGE_BLANK);
     
     ssdTime = stopTime - startTime;
     ssdTimeExpected = VERT_RFRSH_SSD * REFRESH_RATE;
	 currWaitTicks = random(20)*30 + 200;
	 // complete ISI...?
	 nexttick currWaitTicks;
	 trlRunning = 1;
	 }
}

process SETUP_SCRN_CLRS_PGS()
{
  // make sure vdosync is in correct config
  // Check in set_scrn.pro 1024 x 768
  //dsend("vi 261;");
  dsend("vi 256;");
  // flush all vdosync memory
  dsend("ca");
  wait 5000;
  // Set up pages
  spawnwait SET_SCRN();
  spawnwait SET_CLRS();
  spawnwait CMD_PGS();
  wait 5000;
}

process WTCH_PD_SCHMITT()
{
  declare float pdValL = 0;
  declare float pdValR = 0;
  declare int threshLo = 500;//both hi and lo
 
  while(1)
  {
    pdValL = atable(PHOTOCELL_L_CHANNEL);
    pdValR = atable(PHOTOCELL_R_CHANNEL);
	if (pdValL > threshLo && PD_TRIG_L == 0)
	{
	  PD_TRIG_L = 1;
	}
	else if (pdValL < threshLo && PD_TRIG_L == 1)
	{
	  PD_TRIG_L = 0;
	}
	if (pdValR > threshLo && PD_TRIG_R == 0)
	{
	  PD_TRIG_R = 1;
	}
	else if (pdValR < threshLo && PD_TRIG_R == 1)
	{
	  PD_TRIG_R = 0;
	}
	nexttick;
  }
}

process WTCH_EYE()
{
	while(1)
	{
	  BREAK_FIX_FLAG = random(2);
      nexttick;	  
	}
}

