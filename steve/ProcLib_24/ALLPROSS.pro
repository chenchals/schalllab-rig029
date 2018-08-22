//----------------------------------------------------------------------------
// ALL_PROS.pro is meant to contain all of the protocols run in a particular rig.
// The protocols contained here have been written with the following principles.
// If one expands or changes this protocol, it is recommended that these
// principles continue to be followed to save headaches and poor data collection.
// This requires an additional time commitment on the front end, but the 
// investment will pay dividends on the back end. 
//
// PRINCIPLE 1) MODULARITY
// As much as possible, each process in the ProcLib (Process Library) has been 
// written to stand on its own and function without needing other processes.
// This is good for at least three reasons.  First, processes can be recycled in
// the protocol across multiple tasks minimizing valuable coding space.  Second,
// using these processes as a set of tools, protocols can be developed rapidly.
// Third and most important, modularity allows for unit testing.  All of the 
// processes here have been tested as individual units.
//
// PRINCIPLE 2) VARIABLE SCOPE
// Wherever possible, variables have been kept local in scope.  At first glance,
// this may seem like a big waste of time.  Short protocols are easily written 
// with shared globals (see ACQUIRE.pro), and maintaining local variable scope 
// leads to cumbersome process calls.  However, once a protocol reaches any
// real level of complexity, global variables lead to unstable behavior and 
// untraceable bugs (see cman_f.pro, the predecessor of CMANDING.pro).  By 
// carefully tracking variables and keeping their scope local we can simplify the
// behavior of the task greatly.  Throughout the code...  
// -ALL_CAPS refer to process calls,
// -Capitilized variables refer to Globals,
// -lowercase variables refer to locals.
//
// PRINCIPLE 3) STIMULUS PRECISION
// Drawing on the current viewing screen leads to sloppiness.  If an object is 
// drawn in the middle of the refresh cycle stimulus "tear" can occur, and if 
// stimuli and photodiode marker drawing are initiated in the wrong stage of the
// vertical retrace the photodiode marker may be drawn before the stimulus rather
// than after.  One approach is to use pallete swapping to make stimuli visible 
// or invisible, but this approach is time consuming and the timing is somewhat 
// variable since it reallocates video memory.  The approach used here is to  
// allocate a chunk of video memory to every page which will be viewed on a given 
// trial during the inter-trial interval, and then to use page flipping to present  
// the stimuli with precision and speed.
//
// PRINCIPLE 4) UNIT CONVERSION 
// Many different units may refer to the same measurement at different stages in 
// the task.  For instance, eye position may be dealt with in degrees, voltage, 
// analog card units, or pixels depending on the reference frame.  In the past, 
// the burden of conversion fell to the user and translation code had to deal 
// with this problem post-hoc (see cman_f.pro).  Here, pains have been taken to
// convert eye traces, stimuli, and fixation boxes into a standard reference 
// frame (visual degrees) "under the hood" so that the user is not forced to 
// consult a slide rule every time they want to move the target location.
//
// PRINCIPLE 5) TASK SWITCHING
// while() loops have been used below to pause between tasks and pause at task 
// intitiation so users can select variables.  This allows a user to set up a GUI 
// which will switch gracefully between tasks.  Following this principle saves
// the user from having to start and stop the clock every time a new task is to be 
// run, and keeps the user from making costly mistakes like freezing the solonoid 
// open or failing to close the last trial before saving to plexon and ruining the 
// session.
//
// PRINCIPLE 6) HARDWARE FLEXIBILITY
// The protocol has been designed with a mechanism for switching between recording
// setups in place.  Variables which are necessary for the protocol to work in a 
// particular room have not been hard coded.  Instead, they reside in a file called
// RIGSETUP.pro.  By opening and changing the values of the rig specfic hardware 
// variables in this file, one is able to port ALL_PROS.pro to a new recording
// setup easily.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011;        modified by joshua.d.cosman@vanderbilt.edu	July, 2013

#pragma declare = 1                     // require declarations of all variables

declare IDLE();							// must be declared in top because it is called by other processes below

declare int State;						// The State global variable allows the control structure to run tasks...
										// ...depending on the current stystem state. The beginning state is idling.
declare int OK;							// Starts tasks after setting variables;
declare int Set_monkey;
declare int Monkey;	
declare int Pause;						// Gives user ability to pause task with a button press
declare int Last_task;					// Keeps track of the last task which was run to hold onto default variable values
declare int Event_fifo_N = 1000;		// Length of strobed event buffer
declare int Event_fifo[Event_fifo_N];	// Global first in first out buffer for event codes
declare int Set_event = 0;              // Current index of Event_fifo buffer to set
declare int fix_manual = 1;				//auto fixation task = 1

#include C:/TEMPO/ProcLib/ALL_VARS.pro	// declares global variables needed to run protocols


