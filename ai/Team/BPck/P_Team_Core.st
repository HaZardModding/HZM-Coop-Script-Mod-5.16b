//
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
$define RANGE_IDLE_NODE 256
$define STAGE_TURN 8
$define CHANCE_TWITCH .95
$define CHANCE_TWITCH_REPEAT .45
$define TIME_PLAYER_ATTACK .75 
$define RANGE_FUXXORED 1052
$define RANGE_CLEAR 40
$define RANGE_TURN 24


//---------------------------------------------------------
state START
//---------------------------------------------------------
{
entrycommands
	{
	settendency ( "multiplayer" , 0 )
	setvartime ( "playerattacked" )
	multiplayer settendency ( "multiplayer" , 1 )
	multiplayer team ( 444 )
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
entrycommands
	{
	//printmessage "CORE_MAIN"
	}
states
	{
	PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
	CORE_PAIN			: SHOW_PAIN
	FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
	HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
	GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
	GOTO_IDLE_NODE		: VALID_CUSTOM_NODE_IN_RANGE ( "idle" , $RANGE_IDLE_NODE$ )
	WANDER				: SHOULD_DO_ACTION ( "wander" )				
	HOLD				: default
	}
}

//---------------------------------------------------------
state GOTO_IDLE_NODE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GOTO_IDLE_NODE"
	}
	
Behavior GotoCurrentHelperNode ( "walk" , 0 )

states
	{
	WANDER_WAIT		: BEHAVIOR_FAILED
	AT_IDLE_NODE	: BEHAVIOR_SUCCESS
	}
}

//---------------------------------------------------------
state AT_IDLE_NODE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "AT_IDLE_NODE"
	}
states
	{
	AT_IDLE_NODE_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	AT_IDLE_NODE_SP	: default
	}
}

//---------------------------------------------------------
state AT_IDLE_NODE_SP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "AT_IDLE_NODE_SP"
	headwatchtarget player
	setheadwatchmaxdistance 128
	}

Behavior HoldPosition

states
	{
	PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
	CORE_PAIN			: SHOW_PAIN

	FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
	HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
	}

exitcommands
	{
	headwatchtarget none
	setheadwatchmaxdistance -1
	}
}

//---------------------------------------------------------
state AT_IDLE_NODE_MP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "AT_IDLE_NODE_MP"
	}

Behavior HoldPosition

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_THE_LEADER_MP	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
	}
}

//---------------------------------------------------------
state WANDER
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER"
	incontext "wander"
	}

Behavior MoveRandomDirection ( "walk" , 192 , 64 )

states
	{
	PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
	CORE_PAIN			: SHOW_PAIN
	
	HOLD				: SHOULD_DO_ACTION ( "dialog" )
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
	//printmessage "wander_wait"
	}
states
	{
	WANDER_WAIT_MP		: SHOULD_DO_ACTION ( "multiplayer" )
	WANDER_WAIT_SP		: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_SP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_SP"
	headwatchtarget player
	setheadwatchmaxdistance 128
	}

Behavior HoldPosition
time ( 7 , 10 )

states
	{
	PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
	CORE_PAIN			: SHOW_PAIN

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
state WANDER_WAIT_MP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP"
	}
	
states
	{
	WANDER_WAIT_MP_WATCH_1	: SHOULD_DO_ACTION ( "follow_player1" )
	WANDER_WAIT_MP_WATCH_2	: SHOULD_DO_ACTION ( "follow_player2" )
	WANDER_WAIT_MP_WATCH_3	: SHOULD_DO_ACTION ( "follow_player3" )
	WANDER_WAIT_MP_WATCH_4	: SHOULD_DO_ACTION ( "follow_player4" )
	WANDER_WAIT_MP_WATCH_5	: SHOULD_DO_ACTION ( "follow_player5" )
	WANDER_WAIT_MP_WATCH_6	: SHOULD_DO_ACTION ( "follow_player6" )
	WANDER_WAIT_MP_WATCH_7	: SHOULD_DO_ACTION ( "follow_player7" )
	WANDER_WAIT_MP_WATCH_8	: SHOULD_DO_ACTION ( "follow_player8" )
	WANDER_WAIT_MP_WATCH	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH"
	headwatchtarget player
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}


