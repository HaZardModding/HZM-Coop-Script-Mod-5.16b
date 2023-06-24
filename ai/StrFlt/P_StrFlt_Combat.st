//
// Name:     Humanoid_PackageCombat
// Purpose:  AI for Combat State Humanoids
//

//
// Defines
//
$define	RANGE_MAX_DISTANCE_TO_COMBAT_NODE	512
$define RANGE_MAX_DISTANCE_TO_COVER_NODE	512
$define RANGE_MIN_DISTANCE_TO_COVER_NODE	128
$define RANGE_MELEE							96
$define CHANCE_PAIN							.020
$define TIME_DUCK_WAIT_MIN					 .5
$define TIME_DUCK_WAIT_MAX					 1.25
$define RANGE_MAX_DISTANCE_TO_COVER_NODE	 1024
$define RANGE_MIN_DISTANCE_TO_COVER_NODE 	64
$define CHANCE_CHANGE_COVER 				.75
$define TIME_WAIT_AT_COVER_MIN				.75
$define TIME_WAIT_AT_COVER_MAX				1.0
$define COUNT_MAX_REPEATS					3
$define CHANCE_REPEAT_ATTACK				.4
$define PLAYER_NEAR_ME						128
$define RANGE_MAX_DISTANCE_TO_ANY_NODE		1024
$define CHANCE_DO_MELEE						.25



//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	entrycommands
		{
		incontext "enteredcombat"
		groupattack
		}

	states
		{
		COMBAT_MAIN		: default
		}
	}

//---------------------------------------------------------
state COMBAT_MAIN
//---------------------------------------------------------
	{
	states
		{
		HANDLE_CALL_VOLUME						: PLAYER_IN_CALL_VOLUME
		//FOLLOW_THE_LEADER						: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE

		COVER_COMBAT_WITH_RANGED_WEAPON			: VALID_COVER_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_COVER_NODE$ , $RANGE_MIN_DISTANCE_TO_COVER_NODE$ )		
		POSITIONAL_COMBAT_WITH_RANGED_WEAPON	: VALID_COMBAT_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_COMBAT_NODE$ )
		NO_NODE_AVAILABLE								: default
		}
	}

//---------------------------------------------------------
state NO_NODE_AVAILABLE
//---------------------------------------------------------
{
	//co-Op Mod, don't the fucking hell spamm the console, noone cares about!!!
	// entrycommands
		// {
		// printmessage "WARNING: TEAMMATE CANNOT FIND A VALID HELPER NODE"
		// }

	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		NO_NODE_COMBAT_ENEMY_IN_MELEE_RANGE		: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: TORSO_BEHAVIOR_DONE
		}
}

//---------------------------------------------------------
state NO_NODE_COMBAT_GET_OUT_OF_THE_WAY 
//---------------------------------------------------------
{
	Behavior MoveRandomDirection ( "walk" , 200 , 32 )//walk 192 64
	time ( 1.5 )

	states
		{
		NO_NODE_AVAILABLE_RETRY	: BEHAVIOR_SUCCESS		
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY_FAILED	: BEHAVIOR_FAILED		
		NO_NODE_AVAILABLE_RETRY	: TIME_DONE
		}	  
}

state NO_NODE_COMBAT_GET_OUT_OF_THE_WAY_FAILED
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "crouch_idle" , 0 , "crouch_idle" )
	
	states 
		{
		COMBAT_MAIN		: TORSO_BEHAVIOR_DONE !IN_THE_WAY !IN_PLAYER_CONE_OF_FIRE
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY_FAILED_RESET	: TORSO_BEHAVIOR_DONE
		}
}

state NO_NODE_COMBAT_GET_OUT_OF_THE_WAY_FAILED_RESET
{
	states
		{
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY_FAILED : default
		}
}

