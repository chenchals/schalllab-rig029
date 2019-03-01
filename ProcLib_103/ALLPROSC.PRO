//----------------------------------------------------------------------------
// ALL_PROS.PRO is meant to contain all of the protocols run in a particular rig.
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
// with shared globals (see ACQUIRE.PRO), and maintaining local variable scope
// leads to cumbersome process calls.  However, once a protocol reaches any
// real level of complexity, global variables lead to unstable behavior and
// untraceable bugs (see cman_f.PRO, the predecessor of CMANDING.PRO).  By
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
// with this problem post-hoc (see cman_f.PRO).  Here, pains have been taken to
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
// RIGSETUP.PRO.  By opening and changing the values of the rig specfic hardware
// variables in this file, one is able to port ALL_PROS.PRO to a new recording
// setup easily.
//
// written by david.c.godlove@vanderbilt.edu  January, 2011;        modified by joshua.d.cosman@vanderbilt.edu	July, 2013

#pragma declare = 1                     // require declarations of all variables

declare IDLE();                         // must be declared in top because it is called by other processes below

declare int State;                      // The State global variable allows the control structure to run tasks...
// ...depending on the current stystem state. The beginning state is idling.
declare int OK;                         // Starts tasks after setting variables;
declare int Set_monkey;
declare int Monkey;
declare int Pause;                           // Gives user ability to pause task with a button press
declare int Last_task;                       // Keeps track of the last task which was run to hold onto default variable values
declare int Event_fifo_N = 1000;             // Length of strobed event buffer
declare int Event_fifo[Event_fifo_N];        // Global first in first out buffer for event codes
declare int Set_event  = 0;                  // Current index of Event_fifo buffer to set
declare int fix_manual = 1;                  //auto fixation task = 1

