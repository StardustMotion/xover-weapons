const int XW_JAWZ_HUNTERS_AMMO = 6.5;//*XW_AMMOBAR_UNIT;
const int XW_JAWZ_HUNTERS_AMMO_UW = 3.0;//*XW_AMMOBAR_UNIT;

// todo optimize spawnitemexes and weapon wet/dry states duplication
actor XWJawzHuntersWep : BaseXoverWep { 
	weapon.slotNumber 7
	inventory.icon "JAWZHUNT" obituary "$OB_XWJAWZHUNTERS" tag "$TAG_XWJAWZHUNTERS"
	states {
	
		deselect:
			XWAU W 0 A_JumpIfInventory("VarA", 1, "cooldown")
			goto super::deselect
		
		select:
			XWAU W 0 A_SetArg(0,6776) // dry-normal
			XWAU W 0 A_SetArg(1,6777) // dry-flash
			XWAU W 0 A_SetArg(2,6778) // wet-normal
			XWAU W 0 A_SetArg(3,6779) // wet-flash
			XWAU W 0 A_TakeInventory("VarA")
			"----" A 0 A_JumpIfInventory("IsUnderwater", 1, "selectUW")
			XWAU W 0 ACS_ExecuteAlways(998,0,args[0])
			goto super::select
		selectUW:
			XWAW B 0 ACS_ExecuteAlways(998,0,args[2])
			goto super::select
			
		ready:
			TNT1 A 0 offset(0,32) A_JumpIfInventory("IsUnderwater", 1, "readyUW")
			XWAU W 0 Thing_SetTranslation(0,args[0])
			goto readyMain
		readyUW:
			XWAW B 0 Thing_SetTranslation(0,args[2])
		readyMain:
			"----" A 8 A_WeaponReady
			goto ready
			
		spin:
			TNT1 A 0 A_JumpIfInventory("IsUnderwater", 1, "spinUW")
			XWAU W 0 Thing_SetTranslation(0,args[0])
			goto spinMain
		spinUW:
			XWAW B 0 Thing_SetTranslation(0,args[2])
			goto spinMain
		spinMain:			
			"----" A 0 A_JumpIfInventory("VarA", 1, 1) goto cooldown
			"----" A 1 A_WeaponReady
			"----" A 0 A_JumpIfInventory("VarA", 1, 1) goto cooldown
			"----" A 1 A_WeaponReady
			"----" A 0 A_TakeInventory("JawzHuntersDuration", 2)
			"----" A 0 A_JumpIfInventory("VarA", 1, 1) goto cooldown
			"----" A 1 A_WeaponReady
			"----" A 0 A_JumpIfInventory("VarA", 1, 1) goto cooldown
			"----" A 1 A_WeaponReady
			"----" A 0 A_TakeInventory("JawzHuntersDuration", 2)
			"----" A 0 A_JumpIfInventory("JawzHuntersDuration", 1, "spin")
			goto cooldown
			
		noAmmo: 
			TNT1 A 0 A_TakeInventory("VarA")
			TNT1 A 0 offset(0,32) A_JumpIfInventory("IsUnderwater", 1, "noAmmoUW")
			XWAU W 0 Thing_SetTranslation(0,args[0])
			goto xoverNoAmmo
		noAmmoUW:
			XWAW B 0 Thing_SetTranslation(0,args[2])
			goto xoverNoAmmo
			
		// copied from BaseXoverWep
		xoverNoAmmo:
			"----" A 0 ACS_ExecuteAlways(979, 0)
			"----" A 0 A_TakeInventory("altfireToken")
			"----" A 9
			goto ready 			
		
		callSharkFlash: TNT1 A 0 A_SetArg(4,9) goto sharkFlash
		shootSharkFlash: TNT1 A 0 A_SetArg(4,7) goto sharkFlash
		sharkFlash: 
			TNT1 A 0 A_SetArg(4,args[4]-1)
			TNT1 A 0 A_JumpIfInventory("IsUnderwater", 1, "sharkFlashUW")
			TNT1 A 1 Thing_SetTranslation(0,args[1])
			TNT1 A 1 Thing_SetTranslation(0,args[0])
		sharkFlashEnd: TNT1 A 0 A_JumpIf(args[4] <= 0, "end") goto sharkFlash
		sharkFlashUW:
			TNT1 A 1 Thing_SetTranslation(0,args[3])
			TNT1 A 1 Thing_SetTranslation(0,args[2])
			goto sharkFlashEnd
		
		shoot: 
			TNT1 A 0 A_JumpIfInventory("IsUnderwater", 1, "shootUW")
			XWAV D 1 offset(1,32)
			XWAV D 1 offset(-8,44)
			
			XWAV A 1 offset(-8,52) 
			XWAV A 1 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			XWAV H 0 A_GiveInventory("Jawz Hunters Remove")
			XWAV H 1 offset(-4,42) A_GunFlash("shootSharkFlash", GFF_NOEXTCHANGE)
			XWAV B 1 offset(-2,36)
			XWAV H 1 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			
			XWAV C 1 offset(-2,36)
			XWAV I 1 offset(-1,34)
			XWAV C 0 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			
			XWAV BHCIBHBH 1
			XWAV B 0
		goto shootEnd
		
		shootUW:
			XWAW N 1 offset(1,32)
			XWAW N 1 offset(-8,44)
			
			XWAW I 1 offset(-8,52) 
			XWAW I 1 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			XWAW L 0 A_GiveInventory("Jawz Hunters Remove")
			XWAW L 1 offset(-4,42) A_GunFlash("shootSharkFlash", GFF_NOEXTCHANGE)
			XWAW J 1 offset(-2,36)
			XWAW L 1 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			
			XWAW K 1 offset(-2,36)
			XWAW M 1 offset(-1,34)
			XWAW K 0 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			
			XWAW JLKMJLJL 1
			XWAW J 0
		goto shootEnd
		
		shootEnd:
			"----" A 5
			"----" A 1 offset(-2,34)
			"----" A 1 offset(-4,38)
			"----" A 1 offset(-6,46)
			TNT1 A 0 A_JumpIfInventory("IsUnderwater", 1, "shootVeryEndUW")
			XWAV D 1 offset(16,48) Thing_SetTranslation(0,args[0])
			XWAV D 1 offset(24,64)
			XWAU W 4 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			goto spin
			
		shootVeryEndUW:
			XWAW N 1 offset(16,48) Thing_SetTranslation(0,args[2])
			XWAW N 1 offset(24,64)
			XWAW B 4 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			goto spin
		
		fire: hold: altfire: althold:
			"----" A 0 A_JumpIfInventory("Jawz Hunters Cooldown", 1, "ready")
			"----" A 0 A_JumpIfInventory("VarA", 1, "shoot")
		
			"----" A 0 A_JumpIfInventory("IsUnderwater", 1, "uwAmmoCheck")
			"----" A 0 A_JumpIf(!(CallACS("Ammo Check", XW_JAWZ_HUNTERS_AMMO)), "noAmmo")
			goto callSharksDry
		uwAmmoCheck:
			"----" A 0 A_JumpIf(!(CallACS("Ammo Check", XW_JAWZ_HUNTERS_AMMO_UW)), "noAmmo")
			goto callSharksWet
		callSharksWet:
			XWAU Z 0 ACS_NamedExecuteAlways("Ammo Consume", 0, XW_JAWZ_HUNTERS_AMMO_UW)
			goto callSharks
		callSharksDry:	
			XWAU Z 0 ACS_NamedExecuteAlways("Ammo Consume", 0, XW_JAWZ_HUNTERS_AMMO)
			goto callSharks
		callSharks:
			XWAU Z 0 A_TakeInventory("FlagB")
			XWAU Z 0 A_TakeInventory("VarA")
			XWAU Z 0 A_GiveInventory("VarA", 2)
			XWAU Z 0 A_SpawnItemEx("Jawz Hunters Orbit SFX")
			XWAU Z 0 A_PlaySoundEx("JAWZSUMN", "Weapon")
			XWAU Z 0 A_SpawnItemEx("Jawz Hunters Orbit",0,0,0,0,0,0,0,SXF_ABSOLUTEANGLE,0,TID+5770)
			XWAU Z 0 A_SpawnItemEx("Jawz Hunters Orbit",0,0,0,0,0,0,180,SXF_ABSOLUTEANGLE,0,TID+5770)
			
			TNT1 A 0 A_JumpIfInventory("IsUnderwater", 1, "callSharksAnimUW")
			XWAU Z 1 offset(-16,64)	
			XWAV G 1 offset(-28,48) A_GunFlash("callSharkFlash",GFF_NOEXTCHANGE)
			XWAU Y 1 offset(-36,40)
			XWAV F 1 offset(-38,36)
			XWAU X 1 offset(-40,32)
			
			XWAV E 1 offset(-8,36)
			XWAU Y 1 offset(16,48)
			XWAV G 1 offset(32,64)
			XWAU Z 1 offset(36,42)
			XWAV F 1 offset(40,32)
			
			XWAU X 1 offset(38,36)
			XWAV F 1 offset(36,48)
			XWAU Z 1 offset(28,64)
			XWAV G 1 offset(16,42)
			XWAU Y 1 offset(1,32)
		
			XWAV E 1 offset(0,32)
			XWAU X 1 offset(0,32)
			
			XWAV E 1 offset(0,32)
			XWAU X 8 offset(0,32)
			XWAU W 0
			goto callSharksEnd
		callSharksEnd:
			"----" A 2 offset(0,40)
			"----" A 2 offset(0,34)
			"----" A 2 offset(0,33) A_GiveInventory("JawzHuntersDuration", 105)
			"----" A 8 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			goto spin
			
		callSharksAnimUW:
			XWAW E 1 offset(-16,64)	
			XWAW H 1 offset(-28,48) A_GunFlash("callSharkFlash",GFF_NOEXTCHANGE)
			XWAW D 1 offset(-36,40)
			XWAW G 1 offset(-38,36)
			XWAW C 1 offset(-40,32)
			
			XWAW F 1 offset(-8,36)
			XWAW D 1 offset(16,48)
			XWAW H 1 offset(32,64)
			XWAW E 1 offset(36,42)
			XWAW G 1 offset(40,32)
			
			XWAW C 1 offset(38,36)
			XWAW G 1 offset(36,48)
			XWAW E 1 offset(28,64)
			XWAW H 1 offset(16,42)
			XWAW D 1 offset(1,32)
		
			XWAW F 1 offset(0,32)
			XWAW C 1 offset(0,32)
			
			XWAW F 1 offset(0,32)
			XWAW C 8 offset(0,32)
			XWAW B 0
			goto callSharksEnd
			
		cooldown1uw: XWAW C 0 Thing_SetTranslation(0,args[2])
			goto cooldown1main
		cooldown2uw: XWAW C 0 Thing_SetTranslation(0,args[2])
			goto cooldown2main
		cooldown3uw: XWAW B 0 Thing_SetTranslation(0,args[2])
			goto cooldown3main
		cooldown:
			XWAU W 0 A_GiveInventory("Jawz Hunters Cooldown")
			XWAU W 0 A_TakeInventory("VarA")
			XWAU W 0 A_TakeInventory("JawzHuntersDuration")
			XWAU X 0 A_JumpIfInventory("IsUnderwater", 1, "cooldown1uw")
			"----" A 0 Thing_SetTranslation(0,args[0])
		cooldown1main:
			// idk taunting maybe
			"----" A 1 offset(0,42)
			"----" A 1 offset(0,40)
			"----" A 1 offset(0,38)
			"----" A 1 offset(0,36)
			"----" A 1 offset(0,34)
			"----" A 1 offset(0,32)
			"----" A 1 offset(0,34)
			"----" A 1 offset(0,36)
			"----" A 1 offset(0,38)
			XWAU X 0 A_JumpIfInventory("IsUnderwater", 1, "cooldown2uw")
			"----" A 0 Thing_SetTranslation(0,args[0])
		cooldown2main:
			"----" A 1 offset(0,40)
			"----" A 1 offset(0,42)
			"----" A 1 offset(0,40)
			"----" A 1 offset(0,38)
			"----" A 1 offset(0,36)
			"----" A 1 offset(0,34)
			"----" A 1 offset(0,32)
			"----" A 1 offset(0,34)
			"----" A 1 offset(0,36)
			"----" A 1 offset(0,38)
			XWAU W 0 A_JumpIfInventory("IsUnderwater", 1, "cooldown3uw")
			"----" A 0 Thing_SetTranslation(0,args[0])
		cooldown3main:
			"----" A 1 offset(0,50)
			"----" A 1 offset(0,44)
			"----" A 1 offset(0,38)
			"----" A 1 A_WeaponReady(WRF_NOFIRE | WRF_NOSWITCH)
			goto ready}}
			
