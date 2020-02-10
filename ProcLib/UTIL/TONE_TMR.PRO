//==========================================================================
// TONE_TMR.PRO
//   Description: Start timer for tone delay
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2020/02/10
//==========================================================================

declare START_TONE_TIMER();
declare STOP_TONE_TIMER();

declare int TONE_DURATION_EXPIRED = 0;
// 
declare int TONE_START_FLAG = 0;

process START_TONE_TIMER()
{
    TONE_START_FLAG = 1;
    while (TONE_START_FLAG == 1)
    {
        TONE_DURATION_EXPIRED = TONE_DURATION_EXPIRED + 1;
        nexttick;
    }
}

process STOP_TONE_TIMER()
{
    TONE_START_FLAG = 0;
    TONE_DURATION_EXPIRED = 0;
}

