//==========================================================================
// CONSTNTS.PRO
//   Description: Define all constants fand related global vars 
//                for the experiments
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-15
//==========================================================================
//  Revision History:

// Room Definitions
declare int RIG;
declare constant int RIG_029 = 1;
declare constant int RIG_030 = 2;

// Monk definitions
declare int MONK;
declare constant int MONK_JOULE = 1;
declare constant int MONK_HELMHOLTZ = 2;

// Task definitions
declare int TASK;
declare constant int TASK_TEST = 99;
declare constant int TASK_COUNTERMANDING = 1;
declare constant int TASK_FIXATION = 2;
declare constant int TASK_SEARCH = 3;
declare constant int TASK_MEMORY_GUIDED = 4;

// Events: Length of strobed event buffer
declare int CURR_EVENT_FIFO_IDX  = 0;
declare int constant N_EVENT_FIFO = 1000;
declare int EVENT_FIFO[N_EVENT_FIFO];
