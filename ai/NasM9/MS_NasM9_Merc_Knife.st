//
// Name:	 nausicaan-m9-merc-knife-masterstatemap.st
// Purpose:	 MasterStateMap	for	Nausicaan Merc with Knife
//

//---------------------------------------------------------
state START
//---------------------------------------------------------
{
	states
	{
		AUTO : default
	}
}

//---------------------------------------------------------
state AI_OFF
//---------------------------------------------------------
{
	entrycommands
	{
		setposturestate	( "STAND" ,	"STAND"	)
		usebehaviorpackage ( "general_ai_off" )
	}

	states
	{
		START :	IN_AI_MODE
	}
}

//---------------------------------------------------------
state AUTO
//---------------------------------------------------------
{
	states
	{
		AI_OFF	 : !IN_AI_MODE
		COMBAT 	 : ACTORTYPE ( "enemy" ) HAVE_ENEMY
		COMBAT 	 : ACTORTYPE ( "enemy" ) ATTACKED
		TO_ENEMY : ATTACKED
		TO_ENEMY : HAVE_ENEMY
		CORE	 : default
	}
}

//---------------------------------------------------------
state CORE
//---------------------------------------------------------
{
	entrycommands
	{
		setposturestate	( "STAND" ,	"STAND"	)
		usebehaviorpackage ( "nausicaan-m9-merc-knife-core" )
	}

	states
	{
		AI_OFF : !IN_AI_MODE
		COMBAT 	 : ACTORTYPE ( "enemy" ) HAVE_ENEMY
		COMBAT 	 : ACTORTYPE ( "enemy" ) ATTACKED
		TO_ENEMY : ATTACKED
		COMBAT : HAVE_ENEMY
	}
}

//---------------------------------------------------------
state TO_ENEMY
//---------------------------------------------------------
{
	entrycommands
	{
		actortype "enemy"
		visiondistance 1500
		setposturestate	( "STAND" ,	"STAND"	)
		groupactortype "enemy"
		selectclosestenemy
		groupattack	1
		thread globalCoop_failMission //failmission	3
	}

	states
	{
		AI_OFF			  :	!IN_AI_MODE
		COMBAT			  :	HAVE_ENEMY CAN_SEE_ENEMY
		COMBAT			  :	ATTACKED
		COMBAT			  :	HAVE_ENEMY NOISE_HEARD
	}
}

//---------------------------------------------------------
state COMBAT
//---------------------------------------------------------
{
	entrycommands
	{
		setposturestate	( "STAND" ,	"STAND"	)
		usebehaviorpackage ( "nausicaan-m9-merc-knife-combat" )
		incontext "startcombat"
	}

	states
	{
		AI_OFF : !IN_AI_MODE
		CORE : !TURRET_MODE	!HAVE_ENEMY
	}

	exitcommands
	{
		incontext "postcombat"
	}

}

//---------------------------------------------------------
state SCRIPTED
//---------------------------------------------------------
{
}
