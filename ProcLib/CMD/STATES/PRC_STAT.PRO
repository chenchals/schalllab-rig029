//==========================================================================
// PRC_STAT.PRO
//   Description: Process states for Countermanding. All states are based
//                on EYE POSITION and current TASK PHASE
//                A STATE should ideally know about
//                1. STAT_PREV : State it came from
//                2. STAT_STRT_T : Start time of state (in ticks/ms) from trial start
//                3. STAT_STP_T : End time of state (in ticks/ms) from trial start
//                4. STAT_DLTA_T : Length of time in this state (in ticks/ms)
//                5. STAT_NEXT : Must be able to set NEXT STATE
//
//   NOTE:
//
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-28
//==========================================================================
//  Revision History:
//

declare SET_CURR_STAT(int inTime);

process SET_CURR_STAT(int inTime)
{
  PREV_STAT   = CURR_STAT;
  CURR_STAT   = STAT_GET_READY;
  STAT_STRT_T = inTime;
  STAT_DLTA_T = 0;
}
