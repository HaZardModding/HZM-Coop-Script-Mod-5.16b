//
// Name:     BorgBoss_MasterState.st
// Purpose:  Master State Machine for Borg Boss
//

//Coop Mod version
//---------------------------------------------------------
state START //()
//---------------------------------------------------------
{
entrycommands
	{
//reset attack
	clearCurrentEnemy
	evaluateenemies
//for singleplayer/multiplayer detection
	settendency ( "multiplayer" , 0 )
	multiplayer settendency ( "multiplayer" , 1 )
//Aimate Mouth angles stronger
	dialogMorphMult ( 1.6 )
//inizial animation
	anim ( "change_stage_1" )
//resistance against damage types
	resistance "phaser" 95
	resistance "vaporize" 90
	resistance "comp_rifle" 95
	resistance "vaporize_comp" 85
	resistance "imod_primary" 75
	resistance "imod_secondary" 85
	resistance "assault_rifle" 95
	resistance "explosion" 85
	resistance "plasmashotgun" 85
	resistance "small_explosion" 90
	resistance "electric" 75
	resistance "gas" 100
	resistance "stasis" 85
	resistance "tetryon" 85
	resistance "sniper" 85
	resistance "disruptor" 85
	resistance "vaporize_disruptor" 90
	resistance "firesword" 85
	resistance "melee" 85
	resistance "vaporize_photon" 90
	}

states
	{
//check when ever the Boss is in 
	AI_OFF : !IN_AI_MODE
	AUTO   : default
	}
}

//---------------------------------------------------------
state AI_OFF //()
//---------------------------------------------------------
{
entrycommands
	{
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
states
	{
	AI_OFF : !IN_AI_MODE
	CRIPPLED : CRIPPLED
	DISABLED_STAGE1 : DISABLED STAGE ( 1 )
	DISABLED_STAGE2 : DISABLED STAGE ( 2 )
	DISABLED_STAGE3 : DISABLED STAGE ( 3 )
	DISABLED_STAGE4 : DISABLED STAGE ( 4 )		
	STAGE2 : STAGE ( 2 )
	STAGE3 : STAGE ( 3 )
	STAGE4 : STAGE ( 4 )
	STAGE1 : default
	}
}

//---------------------------------------------------------
state CRIPPLED //()
//---------------------------------------------------------
{
entrycommands
	{
	usebehaviorpackage ( "borgboss_crippled" )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	AUTO : !CRIPPLED
	}
}

//---------------------------------------------------------
state DISABLED_STAGE1 //()
//---------------------------------------------------------
{
entrycommands
	{
	usebehaviorpackage ( "borgboss_disabled" )
	}
states
	{
	AI_OFF : !IN_AI_MODE
	AUTO : !DISABLED
	STAGE2 : STAGE ( 2 )
	STAGE3 : STAGE ( 3 )
	STAGE4 : STAGE ( 4 )
	}
}

//---------------------------------------------------------
state DISABLED_STAGE2 //()
//---------------------------------------------------------
{
entrycommands
	{
	usebehaviorpackage ( "borgboss_disabled" )
	}
states
	{
	AI_OFF : !IN_AI_MODE
	AUTO : !DISABLED
	STAGE1 : STAGE ( 1 )		
	STAGE3 : STAGE ( 3 )
	STAGE4 : STAGE ( 4 )	
	}
}

//---------------------------------------------------------
state DISABLED_STAGE3 //()
//---------------------------------------------------------
{
entrycommands
	{
	usebehaviorpackage ( "borgboss_disabled" )
	}
states
	{
	AI_OFF : !IN_AI_MODE
	AUTO : !DISABLED
	STAGE1 : STAGE ( 1 )
	STAGE2 : STAGE ( 2 )		
	STAGE4 : STAGE ( 4 )	
	}
}

//---------------------------------------------------------
state DISABLED_STAGE4 //()
//---------------------------------------------------------
{
entrycommands
	{
	usebehaviorpackage ( "borgboss_disabled" )
	}
states
	{
	AI_OFF : !IN_AI_MODE
	AUTO : !DISABLED
	}
}
//---------------------------------------------------------
state STAGE1 //()
//---------------------------------------------------------
{
entrycommands
	{
	usebehaviorpackage ( "borgboss_stage1" )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	DISABLED_STAGE1 : CRIPPLED
	DISABLED_STAGE1 : DISABLED		
	STAGE2 : STAGE ( 2 )
	STAGE3 : STAGE ( 3 )
	STAGE4 : STAGE ( 4 )			
	}
}

//---------------------------------------------------------
state STAGE2 //()
//---------------------------------------------------------
{
entrycommands
	{
	displayeffect noelectric
	setactorflag "disabled" 0 
	usebehaviorpackage ( "borgboss_stage2" )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	DISABLED_STAGE2 : CRIPPLED
	DISABLED_STAGE2 : DISABLED
	STAGE1 : STAGE ( 1 )		
	STAGE3 : STAGE ( 3 )
	STAGE4 : STAGE ( 4 )		
	}
}

//---------------------------------------------------------
state STAGE3 //()
//---------------------------------------------------------
{
entrycommands
	{
		displayeffect noelectric
		setactorflag "disabled" 0 
		usebehaviorpackage ( "borgboss_stage3" )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	DISABLED_STAGE3 : CRIPPLED
	DISABLED_STAGE3 : DISABLED
	STAGE1 : STAGE ( 1 )
	STAGE2 : STAGE ( 2 )		
	STAGE4 : STAGE ( 4 )		
	}
}

//---------------------------------------------------------
state STAGE4 //()
//---------------------------------------------------------
{
entrycommands
	{
		displayeffect noelectric
		setactorflag "disabled" 0 
		usebehaviorpackage ( "borgboss_stage4" )
	}

states
	{
	AI_OFF : !IN_AI_MODE
	DISABLED_STAGE4 : CRIPPLED
	DISABLED_STAGE4 : DISABLED
	}
}

//---------------------------------------------------------
state SCRIPTED //()
//---------------------------------------------------------
{
}


