//-----------------------------------------------------------------------------------------------------
// End a trial without imposing any iti or trial length, and without
// giving any rewards or punishments.
//
// written by david.c.godlove@vanderbilt.edu 	January, 2011
#include C:/TEMPO/ProcLib/SEND_EVT.PRO
declare ABORT();

process ABORT()
	{

	declare hide int run_cmd_sess = 1;	// state 1 is countermanding
	declare hide int run_mg_sess = 3;	// state 3 is mem guided sacc
	declare hide int run_gonogo_sess = 4;
	declare hide int run_delayed_sess = 6;
	declare hide int run_search_sess = 7;
	declare hide int run_anti_sess = 9;

	spawn SEND_EVT(Abort_);
	spawn SEND_EVT(Eot_);

	nexttick 2;

	spawnwait INFOS();

	nexttick 15;

	spawn SEND_EVT(TaskEnd_);

	// Setuop for next trial
	if (State == run_cmd_sess)
		{
		spawnwait SETC_TRL(n_targ_pos,
					go_weight,
					stop_weight,
					ignore_weight,
					staircase,
					n_SSDs,
					min_holdtime,
					max_holdtime,
					expo_jitter);

		}
	else if (State == run_mg_sess)
		{
		spawnwait SETMGTRL(n_targ_pos,
				 go_weight,
				 stop_weight,
				 ignore_weight,
				 n_SOAs,
				 min_holdtime,
				 max_holdtime,
				 expo_jitter,
				 expo_jitter_soa);
		}

	else if (State == run_gonogo_sess)
		{
		spawnwait SETG_TRL(n_targ_pos,
				min_holdtime,
				max_holdtime,
				expo_jitter,
				min_soa,
				max_soa,
				expo_jitter_soa);
		}

	else if (State == run_delayed_sess)
		{
		spawnwait SETD_TRL(n_targ_pos,
				min_holdtime,
				max_holdtime,
				expo_jitter,
				min_soa,
				max_soa,
				expo_jitter_soa);
		}

	}
