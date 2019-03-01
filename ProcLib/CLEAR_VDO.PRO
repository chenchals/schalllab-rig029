
declare CLEAR_VDO();

process CLEAR_VDO()
{
	printf("Clearing Screen\n");
	dsendf("cl\n");
}