actor "Jawz Hunters Cooldown" : Powerup { powerup.duration 42 }
actor "JawzHuntersDuration" : VarA { inventory.maxamount 105 }
		
actor "Jawz Hunters Orbit" : Watcher { 
	args 0,0,0,4,13// [currentAngle, identifier, toAddAngle, DRYANGLE, WETANGLE]
	mass 0 // intro frame count
	scale 2.0 reactiontime 1 states {
	spawn:
		TNT1 A 0 nodelay A_SetScale(TID-6769)
		TNT1 A 0 Thing_ChangeTID(0,0)
		TNT1 A 0 A_SetArg(0, angle)
		TNT1 A 0 A_SetArg(1, 1+(!angle))
		TNT1 A 0 A_GiveInventory("FlagA")
		TNT1 A 0 A_RearrangePointers(AAPTR_NULL, AAPTR_TARGET)
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Orbit Assist")
		TNT1 A 0 A_RearrangePointers(AAPTR_MASTER)
		
	orbitA1: TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "orbitB1")
		TNT1 A 0 A_SetArg(2,args[3])
		TNT1 AAAA 1 A_SpawnItemEx("Jawz Hunters GFX A1",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
	orbitA2: TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "orbitB2")
		TNT1 A 0 A_SetArg(2,args[3])
		TNT1 AAAA 1 A_SpawnItemEx("Jawz Hunters GFX A2",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
	orbitA3: TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "orbitB3")
		TNT1 A 0 A_SetArg(2,args[3])
		TNT1 AAAA 1 A_SpawnItemEx("Jawz Hunters GFX A3",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
	orbitA4: TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "orbitB4")
		TNT1 A 0 A_SetArg(2,args[3])
		TNT1 AAAA 1 A_SpawnItemEx("Jawz Hunters GFX A4",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
		goto orbitA1
		
	orbitB1:
		TNT1 A 0 A_SetArg(2,args[4])
		TNT1 AA 1 A_SpawnItemEx("Jawz Hunters GFX B1",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, 1)
		goto orbitA2+1
	orbitB2: TNT1 A 0 A_SetArg(2,args[4])
		TNT1 AA 1 A_SpawnItemEx("Jawz Hunters GFX B2",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, 1)
		goto orbitA3+1
	orbitB3:  TNT1 A 0 A_SetArg(2,args[4])
		TNT1 AA 1 A_SpawnItemEx("Jawz Hunters GFX B3",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, 1)
		goto orbitA4+1
	orbitB4:  TNT1 A 0 A_SetArg(2,args[4])
		TNT1 AA 1 A_SpawnItemEx("Jawz Hunters GFX B4",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "orbitB1")
		goto orbitA1+1
		
	death: TNT1 A 2
		stop}}		
		
		
