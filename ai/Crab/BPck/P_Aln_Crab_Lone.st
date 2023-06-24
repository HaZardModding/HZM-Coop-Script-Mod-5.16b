//
// Includes
//
$include ai/crab/glob/GP_Aln_Crab_Lone.st

//
// Defines
//

//---------------------------------------------------------
$define RANGE_RETREAT							192
$define RANGE_SPAR								350
$define RANGE_CHARGE							300
$define RANGE_MELEE_COMBAT 						128
$define DISTANCE_STRAFE							64
$define MIN_TIME_CIRCLESTRAFE					0.7
$define MAX_TIME_CIRCLESTRAFE					1.3
$define CHANCE_ATTACK							.65
$define CHANCE_ATTACK_WHILE_IN_SPARRING_RANGE 	.85
$define CHANCE_DODGE_WHILE_IN_CONE_OF_FIRE		0.4
$define CHANCE_SPLIT							.30
$define CHANCE_APPROACH_RUNNING 				.50
$define CHANCE_DO_CHARGE_ATTACK 				.70
$define CHANCE_TAUNT							.30
//$define	CHANCE_TWITCH							 .10

//---------------------------------------------------------

//---------------------------------------------------------
state START
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "START" )
	}
	states
	{
		FIRST_ATTACK : default
	}
}

//---------------------------------------------------------
state FIRST_ATTACK // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "FIRST_ATTACK" )
	}
	states
	{
		THINK 	: default
	}
}

//---------------------------------------------------------
state THINK // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "THINK" )
		clearCurrentEnemy
		evaluateenemies
		turntowardsenemy
	}

	states
	{
		DODGE 	 		: IN_CONE_OF_FIRE CHANCE ( $CHANCE_DODGE_WHILE_IN_CONE_OF_FIRE$ )
		//TWITCH			: CHANCE ( $CHANCE_TWITCH$ )
		MELEE_ATTACK 	: RANGE ( $RANGE_MELEE_COMBAT$ )
		//BACK_PEDAL 		: RANGE ( $RANGE_RETREAT$ )
		ATTACK 			: CAN_ATTACK_ENEMY CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN 		: !RANGE ( $RANGE_SPAR$ )
		ATTACK 			: CAN_ATTACK_ENEMY CHANCE ( $CHANCE_ATTACK_WHILE_IN_SPARRING_RANGE$ )
		DODGE   		: default
	}
}

//---------------------------------------------------------
//state BACK_PEDAL
//---------------------------------------------------------
//	{
//	Behavior BackAwayFromEnemy ( "backpedal" , 128.0 , 64.0 )
//
//	states
//		{
//		MELEE_ATTACK 	: RANGE ( $RANGE_MELEE_COMBAT$ )
//		DODGE 		: BEHAVIOR_SUCCESS
//		DODGE 		: BEHAVIOR_FAILED
//		}
//	}


//---------------------------------------------------------
state DODGE
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "DOGE" )
	}
	
	states
	{
		DODGE_LEFT	: CHANCE ( $CHANCE_SPLIT$ ) LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		DODGE_RIGHT	: RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		ATTACK		: default
	}
}

//---------------------------------------------------------
state DODGE_LEFT
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "DOGE_LEFT" )
		turntowardsenemy
	}

	legs
	{
		dodgeL : default
	}

	states
	{
		//BACK_PEDAL			: RANGE ( $RANGE_RETREAT$ )
		ATTACK				: ANIM_DONE CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN			: ANIM_DONE !RANGE ( $RANGE_SPAR$ )
		DODGE_LEFT_RESET 	: ANIM_DONE LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK				: ANIM_DONE
	}
}

//---------------------------------------------------------
state DODGE_LEFT_RESET
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "DOGE_LEFT_RESET" )
	}
	
	states
	{
		DODGE_LEFT : default
	}
}