//---------------------------------------------------------
state NO_NODE_AVAILABLE_RETRY
//---------------------------------------------------------
{
//co-Op Mod, don't the fucking hell spamm the console, noone cares about!!!
	// entrycommands
		// {
		// printmessage "WARNING: TEAMMATE CANNOT FIND A VALID HELPER NODE"
		// }

	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		NO_NODE_COMBAT_ENEMY_IN_MELEE_RANGE		: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state NO_NODE_COMBAT_ENEMY_IN_MELEE_RANGE
//------------------------------------------------------------------------------
{
	states
		{
		NO_NODE_COMBAT_MELEE_RANGE_ATTACK_WITH_MELEE	: ALLOWED_TO_MELEE_ENEMY CHANCE ( $CHANCE_DO_MELEE$ )
		NO_NODE_COMBAT_MELEE_RANGE_ATTACK_WITH_WEAPON	: default
		}
}

//------------------------------------------------------------------------------
state NO_NODE_COMBAT_MELEE_RANGE_ATTACK_WITH_MELEE
//------------------------------------------------------------------------------
{
	Behavior DoAttack ( "" , 15 , 1 , "shuffle" )

	states
		{
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		NO_NODE_COMBAT_ENEMY_IN_MELEE_RANGE		: BEHAVIOR_SUCCESS RANGE ( $RANGE_MELEE$ )
		NO_NODE_COMBAT_ENEMY_IN_MELEE_RANGE		: BEHAVIOR_FAILED RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: BEHAVIOR_SUCCESS
		COMBAT_MAIN								: BEHAVIOR_FAILED
		}
}

//------------------------------------------------------------------------------
state NO_NODE_COMBAT_MELEE_RANGE_ATTACK_WITH_WEAPON
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		NO_NODE_COMBAT_ENEMY_IN_MELEE_RANGE		: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: TORSO_BEHAVIOR_DONE
		}
}


//---------------------------------------------------------
state FOLLOW_THE_LEADER
//---------------------------------------------------------
	{
	entrycommands
		{
		incontext "combatfollow"
		}

//13.02.2008
	Behavior CloseInOnPlayer ( "walk" , 192 )

	states
		{
		HANDLE_CALL_VOLUME	: PLAYER_IN_CALL_VOLUME
		COMBAT_MAIN			: WITHIN_FOLLOW_TARGET_MIN_RANGE
		COMBAT_MAIN			: BEHAVIOR_SUCCESS
		HOLD				: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state HOLD
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage "COMBAT:  HOLD"
		}

	legs
		{
		idle : default
		}

	time ( 1 )

	states
		{
		COMBAT_MAIN	: TIME_DONE
		}
	}

