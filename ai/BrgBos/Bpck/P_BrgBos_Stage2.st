//
// Name:     BorgBoss_Stage2
// Purpose:  Functionality for Stage 2
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
	//printmessage "START (STAGE2)"
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
	//printmessage "THINK (STAGE 2)"
	clearCurrentEnemy
	evaluateenemies
	selectclosestenemy
	HeadWatchEnemy
	}
	
behavior HoldPosition
	
states
	{      
	NO_ENEMY			: !HAVE_ENEMY
	ATTACK_MELEE		: CAN_SHOOT_ENEMY CHANCE ( .25 )
	ATTACK_PHASER		: CAN_SHOOT_ENEMY
	ATTACK_MELEE		: CAN_SHOOT_ENEMY RANGE ( 700 ) //not to far away or boss gets stuck at clifs
	ATTACK_PHASER		: CAN_SHOOT_ENEMY NO_PATH
	NO_PATH_AVAILABLE	: !HAVE_PATH_TO_ENEMY
	STAGE2_CHASE_PLAYER	: default      
	}
}

//---------------------------------------------------------
state ATTACK_MELEE //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE (STAGE2)"
	}
	
behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )
time ( .75 )

states
	{
	ATTACK_MELEE_FAST : TIME_DONE
	}
}

//---------------------------------------------------------
state ATTACK_MELEE_FAST //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_FAST"
	}

behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )
time ( 3 , 5 )

states
	{     
	ATTACK_MELEE_PUNCH	: !HAVE_PATH_TO_ENEMY RANGE ( 100 )
	NO_PATH_AVAILABLE	: !HAVE_PATH_TO_ENEMY 
	THINK				: TIME_DONE
	ATTACK_MELEE_PUNCH	: BEHAVIOR_SUCCESS
	}
}

//---------------------------------------------------------
state ATTACK_MELEE_PUNCH //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_PUNCH (STAGE2)"
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
state ATTACK_PHASER //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER (STAGE2)"
	turntowardsenemy
	}

legs
	{
	phaser_start : default
	}

states
	{
	ATTACK_PHASER_CHARGE : ANIM_DONE
	}
}

//---------------------------------------------------------
state ATTACK_PHASER_CHARGE //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_PHASER_CHARGE (STAGE2)"
	turntowardsenemy
	}
	
	states
	{
	ATTACK_PHASER_CHARGE_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	ATTACK_PHASER_CHARGE_SP	: default
	}
}



//---------------------------------------------------------
state ATTACK_PHASER_CHARGE_SP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_CHARGE_SP (STAGE2)"
	turntowardsenemy
	}

legs
	{
	phaser_charge : default
	}

Behavior Watch ( 30 )

states
	{
	ATTACK_PHASER_BLAST : ANIM_DONE CHANCE ( .20 )
	ATTACK_PHASER_SWEEP : ANIM_DONE CHANCE ( .35 )
	ATTACK_PHASER_BURST : ANIM_DONE 
	}
}


//---------------------------------------------------------
state ATTACK_PHASER_CHARGE_MP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_CHARGE_MP (STAGE2)"
	turntowardsenemy
	}

legs
	{
	phaser_charge : default
	}

Behavior Watch ( 300 )

states
	{
	ATTACK_PHASER_BLAST : ANIM_DONE CHANCE ( .20 )
	ATTACK_PHASER_SWEEP : ANIM_DONE CHANCE ( .35 )
	ATTACK_PHASER_BURST : ANIM_DONE 
	}
}

//---------------------------------------------------------
state ATTACK_PHASER_BLAST //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_BLAST (STAGE2)"
	turntowardsenemy
	}

legs
	{
	phaser_blast : default
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
	//printmessage "ATTACK_PHASER_SWEEP (STAGE2)"
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
state ATTACK_PHASER_BURST //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_BURST (STAGE2)"
	turntowardsenemy
	}

behavior DoAttack ( "phaser_burst" , 30 , 1 )

states
	{
	THINK : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state STAGE2_CHASE_PLAYER //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "STAGE2_CHASE_PLAYER (STAGE2)"
	}

behavior CloseInOnEnemy ( "walk" , $MELEE_RANGE$ )

time ( .75 )

states
	{
	ATTACK_PHASER : CAN_SHOOT_ENEMY
	STAGE2_CHASE_PLAYER_FAST : TIME_DONE
	}
}

//---------------------------------------------------------
state STAGE2_CHASE_PLAYER_FAST //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "STAGE2_CHASE_PLAYER_FAST (STAGE2)"
	}
	
behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )

time ( 2 , 4 )

states
	{
	ATTACK_PHASER : CAN_SHOOT_ENEMY
	THINK : TIME_DONE
	}
}

//---------------------------------------------------------
state NO_PATH_AVAILABLE //()
//---------------------------------------------------------
{
entrycommands
	{
	unreservecurrenthelpernode
	//printmessage "NO_PATH_AVAILABLE (STAGE2)"
	}

Behavior GotoHelperNodeNearestEnemy ( "combat" , "walk" , 9090 )

time ( 1 , 2 )

states
	{      
	THINK						: HAVE_PATH_TO_ENEMY
	NO_PATH_AVAILABLE_ATTACK	: CAN_SHOOT_ENEMY BEHAVIOR_SUCCESS 
	NO_PATH_AVAILABLE_ATTACK	: CAN_SHOOT_ENEMY BEHAVIOR_FAILED
	THINK						: TIME_DONE
	}
}

//---------------------------------------------------------
state NO_PATH_AVAILABLE_ATTACK //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "NO_PATH_AVAILABLE_ATTACK (STAGE2)"
	turntowardsenemy
	}

behavior DoAttack ( "phaser_burst" , 30 , 1 )

states
	{
	THINK	: BEHAVIOR_DONE
	}
}

//--------------------------------------------------------
state NO_ENEMY //()
//--------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "NO_ENEMY (STAGE2)"
	clearCurrentEnemy
	SelectNextEnemy
	selectclosestenemy
	HeadWatchEnemy
	}

legs
	{
	idle : default
	}

states
	{
	THINK			: HAVE_ENEMY
	NO_ENEMY_RESET	: ANIM_DONE
	}
}

//--------------------------------------------------------
state NO_ENEMY_RESET //()
//--------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "NO_ENEMY_RESET (STAGE2)"
	}

states
	{
	NO_ENEMY	: default
	}
}
