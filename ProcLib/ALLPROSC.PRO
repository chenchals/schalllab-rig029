//==========================================================================
// ALLPROS.PRO
//   Description: Loads all PRO files
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-14
//==========================================================================
//  Revision History:
//
//==========================================================================
// Use variables on the fly - no declaration
#pragma declare = 1
// Room variables: screen, isoluminant colors, data channels
#include C:/TEMPO/ProcLib/Room/VAR_029.PRO
// Screen parameters
#include C:/TEMPO/ProcLib/SET_SCRN.PRO
// Stimulus Variables: fixation, target, photodiode
#include C:/TEMPO/ProcLib/VAR_STIM.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/SET_CLRS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/CMD/CMD_PGS.PRO
//==========================================================================
declare IDLE();

// The State global variable allows the control structure to run tasks...
// ...depending on the current stystem state. The beginning state is idling.
declare int State;
 // Starts tasks after setting variables;
declare int OK;
declare int Set_monkey;
declare int Monkey;
// Give user ability to pause task with a button press
declare int Pause;
// Keeps track of the last task which was run to hold onto default variable values
declare int Last_task;
// Length of strobed event buffer
declare int Event_fifo_N = 1000;
declare int Event_fifo[Event_fifo_N];
// Current index of Event_fifo buffer to set
declare int Set_event  = 0;
//auto fixation task = 1
declare int fix_manual = 1;


process IDLE() enabled
{
  printf("ALLPROSC.PRO Running IDLE()\n");
  printf("ALLPROSC.PRO Running SET_SCRN()\n");
  spawnwait SET_SCRN();
  printf("ALLPROSC.PRO Running SET_DEFAULT_STIM_VARS()\n");
  spawnwait SET_DEFAULT_STIM_VARS();
  printf("ALLPROSC.PRO Running SET_CLR_PALETTE()\n");
  spawnwait SET_CLR_PALETTE();
  printf("ALLPROSC.PRO Running CMD_PGS()\n");
  spawnwait CMD_PGS(1);
  printf("DONE....!\n");
}
