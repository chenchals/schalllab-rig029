// SEND_EVT.PRO - Set event code for event buffer and increment counter.
//
// DESCRIPTION
//
//  This process will be called for setting event codes
//
// EDIT HISTORY
//  2018-08-08: Chenchal.subraveti@vanderbilt.edu
//    Initial edit.
//

declare SEND_EVT(int eventCode);

process SEND_EVT(int eventCode)
{
  Event_fifo[Set_event] = eventCode;
  Set_event = (Set_event + 1) % Event_fifo_N;
}
