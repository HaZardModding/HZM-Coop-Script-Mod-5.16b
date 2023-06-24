//
// Name:     Teammate_MasterStateMap.st
// Purpose:  MasterStateMap for Teammates
//

$define RANGE_ENEMY_SEARCH 512
//---------------------------------------------------------
state START
//---------------------------------------------------------
{
entrycommands
	{
	settendency ( "multiplayer" , 0 )
	multiplayer settendency ( "multiplayer" , 1 )
	}
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
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "general_ai_off" )
	setfloatvar ( "aiState" , 2 )
	}

states
	{
	START : IN_AI_MODE
	}
}

//---------------------------------------------------------
state AUTO
//---------------------------------------------------------
{
states
	{
	AI_OFF : !IN_AI_MODE
	BATLETH_COMBAT : HAVE_ENEMY WEAPON_IS_MELEE
	COMBAT : HAVE_ENEMY
	BATLETH_CORE : WEAPON_IS_MELEE
	CORE : default
	}
}

state BATLETH_CORE
{
entrycommands
	{
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "teammate_batleth_core" )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	CORE   : !WEAPON_IS_MELEE
	BATLETH_COMBAT : HAVE_ENEMY WEAPON_IS_MELEE
	COMBAT : HAVE_ENEMY
	}
}

//---------------------------------------------------------
state CORE
//---------------------------------------------------------
{
entrycommands
	{
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "teammate_core" )
	setfloatvar ( "aiState" , 1 )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	BATLETH_CORE : WEAPON_IS_MELEE
	BATLETH_COMBAT : HAVE_ENEMY WEAPON_IS_MELEE
	COMBAT : HAVE_ENEMY
	}
}

state BATLETH_COMBAT
{
entrycommands
	{
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "teammate_batleth_combat" )
	incontext "startcombat"
	}

states
	{
	AI_OFF : !IN_AI_MODE		
	COMBAT : !WEAPON_IS_MELEE
	POST_COMBAT : !TURRET_MODE !HAVE_ENEMY !ANY_ENEMIES_NEARBY ( $RANGE_ENEMY_SEARCH$ )		
	CORE : !TURRET_MODE !HAVE_ENEMY 
	}

exitcommands
	{
	incontext "postcombat"
	}
}

//---------------------------------------------------------
state COMBAT
//---------------------------------------------------------
{
entrycommands
	{
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "teammate_combat" )
	incontext "startcombat"
	}

states
	{
	AI_OFF : !IN_AI_MODE
	POST_BATLETH_COMBAT : WEAPON_IS_MELEE !TURRET_MODE !HAVE_ENEMY !ANY_ENEMIES_NEARBY ( $RANGE_ENEMY_SEARCH$ )		
	POST_COMBAT : !TURRET_MODE !HAVE_ENEMY !ANY_ENEMIES_NEARBY ( $RANGE_ENEMY_SEARCH$ )		
	CORE : !TURRET_MODE !HAVE_ENEMY 
	}

exitcommands
	{
	incontext "postcombat"
	}

}

state POST_COMBAT
{
entrycommands
	{
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "teammate_core" )		
	incontext "postcombat"
	}

states
	{
	AI_OFF : !IN_AI_MODE
	BATLETH_CORE : WEAPON_IS_MELEE
	COMBAT : HAVE_ENEMY
	}
}

state POST_BATLETH_COMBAT
{
entrycommands
	{
	setposturestate ( "STAND" , "STAND" )
	usebehaviorpackage ( "teammate_batleth_core" )
	incontext "postcombat"
	}

states
	{
	AI_OFF : !IN_AI_MODE
	CORE : !WEAPON_IS_MELEE
	BATLETH_COMBAT : HAVE_ENEMY WEAPON_IS_MELEE
	}
}
//---------------------------------------------------------
state SCRIPTED
//---------------------------------------------------------
{
}	
