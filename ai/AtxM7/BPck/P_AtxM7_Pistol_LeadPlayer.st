//
// Name:     Common_PackageLead
// Purpose:  General AI that directs the actor to follow a patrol path and fight any enemies they
//			 encounter. They will stop and face the player if the player gets too far away,
//			 and will attempt to run back to the player if they get even farther away.
//			 After combat is done they will regain the patrol path and continue on.
//

$define MIN_WAIT_FOR_PLAYER_RANGE 256
$define MAX_WAIT_FOR_PLAYER_RANGE 512
$define FOLLOW_PLAYER_RANGE 1024

$define CHASE_RANGE 550

//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "START"
		settendency ( "multiplayer" , 0 )
		multiplayer settendency ( "multiplayer" , 1 )
	}
	states
		{
		THINK : default
		}
	}

//---------------------------------------------------------
state THINK
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "THINK"
	}
	states
		{
		LEAD : default
		}
	}

//---------------------------------------------------------
state LEAD
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "LEAD"
	}
	
	Behavior Patrol ( "run" )

	states
		{
		TURN_TO_PLAYER   		: SHOULD_DO_ACTION ( "multiplayer" ) FOLLOW_TARGET_OUT_OF_RANGE ( $MAX_WAIT_FOR_PLAYER_RANGE$ ) 
		TURN_TO_PLAYER   		: !SHOULD_DO_ACTION ( "multiplayer" ) !PLAYER_RANGE ( $MAX_WAIT_FOR_PLAYER_RANGE$ )
		//IDLE				 	: BEHAVIOR_SUCCESS
		IDLE			 		: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state IDLE
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "IDLE"
	}
	
	legs
	{
		gesture_come :  default
		//idle	: default
	}
	
	behavior WatchEntity ( 1 , 10 , "idle" , 1 )

	states
		{
		THINK : BEHAVIOR_DONE
		THINK : BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state TURN_TO_PLAYER
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "TURN_TO_PLAYER"
	}
	
	states
		{
		CHECK_PLAYER_FOLLOW_1	: SHOULD_DO_ACTION ( "multiplayer" )
		//IDLE					: SHOULD_DO_ACTION ( "multiplayer" ) CHANCE ( .3 )
		TURN_TO_PLAYER_SP		: default
		}
	}
	
//---------------------------------------------------------
state TURN_TO_PLAYER_SP
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "TURN_TO_PLAYER_SP"
	}
	
	Behavior RotateToEntity ( 10.0 , "idle" , "player" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
	}

//---------------------------------------------------------
state WAIT_FOR_PLAYER
//---------------------------------------------------------
	{
	entrycommands
	{
		//printmessage "WAIT_FOR_PLAYER"
	}
	
	legs
		{
		idle :  default
		}

	states
		{		
		THINK 			: SHOULD_DO_ACTION ( "multiplayer" ) FOLLOW_TARGET_OUT_OF_RANGE ( $MAX_WAIT_FOR_PLAYER_RANGE$ ) 
		THINK 			: SHOULD_DO_ACTION ( "multiplayer" ) !FOLLOW_TARGET_OUT_OF_RANGE ( $MIN_WAIT_FOR_PLAYER_RANGE$ )
		
		THINK 			: !SHOULD_DO_ACTION ( "multiplayer" ) !PLAYER_RANGE ( $MAX_WAIT_FOR_PLAYER_RANGE$ )
		THINK 			: !SHOULD_DO_ACTION ( "multiplayer" ) PLAYER_RANGE ( $MIN_WAIT_FOR_PLAYER_RANGE$ )
		
		WAIT_FOR_PLAYER : ANIM_DONE
		}
	}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_1
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_1"
		followtarget ( $player1 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_1		: !FOLLOW_TARGET_OUT_OF_RANGE ( 500 )
	CHECK_PLAYER_FOLLOW_2	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_1
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_1"
		headwatch ( $player1 )
	}
	
	Behavior RotateToEntity ( 15.0 , "idle" , "player1" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_2
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_2"
		followtarget ( $player2 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_2		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	CHECK_PLAYER_FOLLOW_3	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_2
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_2"
		headwatch ( $player2 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player2" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_3
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_3"
		followtarget ( $player3 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_3		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	CHECK_PLAYER_FOLLOW_4	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_3
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_3"
		headwatch ( $player3 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player3" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_4
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_4"
		followtarget ( $player4 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_4		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	CHECK_PLAYER_FOLLOW_5	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_4
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_4"
		headwatch ( $player4 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player4" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_5
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_5"
		followtarget ( $player5 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_5		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	CHECK_PLAYER_FOLLOW_6	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_5
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_5"
		headwatch ( $player5 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player5" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_6
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_6"
		followtarget ( $player6 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_6		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	CHECK_PLAYER_FOLLOW_7	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_6
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_6"
		headwatch ( $player6 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player6" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_7
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_7"
		followtarget ( $player7 )
		headwatchtarget ( "none" , 10 )
	}
states
	{
	FOLLOW_PLAYER_MP_7		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	CHECK_PLAYER_FOLLOW_8	: FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_7
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_7"
		headwatch ( $player7 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player7" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

//---------------------------------------------------------
state CHECK_PLAYER_FOLLOW_8
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "CHECK_PLAYER_FOLLOW_8"
		followtarget ( $player8 )
		headwatchtarget ( "none" , 10 )
	}
	
time ( 1 , 2 )
	
states
	{
	FOLLOW_PLAYER_MP_8		: !FOLLOW_TARGET_OUT_OF_RANGE ( 9999999 )
	IDLE					: TIME_DONE
	}
}

//---------------------------------------------------------
state FOLLOW_PLAYER_MP_8
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage "FOLLOW_PLAYER_MP_8"
		headwatch ( $player8 )
	}
	
	Behavior RotateToEntity ( 30.0 , "idle" , "player8" )

	states
		{
		WAIT_FOR_PLAYER : BEHAVIOR_SUCCESS
		THINK			: BEHAVIOR_FAILED
		}
}

