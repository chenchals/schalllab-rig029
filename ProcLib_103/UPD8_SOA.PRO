declare UPD8_SOA(int curr_soa, 
				int laststopoutcome,
				int per_jitter);

process UPD8_SOA(int curr_soa, 
				int laststopoutcome,
				int per_jitter)
	{
	declare int ct;
	declare float hide weight;
	declare float hide change_value;
	declare int hide success = 1;
	declare int hide failure = 0;
	declare int hide position_x;
	declare float hide position_y[20];
	declare float hide ct_soa[20];
	declare float hide rts[20];
	
	ct = 0;
	if (FirstSOATrial == 1)
		{
		while(ct<20)
			{
			position_y[ct] = 0;
			ct_soa[ct] = 0;
			rts[ct] = 0;
			ct = ct + 1;
			FirstSOATrial = 0;
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
	
	
	position_x = round(curr_soa * (1000.0/Refresh_rate));	

//	weight = 1.0 / (ct_soa[per_jitter] + 1.0);
//	position_y[per_jitter] = ((1 - weight) * position_y[per_jitter]) + (change_value * weight);
	ct_soa[per_jitter] = ct_soa[per_jitter] + 1;
	rts[per_jitter] = rts[per_jitter] + (ReactionTime);
	position_y[per_jitter] = rts[per_jitter] / ct_soa[per_jitter];
	printf("mean latency = %d\n",position_y[per_jitter]);
	
	
	//---------------------------------------------------------------------
	// SSD 0		
	if (curr_soa == SOA_list[0])
		{
		oSetAttribute(object_soa0,aFILLED);
		oSetAttribute(object_soa0,aVISIBLE);
		oMove(object_soa0,position_x,position_y[0]);	
		}
	//---------------------------------------------------------------------
	// SSD 1		
	if (curr_soa == SOA_list[1])
		{
		oSetAttribute(object_soa1,aFILLED);
		oSetAttribute(object_soa1,aVISIBLE);
		oMove(object_soa1,position_x,position_y[1]);	
		}
	//---------------------------------------------------------------------
	// SSD 2		
	if (curr_soa == SOA_list[2])
		{
		oSetAttribute(object_soa2,aFILLED);
		oSetAttribute(object_soa2,aVISIBLE);
		oMove(object_soa2,position_x,position_y[2]);	
		}
	//---------------------------------------------------------------------
	// SSD 3		
	if (curr_soa == SOA_list[3])
		{
		oSetAttribute(object_soa3,aFILLED);
		oSetAttribute(object_soa3,aVISIBLE);
		oMove(object_soa3,position_x,position_y[3]);	
		}
	//---------------------------------------------------------------------
	// SSD 4		
	if (curr_soa == SOA_list[4])
		{
		oSetAttribute(object_soa4,aFILLED);
		oSetAttribute(object_soa4,aVISIBLE);
		oMove(object_soa4,position_x,position_y[4]);	
		}
	//---------------------------------------------------------------------
	// SSD 5		
	if (curr_soa == SOA_list[5])
		{
		oSetAttribute(object_soa5,aFILLED);
		oSetAttribute(object_soa5,aVISIBLE);
		oMove(object_soa5,position_x,position_y[5]);	
		}
	//---------------------------------------------------------------------
	// SSD 6		
	if (curr_soa == SOA_list[6])
		{
		oSetAttribute(object_soa6,aFILLED);
		oSetAttribute(object_soa6,aVISIBLE);
		oMove(object_soa6,position_x,position_y[6]);	
		}
	//---------------------------------------------------------------------
	// SSD 7		
	if (curr_soa == SOA_list[7])
		{
		oSetAttribute(object_soa7,aFILLED);
		oSetAttribute(object_soa7,aVISIBLE);
		oMove(object_soa7,position_x,position_y[7]);	
		}
	//---------------------------------------------------------------------
	// SSD 8		
	if (curr_soa == SOA_list[8])
		{
		oSetAttribute(object_soa8,aFILLED);
		oSetAttribute(object_soa8,aVISIBLE);
		oMove(object_soa8,position_x,position_y[8]);	
		}
	//---------------------------------------------------------------------
	// SSD 9		
	if (curr_soa == SOA_list[9])
		{
		oSetAttribute(object_soa9,aFILLED);
		oSetAttribute(object_soa9,aVISIBLE);
		oMove(object_soa9,position_x,position_y[9]);	
		}
	//---------------------------------------------------------------------
	// SSD 10		
	if (curr_soa == SOA_list[10])
		{
		oSetAttribute(object_soa10,aFILLED);
		oSetAttribute(object_soa10,aVISIBLE);
		oMove(object_soa10,position_x,position_y[10]);	
		}
	//---------------------------------------------------------------------
	// SSD 11		
	if (curr_soa == SOA_list[11])
		{
		oSetAttribute(object_soa11,aFILLED);
		oSetAttribute(object_soa11,aVISIBLE);
		oMove(object_soa11,position_x,position_y[11]);	
		}
	//---------------------------------------------------------------------
	// SSD 12		
	if (curr_soa == SOA_list[12])
		{
		oSetAttribute(object_soa12,aFILLED);
		oSetAttribute(object_soa12,aVISIBLE);
		oMove(object_soa12,position_x,position_y[12]);	
		}
	//---------------------------------------------------------------------
	// SSD 13		
	if (curr_soa == SOA_list[13])
		{
		oSetAttribute(object_soa13,aFILLED);
		oSetAttribute(object_soa13,aVISIBLE);
		oMove(object_soa13,position_x,position_y[13]);	
		}
	//---------------------------------------------------------------------
	// SSD 14		
	if (curr_soa == SOA_list[14])
		{
		oSetAttribute(object_soa14,aFILLED);
		oSetAttribute(object_soa14,aVISIBLE);
		oMove(object_soa14,position_x,position_y[14]);	
		}
	//---------------------------------------------------------------------
	// SSD 15		
	if (curr_soa == SOA_list[15])
		{
		oSetAttribute(object_soa15,aFILLED);
		oSetAttribute(object_soa15,aVISIBLE);
		oMove(object_soa15,position_x,position_y[15]);	
		}
	//---------------------------------------------------------------------
	// SSD 16		
	if (curr_soa == SOA_list[16])
		{
		oSetAttribute(object_soa16,aFILLED);
		oSetAttribute(object_soa16,aVISIBLE);
		oMove(object_soa16,position_x,position_y[16]);	
		}
	//---------------------------------------------------------------------
	// SSD 17		
	if (curr_soa == SOA_list[17])
		{
		oSetAttribute(object_soa17,aFILLED);
		oSetAttribute(object_soa17,aVISIBLE);
		oMove(object_soa17,position_x,position_y[17]);	
		}
	//---------------------------------------------------------------------
	// SSD 18		
	if (curr_soa == SOA_list[18])
		{
		oSetAttribute(object_soa18,aFILLED);
		oSetAttribute(object_soa18,aVISIBLE);
		oMove(object_soa18,position_x,position_y[18]);	
		}
	//---------------------------------------------------------------------
	// SSD 19		
	if (curr_soa == SOA_list[19])
		{
		oSetAttribute(object_soa19,aFILLED);
		oSetAttribute(object_soa19,aVISIBLE);
		oMove(object_soa19,position_x,position_y[19]);	
		}
		
}