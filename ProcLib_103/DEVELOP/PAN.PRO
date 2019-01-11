// PAN.PRO - Example protocol showing use of PAN and synchronization
//             with VideoSYNC's vertical retrace using RDXTTLs.
//
// DESCRIPTION
//
//  Video memory is reorganized into 2048 wide raster lines.
//  Two rows of 4 rectangles each are drawn into Video memory.
//  We then send PAN (PA) commands to VideoSYNC to move the entire
//  image according a trajectory that we compute.
//
// EDIT HISTORY
//  03Oct05 sh  Initial edit

#pragma declare = 1
#include object.pro

declare constant VIDEOMODE         = 261;
declare constant XMAX				= 1024;
declare constant YMAX				= 768;

declare constant TRUE				= 1;
declare constant FALSE				= 0;

declare constant int COLOR_BLACK	= 0;
declare constant int COLOR_RED		= 12;
declare constant int COLOR_GREEN	= 10;
declare constant int COLOR_WHITE	= 15;
declare constant int COLOR_CYAN     = 11;

//-------------------------------------------------------------------------------//
declare int _counter_shot_target	= 0;

declare int _self_size_x			= 60;
declare int _self_size_y			= 60;

declare constant int TARGET		= 2;
declare constant int ROW_NUM		= 2;
declare constant int COL_NUM		= 4;//3;
declare constant int TARGET_NUM	= ROW_NUM * COL_NUM;
declare int _target_size_x		= XMAX/10;
declare int _target_size_y		= YMAX/10;

declare int _target_visible[ROW_NUM, COL_NUM]; // Visibility: TRUE or FALSE
declare int _target_pos_x[ROW_NUM, COL_NUM];   // Target X position (upper left corner)
declare int _target_pos_y[ROW_NUM, COL_NUM];   // Target Y position (upper left corner)

declare int NTRAJECTORY = 200;
declare int trajectoryX[NTRAJECTORY];   // X,Y for PAN
declare int trajectoryY[NTRAJECTORY];

//-------------------------------------------------------------------------------//
// Prototypes

declare Main(), Initialize();
declare TargetSetUp(), TargetLoop(), TargetDraw();
declare WaitForVideoSYNC();
declare SetTrajectory();


//-------------------------------------------------------------------------------//

process Main enabled
{	
	spawnwait	Initialize();
	spawn		TargetLoop();	
}


//-------------------------------------------------------------------------------//
// Initialize - Protocol initialization

process Initialize()
{
	declare hide int i;

    //dsendf("VI %d\n", VIDEOMODE);
    //printf("Waiting 10sec for VideoSYNC to initialize..\n");
    
    dsendf("CL\n");
    dsendf("CA\n");                     // Reset VideoSYNC
    printf("Waiting for VideoSYNC to reset..\n");
    wait 5000;
    printf("Starting test..\n");
    
    // Use a full
    
	dsendf("VC %d,%d,%d,%d\n", 0, XMAX, 0, YMAX);
    
    // Make video memory width 2xXMAX so that when we pan around
    // we don't get artifact due to the video controller wrapping
    // around video memory.
    
    dsendf("LM %d,%d\n", XMAX * 2, YMAX * 2);  // Set logical memory
}


//-------------------------------------------------------------------------------//
// TargetLoop - Loop indefinitely panning the targets along the trajectory.

