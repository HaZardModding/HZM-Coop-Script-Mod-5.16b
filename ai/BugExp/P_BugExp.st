//
// SolanSpydantYoung.st -- AI file for the Solan III Spydant creature
//
$define EXPLODE_RANGE 50
$define LAUNCH_RANGE 100

////////////////////////////////////////////////////////////////////////////////////
//
// Idle-Type States
//
///////////////////////////////////////////////////////////////////////////////////
state IDLE //()
{
   	entrycommands
	{
		//printmessage ( "IDLE" )
  		clearCurrentEnemy
		evaluateenemies
	}
	
	time ( .2 , .5 )
	
   states
	{
		WANDER     	: HAVE_ENEMY
		THINK 		: TIME_DONE
		HOLD 		: default
	}
}

state REAL_IDLE //()
   {
	entrycommands
	{
		//printmessage ( "REAL_IDLE" )
	}
   legs
    {
      idle : default
    }

   states
   {
		IDLE_RESET 	: ANIM_DONE
		HOLD      	: !HAVE_ENEMY
		THINK      	: default
    }

   }

state IDLE_RESET //()
{
  	entrycommands
	{
		//printmessage ( "IDLE_REST" )
		
	}
   states
    {
		THINK		: default
    }
}

state WANDER //()
{
  	entrycommands
	{
		//printmessage ( "WANDER" )
  		clearCurrentEnemy
		evaluateenemies
	}
	
   behavior CloseInOnEnemy ( "walk" , $LAUNCH_RANGE$ )
   time ( .75 )

   states
	{
		ATTACK : RANGE ( $LAUNCH_RANGE$ ) BEHAVIOR_SUCCESS
		HOLD  : BEHAVIOR_FAILED
		THINK  : TIME_DONE
	}
}

state ATTACK //()
   {
   	entrycommands
	{
		//printmessage ( "ATTACK" )
	}
//   behavior GetCloseToPlayer ( "attack1" , 0 , 30 )
	behavior LeapToEnemy ( 50 )

   states
      {
      EXPLODE : RANGE ( $EXPLODE_RANGE$ )
      THINK   : BEHAVIOR_SUCCESS
      THINK   : BEHAVIOR_FAILED
      }
   }

state EXPLODE //()
   {
   entrycommands
      {
		//printmessage ( "EXPLODE" )
		selfdetonate
		remove
      }
   }

state THINK //()
   {
   	entrycommands
	{
		//printmessage ( "THINK" )
  		clearCurrentEnemy
		evaluateenemies
	}
   states
    {
		//WANDER		: HAVE_ENEMY
		HOLD		: !HAVE_ENEMY
		IDLE		: default
    }
}

state DEATH //()
{
   entrycommands
    {
		//printmessage ( "DEATH" )
		selfdetonate
		remove
    }
}


state HOLD //()
{
	entrycommands
	{
		//printmessage ( "HOLD" )
	}
   legs
    {
      idle : default
    }
	
	time ( .2 , .75 )
	
	states
	{
		REAL_IDLE      	: TIME_DONE !HAVE_ENEMY
		THINK      		: TIME_DONE HAVE_ENEMY
	}
}