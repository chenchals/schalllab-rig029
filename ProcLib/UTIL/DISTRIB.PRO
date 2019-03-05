//==========================================================================
// DISTRIB.PRO
//   Description: Create an instance of a different distributions.
//
//   Example:
//
//   Inputs:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-04
//==========================================================================

declare RANDOM_GAUS(int mu, float sigma);
declare RANDOM_UNIFORM(int minN, int maxN);
declare RANDOM_EXP(int minT, int maxT);

declare int RAND_NUM;

// Random Gaussian distribution
process RANDOM_GAUS(int mu, float sigma)
{
    // Box-Muller transform
    //Using: https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    declare float u1, u2, z1, tol;
	declare float twoPi = 2.0*22/7;
	// uniform random number (0 < u1 < 1)
	u1 = (random(65535)+1.0)/65536.0;
	u2 = (random(65535)+1.0)/65536.0;

    z1 = sqrt(-2.0 * ln(u1)) * cosrad(u2 * twoPi);
    //z1 = sqrt(-2.0 * ln(u1)) * sinrad(u2 * twoPi);

    RAND_NUM = round(z1 * sigma) + mu;
}

// Random uniform distribution
process RANDOM_UNIFORM(int minN, int maxN)
{
    RAND_NUM = (random(maxN - minN) + 1) + minN;
}

// Exponential distribution
process RANDOM_EXP(int minT, int maxT)
{
    declare float diffT, jitter;

	jitter = (random(1001))/1000.0;
    jitter   = exp(-1.0 * jitter/ 0.25);
    RAND_NUM = round((jitter * (maxT - minT)) + minT);
}