//---------------------------------------------------------
state DODGE_RIGHT
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "DOGE_RIGHT" )
		turntowardsenemy
	}

	legs
	{
		dodgeR : default
	}

	states
	{
		//BACK_PEDAL				: RANGE ( $RANGE_RETREAT$ )
		ATTACK					: ANIM_DONE CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN				: ANIM_DONE !RANGE ( $RANGE_SPAR$ )
		DODGE_RIGHT_RESET		: ANIM_DONE RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK 					: ANIM_DONE
	}
}

//---------------------------------------------------------
state DODGE_RIGHT_RESET
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "DODGE_RIGHT_RESET" )
	}
	
	states
	{
		DODGE_RIGHT : default
	}
}

//---------------------------------------------------------
state SIDESTEP
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SIDESTEP" )
	}
	
	states
	{
		SIDESTEP_LEFT	: CHANCE ( $CHANCE_SPLIT$ ) LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		SIDESTEP_RIGHT	: RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		ATTACK			: default
	}
}

//---------------------------------------------------------
state SIDESTEP_LEFT
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SIDESTEP_LEFT" )	
	}
	
	Behavior CircleStrafeEntity ( "enemy" , "sidestepL" , 64 , 1 )
	Time ( $MIN_TIME_CIRCLESTRAFE$ , $MAX_TIME_CIRCLESTRAFE$ )
	states
	{
		//BACK_PEDAL			: RANGE ( $RANGE_RETREAT$ )
		ATTACK				: TIME_DONE CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN			: TIME_DONE !RANGE ( $RANGE_SPAR$ )
		SIDESTEP_LEFT_RESET : TIME_DONE LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK				: TIME_DONE
	}
}

//---------------------------------------------------------
state SIDESTEP_LEFT_RESET
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SIDESTEP_LEFT_RESET" )
	}
	
	states
	{
		SIDESTEP_LEFT : default
	}
}

//---------------------------------------------------------
state SIDESTEP_RIGHT
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SIDESTEP_RIGHT" )
	}
	
	Behavior CircleStrafeEntity ( "enemy" , "sidestepR" , 64 , 0 )
	Time ( $MIN_TIME_CIRCLESTRAFE$ , $MAX_TIME_CIRCLESTRAFE$ )
	states
	{
		//BACK_PEDAL				: RANGE ( $RANGE_RETREAT$ )
		ATTACK					: TIME_DONE CHANCE ( $CHANCE_ATTACK$ )
		CLOSE_IN				: TIME_DONE !RANGE ( $RANGE_SPAR$ )
		SIDESTEP_RIGHT_RESET	: TIME_DONE RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		THINK 					: TIME_DONE
	}
}

//---------------------------------------------------------
state SIDESTEP_RIGHT_RESET
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SIDESTEP_RIGHT_RESET" )
	}
	
	states
	{
		SIDESTEP_RIGHT : default
	}
}

//---------------------------------------------------------
state CLOSE_IN
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "CLOSE_IN" )
	}
	
	states
	{
		CLOSE_IN_RUN	: CHANCE ( $CHANCE_APPROACH_RUNNING )
		CLOSE_IN_WALK	: default
	}
}

//---------------------------------------------------------
state CLOSE_IN_WALK
//---------------------------------------------------------
{
	
	entrycommands
	{
		//printmessage ( "CLOSE_IN_WALK" )
	}
	
	behavior CloseInOnEnemy ( "walk" , $RANGE_SPAR$ )
	time ( 1 )

	states
	{
		DODGE 	 			: IN_CONE_OF_FIRE CHANCE ( $CHANCE_DODGE_WHILE_IN_CONE_OF_FIRE$ )
		ATTACK 				: RANGE ( $RANGE_SPAR$ )
		TAUNT				: TIME_DONE CHANCE ( $CHANCE_TAUNT$ )
		PROJECTILE_ATTACK 	: TIME_DONE
		THINK         		: BEHAVIOR_FAILED
		THINK        		: BEHAVIOR_SUCCESS
	}
}

