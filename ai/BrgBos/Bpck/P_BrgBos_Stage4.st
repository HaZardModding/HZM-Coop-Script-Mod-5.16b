//
// Name:     BorgBoss_Stage4
// Purpose:  Functionality for Stage 4
//
//

//Changed for Co-Op 2009.1.24 Chrissstrahl

//Includes
$include ai/BrgBos/Glob/GP_BrgBos_Global.st


$define MELEE_RANGE 128
$define TELEPORT_RANGE 1000
$define TELEPORT_RANGE_MAX_HEIGHT 500
$define TELEPORT_RANGE_MIN_HEIGHT -500

//---------------------------------------------------------
state START //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "START (STAGE4)"
	
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
	resistance "vaporize_disruptor" 95
	resistance "melee" 85
	resistance "vaporize_photon" 90

	displayeffect noelectric
	setactorflag "disabled" 0
	health 199
	immortal 0
	
	emitteroff tempbossflare
	}

states
	{
	RESISTANCE_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	THINK 			: default
	}
}

//---------------------------------------------------------
state RESISTANCE_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "RESISTANCE_MP (STAGE4)"
	resistance "phaser" 99
	resistance "vaporize" 99
	resistance "comp_rifle" 99
	resistance "vaporize_comp" 99
	resistance "imod_primary" 96
	resistance "imod_secondary" 96
	resistance "assault_rifle" 99
	resistance "explosion" 99
	resistance "plasmashotgun" 99
	resistance "small_explosion" 99
	resistance "electric" 99
	resistance "gas" 100
	resistance "stasis" 100
	resistance "tetryon" 99
	resistance "sniper" 99
	resistance "disruptor" 99
	resistance "vaporize_disruptor" 99
	resistance "melee" 99
	resistance "vaporize_photon" 99
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
	immortal 0
	//printmessage "THINK (STAGE4)"
	clearCurrentEnemy
	evaluateenemies
	headwatchenemy 1
	}

states
	{
	TELEPORT_ATTACK		: SHOULD_DO_ACTION ( "multiplayer" ) RANGE ( 120 ) CHANCE ( 70 )
	ATTACK_MELEE_FAST	: SHOULD_DO_ACTION ( "multiplayer" ) RANGE ( 150 ) CHANCE ( 70 )
	ATTACK_MELEE_STOMP	: SHOULD_DO_ACTION ( "multiplayer" ) RANGE ( 200 ) CHANCE ( 70 )
		
	TELEPORT_START		: CHANCE ( .80 )
	TELEPORT_HIDE		: !HAVE_ENEMY !RANGE ( $MELEE_RANGE$ )
	TELEPORT_HIDE		: !HAVE_PATH_TO_ENEMY !RANGE ( $MELEE_RANGE$ )

	TELEPORT_HIDE		: !CAN_SEE_ENEMY
	TELEPORT_START		: default
	//ATTACK_MELEE		: default
	}
}

//---------------------------------------------------------
state ATTACK_MELEE //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE (STAGE4)"
	}

behavior CloseInOnEnemy ( "walk" , $MELEE_RANGE$ )
time ( .75 )

states
	{
	ATTACK_MELEE_FAST	: TIME_DONE CHANCE ( 30 )
	TELEPORT_START		: TIME_DONE BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state ATTACK_MELEE_FAST //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_FAST (STAGE4)"
	}

behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )
time ( 2 , 3.7 )

states
	{
	TELEPORT_HIDE		: BEHAVIOR_FAILED
	ATTACK_MELEE_PUNCH	: BEHAVIOR_SUCCESS
	TELEPORT_START		: BEHAVIOR_FAILED
	TELEPORT_START		: TIME_DONE
	}
}

//---------------------------------------------------------
state ATTACK_MELEE_PUNCH //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_PUNCH (STAGE4)"
	turntowardsenemy
	}

legs
	{
	melee_punch : default
	}

states
	{
	THINK : ANIM_DONE
	}
}


//---------------------------------------------------------
state ATTACK_MELEE_STOMP //()
//---------------------------------------------------------
{
entrycommands
	{
	turntowardsenemy
	//printmessage "ATTACK_MELEE_STOMP (STAGE4)"
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
state ATTACK_PHASER_SWEEP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_SWEEP (STAGE4)"
	turntowardsenemy
	}

legs
	{
	phaser_sweep : default
	}

states
	{
	THINK : ANIM_DONE
	}
}


//---------------------------------------------------------
state TELEPORT_START //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_START (STAGE4)"
	}

