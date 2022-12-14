//LW_ZH Life and Death Functions

// Set an lweapon's lifespan
void SetLWeaponLifespan(lweapon wpn, int type, int arg)
{
    wpn->Misc[LW_ZH_I_LIFESPAN]=type;
    wpn->Misc[LW_ZH_I_LIFESPAN_ARG]=arg;
    //wpn->Misc[LW_ZH_I_FLAGS]|=__LWFI_IS_LWZH_LWPN;
}

// Set an lweapon to use a standard death effect
void SetLWeaponDeathEffect(lweapon wpn, int type, int arg)
{  
    wpn->Misc[LW_ZH_I_ON_DEATH]=type;
    wpn->Misc[LW_ZH_I_ON_DEATH_ARG]=arg;
    //wpn->Misc[LW_ZH_I_FLAGS]|=__LWFI_IS_LWZH_LWPN;
}

//LWeapon Death Effects

//This lweapon aims at an enemy.

void __DoLWeaponDeathAimAtNPC(lweapon wpn){
    wpn->Step=0;
	wpn->Misc[LW_ZH_I_WORK]=0;
    wpn->Misc[LW_ZH_I_ON_DEATH_ARG]-=1;
	float targetAngle;
	npc target_enemy;
    if(wpn->Misc[LW_ZH_I_ON_DEATH_ARG]<=0){
        if(Screen->NumNPCs()>0){
			wpn->Misc[LW_ZH_I_WORK] = Rand(1,Screen->NumNPCs());
			for(int i=1;i<=Screen->NumNPCs();i++){
				target_enemy = Screen->LoadNPC(i);
				if(target_enemy->ID==wpn->Misc[LW_ZH_I_WORK] &&
					target_enemy->Defense[LWDefense(wpn->ID)]!=NPCDT_BLOCK||
					target_enemy->Defense[LWDefense(wpn->ID)]!=NPCDT_IGNORE)
					target_enemy->Misc[NPC_MISC_TARGET_NUMBER]=wpn->Misc[LW_ZH_I_WORK];
			}
			if(target_enemy->HP<=0)wpn->Misc[LW_ZH_I_WORK]=0;
			if(target_enemy->Misc[NPC_MISC_TARGET_NUMBER]==wpn->Misc[LW_ZH_I_WORK])
				targetAngle=RadianAngle(wpn->X, wpn->Y, target_enemy->X, target_enemy->Y);
			wpn->Angle=targetAngle;
			SetLWeaponDir(wpn);
			wpn->Step=300;
			wpn->Misc[LW_ZH_I_ON_DEATH]=0;
		}
		else
			Remove(wpn);
	}
    // Spin while waiting
    wpn->Angle+=0.3;
    return;
    // Pick a direction based on the counter
	int dir=wpn->Misc[LW_ZH_I_ON_DEATH_ARG]&110b;
	if(dir==110b)
		SetLWeaponRotation(wpn, DIR_UP);
	else if(dir==100b)
		SetLWeaponRotation(wpn, DIR_RIGHT);
	else if(dir==010b)
		SetLWeaponRotation(wpn, DIR_DOWN);
	else
		SetLWeaponRotation(wpn, DIR_LEFT);
}



// Some of these could probably be combined...

//This lweapon explodes in a bomb blast.

void __DoLWeaponDeathExplode(lweapon wpn)
{
    FireNonAngularLWeapon(LW_BOMBBLAST, CenterX(wpn)-8, CenterY(wpn)-8, wpn->Dir, 0, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], -1, 0, LWF_PIERCES_ENEMIES);
	Remove(wpn);
}

//This lweapon explodes in a super bomb blast.

void __DoLWeaponDeathSBombExplode(lweapon wpn)
{
    FireNonAngularLWeapon(LW_SBOMBBLAST, CenterX(wpn)-8, CenterY(wpn)-8, wpn->Dir, 0, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], -1, 0,LWF_PIERCES_ENEMIES);
	Remove(wpn);
}

// Some of these could probably be combined...

//This lweapon explodes in a bomb blast.

void __DoLWDeathExplodeShake(lweapon wpn)
{
    FireNonAngularLWeapon(LW_BOMBBLAST, CenterX(wpn)-8, CenterY(wpn)-8, wpn->Dir, 0, wpn->Damage, -1, 0, LWF_PIERCES_ENEMIES);
	Screen->Quake = wpn->Misc[LW_ZH_I_ON_DEATH_ARG];
	Remove(wpn);
}

