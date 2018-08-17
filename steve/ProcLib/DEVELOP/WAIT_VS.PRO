// The process code is from PROWIN/PAN process: WaitForVideoSYNC

// PROCESS WaitForVideoSYNC - Wait for all commands to be executed by VideoSYNC.
//
//  The protocol uses WaitForVideoSYNC() like this:
//
//      dsend() or dsendf() ...         // Send a command sequence to VideoSYNC
//      spawnwait WaitForVideoSYNC;     // Wait for all commands to complete
//      // At this point, all commands were executed by VideoSYNC.
//      ...
//
// We utilize the new (as of 24Jun03) RDX TTL feature where there are two TTL
// bits in each direction (VideoSYNC to server and server to VideoSYNC) that
// are now supported by the TEMPO server as well as VideoSYNC.  The two
// features we use are:
//
//      o VideoSYNC's SO command (which sets VideoSYNC's RDX TTL outputs)
//      o PCL's rdxGetTTLIN() and rdxSetTTLIN() functions, which get and
//        set the TEMPO server's RDX TTL outputs.
//
// In particular, we use the RDX TTL bits from VideoSYNC to the TEMPO server
// to have VideoSYNC tell us when it is finished executing all previously
// sent (via dsend/dsendf) commands.  We to this by telling VideoSYNC to set
// its RDX TTL output bits (by sending the SO VideoSYNC command) to a new value
// each time the WaitForVideoSYNC process is spawned.  We then watch the
// incoming RDX TTL bits until we see the value we expect.
//
// There are two enhancements that could be made to this process, which are left
// to the reader to implement.
//
// 1. Use only one TTL bit instead of 2.  This frees up one bit from VideoSYNC
//    to the TEMPO server for other uses by the protocol.
//
// 2. Add a timeout (in ms) argument that causes WaitForVideoSYNC to return
//    after so many milliseconds.  WaitForVideoSYNC would also set a global
//    variable indicating whether the wait was successful or, if no, what the
//    reason was.  Possible status codes are:
//
//          0. Success.  VideoSYNC executed the commands within the requested
//             timeframe.
//          1. timeout waiting for our transmit buffer to empty.  This
//             error indicates that VideoSYNC (or the RDX reader isn't
//             running)
//          2. timeout waiting for VideoSYNC to finish executing commands.
//             This indicates that either VideoSYNC is too slow to execute
//             the commands in the requested time or that the RDX receiver
//             hasn't implemented the SO command.
declare WAIT_VS();

process WAIT_VS()
    {
    int     newBits;                    // =0,1,2,3

    // WAIT FOR ALL PREVIOUS COMMAND TO GET SENT
    // This insures that we are in sync up to this point.

    while (dsend())
		{
			nexttick;
		}

    // Now read the current TTL setting and advance by 1.
    // We are using both of RDX's TTL bits from VideoSYNC
    // to us.  But this is not necessary.  We could just
    // use one of the bits, leaving the other free for
    // other uses.

    newBits = (rdxGetTTLIN() + 1) % 4;  // Advance one MOD 4

    // Tell VideoSYNC to increment the sequence count
    // .. by setting its local OOB bits on the RDX link
    // We assume we are the only process sending the SO command.
    // If SO is sent by any other process, it will mess us up
    // and cause us to wait, possibly indefinitely, for our bits.

    dsendf("SO%d\n", newBits);

    // WAIT FOR VIDEOSYNC TO ACTUALLY EXECUTE THE SO COMMAND ABOVE.
    // When it does, it will set its "local" bits to newBits.
    // We will see that change here when we get the "remote" bits.

    while (rdxGetTTLIN() != newBits)    // Wait for the bits we expect
		{
		nexttick;
		}
    }
