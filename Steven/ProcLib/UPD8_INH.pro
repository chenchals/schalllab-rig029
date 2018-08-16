// Updates inhibition function in the animated graph online. 
// NOTE: SET_INH must have been run already to set inhibition
// function graph up.  Needed for global objects.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
declare float curr_pNC;

declare UPD8_INH(int curr_ssd, 
				int laststopoutcome,
				int decide_ssd);

process UPD8_INH(int curr_ssd, 
				int laststopoutcome,
				int decide_ssd)
	{
	declare int ct;
	declare float hide weight;
	declare float hide change_value;
	declare int hide success = 1;
	declare int hide failure = 0;
	declare int hide position_x;
	declare float hide position_y[20];
	declare float hide ct_ssd[20];
	
	ct = 0;
	if (FirstStopTrial == 1)
		{
		while(ct<20)
			{
			position_y[ct] = 0;
			ct_ssd[ct] = 0;
			ct = ct + 1;
			FirstStopTrial = 0;
			}
		}
	
	if (laststopoutcome == success)
		{
		change_value = 0;
		}
	else if(laststopoutcome == failure)
		{
		change_value = 1000;
		}
		
	
	position_x = (curr_ssd * 1000.0/Refresh_rate) * 1000;	

	weight = 1.0 / (ct_ssd[decide_ssd] + 1.0);
	position_y[decide_ssd] = ((1 - weight) * position_y[decide_ssd]) + (change_value * weight);
	ct_ssd[decide_ssd] = ct_ssd[decide_ssd] + 1;

	
	//---------------------------------------------------------------------
	// SSD 0		
	if (curr_ssd == SSD_list[0])
		{
		oSetAttribute(object_ssd0,aFILLED);
		oSetAttribute(object_ssd0,aVISIBLE);
		oMove(object_ssd0,position_x,position_y[0]);	
		curr_pNC = (position_y[0])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 1		
	if (curr_ssd == SSD_list[1])
		{
		oSetAttribute(object_ssd1,aFILLED);
		oSetAttribute(object_ssd1,aVISIBLE);
		oMove(object_ssd1,position_x,position_y[1]);	
		curr_pNC = (position_y[1])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 2		
	if (curr_ssd == SSD_list[2])
		{
		oSetAttribute(object_ssd2,aFILLED);
		oSetAttribute(object_ssd2,aVISIBLE);
		oMove(object_ssd2,position_x,position_y[2]);	
		curr_pNC = (position_y[2])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 3		
	if (curr_ssd == SSD_list[3])
		{
		oSetAttribute(object_ssd3,aFILLED);
		oSetAttribute(object_ssd3,aVISIBLE);
		oMove(object_ssd3,position_x,position_y[3]);	
		curr_pNC = (position_y[3])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 4		
	if (curr_ssd == SSD_list[4])
		{
		oSetAttribute(object_ssd4,aFILLED);
		oSetAttribute(object_ssd4,aVISIBLE);
		oMove(object_ssd4,position_x,position_y[4]);	
		curr_pNC = (position_y[4])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 5		
	if (curr_ssd == SSD_list[5])
		{
		oSetAttribute(object_ssd5,aFILLED);
		oSetAttribute(object_ssd5,aVISIBLE);
		oMove(object_ssd5,position_x,position_y[5]);	
		curr_pNC = (position_y[5])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 6		
	if (curr_ssd == SSD_list[6])
		{
		oSetAttribute(object_ssd6,aFILLED);
		oSetAttribute(object_ssd6,aVISIBLE);
		oMove(object_ssd6,position_x,position_y[6]);	
		curr_pNC = (position_y[6])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 7		
	if (curr_ssd == SSD_list[7])
		{
		oSetAttribute(object_ssd7,aFILLED);
		oSetAttribute(object_ssd7,aVISIBLE);
		oMove(object_ssd7,position_x,position_y[7]);	
		curr_pNC = (position_y[7])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 8		
	if (curr_ssd == SSD_list[8])
		{
		oSetAttribute(object_ssd8,aFILLED);
		oSetAttribute(object_ssd8,aVISIBLE);
		oMove(object_ssd8,position_x,position_y[8]);	
		curr_pNC = (position_y[8])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 9		
	if (curr_ssd == SSD_list[9])
		{
		oSetAttribute(object_ssd9,aFILLED);
		oSetAttribute(object_ssd9,aVISIBLE);
		oMove(object_ssd9,position_x,position_y[9]);	
		curr_pNC = (position_y[9])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 10		
	if (curr_ssd == SSD_list[10])
		{
		oSetAttribute(object_ssd10,aFILLED);
		oSetAttribute(object_ssd10,aVISIBLE);
		oMove(object_ssd10,position_x,position_y[10]);	
		curr_pNC = (position_y[10])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 11		
	if (curr_ssd == SSD_list[11])
		{
		oSetAttribute(object_ssd11,aFILLED);
		oSetAttribute(object_ssd11,aVISIBLE);
		oMove(object_ssd11,position_x,position_y[11]);	
		curr_pNC = (position_y[11])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 12		
	if (curr_ssd == SSD_list[12])
		{
		oSetAttribute(object_ssd12,aFILLED);
		oSetAttribute(object_ssd12,aVISIBLE);
		oMove(object_ssd12,position_x,position_y[12]);	
		curr_pNC = (position_y[12])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 13		
	if (curr_ssd == SSD_list[13])
		{
		oSetAttribute(object_ssd13,aFILLED);
		oSetAttribute(object_ssd13,aVISIBLE);
		oMove(object_ssd13,position_x,position_y[13]);	
		curr_pNC = (position_y[13])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 14		
	if (curr_ssd == SSD_list[14])
		{
		oSetAttribute(object_ssd14,aFILLED);
		oSetAttribute(object_ssd14,aVISIBLE);
		oMove(object_ssd14,position_x,position_y[14]);	
		curr_pNC = (position_y[14])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 15		
	if (curr_ssd == SSD_list[15])
		{
		oSetAttribute(object_ssd15,aFILLED);
		oSetAttribute(object_ssd15,aVISIBLE);
		oMove(object_ssd15,position_x,position_y[15]);	
		curr_pNC = (position_y[15])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 16		
	if (curr_ssd == SSD_list[16])
		{
		oSetAttribute(object_ssd16,aFILLED);
		oSetAttribute(object_ssd16,aVISIBLE);
		oMove(object_ssd16,position_x,position_y[16]);	
		curr_pNC = (position_y[16])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 17		
	if (curr_ssd == SSD_list[17])
		{
		oSetAttribute(object_ssd17,aFILLED);
		oSetAttribute(object_ssd17,aVISIBLE);
		oMove(object_ssd17,position_x,position_y[17]);	
		curr_pNC = (position_y[17])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 18		
	if (curr_ssd == SSD_list[18])
		{
		oSetAttribute(object_ssd18,aFILLED);
		oSetAttribute(object_ssd18,aVISIBLE);
		oMove(object_ssd18,position_x,position_y[18]);	
		curr_pNC = (position_y[18])/1000;
		}
	//---------------------------------------------------------------------
	// SSD 19		
	if (curr_ssd == SSD_list[19])
		{
		oSetAttribute(object_ssd19,aFILLED);
		oSetAttribute(object_ssd19,aVISIBLE);
		oMove(object_ssd19,position_x,position_y[19]);	
		curr_pNC = (position_y[19])/1000;
		}		

		
		
	//printf("Current pNC at %d ms SSD = %d \n", curr_ssd * (1000.0 / Refresh_rate), curr_pNC);


	}