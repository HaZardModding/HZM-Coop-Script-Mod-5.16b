////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////HaZardModding HYBRID AI
////////////////////////////////////////////////////////////////////////////////
// Name:     Humanoid_PackageCore
// Purpose:  AI for Non Combat State Humanoids
//

//
// Includes
//

//
// Defines
//
$define RANGE_WORK 256
$define RANGE_PATROL 256
$define RANGE_IDLE_NODE 512//
$define STAGE_TURN 8
$define CHANCE_TWITCH .95
$define CHANCE_TWITCH_REPEAT .45
$define TIME_PLAYER_ATTACK .75 
$define RANGE_FUXXORED 900 //1052
$define RANGE_FOLLOW 256 //1052

//---------------------------------------------------------
state START // ()
//---------------------------------------------------------
	{
	entrycommands
		{
		setvartime ( "playerattacked" )
		}

	states
		{
		CORE_MAIN	: default
		}
	}

//---------------------------------------------------------
state CORE_MAIN // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CORE_MAIN"
	}
	
	states
	{
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		FOLLOW_THE_LEADER		: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		
		CORE_PAIN				: SHOW_PAIN

		WANDER					: SHOULD_DO_ACTION ( "wander" )
		GET_OUT_OF_THE_WAY		: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		GOTO_IDLE_NODE			: VALID_CUSTOM_NODE_IN_RANGE ( "idle" , $RANGE_IDLE_NODE$ )
		
		RESET_ANIMATION : default
	}
}

//---------------------------------------------------------
state GOTO_IDLE_NODE // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "GOTO_IDLE_NODE"
	}
	
	Behavior GotoCurrentHelperNode ( "walk" , 0 )
	time ( 1 )

	states
	{
		WANDER_WAIT		: BEHAVIOR_FAILED
		AT_IDLE_NODE	: BEHAVIOR_SUCCESS
		CORE_MAIN		: TIME_DONE
	}
}

//---------------------------------------------------------
state AT_IDLE_NODE // ()
//---------------------------------------------------------
{
	entrycommands
	{
		setheadwatchmaxdistance 256
	}

	Behavior HoldPosition
	
	states
		{
		CORE_PAIN			: SHOW_PAIN
		FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		HOLD : BEHAVIOR_FAILED
		CORE_MAIN			: TIME_DONE
		}

	exitcommands
	{
		headwatchtarget none
		setheadwatchmaxdistance -1
	}
}

//---------------------------------------------------------
state WANDER // ()
//---------------------------------------------------------
{	
	entrycommands
	{
		incontext "wander"
		//printmessage "WANDER"
	}

	Behavior MoveRandomDirection ( "walk" , 200 , 32 )//walk 192 64

	states
	{
		CORE_MAIN				: !SHOULD_DO_ACTION ( "wander" )
		CORE_PAIN				: SHOW_PAIN
		WANDER_WAIT				: BEHAVIOR_SUCCESS
		GET_OUT_OF_THE_WAY		: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		WANDER_FAILED			: BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state WANDER_WAIT // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "WANDER_WAIT"
	}
	
	states
	{
		WANDER_WAIT_WATCH0		: SHOULD_DO_ACTION ( "watch0" )
		WANDER_WAIT_WATCH1		: SHOULD_DO_ACTION ( "watch1" )
		WANDER_WAIT_WATCH2		: SHOULD_DO_ACTION ( "watch2" )
		WANDER_WAIT_WATCH3		: SHOULD_DO_ACTION ( "watch3" )
		WANDER_WAIT_WATCH4		: SHOULD_DO_ACTION ( "watch4" )
		WANDER_WAIT_WATCH5		: SHOULD_DO_ACTION ( "watch5" )
		WANDER_WAIT_WATCH6		: SHOULD_DO_ACTION ( "watch6" )
		WANDER_WAIT_WATCH7		: SHOULD_DO_ACTION ( "watch7" )
		WANDER_WAIT_WATCH8		: SHOULD_DO_ACTION ( "watch8" )
		
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		
		CORE_PAIN				: SHOW_PAIN
		HOLD					: BEHAVIOR_FAILED
		GET_OUT_OF_THE_WAY		: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		WANDER_WAIT_WATCH		: default
	}
}


//---------------------------------------------------------
state WANDER_WAIT_WATCH // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget player
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH0 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player0"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH1 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player1"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH2 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player2"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}


//---------------------------------------------------------
state WANDER_WAIT_WATCH3 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player3"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH4 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player4"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH5 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player5"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH6 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player6"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH7 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player7"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_WATCH8 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		headwatchtarget "player8"
	}	

	states
	{
		WANDER_WAIT_DO_WAIT		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_DO_WAIT // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "WANDER_WAIT_DO_WAIT"
		setheadwatchmaxdistance 256
	}
	
	time ( 1 , 3 )
	Behavior HoldPosition

	states
	{
		CORE_MAIN				: TIME_DONE
		GET_OUT_OF_THE_WAY		: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		
		CORE_PAIN				: SHOW_PAIN
		HOLD					: BEHAVIOR_FAILED
	}

	exitcommands
	{
		headwatchtarget none
		setheadwatchmaxdistance -1
	}
}

//---------------------------------------------------------
state WANDER_FAILED // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "WANDER_FAILED"
	}	
	
	states
	{
		WANDER_WAIT : default
	}
}