actor "Jawz Hunters Orbit Assist" : Watcher { states {
	spawn: TNT1 A 0
		TNT1 AAAAAAAAAAAAAAAA 1 A_GiveToTarget("Jawz Hunters Orbit Intro Tic", 1)
	main:
		TNT1 A 1 A_GiveToTarget("Jawz Hunters Orbit Tic", 1)
		TNT1 A 0 A_JumpIfInTargetInventory("FlagA", 1, "main")
		stop}}
		
actor "Jawz Hunters Orbit Tic" : CustomInventory { states {
	pickup: 
		TNT1 A 0 A_JumpIfInventory("FlagB", 1, "counterAttack")
		TNT1 A 0 A_JumpIfInTargetInventory("VarA", args[1], "keepSpinning")
		TNT1 A 0 A_JumpIfInTargetInventory("JawzHuntersDuration", 1, "shoot")
		goto dropTheShark
	dropTheShark:
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "uwDrop")
		TNT1 A 0 A_SetScale(1) goto dropEnd
	uwDrop: 
		TNT1 A 0 A_SetScale(2) goto dropEnd
	dropEnd:
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Drop",0,0,0,0,0,0,90,SXF_TRANSFERSCALE)
		goto clear		
	shoot: 
		TNT1 A 0 A_GiveToTarget("Jawz Hunters Shoot")
		goto clear
	counterAttack:
		TNT1 A 0 A_JumpIfInventory("FlagA", 1, 1)
		stop
		TNT1 A 0 A_JumpIfInTargetInventory("VarA", 2, "counterDualCheck")
	counterAttackStacks:
		TNT1 A 0 A_GiveToTarget("Jawz Hunters Remove")
		goto counterAttackChecks
	counterDualCheck:
		TNT1 A 0 A_JumpIf(args[1] == 1, "preventDualConsume")
		goto counterAttackStacks
		
	preventDualConsume:
		TNT1 A 0 A_GiveToTarget("FlagB")
	counterAttackChecks:
		TNT1 A 0 A_RearrangePointers(AAPTR_NULL, AAPTR_TARGET)
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Counter")
	clearCounter:
		TNT1 A 0 A_RearrangePointers(AAPTR_MASTER)
	clear: 
		TNT1 A 0 A_Countdown
		TNT1 A 0 A_TakeInventory("FlagA")
		stop	
	keepSpinning: 
		TNT1 A 0 A_SetArg(0, (args[0]+args[2])%360)
	keepSpinningWarp:
		TNT1 A 0 A_Warp(AAPTR_TARGET, mass, 0, 24, args[0], WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE|WARPF_ABSOLUTEANGLE)
		TNT1 A 0 A_RearrangePointers(AAPTR_NULL, AAPTR_TARGET)
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Block",0,-30)
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Block",0,30)
		TNT1 A 0 A_RearrangePointers(AAPTR_MASTER)
		stop}}
		