states
	{
	TELEPORT_START_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	TELEPORT_START_SP	: default
	}
}

//---------------------------------------------------------
state TELEPORT_START_SP //()
//---------------------------------------------------------
{
	ignoreglobalstate

	behavior AnimatedTeleportToPlayer ( "teleport_start" , "teleport_end" )

	states
	{
		ATTACK_MELEE : BEHAVIOR_FAILED
		TELEPORT_ATTACK : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_START_MP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "TELEPORT_START_MP (STAGE4)"
	animateonce ( "teleport_start" )
	}

time (  .5 )

states
	{
	TELEPORT_WAIT_MP	: TIME_DONE
	}
exitcommands
	{
	hide
	notsolid
	}
}

//---------------------------------------------------------
state TELEPORT_WAIT_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_WAIT_MP (STAGE4)"
	}

states
	{
	TELEPORT_HIDDEN_CHASE_MP	: default
	}
}

//---------------------------------------------------------
state TELEPORT_HIDDEN_CHASE_MP //()
//---------------------------------------------------------
//Hunt tha dude, I think its the best way to do it
{
entrycommands
	{
	//printmessage "TELEPORT_HIDDEN_CHASE_MP (STAGE4)"
	clearCurrentEnemy
	evaluateenemies
	turntowardsenemy
	headwatchenemy 1
	jumpxy ( 1 , 0 , 1800 )
	}

time ( .25 )

states
	{
	//TELEPORT_HIDDEN_CHASE_WALK_MP : TIME_DONE
	TELEPORT_END_MP					: TIME_DONE HAVE_ENEMY RANGE ( 90 )
	TELEPORT_HIDDEN_CHASE_WALK_MP	: TIME_DONE
	}
	
exitcommands
	{
	setvelocity "0 0 0"
	}
}


//---------------------------------------------------------
state TELEPORT_HIDDEN_CHASE_WALK_MP //()
//---------------------------------------------------------
//Hunt tha dude, I think its the best way to do it
{
entrycommands
	{
	//printmessage "TELEPORT_HIDDEN_CHASE_MP (STAGE4)"
	clearCurrentEnemy
	evaluateenemies
	selectclosestenemy
	}
	

behavior CloseInOnEnemy ( "walk_fast" , 100 )
time (  .5 , 2 )

states
	{
	TELEPORT_END_MP					: TIME_DONE BEHAVIOR_SUCCESS HAVE_ENEMY HAVE_PATH_TO_ENEMY
	TELEPORT_END_MP					: TIME_DONE BEHAVIOR_SUCCESS HAVE_ENEMY
	TELEPORT_END_MP					: TIME_DONE HAVE_ENEMY RANGE ( 190 )
	TELEPORT_HIDDEN_CHASE_MP		: BEHAVIOR_FAILED HAVE_ENEMY
	TELEPORT_HIDDEN_CHASE_MP		: TIME_DONE HAVE_ENEMY !RANGE ( 110 )
	TELEPORT_HIDDEN_TO_CLOSE_1_MP	: HAVE_ENEMY RANGE ( 60 )
	TELEPORT_END_MP					: TIME_DONE HAVE_ENEMY RANGE ( 110 )
	}

exitcommands
	{
	}
}


//---------------------------------------------------------
state TELEPORT_HIDDEN_TO_CLOSE_1_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDDEN_TO_CLOSE_1_MP (STAGE4)"
	setvelocity "900 0 0"
	}
	
time (  .5 , 1 )

states
	{
	TELEPORT_HIDDEN_TO_CLOSE_2_MP	: HAVE_ENEMY RANGE ( 60 )
	TELEPORT_HIDDEN_CHASE_MP		: TIME_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_HIDDEN_TO_CLOSE_2_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDDEN_TO_CLOSE_2_MP (STAGE4)"
	setvelocity "-900 0 0"
	}
	
time (  .5 , 1 )

states
	{
	TELEPORT_HIDDEN_TO_CLOSE_3_MP	: HAVE_ENEMY RANGE ( 60 )
	TELEPORT_HIDDEN_CHASE_MP		: TIME_DONE
	}
}


//---------------------------------------------------------
state TELEPORT_HIDDEN_TO_CLOSE_3_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDDEN_TO_CLOSE_3_MP (STAGE4)"
	setvelocity "0 900 0"
	}
	
time (  .5 , 1 )