#include C:/TEMPO/ProcLib/RIGDEC.pro  // declares a bunch of rig specific global variables
#include C:/TEMPO/ProcLib/RIGSETUP.pro // Assigns variables
//#include C:/TEMPO/ProcLib/Room23/RIGSETUP.pro  // assigns a bunch of rig specific global variables
//#include C:/TEMPO/ProcLib/Room28/RIGSETUP.pro  // assigns a bunch of rig specific global variables
//#include C:/TEMPO/ProcLib/Room29/RIGSETUP.pro  // assigns a bunch of rig specific global variables
//#include C:/TEMPO/ProcLib/Room30/RIGSETUP.pro  // assigns a bunch of rig specific global variables


#include C:/TEMPO/ProcLib/EVENTDEF.pro	// event code definitions
#include C:/TEMPO/ProcLib/DEFAULT.pro	// sets all globals to their appropriate defaults for countermanding
#include C:/TEMPO/ProcLib/GOODVARS.pro	// do user defined variables make sense before starting the task?
#include C:/TEMPO/ProcLib/STIM.pro		// deliver microstim and send a stobe
#include C:/TEMPO/ProcLib/KEY_STIM.pro	// deliver microstim via key press
#include C:/TEMPO/ProcLib/SET_CLRS.pro	// sets the stim colors up
#include C:/TEMPO/ProcLib/DIO.pro		// necessary for digital input output communication
#include C:/TEMPO/ProcLib/SET_COOR.pro  // set screen coordinates up and calculate some conversion factors
#include C:/TEMPO/ProcLib/GRAPHS.pro    // required when using object graphs in cmanding protocol (modified from object.pro to include graph setup)
#include C:/TEMPO/ProcLib/SET_INH.pro	// sets up the inhibition function graph used in cmanding
#include C:/TEMPO/ProcLib/SET_SOA.pro
#include C:/TEMPO/ProcLib/SET_SCH.pro	// sets parameters for search RT graph
#include C:/TEMPO/ProcLib/Set_PA.pro
#include C:/TEMPO/ProcLib/WINDOWS.pro	// sets fixation and target window size (these valeus are needed in WATCHEYE.pro)
#include C:/TEMPO/ProcLib/WATCHEYE.pro	// monitors eye position on each process cyle
#include C:/TEMPO/ProcLib/TONE.pro      // does simple frequency conversion and presents tone accordingly
#include C:/TEMPO/ProcLib/TONESWEP.pro	// a sweep through several tones for a sound which can be distinguished from pure tones
#include C:/TEMPO/ProcLib/WATCHMTH.pro	// monitors mouth movement on each process cycle
#include C:/TEMPO/ProcLib/WATCHBOD.pro	// monitors body movement on each process cycle
#include C:/TEMPO/ProcLib/SVR_BELL.pro	// sounds speaker on server
#include C:/TEMPO/ProcLib/SVR_BEL2.pro	// sounds speaker on server (different)
//#include C:/TEMPO/ProcLib/CMDTRIAL.pro	// runs a single countermanding trial based on input
#include C:/TEMPO/ProcLib/MGTRIAL.pro
#include C:/TEMPO/ProcLib/SCHTRIAL.pro
//#include C:/TEMPO/ProcLib/VMAPTRIAL.pro
#include C:/TEMPO/ProcLib/ANTITR.pro
#include C:/TEMPO/ProcLib/REP_ORT.pro   // simple process for selecting repeated display orientations prior to trial
#include C:/TEMPO/ProcLib/RAND_ORT.pro	// simple process for selecting random display orientation prior to trial
#include C:/TEMPO/ProcLib/LOC_REP.pro	// simple process for selecting repeated display locations prior to trial
//#include C:/TEMPO/ProcLib/LOC_RAND_SING.pro	// simple process for selecting random display locations prior to trial
#include C:/TEMPO/ProcLib/LOC_RAND.pro	// simple process for selecting random display locations prior to trial
#include C:/TEMPO/ProcLib/LOC_ASYM.pro	// select displays for probability cueing mode

#include C:/TEMPO/ProcLib/SEL_LOCS.pro	// simple process for selecting stimulus locations on a given trials, from above 2 files
//#include C:/TEMPO/ProcLib/A_LOCS.pro