//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_1
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_1"
	headwatchtarget player1
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_2
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_2"
	headwatchtarget player2
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_3
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_3"
	headwatchtarget player3
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_4
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_4"
	headwatchtarget player4
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_5
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_5"
	headwatchtarget player5
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_6
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_6"
	headwatchtarget player6
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_7
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_7"
	headwatchtarget player7
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}

//---------------------------------------------------------
state WANDER_WAIT_MP_WATCH_8
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_WAIT_MP_WATCH_8"
	headwatchtarget player8
	}
states
	{
	WANDER_DO_WAIT_MP	: default
	}
}


//---------------------------------------------------------
state WANDER_DO_WAIT_MP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "WANDER_DO_WAIT_MP"
	setheadwatchmaxdistance 128
	}

Behavior HoldPosition
time ( 3 , 6 )

states
	{
	CORE_PAIN			: SHOW_PAIN
	FOLLOW_THE_LEADER	: SHOULD_DO_ACTION ( "follow" ) FOLLOW_TARGET_OUT_OF_RANGE
	HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
	GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
	CORE_MAIN			: TIME_DONE
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
state FOLLOW_THE_LEADER
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_THE_LEADER"
	}
states
	{
	FOLLOW_THE_LEADER_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	FOLLOW_THE_LEADER_SP	: default
	}
}


//---------------------------------------------------------
state FOLLOW_THE_LEADER_SP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_THE_LEADER_SP"
	incontext "noncombatfollow"
	}

Behavior GroupFollow ( 256 , 320 )

states
	{
	PLAYER_ATTACKED		: ATTACKED_BY_PLAYER ACTORTYPE ( "teammate" )
	HANDLE_CALL_VOLUME	: SHOULD_DO_ACTION ( "handlecallvolume" ) PLAYER_IN_CALL_VOLUME
	CORE_MAIN			: !SHOULD_DO_ACTION ( "follow" )

	FOLLOW_FUXXORED		: FOLLOW_TARGET_OUT_OF_RANGE !PLAYER_RANGE ( $RANGE_FUXXORED$ )
	CORE_PAIN			: SHOW_PAIN

	GET_OUT_OF_THE_WAY	: SHOULD_DO_ACTION ( "getoutoftheway" ) IN_THE_WAY
	CORE_MAIN			: BEHAVIOR_SUCCESS
	HOLD				: BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_THE_LEADER_MP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_THE_LEADER_MP"
	incontext "noncombatfollow"
	}
