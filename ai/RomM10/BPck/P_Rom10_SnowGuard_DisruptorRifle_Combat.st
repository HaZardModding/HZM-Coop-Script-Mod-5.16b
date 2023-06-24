//
//---------------------------------------------------------------------------------------------------------------
// Name:     Package_DisruptorPistolCombat
// Purpose:  Gives Pistol "Grunt" AI to M11 Romulans
//
// Rules: 
//
//---------------------------------------------------------------------------------------------------------------
//

//---------------------------------------------------------
$define RANGE_MAX_DISTANCE_TO_COMBAT_NODE	512
$define RANGE_SPARRING						384
$define TIME_WAIT_ON_ATTACK_MIN				1.0
$define TIME_WAIT_ON_ATTACK_MAX				1.5
$define TIME_CHASE_TIME_MAX					2.5
$define TIME_DODGE							1.0
$define CHANCE_DODGE						.65
$define CHANCE_DIVE							.05
$define CHANCE_MANUEVER_FIRE				.35
$define CHANCE_SPLIT						.5
$define RANGE_MELEE 						96
$define DISTANCE_STRAFE 					64.0
//---------------------------------------------------------


//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	entrycommands
		{		
		turntowardsplayer
		setvartime ( "last_dodge" )
		//groupattack
		selectclosestenemy		
		}
		
	Time ( 0.5 )

	states
		{
		STUPID_STEALTH_DIALOG_HACK		: TIME_DONE CAN_SEE_ENEMY

		GENERAL_COMBAT_PAIN							: TIME_DONE SHOW_PAIN		
		CLOSE_IN_ON_ENEMY : TIME_DONE 
		}
	}

state STUPID_STEALTH_DIALOG_HACK
{
	entrycommands
		{
		incontext "incombat"
		}	

	states
		{
		GENERAL_COMBAT_PAIN							: SHOW_PAIN
		CLOSE_IN_ON_ENEMY : default
		}
}

