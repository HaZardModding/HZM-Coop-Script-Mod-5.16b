//
// Name:     Commander_PackageCombat
// Purpose:  
//

//
// Includes
//

//
// Defines
//
$define RETREAT_RANGE 		384
$define CHARGE_RANGE  		500
$define ATTACK_RANGE  		200
$define TOO_CLOSE    		100
$define RANGE_BUFFER_MAX	256
$define RANGE_BUFFER_MIN	320
$define CHANCE_HOLD			.15
$define TIME_MAX_CHASE		1.5

$define ATTACK_RANGE_MP  	180
$define RANGE_BUFFER_MIN_MP	180

//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "START" )
		settendency ( "multiplayer" , 0 )
		multiplayer settendency ( "multiplayer" , 1 )
		}
	states
		{
		THINK : default
		}
	}
	
//---------------------------------------------------------
state EVALUATE
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "EVALUATE" )
		clearCurrentEnemy
		evaluateenemies
		turntowardsenemy
		}
		time ( 0.1 )
	states
		{
		THINK : TIME_DONE
		}
	}

//---------------------------------------------------------
state THINK
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "THINK" )
		}
	states
		{
		EVALUATE			: !HAVE_ENEMY
		PAIN				: SHOW_PAIN !SHOULD_DO_ACTION ( "multiplayer" )
		STRAFE 				: IN_CONE_OF_FIRE 	
		RETREAT				: RANGE ( $RANGE_BUFFER_MIN$ )	!SHOULD_DO_ACTION ( "multiplayer" )
		RETREAT				: RANGE ( $RANGE_BUFFER_MIN_MP$ ) SHOULD_DO_ACTION ( "multiplayer" )
		CLOSE_IN 			: !RANGE ( $ATTACK_RANGE$ ) HAVE_PATH_TO_ENEMY !SHOULD_DO_ACTION ( "multiplayer" )
		CLOSE_IN_MP			: !RANGE ( $ATTACK_RANGE_MP$ ) SHOULD_DO_ACTION ( "multiplayer" )
        ATTACK 				: default		
		}
	}

//---------------------------------------------------------
state STRAFE
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "STRAFE" )
		turntowardsenemy
		}

	Behavior Strafe ( 2 )
	
	time ( 2 )

	states
		{
		PAIN						: SHOW_PAIN
		ATTACK_GUNS_WARN			: BEHAVIOR_DONE CHANCE ( .25 )
		ATTACK_GOO_WARN				: BEHAVIOR_DONE CHANCE ( .33 )
		ATTACK_MISSILES_WARN		: BEHAVIOR_DONE
		
		CLOSE_IN 			: !RANGE ( $ATTACK_RANGE$ ) HAVE_PATH_TO_ENEMY !SHOULD_DO_ACTION ( "multiplayer" )
		CLOSE_IN_MP			: !RANGE ( $ATTACK_RANGE_MP$ ) SHOULD_DO_ACTION ( "multiplayer" )
		
		THINK						: TIME_DONE
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
	behavior CloseInOnEnemy ( "run" , $ATTACK_RANGE$ )
	time ( $TIME_MAX_CHASE$ )
	states
		{      
		PAIN				: SHOW_PAIN 
		CLOSE_IN_COMPLETE	: !HAVE_PATH_TO_ENEMY   
		CLOSE_IN_COMPLETE	: BEHAVIOR_FAILED  
		CLOSE_IN_COMPLETE	: BEHAVIOR_SUCCESS
		}
	}
	
//---------------------------------------------------------
state CLOSE_IN_MP
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "CLOSE_IN_MP" )
		turntowardsenemy
		}
	behavior CloseInOnEnemy ( "run" , $ATTACK_RANGE_MP$ )
	time ( $TIME_MAX_CHASE$ )
	
	states
		{
		PAIN				: SHOW_PAIN 
		THINK 				: !HAVE_ENEMY
		THINK				: BLOCKED_BY_ENEMY
		THINK 				: BEHAVIOR_SUCCESS !RANGE ( $ATTACK_RANGE_MP$ )
		RETREAT				: CAN_WALK_FORWARD ( FALSE ) TIME_DONE
		CLOSE_IN_COMPLETE	: BEHAVIOR_SUCCESS
		CLOSE_IN_COMPLETE	: BEHAVIOR_FAILED
		THINK				: TIME_DONE
		}
	}


state CLOSE_IN_COMPLETE
{
	entrycommands
		{
		//printmessage ( "COLSE_IN_COMPLETE" )
		}
	states
		{
		ATTACK_GUNS_PRE			: CHANCE ( .25 )
		ATTACK_GOO_PRE			: CHANCE ( .33 )
		ATTACK_MISSILES_PRE		: default
		}
}


//---------------------------------------------------------
state ATTACK
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "ATTACK" )
		}
	states
		{
		RETREAT	: RANGE ( $RANGE_BUFFER_MIN$ ) !SHOULD_DO_ACTION ( "multiplayer" )
		RETREAT	: RANGE ( $RANGE_BUFFER_MIN_MP$ ) SHOULD_DO_ACTION ( "multiplayer" )
		CLOSE_IN 			:  CHANCE ( .25 ) !RANGE ( $ATTACK_RANGE$ ) HAVE_PATH_TO_ENEMY !SHOULD_DO_ACTION ( "multiplayer" )
		CLOSE_IN_MP			:  CHANCE ( .45 ) !RANGE ( $ATTACK_RANGE_MP$ ) SHOULD_DO_ACTION ( "multiplayer" )
		
		STRAFE 				: IN_CONE_OF_FIRE
		STRAFE				: !CAN_SHOOT_ENEMY

		ATTACK_GUNS_WARN			: CHANCE ( .25 )
		ATTACK_GOO_WARN			: CHANCE ( .33 )
		ATTACK_MISSILES_WARN		: default
		}
	}

