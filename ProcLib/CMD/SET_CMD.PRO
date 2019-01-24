//==========================================================================
// SET_CMD.PRO
//   Description: Setup All variables, procs for Countermanding task.
//
//   NOTE:
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-24
//==========================================================================
//  Revision History:

// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/VAR/CONSTNTS.PRO
// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/RIG/SET_RIG.PRO
// Set monk
#include C:/TEMPO/ProcLib/MONK/SET_MONK.PRO
// Stimulus Variables: fixation, target, photodiode
#include C:/TEMPO/ProcLib/CMD/VAR_STIM.PRO
// CMD Vars only...?
#include C:/TEMPO/ProcLib/CMD/VAR_CMD.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/CMD/SET_CLRS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
// Setup event defs so events can be sent
#include C:/TEMPO/ProcLib/CMD/EVENTDEF.PRO
// Send event processes
#include C:/TEMPO/ProcLib/UTIL/SEND_EVT.PRO
// Setup GRAPHS
#include C:/TEMPO/ProcLib/GRAFS/GRAPHS.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_EYE.PRO
// Set up watches
#include C:/TEMPO/ProcLib/WATCH/WTCH_PD.PRO



declare SET_CMD();


process SET_CMD()
{
  // Nothing to do...
  printf("SET_CMD called\n");

}