//---------------------------------------------------------
state HANDLE_CALL_VOLUME
//---------------------------------------------------------
	{
	entrycommands
		{
		incontext "incallvolume"
		}

	Behavior GotoLiftPosition

	states
		{
		COMBAT_MAIN			: !PLAYER_IN_CALL_VOLUME
		COMBAT_MAIN			: BEHAVIOR_SUCCESS
		CALL_VOLUME_FAILED	: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state CALL_VOLUME_FAILED
//---------------------------------------------------------
	{
	legs
		{
		duck : default
		}
	}




//===============================================================================================
//---------------------------------------------------------
// Cover Combat
//---------------------------------------------------------
//==============================================================================================

//---------------------------------------------------------
state COVER_COMBAT_WITH_RANGED_WEAPON
//---------------------------------------------------------
	{
	states 
		{
		COVER_COMBAT_PAIN						: SHOW_PAIN
		COVER_COMBAT_WITH_RANGED_WEAPON_BEGIN	: default				
		}
	}

//---------------------------------------------------------
state COVER_COMBAT_WITH_RANGED_WEAPON_BEGIN
//---------------------------------------------------------
	{
	states
		{	
		COVER_COMBAT_PAIN						: SHOW_PAIN
		COVER_COMBAT_GOTO_COVER_NODE			: default		
		}
	}


//------------------------------------------------------------------------------
state COVER_COMBAT_GOTO_COVER_NODE
//------------------------------------------------------------------------------
{
	entrycommands
		{
		incontext "incombat"
		}

	behavior GotoCurrentHelperNode ( "swat_run" , 0 )
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	
	states
		{
		COVER_COMBAT_PAIN			: SHOW_PAIN
		HANDLE_CALL_VOLUME			: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME

		COVER_COMBAT_ARRIVED_AT_COVER_NODE		: BEHAVIOR_SUCCESS
		COVER_COMBAT_GOTO_COVER_NODE_FAILED		: BEHAVIOR_FAILED
		COVER_COMBAT_GOTO_COVER_NODE_RESET		: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_GOTO_COMBAT_NODE
//------------------------------------------------------------------------------
{
	entrycommands
		{
		incontext "incombat"
		}

	behavior GotoCurrentHelperNode ( "swat_run" , 0 )
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	
	states
		{
		COVER_COMBAT_PAIN			: SHOW_PAIN
		HANDLE_CALL_VOLUME			: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME

		COVER_COMBAT_ARRIVED_AT_COMBAT_NODE		: BEHAVIOR_SUCCESS
		COVER_COMBAT_GOTO_COMBAT_NODE_FAILED	: BEHAVIOR_FAILED
		COVER_COMBAT_GOTO_COMBAT_NODE_RESET		: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_GOTO_COMBAT_NODE_FAILED
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		COVER_COMBAT_ENEMY_IN_MELEE_RANGE	: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COVER_COMBAT_GOTO_COMBAT_NODE		: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_GOTO_COMBAT_NODE_RESET
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_GOTO_COMBAT_NODE : default
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_GOTO_COVER_NODE_FAILED
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		COVER_COMBAT_ENEMY_IN_MELEE_RANGE	: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COVER_COMBAT_GOTO_COVER_NODE		: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_GOTO_COVER_NODE_RESET
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_GOTO_COVER_NODE : default
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_ARRIVED_AT_COVER_NODE
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_FIND_NEW_SPOT					: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_DUCK	: default
		}
}


//------------------------------------------------------------------------------
state COVER_COMBAT_ARRIVED_AT_COMBAT_NODE
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_FIND_NEW_SPOT				: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_ATTACK_FROM_COMBAT_NODE	: default
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_COMBAT_NODE
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		COVER_COMBAT_FIND_NEW_SPOT					: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_ATTACK_FROM_COMBAT_NODE_REPEAT	: TORSO_BEHAVIOR_DONE CHANCE ( $CHANCE_REPEAT_ATTACK$ )
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_COMBAT_NODE_REPEAT
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_GOTO_COVER_NODE			: VALID_COVER_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_ANY_NODE$ , $RANGE_MIN_DISTANCE_TO_COVER_NODE$ )
		COVER_COMBAT_ATTACK_FROM_COMBAT_NODE	: default
		}
}

//---------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_CRATE_COVER_DUCK
//---------------------------------------------------------
{
	entrycommands
		{
		gotostage 1
		}

	legs
		{
		to_crouch : default
		}

	states
		{
		COVER_COMBAT_FIND_NEW_SPOT					: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_WAIT	: ANIM_DONE
		}
}

//---------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_CRATE_COVER_WAIT
//---------------------------------------------------------
{
	legs
		{
		crouch_idle : default
		}

	time ( $TIME_WAIT_AT_COVER_MIN$ , $TIME_WAIT_AT_COVER_MAX$ )

	states
		{
		COVER_COMBAT_FIND_NEW_SPOT	: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_SPOTTED_STAND_UP : ENEMY_CAN_SEE_CURRENT_NODE
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_STANDUP_TO_ATTACK : TIME_DONE
		}
}

//---------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_CRATE_COVER_STANDUP_TO_ATTACK
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		from_crouch : default
		}

	states
		{
		COVER_COMBAT_FIND_NEW_SPOT	: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_SPOTTED 	: ANIM_DONE ENEMY_CAN_SEE_CURRENT_NODE		
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER : ANIM_DONE
		}
}

//---------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_CRATE_COVER
//---------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		COVER_COMBAT_FIND_NEW_SPOT							: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_SPOTTED								: TORSO_BEHAVIOR_DONE ENEMY_CAN_SEE_CURRENT_NODE		
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_DUCK 			: TORSO_BEHAVIOR_DONE STAGE ( $COUNT_MAX_REPEATS$ )
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_REPEAT_ATTACK	: TORSO_BEHAVIOR_DONE CHANCE ( $CHANCE_REPEAT_ATTACK$ )
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_DUCK 			: TORSO_BEHAVIOR_DONE
		}
}

//---------------------------------------------------------
state COVER_COMBAT_ATTACK_FROM_CRATE_COVER_REPEAT_ATTACK
//---------------------------------------------------------
{
	entrycommands
		{
		gotonextstage
		}

	states
		{
		COVER_COMBAT_FIND_NEW_SPOT	: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER : default
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_FIND_NEW_SPOT
//------------------------------------------------------------------------------
{
	states
		{		
		COVER_COMBAT_GOTO_COVER_NODE 			: VALID_COVER_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_ANY_NODE$ , $RANGE_MIN_DISTANCE_TO_COVER_NODE$ )
		COVER_COMBAT_GOTO_COMBAT_NODE			: VALID_COMBAT_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_ANY_NODE$ )
		COVER_COMBAT_FAILED_TO_FIND_NEW_SPOT 	: default
		}	
}

