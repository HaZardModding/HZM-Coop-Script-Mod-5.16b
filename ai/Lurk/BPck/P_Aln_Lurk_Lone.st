//
// Name:     Lurker_PackageLoneLurker
// Purpose:  AI for Lurkers in a group of 2 or fewer 
//

//
// Includes
//
$include ai/lurk/glob/GP_Aln_Lurk_Lone.st

//
// Defines
//

$define RANGE_RETREAT 							 192
$define RANGE_SPAR								 225
$define RANGE_CHARGE							 200
$define RANGE_MELEE_COMBAT 						 112
$define RANGE_MELEE_MIN							  88
$define DISTANCE_STRAFE							  64
$define CHANCE_ATTACK							 .65
$define CHANCE_ATTACK_WHILE_IN_SPARRING_RANGE 	 .55
$define CHANCE_STRAFE_AFTER_BEING_ATTACKED 		 .80
$define CHANCE_STRAFE_WHILE_IN_CONE_OF_FIRE		 .45
$define CHANCE_SIDESTEP_WHILE_IN_CONE_OF_FIRE	 .75
$define CHANCE_SIDESTEP_AFTER_RETREAT			 .55
$define CHANCE_SPLIT							 .50
$define CHANCE_APPROACH_RUNNING 				 .65
$define	CHANCE_CRASH_ATTACK 					 .35
$define CHANCE_DO_SPRAY_ATTACK 					 .35
$define CHANCE_DO_CHARGE_ATTACK 				 .15
$define CHANCE_TO_RETREAT						 .65
$define CHANCE_BLIND_ATTACK						0.5
$define CHANCE_COMBO_1							.25
$define CHANCE_COMBO_3							.35

//---------------------------------------------------------
state START// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		evaluateenemies
		}

	states
		{
		FIRST_ATTACK : default
		}
	}

//---------------------------------------------------------
state FIRST_ATTACK// ()
//---------------------------------------------------------
	{
	states
		{
		//SPRAY_ATTACK	: !HAVE_PATH_TO_ENEMY SHOULD_DO_ACTION ( "fire" )
		CHARGE 	: default		
		}
	}

//---------------------------------------------------------
state THINK// ()
//---------------------------------------------------------
	{
	states
		{
		BACK_PEDAL 	: RANGE ( $RANGE_RETREAT$ ) CHANCE ( $CHANCE_TO_RETREAT$ )
		ATTACK 		: CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN 	: !RANGE ( $RANGE_SPAR$ )
		ATTACK 		: CHANCE ( $CHANCE_ATTACK_WHILE_IN_SPARRING_RANGE$ )
		SIDESTEP   	: default		
		}
	}

//---------------------------------------------------------
state BACK_PEDAL
//---------------------------------------------------------
	{
	Behavior BackAwayFromEnemy ( "backpedal" , 128.0 , 64.0 , 1 )

	states
		{
		SIDESTEP : BEHAVIOR_DONE CHANCE ( $CHANCE_SIDESTEP_AFTER_RETREAT$ )		
		THINK : BEHAVIOR_DONE
		}
	}


//---------------------------------------------------------
state STRAFE// ()
//---------------------------------------------------------
	{
	states
		{
		STRAFE_LEFT		: CHANCE ( $CHANCE_SPLIT$ ) LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		STRAFE_RIGHT	: RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		HOLD			: default
		}
	}