actor "Jawz Hunters Orbit Intro Tic" : "Jawz Hunters Orbit Tic" {
	states {
		keepSpinning: 
			TNT1 A 0 A_SetMass(mass+5)
			TNT1 A 0 A_SetArg(0, (args[0]+args[2]+(80-mass))%360)
			goto keepSpinningWarp}}
		
actor "Jawz Hunters Remove" : CustomInventory { states {
	pickup: 
		TNT1 A 0 A_JumpIfInventory("FlagB", 1, "counterDualConsume")
		TNT1 A 0 A_TakeInventory("VarA", 1)
		stop
	counterDualConsume: 
		TNT1 A 0 A_TakeInventory("VarA", 2)
		stop}}		
		
actor "Jawz Hunters Orbit SFX" : Watcher { states { 
	spawn: 
		TNT1 A 0 nodelay A_JumpIfInTargetInventory("VarA", 1, 1) 
		stop
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "fast")
	slow: TNT1 A 12 A_GiveToTarget("Jawz Hunters Spin 1") goto spawn
	fast: TNT1 A 8 A_GiveToTarget("Jawz Hunters Spin 2") goto spawn}}
	
		
actor "Jawz Hunters Spin 1" : CustomInventory { states {
	pickup: TNT1 A 0 A_PlaySoundEx("JAWZSPN1", "SoundSlot6") stop}}
actor "Jawz Hunters Spin 2" : CustomInventory { states {
	pickup: TNT1 A 0 A_PlaySoundEx("JAWZSPN2", "SoundSlot6") stop}}
		
		
	

		
		
		
		
		
		
			// ######### //
			// 	Attacks	 //
			// ######### //
	
// RELEASED

actor "Jawz Hunters Shoot" : CustomInventory { 
	states {
		pickup: 
			TNT1 A 0 A_PlaySoundEx("JAWZTHRW", "Weapon")
			TNT1 A 0 A_SpawnItemEx("Jawz Hunters", 0,0,20,
				40*cos(pitch), 0, 40*-sin(pitch), 0, 0, 0, TID+5736) 
			stop}}	
		
		
