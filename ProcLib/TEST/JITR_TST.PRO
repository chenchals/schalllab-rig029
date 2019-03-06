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

#include C:/TEMPO/ProcLib/UTIL/JITTER.PRO

declare JITTER_TEST();


process JITTER_TEST() enabled
{
    declare int nPoints = 2000;

    declare int meanT     = 600;
    declare int varianceT = 175;

    declare int exponentJitter, uniformJitter, gaussJitter;

    declare int temp = 0;

    writef("jitters.csv exponentJitter, uniformJitter, gaussJitter\n");
    while (temp < nPoints)
    {
        spawnwait EXPONENT_JITTER(meanT, varianceT);
        exponentJitter = JITTER_INT;

        spawnwait UNIFORM_JITTER(meanT, varianceT);
        uniformJitter = JITTER_INT;

        spawnwait GAUSS_JITTER(meanT, varianceT);
        gaussJitter = JITTER_INT;

        printf("%d,%d,%d\n", exponentJitter, uniformJitter, gaussJitter);
        writef("jitters.csv %d,%d,%d\n", exponentJitter, uniformJitter, gaussJitter);
        temp = temp + 1;
        nexttick 2;
    }
    printf("\n****Writing file : jitters.csv---will complete--ONLY when you exit the TEMPO Client****\n");
}/* DISTRIB_TEST */
