//==========================================================================
// CONSTNTS.PRO
//   Description: Define all constants fand related global vars
//                for the experiments
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-15
//==========================================================================
//  Revision History:

// Room Definitions
declare int          RIG;
declare constant int RIG_029 = 1;
declare constant int RIG_030 = 2;

// Color indexes
declare constant int R_IDX = 0;
declare constant int G_IDX = 1;
declare constant int B_IDX = 2;

// Window corners
declare constant int LEFT  = 0;
declare constant int RIGHT = 1;
declare constant int UP    = 2;
declare constant int DOWN  = 3;

// Task definitions
declare int          TASK;
declare constant int TASK_TEST           = 99;
declare constant int TASK_COUNTERMANDING = 1;
declare constant int TASK_FIXATION       = 2;
declare constant int TASK_SEARCH         = 3;
declare constant int TASK_MEMORY_GUIDED  = 4;

// Events: Length of strobed event buffer
declare int          CURR_EVENT_FIFO_IDX = 0;
declare int constant N_EVENT_FIFO        = 1000;
declare int          EVENT_FIFO[N_EVENT_FIFO];
