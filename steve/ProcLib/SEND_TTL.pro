//--------------------------------------------------------------------------------------------------
// Set TTLs to a value denoting a stobed event, wait 100 micro seconds so plexon can pick it up,
// and then set the values back 0
// value  = 0 to 32767 (signed 16 bit so in theory negative works too but not used here).
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

#include C:/TEMPO/ProcLib/WAIT_MU.pro

declare SEND_TTL(int value);

process SEND_TTL(int value)
	{
	declare int output = 1;
	int shiftVal;

	//printf("Sending value: %d\n",value);

	dioSetMode(output, PORTA|PORTB|PORTC);			// set ports A, B, and C to send strobes (output)

	// TDT doesn't want to recognize odd values (as of 7/5/16 - KL), but luckily...
	// 4 digit event codes can be represented with 14 bits (of 16 available by TDT)
	// A solution? bit-shift the value so that the event code takes ups bits 2-15, which should be decodable...

	shiftVal = value;// << 1;

	dioSetA(output, shiftVal & 0xFF);
	dioSetB(output, (shiftVal >> 8) | 0x80);

	//The commented section is the ideal form, without this shifting nonsense
	//dioSetA(output, value & 0xFF);				// load the low 8 bits on port A
	//dioSetB(output, (value >> 8) | 0x80); //& 0x3F);				// load the high 8 bits on port B


	spawnwait WAIT_MU(100);							// wait 100 micro seconds to avoid losing events

	dioSetA(output, ~0xFF);
	dioSetB(output, ~0xFF);
	}
