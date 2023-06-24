//
// Name:     BorgBoss_Global
// Purpose:  Global State File for Borg Boss
//
// Notes:    None

$define STAGE_2_HEALTH 800
$define STAGE_3_HEALTH 600
$define STAGE_4_HEALTH 400
$define CHASE_RANGE 600
$define TELEPORT_RANGE 1000
$define TELEPORT_RANGE_MAX_HEIGHT 500
$define TELEPORT_RANGE_MIN_HEIGHT -500
$define MELEE_RANGE 128

//---------------------------------------------------------
globalstate GLOBAL_MAIN //()
//---------------------------------------------------------
{
entrycommands
	{
		//printmessage "GLOBAL_MAIN (GLOBAL)"
		settendency ( "multiplayer" , 0 )
		multiplayer settendency ( "multiplayer" , 1 )
		dialogMorphMult ( 1.6 )
		
		HeadWatchEnemy
		
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
		resistance "melee" 85
		resistance "vaporize_photon" 90
		
		setactorflag "disabled" 0
		displayeffect noelectric
		takedamage
	}

states
	{
	PAIN							: PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	PAIN							: SMALL_PAIN CHANCE ( .025 ) !SHOULD_DO_ACTION ( "multiplayer" )
	//GLOBAL_NO_PATH_AVAILABLE		: !HAVE_PATH_TO_ENEMY      
	//GLOBAL_TELEPORT_TO_PLAYER_START	: !NO_PATH !RANGE ( $TELEPORT_RANGE$ , $TELEPORT_RANGE_MAX_HEIGHT$ , $TELEPORT_RANGE_MIN_HEIGHT$ )
	//CHASE_PLAYER					: HAVE_PATH_TO_ENEMY !RANGE ( $CHASE_RANGE$ )
	GOTO_STAGE_4_START				: !STAGE ( 4 ) HEALTH ( $STAGE_4_HEALTH$ )
	GOTO_STAGE_3_START				: !STAGE ( 3 ) HEALTH ( $STAGE_3_HEALTH$ ) !HEALTH ( $STAGE_4_HEALTH$ )      
	GOTO_STAGE_2_START				: !STAGE ( 2 ) HEALTH ( $STAGE_2_HEALTH$ ) !HEALTH ( $STAGE_3_HEALTH$ )
	}
}

//---------------------------------------------------------
state CHASE_PLAYER //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "CHASE_PLAYER (GLOBAL)"
	}

behavior CloseInOnEnemy ( "walk" , $MELEE_RANGE$ )
time ( .75 )

states
	{
	CHASE_PLAYER_FAST				: TIME_DONE
	THINK							: RANGE ( $CHASE_RANGE$ )
	GLOBAL_NO_PATH_AVAILABLE		: !HAVE_PATH_TO_ENEMY      
	GLOBAL_TELEPORT_TO_PLAYER_START	: !NO_PATH !RANGE ( $TELEPORT_RANGE$ , $TELEPORT_RANGE_MAX_HEIGHT$ , $TELEPORT_RANGE_MIN_HEIGHT$ )
	}
}

//---------------------------------------------------------
state CHASE_PLAYER_FAST //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "CHASE_PLAYER_FAST (GLOBAL)"
	}

behavior CloseInOnEnemy ( "walk_fast" , $MELEE_RANGE$ )

states
	{
	THINK								: RANGE ( $CHASE_RANGE$ )
	GLOBAL_NO_PATH_AVAILABLE			: NO_PATH      
	GLOBAL_TELEPORT_TO_PLAYER_START		: !NO_PATH !RANGE ( $TELEPORT_RANGE$ , $TELEPORT_RANGE_MAX_HEIGHT$ , $TELEPORT_RANGE_MIN_HEIGHT$ )
	}
}

//---------------------------------------------------------
state CHASE_PLAYER_FAST_NO_TELEPORT //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "CHASE_PLAYER_FAST_NO_TELEPORT (GLOBAL)"
	}

behavior CloseInOnEnemy ( "walk" , $MELEE_RANGE$ )

states
	{
	THINK								: RANGE ( $CHASE_RANGE$ )
	GLOBAL_NO_PATH_AVAILABLE			: NO_PATH      		
	}
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////STAGE 2/////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------
state GOTO_STAGE_2_START //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
		//printmessage "GOTO_STAGE_2_START (STAGE1)"
