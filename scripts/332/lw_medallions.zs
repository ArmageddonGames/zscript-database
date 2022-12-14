//LWeapons.zh Medallions

const int BOMBOS_SCRIPT = 3;//FFC script slot for Bombos

//D0- Blank so other scripts can use it.
//D1- How much MP Bombos takes to use.

item script Run_Bombos{
	void run(int dummy, int MP_Cost){
		if(Link->MP>=MP_Cost && CountFFCsRunning(BOMBOS_SCRIPT)==0){
			int Args[8];
			NewFFCScript(BOMBOS_SCRIPT,Args);
			Link->MP-=MP_Cost;
		}
	}
}

ffc script Bombos_Spell{
	void run(){
		this->X=Link->X;
		this->Y=Link->Y;
		lweapon fireball;
		int i;
		int counter;
		int timer;
		Link->CollDetection=false;
		for(i=0;i<=3;i++){
			fireball= FireLWeapon(LW_SCRIPT1, Link->X + 8,
									 Link->Y+8, __DirtoRad(i), 
									 100, 0, SPR_FIRE, SFX_FIRE, 
									 LWF_PIERCES_ENEMIES|LWF_NORMALIZE);
			SetLWeaponLifespan(fireball,LWL_TIMER,180);
			SetLWeaponMovement(fireball,LWM_CIRCLE,32,10);
			SetLWeaponDeathEffect(fireball,LWD_VANISH,0);
			fireball->Misc[LW_ZH_I_FLAGS_2]|=LWF_NO_COLLISION;
		}
		while(fireball->isValid())
			WaitNoAction();
		counter = 10;
		while (counter>0){
			Link->Action=LA_CASTING;
			timer--;
			if (timer<=0){
				lweapon fire= Screen->CreateLWeapon(LW_SBOMBBLAST);
				fire->X=Rand(256);
				fire->Y=Rand(176);
				fire->Damage = 8;
				SetLWeaponFlag(fire,__LWFI_IS_LWZH_LWPN);
				counter--;
				timer=8;
			}	
			WaitNoAction();
		}
		lweapon fire= Screen->CreateLWeapon(LW_SBOMBBLAST);
		fire->X=Link->X;
		fire->Y=Link->Y;
		SetLWeaponFlag(fire,__LWFI_IS_LWZH_LWPN);
		fireball= FireLWeapon(LW_SCRIPT1, Link->X + 8,
									 Link->Y+8, DegtoRad(0), 
									 0, 20, SPR_NULL, SFX_FIRE, 
									 LWF_PIERCES_ENEMIES);
		SetLWeaponLifespan(fireball,LWL_TIMER,60);
		SetLWeaponMovement(fireball,LWM_FULL_SCREEN,0x0c,64);
		SetLWeaponDeathEffect(fireball,LWD_VANISH,0);
		Link->CollDetection=true;
	}
}

//D0- Blank so other scripts can use it.
//D1- How much MP Ether takes to use.

item script Run_Ether{
	void run(int dummy, int MP_Cost){
		if(Link->MP>=MP_Cost && CountFFCsRunning(ETHER_SCRIPT)==0){
			int Args[8];
			NewFFCScript(ETHER_SCRIPT,Args);
			Link->MP-=MP_Cost;
		}
	}
}

const int ETHER_SCRIPT = 4;//FFC Script slot for Ether
const int TILE_LIGHTNING = 42310;//Tile used to draw lightning bolt above Link's head.
const int SFX_ETHER = 44;//Sound made by Ether projectiles.
const int SPR_ETHER = 87;//Sprite of Ether projectiles.
const int SFX_LIGHTNING= 66;//Sound made by lightning bolt.