actor "Jawz Hunters" : Projo { 
	damage (26+(args[0]*10)) accuracy 13 // explosion damage
	radius 26 height 24
	damagetype "JawzHunters" obituary "$OB_XWJAWZHUNTERS"  
	-SCREENSEEKER +SEEKERMISSILE +MOVEWITHSECTOR
	+FIXMAPTHINGPOS +THRUSPECIES species "JawzHunters" +THRUACTORS  
	renderstyle "translucent" alpha 0.4 wallbouncefactor 0.99
	 bouncetype classic +BOUNCEONWALLS +CANBOUNCEWATER
	args 0,0 // [isUnderwaterVersion, owner]
	scale 2.0 speed 6 states { 
	spawn: 
		TNT1 A 0 nodelay A_JumpIfInTargetInventory("IsUnderwater", 1, "upgrade") 
		goto main
	upgrade: 
		TNT1 A 0 A_SetArg(0,1)
	main:
		TNT1 A 0 A_SetArg(1,TID-6735)
		TNT1 A 0 Thing_SetTranslation(0,6780+args[0])
		TNT1 A 2 Thing_ChangeTID(0,0)
		XWAV JKLM 1
		TNT1 A 0 A_JumpIf(args[0], "uwGoDeep")
		XWAV JKLM 1
		TNT1 A 0 A_FadeIn(0.6)
		goto enableJawz
	uwGoDeep:
		XWAV JKLM 1 A_FadeOut(0.1, 0)
		goto enableJawz
		
	enableJawz:
		TNT1 A 0 A_ScaleVelocity(0.15)
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false)
		TNT1 A 0 ACS_NamedExecuteWithResult("XW Weapons", SS_ASYNC_STATE, 180, true)
		
		//startup
		TNT1 A 0 A_GiveInventory("Jawz Hunters Ghost Display")
		XWAV JKLM 2
		TNT1 A 0 A_GiveInventory("Jawz Hunters Ghost Display")
		XWAV JKLM 2
		TNT1 A 0 A_GiveInventory("Jawz Hunters Ghost Display")
		XWAV JKLM 2
		goto hunt
	hunt:
		TNT1 A 0 A_GiveInventory("Jawz Hunters Ghost Display")
		XWAV J 0 A_SeekerMissile(89,90,SMF_LOOK|SMF_CURSPEED ,256,12)
		XWAV J 2 A_JumpIfTracerCloser(768, "chaseStart")
		XWAV K 2
		XWAV L 0 A_SeekerMissile(89,90,SMF_LOOK|SMF_CURSPEED ,256,12)
		XWAV L 2 A_JumpIfTracerCloser(768, "chaseStart")
		XWAV M 2
		goto hunt
	chaseStart:
		XWAV M 0 A_RearrangePointers(AAPTR_NULL, AAPTR_TARGET)
		XWAV M 0 A_GiveInventory("FlagA")
		XWAV M 0 A_SpawnItemEx("Jawz Hunters Watcher",0,0,0, 0,0,0, 69*args[0], SXF_ABSOLUTEANGLE)
		XWAV M 0 A_RearrangePointers(AAPTR_MASTER)
	chase:
		XWAV J 0 A_FaceTracer(0,14)
		XWAV J 1 A_ChangeVelocity(28*cos(pitch),0,28*sin(pitch), CVF_RELATIVE | CVF_REPLACE)//A_SeekerMissile(89,90,SMF_LOOK|SMF_PRECISE,256,16)
		XWAV KLMJKLM 1
		XWAV JKLMJKLM 1 A_ScaleVelocity(0.83)
	chaseRest:
		XWAV JKLMJKLM 2
	juke:
		XWAV J 0 A_JumpIf(random(0,1), "chase")
		XWAV JKLM 2
		goto chase
	death: promiseThen:
		TNT1 A 0 A_Explode(accuracy,96,0,0,50) // radius+playerRadius+8
		TNT1 A 1 A_SpawnItemEx("Jawz Hunters Boom Server")
		stop}}

actor "Jawz Hunters Lock-On Stack" : VarA {}
		
actor "Jawz Hunters Watcher" : Watcher { states {
	spawn: 
		 // the locked victim
		TNT1 A 0 nodelay A_GiveToTarget("Jawz Hunters Lock-On Stack",1,AAPTR_TRACER)
		TNT1 A 0 A_GiveToTarget("Jawz Hunters Reticle Summon", 1, AAPTR_TRACER)		
		TNT1 A 0 A_TransferPointer(AAPTR_TARGET,AAPTR_DEFAULT,AAPTR_TRACER,AAPTR_TRACER)
		TNT1 A 0 A_JumpIf(!angle, "notDoneYet")
		goto notDoneYetUW		
	notDoneYet: 
		TNT1 A 8
		TNT1 A 0 A_JumpIfInTargetInventory("FlagA", 1, "notDoneYet")
		goto lockEnd
	notDoneYetUW: 
		TNT1 A 0 A_GiveToTarget("Jawz Hunters Ghost Display")
		TNT1 AAAA 2 A_GiveToTarget("Jawz Hunters Plunge")
		TNT1 A 0 A_JumpIfInTargetInventory("FlagA", 1, "notDoneYetUW")
		goto lockEnd
	lockEnd:
		TNT1 A 0 A_RearrangePointers(AAPTR_TRACER)
		TNT1 A 0 A_TakeFromTarget("Jawz Hunters Lock-On Stack", 1)
		stop}}
	
		