process TargetLoop()
{
    int         iTrajectory;
    int         direction;
    
	spawnwait	TargetSetUp();
	spawnwait	TargetDraw();
    spawnwait   SetTrajectory();
    
    // Now sequence through the trajectory as fast as VideoSYNC can go
    // and send PAN commands.
    
    iTrajectory = 0;
    direction = 1;
	while (1)
	    {
        dsendf("PA %d,%d\n", trajectoryX[iTrajectory], trajectoryY[iTrajectory]);
        
        // Synchronize with VideoSYNC so we don't flood it with PA commands.
        // The PA command synchronizes with the vertical retrace.

        spawnwait WaitForVideoSYNC();
        
        // These extra waits are added just to slow things down.
        // Without them, the image moves too fast to see what is going on!
        
        //spawnwait WaitForVideoSYNC();
        //spawnwait WaitForVideoSYNC();
        //spawnwait WaitForVideoSYNC();
        //spawnwait WaitForVideoSYNC();
        //spawnwait WaitForVideoSYNC();
        //spawnwait WaitForVideoSYNC();
        //spawnwait WaitForVideoSYNC();
        
        iTrajectory = iTrajectory + direction;
        
        if (iTrajectory >= NTRAJECTORY)
            {
            iTrajectory = NTRAJECTORY - 1;
            direction = -direction;
            }
        else if (iTrajectory < 0)
            {
            iTrajectory = 0;
            direction = -direction;
            }
        }
    }


//-------------------------------------------------------------------------------//
// TargetSetUp - Set position of targets in video memory

process TargetSetUp()
{
	declare hide int i, j, x, y, x_offset = XMAX / 15, y_offset = YMAX / 10;

	//_counter_shot_target	= 0;
    
    // Center the boxes horizontally

	x = (XMAX - (_target_size_x * COL_NUM + x_offset * (COL_NUM - 1))) / 2;
	y = 100;
    
	i = 0;
	while(i < ROW_NUM)
	    {
		j = 0;
		while(j < COL_NUM)
		    {
			_target_visible[i, j]	= TRUE; // Make target visible
			_target_pos_x[i, j]		= x;    // Set upper left corner (X,Y)
			_target_pos_y[i, j]		= y;

			x = x + _target_size_x + x_offset;
			j = j + 1;
		    }
		x = (XMAX - (_target_size_x * COL_NUM + x_offset * (COL_NUM - 1))) / 2;
		y = y + _target_size_y + y_offset;		
		i = i + 1;
		nexttick;
	    }
}


//-------------------------------------------------------------------------------//
// SetTrajectory - Generate trajectory X,Y arrays by setting the PAN coordinates
// that we want to PAN the image to.
//
// The idea is that we want to limit the X portion of the pan to be between
// between leftX and rightX.
//
// The trajectory looks like this:
//
//  --------------------------------->-------------------------------End
//  |
//  ^
//  |
//  ---------------------------------<-----------------------------------
//                                                                      |
//                                                                      ^
//                                                                      |
//  --------------------------------->-----------------------------------
//  |
//  ^
//  |
//  ---------------------------------<----------------------------<--Begin
//
// Note that the displayed image will move in the opposite direction of
// the PAN trajectory!  So at Begin, the image will appear in the upper
// left corner of the screen.  As we PAN towards the End, the image will
// scan left, then down, then right, then down, etc.
 
process SetTrajectory()
{
    int     iTrajectory;
    float   x, y;                           // Keep in float so we don't loose precision
    float   jumpX;
    float   jumpY;
    int     loop;
    int     leftX, rightX;
    
    iTrajectory = 0;
    
    leftX = XMAX/6;                             // Left margin of trajectory
    rightX = leftX + (XMAX / 10);               // Right margin of trajectory
    
    y = YMAX/4.0;
    jumpY = -(YMAX/4.0) / 4;
    
    x = rightX;
    jumpX = - (rightX - leftX) / (NTRAJECTORY / 4);
    
    loop = 0;
    while (loop < NTRAJECTORY / 4)
        {
        trajectoryX[iTrajectory] = x;
        trajectoryY[iTrajectory] = y;
        iTrajectory = iTrajectory + 1;
        x = x + jumpX;
        loop = loop + 1;
        nexttick;                               // Don't overrun the process cycle
        }
    
    y = y + jumpY;
    jumpX = - jumpX;
    
    loop = 0;
    while (loop < NTRAJECTORY / 4)
        {
        trajectoryX[iTrajectory] = x;
        trajectoryY[iTrajectory] = y;
        iTrajectory = iTrajectory + 1;
        x = x + jumpX;
        loop = loop + 1;
        nexttick;                               // Don't overrun the process cycle
        }
        
    y = y + jumpY;
    
    jumpX = - jumpX;
    loop = 0;
    while (loop < NTRAJECTORY / 4)
        {
        trajectoryX[iTrajectory] = x;
        trajectoryY[iTrajectory] = y;
        iTrajectory = iTrajectory + 1;
        x = x + jumpX;
        loop = loop + 1;
        nexttick;                               // Don't overrun the process cycle
        }
    
    y = y + jumpY;
    
    jumpX = - jumpX;
    loop = 0;
    while (loop < NTRAJECTORY / 4)
        {
        trajectoryX[iTrajectory] = x;
        trajectoryY[iTrajectory] = y;
        iTrajectory = iTrajectory + 1;
        x = x + jumpX;
        loop = loop + 1;
        nexttick;                               // Don't overrun the process cycle
        }
}

