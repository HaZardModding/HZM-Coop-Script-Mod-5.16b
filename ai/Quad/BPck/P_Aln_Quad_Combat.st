//
// Name:     Quadraped_PackageCombat
// Purpose:  Combat AI for the Quadraped
//

$define CHANCE_ATTACKPATTERN_1  .40
$define CHANCE_ATTACKPATTERN_2	.60
$define CHANCE_ATTACKPATTERN_3	.75
$define CHANCE_DODGE			.80
$define CHANCE_SIDESTEP			.13
$define CHANCE_CHESTBURST		.65
$define SMALL_PAIN_CHANCE 		.35

$define RANGE_PREFERRED_MAX 640

$include ai/quad/mdul/M_Aln_Quad_Sidestep.ai
$include ai/quad/mdul/M_Aln_Quad_AttackChestBurst.ai
$include ai/quad/mdul/M_Aln_Quad_AttackPattern1.ai
$include ai/quad/mdul/M_Aln_Quad_AttackPattern2.ai
$include ai/quad/mdul/M_Aln_Quad_AttackPattern3.ai

//---------------------------------------------------------
state START //()
//---------------------------------------------------------
{
	states
	{
		THINK : default
	}
}

//---------------------------------------------------------
state THINK //()
//---------------------------------------------------------
{
	ignoreglobalstate
	entrycommands
	{
		//printmessage ( "THINK" )
		evaluateenemies
	}
	legs
	{
		base : default //added
		//idle : default
	}
	states
	{
		SPARRING 	: HAVE_ENEMY
		HOLD		: default
	}	
}

//---------------------------------------------------------
state SPARRING //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SPARRING" )
	}
	states
	{
		APPROACH  				:	!RANGE ( $RANGE_PREFERRED_MAX$ ) HAVE_PATH_TO_ENEMY
		SIDESTEP  		 		:	RANGE ( $RANGE_PREFERRED_MAX$ ) CHANCE ( $SIDESTEP_CHANCE$ )		
		DODGE			 		:	INCOMING_PROJECTILE CHANCE ( $CHANCE_DODGE$ )
		SELECT_ATTACK_PATTERN	:	default
	}
}

//---------------------------------------------------------
state APPROACH //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "APPROACH" )
		clearCurrentEnemy
		evaluateenemies
	}

	//Behavior CloseInOnPlayer ( "run" , $RANGE_PREFERRED_MAX$ )
	Behavior CloseInOnEnemy ( "run" , $RANGE_PREFERRED_MAX$ )
	time ( 0.5 )

	states
	{
		SELECT_ATTACK_PATTERN			:	 !HAVE_ENEMY
		DODGE							: INCOMING_PROJECTILE CHANCE ( $CHANCE_DODGE$ )
		NO_PATH_SHOULDERCANNON_START	: !HAVE_PATH_TO_ENEMY
		THINK							: BEHAVIOR_SUCCESS
		//THINK							: TIME_DONE
		HOLD							: BEHAVIOR_FAILED
	}
}

//---------------------------------------------------------
state HOLD //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "HOLD" )
		clearCurrentEnemy
	}
	
	time ( 0.5 )
	
	legs
	{
		base : default
		//idle : default
	}
	
	states
	{
		THINK : TIME_DONE
	}
}

//---------------------------------------------------------
state SELECT_ATTACK_PATTERN //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "SELECT_ATTACK_PATTERN" )
	}
	
	time ( 0.05 , 0.1 )
	
	states
	{
		ATTACK_PATTERN1	: CHANCE ( $CHANCE_ATTACKPATTERN_1$ )
		ATTACK_PATTERN3 : CHANCE ( $CHANCE_ATTACKPATTERN_3$ )
		ATTACK_PATTERN2 : TIME_DONE
		HOLD			: default			
	}
}

//---------------------------------------------------------
state DEATH	//()
//---------------------------------------------------------
{
	legs
	{
		//death_pain : CHECK_VAR ( "special_death" , "true" )
		death : default
	}
}

//---------------------------------------------------------
state PAIN //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "PAIN" )
	}
	legs
	{
		pain : default
	}

	states
	{
		THINK   : ANIM_DONE
	}
}

//---------------------------------------------------------
state NO_PATH_SHOULDERCANNON_START //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "NO_PATH_SHOULDERCANNON_START" )
	}
	behavior WatchEntity  ( 100 , 20 , "base_to_shoulderattack" , 1 , "base_to_shoulderattack" )

	states
	{	
		PAIN  : SHOW_PAIN CHANCE ( $SMALL_PAIN_CHANCE$ )	
		NO_PATH_SHOULDERCANNON_FIRE : BEHAVIOR_DONE
	}
}


//---------------------------------------------------------
state NO_PATH_SHOULDERCANNON_FIRE //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "NO_PATH_SHOULDERCANNON_FIRE" )
	}
	
	behavior WatchEntity  ( 100 , 20 , "nopathattack_fire" , 1 , "nopathattack_fire" )
	states
	{
		NO_PATH_SHOULDERCANNON_END : BEHAVIOR_DONE
	}
}


//---------------------------------------------------------
state NO_PATH_SHOULDERCANNON_END //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "NO_PATH_SHOULDERCANNON_END" )
	}
	behavior WatchEntity  ( 100 , 20 , "shoulderattack_to_base" , 1 , "shoulderattack_to_base" )
	states
	{		
		PAIN  : SHOW_PAIN CHANCE ( $SMALL_PAIN_CHANCE$ )
		THINK : BEHAVIOR_DONE
	}
}

//---------------------------------------------------------
state END_ATTACK_PATTERN //()
//---------------------------------------------------------
{
	entrycommands
	{
		//printmessage ( "END_ATTACK_PATTERN" )
	}
	
	states
	{
		ATTACK_CHESTBURST_WARN 		: CHANCE ( $CHANCE_CHESTBURST$ )
		SELECT_ATTACK_PATTERN		: default
	}
}