//------------------------------------------------------------------------------
state COVER_COMBAT_FAILED_TO_FIND_NEW_SPOT
//------------------------------------------------------------------------------
{
	legs
		{
		idle : default
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_SPOTTED_STAND_UP
//------------------------------------------------------------------------------
{
	legs
		{
		from_crouch : default
		}

	states
		{		
		COVER_COMBAT_SPOTTED 	: ANIM_DONE
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_SPOTTED
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		COVER_COMBAT_FIND_NEW_SPOT							: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_DUCK			: TORSO_BEHAVIOR_DONE !ENEMY_CAN_SEE_CURRENT_NODE
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_REPEAT_ATTACK	: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_WITH_RANGED_WEAPON_FAILED
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		COVER_COMBAT_ENEMY_IN_MELEE_RANGE			: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )	
		COVER_COMBAT_ATTACK_FROM_CRATE_COVER_DUCK	: TORSO_BEHAVIOR_DONE !ENEMY_CAN_SEE_CURRENT_NODE
		COVER_COMBAT_SPOTTED						: TORSO_BEHAVIOR_DONE
		}
}


//---------------------------------------------------------
state COVER_COMBAT_PAIN
//---------------------------------------------------------
	{
	states
		{
		COVER_COMBAT_BIG_PAIN		: MOD ( "explosion" )
		COVER_COMBAT_BIG_PAIN		: MOD ( "imod_primary" )
		COVER_COMBAT_BIG_PAIN		: MOD ( "plasmashotgun" )
		COVER_COMBAT_BIG_PAIN		: MOD ( "small_explosion" )
		COVER_COMBAT_SMALL_PAIN		: default
		}	
	}

//---------------------------------------------------------
state COVER_COMBAT_BIG_PAIN
//---------------------------------------------------------
{
	legs
		{
		pain_knockback : default
		}

	states
		{		
		COVER_COMBAT_GOTO_COVER_NODE	: ANIM_DONE
		}
}

//---------------------------------------------------------
state COVER_COMBAT_SMALL_PAIN
//---------------------------------------------------------
{
	entrycommands
		{
		saveofflasthitbone
		}

	legs
		{		
		pain_stomach	: BONE_DAMAGED ( "Bip01 Pelvis" )
		pain_stomach	: BONE_DAMAGED ( "Bip01 Spine" )
		pain_chest		: BONE_DAMAGED ( "Bip01 Spine2" )
		pain_head		: BONE_DAMAGED ( "Bip01 Head" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Clavicle" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Upperarm" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Forearm" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Hand" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Finger2" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Clavicle" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Upperarm" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Forearm" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Hand" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Finger2" )
		pain_leg_L		: BONE_DAMAGED ( "Bip01 L Thigh" )
		pain_L_lowerleg	: BONE_DAMAGED ( "Bip01 L Calf" )
		pain_L_lowerleg	: BONE_DAMAGED ( "Bip01 L Foot" )
		pain_L_lowerleg	: BONE_DAMAGED ( "Bip01 L Toe0" )		
		pain_leg_R		: BONE_DAMAGED ( "Bip01 R Thigh" )
		pain_R_lowerleg	: BONE_DAMAGED ( "Bip01 R Calf" )
		pain_R_lowerleg	: BONE_DAMAGED ( "Bip01 R Foot" )
		pain_R_lowerleg	: BONE_DAMAGED ( "Bip01 R Toe0" )
		pain_chest		: default
		}

	states
		{		
		COVER_COMBAT_GOTO_COVER_NODE : ANIM_DONE
		}

}

//------------------------------------------------------------------------------
state COVER_COMBAT_ENEMY_IN_MELEE_RANGE
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_MELEE_RANGE_ATTACK_WITH_MELEE	: ALLOWED_TO_MELEE_ENEMY CHANCE ( $CHANCE_DO_MELEE$ )
		COVER_COMBAT_MELEE_RANGE_ATTACK_WITH_WEAPON	: default
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_MELEE_RANGE_ATTACK_WITH_MELEE
//------------------------------------------------------------------------------
{
	Behavior DoAttack ( "" , 15 , 1 , "shuffle" )

	states
		{
		COVER_COMBAT_ENEMY_IN_MELEE_RANGE		: BEHAVIOR_SUCCESS RANGE ( $RANGE_MELEE$ )
		COVER_COMBAT_ENEMY_IN_MELEE_RANGE		: BEHAVIOR_FAILED RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: BEHAVIOR_SUCCESS
		COMBAT_MAIN								: BEHAVIOR_FAILED
		}
}

//------------------------------------------------------------------------------
state COVER_COMBAT_MELEE_RANGE_ATTACK_WITH_WEAPON
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		COVER_COMBAT_ENEMY_IN_MELEE_RANGE		: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: TORSO_BEHAVIOR_DONE
		}
}




