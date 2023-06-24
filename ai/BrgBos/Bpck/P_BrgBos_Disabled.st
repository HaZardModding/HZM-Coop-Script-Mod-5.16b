//
// Name:     BorgBoss_Disabled
// Purpose:  Disable Functionality
//
//

//Changed for Co-Op 2009.1.24 Chrissstrahl

//Includes
$include ai/BrgBos/Glob/GP_BrgBos_Disabled.st


//---------------------------------------------------------
state START //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	removeresistance "phaser"
	removeresistance "vaporize"
	removeresistance "comp_rifle"
	removeresistance "vaporize_comp"
	removeresistance "imod_primary"
	removeresistance "imod_secondary"
	removeresistance "assault_rifle"
	removeresistance "explosion"
	removeresistance "plasmashotgun"
	removeresistance "small_explosion"
	removeresistance "electric"
	removeresistance "gas"
	removeresistance "stasis"
	removeresistance "tetryon"
	removeresistance "sniper"
	removeresistance "disruptor"
	removeresistance "vaporize_disruptor"
	removeresistance "firesword"
	removeresistance "melee"
	removeresistance "vaporize_photon"

	cleararmoradaptions
	}

states
	{
	GO_DISABLED_MP : SHOULD_DO_ACTION ( "multiplayer" )
	GO_DISABLED_SP : default
	}
}

//---------------------------------------------------------
state GO_DISABLED_SP //()
//---------------------------------------------------------
{  
entrycommands
	{
	fadein
	show
	displayeffect electric
	solid
	}

legs
	{
	deactivated : default
	}

time ( 10 , 12.5 )

states
	{
	THINK : TIME_DONE
	}

exitcommands
	{
	resistance "phaser" 95
	resistance "vaporize" 90
	resistance "comp_rifle" 95
	resistance "vaporize_comp" 85
	resistance "imod_primary" 75
	resistance "imod_secondary" 85

	displayeffect noelectric
	setactorflag "disabled" 0 
	}
}


//---------------------------------------------------------
state GO_DISABLED_MP //()
//---------------------------------------------------------
{  
entrycommands
	{
	fadein
	show
	displayeffect electric
	solid
	} 

legs
	{
	deactivated : default
	}

time ( 6 , 8.5 )

states
	{
	THINK : TIME_DONE
	}

exitcommands
	{
	resistance "phaser" 95
	resistance "vaporize" 90
	resistance "comp_rifle" 95
	resistance "vaporize_comp" 85
	resistance "imod_primary" 75
	resistance "imod_secondary" 85
	
	displayeffect noelectric
	setactorflag "disabled" 0 
	}
}

//---------------------------------------------------------
state THINK //()
//---------------------------------------------------------
{
entrycommands
	{
	setactorflag "disabled" 0 
	}
}
