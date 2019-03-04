//==========================================================================
// DISTTEST.PRO
//   Description: Test different distributions
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-02-08
//==========================================================================
//  Revision History:
//  002: 2019-02-08 chenchal subraveti
//       Adapted from BITSWEEP.PRO
//

#include C: / TEMPO / ProcLib / UTIL / DISTRIB.PRO

declare DISTRIB_TEST();

process DISTRIB_TEST() enabled
{
  declare int nPoints = 2000;
  declare int minT = 600;
  declare int maxT = 800;

  declare int meanT = 600;
  declare float sdT = 15;

  declare int expJitter, uniformJitter, gausRand;

  declare int temp = 0;

  writef("distribs.csv expJitter, uniformJitter, gausRand\n");
  while(temp < nPoints)
  {
    spawnwait RANDOM_EXP(minT, maxT);
    expJitter = RAND_NUM;
    spawnwait RANDOM_UNIFORM(minT, maxT);
    uniformJitter = RAND_NUM;
    spawnwait RANDOM_GAUS(meanT, sdT);
    gausRand = RAND_NUM;

    printf("%d,%d,%d\n",expJitter, uniformJitter, gausRand);
    writef("distribs.csv %d,%d,%d\n",expJitter, uniformJitter, gausRand);

    temp = temp + 1;
    nexttick;
  }






}/* DISTRIB_TEST */