#include C:/TEMPO/ProcLib/ALL_VARS.PRO // declares global variables needed to run protocols
#include C:/TEMPO/ProcLib/RIGDEC.PRO   // declares a bunch of rig specific global variables
#include C:/TEMPO/ProcLib/RIGSETUP.PRO // Assigns variables
#include C:/TEMPO/ProcLib/EVENTDEF.PRO // event code definitions
#include C:/TEMPO/ProcLib/DEFAULT.PRO  // sets all globals to their appropriate defaults for countermanding
#include C:/TEMPO/ProcLib/GOODVARS.PRO // do user defined variables make sense before starting the task?
#include C:/TEMPO/ProcLib/STIM.PRO     // deliver microstim and send a stobe
#include C:/TEMPO/ProcLib/KEY_STIM.PRO // deliver microstim via key press
#include C:/TEMPO/ProcLib/SET_CLRS.PRO // sets the stim colors up
#include C:/TEMPO/ProcLib/SEND_EVT.PRO // sends event code to TDT
#include C:/TEMPO/ProcLib/DIO.PRO      // necessary for digital input output communication
#include C:/TEMPO/ProcLib/SET_COOR.PRO // set screen coordinates up and calculate some conversion factors
#include C:/TEMPO/ProcLib/GRAPHS.PRO   // required when using object graphs in cmanding protocol (modified from object.PRO to include graph setup)
#include C:/TEMPO/ProcLib/SET_INH.PRO  // sets up the inhibition function graph used in cmanding
#include C:/TEMPO/ProcLib/SET_SOA.PRO
#include C:/TEMPO/ProcLib/SET_SCH.PRO  // sets parameters for search RT graph
#include C:/TEMPO/ProcLib/SET_PA.PRO
#include C:/TEMPO/ProcLib/WINDOWS.PRO  // sets fixation and target window size (these valeus are needed in WATCHEYE.PRO)
#include C:/TEMPO/ProcLib/WATCHEYE.PRO // monitors eye position on each process cyle
#include C:/TEMPO/ProcLib/TONE.PRO     // does simple frequency conversion and presents tone accordingly
#include C:/TEMPO/ProcLib/TONESWEP.PRO // a sweep through several tones for a sound which can be distinguished from pure tones
#include C:/TEMPO/ProcLib/WATCHMTH.PRO // monitors mouth movement on each process cycle
#include C:/TEMPO/ProcLib/WATCHBOD.PRO // monitors body movement on each process cycle
#include C:/TEMPO/ProcLib/SVR_BELL.PRO // sounds speaker on server
#include C:/TEMPO/ProcLib/SVR_BEL2.PRO // sounds speaker on server (different)
#include C:/TEMPO/ProcLib/CMDTRIAL.PRO // runs a single countermanding trial based on input
#include C:/TEMPO/ProcLib/MGTRIAL.PRO
#include C:/TEMPO/ProcLib/REP_ORT.PRO  // simple process for selecting repeated display orientations prior to trial
#include C:/TEMPO/ProcLib/RAND_ORT.PRO // simple process for selecting random display orientation prior to trial
#include C:/TEMPO/ProcLib/LOC_REP.PRO  // simple process for selecting repeated display locations prior to trial
#include C:/TEMPO/ProcLib/LOC_RAND.PRO // simple process for selecting random display locations prior to trial
#include C:/TEMPO/ProcLib/LOC_ASYM.PRO // select displays for probability cueing mode
#include C:/TEMPO/ProcLib/SEL_LOCS.PRO // simple process for selecting stimulus locations on a given trials, from above 2 files
#include C:/TEMPO/ProcLib/DRW_T.PRO    // simple process for drawing T stimulus, incldues T_ORIENT
#include C:/TEMPO/ProcLib/DRW_L.PRO    // simple process for drawing L stimulus, incldues L_ORIENT
#include C:/TEMPO/ProcLib/DRW_PLAC.PRO // simple process for drawing placeholder stimulus
#include C:/TEMPO/ProcLib/DRW_SQR.PRO  // simple process for drawing box
#include C:/TEMPO/ProcLib/DRW_RECT.PRO
#include C:/TEMPO/ProcLib/FIX_PGS.PRO  // setup fixation stimuli
#include C:/TEMPO/ProcLib/FLS_PGS.PRO  // setup flash stimuli
#include C:/TEMPO/ProcLib/CMD_PGS.PRO  // setup countermanding windows
#include C:/TEMPO/ProcLib/SETC_TRL.PRO // sets up all of the input to run a countermanding trial
#include C:/TEMPO/ProcLib/SETMGTRL.PRO
#include C:/TEMPO/ProcLib/SETG_TRL.PRO // sets up all input to run a gonogo trial
#include C:/TEMPO/ProcLib/SETD_TRL.PRO // sets up all input to run a delayed saccade trial
#include C:/TEMPO/ProcLib/GNGTRIAL.PRO // runs a single gonogo guided trial based on input
#include C:/TEMPO/ProcLib/DELTRIAL.PRO // runs a single delayed saccade trial based on input
#include C:/TEMPO/ProcLib/UPD8_INH.PRO // updates inhibition function for cmanding
#include C:/TEMPO/ProcLib/UPD8_SOA.PRO
#include C:/TEMPO/ProcLib/SET_LOCS.PRO
#include C:/TEMPO/ProcLib/CMD/INFOS.PRO         // queue up all trial event codes for strobing to plexon
#include C:/TEMPO/ProcLib/CMD/ABORT.PRO
#include C:/TEMPO/ProcLib/CMD/SUCCESS.PRO
#include C:/TEMPO/ProcLib/CMD/FAILURE.PRO
#include C:/TEMPO/ProcLib/END_TRL.PRO  // ends a trial based on outcome
#include C:/TEMPO/ProcLib/KEY_REWD.PRO // needed to give reward manually from keyboard (stupid)
#include C:/TEMPO/ProcLib/KEY_TARG.PRO // see above
#include C:/TEMPO/ProcLib/FIXATION.PRO // fixation control structure
#include C:/TEMPO/ProcLib/CMANDING.PRO // countermanding control structure//#include C:/TEMPO/ProcLib/MEMORY.PRO	// mem guided sacc task control structure
#include C:/TEMPO/ProcLib/MGUIDE.PRO
#include C:/TEMPO/ProcLib/GONOGO.PRO   // gonogo sacc task control structure
#include C:/TEMPO/ProcLib/DELAYED.PRO  // delayed guided sacc task control structure
#include C:/TEMPO/ProcLib/FLSHSCRN.PRO // for gross VEPs
#include C:/TEMPO/ProcLib/QUE_TTL.PRO  // makes a ring buffer for sending TTL events
#include C:/TEMPO/ProcLib/SET_LOCS.PRO
#include C:/TEMPO/ProcLib/BITSWEEP.PRO // Allows to check for integrity of TEMPO -> Data collection system connection
#include C:/TEMPO/ProcLib/WAIT_VS.PRO
#include C:/TEMPO/ProcLib/WATCHPD.PRO  // Controls presentation time by watching for PD presentation


