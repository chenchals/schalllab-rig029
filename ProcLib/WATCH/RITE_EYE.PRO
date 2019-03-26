//==========================================================================
// RITE_EYE.PRO
//   Description: Write eye data to file at some specified interval
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-03-22
//==========================================================================
//  Revision History:

declare PROC_WRITE_RAW_I_DATA();


process PROC_WRITE_RAW_I_DATA()
{
    declare int tickInterval = 2;
    declare int write2File   = 0;
    declare int currTime;

    currTime = time();
    writef("rawIVals.csv relTimeMs,xADC,yADC,iInvalid,iInvalidDuration\n");
    while (1)
    {
        if (write2File)
        {
            //rawIVals.csv relTimeMs,xADC,yADC\n"
            writef("rawIVals.csv %d,%d,%d,%d,%d\n", time() - currTime, EYE_X_VOLTS, EYE_Y_VOLTS, I_INVALID, I_INVALID_DURATION);
        }
        nexttick tickInterval;
    }
}