//---------------------------------------------------------
state STRAFE_LEFT// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	Behavior Strafe ( 0 )

	states
		{
		ATTACK				: BEHAVIOR_SUCCESS CHANCE ( $CHANCE_ATTACK$ )
		ATTACK				: BEHAVIOR_FAILED CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN			: BEHAVIOR_SUCCESS !RANGE ( $RANGE_SPAR$ )
		CLOSE_IN			: BEHAVIOR_FAILED !RANGE ( $RANGE_SPAR$ )
		STRAFE_LEFT_RESET	: BEHAVIOR_SUCCESS LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK				: BEHAVIOR_SUCCESS
		THINK				: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state STRAFE_LEFT_RESET// ()
//---------------------------------------------------------
	{
	states
		{
		STRAFE_LEFT : default
		}
	}

//---------------------------------------------------------
state STRAFE_RIGHT// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	Behavior Strafe ( 1 )

	states
		{
		ATTACK				: BEHAVIOR_SUCCESS CHANCE ( $CHANCE_ATTACK$ )
		ATTACK				: BEHAVIOR_FAILED CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN			: BEHAVIOR_SUCCESS !RANGE ( $RANGE_SPAR$ )
		CLOSE_IN			: BEHAVIOR_FAILED !RANGE ( $RANGE_SPAR$ )
		STRAFE_LEFT_RESET	: BEHAVIOR_SUCCESS RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK 				: BEHAVIOR_SUCCESS
		THINK 				: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state STRAFE_RIGHT_RESET// ()
//---------------------------------------------------------
	{
	states
		{
		STRAFE_RIGHT : default
		}
	}


//---------------------------------------------------------
state SIDESTEP// ()
//---------------------------------------------------------
	{
	states
		{
		SIDESTEP_LEFT	: CHANCE ( $CHANCE_SPLIT$ ) 
		SIDESTEP_RIGHT	: default		
		}
	}

//---------------------------------------------------------
state ATTEMPT_SIDESTEP_LEFT// ()
//---------------------------------------------------------
	{
	states
		{
		SIDESTEP_LEFT	: LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		SIDESTEP_RIGHT  : RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		ATTACK			: default
		}
	}

//---------------------------------------------------------
state ATTEMPT_SIDESTEP_RIGHT// ()
//---------------------------------------------------------
	{
	states
		{
		SIDESTEP_RIGHT  : RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		SIDESTEP_LEFT	: LEFT_CLEAR ( $DISTANCE_STRAFE$ )		
		ATTACK			: default
		}
	}

//---------------------------------------------------------
state SIDESTEP_LEFT// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		sidestep_left : default
		}

	states
		{
		BACK_PEDAL			: RANGE ( $RANGE_RETREAT$ )
		ATTACK				: ANIM_DONE CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN			: ANIM_DONE !RANGE ( $RANGE_SPAR$ )
		SIDESTEP_LEFT_RESET : ANIM_DONE LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK				: ANIM_DONE
		}
	}

//---------------------------------------------------------
state SIDESTEP_LEFT_RESET// ()
//---------------------------------------------------------
	{
	states
		{
		SIDESTEP_LEFT : default
		}
	}

//---------------------------------------------------------
state SIDESTEP_RIGHT// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		sidestep_right : default
		}

	states
		{
		BACK_PEDAL				: RANGE ( $RANGE_RETREAT$ )
		ATTACK					: ANIM_DONE CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN				: ANIM_DONE !RANGE ( $RANGE_SPAR$ )
		SIDESTEP_RIGHT_RESET	: ANIM_DONE RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK 					: ANIM_DONE
		}
	}

//---------------------------------------------------------
state SIDESTEP_RIGHT_RESET// ()
//---------------------------------------------------------
	{
	states
		{
		SIDESTEP_RIGHT : default
		}
	}

//---------------------------------------------------------
state CLOSE_IN
//---------------------------------------------------------
	{
	states
		{
		CLOSE_IN_RUN	: CHANCE ( $CHANCE_APPROACH_RUNNING )
		CLOSE_IN_WALK	: default
		}
	}

