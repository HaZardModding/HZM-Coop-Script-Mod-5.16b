
$define RANGE_WORK 256
$define RANGE_PATROL 256
$define RANGE_IDLE_NODE 256
$define STAGE_TURN 8
$define CHANCE_TWITCH .95
$define CHANCE_TWITCH_REPEAT .45
$define TIME_PLAYER_ATTACK .75 
$define RANGE_FUXXORED 1052
$define RANGE_CLEAR 48
$define RANGE_TURN 24

//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	entrycommands
		{
		settendency ( "multiplayer" , 0 )
		multiplayer settendency ( "multiplayer" , 1 )
		setvartime ( "playerattacked" )
		}

	states
		{
		CORE_MAIN	: default
		}
	}

//---------------------------------------------------------
state CORE_MAIN
//---------------------------------------------------------
{
	states
		{
		PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 

		FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		GOTO_IDLE_NODE		: VALID_CUSTOM_NODE_IN_RANGE ( "idle" , $RANGE_IDLE_NODE$ )
		WANDER				: SHOULD_DO_ACTION ( "wander" )				
		HOLD				: default
		}
}

state GOTO_IDLE_NODE
{
	Behavior GotoCurrentHelperNode ( "walk" , 0 )

	states
		{
		WANDER_WAIT : BEHAVIOR_FAILED
		AT_IDLE_NODE : BEHAVIOR_SUCCESS
		}
}

state AT_IDLE_NODE
{
	entrycommands
		{
		headwatchtarget player
		setheadwatchmaxdistance 128
		}

	Behavior HoldPosition
	
	states
		{
		PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 

		FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		//GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		//CORE_MAIN		: TIME_DONE
		}

	exitcommands
		{
		headwatchtarget none
		setheadwatchmaxdistance -1
		}
}