states
	{
	TELEPORT_HIDDEN_TO_CLOSE_4_MP	: HAVE_ENEMY RANGE ( 60 )
	TELEPORT_HIDDEN_CHASE_MP		: TIME_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_HIDDEN_TO_CLOSE_4_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDDEN_TO_CLOSE_MP (STAGE4)"
	setvelocity "0 -900 0"
	}
	
time (  .5 , 1 )

states
	{
	TELEPORT_HIDDEN_CHASE_MP		: TIME_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_END_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_END_MP (STAGE4)"
	}

states
	{
	TELEPORT_MATERIALIZE_MP		: HAVE_ENEMY !RANGE ( 60 ) RANGE ( 600 )
	TELEPORT_HIDDEN_CHASE_MP	: HAVE_ENEMY
	}
}

//---------------------------------------------------------
state TELEPORT_MATERIALIZE_MP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	spawneffect "fx/fx-beamsparkle-borgboss.tik" "origin" "1"
	//printmessage "TELEPORT_MATERIALIZE_MP (STAGE4)"
	}

time (  .05 )

states
	{
	TELEPORT_MATERIALIZE_ATTACKS_MP	: TIME_DONE
	}

exitcommands
	{
	show
	solid
	}
}

//---------------------------------------------------------
state TELEPORT_MATERIALIZE_MP_STOMP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	spawneffect "fx/fx-beamsparkle-borgboss.tik" "origin" "1"
	//printmessage "TELEPORT_MATERIALIZE_MP (STAGE4)"

	}
	
states
	{
	ATTACK_MELEE_STOMP			: TIME_DONE
	}
	
exitcommands
	{
	show
	solid
	}
}

//---------------------------------------------------------
state TELEPORT_MATERIALIZE_ATTACKS_MP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_MATERIALIZE_ATTACKS_MP (STAGE4)"
	}

states
	{
	TELEPORT_ATTACK		: RANGE ( 120 )
	ATTACK_MELEE		: RANGE ( 200 ) CHANCE ( 70 )
	ATTACK_MELEE_FAST	: RANGE ( 220 ) CHANCE ( 70 )
	ATTACK_MELEE_STOMP	: RANGE ( 400 ) CHANCE ( 60 )
	ATTACK_PHASER_SWEEP	: RANGE ( 600 ) CHANCE ( 80 )
	THINK				: default
	}

exitcommands
	{
	}
}

//---------------------------------------------------------
state TELEPORT //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT (STAGE4)"
	}

	//Behavior TeleportToPlayer
	behavior AnimatedTeleportToPlayer ( "teleport_start" , "teleport_end" )

	states
	{
		TELEPORT_ATTACK : default
	}
}

//---------------------------------------------------------
state TELEPORT_ATTACK //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_ATTACK (STAGE4)"
	turntowardsenemy
	resetmovedir
	}

legs
	{
	melee_charge : default
	}

states
	{
	ATTACK_MELEE_STOMP	: ANIM_DONE !SHOULD_DO_ACTION ( "multiplayer" ) RANGE ( 400 ) CHANCE ( 60 )
	TELEPORT_HIDE		: ANIM_DONE !SHOULD_DO_ACTION ( "multiplayer" )
	THINK				: ANIM_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_HIDE //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDE (STAGE4)"
	}

states
	{
	TELEPORT_START_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	TELEPORT_HIDE_SP	: default
	}
}


//---------------------------------------------------------
state TELEPORT_HIDE_SP //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDE_SP (STAGE4)"
	//displayeffect ( "TransportOut" , "Federation" )
	spawneffect "fx/fx-beamsparkle-borgboss.tik" "origin" "1"
	}
Time ( 1.0 )

legs
	{
	idle : default
	}

states
	{
	TELEPORT_HIDE_WAIT : TIME_DONE
	}
}

//---------------------------------------------------------
state TELEPORT_HIDE_WAIT //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDE_WAIT (STAGE4)"
	hide
	notsolid
	}

legs
	{
	idle : default
	}

states
	{
	TELEPORT_HIDE_FINISH : HAVE_ENEMY HAVE_PATH_TO_ENEMY
	}
	
//exitcommands
	//{
	//displayeffect ( "TransportIn" , "Federation" )
	//}
}

//---------------------------------------------------------
state TELEPORT_HIDE_FINISH //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TELEPORT_HIDE_FINISH (STAGE4)"
	}

legs
	{
	idle : default
	}

states
	{
	TELEPORT : default
	}

exitcommands
	{
	solid
	show
	spawneffect "fx/fx-beamsparkle-borgboss.tik" "origin" "1"
	}
}