ffc script Ether_Spell{
	void run (){
		this->X=Link->X;
		this->Y=Link->Y;
		int i;
		int drawlightning;
		lweapon trigger;
		lweapon fireball1[8];
		lweapon fireball2[8];
		int timer;
		Game->PlaySound(SFX_LIGHTNING);
		while (drawlightning<=Link->Y){
			drawlightning++;
			Screen->DrawTile(6,Link->X, Link->Y-drawlightning,TILE_LIGHTNING,1,1,0,16,drawlightning,0,0,0,0,true,128);
			WaitNoAction();
		}
		for(i=0;i<=7;i++){
			fireball1[i]= FireLWeapon(LW_SCRIPT2, Link->X + 8,
									 Link->Y+8, __DirtoRad(i), 
									 100, 0, SPR_ETHER, SFX_ETHER, 
									 LWF_PIERCES_ENEMIES|LWF_NORMALIZE);
			SetLWeaponLifespan(fireball1[i],LWL_TIMER,180);
			SetLWeaponMovement(fireball1[i],LWM_CIRCLE,32,10);
			SetLWeaponDeathEffect(fireball1[i],LWD_VANISH,0);
			fireball1[i]->Misc[LW_ZH_I_FLAGS_2]|=LWF_NO_COLLISION;
		}
		Game->PlaySound(SFX_ETHER);
		timer= 180;
		while(timer>=0){
			timer--;
			WaitNoAction();
		}
		for(i=0;i<=7;i++){
			fireball2[i]= FireLWeapon(LW_SCRIPT2, Link->X + 32* Cos((i+1)*45),
									 Link->Y+8 + 32* Sin((i+1)*45), DegtoRad((i+1)*45), 
									 100, 0, SPR_ETHER, SFX_ETHER, 
									 LWF_PIERCES_ENEMIES|LWF_NORMALIZE|LWF_STUNS_ENEMIES);
			SetLWeaponLifespan(fireball2[i],LWL_TIMER,180);
			SetLWeaponDeathEffect(fireball2[i],LWD_VANISH,0);
		}
		trigger= FireLWeapon(LW_SCRIPT2, Link->X + 8,
									 Link->Y+8, DegtoRad(0), 
									 0, 20, SPR_NULL, SFX_FIRE, 
									 LWF_PIERCES_ENEMIES);
		SetLWeaponLifespan(trigger,LWL_TIMER,60);
		SetLWeaponMovement(trigger,LWM_FULL_SCREEN,0x06,64);
		SetLWeaponDeathEffect(trigger,LWD_VANISH,0);								 
	}
}

//D0- Blank so other scripts can use it.
//D1- How much MP Quake takes to use.

item script Run_Quake{
	void run(int dummy, int MP_Cost){
		if(Link->MP>=20 && CountFFCsRunning(QUAKE_SCRIPT)==0){
			int Args[8];
			NewFFCScript(QUAKE_SCRIPT,Args);
			Link->MP-=20;
		}
	}
}

const int QUAKE_SCRIPT = 6;//FFC Script slot for Quake.
const int SPR_QUAKE = 100;//Sprite of Quake effect.
const int SFX_QUAKE = 82;//Sound of Quake effect.

//Check if on the ground in top-down.

bool OnGround(){
	return(Link->Jump==0);
}

ffc script Quake_Spell{
	void run(){
		int i;
		lweapon quake;
		lweapon trigger;
		Link->Jump = 2;
		while(!OnGround())
			WaitNoAction();
		Screen->Quake = 60;
		for(i=0;i<=3;i++){
			quake = FireLWeapon(LW_SCRIPT3, Link->X+InFrontX(i,2), Link->Y+InFrontY(i,2), 
										__DirtoRad(i),100, 20, SPR_QUAKE, 0,LWF_PIERCES_ENEMIES|LWF_STUNS_ENEMIES);
			if(quake->Dir==DIR_UP || quake->Dir==DIR_DOWN)
				SetLWeaponMovement(quake, LWM_SINE_WAVE, 6, 4);
			else if(quake->Dir==DIR_LEFT || quake->Dir==DIR_RIGHT)
				SetLWeaponMovement(quake, LWM_SINE_WAVE, 4, 6);	
			SetLWeaponLifespan(quake,LWL_EDGE,0);
			SetLWeaponDeathEffect(quake,LWD_VANISH,0);
			Game->PlaySound(SFX_QUAKE);
		}
		trigger= FireLWeapon(LW_SCRIPT3, Link->X + 8,
									 Link->Y+8, DegtoRad(0), 
									 0, 20, SPR_NULL, SFX_FIRE, 
									 LWF_PIERCES_ENEMIES);
		SetLWeaponLifespan(trigger,LWL_TIMER,60);
		SetLWeaponMovement(trigger,LWM_FULL_SCREEN,0x02,64);
		SetLWeaponDeathEffect(trigger,LWD_VANISH,0);	
	}
}