//---------------------------------------------------------
state WANDER
//---------------------------------------------------------
	{
	entrycommands
		{
		incontext "wander"
		}

	Behavior MoveRandomDirection ( "walk" , 128 , 96 )

	states
		{
		PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 

		FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		WANDER_WAIT			: BEHAVIOR_SUCCESS
		WANDER_FAILED		: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state WANDER_WAIT
//---------------------------------------------------------
{
	entrycommands
		{
		headwatchtarget player
		setheadwatchmaxdistance 128
		}

	Behavior HoldPosition

	time ( 7 , 10 )

	states
		{
		PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 

		FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		CORE_MAIN		: TIME_DONE
		}

	exitcommands
		{
		headwatchtarget none
		setheadwatchmaxdistance -1
		}
}

//---------------------------------------------------------
state WANDER_FAILED
//---------------------------------------------------------
	{
	Behavior HoldPosition

	time ( 1.0 )

	states
		{
		PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 

		GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		WANDER	: TIME_DONE
		}
	}


//---------------------------------------------------------
state FOLLOW_THE_LEADER
//---------------------------------------------------------
{
	entrycommands
		{
		incontext "noncombatfollow"
		}

	Behavior GroupFollow ( 256 , 320 )

	states
		{
		PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
		HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		FOLLOW_FUXXORED		: FOLLOW_TARGET_OUT_OF_RANGE !PLAYER_RANGE ( $RANGE_FUXXORED$ )
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 

		GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		CORE_MAIN			: BEHAVIOR_SUCCESS
		HOLD				: BEHAVIOR_FAILED
		}
}

state FOLLOW_FUXXORED
{
	Behavior CloseInOnPlayer ( "run" , 256 )
	time ( 1.0 )

	states
		{
		FOLLOW_THE_LEADER : TIME_DONE
		CORE_MAIN		  : BEHAVIOR_SUCCESS
		}

}

state PLAYER_ATTACKED
{

	states
		{
		UPGRADE_STAGE		: CHECK_VAR_TIME_DIFFERENCE ( "playerattacked" , $TIME_PLAYER_ATTACK$ )
		CORE_PAIN			: default
		}
}

state UPGRADE_STAGE
{
	entrycommands
		{
		incontext "playerattacked"	
		gotonextstage
		setvartime ( "playerattacked" )
		}

	states
		{
		TURN_AGAINST_PLAYER : STAGE ( $STAGE_TURN$ )
		CORE_PAIN			: default
		}
}

state TURN_AGAINST_PLAYER
{
	entrycommands
		{
		incontext "turnonplayer"
		attackplayer
		groupattack	1	
		failmission 8
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

	time ( 1.0 )

	states
		{
		GET_OUT_OF_THE_WAY	: IN_THE_WAY
		CORE_PAIN			: SHOW_PAIN
		CORE_COWER			: OTHER_DIED 
		CORE_MAIN			: TIME_DONE		
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
		CORE_MAIN				: !PLAYER_IN_CALL_VOLUME
		CORE_MAIN				: BEHAVIOR_SUCCESS
		CALL_VOLUME_FAILED		: BEHAVIOR_FAILED	 
		}
	}

//---------------------------------------------------------
state CALL_VOLUME_FAILED
//---------------------------------------------------------
	{
	legs
		{
		duck	: default
		}
	}

//---------------------------------------------------------
state GET_OUT_OF_THE_WAY
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "GET_OUT_OF_THE_WAY"
	}
	states
	{
	GET_OUT_OF_THE_WAY_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	GET_OUT_OF_THE_WAY_SP	: default
	}
}
//---------------------------------------------------------
state GET_OUT_OF_THE_WAY_SP
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "GET_OUT_OF_THE_WAY_SP"
	}
	Behavior MoveFromConeOfFire ( "walk" )
	time ( 1.5 )

	states
	{
		CORE_MAIN	: BEHAVIOR_SUCCESS		
		HOLD		: BEHAVIOR_FAILED		
		CORE_MAIN  	: TIME_DONE
	}	
}
//---------------------------------------------------------
state GET_OUT_OF_THE_WAY_MP
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "GET_OUT_OF_THE_WAY_MP"
	}
	
	states
	{
		STEP_LEFT			: LEFT_CLEAR ( $RANGE_CLEAR$ ) CHANCE ( 0.4 )
		STEP_RIGHT			: RIGHT_CLEAR ( $RANGE_CLEAR$ ) CHANCE ( 0.4 )
		STEP_FORWARD		: FORWARD_CLEAR ( $RANGE_CLEAR$ )
		STEP_LEFT			: LEFT_CLEAR ( $RANGE_CLEAR$ )
		STEP_RIGHT			: RIGHT_CLEAR ( $RANGE_CLEAR$ )
		STEP_BACKWARD		: REAR_CLEAR ( $RANGE_CLEAR$ ) !LEFT_CLEAR ( $RANGE_CLEAR$ ) !RIGHT_CLEAR ( $RANGE_CLEAR$ )
		STEP_TURN_AGAIN		: !REAR_CLEAR ( $RANGE_TURN$ ) !LEFT_CLEAR ( $RANGE_TURN$ ) !RIGHT_CLEAR ( $RANGE_TURN$ ) !FORWARD_CLEAR ( $RANGE_TURN$ )
		CORE_MAIN			: default
	}
}
//---------------------------------------------------------
state STEP_LEFT
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "STEP_LEFT"
	//turntowardsenemy
	}
	
	time ( 0.25 )

	legs
	{
		//strafe_left : default
		dead : default
	}
	
	states
	{
		STEP_EXIT	: ANIM_DONE
	}
}
//---------------------------------------------------------
state STEP_RIGHT
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "STEP_RIGHT"
	//turntowardsenemy
	}
	
	time ( 0.25 )
	
	legs
	{
		//strafe_right : default
		run : default
	}
	
	states
	{
		STEP_EXIT	: ANIM_DONE
	}
}
//---------------------------------------------------------
state STEP_BACKWARD
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "STEP_BACKWARD"
	//turntowardsenemy
	}
	
	Behavior Turn ( 45 )
	time ( 0.05 )
	
	legs
	{
		idle : default
	}
	
	states
	{
		GET_OUT_OF_THE_WAY_MP	: TIME_DONE IN_THE_WAY
		STEP_TURN_AGAIN			: TIME_DONE
	}
	exitcommands
	{
	resetmovedir
	}
}
//---------------------------------------------------------
state STEP_TURN_AGAIN
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "STEP_TURN_AGAIN"
	}
	
	Behavior Turn ( 45 )
	time ( 0.05 )
	
	legs
	{
		idle : default
	}
	
	states
	{
		GET_OUT_OF_THE_WAY_MP	: TIME_DONE IN_THE_WAY
		STEP_EXIT				: TIME_DONE
	}

	exitcommands
	{
	resetmovedir
	}
}
//---------------------------------------------------------
state STEP_FORWARD
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "STEP_FORWARD"
	//turntowardsenemy
	}
	
	time ( 0.4 )
	
	legs
	{
		run : default
	}
	
	states
	{
		STEP_EXIT		: ANIM_DONE
	}
}
//---------------------------------------------------------
state STEP_EXIT
//---------------------------------------------------------
{
	entrycommands
	{
	printmessage "STEP_EXIT"
	}
	
	legs
	{
		idle : default
	}
	
	states
	{
		CORE_MAIN	: default
	}
}

state CORE_COWER
{
	entrycommands
		{
		cleartorsoanim
		}
	legs
		{
		cower : default
		}

	time ( 5 , 7.0 )

	states
		{
		CORE_MAIN : TIME_DONE
		}
}

//---------------------------------------------------------
state CORE_PAIN
//---------------------------------------------------------
	{
	states
		{
		CORE_BIG_PAIN	  : MOD ( "explosion" )
		CORE_BIG_PAIN	  : MOD ( "imod_primary" )
		CORE_BIG_PAIN	  : MOD ( "plasmashotgun" )
		CORE_BIG_PAIN	  : MOD ( "small_explosion" )
		CORE_SMALL_PAIN : default
		}	
	}

//---------------------------------------------------------
state CORE_BIG_PAIN
//---------------------------------------------------------
{
	legs
		{
		pain_knockback : default
		}

	states
		{		
		CORE_MAIN : ANIM_DONE
		}
}

//---------------------------------------------------------
state CORE_SMALL_PAIN
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
		CORE_MAIN : ANIM_DONE
		}

}