states
	{
	CORE_MAIN						: !SHOULD_DO_ACTION ( "follow" )
	FOLLOW_PLAYER_MP_1				: SHOULD_DO_ACTION ( "follow_player1" )
	FOLLOW_PLAYER_MP_2				: SHOULD_DO_ACTION ( "follow_player2" )
	FOLLOW_PLAYER_MP_3				: SHOULD_DO_ACTION ( "follow_player3" )
	FOLLOW_PLAYER_MP_4				: SHOULD_DO_ACTION ( "follow_player4" )
	FOLLOW_PLAYER_MP_5				: SHOULD_DO_ACTION ( "follow_player5" )
	FOLLOW_PLAYER_MP_6				: SHOULD_DO_ACTION ( "follow_player6" )
	FOLLOW_PLAYER_MP_7				: SHOULD_DO_ACTION ( "follow_player7" )
	FOLLOW_PLAYER_MP_8				: SHOULD_DO_ACTION ( "follow_player8" )
	FOLLOW_PLAYER_MP				: SHOULD_DO_ACTION ( "follow_player0" )
	FOLLOW_PLAYER_MP_1_CHECK		: default
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_1_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_1_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player1" )
states
	{
	FOLLOW_PLAYER_MP_1_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_2_CHECK	: BEHAVIOR_FAILED
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_2_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_2_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player2" )
states
	{
	FOLLOW_PLAYER_MP_2_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_3_CHECK	: BEHAVIOR_FAILED
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_3_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_3_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player3" )
states
	{
	FOLLOW_PLAYER_MP_3_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_4_CHECK	: BEHAVIOR_FAILED
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_4_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_4_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player4" )
states
	{
	FOLLOW_PLAYER_MP_4_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_5_CHECK	: BEHAVIOR_FAILED
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_5_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_5_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player5" )
time ( .05 )
states
	{
	FOLLOW_PLAYER_MP_5_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_6_CHECK	: BEHAVIOR_FAILED TIME_DONE
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_6_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_6_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player6" )
time ( .05 )
states
	{
	FOLLOW_PLAYER_MP_6_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_7_CHECK	: BEHAVIOR_FAILED TIME_DONE
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_7_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_7_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player7" )
time ( .05 )
states
	{
	FOLLOW_PLAYER_MP_7_FORCE	: BEHAVIOR_SUCCESS
	FOLLOW_PLAYER_MP_8_CHECK	: BEHAVIOR_FAILED TIME_DONE
	}
}

//CHECK IF PLAYER WITH THE ID EXISTS, IF SO (BEHAVIOR_SUCCESS) FOLLOW THE PLAYER
//---------------------------------------------------------
state FOLLOW_PLAYER_MP_8_CHECK
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_8_CHECK"
	}
Behavior RotateToEntity ( 90.0 , "idle" , "$player8" )
time ( .05 )
states
	{
	FOLLOW_PLAYER_MP_8_FORCE	: BEHAVIOR_SUCCESS
	HOLD						: BEHAVIOR_FAILED TIME_DONE
	}
}


//---------------------------------------------------------
state FOLLOW_PLAYER_MP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP"
	incontext "noncombatfollow"
	followtarget ( $player )
	}
Behavior GotoSpecified ( "run" , "player" )
states
	{
	CORE_PAIN			: SHOW_PAIN
	WANDER				: BEHAVIOR_SUCCESS CHANCE ( .8 )
	CORE_MAIN			: BEHAVIOR_SUCCESS CHANCE ( .5 )
	HOLD				: BEHAVIOR_SUCCESS CHANCE ( .3 )
	HOLD				: BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_1_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_1_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 1 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_1	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_2_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_2_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 1 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_2	: default
	}
}


//---------------------------------------------------------
state FOLLOW_PLAYER_MP_3_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_3_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 1 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_3	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_4_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_4_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 1 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_4	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_5_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_5_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 1 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_5	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_6_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_6_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 1 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_6	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_7_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_7_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 1 )
	settendency ( "follow_player8" , 0 )
	}
states
	{
	FOLLOW_PLAYER_MP_7	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_8_FORCE
//---------------------------------------------------------
{
entrycommands
	{
	
	//printmessage "FOLLOW_PLAYER_MP_8_FORCE"
	settendency ( "follow_player0" , 0 )
	settendency ( "follow_player1" , 0 )
	settendency ( "follow_player2" , 0 )
	settendency ( "follow_player3" , 0 )
	settendency ( "follow_player4" , 0 )
	settendency ( "follow_player5" , 0 )
	settendency ( "follow_player6" , 0 )
	settendency ( "follow_player7" , 0 )
	settendency ( "follow_player8" , 1 )
	}
states
	{
	FOLLOW_PLAYER_MP_8	: default
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_1
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_1"
	incontext "noncombatfollow"
	followtarget ( $player1 )
	}

Behavior GotoSpecified ( "run" , "player1" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_1 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_1	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}


//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_1
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_1"
	incontext "noncombatfollow"
	followtarget ( $player1 )
	}

Behavior GotoSpecified ( "walk" , "player1" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_2
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_2"
	incontext "noncombatfollow"
	followtarget ( $player2 )
	}

Behavior GotoSpecified ( "run" , "player2" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_2 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_2	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}


//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_2
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_2"
	incontext "noncombatfollow"
	followtarget ( $player2 )
	}

Behavior GotoSpecified ( "walk" , "player2" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_3
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_3"
	incontext "noncombatfollow"
	followtarget ( $player3 )
	}

