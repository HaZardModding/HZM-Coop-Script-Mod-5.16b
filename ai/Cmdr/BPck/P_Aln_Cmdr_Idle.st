//
// Name:     Lurker_PackageStage1
// Purpose:  Stage 1 Lurker.  A Stage 1 Lurker uses a swarm mechanic.  And needs to be no clip to
//           other lurkers.  A Stage 2 Lurker, really has nothing to do with its AI Stage.  A Lurker
//           becomes as Stage 2 Lurker after it registers that 5 or more other nearby lurkers have died.
//           I iterate through AI stages to maintain a count of the other Lurkers that have died.  So 
//           A Stage 2 Lurker will actually have an AI stage count of 5.
//

//
// Includes
//
$include ai/cmdr/glob/GP_Aln_Cmdr_Idle.st

//
// Defines
//
$define MELEE_RANGE 160
$define ATTACK_RANGE 250
$define TOO_CLOSE_FOR_CHARGE 250


//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	states
		{
		THINK : default
		}
	}

//---------------------------------------------------------
state THINK
//---------------------------------------------------------
	{
	states
		{
		CHARGE_ATTACK : !CHECK_VAR ( "charged_enemy" , "true" ) !RANGE ( $TOO_CLOSE_FOR_CHARGE$ )
		MELEE : default 		
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK
//---------------------------------------------------------
	{
	Behavior CloseInOnEnemy ( "run" , $ATTACK_RANGE$ )

	states
		{
		HOLD                : BEHAVIOR_FAILED
		CHARGE_ATTACK_MELEE : RANGE ( $ATTACK_RANGE$ )
		CHARGE_ATTACK_MELEE : BEHAVIOR_SUCCESS
		}
	}

//---------------------------------------------------------
state CHARGE_ATTACK_MELEE
//---------------------------------------------------------
	{
	ignoreglobalstate

	entrycommands
		{
		turntowardsenemy
		setvar ( "charged_enemy" , "true" )
		}

	behavior leaptoenemy ( 350.0 )

	states
		{
		THINK : BEHAVIOR_SUCCESS
		}
	}

//---------------------------------------------------------
state MELEE
//---------------------------------------------------------
	{
	Behavior SimpleMelee ( "run" , "attackcombo" , $MELEE_RANGE$ , 36.0 )

  	states
		{
		MOVE         : RANGE ( $MELEE_RANGE$ ) !CAN_ATTACK_ENEMY
		MELEE_FAILED : BEHAVIOR_FAILED	 
		THINK        : BEHAVIOR_DONE	 
		}
	}

//---------------------------------------------------------
state MELEE_FAILED
//---------------------------------------------------------
	{
	states
		{
		CLOSE_IN_ON_ENEMY : !RANGE ( $MELEE_RANGE$ )
		SPRAY_ATTACK      : CHANCE ( .25 )
		HOLD              : default
		}
	}

//---------------------------------------------------------
state CLOSE_IN_ON_ENEMY
//---------------------------------------------------------
	{
	Behavior CloseInOnEnemy ( "run" , 64.0 )

	states
		{
		THINK       : BEHAVIOR_SUCCESS
		THINK       : RANGE ( $MELEE_RANGE$ )
		HOLD        : BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state SPRAY_ATTACK
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		attack_spray_begin : default
		}

	states
		{
		SPRAY_ATTACK_LOOP : ANIM_DONE
		}
	}

//---------------------------------------------------------
state SPRAY_ATTACK_LOOP
//---------------------------------------------------------
	{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		attack_spray_looping : default
		}

	time ( .5 , 1 )

	states
		{
		SPRAY_ATTACK_END : TIME_DONE
		}
	}

//---------------------------------------------------------
state SPRAY_ATTACK_END
//---------------------------------------------------------
	{
	  entrycommands
	     {
	     turntowardsenemy
	     }
	
	  legs
	     {
	 	 attack_spray_end : default
	     }
	
	  states
	     {
	     THINK : ANIM_DONE
	     }
	}

//---------------------------------------------------------
state HOLD
//---------------------------------------------------------
	{
	legs
		{
		idle : default
		}

	time ( .5 , 1 )

	states
		{
		THINK : TIME_DONE
		}
	}

//---------------------------------------------------------
state MOVE
//---------------------------------------------------------
	{
	states
		{
		MOVE_CLOCKWISE        : CHANCE ( .5 )
		MOVE_COUNTERCLOCKWISE : default
		}
	} 

//---------------------------------------------------------
state MOVE_CLOCKWISE
//---------------------------------------------------------
	{
	Behavior CircleStrafeEntity ( "enemy" , "run" , 64.0 , 1 )

	time ( 1 , 1.25 )

	states
		{
		MELEE                 : RANGE ( $MELEE_RANGE$ ) CAN_ATTACK_ENEMY
		THINK                 : TIME_DONE
		MOVE_CLOCKWISE_FAILED : BEHAVIOR_FAILED     
		}
	}

//---------------------------------------------------------
state MOVE_CLOCKWISE_FAILED
//---------------------------------------------------------
	{
	Behavior CircleStrafeEntity ( "enemy" , "run" , 64.0 , 0 )

	time ( 1 , 1.25 )

	states
		{
		MELEE : RANGE ( $MELEE_RANGE$ ) CAN_ATTACK_ENEMY
		THINK : TIME_DONE
		HOLD  : BEHAVIOR_FAILED     
		}
	}

//---------------------------------------------------------
state MOVE_COUNTERCLOCKWISE_FAILED
//---------------------------------------------------------
	{
	Behavior CircleStrafeEntity ( "enemy" , "run" , 64.0 , 1 )

	time ( 1 , 1.25 )

	states
		{
		MELEE : RANGE ( $MELEE_RANGE$ ) CAN_ATTACK_ENEMY
		THINK : TIME_DONE
		HOLD  : BEHAVIOR_FAILED  
		}   
	}

//---------------------------------------------------------
state MOVE_COUNTERCLOCKWISE
//---------------------------------------------------------
	{
	Behavior CircleStrafeEntity ( "enemy" , "run" , 64.0 , 0 )

	time ( 1 , 1.25 )

	states
		{
		MELEE : RANGE ( $MELEE_RANGE$ ) CAN_ATTACK_ENEMY
		THINK : TIME_DONE
		HOLD  : BEHAVIOR_FAILED     
		}
	}