//---------------------------------------------------------
state FOLLOW_THE_LEADER // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_THE_LEADER"
		incontext "noncombatfollow"
		idle : default
	}
	
	states
	{
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		CORE_PAIN			: SHOW_PAIN
		
		FOLLOW_PLAYER_0		: SHOULD_DO_ACTION ( "follow_player0" )
		FOLLOW_PLAYER_1		: SHOULD_DO_ACTION ( "follow_player1" )
		FOLLOW_PLAYER_2		: SHOULD_DO_ACTION ( "follow_player2" )
		FOLLOW_PLAYER_3		: SHOULD_DO_ACTION ( "follow_player3" )
		FOLLOW_PLAYER_4		: SHOULD_DO_ACTION ( "follow_player4" )
		FOLLOW_PLAYER_5		: SHOULD_DO_ACTION ( "follow_player5" )
		FOLLOW_PLAYER_6		: SHOULD_DO_ACTION ( "follow_player6" )
		FOLLOW_PLAYER_7		: SHOULD_DO_ACTION ( "follow_player7" )
		FOLLOW_PLAYER_8		: SHOULD_DO_ACTION ( "follow_player8" )
		
		FOLLOW_PLAYER		: SHOULD_DO_ACTION ( "follow" )
		HOLD				: default
	}
	exitcommands
	{
		idle : default
	}
}


//---------------------------------------------------------
state FOLLOW_PLAYER // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER"
		incontext "noncombatfollow"
		//cleartorsoanim : default
	}
	
	Behavior CloseInOnPlayer ( "run" , 180 )
	time ( 1 )
	
	states
	{
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )		
		FOLLOW_FUXXORED		: FOLLOW_TARGET_OUT_OF_RANGE !PLAYER_RANGE ( $RANGE_FUXXORED$ )
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_0 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_0"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player0" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_1 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_1"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player1" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}


//---------------------------------------------------------
state FOLLOW_PLAYER_2 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_2"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player2" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_3 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_3"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player3" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_4 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_4"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player4" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_5 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_5"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player5" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_6 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_6"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player6" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_7 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_7"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player7" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_8 // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_8"
		incontext "noncombatfollow"
	}
	
	Behavior GotoSpecified ( "run" , "player8" )
	time ( 1 )
	
	states
	{
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_PAIN			: SHOW_PAIN
		WANDER				: BEHAVIOR_SUCCESS
		CORE_MAIN 			: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_FUXXORED // ()
//---------------------------------------------------------
{
	entrycommands
	{
		incontext "noncombatfollow"
		//printmessage "FOLLOW_FUXXORED"
	}
	
	Behavior CloseInOnPlayer ( "run" , 128 )
	time ( 1 )

	states
	{
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )
		
		RESET_ANIMATION : BEHAVIOR_FAILED
		RESET_ANIMATION : BEHAVIOR_SUCCESS
		CORE_MAIN			: TIME_DONE
		CORE_PAIN			: SHOW_PAIN
	}
}

//---------------------------------------------------------
state RESET_ANIMATION //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "RESET_ANIMATION"
	}
	
	legs
	{
		idle : default
	}
	
	states
	{
		//CORE_MAIN : default
		WANDER_WAIT : default
	}
}


state RESET_ANIMATION_ONLY //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "RESET_ANIMATION_ONLY"
	}
	
	legs
	{
		idle : default
	}
	
	time ( 0.35 , 0.5 )
	
	states
	{
		CORE_MAIN : TIME_DONE
	}
}

//---------------------------------------------------------
state HOLD // ()
//---------------------------------------------------------
{	
	entrycommands
	{
		//printmessage "HOLD"
	}
	
	Behavior HoldPosition
	time ( 1 )

	states
	{
		GET_OUT_OF_THE_WAY		: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
		GOTO_IDLE_NODE			: VALID_CUSTOM_NODE_IN_RANGE ( "idle" , $RANGE_IDLE_NODE$ )
		RESET_ANIMATION : BEHAVIOR_FAILED
		WANDER				: TIME_DONE
	}
}

//---------------------------------------------------------
state HANDLE_CALL_VOLUME_SP // ()
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
		RESET_ANIMATION_ONLY	: BEHAVIOR_FAILED
	}
}


//---------------------------------------------------------
state GET_OUT_OF_THE_WAY // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "GET_OUT_OF_THE_WAY"
	}
	states
	{
		HANDLE_CALL_VOLUME_SP	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
		FOLLOW_THE_LEADER		: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
		GET_OUT_OF_THE_WAY_DO_SO : default
	}
}

//---------------------------------------------------------
state GET_OUT_OF_THE_WAY_DO_SO // ()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "GET_OUT_OF_THE_WAY_DO_SO"
	}
	
	Behavior MoveRandomDirection ( "walk" , 128 , 32 )
	time ( .7 )

	states
	{
		CORE_MAIN		: SHOULD_DO_ACTION ( "handlecallvolume_mp" )
		CORE_MAIN		: BEHAVIOR_SUCCESS	
		RESET_ANIMATION : BEHAVIOR_FAILED
		CORE_MAIN		: TIME_DONE
	}
}


//---------------------------------------------------------
state CORE_PAIN // ()
//---------------------------------------------------------
{
	states
	{
		CORE_BIG_PAIN	  	: MOD ( "explosion" )
		CORE_BIG_PAIN	  	: MOD ( "imod_primary" )
		CORE_BIG_PAIN	  	: MOD ( "plasmashotgun" )
		CORE_BIG_PAIN	  	: MOD ( "small_explosion" )
		CORE_SMALL_PAIN 	: default
		HOLD : BEHAVIOR_FAILED
	}	
}

//---------------------------------------------------------
state CORE_BIG_PAIN // ()
//---------------------------------------------------------
{
	legs
	{
		pain_knockback : default
	}

	states
	{		
		CORE_MAIN : ANIM_DONE
		HOLD : BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state CORE_SMALL_PAIN // ()
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
		HOLD : BEHAVIOR_FAILED
	}
}
