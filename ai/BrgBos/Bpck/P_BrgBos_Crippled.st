//
// Name:     BorgBoss_Crippled
// Purpose:  Crippled Functionality
//
//

//Changed for Co-Op 2009.1.24 Chrissstrahl

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
	removeresistance "stasis"
	removeresistance "tetryon"
	removeresistance "sniper"
	removeresistance "disruptor"
	removeresistance "vaporize_disruptor"
	removeresistance "melee"
	removeresistance "vaporize_photon"
	
	takedamage
	cleararmoradaptions
	armor none
	}

states
	{
	GO_CRIPPLED_MP	: SHOULD_DO_ACTION ( "multiplayer" )
	GO_CRIPPLED_SP	: default
	}
}

//---------------------------------------------------------
state GO_CRIPPLED_SP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	displayeffect electric
	}   

legs
	{
	deactivated : default
	}

	time ( 12 )

states
	{
	THINK : TIME_DONE
	}

exitcommands
	{
	displayeffect noelectric
	setactorflag "crippled" 0 
	}
}

//---------------------------------------------------------
state GO_CRIPPLED_MP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	displayeffect electric
	}   

legs
	{
	deactivated : default
	}

time ( 7 )

states
	{
//dissallow beeing disabled in stage 4 for Multiplayer
	THINK : STAGE ( 4 )
//otherwise wait for the crippled time to end
	THINK : TIME_DONE
	}

exitcommands
	{
	displayeffect noelectric
	setactorflag "crippled" 0 
	}
}

//---------------------------------------------------------
state THINK //()
//---------------------------------------------------------
{
//this state is required but empty cuz as soon as crippled ends the
//behavior package for the stage will be loaded
//check the MS_BrgBos.st AUTO state
}