//---------------------------------------------------------
state CLOSE_IN_ON_ENEMY
//---------------------------------------------------------
	{
	Behavior CloseInOnEnemy ( "run_footprint" , $RANGE_SPARRING$ )
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	time ( $TIME_CHASE_TIME_MAX$ )

	states
		{
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		CLOSE_IN_ON_ENEMY_FAILED			: TIME_DONE
		AT_SPARRING_RANGE					: BEHAVIOR_SUCCESS
		CLOSE_IN_ON_ENEMY_FAILED 			: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state CLOSE_IN_ON_ENEMY_FAILED
//---------------------------------------------------------
	{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		CLOSE_IN_ON_ENEMY						: TORSO_BEHAVIOR_DONE
		}	
	}

//---------------------------------------------------------
state AT_SPARRING_RANGE
//---------------------------------------------------------
	{
	states
		{
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		CLOSE_IN_ON_ENEMY		: !RANGE ( $RANGE_SPARRING$ )
		MELEE_COMBAT			: RANGE ( $RANGE_MELEE$ )
		GENERAL_COMBAT_DODGE	: CHANCE ( $CHANCE_DODGE$ , 1 ) IN_CONE_OF_FIRE CHECK_VAR_TIME_DIFFERENCE ( "last_dodge" , $TIME_DODGE$ )
		MANUEVER				: default
		}
	}

//---------------------------------------------------------
state GENERAL_COMBAT_DODGE
//---------------------------------------------------------
{
	entrycommands
		{
		setvartime ( "last_dodge" )
		}

	states
		{
		GENERAL_COMBAT_CHECK_LEFT : CHANCE ( $CHANCE_SPLIT$ )
		GENERAL_COMBAT_CHECK_RIGHT : default
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_CHECK_LEFT
//---------------------------------------------------------
{
	states
		{
		GENERAL_COMBAT_SELECT_DODGE_LEFT : LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		GENERAL_COMBAT_CHECK_LEFT_FAILED : default
		}	
}

//---------------------------------------------------------
state GENERAL_COMBAT_CHECK_LEFT_FAILED
//---------------------------------------------------------
{
	states
		{
		GENERAL_COMBAT_SELECT_DODGE_RIGHT : RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		CANT_DODGE : default
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_CHECK_RIGHT
//---------------------------------------------------------
{
	states
		{
		GENERAL_COMBAT_SELECT_DODGE_RIGHT : RIGHT_CLEAR ( $DISTANCE_STRAFE$ )
		GENERAL_COMBAT_CHECK_RIGHT_FAILED : default
		}	
}

//---------------------------------------------------------
state GENERAL_COMBAT_CHECK_RIGHT_FAILED
//---------------------------------------------------------
{
	states
		{
		GENERAL_COMBAT_SELECT_DODGE_LEFT : LEFT_CLEAR ( $DISTANCE_STRAFE$ )
		CANT_DODGE : default
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_SELECT_DODGE_LEFT
//---------------------------------------------------------
{
	states
		{		
		GENERAL_COMBAT_DIVE_LEFT : CHANCE ( $CHANCE_DIVE$ )
		GENERAL_COMBAT_DODGE_LEFT : default
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_SELECT_DODGE_RIGHT
//---------------------------------------------------------
{
	states
		{		
		GENERAL_COMBAT_DIVE_RIGHT : CHANCE ( $CHANCE_DIVE$ )
		GENERAL_COMBAT_DODGE_RIGHT : default
		}
}
 
//---------------------------------------------------------
state GENERAL_COMBAT_DIVE
//---------------------------------------------------------
{
	states
		{
		GENERAL_COMBAT_DIVE_LEFT : CHANCE ( $CHANCE_SPLIT$ )
		GENERAL_COMBAT_DIVE_RIGHT : default
		}

}

//---------------------------------------------------------
state GENERAL_COMBAT_DODGE_LEFT
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		swat_dodge_L : default
		}

	states
		{
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		CLOSE_IN_ON_ENEMY									: ANIM_DONE !RANGE ( $RANGE_SPARRING$ ) HAVE_PATH_TO_ENEMY
		AT_SPARRING_RANGE 									: ANIM_DONE		
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_DODGE_RIGHT
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		swat_dodge_R : default
		}

	states
		{
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		CLOSE_IN_ON_ENEMY									: ANIM_DONE !RANGE ( $RANGE_SPARRING$ ) HAVE_PATH_TO_ENEMY
		AT_SPARRING_RANGE 									: ANIM_DONE		
		}
}


//---------------------------------------------------------
state GENERAL_COMBAT_DIVE_LEFT
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy
		}

	legs
		{
		diveroll_L : default		
		}

	states
		{
		CLOSE_IN_ON_ENEMY									: ANIM_DONE !RANGE ( $RANGE_SPARRING$ ) HAVE_PATH_TO_ENEMY
		AT_SPARRING_RANGE 									: ANIM_DONE		
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_DIVE_RIGHT
//---------------------------------------------------------
{
	entrycommands
		{
		turntowardsenemy		
		}

	legs
		{
		diveroll_R : default
		}

	states
		{
		CLOSE_IN_ON_ENEMY									: ANIM_DONE !RANGE ( $RANGE_SPARRING$ ) HAVE_PATH_TO_ENEMY
		AT_SPARRING_RANGE 									: ANIM_DONE		
		}
}

//---------------------------------------------------------
state CANT_DODGE
//---------------------------------------------------------
{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior WatchEntity ( 1 , 15 , "shuffle" , 0 , "idle_weapon_legs" )
	
	states 
		{	
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		CLOSE_IN_ON_ENEMY									: !RANGE ( $RANGE_SPARRING$ ) HAVE_PATH_TO_ENEMY
		AT_SPARRING_RANGE 									: TORSO_BEHAVIOR_DONE		
		}
}

//---------------------------------------------------------
state MANUEVER
//---------------------------------------------------------
	{
	TorsoBehavior torsoAimAndFireWeapon ( 0 )
	Behavior MoveRandomDirection ( "walk_footprint" , 256 , 96 , 0 , 1 , 1 )

	Time ( 3 )

	states 
		{	
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		AT_SPARRING_RANGE						: TORSO_BEHAVIOR_DONE		
		CLOSE_IN_ON_ENEMY		: TIME_DONE
		}
	}

//------------------------------------------------------------------------------
state MELEE_COMBAT
//------------------------------------------------------------------------------
{
	Behavior DoAttack ( "" , 15 , 1 , "shuffle" )

	states
		{
		MELEE_COMBAT_RETREAT					: BEHAVIOR_SUCCESS RANGE ( $RANGE_MELEE$ )
		MELEE_COMBAT_RETREAT					: BEHAVIOR_FAILED RANGE ( $RANGE_MELEE$ )
		AT_SPARRING_RANGE						: BEHAVIOR_SUCCESS
		AT_SPARRING_RANGE						: BEHAVIOR_FAILED
		}
}

//------------------------------------------------------------------------------
state MELEE_COMBAT_RETREAT
//------------------------------------------------------------------------------
	{
	Behavior BackAwayFromEnemy ( "swat_backpedal_run" , 96.0 , 64.0 )
	TorsoBehavior torsoAimAndFireWeapon ( 0 , 1 )

	states
		{
		GENERAL_COMBAT_PAIN					: SHOW_PAIN
		AT_SPARRING_RANGE 			: BEHAVIOR_SUCCESS 
		AT_SPARRING_RANGE 			: BEHAVIOR_FAILED 
		}
	}

//---------------------------------------------------------
state GENERAL_COMBAT_PAIN
//---------------------------------------------------------
	{
	states
		{
		GENERAL_COMBAT_BIG_PAIN	  : MOD ( "explosion" )
		GENERAL_COMBAT_BIG_PAIN	  : MOD ( "imod_primary" )
		GENERAL_COMBAT_BIG_PAIN	  : MOD ( "plasmashotgun" )
		GENERAL_COMBAT_BIG_PAIN	  : MOD ( "small_explosion" )
		GENERAL_COMBAT_SMALL_PAIN : default
		}	
	}

//---------------------------------------------------------
state GENERAL_COMBAT_BIG_PAIN
//---------------------------------------------------------
{
	legs
		{
		pain_knockback : default
		}

	states
		{		
		AT_SPARRING_RANGE : ANIM_DONE
		}
}

//---------------------------------------------------------
state GENERAL_COMBAT_SMALL_PAIN
//---------------------------------------------------------
{
	entrycommands
		{
		saveofflasthitbone
		}

	legs
		{		
		pain_stomach 	: BONE_DAMAGED ( "Bip01 Pelvis" )
		pain_stomach 	: BONE_DAMAGED ( "Bip01 Spine" )
		pain_chest 		: BONE_DAMAGED ( "Bip01 Spine2" )
		pain_head 		: BONE_DAMAGED ( "Bip01 Head" )
		pain_shoulder_L : BONE_DAMAGED ( "Bip01 L Clavicle" )
		pain_shoulder_L : BONE_DAMAGED ( "Bip01 L Upperarm" )
		pain_shoulder_L : BONE_DAMAGED ( "Bip01 L Forearm" )
		pain_shoulder_L : BONE_DAMAGED ( "Bip01 L Hand" )
		pain_shoulder_L : BONE_DAMAGED ( "Bip01 L Finger2" )
		pain_shoulder_R : BONE_DAMAGED ( "Bip01 R Clavicle" )
		pain_shoulder_R : BONE_DAMAGED ( "Bip01 R Upperarm" )
		pain_shoulder_R : BONE_DAMAGED ( "Bip01 R Forearm" )
		pain_shoulder_R : BONE_DAMAGED ( "Bip01 R Hand" )
		pain_shoulder_R : BONE_DAMAGED ( "Bip01 R Finger2" )
		pain_leg_L 		: BONE_DAMAGED ( "Bip01 L Thigh" )
		pain_L_lowerleg : BONE_DAMAGED ( "Bip01 L Calf" )
		pain_L_lowerleg : BONE_DAMAGED ( "Bip01 L Foot" )
		pain_L_lowerleg : BONE_DAMAGED ( "Bip01 L Toe0" )		
		pain_leg_R 		: BONE_DAMAGED ( "Bip01 R Thigh" )
		pain_R_lowerleg : BONE_DAMAGED ( "Bip01 R Calf" )
		pain_R_lowerleg : BONE_DAMAGED ( "Bip01 R Foot" )
		pain_R_lowerleg : BONE_DAMAGED ( "Bip01 R Toe0" )
		pain_chest		: default
		}

	states
		{		
		AT_SPARRING_RANGE : ANIM_DONE
		}

}