//===============================================================================================
//---------------------------------------------------------
// Positional Combat
//---------------------------------------------------------
//==============================================================================================

state POSITIONAL_COMBAT_WITH_RANGED_WEAPON
{
	states
		{
		POSITIONAL_COMBAT_PAIN : SHOW_PAIN
		POSITIONAL_COMBAT_WITH_RANGED_WEAPON_BEGIN : default
		}
}


//---------------------------------------------------------
state POSITIONAL_COMBAT_WITH_RANGED_WEAPON_BEGIN
//---------------------------------------------------------
	{
	states
		{	
		POSITIONAL_COMBAT_PAIN						: SHOW_PAIN
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE			: default		
		}
	}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_GOTO_COMBAT_NODE
//------------------------------------------------------------------------------
{
	entrycommands
		{
		incontext "incombat"
		}

	behavior GotoCurrentHelperNode ( "swat_run" , 0 )
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	
	states
		{
		POSITIONAL_COMBAT_PAIN			: SHOW_PAIN
		//FOLLOW_THE_LEADER			: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		HANDLE_CALL_VOLUME			: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME

		POSITIONAL_COMBAT_ARRIVED_AT_COMBAT_NODE		: BEHAVIOR_SUCCESS
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE_FAILED		: BEHAVIOR_FAILED
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE_RESET		: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_GOTO_COMBAT_NODE_FAILED
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		POSITIONAL_COMBAT_ENEMY_IN_MELEE_RANGE	: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE		: TORSO_BEHAVIOR_DONE
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_GOTO_COMBAT_NODE_RESET
//------------------------------------------------------------------------------
{
	states
		{
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE : default
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_ARRIVED_AT_COMBAT_NODE
//------------------------------------------------------------------------------
{
	states
		{
		POSITIONAL_COMBAT_FIND_NEW_SPOT				: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		POSITIONAL_COMBAT_ATTACK_FROM_COMBAT_NODE	: default
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_ATTACK_FROM_COMBAT_NODE
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		POSITIONAL_COMBAT_ENEMY_IN_MELEE_RANGE				: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )	
		POSITIONAL_COMBAT_FIND_NEW_SPOT						: PLAYER_RANGE ( $PLAYER_NEAR_ME$ )
		POSITIONAL_COMBAT_ATTACK_FROM_COMBAT_NODE_REPEAT	: TORSO_BEHAVIOR_DONE CHANCE ( $CHANCE_REPEAT_ATTACK$ )
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_ATTACK_FROM_COMBAT_NODE_REPEAT
//------------------------------------------------------------------------------
{
	states
		{
		COVER_COMBAT_GOTO_COVER_NODE			: VALID_COVER_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_ANY_NODE$ , $RANGE_MIN_DISTANCE_TO_COVER_NODE$ )
		POSITIONAL_COMBAT_ATTACK_FROM_COMBAT_NODE	: default
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_FIND_NEW_SPOT
//------------------------------------------------------------------------------
{
	states
		{		
		COVER_COMBAT_GOTO_COVER_NODE				: VALID_COVER_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_ANY_NODE$ , $RANGE_MIN_DISTANCE_TO_COVER_NODE$ )
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE			: VALID_COMBAT_NODE_IN_RANGE ( $RANGE_MAX_DISTANCE_TO_ANY_NODE$ )
		POSITIONAL_COMBAT_FAILED_TO_FIND_NEW_SPOT	: default
		}	
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_FAILED_TO_FIND_NEW_SPOT
//------------------------------------------------------------------------------
{
	legs
		{
		idle : default
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_ENEMY_IN_MELEE_RANGE
//------------------------------------------------------------------------------
{
	states
		{
		POSITIONAL_COMBAT_MELEE_RANGE_ATTACK_WITH_MELEE	: ALLOWED_TO_MELEE_ENEMY CHANCE ( $CHANCE_DO_MELEE$ )
		POSITIONAL_COMBAT_MELEE_RANGE_ATTACK_WITH_WEAPON	: default
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_MELEE_RANGE_ATTACK_WITH_MELEE
//------------------------------------------------------------------------------
{
	Behavior DoAttack ( "" , 15 , 1 , "shuffle" )

	states
		{
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_THE_WAY
		NO_NODE_COMBAT_GET_OUT_OF_THE_WAY	: IN_PLAYER_CONE_OF_FIRE
		POSITIONAL_COMBAT_ENEMY_IN_MELEE_RANGE		: BEHAVIOR_SUCCESS RANGE ( $RANGE_MELEE$ )
		POSITIONAL_COMBAT_ENEMY_IN_MELEE_RANGE		: BEHAVIOR_FAILED RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN									: BEHAVIOR_SUCCESS
		COMBAT_MAIN									: BEHAVIOR_FAILED
		}
}

//------------------------------------------------------------------------------
state POSITIONAL_COMBAT_MELEE_RANGE_ATTACK_WITH_WEAPON
//------------------------------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{
		POSITIONAL_COMBAT_ENEMY_IN_MELEE_RANGE		: TORSO_BEHAVIOR_DONE RANGE ( $RANGE_MELEE$ )
		COMBAT_MAIN								: TORSO_BEHAVIOR_DONE
		}
}
//---------------------------------------------------------
state POSITIONAL_COMBAT_PAIN
//---------------------------------------------------------
	{
	states
		{
		POSITIONAL_COMBAT_BIG_PAIN		: MOD ( "explosion" )
		POSITIONAL_COMBAT_BIG_PAIN		: MOD ( "imod_primary" )
		POSITIONAL_COMBAT_BIG_PAIN		: MOD ( "plasmashotgun" )
		POSITIONAL_COMBAT_BIG_PAIN		: MOD ( "small_explosion" )
		POSITIONAL_COMBAT_SMALL_PAIN	: default
		}	
	}

//---------------------------------------------------------
state POSITIONAL_COMBAT_BIG_PAIN
//---------------------------------------------------------
{
	legs
		{
		pain_knockback : default
		}

	states
		{		
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE	: ANIM_DONE
		}
}

//---------------------------------------------------------
state POSITIONAL_COMBAT_SMALL_PAIN
//---------------------------------------------------------
{
	entrycommands
		{
		saveofflasthitbone
		}

	legs
		{		
		pain_stomach	: BONE_DAMAGED ( "Bip01 Pelvis" )
		pain_stomach	: BONE_DAMAGED ( "Bip01 Spine" )
		pain_chest		: BONE_DAMAGED ( "Bip01 Spine2" )
		pain_head		: BONE_DAMAGED ( "Bip01 Head" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Clavicle" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Upperarm" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Forearm" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Hand" )
		pain_shoulder_L	: BONE_DAMAGED ( "Bip01 L Finger2" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Clavicle" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Upperarm" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Forearm" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Hand" )
		pain_shoulder_R	: BONE_DAMAGED ( "Bip01 R Finger2" )
		pain_leg_L		: BONE_DAMAGED ( "Bip01 L Thigh" )
		pain_L_lowerleg	: BONE_DAMAGED ( "Bip01 L Calf" )
		pain_L_lowerleg	: BONE_DAMAGED ( "Bip01 L Foot" )
		pain_L_lowerleg	: BONE_DAMAGED ( "Bip01 L Toe0" )		
		pain_leg_R		: BONE_DAMAGED ( "Bip01 R Thigh" )
		pain_R_lowerleg	: BONE_DAMAGED ( "Bip01 R Calf" )
		pain_R_lowerleg	: BONE_DAMAGED ( "Bip01 R Foot" )
		pain_R_lowerleg	: BONE_DAMAGED ( "Bip01 R Toe0" )
		pain_chest		: default
		}

	states
		{		
		POSITIONAL_COMBAT_GOTO_COMBAT_NODE : ANIM_DONE
		}

}