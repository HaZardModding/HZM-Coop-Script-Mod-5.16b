//
// Name:     BorgBoss_Stage1
// Purpose:  Functionality for Stage 1
//
//

//Includes
$include ai/BrgBos/Glob/GP_BrgBos_Global.st


//---------------------------------------------------------
state START //()
//---------------------------------------------------------
{
entrycommands
	{
	//settendency ( "multiplayer" , 0 )
	//multiplayer settendency ( "multiplayer" , 1 )
	//dialogMorphMult ( 1.6 )
	
	//printmessage "START (STAGE1)"
	setactorflag "updateactionlevel" 1
	}

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	THINK				: default
	}
}

//---------------------------------------------------------
state THINK //()
//---------------------------------------------------------
{

entrycommands
	{
	//printmessage "THINK (STAGE1)"
	clearCurrentEnemy
	evaluateenemies
	HeadWatchEnemy
	}
	
legs
	{
	idle : default
	}
	
states
	{
	//GOTO_STAGE_2_START			: !STAGE ( 2 ) HEALTH ( $STAGE_2_HEALTH$ ) !HEALTH ( $STAGE_3_HEALTH$ )
	STAGE1_PAIN					: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN					: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	NO_ENEMY					: !HAVE_ENEMY
	STAGE1_CHASE_PLAYER			: CHANCE ( .7 ) RANGE ( 220 )
	ATTACK_MELEE				: CAN_SHOOT_ENEMY CHANCE ( .4 ) !SHOULD_DO_ACTION ( "scriptcontrolled" )
	ATTACK_MELEE_FAST			: CAN_SHOOT_ENEMY CHANCE ( .7 ) !SHOULD_DO_ACTION ( "scriptcontrolled" )
	ATTACK_PHASER				: CAN_SHOOT_ENEMY CHANCE ( .7 )
	STAGE1_CHASE_PLAYER_FAST	: CHANCE ( .7 ) RANGE ( 220 )
	ATTACK_MELEE_PUNCH			: RANGE ( 120 )
	NO_PATH_AVAILABLE			: default
	}
}


//---------------------------------------------------------
state ATTACK_MELEE //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE (STAGE1)"
	}

behavior CloseInOnEnemy ( "walk" , $MELEE_RANGE$ )
time ( .75 )

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	ATTACK_MELEE_FAST 	: BEHAVIOR_SUCCESS
	ATTACK_MELEE_FAST 	: TIME_DONE
	}
}

//---------------------------------------------------------
state ATTACK_MELEE_FAST //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_FAST (STAGE1)"
	}

behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )
time ( 3 , 5 )

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	ATTACK_MELEE_PUNCH	: RANGE ( 120 ) 
	ATTACK_MELEE_PUNCH	: BEHAVIOR_SUCCESS
	ATTACK_PHASER		: TIME_DONE CAN_SHOOT_ENEMY
	NO_PATH_AVAILABLE	: !HAVE_PATH_TO_ENEMY
	THINK				: BEHAVIOR_FAILED
	THINK				: TIME_DONE
	}
}

//---------------------------------------------------------
state ATTACK_MELEE_PUNCH //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "ATTACK_MELEE_PUNCH (STAGE1)"
	turntowardsenemy
	}

legs
	{
	melee_punch : default
	}

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	THINK				: ANIM_DONE
	}
}

//---------------------------------------------------------
state ATTACK_PHASER //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER (STAGE1)"
	}

legs
	{
	phaser_start : default
	}

states
	{
	STAGE1_PAIN				: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN				: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	ATTACK_PHASER_CHARGE	: ANIM_DONE
	}
}

//---------------------------------------------------------
state ATTACK_PHASER_CHARGE //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_CHARGE (STAGE1)"
	}
	
legs
	{
	phaser_charge : default
	}

Behavior Watch ( 10 )

states
	{
	STAGE1_PAIN							: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN							: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	

	ATTACK_PHASER_SWEEP	: ANIM_DONE CHANCE ( .35 )
	ATTACK_PHASER_BURST	: ANIM_DONE 
	}
}

//---------------------------------------------------------
state ATTACK_PHASER_SWEEP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_SWEEP (STAGE1)"
	turntowardsenemy
	}

legs
	{
	phaser_sweep : default
	}

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	THINK				: ANIM_DONE
	}
}

//---------------------------------------------------------
state ATTACK_PHASER_BURST //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "ATTACK_PHASER_BURST (STAGE1)"
	turntowardsenemy
	}

behavior DoAttack ( "phaser_burst" , 30 , 1 )

states
	{
	STAGE1_PAIN							: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN							: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	

	THINK	: BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state STAGE1_CHASE_PLAYER //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "STAGE1_CHASE_PLAYER (STAGE1)"
	}

behavior CloseInOnEnemy ( "walk" , $MELEE_RANGE$ )
time ( 2 , 4 )

states
	{
	STAGE1_PAIN					: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN					: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	ATTACK_MELEE_PUNCH			: TIME_DONE RANGE ( 120 ) BEHAVIOR_FAILED
	ATTACK_PHASER 				: TIME_DONE !RANGE ( 120 ) CAN_SHOOT_ENEMY BEHAVIOR_FAILED
	STAGE1_CHASE_PLAYER_FAST 	: TIME_DONE RANGE ( 220 )
	THINK						: BEHAVIOR_FAILED
	THINK						: BEHAVIOR_SUCCESS
	THINK						: TIME_DONE
	}
}

//---------------------------------------------------------
state STAGE1_CHASE_PLAYER_FAST //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "STAGE1_CHASE_PLAYER_FAST (STAGE1)"
	}

behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )
time ( 2 , 4 )

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	//ATTACK_PHASER		: CAN_SHOOT_ENEMY
	ATTACK_MELEE_PUNCH	: TIME_DONE RANGE ( 120 ) 
	ATTACK_PHASER 		: TIME_DONE !RANGE ( 120 ) CAN_SHOOT_ENEMY BEHAVIOR_FAILED
	NO_PATH_AVAILABLE	: !HAVE_PATH_TO_ENEMY
	THINK				: BEHAVIOR_FAILED
	THINK				: BEHAVIOR_SUCCESS
	THINK				: TIME_DONE
	}
}

//---------------------------------------------------------
state NO_PATH_AVAILABLE //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "NO_PATH_AVAILABLE (STAGE1)"
	unreservecurrenthelpernode
	}

Behavior GotoHelperNodeNearestEnemy ( "combat" , "walk" , 9090 )
time ( 1 , 2 )

states
	{      
	STAGE1_PAIN					: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN					: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )	
	ATTACK_MELEE			 	: RANGE ( 220 ) //not to far away or boss gets stuck at clifs
	NO_PATH_AVAILABLE_ATTACK 	: BEHAVIOR_FAILED
	NO_PATH_AVAILABLE_ATTACK 	: BEHAVIOR_SUCCESS
	THINK 						: TIME_DONE
	}
}

//---------------------------------------------------------
state NO_PATH_AVAILABLE_ATTACK //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "NO_PATH_AVAILABLE_ATTACK (STAGE1)"
	turntowardsenemy
	}

behavior DoAttack ( "phaser_burst" , 30 , 1 )

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )		
	THINK				: BEHAVIOR_DONE
	}
}

//--------------------------------------------------------
state NO_ENEMY //()
//--------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "NO_ENEMY (STAGE1)"
	clearCurrentEnemy
	evaluateenemies
	SelectNextEnemy
	selectclosestenemy
	}

legs
	{
	idle : default
	}

states
	{
	STAGE1_PAIN			: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN			: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )		
	THINK				: HAVE_ENEMY
	NO_ENEMY_RESET		: ANIM_DONE
	}
}

//--------------------------------------------------------
state NO_ENEMY_RESET //()
//--------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "NO_ENEMY_RESET (STAGE1)"
	}

states
	{
	STAGE1_PAIN							: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	STAGE1_PAIN							: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )		

	NO_ENEMY	: default
	}
}

//---------------------------------------------------------
state STAGE1_PAIN //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "STAGE1_PAIN (STAGE1)"
	}

states
	{
	STAGE1_PAIN_LEFT_SHOULDER : BONE_DAMAGED ( "Bip01 L Clavicle" )
	STAGE1_PAIN_LEFT_SHOULDER : BONE_DAMAGED ( "Bip01 L Upperarm" )
	STAGE1_PAIN_LEFT_SHOULDER : BONE_DAMAGED ( "Bip01 L Forearm" )
	STAGE1_PAIN_LEFT_SHOULDER : BONE_DAMAGED ( "Bip01 L Hand" )
	
	STAGE1_PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Clavicle" )
	STAGE1_PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Upperarm" )
	STAGE1_PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Forearm" )
	STAGE1_PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Hand" )
	
	STAGE1_PAIN_HEAD           : BONE_DAMAGED ( "Bip01 Neck" )
	STAGE1_PAIN_HEAD           : BONE_DAMAGED ( "Bip01 Head" )
	
	STAGE1_PAIN_LEFT_LEG       : BONE_DAMAGED ( "Bip01 L Calf" )
	STAGE1_PAIN_LEFT_LEG       : BONE_DAMAGED ( "Bip01 L Thigh" )
	STAGE1_PAIN_LEFT_LEG       : BONE_DAMAGED  ( "Bip01 L Foot" )
	
	STAGE1_PAIN_RIGHT_LEG       : BONE_DAMAGED ( "Bip01 R Calf" )
	STAGE1_PAIN_RIGHT_LEG       : BONE_DAMAGED ( "Bip01 R Thigh" )
	STAGE1_PAIN_RIGHT_LEG       : BONE_DAMAGED  ( "Bip01 R Foot" )
	
	STAGE1_PAIN_GENERAL : default
	}
}

//---------------------------------------------------------
state STAGE1_PAIN_LEFT_SHOULDER  //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "STAGE1_PAIN_LEFT_SHOULDER (STAGE1)"
	}

legs
	{
	pain_arm_l : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state STAGE1_PAIN_RIGHT_SHOULDER //()
//---------------------------------------------------------
{
ignoreglobalstate  

entrycommands
	{
	//printmessage "STAGE1_PAIN_RIGHT_SHOULDER (STAGE1)"
	}

legs
	{
	pain_arm_r : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state STAGE1_PAIN_HEAD //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "STAGE1_PAIN_HEAD (STAGE1)"
	}

legs
	{
	pain_head : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state STAGE1_PAIN_LEFT_LEG //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "STAGE1_PAIN_LEFT_LEG (STAGE1)"
	}

legs
	{
	pain_leg_l : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state STAGE1_PAIN_RIGHT_LEG //()
//---------------------------------------------------------
{
ignoreglobalstate  

entrycommands
	{
	//printmessage "STAGE1_PAIN_RIGHT_LEG (STAGE1)"
	}

legs
	{
	pain_leg_r : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state STAGE1_PAIN_GENERAL //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "STAGE1_PAIN_GENERAL (STAGE1)"
	}

legs
	{
	pain_chest : default
	}

states
	{
	THINK : ANIM_DONE
	}
}