//---------------------------------------------------------
state CLOSE_IN_WALK// ()
//---------------------------------------------------------
	{
	behavior CloseInOnEnemy ( "walk" , $RANGE_SPAR$ )
	time ( .75 )

	states
		{
		HOLD         : BEHAVIOR_FAILED
		ATTACK 		 : RANGE ( $RANGE_SPAR$ )
		STRAFE		 : ATTACKED CHANCE ( $CHANCE_STRAFE_AFTER_BEING_ATTACKED$ )
		STRAFE	 	 : TIME_DONE IN_CONE_OF_FIRE CHANCE ( $CHANCE_STRAFE_WHILE_IN_CONE_OF_FIRE$ )
		SIDESTEP 	 : TIME_DONE IN_CONE_OF_FIRE CHANCE ( $CHANCE_SIDESTEP_WHILE_IN_CONE_OF_FIRE$ )
		CHARGE		 : TIME_DONE !RANGE ( $RANGE_CHARGE$ )
		THINK        : BEHAVIOR_SUCCESS
		}
	}

//---------------------------------------------------------
state CLOSE_IN_RUN// ()
//---------------------------------------------------------
	{
	ignoreglobalstate

	behavior CloseInOnEnemy ( "run" , $RANGE_SPAR$ )
	time ( 1 )

	states
		{
		HOLD         : BEHAVIOR_FAILED
		ATTACK 		 : RANGE ( $RANGE_SPAR$ )
		STRAFE		 : ATTACKED CHANCE ( $CHANCE_STRAFE_AFTER_BEING_ATTACKED$ )
		STRAFE	 	 : TIME_DONE IN_CONE_OF_FIRE CHANCE ( $CHANCE_STRAFE_WHILE_IN_CONE_OF_FIRE$ )
		SIDESTEP 	 : TIME_DONE IN_CONE_OF_FIRE CHANCE ( $CHANCE_SIDESTEP_WHILE_IN_CONE_OF_FIRE$ )
		SPRAY_ATTACK : TIME_DONE SHOULD_DO_ACTION ( "fire" )
		THINK        : BEHAVIOR_SUCCESS
		}
	}

