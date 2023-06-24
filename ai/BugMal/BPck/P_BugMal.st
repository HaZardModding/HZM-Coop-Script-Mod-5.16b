$define RANGE_MELEE_MAX 184
$define RANGE_MELEE_MIN 160

//-------------------------------------------------------------
state START
//-------------------------------------------------------------
	{
	legs
		{
		crawl_out : default
		}

	states
		{
		THINK : ANIM_DONE
		}
	}
//-------------------------------------------------------------
state THINK
//-------------------------------------------------------------
	{
	states
		{
		PAIN				: SHOW_PAIN
		CLOSE_IN_ON_ENEMY	: default
		}
	}

//---------------------------------------------------------
state CLOSE_IN_ON_ENEMY
//---------------------------------------------------------
	{
	behavior CloseInOnEnemy ( "run" , $RANGE_MELEE_MIN$ )

	states
		{
		PAIN				: SHOW_PAIN
		START_MELEE_ATTACKS	: BEHAVIOR_SUCCESS
		STOP_WALK_FAILED	: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state STOP_WALK_FAILED
//---------------------------------------------------------
	{
	behavior WatchEntity  ( 100 , 20 , "from_run" , 1 )

	states
		{
		PAIN	: SHOW_PAIN
		HOLD	: BEHAVIOR_DONE
		}
	}


//---------------------------------------------------------
state HOLD
//---------------------------------------------------------
	{
	behavior WatchEntity  ( 100 , 20 , "idle" , 1 )

	time ( .15 )

	states
		{
		PAIN	: SHOW_PAIN
		THINK	: TIME_DONE
		}
	}

//---------------------------------------------------------
state PAIN
//---------------------------------------------------------
{
	states
		{
		PAIN_GENERAL : default
		}
}

//---------------------------------------------------------
state PAIN_GENERAL
//---------------------------------------------------------
{
	legs
		{
		pain : default
		}

	states
		{
		THINK : ANIM_DONE  		
		}
}

state START_MELEE_ATTACKS
	{
	states
		{
		MELEE_STING_ATTACK	: CHANCE ( .5 )
		MELEE_SNAP_ATTACK	: default
		}
	}


//---------------------------------------------------------
state MELEE_STING_ATTACK
//---------------------------------------------------------
	{
	behavior WatchEntity  ( 100 , 20 , "attack_2" , 1 , "attack_2" )

	states
		{
		START_MELEE_ATTACKS : BEHAVIOR_DONE RANGE ( $RANGE_MELEE_MAX$ )
		CLOSE_IN_ON_ENEMY : BEHAVIOR_DONE
		}
	}


//---------------------------------------------------------
state MELEE_SNAP_ATTACK
//---------------------------------------------------------
	{
	behavior WatchEntity  ( 100 , 20 , "attack_1" , 1 , "attack_1" )

	states
		{
		START_MELEE_ATTACKS : BEHAVIOR_DONE RANGE ( $RANGE_MELEE_MAX$ )
		CLOSE_IN_ON_ENEMY : BEHAVIOR_DONE
		}
	}