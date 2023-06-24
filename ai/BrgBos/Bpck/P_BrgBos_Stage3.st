//
// Name:     BorgBoss_Stage3
// Purpose:  Functionality for Stage 3
//
//

//Changed for Co-Op 2009.1.24 Chrissstrahl

//Includes
$include ai/BrgBos/Glob/GP_BrgBos_Global.st

$define MELEE_RANGE 128

//---------------------------------------------------------
state START //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "START (STAGE3)"	
	HeadWatchEnemy

	settendency ( "multiplayer" , 0 )
	multiplayer settendency ( "multiplayer" , 1 )
	dialogMorphMult ( 1.6 )
	
	resistance "phaser" 95
	resistance "vaporize" 90
	resistance "comp_rifle" 95
	resistance "vaporize_comp" 85
	resistance "imod_primary" 75
	resistance "imod_secondary" 85
	resistance "assault_rifle" 95
	resistance "explosion" 85
	resistance "plasmashotgun" 85
	resistance "small_explosion" 90
	resistance "electric" 75
	resistance "gas" 100
	resistance "stasis" 85
	resistance "tetryon" 85
	resistance "sniper" 85
	resistance "disruptor" 85
	resistance "vaporize_disruptor" 90
	resistance "melee" 85
	resistance "vaporize_photon" 90
	
	displayeffect noelectric
	setactorflag "disabled" 0 
	immortal 1
	}

states
  {
  THINK : default
  }
}

//---------------------------------------------------------
state THINK //()
//---------------------------------------------------------
{
entrycommands
	{
	clearCurrentEnemy
	evaluateenemies
	HeadWatchEnemy
	}

states
	{
	//REINFORCMENTS 			: !HAS_THING ( 1 ) !SHOULD_DO_ACTION ( "multiplayer" )
	//ATTACK_MELEE_STOMP_MP		: !SHOULD_DO_ACTION ( "scriptcontrolled" ) HAVE_ENEMY RANGE ( 500 ) SHOULD_DO_ACTION ( "multiplayer" ) CHANCE ( .7 )
	ATTACK_MELEE_STOMP_MP		: !SHOULD_DO_ACTION ( "scriptcontrolled" ) ANY_ENEMY_IN_RANGE ( 500 ) SHOULD_DO_ACTION ( "multiplayer" ) CHANCE ( .7 )
	TELEPORT_START 				: default 
	}
}


//---------------------------------------------------------
state REINFORCMENTS //()
//---------------------------------------------------------
{
entrycommands
  {
  runthread borgspawn
  havething ( 1 , 1 )
  }
  
states
  {
  THINK : default
  }
}

//---------------------------------------------------------
state TELEPORT_START //()
//---------------------------------------------------------
{
states
  {
  ATTACK_MELEE_STOMP_MP	: !SHOULD_DO_ACTION ( "scriptcontrolled" ) SHOULD_DO_ACTION ( "multiplayer" ) CHANCE ( .4 )
  TELEPORT_ATTACK		: !SHOULD_DO_ACTION ( "scriptcontrolled" ) SHOULD_DO_ACTION ( "multiplayer" ) CAN_SHOOT_ENEMY
  //THINK					: !CAN_SHOOT_ENEMY
  TELEPORT_START_SP		: default
  }
}


//---------------------------------------------------------
state TELEPORT_START_SP //()
//---------------------------------------------------------
{

behavior AnimatedTeleportToPosition ( "teleport" , 4 , "teleport_start" , "teleport_end" )

states
  {
  TELEPORT_ATTACK	: BEHAVIOR_DONE
  }
}

//---------------------------------------------------------
state TELEPORT_ATTACK //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
  {
  turntowardsenemy
  }

behavior DoAttack ( "phaser_burst" , 30 , 1 )

states
  {
  TELEPORT_ATTACK_RESET : BEHAVIOR_SUCCESS CHANCE ( .15 )
  TELEPORT_ATTACK_WAIT : BEHAVIOR_SUCCESS
  TELEPORT_ATTACK_WAIT : BEHAVIOR_FAILED
  }   
}

//---------------------------------------------------------
state TELEPORT_ATTACK_WAIT //()
//---------------------------------------------------------
{
entrycommands
  {
  }

states
  {
  TELEPORT_ATTACK_WAIT_MP	: SHOULD_DO_ACTION ( "multiplayer" )
  TELEPORT_ATTACK_WAIT_SP	: default
  }   
}

//---------------------------------------------------------
state TELEPORT_ATTACK_WAIT_SP //()
//---------------------------------------------------------
{
behavior RotateToEntity ( 2.5 , "idle" )

states
	{
	THINK 					: BEHAVIOR_SUCCESS
	TELEPORT_ATTACK_FAILED	: BEHAVIOR_FAILED
	}
}


//---------------------------------------------------------
state TELEPORT_ATTACK_WAIT_MP //()
//---------------------------------------------------------
{
entrycommands
  {
  turntowardsenemy
  }
  
 time ( .1 , .3 )
 
states
	{
	TELEPORT_ATTACK_FAILED	: !CAN_SHOOT_ENEMY
	TELEPORT_ATTACK_FAILED	: !HAVE_ENEMY
	THINK 					: TIME_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_ATTACK_FAILED //()
//---------------------------------------------------------
{
entrycommands
	{
	clearCurrentEnemy
	evaluateenemies
	}

time ( 0.5 )

states
	{
	TELEPORT_ATTACK_WAIT : TIME_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_ATTACK_RESET //()
//---------------------------------------------------------
{
states
  {
  TELEPORT_ATTACK : default
  }
}


//---------------------------------------------------------
state ATTACK_MELEE_STOMP_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_STOMP_MP (STAGE3)"
	clearCurrentEnemy
	evaluateenemies
	selectclosestenemy
	turntowardsenemy
	}

legs
	{
	melee_stomp : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state NO_PATH_AVAILABLE //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
  {
  turntowardsenemy
  }

behavior DoAttack ( "phaser_burst" , 30 , 1 )

states
  {
  THINK : BEHAVIOR_DONE
  }  
}