//----------------------------------------------------------------------
process IDLE() enabled
{
  // When the clock is started the task is not yet running.
  // At any time we can press a button to return to this...
  // ...idle loop.  It will make sure everything is off...
  // ...and all necessary variables are reset before...
  // ...starting the task over or starting a new task.
  declare hide int off = 0;
  declare hide int idling;
  declare hide int run_cmd_sess     = 1;                // state 1 is countermanding
  declare hide int run_fix_sess     = 2;                // state 2 is fixation
  declare hide int run_mg_sess      = 3;                // state 3 is mem guided sacc
  declare hide int run_gonogo_sess  = 4;
  declare hide int run_flash_sess   = 5;                // state 5 is flash screen protocol
  declare hide int run_delayed_sess = 6;
  declare hide int run_search_sess  = 7;
  declare hide int run_vm_sess      = 8;
  declare hide int run_anti_sess    = 9;
  declare hide int run_color_pop    = 10;

  declare hide int roomSelect;

  seed1(timeus());                                       // randomly seed the number generator
  normal(1);                                             // call the normal distribution to replenish queue after seeding
  idling = 1;                                            // makes the while loop run

  roomSelect = 1;

  // Select room
  system("dialog Room_Number");
  while (roomSelect == 1)
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

  dioSetMode(0, PORTA | PORTB | PORTC);         // set 1st three TTL lines to output
  mio_dig_set(Juice_channel, off);              // make sure the juice line is closed
  mio_fout(off);                                // make sure the speaker is off
  dsend("vi 256;");                             // make sure vdosync is in correct config
  dsend("ca");                                  // flush all vdosync memory

  spawn SET_COOR(scr_width,                     // set up screen coordinates based on globals defined in RIGSETUP.PRO
                 scr_height,
                 subj_dist,
                 scr_pixX,
                 scr_pixY);

  spawn GRAPHS(scr_pixX,                        // this is currently countermanding specific and should be changed
               scr_pixY,
               deg2pix_X,
               deg2pix_Y);

  spawn WATCHEYE(eye_X_channel,                 // start monitoring eye position
                 eye_Y_channel,
                 analogUnits,
                 maxVoltage,
                 deg2pix_X,
                 deg2pix_Y);

  spawn WTCH_PD_SCHMITT();

  spawn QUE_TTL();                              // set up for plexon communication

  printf("flushing video memory please wait...\n");
  wait 5000;                                    // it can take up to 5 seconds to clear all vdo sync memory (pg 7-37)
  printf("done!\n");
  system("dialog Choose_Task");                 // Pop up choose task dialog



  while (idling)                               // wait for the user to specify which task to run
  {
    if (State == run_cmd_sess)                 // user wants to run the countermanding task
    {
      OK = 0;
      spawn CMANDING();                       // start countermanding

      idling = 0;                             // stop idling
    }

    if (State == run_fix_sess)                // user wants to run the fixation task
    {
      OK = 0;
      spawn FIXATION();                       // start fixation

      idling = 0;                             // stop idling
    }

    if (State == run_mg_sess)                 // user wants to run the mem guided sacc task
    {
      OK = 0;
      spawn MGUIDE();                         // start mem guided sacc task

      idling = 0;                             // stop idling
    }

    if (State == run_gonogo_sess)             // user wants to run the go/nogo task
    {
      OK = 0;
      spawn goNOgo();                         // start go/nogo task

      idling = 0;                             // stop idling
    }

    if (State == run_flash_sess)              // user wants to run the flash protocol
    {
      OK = 0;
      spawn FLSHSCRN();                       // start flash protocol

      idling = 0;                             // stop idling
    }

    if (State == run_delayed_sess)            // user wants to run the delayed sacc task
    {
      OK = 0;
      spawn Delayed();                        // start delayed sacc task

      idling = 0;                             // stop idling
    }
    if (State == run_search_sess)             // user wants to run the delayed sacc task
    {
      printf("Search not supported by ALL_PROS_CMD. Please select another option\n");
      State = 0;
      system("dpop Pre_Task_Main");
      system("dialog Choose_Task");
    }
    if (State == run_anti_sess)
    {
      printf("Pro/Anti not supported by ALL_PROS_CMD. Please select another option\n");
      State = 0;
      system("dpop Pre_Task_Main");
      system("dialog Choose_Task");
    }
    if (State == run_color_pop)
    {
      printf("Color Popout not supported by ALL_PROS_SCH. Please select another option\n");
      State = 0;
      system("dpop Pre_Task_Main");
      system("dialog Choose_Task");
    }
    nexttick;                                 // if no task is specified idle for another process...
    // ...cycle and then check again.
  }
} /* IDLE */
