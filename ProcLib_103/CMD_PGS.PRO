//==========================================================================
// CMD_PGS.PRO
//   Description: Function to setup all PAGES for CMD task
//   Author: chenchal.subraveti@vanderbilt.edu
//   Date: 2019-01-09
//==========================================================================
//  Revision History:
//  001: 2019/01/09 chenchal subraveti
//       Only the following vars are used int he call:
//       curr_target
//       fixation_size
//       fixation_color
//       sig_color
//       object_targ
//--------------------------------------------------------------------------------------------------

declare hide float 	size;   																	// Global output will be sent as stobes...
declare hide float 	angle;        																// ...by INFOS.pro at trial end.
declare hide float 	eccentricity;
declare hide int   	color;

declare CMD_PGS(int curr_target, 																// set SETC_TRL.pro
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				int object_targ);                       										// see GRAPHS.pro

process CMD_PGS(int curr_target, 																// set SETC_TRL.pro
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				int object_targ)                        										// see GRAPHS.pro
	{

	declare hide float 	pdEccentricity;
	declare hide float	pdAngleR;
	declare hide float	pdAngleL;
	declare hide float 	opposite;
	declare hide float	adjacent;
	declare hide float	stim_ecc_x;
	declare hide float	stim_ecc_y;
	declare hide int   	open        = 0;
	declare hide int   	fill        = 1;
	declare hide int   	pdColor     =  247 ;

	declare float pdSize = 4;

	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;
	declare hide int	fixation_pd = 1;
	declare hide int	fixation    = 2;
	declare hide int	target_pd   = 3;
	declare hide int	target      = 4;
	declare hide int	signal_pd   = 5;
	declare hide int	signal      = 6;

	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Calculate screen coordinates for stimuli on this trial
	size         = Size_list[curr_target];   													// Figure out the attributes of the current target
	angle        = Angle_list[curr_target]; 													// THESE USER DEFINED GLOBALS ARE ARRAYS SO
	eccentricity = Eccentricity_list[curr_target];												// THEY CANNOT BE PASSED INTO PROCESSES
	color        = curr_target + 1;																// zero is reserved for black.  see SET_CLRS.pro

	stim_ecc_x = cos(angle) * eccentricity;														// find the center of the box in x and y space based on the angle and eccentricity...
	stim_ecc_y = sin(angle) * eccentricity * -1;
	oMove(object_targ, stim_ecc_x*deg2pix_X, stim_ecc_y*deg2pix_Y);								// ...and move the animated graph object there.
	oSetAttribute(object_targ, aSIZE, size*deg2pix_X, size*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);

  // For PD
	adjacent = rad2deg(atan((Scr_width/2)/Subj_dist));
	opposite = rad2deg(atan((Scr_height/2)/Subj_dist));
	pdEccentricity = sqrt((opposite * opposite) + (adjacent * adjacent)) - 0.5;
	pdAngleL = rad2deg(atan(opposite/adjacent)) + 180;
	pdAngleR = -rad2deg(atan(opposite/adjacent));

		//--------------------------------------------------------------------------------------------------------------------
		// Draw pg 1 FIXATION_PD - PD is drawn on LEFT-TOP of screen only
		//printf("CMD_PGS: Drawing page %d FIX_SIZE %2.2d, pdSize %3.4d, pdAngleL %3.2d\n",fixation_pd,fixation_size,pdSize,pdAngleL);
		dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
		dsendf("cl:\n");
		spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, fixation_color, fill);
		spawnwait DRW_RECT_NEW(pdSize,pdSize/4,pdAngleL,pdEccentricity,pdColor,fill);
	 	printf("-----------------\n");
    nexttick;
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Draw pg 2 FIXATION - No PD
		//printf("CMD_PGS: Drawing page %d FIX_SIZE %2.2d, pdSize %3.4d\n",fixation,fixation_size);
		dsendf("rw %d,%d;\n",fixation,fixation);
		dsendf("cl:\n");
		spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, fixation_color, fill);
	 	printf("-----------------\n");
		nexttick;
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Draw pg 3 TARGET with PD - PD is drawn on LEFT-TOP of screen only
	//printf("CMD_PGS: Drawing page %d targetSize %2.2d, pdSize %3.4d, pdAngleL %3.2d\n",target_pd,size,pdSize,pdAngleL);
	dsendf("rw %d,%d;\n",target_pd,target_pd);
	dsendf("cl:\n");
	spawnwait DRW_RECT_NEW(size, size, angle, eccentricity, color, fill);          	// draw target
	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
		{
		  spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, fixation_color, open); // draw fixation point
		}
	spawnwait DRW_RECT_NEW(pdSize,pdSize/4,pdAngleL,pdEccentricity,pdColor,fill);
  nexttick;
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Draw pg 4 TARGET no PD - Not used
	//printf("CMD_PGS: Drawing page %d targetSize %2.2d\n",target,size);
  dsendf("rw %d,%d;\n",target,target);  														// draw pg 4
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_RECT_NEW(size, size, angle, eccentricity, color, fill);         	// draw target
	if (!Classic)																				// if we are doing stop-signal 2.0 (not classic)
		{
		  spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, fixation_color, open); // draw fixation point
		}
  nexttick;

	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Draw pg 5 SIGNAL PD - PD is drawn on the right only
	//printf("CMD_PGS: Drawing page %d targetSize %2.2d, pdSize %3.4d, pdAngleR %3.2d\n",signal_pd,size,pdSize,pdAngleR);
	dsendf("rw %d,%d;\n",signal_pd,signal_pd);    												// draw pg 5
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_RECT_NEW(size, size, angle, eccentricity, color, fill);         	// draw target
	spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, sig_color, fill);
	if (!Classic)                                                               // if we are doing stop-signal 2.0 (not classic)
		{
		  spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, fixation_color, open); // draw fixation point
		}
	spawnwait DRW_RECT_NEW(pdSize,pdSize/4,pdAngleR,pdEccentricity,pdColor,fill);
	nexttick;
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Draw pg 6 SIGNAL no PD
	//printf("CMD_PGS: Drawing page %d targetSize %2.2d\n",signal,size);
	dsendf("rw %d,%d;\n",signal,signal);   														          // draw pg 6
	dsendf("cl:\n");																			                      // clear screen
	spawnwait DRW_RECT_NEW(size, size, angle, eccentricity, color, fill);         	// draw target
	spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, sig_color, fill);
	if (!Classic)																			                          // if we are doing stop-signal 2.0 (not classic)
		{
		  spawnwait DRW_RECT_NEW(fixation_size, fixation_size, 0.0, 0.0, fixation_color, open); // draw fixation point
		}
	nexttick;

	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Draw pg 0 BLANK (draw last so it is displayed as default))
	printf("CMD_PGS: Drawing page %d blank\n",blank);
	dsendf("rw %d,%d;\n",blank,blank);                                        // draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                          // clear screen (that's all)
	nexttick;
	}