//---------------------------------------------------------
state CLOSE_IN_RUN
//---------------------------------------------------------
{
	ignoreglobalstate

	entrycommands
	{
		//printmessage ( "CLOSE_IN_RUN" )
	}
	
	behavior CloseInOnEnemy ( "run" , $RANGE_SPAR$ )
	time ( 1 )

	states
	{
		DODGE 	 			: IN_CONE_OF_FIRE CHANCE ( $CHANCE_DODGE_WHILE_IN_CONE_OF_FIRE$ )
		CLOSE_IN_ABORT		: PAIN
		THINK         		: BEHAVIOR_FAILED
		THINK        		: BEHAVIOR_SUCCESS
		ATTACK 		 		: RANGE ( $RANGE_SPAR$ )
		TAUNT				: TIME_DONE CHANCE ( $CHANCE_TAUNT$ )
		PROJECTILE_ATTACK 	: TIME_DONE
	}
}

//---------------------------------------------------------
state CHARGE
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "CHARGE" )
	}
	
	ignoreglobalstate
	Behavior WatchEntity ( 2.0 , 20 , "projectile_pre" , 1 , "projectile_pre" )

	states
	{
		CHARGE_ATTACK : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state CHARGE_ATTACK
//---------------------------------------------------------
{
	ignoreglobalstate
	
	entrycommands
	{
		//printmessage ( "CHARGE_ATTACK" )
	}
	
	Behavior CloseInOnEnemy ( "charge_run" , $RANGE_MELEE_COMBAT$ )

	time ( 1.5 )

	states
	{
		DODGE 	 					: IN_CONE_OF_FIRE CHANCE ( $CHANCE_DODGE_WHILE_IN_CONE_OF_FIRE$ )
		CLOSE_IN_ABORT				: PAIN
		CHARGE_ATTACK_REEVALUATE	: BEHAVIOR_FAILED
		CHARGE_ATTACK_MELEE			: RANGE ( $RANGE_CHARGE$ )
		CHARGE_ATTACK_MELEE			: BEHAVIOR_SUCCESS
		THINK						: TIME_DONE
	}
}

//---------------------------------------------------------
state CHARGE_ATTACK_REEVALUATE
//---------------------------------------------------------
{
	ignoreglobalstate
	entrycommands
	{
		//printmessage ( "CHARGE_ATTACK_REEVALUATE" )
		clearCurrentEnemy
		evaluateenemies
	}

	Behavior WatchEntity ( .75 , 10 , "idle" )

	states
	{
		CLOSE_IN_ABORT		: PAIN
		CHARGE_ATTACK_RETRY : BEHAVIOR_SUCCESS
		CHARGE_ATTACK_RETRY : BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state CHARGE_ATTACK_RETRY
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "CHARGE_ATTACK_RETRY" )
	}
	
	ignoreglobalstate
	Behavior CloseInOnEnemy ( "charge_run" , $RANGE_MELEE_COMBAT$ )

	time ( 1.5 )

	states
	{
		CLOSE_IN_ABORT		: PAIN
		HOLD                : BEHAVIOR_FAILED
		CHARGE_ATTACK_MELEE : RANGE ( $RANGE_MELEE_COMBAT$ )
		CHARGE_ATTACK_MELEE : BEHAVIOR_SUCCESS
		THINK				: TIME_DONE
	}
}

//---------------------------------------------------------
state CHARGE_ATTACK_MELEE
//---------------------------------------------------------
{
	ignoreglobalstate

	entrycommands
	{
		//printmessage ( "CHARGE_ATTACK_MELEE" )
		turntowardsenemy
	}

	legs
	{
		melee_spin : default
	}

	states
	{
		TAUNT : ANIM_DONE CHANCE ( $CHANCE_TAUNT$ )
		SIDESTEP : ANIM_DONE
	}
}

//---------------------------------------------------------
state TAUNT
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "TAUNT" )
	}
	
	Behavior WatchEntity ( 1.75 , 10 , "taunt" , 1  )

	states
	{
		THINK : BEHAVIOR_DONE
	}

}