#include C:/TEMPO/ProcLib/DRW_T.pro		// simple process for drawing T stimulus, incldues T_ORIENT
#include C:/TEMPO/ProcLib/DRW_L.pro	    // simple process for drawing L stimulus, incldues L_ORIENT
#include C:/TEMPO/ProcLib/DRW_PLAC.pro	// simple process for drawing placeholder stimulus
#include C:/TEMPO/ProcLib/DRW_SQR.pro	// simple process for drawing box
#include C:/TEMPO/ProcLib/DRW_RECT.pro
#include C:/TEMPO/ProcLib/FIX_PGS.pro	// setup fixation stimuli
#include C:/TEMPO/ProcLib/FLS_PGS.pro	// setup flash stimuli
//#include C:/TEMPO/ProcLib/LSCH_PGS.pro	// setup search windows - L
//#include C:/TEMPO/ProcLib/TSCH_PGS.pro	// setup search windows - T
//#include C:/TEMPO/ProcLib/CMD_PGS.pro	// setup countermanding windows
#include C:/TEMPO/ProcLib/ANTI_PGS.pro
//#include C:/TEMPO/ProcLib/SETC_TRL.pro	// sets up all of the input to run a countermanding trial
#include C:/TEMPO/ProcLib/SETMGTRL.pro
//#include C:/TEMPO/ProcLib/SETM_TRL.pro
//#include C:/TEMPO/ProcLib/SETG_TRL.pro  // sets up all input to run a gonogo trial
//#include C:/TEMPO/ProcLib/SETD_TRL.pro  // sets up all input to run a delayed saccade trial
#include C:/TEMPO/ProcLib/SETS_TRL.pro  // sets up all input to run a search trial
#include C:/TEMPO/ProcLib/SETA_TRL.pro 	// sets up all input to run a pro/anti trial
//#include C:/TEMPO/ProcLib/GNGTRIAL.pro	// runs a single gonogo guided trial based on input
//#include C:/TEMPO/ProcLib/DELTRIAL.pro 	// runs a single delayed saccade trial based on input
#include C:/TEMPO/ProcLib/UPD8_INH.pro	// updates inhibition function for cmanding
#include C:/TEMPO/ProcLib/UPD8_SOA.pro  
#include C:/TEMPO/ProcLib/UPD8_SCH.pro	// updates search performance RT
#include C:/TEMPO/ProcLib/SET_LOCS.pro 
#include C:/TEMPO/ProcLib/Search/INFOS.pro		// queue up all trial event codes for strobing to plexon

#include C:/TEMPO/ProcLib/Search/ABORT.pro
#include C:/TEMPO/ProcLib/Search/SUCCESS.pro
#include C:/TEMPO/ProcLib/Search/FAILURE.pro

#include C:/TEMPO/ProcLib/END_TRL.pro	// ends a trial based on outcome
#include C:/TEMPO/ProcLib/KEY_REWD.pro	// needed to give reward manually from keyboard (stupid)
#include C:/TEMPO/ProcLib/KEY_TARG.pro	// see above
#include C:/TEMPO/ProcLib/FIXATION.pro	// fixation control structure
//#include C:/TEMPO/ProcLib/CMANDING.pro	// countermanding control structure
//#include C:/TEMPO/ProcLib/MEMORY.pro	// mem guided sacc task control structure
#include C:/TEMPO/ProcLib/MGUIDE.pro
//#include C:/TEMPO/ProcLib/GONOGO.pro    // gonogo sacc task control structure
//#include C:/TEMPO/ProcLib/DELAYED.pro   // delayed guided sacc task control structure
#include C:/TEMPO/ProcLib/SEARCH.pro	// SEARCH control structure

#include C:/TEMPO/ProcLib/FLSHSCRN.pro	// for gross VEPs
#include C:/TEMPO/ProcLib/QUE_TTL.pro	// makes a ring buffer for sending TTL events

#include C:/TEMPO/ProcLib/PROANTI.pro 	// Pro/Anti Task
#include C:/TEMPO/ProcLib/SET_LOCS.pro
//#include C:/TEMPO/ProcLib/ANTI_DIFFS.pro

#include C:/TEMPO/ProcLib/BITSWEEP.pro // Allows to check for integrity of TEMPO -> Data collection system connection

