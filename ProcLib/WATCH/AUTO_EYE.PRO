//==========================================================================
// AUTO_EYE.PRO
//   Description: Create eyeX and eyeY positions for auto-monkey
//   NOTE:
//         Only works if MONK_ID s=is set to AUTO_ID
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-25
//==========================================================================
//  Revision History:
//

declare AUTO_EYE();

// For different states
declare AUTO_EYE_GET_READY();
declare AUTO_EYE_FIX_ON();
declare AUTO_EYE_FIXATE();
declare AUTO_EYE_TARG_ON();
declare AUTO_EYE_TARG_ACQ();

// Utils for eye pos
declare AUTO_EYE_POS_ACQ_TARG();
declare AUTO_EYE_POS_MARCH();
declare AUTO_EYE_POS_RAND();
declare AUTO_EYE_POS_FIX();
declare AUTO_EYE_POS_FIX_WIDE();
declare AUTO_EYE_POS_TARG();

declare float AUTO_EYE_A;
declare float AUTO_EYE_X_DEG;
declare float AUTO_EYE_Y_DEG;
declare int   AUTO_EYE_TICS;
declare int   AUTO_TRIG_SACC;

//======Flags for states======
//0= no saccade
//1= normal saccade
//2= early saccade
//3= late saccade
declare int DO_SACC = 2;

// 0=stay in FIX (for late saccade)
// 1=goto Target within SACC_DURATION
// 2=goto Target After SACC_DURATION
// 3=goto random loc out of FIX WIN_W
declare int DO_TARG_ACQ = 1;

process AUTO_EYE()
{
    declare int march;

    march = 1;
    while (1)
    {
        // Random eye position which is ON the screen
        // Eccentricity: Between screen degrees X, screen degrees Y
        // Angle any

        if (CURR_STAT == STAT_TEST)
        {
            spawnwait AUTO_EYE_POS_MARCH();
        }
        else if (CURR_STAT == STAT_IDLE)
        {
            spawnwait AUTO_EYE_POS_RAND();
        }
        else if (CURR_STAT == STAT_GET_READY)
        {
            spawnwait AUTO_EYE_GET_READY();
        }
        else if (CURR_STAT == STAT_FIX_ON)
        {
            spawnwait AUTO_EYE_FIX_ON();
        }
        else if (CURR_STAT == STAT_FIXATE)
        {
            spawnwait AUTO_EYE_FIXATE();
        }
        else if (CURR_STAT == STAT_TARG_ON)
        {
            spawnwait AUTO_EYE_TARG_ON();
        }
        else if (CURR_STAT == STAT_TARG_ACQ)
        {
            spawnwait AUTO_EYE_TARG_ACQ();
        }
        else
        {
            //freeze
            AUTO_EYE_X_DEG = AUTO_EYE_X_DEG;
            AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG;
        }
        nexttick;
    }
} /* AUTO_EYE */


// State GET_READY
process AUTO_EYE_GET_READY()
{
    if (STAT_DLTA_T <= (STAT_ALLOWED_T)+10)
    {
        spawnwait AUTO_EYE_POS_FIX_WIDE();
    }
}


// State FIX_ON
process AUTO_EYE_FIX_ON()
{
    if (STAT_DLTA_T <= round(STAT_ALLOWED_T * 0.8))
    {
        // hold position for half the allowed fix timetime
        AUTO_EYE_X_DEG = AUTO_EYE_X_DEG + random(10) / 10.0;
        AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG + random(10) / 10.0;
    }
    else     // fixate
    {
        spawnwait AUTO_EYE_POS_FIX();
    }
}


// State FIXATE
process AUTO_EYE_FIXATE()
{
    if (STAT_DLTA_T <= round(STAT_ALLOWED_T * 1.1))
    {
        // hold fix
        AUTO_EYE_X_DEG = random(5) / 10.0;
        AUTO_EYE_Y_DEG = random(5) / 10.0;
    }
    else     // break fix
    {
        spawnwait AUTO_EYE_POS_FIX_WIDE();
    }
}


// State TARG_ON
process AUTO_EYE_TARG_ON()
{
    declare float fracTime;

    fracTime = 1.1;
    if (DO_SACC > 1)
    {
        // cant use random since it changes every nexttick
        fracTime = 0.8;
    }
    if (DO_SACC == 0)
    {
        // hold fix
        spawnwait AUTO_EYE_POS_FIX();
    }
    else
    {
        if (STAT_DLTA_T <= round(STAT_ALLOWED_T * fracTime))
        {
            // hold fix
            spawnwait AUTO_EYE_POS_FIX();
        }
        else
        {
            spawnwait AUTO_EYE_POS_FIX_WIDE();
        }
    }
}