//RUN CINEMATIC, works only if the level has that thread
		runthread stage_change_cinema_start
	}

states
	{
//start AI MODE CIN if the boss is not on the Borg Mission
	GOTO_STAGE_2_START_NO_CIN	: !SHOULD_DO_ACTION ( "scriptcontrolled" )
	}
}

//---------------------------------------------------------
state GOTO_STAGE_2_START_NO_CIN //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "//GOTO_STAGE_2_START_NO_CIN (STAGE1)"
	nodamage
	resetHead ( 10 )
	displayEffect ( "electric" )
	anim ( "deactivated" )
	}
	
time ( .5 )
	
states
	{
	GOTO_STAGE_2_NO_CIN : TIME_DONE
	}
}


//---------------------------------------------------------
state GOTO_STAGE_2_NO_CIN //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GOTO_STAGE_2_NO_CIN_ANIM (STAGE1)"
	displayEffect ( "noelectric" )
	surface ( "material8", "+nodraw" );
	surface ( "material7", "+nodraw" );
	animateonce ( "change_stage_1" )
	}
	
time ( 5 )

states
	{
	GOTO_STAGE_2_NO_CIN_DIALOG : TIME_DONE
	}
}


//---------------------------------------------------------
state GOTO_STAGE_2_NO_CIN_DIALOG //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_2_NO_CIN_ANIM_DIALOG (STAGE1)"
	playdialog			"loc/Eng/sound/dialog/borg03/borgboss_stage1.mp3" , 1 , 20000 , 0
	simpleplayDialog	"loc/Deu/sound/dialog/borg03/borgboss_stage1.mp3" , 1 , 20000 , 0
	goToStage ( 2 )
	anim ( "idle" )
	}
	
time ( 6 )

states
	{
	THINK	: TIME_DONE
	}
	
exitcommands
	{
	takedamage
	}
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////STAGE 3/////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------
state GOTO_STAGE_3_START //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GOTO_STAGE_3_START (GLOBAL)"
	runthread stage_change_cinema_start
	}

states
	{
	GOTO_STAGE_3_START_NO_SCRIPT	: !SHOULD_DO_ACTION ( "scriptcontrolled" )
	}
}

//---------------------------------------------------------
state GOTO_STAGE_3_START_NO_SCRIPT //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_3_START_NO_SCRIPT (GLOBAL)"
//reset head, stop watching p...
	resetHead ( 10 )
//set electric effect, as if the boss has been disabled
	displayEffect ( "electric" )
//animate the dude as he has been disabled
	anim ( "deactivated" )
	nodamage
	}
	
time ( .5 )
	
states
	{
	GOTO_STAGE_3_NO_CIN	: TIME_DONE
	}
}

//---------------------------------------------------------
state GOTO_STAGE_3_NO_CIN //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_3_NO_CIN (GLOBAL)"
	displayEffect ( "noelectric" )
//No Draw Chest
	surface material6  +nodraw   
//No Draw L Shoulder
	surface material10 +nodraw
//No Draw R Arm
	surface material9  +nodraw
	animateonce ( "change_stage_2" )
	}
	
time ( 5 )
	
states
	{
	GOTO_STAGE_3_NO_CIN_DIALOG	: TIME_DONE
	}
}

//---------------------------------------------------------
state GOTO_STAGE_3_NO_CIN_DIALOG //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_3_NO_CIN_DIALOG (GLOBAL)"
//play dialog
	playdialog			"loc/Eng/sound/dialog/borg03/borgboss_stage2.mp3" , 1 , 20000 , 0
	simpleplayDialog	"loc/Deu/sound/dialog/borg03/borgboss_stage2.mp3" , 1 , 20000 , 0
	gotostage 3
	anim ( "idle" )
	}
	

time ( 6 )
	
states
	{
	THINK	: TIME_DONE
	}

exitcommands
	{
	takedamage
	}	
}


//---------------------------------------------------------
state GOTO_STAGE_3 //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_3 (GLOBAL)"
	//No Draw Chest
	surface material6  +nodraw   

	//No Draw L Shoulder
	surface material10 +nodraw

	//No Draw R Arm
	surface material9  +nodraw
	}

