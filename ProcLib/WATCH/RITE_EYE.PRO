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
    declare int tickInterval = 5;
    declare     write2File   = 1;
    declate int currTime = time();
    while (1)
    {
        if (write2File)
        {
            //rawIVals.csv relTimeMs,xADC,yADC\n"
            writef("rawIVals.csv %d,%d,%d\n", time()-currTime,atable(EYE_X_CHANNEL),atable(EYE_Y_CHANNEL));
        }
        nexttick tickInterval;
    }
}