//---------------------------------------------------------
state CHARGE// ()
//---------------------------------------------------------
	{
	Behavior WatchEntity ( 2.0 , 20 , "pre_charge_attack" , 1 , "pre_charge_attack" )

	states
		{
		SPRAY_HOLD	: BEHAVIOR_DONE !HAVE_PATH_TO_ENEMY SHOULD_DO_ACTION ( "fire" )
		CHARGE_ATTACK : BEHAVIOR_DONE
		}

	exitcommands
		{
		evaluateenemies
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK// ()
//---------------------------------------------------------
	{
	Behavior CloseInOnEnemy ( "attack_charge_run" , $RANGE_MELEE_COMBAT$ )

	time ( 3.5 )

	states
		{
		CHARGE_ATTACK_REEVALUATE	: BEHAVIOR_FAILED
		CHARGE_ATTACK_MELEE			: RANGE ( $RANGE_CHARGE$ ) CAN_ATTACK_ENEMY
		THINK						: RANGE ( $RANGE_CHARGE$ ) !CAN_ATTACK_ENEMY
		CHARGE_ATTACK_MELEE			: BEHAVIOR_SUCCESS
		THINK						: TIME_DONE
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK_REEVALUATE// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		evaluateenemies
		}

	Behavior WatchEntity ( .75 , 10 , "idle" )

	states
		{
		CHARGE_ATTACK_RETRY : BEHAVIOR_SUCCESS
		CHARGE_ATTACK_RETRY : BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK_RETRY// ()
//---------------------------------------------------------
	{
	Behavior CloseInOnEnemy ( "attack_charge_run" , $RANGE_MELEE_COMBAT$ )

	time ( 1.5 )

	states
		{
		HOLD                : BEHAVIOR_FAILED
		CHARGE_ATTACK_MELEE : RANGE ( $RANGE_MELEE_COMBAT$ )
		CHARGE_ATTACK_MELEE : BEHAVIOR_SUCCESS
		THINK				: TIME_DONE
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK_MELEE// ()
//---------------------------------------------------------
	{
	ignoreglobalstate

	states
		{
		CHARGE_ATTACK_CRASH		: CHANCE ( $CHANCE_CRASH_ATTACK$ )
		CHARGE_ATTACK_POUNCE	: default
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK_POUNCE// ()
//---------------------------------------------------------
{
	ignoreglobalstate

	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		attack_charge_pounce : default		
		}

	states
		{
		THINK : ANIM_DONE
		}
}

//---------------------------------------------------------
state CHARGE_ATTACK_CRASH// ()
//---------------------------------------------------------
{
	ignoreglobalstate

	entrycommands
		{
		turntowardsenemy
		}

	legs
		{		
		crash : default
		}

	states
		{
		THINK : ANIM_DONE
		}
}

//---------------------------------------------------------
state ATTACK// ()
//---------------------------------------------------------
	{
	ignoreglobalstate

	states
		{
		SPRAY_ATTACK	: !HAVE_PATH_TO_ENEMY SHOULD_DO_ACTION ( "fire" )
		CHARGE			: CHANCE ( $CHANCE_DO_CHARGE_ATTACK$ ) !RANGE ( $RANGE_CHARGE$ )
		MELEE_ATTACK	: default
		}
	}

//---------------------------------------------------------
state MELEE_ATTACK// ()
//---------------------------------------------------------
	{
	states
		{
		MELEE_ATTACK_COMBO		: RANGE ( $RANGE_MELEE_COMBAT$ )
		MELEE_ATTACK_APPROACH	: default
		}
	}

//---------------------------------------------------------
state MELEE_ATTACK_APPROACH// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	states
		{
		DO_MELEE_ATTACK_APPROACH : default
		}
	}

//---------------------------------------------------------
state DO_MELEE_ATTACK_APPROACH// ()
//---------------------------------------------------------
{

	Behavior CloseInOnEnemy ( "run" , $RANGE_MELEE_COMBAT$ )
	time ( 3.0 )

	states
		{
		MELEE_ATTACK_COMBO			: RANGE ( $RANGE_MELEE_COMBAT$ )
		//MELEE_ATTACK_APPROACH_HOLD	: BEHAVIOR_FAILED
		SPRAY_ATTACK				: BEHAVIOR_FAILED
		MELEE_ATTACK_APPROACH		: BEHAVIOR_DONE
		CHARGE						: TIME_DONE !RANGE ( $RANGE_CHARGE$ )
		THINK						: TIME_DONE
		}
}

//---------------------------------------------------------
state MELEE_ATTACK_APPROACH_HOLD// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		headwatchtarget enemy
		}

	legs
		{
		idle : default
		}

	Behavior WatchEntity ( .75 , 20 , "idle" )

	states
		{
		CHARGE_ATTACK_MELEE : BEHAVIOR_SUCCESS
		CHARGE_ATTACK_MELEE : BEHAVIOR_FAILED
		}

	}

//---------------------------------------------------------
state MELEE_ATTACK_COMBO// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	states
		{
		DO_MELEE_ATTACK_COMBO : default
		}

	}

//---------------------------------------------------------
state DO_MELEE_ATTACK_COMBO// ()
//---------------------------------------------------------
	{
	states
		{
		DO_COMBO_ATTACK1 : CHANCE ( $CHANCE_COMBO_1$ )
		DO_COMBO_ATTACK3 : CHANCE ( $CHANCE_COMBO_3$ )
		DO_COMBO_ATTACK2 : default
		}

	}

//---------------------------------------------------------
state DO_COMBO_ATTACK1// ()
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	Behavior WatchEntity ( 2.0 , 20 , "attackcombo1" , 1 , "attackcombo1" )
	time ( 1.0 )

	states
		{
		MELEE_BACKPEDAL : BEHAVIOR_DONE RANGE ( $RANGE_MELEE_MIN$ )
		THINK : !RANGE ( $RANGE_MELEE_COMBAT$ ) TIME_DONE
		THINK : BEHAVIOR_DONE
		}
}

//---------------------------------------------------------
state DO_COMBO_ATTACK2// ()
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	Behavior WatchEntity ( 2.0 , 20 , "attackcombo2" , 1 , "attackcombo2" )
	time ( 1.0 )

	states
		{
		MELEE_BACKPEDAL : BEHAVIOR_DONE RANGE ( $RANGE_MELEE_MIN$ )
		THINK : !RANGE ( $RANGE_MELEE_COMBAT$ ) TIME_DONE
		THINK : BEHAVIOR_DONE
		}
}

//---------------------------------------------------------
state DO_COMBO_ATTACK3// ()
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	Behavior WatchEntity ( 2.0 , 20 , "attackcombo3" , 1 , "attackcombo3" )
	time ( 1.0 )

	states
		{
		MELEE_BACKPEDAL : BEHAVIOR_DONE RANGE ( $RANGE_MELEE_MIN$ )
		THINK : !RANGE ( $RANGE_MELEE_COMBAT$ ) TIME_DONE
		THINK : BEHAVIOR_DONE
		}
}