actor "Jawz Hunters Plunge" : CustomInventory { states {
	pickup: 
		TNT1 A 0 A_JumpIfTracerCloser(192, "d12") goto d3
	d12:
		TNT1 A 0 A_JumpIfTracerCloser(96, "d1") goto d2
			
	d1: TNT1 A 0 A_SetTranslucent(1.0) stop
	d2: TNT1 A 0 A_SetTranslucent(0.5) stop
	d3: TNT1 A 0 A_SetTranslucent(0.0) stop }}







// COUNTER ATTACK
		
actor "Jawz Hunters Block" : Projo { 
	damage (0) radius 30 height 48 +NORADIUSDMG
	+THRUSPECIES species "JawzHunters" // zandro limitations
	args 0 // [blockerOffset]
	painchance 256 -NOBLOCKMAP +QUICKTORETALIATE +THRUGHOST +SHOOTABLE +GHOST +DONTRIP 
	states {
		spawn: TNT1 A 0
			TNT1 A 1
			stop
		pain: 
			TNT1 A 0 A_ChangeFlag("NOINTERACTION", true)
			// attacker is acquired on the next tic, here target is still the Jawz user
			TNT1 A 0 A_RearrangePointers(AAPTR_DEFAULT, AAPTR_TARGET)
			TNT1 A 1
			TNT1 A 0 A_RearrangePointers(AAPTR_MASTER, AAPTR_TARGET)
			// transfer the attacker to the orbiting actor
			TNT1 A 0 A_TransferPointer(AAPTR_DEFAULT, AAPTR_TARGET, AAPTR_MASTER, AAPTR_TRACER)
			TNT1 A 0 A_GiveToTarget("FlagB")
			stop}}
		
actor "Jawz Hunters Counter" : "Jawz Hunters" { 
	damagetype "JawzHuntersCounter" obituary "$OB_XWJAWZHUNTERSCOUNTER"
	damage (24) accuracy 12 alpha 1.0 -SEEKERMISSILE bouncetype none  speed 94
	reactiontime 10
	args 0,0,0 // [translation, isUnderWaterVersion, currentFrame]
	states {
	spawn: 
		TNT1 A 0
		TNT1 A 0 A_TransferPointer(AAPTR_TARGET,AAPTR_DEFAULT,AAPTR_TRACER,AAPTR_TRACER)
		TNT1 A 0 A_TransferPointer(AAPTR_TARGET,AAPTR_DEFAULT,AAPTR_MASTER,AAPTR_TARGET)
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "upgrade")
		goto main
	upgrade:
		TNT1 A 0 A_SetArg(1,1)
	main:
		TNT1 A 0 A_SetArg(0,args[1]+6780)
		TNT1 A 0 Thing_SetTranslation(0,args[0])
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false)
	blinking:
		XWAV J 0 A_PlaySoundEx("JAWZRUSH", "Weapon")
		XWAV JKLMJKLM 1 A_GiveInventory("Jawz Hunters Counter Aim")
		XWAV J 0 A_GiveInventory("Jawz Hunters Counter Aim")
		XWAV J 0 A_JumpIf(!args[1], "hunt")		
		XWAV JKLMJK 1 A_GiveInventory("Jawz Hunters Counter Aim")
		goto hunt+2
	hunt: XWAV JKLM 1
		XWAV J 0 A_Countdown
		loop
	death: 
		TNT1 A 0 A_PlaySoundEx("NOSOUND", "Weapon")
		goto super::death}}
		
actor "Jawz Hunters Counter Aim" : CustomInventory { states {
	pickup:
		TNT1 A 0 A_JumpIf(!args[2] || args[1], "aim")
		goto blink
	aim:
		TNT1 A 0 A_FaceTracer(0,180)
		TNT1 A 0 A_SetPitch(pitch+2) // look a bit over target's feet
		TNT1 A 0 A_SetScale(1.0+ args[2]+(15*!args[1]))
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock Scan", 0,0,0,
			1024*cos(pitch),0,1024*sin(pitch),0,SXF_TRANSFERSCALE)
		TNT1 A 0 A_SetScale(2.0)
		goto blink
	blink:
		TNT1 A 0 A_JumpIf(args[2] < 8, 2)
		XWAV J 0 A_ChangeVelocity(94*cos(pitch),0,94*sin(pitch),CVF_RELATIVE|CVF_REPLACE)
		
		TNT1 A 0 A_SetArg(2,args[2]+1)
		TNT1 A 0 A_JumpIf((args[2] % 2) || (args[2] >= 8), "white")
		TNT1 A 0 Thing_SetTranslation(0, args[0])
		stop
	white:
		TNT1 A 0 Thing_SetTranslation(0, 6782)
		stop}}
		
		
		
	
	
		
	

	
	
			// ######### //
			// 	Effects	 //
			// ######### //
			
