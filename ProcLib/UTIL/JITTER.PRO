//==========================================================================
// JITTER.PRO
//   Description: Create an instance of a different distributions.
//                The computed value is written to a global variable JITTER_INT.
//
//   Inputs:
//          GAUSS_JITTER(int mu, float variance):
//          UNIFORM_JITTER(int minT, int maxT);:
//          EXPONENT_JITTER(int minT, int maxT);:
//   Output:
//         Global variable: JITTER_INT (int)
//
//   Usage:
//                spawnwait GAUSS_JITTER(600,15);
//                valueNeeded = JITTER_INT;
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-05
//==========================================================================

declare GAUSS_JITTER(int mu, int variance);
declare UNIFORM_JITTER(int minT, int maxT);
declare EXPONENT_JITTER(int minT, int maxT);

declare int JITTER_INT;


// Gaussian distribution
process GAUSS_JITTER(int mu, int variance)
{
    // Box-Muller transform
    //Using: https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    declare float u1, u2, z1, tol;
    declare float twoPi = 2.0 * 22 / 7;

    // uniform random number (0 < u1 < 1)
    u1 = (random(65535) + 1.0) / 65536.0;
    u2 = (random(65535) + 1.0) / 65536.0;

    z1 = sqrt(-2.0 * ln(u1)) * cosrad(u2 * twoPi);
    //z1 = sqrt(-2.0 * ln(u1)) * sinrad(u2 * twoPi);

    JITTER_INT = round(z1 * sqrt(variance)) + mu;
}


// Random uniform distribution
process UNIFORM_JITTER(int minT, int maxT)
{
    JITTER_INT = (random(maxT - minT) + 1) + minT;
}


// Exponential distribution
process EXPONENT_JITTER(int minT, int maxT)
{
    declare float diffT, jitter;

    jitter     = (random(1001)) / 1000.0;
    jitter     = exp(-1.0 * jitter / 0.25);
    JITTER_INT = round((jitter * (maxT - minT)) + minT);
}