// State TARG_ACQ
process AUTO_EYE_TARG_ACQ()
{
    if (!DO_SACC)
    {
        spawnwait AUTO_EYE_POS_FIX();
    }
    else if (DO_SACC == 1)    // has till max_SAC_TIME
    {
        if (STAT_DLTA_T < round((STAT_ALLOWED_T) * 0.7))
        {
            if (DO_TARG_ACQ == 2)
            {
                spawnwait AUTO_EYE_POS_FIX_WIDE();
            }
            else if (DO_TARG_ACQ == 1)
            {
                spawnwait AUTO_EYE_POS_FIX();
            }
        }
        else
        {
            //saccade
            spawnwait AUTO_EYE_POS_ACQ_TARG();
        }
    }
    else if (DO_SACC > 1)   //  EArly or late saccade, has till max_sacc_duration
    {
        spawnwait AUTO_EYE_POS_ACQ_TARG();
    }
}
//Util functions


process AUTO_EYE_POS_ACQ_TARG()
{
    if (!DO_TARG_ACQ)
    {
        spawnwait AUTO_EYE_POS_FIX();
    }
    else if (DO_TARG_ACQ == 1)
    {
        if (STAT_DLTA_T < random(round(STAT_I_MOVE_DURATION * 0.8)) + 5)
        {
            spawnwait AUTO_EYE_POS_FIX_WIDE();
        }
        else
        {
            spawnwait AUTO_EYE_POS_TARG();
        }
    }
    else if (DO_TARG_ACQ == 2)
    {
        if (STAT_DLTA_T < (STAT_I_MOVE_DURATION + 5 + random(10)))
        {
            spawnwait AUTO_EYE_POS_FIX_WIDE();
        }
        else
        {
            spawnwait AUTO_EYE_POS_TARG();
        }
    }
    else if (DO_TARG_ACQ == 3)
    {
        spawnwait AUTO_EYE_POS_FIX_WIDE();
    }
}


process AUTO_EYE_POS_MARCH()
{
    // march along diagonal
    if (AUTO_EYE_TICS == 0)
    {
        AUTO_EYE_TICS  = 1;
        AUTO_EYE_X_DEG = -15.0;
        AUTO_EYE_Y_DEG = -15.0;
    }
    else
    {
        AUTO_EYE_TICS = AUTO_EYE_TICS + 1;
        if (AUTO_EYE_TICS >= 10)
        {
            AUTO_EYE_TICS  = 1;
            AUTO_EYE_X_DEG = AUTO_EYE_X_DEG + 1.0;
            AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG + 1.0;
        }
        else if (AUTO_EYE_X_DEG >= 15)
        {
            AUTO_EYE_X_DEG = -15.0;
            AUTO_EYE_Y_DEG = -15.0;
        }
        else
        {
            AUTO_EYE_TICS = AUTO_EYE_TICS + 1;
        }
    }
}


process AUTO_EYE_POS_RAND()
{
    AUTO_EYE_X_DEG = random(10) + random(10) / 10.0;
    AUTO_EYE_Y_DEG = random(10) + random(10) / 10.0;
    if (random(2))
    {
        AUTO_EYE_X_DEG = AUTO_EYE_X_DEG * -1;
    }
    if (random(2))
    {
        AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG * -1;
    }
}


process AUTO_EYE_POS_FIX()
{
    AUTO_EYE_X_DEG = random(10) / 10.0;
    AUTO_EYE_Y_DEG = random(10) / 10.0;
    // for eyeXdeg
    if (random(2))
    {
        AUTO_EYE_X_DEG = AUTO_EYE_X_DEG * -1.0;
    }
    // for eyeYdeg
    if (random(2))
    {
        AUTO_EYE_Y_DEG = AUTO_EYE_Y_DEG * -1.0;
    }
}


process AUTO_EYE_POS_FIX_WIDE()
{
    // sometimes the pos maybe in targ window
    declare float randX;
    declare float randY;

    randX = ((FIX_WIN_LARGE[LEFT] + FIX_WIN_LARGE[RIGHT]) / 2.0) + 3.0 + random(10) / 10.0;
    randY = ((FIX_WIN_LARGE[UP] + FIX_WIN_LARGE[DOWN]) / 2.0) + 3.0 + random(10) / 10.0;
    // for eyeXdeg
    if (random(2))
    {
        randX = randX * -1.0;
    }
    // for eyeYdeg
    if (random(2))
    {
        randY = randY * -1.0;
    }
    AUTO_EYE_X_DEG = randX;
    AUTO_EYE_Y_DEG = randY;
}


process AUTO_EYE_POS_TARG()
{
    declare float randX;
    declare float randY;

    randX = random(10) / 10.0;
    randY = random(10) / 10.0;
    // for eyeXdeg
    if (random(2))
    {
        randX = randX * -1.0;
    }
    // for eyeYdeg
    if (random(2))
    {
        randY = randY * -1.0;
    }
    AUTO_EYE_X_DEG = (TARG_WIN[LEFT] + TARG_WIN[RIGHT]) / 2.0 + randX;
    AUTO_EYE_Y_DEG = (TARG_WIN[UP] + TARG_WIN[DOWN]) / 2.0 + randY;
}
