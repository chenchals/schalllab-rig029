//--------------------------------------------------------------------------------------------------
// process ANTI_PGS(int curr_target, 
				// float fixation_size, 
				// int fixation_color, 
				// int sig_color, 
				// float scr_width, 
				// float scr_height, 
				// float pd_left, 
				// float pd_bottom, 
				// float pd_size);
// Figure out all stimuli that will be needed on the next search trial and
// place it all into video memory.
//
// written by joshua.d.cosman@vanderbilt.edu 	July, 2013
// modified by kaleb.a.lowe@vanderbilt.edu February 2017


#include C:/TEMPO/ProcLib/DRW_SQR.pro
#include C:/TEMPO/ProcLib/DRW_RECT.pro

declare hide float 	Size;   																	// Global output will be sent as stobes...        										
declare hide int   	Color;	
declare hide int  	singColor;
declare hide int 	distColor;	
declare hide int 	oppCol;						
declare hide float 	Eccentricity; 
declare hide float 	Angle;   

declare hide int id;     																// ...by INFOS.pro at trial end.

declare hide float 	targ_orient; 
declare hide float 	d1_orient; 
declare hide float 	d2_orient; 
declare hide float 	d3_orient; 
declare hide float 	d4_orient; 
declare hide float 	d5_orient; 
declare hide float 	d6_orient; 
declare hide float 	d7_orient; 
declare hide float 	d8_orient; 
declare hide float 	d9_orient; 
declare hide float 	d10_orient; 
declare hide float 	d11_orient; 

declare hide float 	targ_angle;
declare hide float 	d1_angle; 
declare hide float 	d2_angle; 
declare hide float 	d3_angle; 
declare hide float 	d4_angle; 
declare hide float 	d5_angle; 
declare hide float 	d6_angle; 
declare hide float 	d7_angle; 
declare hide float 	d8_angle; 
declare hide float 	d9_angle; 
declare hide float 	d10_angle; 
declare hide float 	d11_angle; 
      																
declare hide float 	targ_ecc;
declare hide float 	d1_ecc; 
declare hide float 	d2_ecc; 
declare hide float 	d3_ecc; 
declare hide float 	d4_ecc; 
declare hide float 	d5_ecc; 
declare hide float 	d6_ecc; 
declare hide float 	d7_ecc; 
declare hide float 	d8_ecc; 
declare hide float 	d9_ecc; 
declare hide float 	d10_ecc; 
declare hide float 	d11_ecc; 


declare ANTI_PGS(int curr_target, 																// set SETC_TRL.pro
				int singDifficulty,
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int cue_color,
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ);                       										// see GRAPHS.pro