actor "Jawz Hunters GFX A1" : BasicClientSideFrameTID { 
	scale 2.0 args 6780 alpha 0.4 states { 
	sprite: XWAV J 0
	rescale: "----" A 0 A_SetScale(2.0)
		"----" A 0 Thing_SetTranslation(0,args[0])
		goto clientSideCheck}}
actor "Jawz Hunters GFX A2" : "Jawz Hunters GFX A1" { states { sprite: XWAV K 0
	goto rescale}}
actor "Jawz Hunters GFX A3" : "Jawz Hunters GFX A1" { states { sprite: XWAV L 0
	goto rescale}}
actor "Jawz Hunters GFX A4" : "Jawz Hunters GFX A1" { states { sprite: XWAV M 0
	goto rescale}}
		
actor "Jawz Hunters GFX B1" : "Jawz Hunters GFX A1" { args 6781 }
actor "Jawz Hunters GFX B2" : "Jawz Hunters GFX A2" { args 6781 }
actor "Jawz Hunters GFX B3" : "Jawz Hunters GFX A3" { args 6781 }
actor "Jawz Hunters GFX B4" : "Jawz Hunters GFX A4" { args 6781 }

// Jawz explosion
actor "Jawz Hunters Boom Server" : Watcher { states {
	spawn: TNT1 A 0 nodelay A_PlaySoundEx("JAWZBOOM", "Weapon")
		TNT1 A 0 A_JumpIfInTargetInventory("IsUnderwater", 1, "uw")
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Boom Client")
		stop
	uw: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Boom Client UW")
		stop}}
		
actor "Jawz Hunters Boom Client" : BasicClientSide { +FORCEXYBILLBOARD
	translation "192:192=86:86", "198:198=86:86", "199:199=95:95", 
	"194:194=229:229", "195:195=218:218"
	states { 
		spawn: TNT1 A 0
			XWAV "XYZ\" 3
			XWAW A 3
			stop}}
		
actor "Jawz Hunters Boom Client UW" : "Jawz Hunters Boom Client" {
	translation "192:192=56:56", "198:198=56:56", "199:199=255:255",
		"194:194=215:215", "195:195=21:21" }
		
		
// Reticle (released Jawz)
actor "Jawz Hunters Locked On" : Powerup { powerup.duration 0x7FFFFFFA }

actor "Jawz Hunters Reticle Summon" : CustomInventory { states { 
	pickup: TNT1 A 0 A_JumpIfInventory("Jawz Hunters Locked On", 1, 2)
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Reticle Watcher")
		TNT1 A 0
		stop}}

actor "Jawz Hunters Reticle Watcher" : Watcher { states {
	spawn: TNT1 A 0 nodelay A_GiveToTarget("Jawz Hunters Locked On")
	gfx:
		TNT1 A 0 A_Warp(AAPTR_TARGET,64,0,0,0,WARPF_NOCHECKPOSITION)
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Beep")
		TNT1 AAA 1 A_GiveToTarget("Jawz Hunters Lock 1I")
		TNT1 AAA 1 A_GiveToTarget("Jawz Hunters Lock 2I")
		TNT1 A 0 A_JumpIfInTargetInventory("Jawz Hunters Lock-On Stack", 1, 1) goto end
		TNT1 AAA 1 A_GiveToTarget("Jawz Hunters Lock 3I")
		TNT1 AAA 1 A_GiveToTarget("Jawz Hunters Lock 4I")
		TNT1 AAA 1 A_GiveToTarget("Jawz Hunters Lock 5I")
		TNT1 A 0 A_JumpIfInTargetInventory("Jawz Hunters Lock-On Stack", 1, "gfx") goto end
	end: TNT1 A 0 A_TakeFromTarget("Jawz Hunters Locked On")
		stop}}
		
actor "Jawz Hunters Beep" : Watcher { states {
	spawn: TNT1 A 0 nodelay A_PlaySoundEx("JAWZBEEP", "SoundSlot5") stop}}