//----------------------------------------------------------------------
process IDLE() enabled					// When the clock is started the task is not yet running.
	{									// At any time we can press a button to return to this...
										// ...idle loop.  It will make sure everything is off...
										// ...and all necessary variables are reset before...
										// ...starting the task over or starting a new task.
	
	
	declare hide int off = 0;
	declare hide int idling;
	declare hide int run_cmd_sess 		= 1;	// state 1 is countermanding
	declare hide int run_fix_sess 		= 2;	// state 2 is fixation
	declare hide int run_mg_sess 		= 3;	// state 3 is mem guided sacc
	declare hide int run_gonogo_sess	= 4;
	declare hide int run_flash_sess		= 5;	// state 5 is flash screen protocol
	declare hide int run_delayed_sess	= 6;
	declare hide int run_search_sess	= 7;
	declare hide int run_vm_sess 		= 8;
	declare hide int run_anti_sess 		= 9;
	declare hide int run_color_pop 		= 10;
	declare hide int run_pop_prime 		= 11;
	
	declare hide int checkBits 			= 20;
	
	declare hide int roomSelect;
	
	seed1(timeus());					// randomly seed the number generator
	normal(1);							// call the normal distribution to replenish queue after seeding
	idling = 1;							// makes the while loop run
	roomSelect = 1;
	
	
	//spawn RIGSETUP(23);
	// Select room
	system("dialog Room_Number");
	while (roomSelect==1)
	{
		if (Room == 23)
		{
			spawnwait RIGSETUP(Room);
			roomSelect = 0;
		}
		if (Room == 28)
		{
			spawnwait RIGSETUP(Room);
			roomSelect = 0;
		}
		if (Room == 29)
		{
			spawnwait RIGSETUP(Room);
			roomSelect = 0;
		}
		if (Room == 30)
		{
			spawnwait RIGSETUP(Room);
			roomSelect = 0;
		}
		
		nexttick;
	}
	system("dpop Room_Number");
	
	//spawnwait RIGSETUP(Room);
	
	dioSetMode(0, PORTA|PORTB|PORTC); 	// set 1st three TTL lines to output					  
	mio_dig_set(Juice_channel,off);		// make sure the juice line is closed
	mio_fout(off);						// make sure the speaker is off
	dsend("vi 256;");					// make sure vdosync is in correct config
	dsend("ca");						// flush all vdosync memory
	
	spawn SET_COOR(scr_width,			// set up screen coordinates based on globals defined in RIGSETUP.pro	
				scr_height,
				subj_dist,
				scr_pixX,
				scr_pixY);
				
	spawn GRAPHS(scr_pixX,				// this is currently countermanding specific and should be changed
				scr_pixY,				
				deg2pix_X,
				deg2pix_Y);		
	
	spawn WATCHEYE(eye_X_channel,		// start monitoring eye position
				eye_Y_channel, 
				analogUnits, 
				maxVoltage,
				deg2pix_X,
				deg2pix_Y);
				
	spawn QUE_TTL();					// set up for plexon communication
	printf("flushing video memory please wait...\n");
	wait 5000; 							// it can take up to 5 seconds to clear all vdo sync memory (pg 7-37)
	printf("done!\n");
	
	
	system("dialog Choose_Task");		// Pop up choose task dialog
	
		
	
	while (idling)						// wait for the user to specify which task to run
		{
		
		if (State == run_cmd_sess)		// user wants to run the countermanding task
			{
			printf("Countermanding not supported by ALL_PROS_SCH. Please select another option\n");
			State = 0;
			system("dpop Pre_Task_Main");
			system("dialog Choose_Task");
			}
			
		if (State == run_fix_sess)		// user wants to run the fixation task
			{
			OK = 0;
			spawn FIXATION();			// start fixation
			idling = 0;					// stop idling
			}
			
		if (State == run_mg_sess)		// user wants to run the mem guided sacc task
			{
			OK = 0;
			spawn MGUIDE();				// start mem guided sacc task
			idling = 0;					// stop idling
			}
			
		if (State == run_gonogo_sess)	// user wants to run the go/nogo task
			{                           
			printf("Go/NoGo not supported by ALL_PROS_SCH. Please select another option\n");
			State = 0;
			system("dpop Pre_Task_Main");
			system("dialog Choose_Task");
			}
			
		if (State == run_flash_sess)	// user wants to run the flash protocol
			{
			//printf("Full-screen Flash not supported by ALLPROSS. Please select another option\n");
			//State = 0;
			//system("dpop Pre_Task_Main");
			//system("dialog Choose_Task");
			OK = 0;
			spawn FLSHSCRN();			// start flash protocol
			idling = 0;					// stop idling
			}
		
		if (State == run_delayed_sess)	// user wants to run the delayed sacc task
			{
			printf("Delayed Saccade not supported by ALLPROSS. Please select another option\n");
			State = 0;
			system("dpop Pre_Task_Main");
			system("dialog Choose_Task");
			//OK = 0;
			//spawn Delayed();			// start delayed sacc task
			//idling = 0;					// stop idling
			}
		if (State == run_search_sess)	// user wants to run the delayed sacc task
			{
			OK = 0;
			spawn SEARCH();			// start delayed sacc task
			idling = 0;					// stop idling
			}					
		if (State == run_anti_sess)
			{
			OK = 0;
			spawn PROANTI();
			idling = 0;
			}
		if (State == run_color_pop)
			{
			OK = 0;
			spawn PROANTI();
			idling = 0;
			}
		if (State == run_pop_prime)
			{
			//printf("State = %d...\n",State);
			OK = 0;
			spawn PROANTI();
			idling = 0;
			}
		if (State == checkBits)
			{
			//printf("State = %d\n",State);
			spawnwait BITSWEEP();
			system("dialog Choose_Task");
			State = 0;
			}
		nexttick;						// if no task is specified idle for another process... 
										// ...cycle and then check again.
		}
	
	}