//---------------------------------------------------------
//state TWITCH
//---------------------------------------------------------
//	{
//	Behavior WatchEntity ( 1.75 , 10 , "twitch" , 1  )
//
//	states
//		{
//		ATTACK 			: BEHAVIOR_DONE CAN_ATTACK_ENEMY CHANCE ( $CHANCE_ATTACK$ )
//		CLOSE_IN 		: BEHAVIOR_DONE !RANGE ( $RANGE_SPAR$ )
//		ATTACK 			: BEHAVIOR_DONE CAN_ATTACK_ENEMY CHANCE ( $CHANCE_ATTACK_WHILE_IN_SPARRING_RANGE$ )
//		DODGE   		: BEHAVIOR_DONE
//		}
//
//	}

//---------------------------------------------------------
state ATTACK
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "ATTACK" )
	}
	
	ignoreglobalstate

	states
	{
		MELEE_ATTACK 	: RANGE ( $RANGE_MELEE_COMBAT$ )
		CHARGE_ATTACK	: CHANCE ( $CHANCE_DO_CHARGE_ATTACK$ )

		PROJECTILE_FAST_ATTACK : CHANCE ( 0.5 )
		PROJECTILE_ATTACK	: default
	}
}

//---------------------------------------------------------
state MELEE_ATTACK
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "MELEE_ATTACK" )
		turntowardsenemy
	}

	Behavior WatchEntity ( 2.0 , 20 , "melee_" , 1 , "melee_" )
	time ( 1.0 )

	states
	{
		SIDESTEP 	: BEHAVIOR_SUCCESS
		SIDESTEP 	: BEHAVIOR_FAILED
	}
}



//---------------------------------------------------------
state PROJECTILE_ATTACK
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "PROJECTILE_ATTACK" )	
	}
	
	Behavior WatchEntity ( 2.0 , 20 , "projectile_pre" , 1 , "projectile_pre" )

	states
	{
		DO_PROJECTILE_ATTACK : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state DO_PROJECTILE_ATTACK
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "DO_PROJECTILE_ATTACK" )
	}

	ignoreglobalstate

	Behavior DoAttack ( "projectile_fire" , 10 , 0 , "idle" )

	states
	{
		DODGE : !CAN_ATTACK_ENEMY
		THINK	 : BEHAVIOR_SUCCESS
		THINK 	 : BEHAVIOR_FAILED
	}

}

//---------------------------------------------------------
state PROJECTILE_FAST_ATTACK
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "PROJECTILE_FAST_ATTACK" )
	}
	
	ignoreglobalstate

	Behavior DoAttack ( "projectile_full" , 10 , 0 , "idle" )

	states
	{
		DODGE : !CAN_ATTACK_ENEMY
		THINK	 : BEHAVIOR_SUCCESS
		THINK 	 : BEHAVIOR_FAILED
	}

}


//---------------------------------------------------------
state HOLD
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "HOLD" )
		headwatchtarget enemy
	}

	Behavior WatchEntity ( 1.75 , 10 , "idle" )

	states
	{
		THINK	: BEHAVIOR_SUCCESS
		THINK	: BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state SEEK
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SEEK" )
		turntowardsenemy
		clearCurrentEnemy
		evaluateenemies
	}
	
	//Behavior CloseInOnPlayer ( "run" , 256 )
	Behavior CloseInOnEnemy ( "run" , 256 )

	states
	{
		CLOSE_IN_ABORT		: PAIN
		THINK	: CAN_SEE_ENEMY
		HOLD	: BEHAVIOR_FAILED
	}
}


//---------------------------------------------------------
state CLOSE_IN_ABORT
//---------------------------------------------------------
{
	ignoreglobalstate
	entrycommands
	{
		//printmessage ( "CLOSE_IN_ABORT" )
		////printmessage "***********\nABORT\nABORT\nABORT\nABORT\n***********\n" );
	}
	//legs
	//{
	//	pain : default
	//}
	
	states
	{
		SIDESTEP : default
	}
}