//---------------------------------------------------------
state MELEE_BACKPEDAL// ()
//---------------------------------------------------------
{
	legs 
		{
		backpedal : default
		}

	//Behavior BackAwayFromEnemy ( "backpedal" , 128.0 , 64.0 , 1 )

	states
		{
		//SIDESTEP : BEHAVIOR_DONE CHANCE ( $CHANCE_SIDESTEP_AFTER_RETREAT$ )		
		//THINK : BEHAVIOR_DONE
		THINK : ANIM_DONE
		}
}

//---------------------------------------------------------
state SPRAY_ATTACK// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	states
		{
		DO_SPRAY_ATTACK : default
		}
	}

//---------------------------------------------------------
state DO_SPRAY_ATTACK// ()
//---------------------------------------------------------
	{
	ignoreglobalstate

	Behavior DoAttack ( "attack_sprayspit" , 10 , 0 , "idle" )

	states
		{
		SPRAY_HOLD	: !CAN_ATTACK_ENEMY
		THINK   : !CAN_ATTACK_ENEMY HAVE_PATH_TO_ENEMY
		THINK	: BEHAVIOR_SUCCESS HAVE_PATH_TO_ENEMY
		THINK 	: BEHAVIOR_FAILED HAVE_PATH_TO_ENEMY
		SPRAY_ATTACK	: BEHAVIOR_SUCCESS
		SPRAY_ATTACK 	: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state SPRAY_HOLD_BLIND_ATTACK// ()
//---------------------------------------------------------
{
	ignoreglobalstate
	
	Behavior WatchEntity ( 10 , 10 , "attack_sprayspit" , 1 , "attack_sprayspit" )
	states
	{
		THINK : CAN_ATTACK_ENEMY
		SPRAY_HOLD : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state SPRAY_HOLD// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		headwatchtarget enemy
		}

	Behavior WatchEntity ( .75 , 10 , "idle" , 0 , "idle" )

	states
		{
		SPRAY_HOLD_BLIND_ATTACK : BEHAVIOR_DONE CHANCE ( $CHANCE_BLIND_ATTACK$ )
		SPRAY_ATTACK	: BEHAVIOR_SUCCESS
		SPRAY_ATTACK	: BEHAVIOR_FAILED
		SPRAY_ATTACK	: BEHAVIOR_DONE
		}
	}


//---------------------------------------------------------
state HOLD// ()
//---------------------------------------------------------
	{
	entrycommands
		{
		headwatchtarget enemy
		}

	Behavior WatchEntity ( 1.75 , 10 , "idle" )

	states
		{
		CHARGE	: BEHAVIOR_SUCCESS
		SEEK	: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state SEEK// ()
//---------------------------------------------------------
	{
	Behavior CloseInOnEnemy ( "run" , 256 )

	states
		{
		THINK	: CAN_SEE_ENEMY
		HOLD	: BEHAVIOR_FAILED
		}
	}


//---------------------------------------------------------
state DEATH// ()
//---------------------------------------------------------
	{
	legs
		{
		death_gib : CHANCE ( .35 ) !MOD ( "electric" )
		death : default
		}
	}