//This lweapon explodes in a super bomb blast.

void __DoLWDeathSBombShake(lweapon wpn)
{
    FireNonAngularLWeapon(LW_SBOMBBLAST, CenterX(wpn)-8, CenterY(wpn)-8, wpn->Dir, 0, wpn->Damage, -1, 0,LWF_PIERCES_ENEMIES);
	Screen->Quake = wpn->Misc[LW_ZH_I_ON_DEATH_ARG];
	Remove(wpn);
}

//This lweapon produces 4 horizontal and vertical lweapons.

void __DoLWeaponDeath4FireballsHV(lweapon wpn)
{
    for(int i=0; i<270; i+=90)
        FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 200, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	Remove(wpn);
}

//This lweapon produces 4 diagonal lweapons.

void __DoLWeaponDeath4FireballsDiag(lweapon wpn)
{
    for(int i=45; i<315; i+=90)
        FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 200, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	Remove(wpn);
}

//This lweapon produces 4 random lweapons.

void __DoLWeaponDeath4FireballsRand(lweapon wpn)
{
    if(Rand(2)==0)
    {
        for(int i=0; i<270; i+=90)
            FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 200, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	}
    else
    {
        for(int i=45; i<315; i+=90)
            lweapon new = FireNonAngularLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8,  DegtoRad(i), 200, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	}
    Remove(wpn);
}

//This lweapon makes lweapons in all 8 directions.

void __DoLWeaponDeath8Fireballs(lweapon wpn)
{
    for(int i=0; i<315; i+=45)
        FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 200, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	Remove(wpn);
}

void __DoLWeaponDeathShaky(lweapon wpn){
	Screen->Quake= wpn->Misc[LW_ZH_I_ON_DEATH_ARG];
	Remove(wpn);
}

void __DoLWeaponDeath4FiresDiag(lweapon wpn)
{
    for(int i=45; i<315; i+=90)
        FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 71, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	Game->PlaySound(SFX_FIRE);
    Remove(wpn);
}

void __DoLWeaponDeath4FiresRand(lweapon wpn)
{
    if(Rand(2)==0)
    {
        for(int i=0; i<270; i+=90)
            FireNonAngularLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 100, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	}
    else
    {
        for(int i=45; i<315; i+=90)
            FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 71, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	}
    Game->PlaySound(SFX_FIRE);
    Remove(wpn);
}

