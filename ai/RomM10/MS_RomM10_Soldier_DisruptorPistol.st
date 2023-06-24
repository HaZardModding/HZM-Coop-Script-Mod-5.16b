//
// Name:     Romulan_DisruptorPistolMasterStateMap.st
// Purpose:  Masterstate map for Pistol Using Romulans
//

//---------------------------------------------------------
state START
//---------------------------------------------------------
	{
	entrycommands
	{
		//turntowardsenemy
		//printmessage "START"
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
		//printmessage "AI_OFF"
		setposturestate ( "STAND" , "STAND" )
		usebehaviorpackage ( "general_ai_off" )
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
	entrycommands
	{
		//printmessage "AUTO"
	}
	states
		{
		AI_OFF : !IN_AI_MODE
		COMBAT : HAVE_ENEMY
		CORE : default
		}
	}

//---------------------------------------------------------
state CORE
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage "CORE"
		setposturestate ( "STAND" , "STAND" )
		usebehaviorpackage ( "romulan_m10_soldier_pistol_core" )
		}

	states
		{
		AI_OFF : !IN_AI_MODE
		COMBAT : CHECK_VAR ( "manual_state" , "combat" )
		}
	}

//---------------------------------------------------------
state COMBAT
//---------------------------------------------------------
	{
	entrycommands
		{
		//printmessage "COMBAT"
		setposturestate ( "STAND" , "STAND" )
		usebehaviorpackage ( "romulan_m10_soldier_pistol_combat" )
		incontext "startcombat"
		}

	states
		{
		AI_OFF : !IN_AI_MODE
		CORE : CHECK_VAR ( "manual_state" , "core" )
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
