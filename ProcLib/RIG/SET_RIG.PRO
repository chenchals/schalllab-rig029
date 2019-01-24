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

// Screen setip
#include C:/TEMPO/ProcLib/UTIL/SET_SCRN.PRO

// Rig 029
#include C:/TEMPO/ProcLib/RIG/RIG_029.PRO

declare int RIG_029_ID = 29;

declare SET_RIG();


process SET_RIG()
{
  if (RIG_ID == RIG_029_ID)
  {
    spawnwait RIG_029();
  }
  spawnwait SET_SCRN();
}
