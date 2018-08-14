declare CHECK_PA();

process CHECK_PA()
{

	declare hide int it;
	declare hide float equalTol = .01;
	
	// Decide which difficulties are pro or anti
	it = 0;
	while (it < ntDifficulties)
	{
		tIsPro[it] = 0;
		tIsAnti[it] = 0;
		//tIsCatch[it] = 0;
		if ((stimVertical[it] - stimHorizontal[it]) > equalTol)
			{
			tIsPro[it] = 1;
			//tIsAnti[it] = 0;
			//tIsCatch[it] = 0;
			}
		else if ((stimHorizontal[it] - stimVertical[it]) > equalTol)
			{
			//tIsPro[it] = 0;
			tIsAnti[it] = 1;
			//tIsCatch[it] = 0;
			}
		// This if statement should work because it's in an else... a negative value < -equaltol
		// should have been caught by the first if
		else if (((stimHorizontal[singDifficulty] - stimVertical[singDifficulty]) < equalTol) || ((stimVertical[singDifficulty] - stimHorizontal[singDifficulty]) < equalTol))
			{
			//tIsPro[it] = 0;
			//tIsAnti[it] = 0;
			tIsCatch[it] = 1;
			}
		it = it+1;
		
	}
	nexttick;

	
	// We need to repeat the above to assign distractor pro/anti/catch diffs
	it = 0;
	while (it < ndDifficulties)
	{
		// We need to repeat the above to assign distractor pro/anti/catch diffs
		if ((distV[it] - distH[it]) > equalTol)
			{
			dIsPro[it] = 1;
			//dIsAnti[it] = 0;
			//dIsCatch[it] = 0;
			}
		else if ((distH[it] - distV[it]) > equalTol)
			{
			//dIsPro[it] = 0;
			dIsAnti[it] = 1;
			//dIsCatch[it] = 0;
			}
		
		// This if statement should work because it's in an else... a negative value < -equaltol
		// should have been caught by the first if
		else if (((distH[singDifficulty] - distV[singDifficulty]) < equalTol) || ((distV[singDifficulty] - distH[singDifficulty]) < equalTol))
			{
			//dIsPro[it] = 0;
			//dIsAnti[it] = 0;
			dIsCatch[it] = 1;
			}
		it = it+1;
	}
	nexttick;
}