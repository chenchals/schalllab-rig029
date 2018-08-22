#pragma declare = 1;



#include C:/TEMPO/ProcLib/DIO.pro
#include C:/TEMPO/ProcLib/SEND_TTL.pro
#include C:/TEMPO/ProcLib/WAIT_MU.pro
declare main();

process main() enabled
	{
	declare int send_now;
	declare int value = 1;
	while(1)
		{
		if (send_now == 1)
			{
			spawn SEND_TTL(value);
			send_now = 0;
			}
		nexttick;
		}
	}