legs
	{
	change_stage_2 : default
	}

states
	{
	GOTO_STAGE_FINISH			: ANIM_DONE 
	}

exitcommands
	{
	displayeffect noelectric
	gotostage 3
	}
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////STAGE 4/////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------
state GOTO_STAGE_4_START //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GOTO_STAGE_4_START (GLOBAL)"
	runthread stage_change_cinema_start
	anim ( "teleport_end" )
	}
	
legs
	{
	idle : default
	}

states
	{
	GOTO_STAGE_3_START_NO_SCRIPT : SHOULD_DO_ACTION ( "multiplayer" )
	}
}

//---------------------------------------------------------
state GOTO_STAGE_3_START_NO_SCRIPT //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_4_BEGIN_NO_SCRIPT (GLOBAL)"
//reset head, stop watching p...
	resetHead ( 10 )
//set electric effect, as if the boss has been disabled
	displayEffect ( "electric" )
//animate the dude as he has been disabled
	anim ( "deactivated" )
	nodamage
	}
	
time ( .5 )

states
	{
	GOTO_STAGE_4_NO_CIN : TIME_DONE
	}
}


//---------------------------------------------------------
state GOTO_STAGE_4_NO_CIN //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_4_NO_CIN (GLOBAL)"
	
	displayEffect ( "noelectric" )
	//No Draw Head
	surface material5 +nodraw            
	surface material11 +nodraw
	//No Draw Phaser
	surface material13 +nodraw
	surface material14 +nodraw
	surface material16 +nodraw
	animateonce ( "change_stage_3" )
	}
	
time ( 7 )

states
	{
	GOTO_STAGE_4_NO_CIN_DIALOG : TIME_DONE
	}
}


//---------------------------------------------------------
state GOTO_STAGE_4_NO_CIN_DIALOG //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
//play dialog
	playdialog			"loc/Eng/sound/dialog/borg03/borgboss_stage3.mp3" , 1 , 20000 , 0
	simpleplayDialog	"loc/Deu/sound/dialog/borg03/borgboss_stage3.mp3" , 1 , 20000 , 0
	anim ( "idle" )
	gotostage 4
	}
	
time ( 4 )
	
states
	{
	THINK	: TIME_DONE
	}
	
exitcommands
	{
	takedamage
	}
}

//---------------------------------------------------------
state GOTO_STAGE_4 //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_4 (GLOBAL)"
	//No Draw Head
	surface material5 +nodraw            
	surface material11 +nodraw

	//No Draw Phaser
	surface material13 +nodraw
	surface material14 +nodraw
	surface material16 +nodraw
	}

legs
	{
	change_stage_3	: default
	}

states
	{
	GOTO_STAGE_FINISH : ANIM_DONE
	}

exitcommands
	{
	displayeffect noelectric
	gotostage 4
	}
}

//---------------------------------------------------------
state GOTO_STAGE_FINISH //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GOTO_STAGE_FINISH (GLOBAL)"
	displayeffect noelectric      
	runthread stage_change_cinema_end
	}

states
	{
	THINK : default
	}
}

//---------------------------------------------------------
state GLOBAL_TELEPORT_TO_PLAYER_START //()
//---------------------------------------------------------
{
entrycommands
	{
	//printmessage "GLOBAL_TELEPORT_TO_PLAYER_START (GLOBAL)"
	}

states
	{
	GLOBAL_TELEPORT_TO_PLAYER_START_MP : SHOULD_DO_ACTION ( "multiplayer" )
	GLOBAL_TELEPORT_TO_PLAYER_START_SP : default
	}
}

//---------------------------------------------------------
state GLOBAL_TELEPORT_TO_PLAYER_START_SP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GLOBAL_TELEPORT_TO_PLAYER_START_SP (GLOBAL)"
	}

behavior AnimatedTeleportToPlayer ( "teleport_start" , "teleport_end" )

states
	{
	THINK : BEHAVIOR_SUCCESS
	CHASE_PLAYER_FAST_NO_TELEPORT : BEHAVIOR_FAILED
	}
}
	
//---------------------------------------------------------
state GLOBAL_TELEPORT_TO_PLAYER_START_MP //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GLOBAL_TELEPORT_TO_PLAYER_START_MP (GLOBAL)"
	runthread coop_borgBossReplacmentTransport
	}
   
