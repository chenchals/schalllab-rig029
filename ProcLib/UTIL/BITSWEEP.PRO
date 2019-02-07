
//==========================================================================
// BITSWEEP.PRO
//   Description: Sweep through each bit to make sure that TDT can read all bits for event codes
//   Author: kaleb lowe
//   Date: ---
//==========================================================================
//  Revision History:
//  002: 2019/01/21 chenchal subraveti
//       Adapted from BITSWEEP.PRO
// Sweep through each bit to make sure that TDT can read all bits for event codes

#include C:/TEMPO/ProcLib/UTIL/SEND_EVT.PRO

declare BITSWEEP();


process BITSWEEP() enabled
{
  declare int maxBits  = 16;
  declare int thisBit  = 0;
  declare int waitTime = 400;
  declare int sentTime;
  declare int bitValue;

  thisBit = 0;
  while(1)
  {
	  thisBit = 0;
  while (thisBit < maxBits)
  {
    if (thisBit == 0)
    {
      bitValue = 1;
    }
    else
    {
      bitValue = bitValue * 2;
    }
    printf("Sending bit [%d] value(2^%d) = [%d]\n", thisBit, thisBit, bitValue);
    spawnwait SEND_EVT(bitValue);

    sentTime = time();
    while (time() < (sentTime + waitTime))
    {
      nexttick;
    }
    thisBit = thisBit + 1;
  }
  nexttick 1000;
  printf("Doing next cycle...\n");
  }
}