process ANTI_PGS(int curr_target, 																// set SETC_TRL.pro
				int singDifficulty,
				float fixation_size,                    										// see DEFAULT.pro and ALL_VARS.pro
				int fixation_color,                     										// see SET_CLRS.pro
				int cue_color,
				int sig_color,                          										// see DEFAULT.pro and ALL_VARS.pro
				float scr_width,                        										// see RIGSETUP.pro
				float scr_height,                       										// see RIGSETUP.pro
				float pd_left,                          										// see RIGSETUP.pro
				float pd_bottom,                        										// see RIGSETUP.pro
				float pd_size,                          										// see RIGSETUP.pro
				float deg2pix_X,                        										// see SET_COOR.pro
				float deg2pix_Y,                        										// see SET_COOR.pro
				float unit2pix_X,                       										// see SET_COOR.pro
				float unit2pix_Y,                       										// see SET_COOR.pro
				int object_targ)                        										// see GRAPHS.pro
	{										
											
	declare hide float 	pd_eccentricity;										
	declare hide float	pd_angle;	
	declare hide float  pd_angle2;
	declare hide float 	opposite;										
	declare hide float	adjacent;										
	declare hide float	stim_ecc_x;										
	declare hide float	stim_ecc_y;										
	declare hide int   	open        = 0;										
	declare hide int   	fill        = 1;										
	declare hide float 	targH;
	declare hide float	targV;
	declare hide float zeroTol = .01;
	//declare hide int 	distDifficulty[12];
	declare hide int 	distCode;
	/*declare hide int randVal;
	declare hide float cumProbs[ndDifficulties];
	declare hide int it;
	declare hide int ic;
	declare hide int lastVal;
	declare hide int sumProbs;
	declare hide int sumCong;
	declare hide int cumCong[ndDifficulties];
	declare hide int isCong;
	declare hide int nRel;
	declare hide int relInds[ndDifficulties];
	declare hide int relProbs[ndDifficulties];
	declare hide int myInd;
	*/
	
	// number the pgs that need to be drawn
	declare hide int   	blank       = 0;										
	declare hide int	fixation_pd = 1;										
	declare hide int	fixation    = 2;
	//declare hide int 	cue_pd 		= 3;
	declare hide int 	cue 		= 3;
	//declare hide int	plac_pd   	= 4;										
	//declare hide int	plac      	= 5;	
	declare hide int	target_f_pd = 4;										
	declare hide int	target_f  	= 5;
	declare hide int	target      = 6;			
	declare hide int 	targ_only   = 7;
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Calculate screen coordinates for stimuli on this trial								
	size         = llength;   
	color        = 250;//curr_target + 1;	// Figure out the attributes of the current target 
	singColor 	= 251;
	distColor  = 250;
	oppCol 		= 248;
	
	angle			= targ_angle; 		
	//printf("In ANTI_PGS: angle = %d, index = %d",targ_angle,targInd);
	//printf("\n");
		
	eccentricity	= targ_ecc;	
										
	stim_ecc_x		= cos(angle) * eccentricity;
	stim_ecc_y		= sin(angle) * eccentricity * -1;

	oSetAttribute(object_targ, aSIZE, size*deg2pix_X, size*deg2pix_Y);							// while we are at it, resize fixation object on animated graph
	oSetAttribute(object_fix, aSIZE, 1*deg2pix_X, 1*deg2pix_Y);									
	
	opposite = ((scr_height/2)-pd_bottom);														// Figure out angle and eccentricity of photodiode marker in pixels
	adjacent = ((scr_width/2)-pd_left);                                                         // NOTE: I am assuming your pd is in the lower left quadrant of your screen
	pd_eccentricity = 200;//sqrt((opposite * opposite) + (adjacent * adjacent));
	pd_angle = rad2deg(atan (opposite / adjacent));
	//pd_angle = pd_angle + 180; 																//change this for different quadrent or write some code for flexibility
	pd_angle2 = pd_angle + 180;
	
	// Get distractor and target sizes
	// The below should be eliminated if we put the "catch"
	//    in the singleton difficulties, but kept for now
	//printf("ANTI_PGS: Catch = %d, singDiff = %d\n",Catch,singDifficulty);
	if (Catch)
	{
		targH = catchH;
		targV = catchV;
	}
	else if (!Catch)
	{
		targH = stimHorizontal[singDifficulty];
		targV = stimVertical[singDifficulty];
	}
	
	id = 0;
	while (id < SetSize)
		{
		
		//Changed above comments to just the above section because that was the part that moved.
		// Now, the below still drops the difficulty codes for distractors before the pages are set up
		//distCode = 700 + (10*id)+distDifficulty[id];
		// Drop Distractor Code
		//Event_fifo[Set_event] = distCode;		// Set a strobe to identify this file as a Search session and...	
		///Set_event = (Set_event + 1) % Event_fifo_N;	// ...incriment event queue.
		id = id+1;
		nexttick;
		}
		
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 1
	// print("fixation with photodiode");
	dsendf("rw %d,%d;\n",fixation_pd,fixation_pd); 												// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 2	  
	// print("fixation");
	dsendf("rw %d,%d;\n",fixation,fixation);   													// draw second pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, fixation_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	//----------------------------------------------------------------------------------------------------------------------
	// Draw pg 3
	// print("cue with photodiode");
	
	/*dsendf("rw %d,%d;\n",cue_pd,cue_pd); 												// draw first pg of video memory
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    */
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 4	  
	// print("cue");
	dsendf("rw %d,%d;\n",cue,cue);   													// draw second pg of video memory                                       
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
    nexttick;
	
	/* See if cutting out placeholders helps us
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 5	 
	// print("placeholders with photodiode");
	

	dsendf("rw %d,%d;\n",plac_pd,plac_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	
	if (SetSize > 0)
		{
		spawnwait DRW_PLAC(targ_angle, targ_ecc, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				spawnwait DRW_PLAC(Angle_list[id], Eccentricity_list[id], color, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			id = id+1;
			nexttick;
			}
		}
		
		
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
	spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
		
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 6	 
	// print("placeholders");
	dsendf("rw %d,%d;\n",plac,plac);  												// draw pg 3                                        
	dsendf("cl:\n");

	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

	if (SetSize > 0)
		{
		spawnwait DRW_PLAC(targ_angle, targ_ecc, color, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				spawnwait DRW_PLAC(Angle_list[id], Eccentricity_list[id], color, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			id = id+1;
			nexttick;
			}
			
		}
		
	
	
	nexttick;
	*/
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 7	 
	// print("target, fixation, and distractors with photodiode");
	dsendf("rw %d,%d;\n",target_f_pd,target_f_pd);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				if (id == ((targInd + SetSize/2) % SetSize))
				{
					spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], oppCol, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
				else
				{
				spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], distColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
				}
			
			id = id+1;
			nexttick;
			}
		}
	//spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, 0, deg2pix_X, deg2pix_Y);   	// draw fixation point
	
	spawnwait DRW_SQR(pd_size,pd_angle,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    spawnwait DRW_SQR(pd_size,pd_angle2,pd_eccentricity,15,fill,unit2pix_X,unit2pix_Y);			// draw photodiode marker
    nexttick;
	
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 8	 
	// print("target, fixation, and distractors");
	dsendf("rw %d,%d;\n",target_f,target_f);  												// draw pg 3                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
				{
				if (id == ((targInd + SetSize/2) % SetSize))
				{
					spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], oppCol, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
				else
				{
				spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], distColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
				}
			
			id = id+1;
			nexttick;
			}
		}
		
	//spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point
	spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, 0, deg2pix_X, deg2pix_Y);   	// draw fixation point

	
	//spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);   	// draw fixation point

    nexttick;
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 9	  
	// print("target and distractors");
	dsendf("rw %d,%d;\n",target,target);  														// draw pg 4                                        
	dsendf("cl:\n");																			// clear screen

	if (SetSize > 0)
		{
		spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
		}
	
	if (SetSize > 1)
		{
		id = 0;
		while (id < SetSize)
			{
			if (Angle_list[id] != targ_angle)
			{
				if (id == ((targInd + SetSize/2) % SetSize))
				{
					spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], oppCol, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
				else
				{
				spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], distColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
				}
			}
			id = id+1;
			nexttick;
			}
		}
		
	
	if (soa_mode==1)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, open, deg2pix_X, deg2pix_Y);
		}
	else
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);		
		}
	nexttick; 
	
	// Draw pg 10	  
	// print("target only");
	dsendf("rw %d,%d;\n",targ_only,targ_only);  														// draw pg 4                                        
	dsendf("cl:\n");																			// clear screen

	//printf("\n\nDistCol = %d in ANTI_PGS\n\n",distCol);
	if (SetSize > 0)
		{
		if (((targV - targH) > zeroTol) || (basicPopOut==1))// pro trial, leave on target
		{
			id = 0;
			while (id < SetSize)
			{
				if (Angle_list[id] == targ_angle)
				{
					spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
				} else if (id ==  (targInd + (SetSize/2)) % SetSize)
				{
					if (leaveOther==2)//if we should leave the anti stim on even in pro trials...
					{
						spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], oppCol, fill, deg2pix_X, deg2pix_Y);  
					} else if (ghost == 1)
					{
						spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], oppCol, open, deg2pix_X, deg2pix_Y);  
					}
					
				} else if (ghost == 1)
				{
					spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], distColor, open, deg2pix_X, deg2pix_Y);  
				}
				id = id+1;
				nexttick;
			}
		} else if ((targH - targV) > zeroTol) // anti trial, leave on opposite
		{	
			id = 0;
			while (id < SetSize)
			{
				if (id == (targInd + (SetSize/2)) % SetSize)
				{
					spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], oppCol, fill, deg2pix_X, deg2pix_Y);          	// draw target
				} else if (Angle_list[id] == targ_angle)
				{
					if (leaveOther > 0)  // if we don't want to extinguish the pro stim
					{
						spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, fill, deg2pix_X, deg2pix_Y);          	// draw target
					} else if (ghost == 1)
					{
						spawnwait DRW_RECT(targH,targV,targ_angle, targ_ecc, singColor, open, deg2pix_X, deg2pix_Y);          	// draw target
					}
				} else if (ghost == 1)
				{
					spawnwait DRW_RECT(distH[distDifficulty[id]],distV[distDifficulty[id]],Angle_list[id], Eccentricity_list[id], distColor, open, deg2pix_X, deg2pix_Y);  
				}
				id = id+1;
				nexttick;
			}	
		}
				
		}
		
	if (soa_mode==1)
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, open, deg2pix_X, deg2pix_Y);
		}
	else
		{
		spawnwait DRW_SQR(fixation_size, 0.0, 0.0, cue_color, fill, deg2pix_X, deg2pix_Y);		
		}
	nexttick; 
	
	//printf("reached blank start\n");
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	// Draw pg 0 (last is displayed first)	
	// print("blank"); 																			
	dsendf("rw %d,%d;\n",blank,blank);                                          				// draw the blank screen last so that it shows up first
	dsendf("cl:\n");                                                                            // clear screen (that's all)
	//printf("reached blank end\n");
	
	
	}