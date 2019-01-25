//==========================================================================
// AUTO.PRO
//   Description: Setsup default parameters Auto subject.
//                AUTO monk makes pre-decided outcomes on each trial.
//                Once integrated, This helps to test all outcomes
//   NOTE:
//       Create one monk_name.PRO file for each monk used.  Define
//       parameters as needed for that subject
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-15
//==========================================================================
//  Revision History:
//

#include C:/TEMPO/ProcLib/WATCH/AUTO_EYE.PRO
declare AUTO();

process AUTO()
{
  declare int tempVar = 0;

  //SSD list is not set
  while (tempVar < N_SSD_MAX)
  {
    SSD_ARRY[tempVar] = tempVar * 2 + 2;
    tempVar           = tempVar + 1;
  }
  // See CMD_VARS and add those that you want to change.
}