state ATTACK_MISSILES_WARN
{
	entrycommands
		{
		//printmessage ( "ATTACK_MISSILES_WARN" )
		}
	Behavior WatchEntity ( 0 , 20 , "command_charge_front" , 1 , "command_charge_front" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE
		ATTACK_MISSILES_PRE : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state ATTACK_MISSILES_PRE
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_MISSILES_PRE" )
		}
	Behavior WatchEntity ( 0 , 20 , "turret_prefire_missles" , 1 , "turret_prefire_missles" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK_MISSILES : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state ATTACK_MISSILES
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "ATTACK_MISSILES" )
		}
	Behavior DoAttack ( "turret_fire_missles" , 10 , 0 , "idles" )

	states
		{     
        ATTACK_MISSILES_POST : BEHAVIOR_SUCCESS
		ATTACK_MISSILES_POST : BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state ATTACK_MISSILES_POST
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_MISSILES_POST" )
		}
	Behavior WatchEntity ( 0 , 20 , "turret_postfire_missles" , 1 , "turret_postfire_missles" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK : BEHAVIOR_DONE
	}
}


state ATTACK_GOO_WARN
{
	entrycommands
		{
		//printmessage ( "ATTACK_GOO_WARN" )
		}
	Behavior WatchEntity ( 0 , 20 , "command_charge_left" , 1 , "command_charge_left" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE
		ATTACK_GOO_PRE : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state ATTACK_GOO_PRE
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_GOO_PRE" )
		}
	Behavior WatchEntity ( 100 , 20 , "turret_prefire_gooballs" , 1 , "turret_prefire_gooballs" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK_GOO : ANIM_DONE
	}
}

//---------------------------------------------------------
state ATTACK_GOO
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "ATTACK_GOO" )
		}
	Behavior DoAttack ( "turret_fire_gooballs" , 10 , 0 , "idle" )

	states
		{     
			ATTACK_GOO_POST : BEHAVIOR_FAILED			
			ATTACK_GOO_POST : BEHAVIOR_SUCCESS
		}
	}
	
//---------------------------------------------------------
state ATTACK_GOO_POST
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_GOO_POST" )
		}
	Behavior WatchEntity ( 0 , 20 , "turret_postfire_gooballs" , 1  , "turret_postfire_gooballs" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK : BEHAVIOR_DONE
	}
}

state ATTACK_GUNS_WARN
{
	entrycommands
		{
		//printmessage ( "ATTACK_GUNS_WARN" )
		}
	Behavior WatchEntity ( 0 , 20 , "command_charge_right" , 1 , "command_charge_right" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE
		ATTACK_GUNS_PRE : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state ATTACK_GUNS_PRE
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_GUNS_PRE" )
		}
	Behavior WatchEntity ( 100 , 20 , "turret_prefire_machinegun" , 1 , "turret_prefire_machinegun" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK_GUNS : ANIM_DONE
	}
}

//---------------------------------------------------------
state ATTACK_GUNS
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "ATTACK_GUNS" )
		}
	Behavior DoAttack ( "turret_fire_machinegun" , 10 , 0 , "idle" , 1 )

	states
		{     
        ATTACK_GUNS_POST     : BEHAVIOR_FAILED
		ATTACK_GUNS_POST     : BEHAVIOR_SUCCESS        
		}

	}

//---------------------------------------------------------
state ATTACK_GUNS_POST
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_GUNS_POST" )
		}
	Behavior WatchEntity ( 0 , 20 , "turret_postfire_machinegun" , 1 , "turret_postfire_machinegun" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK : default
	}
}

//---------------------------------------------------------
state ATTACK_GUNS_POST_END
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage ( "ATTACK_GUNS_POST_END" )
		}
	Behavior WatchEntity ( 100 , 20 , "turret_postfire_machinegun" , 1 , "turret_postfire_machinegun" )
	states
	{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		ATTACK_END : ANIM_DONE
	}
}
	
//---------------------------------------------------------
state ATTACK_END
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "ATTACK_END" )
		}
	behavior RotateToEntity ( 10 , "idle" )
	
	states
		{
		PAIN				: SHOW_PAIN
		STRAFE				: INCOMING_PROJECTILE
		STRAFE				: ENEMY_PROJECTILE_CLOSE

		STRAFE : BEHAVIOR_SUCCESS
		}
	}

//---------------------------------------------------------
state HOLD
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "HOLD" )
		}
    behavior RotateToEntity ( 10 , "idle" )
    
	states
		{
		PAIN				: SHOW_PAIN
		THINK : BEHAVIOR_SUCCESS
		HOLD_RESET : BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state HOLD_RESET
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "HOLD_RESET" )
		}
	legs
		{
		idle : default
		}

	time ( .5 , .75 )

	states
		{
		HOLD : TIME_DONE
		}

	}


state RETREAT
{
	entrycommands
		{
		//printmessage ( "RETREAT" )
		}
	Behavior MoveRandomDirection ( "backpedal_run" , $RETREAT_RANGE$ , 96 , 2 , 1 , 1 )
	time ( 3.0 )
	
	states
		{
		PAIN			: SHOW_PAIN	
		ATTACK 			: !RANGE ( 384.0 )
		ATTACK 			: TIME_DONE
		ATTACK 			: BEHAVIOR_DONE
		}
}

//---------------------------------------------------------
state PAIN
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage ( "PAIN" )
		}
	legs
		{
		pain : default
		}

	states
		{
		ATTACK_GUNS_PRE			: ANIM_DONE CHANCE ( .25 )
		ATTACK_GOO_PRE			: ANIM_DONE CHANCE ( .33 )
		ATTACK_MISSILES_PRE		: ANIM_DONE
		}
	}