Behavior GotoSpecified ( "run" , "player3" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_3 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_3	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_3
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_3"
	incontext "noncombatfollow"
	followtarget ( $player3 )
	}

Behavior GotoSpecified ( "walk" , "player3" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_4
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_4"
	incontext "noncombatfollow"
	followtarget ( $player4 )
	}

Behavior GotoSpecified ( "run" , "player4" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_4 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_4	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_4
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_4"
	incontext "noncombatfollow"
	followtarget ( $player4 )
	}

Behavior GotoSpecified ( "walk" , "player4" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_5
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_5"
	incontext "noncombatfollow"
	followtarget ( $player5 )
	}

Behavior GotoSpecified ( "run" , "player5" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_5 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_5	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_5
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_5"
	incontext "noncombatfollow"
	followtarget ( $player5 )
	}

Behavior GotoSpecified ( "walk" , "player5" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_6
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_6"
	incontext "noncombatfollow"
	followtarget ( $player6 )
	}

Behavior GotoSpecified ( "run" , "player6" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_6 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_6	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_6
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_6"
	incontext "noncombatfollow"
	followtarget ( $player6 )
	}

Behavior GotoSpecified ( "walk" , "player6" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_7
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_7"
	incontext "noncombatfollow"
	followtarget ( $player7 )
	}

Behavior GotoSpecified ( "run" , "player7" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_7 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_7	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_7
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_7"
	incontext "noncombatfollow"
	followtarget ( $player7 )
	}

Behavior GotoSpecified ( "walk" , "player7" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_8
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_8"
	incontext "noncombatfollow"
	followtarget ( $player8 )
	}

Behavior GotoSpecified ( "run" , "player8" )

states
	{
	CORE_PAIN				: SHOW_PAIN
	FOLLOW_PLAYER_MP_SLOW_8 : WITHIN_FOLLOW_TARGET_MIN_RANGE
	FOLLOW_PLAYER_MP_SLOW_8	: BEHAVIOR_SUCCESS
	FOLLOW_MP_FAILED		: BEHAVIOR_FAILED
	HOLD					: STEERING_FAILED
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_SLOW_8
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_PLAYER_MP_SLOW_8"
	incontext "noncombatfollow"
	followtarget ( $player8 )
	}

Behavior GotoSpecified ( "walk" , "player8" )
time ( 0.5 )

states
	{
	CORE_PAIN	: SHOW_PAIN
	CORE_MAIN	: FOLLOW_TARGET_OUT_OF_RANGE
	HOLD		: BEHAVIOR_SUCCESS
	HOLD		: BEHAVIOR_FAILED
	HOLD		: STEERING_FAILED
	HOLD		: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_MP_SUCCESS
//---------------------------------------------------------
{
entrycommands
	{
		//printmessage "FOLLOW_MP_SUCCESS"
	}

states
	{
	WANDER				: CHANCE ( .8 )
	HOLD				: CHANCE ( .3 )
	HOLD				: WITHIN_FOLLOW_TARGET_MIN_RANGE
	CORE_MAIN			: default
	}
}

//---------------------------------------------------------
state FOLLOW_MP_FAILED
//---------------------------------------------------------
{
entrycommands
	{
		//printmessage "FOLLOW_MP_FAILED"
	}
states
	{
		HOLD				: WITHIN_FOLLOW_TARGET_MIN_RANGE
		WANDER				: CHANCE ( .8 )
		HOLD				: default
	}
}



//---------------------------------------------------------
state FOLLOW_FUXXORED
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_FUXXORED"
	}
states
	{
	FOLLOW_THE_LEADER_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	FOLLOW_FUXXORED_SP		: default
	}
}

//---------------------------------------------------------
state FOLLOW_FUXXORED_SP
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "FOLLOW_FUXXORED_SP"
	}
	
Behavior groupfollow ( 120 , 356 )
time ( 1.0 )

states
	{
	FOLLOW_THE_LEADER : TIME_DONE
	CORE_MAIN		  : BEHAVIOR_SUCCESS
	}
}

