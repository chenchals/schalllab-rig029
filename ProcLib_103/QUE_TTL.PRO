//-------------------------------------------------------------------------
// Process QUE_TTL() runs in the background and sends up to 5 event codes
// per process cycle to the remote system, drawing them from the Event_fifo[] buffer.
// This process should be the last process in your protocol so that any
// preceeding process that adds an event code to the Event_fifo[] will do so
// before QUE_TTL() runs.
// NOTE: Two problems may arise when sending TTLs.  First, TTLs may be sent 
// too quickly for plexon to keep up and plexon may drop them.  This won't
// result in any errors you can see.  Second, too much time may be allotted
// to individual TTLs causing more time to be allotted to TTLs than is possible
// on a process cycle.  This will result in buffer overflow messages in TEMPO.
// The balance between too little time and too much time is struck by 1) the 
// number of micro seconds allotted to each TTL, 2) the number of TTLs sent
// per process cycle, and 3) the amount of other stuff you allow to happen while
// TTLs are being sent.  In rig 028 I have found that 100 microseconds between TTLs
// and 5 TTLs per process cycle results in zero drops and zero overflows AS LONG AS
// I HAVE APPROPRIATELY PLACED nextticks IN AREAS OF HEAVY TTL VOLUME.  That way
// other processes (e.g. rdx communication) don't use up all of the buffer while I am
// trying to strobe.  All of this may depend on plexon settings that I am 
// currently unaware of, and tests should be performed in each rig to find 
// appropriate parameters.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011

#include C:/TEMPO/ProcLib/SEND_TTL.pro

declare QUE_TTL();

process QUE_TTL()
		{
		declare int send_event;									// current event to send (if == to set_event we are...
																// ...caught up meaning no events are in the Event_fifo.
		declare int n_evs_sent;									// # of TTLs which have been sent this process cycle		
					
		while (1)  												// run in the background                         
			{			
			n_evs_sent = 0;			
			while (n_evs_sent < 5								// While we have not sent 5 events on this process cycle...
					&& send_event != Set_event)					// ...and we are not caught up on the Event_fifo... (GLOBAL ALERT)
				{	
				spawnwait SEND_TTL(Event_fifo[send_event]);		// ...send the next event to plexon and...
				send_event = (send_event + 1) % Event_fifo_N;	// ...advance to the next event in the Event_fifo and...
				n_evs_sent = n_evs_sent + 1;					// ... count that another code was sent.
				}	
					
			nexttick;                       					// wait one process cycle
																// Note that we may wait on process cycle because we are..
																// ...just waiting on data to be added to the Event_fifo, or...
																// ...we may wait because we have too many events for a...
																// ...single cycle.
			}
	}