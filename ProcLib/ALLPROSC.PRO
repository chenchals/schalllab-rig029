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
// Room variables
#include C:/TEMPO/ProcLib/Room/ROOM_029.PRO
// Screen parameters including isoluminant colors,
#include C:/TEMPO/ProcLib/SET_SCRN.PRO
// Set palatte colors and color indices
#include C:/TEMPO/ProcLib/SET_CLRS.PRO
// set pages to load CMD_PGS.PRO?
#include C:/TEMPO/ProcLib/TEST/TEST_PGS.PRO
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
  
}
