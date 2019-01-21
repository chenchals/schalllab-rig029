
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


process BITSWEEP()
{
//printf("Bitsweep entered\n");
  declare hide int maxBits  = 15;
  declare hide int thisBit  = 1;
  declare hide int waitTime = 400;
  declare hide int sentTime;
  declare hide int thisVal;
  declare hide int bitInc;

//printf("thisBit=%d\n",thisBit);
  thisBit = 1;
  while (thisBit <= maxBits)
  {
    printf("thisBit=%d\n", thisBit);
    thisVal = 1;
    bitInc  = 1;
    while (bitInc < thisBit)
    {
      thisVal = thisVal * 2;
      bitInc  = bitInc + 1;
    }
    spawnwait SEND_EVT(thisVal);

    printf("Sending code: %d\n", (thisVal));
    sentTime = time();
    while (time() < (sentTime + waitTime))
    {
      nexttick;
    }

    thisBit = thisBit + 1;

    //State = 0;							// If we are out of the while loop the user wanted...
    // ...to stop Search.
  }
}
