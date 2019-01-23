//==========================================================================
// SET_RIG.PRO
//   Description: Setup All RIG ids for tempo.
//                Each rig [NAME]_ID must have an accompanying
//                RIG/[NAME].PRO that [re]defines vars in given task for
//                example VAR_RIG.PRO.  Try not to add extra *global* declares,
//                instead add them to appropriate VAR_[RIG].PRO.
//
//   NOTE:
//       Create RIG/[name].PRO with process RIG_[name]() file for each rig used.  Define
//       parameters as needed for that rig
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-21
//==========================================================================
//  Revision History:

// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/VAR/CONSTNTS.PRO
// Load all constants and related gobal vars
#include C:/TEMPO/ProcLib/RIG/VAR_RIG.PRO
// Screen parameters
#include C:/TEMPO/ProcLib/RIG/SET_SCRN.PRO
// Setup Monk also
#include C:/TEMPO/ProcLib/MONK/SET_MONK.PRO
// Stimulus Variables: fixation, target, photodiode
#include C:/TEMPO/ProcLib/VAR/VAR_STIM.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/RIG/SET_CLRS.PRO
// CMD VArs ??
#include C:/TEMPO/ProcLib/CMD/VAR_CMD.PRO

// Send event processes
#include C:/TEMPO/ProcLib/UTIL/SEND_EVT.PRO

// Rig 029
#include C:/TEMPO/ProcLib/RIG/RIG_029.PRO

declare int RIG_029_ID = 29;

declare SET_RIG(int rigId, int monkId);


process SET_RIG(int rigId, int monkId)
{
  RIG_ID = rigId;
  if (RIG_ID == RIG_029_ID)
  {
    spawnwait RIG_029();
  }

  spawnwait SET_SCRN();
  spawnwait SET_CLRS();
  spawnwait SET_DEFAULT_STIM_VARS();
  spawnwait SET_MONK(monkId);

}