//---------------------------------------------------------
state PLAYER_ATTACKED
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "PLAYER_ATTACKED"
	}

states
	{
	UPGRADE_STAGE		: CHECK_VAR_TIME_DIFFERENCE ( "playerattacked" , $TIME_PLAYER_ATTACK$ )
	CORE_PAIN			: default
	}
}

//---------------------------------------------------------
state UPGRADE_STAGE
//---------------------------------------------------------
{
	entrycommands
		{
		//printmessage "UPGRADE_STAGE"
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

//---------------------------------------------------------
state TURN_AGAINST_PLAYER
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "TURN_AGAINST_PLAYER"
	}
states
	{
	//Do not fail the mission in mp!
	CORE_MAIN				: SHOULD_DO_ACTION ( "multiplayer" )
	//Still fail in sp!
	TURN_AGAINST_PLAYER_SP	: default
	}
}

//---------------------------------------------------------
state TURN_AGAINST_PLAYER_SP
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "TURN_AGAINST_PLAYER_SP"
		incontext "turnonplayer"
		sendeventtogroup actortype enemy
		attackplayer
		groupattack	1	
		failmission 8
	}	
}

//---------------------------------------------------------
state HOLD
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "HOLD"
	}
legs
	{
	idle : default
	}

time ( 1.0 )

states
	{
	GET_OUT_OF_THE_WAY	: IN_THE_WAY
	CORE_PAIN			: SHOW_PAIN
	CORE_MAIN			: TIME_DONE		
	}
}

//---------------------------------------------------------
state HANDLE_CALL_VOLUME
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "HANDLE_CALL_VOLUME"
	}
states
	{
	//Do not go to lift position in Multiplayer, since this can crash!
	WANDER					: SHOULD_DO_ACTION ( "multiplayer" )
	//Go to lift in singeplayer
	GO_TO_LIFT_POSITION		: default
	}
}

//---------------------------------------------------------
state GO_TO_LIFT_POSITION
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GO_TO_LIFT_POSITION"
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
entrycommands
	{
	//printmessage "CALL_VOLUME_FAILED"
	}
	
legs
	{
	idle	: default
	}

time ( .35 )

states
	{
	HANDLE_CALL_VOLUME : TIME_DONE
	}
}

//---------------------------------------------------------
state GET_OUT_OF_THE_WAY 
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GET_OUT_OF_THE_WAY"
	}

states
	{
	//move random in mp else it can chrash
	GET_OUT_OF_THE_WAY_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	GET_OUT_OF_THE_WAY_SP  	: default
	}	  
}


//---------------------------------------------------------
state GET_OUT_OF_THE_WAY_SP 
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GET_OUT_OF_THE_WAY_SP"
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
		STEP_LEFT			: LEFT_CLEAR ( $RANGE_CLEAR$ ) CHANCE ( 0.3 )
		STEP_RIGHT			: RIGHT_CLEAR ( $RANGE_CLEAR$ ) CHANCE ( 0.3 )
		STEP_FORWARD		: FORWARD_CLEAR ( $RANGE_CLEAR$ )
		STEP_LEFT			: LEFT_CLEAR ( $RANGE_CLEAR$ )
		STEP_RIGHT			: RIGHT_CLEAR ( $RANGE_CLEAR$ )
		STEP_BACKWARD		: REAR_CLEAR ( $RANGE_CLEAR$ ) !LEFT_CLEAR ( $RANGE_CLEAR$ ) !RIGHT_CLEAR ( $RANGE_CLEAR$ )
		STEP_FORWARD		: FORWARD_CLEAR ( $RANGE_TURN$ )
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
		strafe_left : default
	}
	
	states
	{
		STEP_EXIT	: TIME_DONE
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
		strafe_right : default
	}
	
	states
	{
		STEP_EXIT	: TIME_DONE
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
		STEP_EXIT		: TIME_DONE
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



//---------------------------------------------------------
state CORE_PAIN
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "CORE_PAIN"
	}
	
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
entrycommands
	{
	//printmessage "CORE_BIG_PAIN"
	}

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
	//printmessage "CORE_SMALL_PAIN"
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