//-------------------------------------------------------------------------------//
// TargetDraw - Draw targets into video memory
//
// The target_pos_X and _Y are origined at (0,0).
// we map this to (XMAX/4, YMAX/4) when we draw so that
// there is 1/2 screen of empty space in all four directions
// around the drawn part of the screen.  This gives us the room
// to PAN 1/4 of the screen in all directions without having to
// worry about the drawn image wrapping around the edges of the
// screen.
//
//                          XMAX*2
// (0,0)
//  -------------------------------------------------------------
//  |Video memory                                               |
//  |                                                           |
//  |      (xmax/2, ymax/2)                                     |
//  |          |                                                |
//  |          X------------------------------------            |
//  |          |Visible      XMAX                  |            |
//  |          |screen                             |            |
//  |          |                                   |            |
//  |          |         X  X  X  X                |            |
//  |          |                                   |YMAX        | YMAX*2
//  |          |         X  X  X  X <--Rectangles  |            |
//  |          |                                   |            |
//  |          |                                   |            |
//  |          |                                   |            |
//  |          -------------------------------------            |
//  |                                                           |
//  |                                                           |
//  |                                                           |
//  -------------------------------------------------------------
//                                                     (XMAX*2-1, YMAX*2-1)

process TargetDraw()
{
	declare int i, j;

	i = 0;
	while(i < ROW_NUM)
	{
		j = 0;
		while(j < COL_NUM)
		{
			if( _target_visible[i, j] == TRUE)
                dsendf("CO %d\n", COLOR_CYAN);          // Visible target
            else
                dsendf("CO %d\n", COLOR_BLACK);         // Hidden target
                
            // When drawing use (XMAX/4, YMAX/4) as our origin.
            // This gives us the maximum movement of 1/2 screen
            // in all 4 directions.
            
			dsendf("RF %d, %d, %d, %d\n",               // Draw into video memory
                XMAX/4 + _target_pos_x[i, j],
				YMAX/4 + _target_pos_y[i, j],
                XMAX/4 + _target_pos_x[i, j] + _target_size_x,
				YMAX/4 + _target_pos_y[i, j] + _target_size_y
                );
            
			j = j + 1;
		}
		i = i + 1;
		nexttick;
	}
    
    // Draw a rectangle around original "screen"
    // so the user can see where the original rectangle is.
    
    dsendf("CO %d\n", COLOR_WHITE);
    dsendf("RU %d,%d,%d,%d\n",
        XMAX/4,
        YMAX/4,
        XMAX/4 + XMAX-1,
        YMAX/4 + YMAX-1);
}


//-----------------------------------------------------------------------
// This process was copied from PROWIN\RDXTTL.PRO
//
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

process WaitForVideoSYNC()
    {
    int     newBits;                    // =0,1,2,3
    
    // WAIT FOR ALL PREVIOUS COMMAND TO GET SENT
    // This insures that we are in sync up to this point.
    
    while (dsend()) nexttick;
    
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
        nexttick;
    }