time ( .7 , .9 )

states
	{
	//THINK							: TIME_DONE SHOULD_DO_ACTION ( "coopMpAttackMelee" )
	CHASE_PLAYER_FAST_NO_TELEPORT	: default
	}
}
	
	
	
//---------------------------------------------------------
state GLOBAL_NO_PATH_AVAILABLE //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "GLOBAL_NO_PATH_AVAILABLE (GLOBAL)"
	}

Behavior GotoHelperNodeNearestEnemy ( "combat" , "walk" , 9090 )
time ( 1 , 2 )

states
	{      
	THINK : HAVE_PATH_TO_ENEMY
	GLOBAL_WANDER : BEHAVIOR_FAILED
	THINK : BEHAVIOR_SUCCESS
	}
}

//---------------------------------------------------------
state GLOBAL_WANDER //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "WANDER (GLOBAL)"
	}

Behavior Wander ( "walk" )
time ( 1 , 2 )

states
	{
	THINK : TIME_DONE
	}
}

//---------------------------------------------------------
state PAIN //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "PAIN (GLOBAL)"
	}
	
states
	{
	THINK 				: SHOULD_DO_ACTION ( "multiplayer" )
	PAIN_LEFT_SHOULDER	: BONE_DAMAGED ( "Bip01 L Clavicle" )
	PAIN_LEFT_SHOULDER	: BONE_DAMAGED ( "Bip01 L Upperarm" )
	PAIN_LEFT_SHOULDER	: BONE_DAMAGED ( "Bip01 L Forearm" )
	PAIN_LEFT_SHOULDER	: BONE_DAMAGED ( "Bip01 L Hand" )
	
	PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Clavicle" )
	PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Upperarm" )
	PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Forearm" )
	PAIN_RIGHT_SHOULDER : BONE_DAMAGED ( "Bip01 R Hand" )
	
	PAIN_HEAD           : BONE_DAMAGED ( "Bip01 Neck" )
	PAIN_HEAD           : BONE_DAMAGED ( "Bip01 Head" )
	
	PAIN_LEFT_LEG       : BONE_DAMAGED ( "Bip01 L Calf" )
	PAIN_LEFT_LEG       : BONE_DAMAGED ( "Bip01 L Thigh" )
	PAIN_LEFT_LEG       : BONE_DAMAGED  ( "Bip01 L Foot" )
	
	PAIN_RIGHT_LEG		: BONE_DAMAGED ( "Bip01 R Calf" )
	PAIN_RIGHT_LEG		: BONE_DAMAGED ( "Bip01 R Thigh" )
	PAIN_RIGHT_LEG		: BONE_DAMAGED  ( "Bip01 R Foot" )
	PAIN_GENERAL		: default
	}
}

//---------------------------------------------------------
state PAIN_LEFT_SHOULDER  //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "PAIN_LEFT_SHOULDER (GLOBAL)"
	}

legs
	{
	pain_arm_l : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state PAIN_RIGHT_SHOULDER //()
//---------------------------------------------------------
{
ignoreglobalstate  

entrycommands
	{
	//printmessage "PAIN_RIGHT_SHOULDER (GLOBAL)"
	}

legs
	{
	pain_arm_r : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state PAIN_HEAD //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "PAIN_HEAD (GLOBAL)"
	}

legs
	{
	pain_head : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state PAIN_LEFT_LEG //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "PAIN_LEFT_LEG (GLOBAL)"
	}

legs
	{
	pain_leg_l : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state PAIN_RIGHT_LEG //()
//---------------------------------------------------------
{
ignoreglobalstate  

entrycommands
	{
	//printmessage "PAIN_RIGHT_LEG (GLOBAL)"
	}

legs
	{
	pain_leg_r : default
	}

states
	{
	THINK : ANIM_DONE
	}
}

//---------------------------------------------------------
state PAIN_GENERAL //()
//---------------------------------------------------------
{
ignoreglobalstate

entrycommands
	{
	//printmessage "PAIN_GENERAL (GLOBAL)"
	}

legs
	{
	pain_chest : default
	}

states
	{
	THINK : ANIM_DONE
	}
}