//to StrParam'd
actor "Jawz Hunters Lock 1I" : CustomInventory { states { 
	pickup: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock 1 Server") stop}}
actor "Jawz Hunters Lock 2I" : CustomInventory { states { 
	pickup: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock 2 Server") stop}}
actor "Jawz Hunters Lock 3I" : CustomInventory { states { 
	pickup: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock 3 Server") stop}}
actor "Jawz Hunters Lock 4I" : CustomInventory { states { 
	pickup: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock 4 Server") stop}}
actor "Jawz Hunters Lock 5I" : CustomInventory { states { 
	pickup: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock 5 Server") stop}}
	
actor "Jawz Hunters Lock 1 Server" : Watcher { states { spawn:
	TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Lock 1 Client") stop}}
actor "Jawz Hunters Lock 2 Server" : Watcher { states { spawn:
	TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Lock 2 Client") stop}}
actor "Jawz Hunters Lock 3 Server" : Watcher { states { spawn:
	TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Lock 3 Client") stop}}
actor "Jawz Hunters Lock 4 Server" : Watcher { states { spawn:
	TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Lock 4 Client") stop}}
actor "Jawz Hunters Lock 5 Server" : Watcher { states { spawn:
	TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Lock 5 Client") stop}}
	
actor "Jawz Hunters Lock 1 Client" : BasicClientSide { +FORCEXYBILLBOARD scale 2.0 states { spawn: XWAV N 0
		frame: "----" A 1
			stop}}
actor "Jawz Hunters Lock 2 Client" : "Jawz Hunters Lock 1 Client" { states { spawn: XWAV O 0
	goto frame}}
actor "Jawz Hunters Lock 3 Client" : "Jawz Hunters Lock 1 Client" { states { spawn: XWAV P 0
	goto frame}}
actor "Jawz Hunters Lock 4 Client" : "Jawz Hunters Lock 1 Client" { states { spawn: XWAV Q 0
	goto frame}}
actor "Jawz Hunters Lock 5 Client" : "Jawz Hunters Lock 1 Client" { states { spawn: XWAV R 0
	goto frame}}

// UW released Jawz user-seen ghost
actor "Jawz Hunters Ghost Display" : CustomInventory { states {
	pickup: TNT1 A 0 A_JumpIf(alpha < 0.01, "ghosting") stop
	ghosting: TNT1 A 0 A_SetScale(args[1])
		TNT1 A 0 A_SpawnItemEx("Jawz Hunters Ghost Server",0,0,0,0,0,0,0,SXF_TRANSFERSCALE)
		TNT1 A 0 A_SetScale(2.0) 
		stop}}
		
actor "Jawz Hunters Ghost Server" : Watcher { states { spawn: 
	TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Ghost Client",0,0,0,0,0,0,0,SXF_TRANSFERSCALE) stop}}
		
actor "Jawz Hunters Ghost Client" : "Jawz Hunters GFX B1" { alpha 0.8 
	states {  
		otherPOV: TNT1 A 0 
			stop
		clientSidePOV: XWAV J 1
			XWAV JKKLLMM 1 A_FadeOut(0.08) stop }}
		
actor "Jawz Hunters Drop" : Watcher { states { 
	spawn: TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Drop Client",0,0,0,
			0,0,0,0,SXF_TRANSFERSCALE) stop}}
		
actor "Jawz Hunters Drop Client" : BasicClientSideCollider { 
	-NOGRAVITY reactiontime 13 states { 
	spawn: 
		TNT1 A 0 nodelay Thing_SetTranslation(0,6779+scalex)
		TNT1 A 0 A_SetScale(2.0)
	fade: 
		TNT1 A 1 A_Countdown
		XWAV J 1
		loop}}
	
// Counter attack visor
actor "Jawz Hunters Lock Scan" : RayCastingProjo {
	+THRUSPECIES species "JawzHunters" radius 26 height 24 -RIPPER //Jawz hitbox
	states {
		xdeath: crash: TNT1 A 0 A_SpawnItemEx("Jawz Hunters Lock Scan Server",
			0,0,0, 0,0,0, 0, SXF_TRANSFERSCALE) stop}}
			
actor "Jawz Hunters Lock Scan Server" : Watcher { states {
	spawn: 
		TNT1 A 0 nodelay A_SpawnItemEx("Jawz Hunters Lock Scan Client",0,0,0,
			0,0,0,0,SXF_TRANSFERSCALE)
		TNT1 A 0 A_JumpIf(scalex==16 || scalex==9, "sfx") // dry visor / uw first moving tic visor
		stop
	sfx:
		TNT1 A 0 A_PlaySoundEx("JAWZSCAN", "Weapon")
		stop}}
			
actor "Jawz Hunters Lock Scan Client" : "Jawz Hunters Lock 1 Client" { states {
	spawn: TNT1 A 0
		TNT1 A 0 A_SetArg(0, scalex-1)
		TNT1 A 0 A_SetScale(2.0)
		TNT1 A 0 A_JumpIf(args[0]/15, "final") // dry aiming
		TNT1 A 0 A_JumpIf(args[0]/14, "finalWet") // final wet aiming
		TNT1 A 0 A_SetArg(0, args[0]%5)
		//A_JumpIf(true, (1+(args[0]%6))  (:
		TNT1 A 0 A_JumpIf(args[0] < 2, "f12") goto f345
	f12: TNT1 A 0 A_JumpIf(!args[0], "f1") goto f2
	f345: TNT1 A 0 A_JumpIf(args[0] < 3, "f3") goto f45
	f45: TNT1 A 0 A_JumpIf(args[0] < 4, "f4") goto f5
		
	f1: XWAV S 1
		stop
	f2: XWAV T 1
		stop
	f3: XWAV U 1
		stop
	f4: XWAV V 1
		stop
	f5: XWAV W 1
		stop
	
	final:
		XWAV STUVWSTUVWSTUV 1
	finalWet:
		XWAV WS 1
		TNT1 A 1
		XWAV T 1
		TNT1 A 1
		XWAV V 1
		TNT1 A 1
		XWAV S 1
		TNT1 A 1
		XWAV U 1
		TNT1 A 1
		XWAV W 1
		stop}}