void __DoLWeaponDeath4FiresHV(lweapon wpn)
{
    for(int i=0; i<4; i++)
        FireNonAngularLWeapon(LW_FIRE, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 100, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
    Game->PlaySound(SFX_FIRE); // Only play sound once
    Remove(wpn);
}

void __DoLWeaponDeath8Fires(lweapon wpn)
{
    for(int i=0; i<270; i+=90)
        FireLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 100, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	for(int i=45; i<315; i+=90)
		FireNonAngularLWeapon(wpn->ID, CenterX(wpn)-8, CenterY(wpn)-8, DegtoRad(i), 71, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, 0);
	Game->PlaySound(SFX_FIRE);
    Remove(wpn);
}

void __DoLWeaponDeathSingleFire(lweapon wpn)
{
    FireLWeapon(LW_FIRE, CenterX(wpn)-8, CenterY(wpn)-8, wpn->Dir, 0, wpn->Damage/2, wpn->Misc[LW_ZH_I_ON_DEATH_ARG], 0, LWF_PIERCES_ENEMIES);
    Game->PlaySound(SFX_FIRE);
    Remove(wpn);
}

void __DoLWeaponDeathReturn(lweapon wpn){
	//This is a boomerang.
	if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG){
		//Calculate the X and Y center of the weapon.
		int fx = CenterX (wpn);
		int fy = CenterY (wpn);
		//Calculate angle from Link to Lweapon
		int hdir = Angle(fx, fy, CenterLinkX(),CenterLinkY());
		//Move weapon along that path towards Link.
		wpn->Misc[LW_ZH_I_XPOS]= wpn->X+ ((wpn->Step/100)*Cos(hdir));
		wpn->Misc[LW_ZH_I_YPOS]= wpn->Y+ ((wpn->Step/100)*Sin(hdir));
		wpn->X=wpn->Misc[LW_ZH_I_XPOS];
		wpn->Y=wpn->Misc[LW_ZH_I_YPOS];
		//Set the weapon to pierce if it doesn't already.
		if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
			wpn->Misc[LW_ZH_I_FLAGS]|=LWF_PIERCES_ENEMIES;
		//Set it not to collide with enemies.
		wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_NO_COLLISION;
		//This lweapon has reached Link. Kill it.
		if(LinkCollision(wpn))
			Remove(wpn);
	}
	else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT){
		wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_NO_COLLISION;
		if(wpn->Dir==DIR_LEFT||wpn->Dir==DIR_RIGHT){
			if(Abs(wpn->X-Link->X+8)>0){
				if(wpn->Dir==DIR_LEFT)wpn->Misc[LW_ZH_I_XPOS]++;
				else if(wpn->Dir==DIR_RIGHT)wpn->Misc[LW_ZH_I_XPOS]--;
				for(int i =0;i<=wpn->Misc[LW_ZH_I_WORK];i++){
					lweapon particle = FireScriptedLWeapon(LW_SCRIPT2, Calc(wpn->X,Link->X+8,wpn->Misc[LW_ZH_I_MOVEMENT_ARG]), wpn->Y, wpn->Misc[LW_ZH_I_MOVEMENT_ARG2], 0, 0,LWF_NO_COLLISION);
					SetLWeaponLifespan(particle,LWL_TIMER,1);
					SetLWeaponDeathEffect(particle,LWD_VANISH,0);
				}
				NoAction();
			}
			else{
				KillLWeapon(wpn);
				Link->CollDetection = true;
				RemoveLWeaponType(LW_SCRIPT2);
			}
		}
		else{
			if(Abs(wpn->Y-Link->Y+8)>0){
				if(wpn->Dir==DIR_UP)wpn->Misc[LW_ZH_I_YPOS]++;
				else if(wpn->Dir==DIR_DOWN)wpn->Misc[LW_ZH_I_YPOS]--;
				for(int i =0;i<=wpn->Misc[LW_ZH_I_MOVEMENT_ARG];i++){
					lweapon particle = FireScriptedLWeapon(LW_SCRIPT2, wpn->X, Calc(wpn->Y,Link->Y+8,wpn->Misc[LW_ZH_I_MOVEMENT_ARG]), wpn->Misc[LW_ZH_I_MOVEMENT_ARG2], 0, 0,LWF_NO_COLLISION);
					SetLWeaponLifespan(particle,LWL_TIMER,1);
					SetLWeaponDeathEffect(particle,LWD_VANISH,0);
				}
				NoAction();
			}
			else{
				KillLWeapon(wpn);
				Link->CollDetection = true;
				RemoveLWeaponType(LW_SCRIPT2);
			}
		}
	}
	SetLWeaponDir(wpn);
}

//Causes lweapon to home on given point. If "accel" boolean is set to TRUE, the function affects FFC`s
//acceleration, instead of velocity.
void __DoLWDeathReturn(lweapon wpn){
	//Calculate the X and Y center of the weapon.
	int fx = CenterX (wpn);
	int fy = CenterY (wpn);
	//Calculate angle from Link to Lweapon
	int hdir = Angle(fx, fy, CenterLinkX(),CenterLinkY());
	//Move weapon along that path towards Link.
	wpn->Misc[LW_ZH_I_XPOS]= wpn->X+ ((wpn->Step/100)*Cos(hdir));
	wpn->Misc[LW_ZH_I_YPOS]= wpn->Y+ ((wpn->Step/100)*Sin(hdir));
	wpn->X=wpn->Misc[LW_ZH_I_XPOS];
	wpn->Y=wpn->Misc[LW_ZH_I_YPOS];
	//Set the weapon to pierce if it doesn't already.
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
		wpn->Misc[LW_ZH_I_FLAGS]|=LWF_PIERCES_ENEMIES;
	//Set it not to collide with enemies.
	wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_NO_COLLISION;
	//This lweapon has reached Link. Kill it.
	if(LinkCollision(wpn))
		Remove(wpn);
	SetLWeaponDir(wpn);
}

bool __IsSolid(lweapon wpn){
	int lwx = wpn->X+wpn->HitXOffset;
	int lwy = wpn->Y+wpn->HitYOffset;
	int centerX = wpn->HitWidth/2;
	int centerY = wpn->HitHeight/2;
	return(Screen->isSolid(lwx+centerX,lwy+centerY));
}