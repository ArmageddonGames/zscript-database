//Common LW_ZH functions

// Fire an lweapon
lweapon FireLWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags)
{
    
    lweapon wpn=Screen->CreateLWeapon(weaponID);
    wpn->X=x;
    wpn->Y=y;
    wpn->Step=step;
    wpn->Damage=damage;
	if(RadtoDeg(angle)%90!=0)
		wpn->Angular=true;
    wpn->Angle=angle;
    
    if(sprite>=0)
        wpn->UseSprite(sprite);
	else
		SetDefaultSprite(wpn);
    wpn->Misc[LW_ZH_I_FLAGS]=flags|__LWFI_IS_LWZH_LWPN;
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_NORMALIZE)==0)
		SetLWeaponDir(wpn); // After flags so unblockability is detected
	if(sound>=0)
		Game->PlaySound(sound);
	else
		DefaultSound(wpn);
    return wpn;
}


// Fire an lweapon aimed based on an enemy's position
lweapon FireAimedLWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags)
{
	lweapon wpn;
	float targetAngle;
	if(Screen->NumNPCs()>0){
		if(wpn->Misc[LW_ZH_I_WORK]==0)wpn->Misc[LW_ZH_I_WORK] = Rand(1,Screen->NumNPCs());
		npc target_enemy = Screen->LoadNPC(wpn->Misc[LW_ZH_I_WORK]);
		target_enemy->Misc[NPC_MISC_TARGET_NUMBER]=wpn->Misc[LW_ZH_I_WORK];
		if(target_enemy->HP<=0)wpn->Misc[LW_ZH_I_WORK]= 0;
		if(target_enemy->Misc[NPC_MISC_TARGET_NUMBER]==wpn->Misc[LW_ZH_I_WORK]){
			targetAngle=RadianAngle(wpn->X, wpn->Y, target_enemy->X, target_enemy->Y);
			if(targetAngle<0)
				targetAngle+=6.2832;
		}
	}
    return FireLWeapon(weaponID, x, y, targetAngle+angle, step, damage, sprite, sound, flags);
}


// Fire a non-angular lweapon
lweapon FireNonAngularLWeapon(int weaponID, int x, int y, int dir, int step, int damage, int sprite, int sound, int flags)
{
    lweapon wpn=Screen->CreateLWeapon(weaponID);
    wpn->X=x;
    wpn->Y=y;
    wpn->Step=step;
    wpn->Damage=damage;
    wpn->Angular=false;
    wpn->Dir=dir;
        
    if(sprite>=0)
        wpn->UseSprite(sprite);
	else
		SetDefaultSprite(wpn);
    wpn->Misc[LW_ZH_I_FLAGS]=flags|__LWFI_IS_LWZH_LWPN;
    //if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_CAN_REFLECT)!=0)wpn->Misc[LW_ZH_I_WORK]= sprite;
    if(sound>=0)
		Game->PlaySound(sound);
	else
		DefaultSound(wpn);
    return wpn;
}


// Fire an lweapon larger than 1x1
lweapon FireBigLWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags, int width, int height)
{
    lweapon wpn= Screen->CreateLWeapon(weaponID);
    wpn->X=x;
    wpn->Y=y;
    wpn->Step=step;
    wpn->Damage=damage;
    wpn->Angular=true;
    wpn->Angle=angle;
    
    if(sprite>=0)
        wpn->UseSprite(sprite);
	else
		SetDefaultSprite(wpn);
	wpn->Misc[LW_ZH_I_FLAGS]=flags|__LWFI_IS_LWZH_LWPN;
    wpn->Extend=3;
    wpn->TileWidth=width;
    wpn->TileHeight=height;
    wpn->HitWidth=16*width;
    wpn->HitHeight=16*height;
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_NORMALIZE)==0)
		SetLWeaponDir(wpn);
	if(sound>=0)
		Game->PlaySound(sound);
	else
		DefaultSound(wpn);
    return wpn;
}


// Fire an lweapon larger than 1x1 aimed based on an enemy's position
lweapon FireBigAimedLWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags, int width, int height)
{
    lweapon wpn;
	float targetAngle;
	if(Screen->NumNPCs()>0){
		if(wpn->Misc[LW_ZH_I_WORK]==0)wpn->Misc[LW_ZH_I_WORK] = Rand(1,Screen->NumNPCs());
		npc target_enemy = Screen->LoadNPC(wpn->Misc[LW_ZH_I_WORK]);
		target_enemy->Misc[NPC_MISC_TARGET_NUMBER]=wpn->Misc[LW_ZH_I_WORK];
		if(target_enemy->HP<=0)wpn->Misc[LW_ZH_I_WORK]= 0;
		if(target_enemy->Misc[NPC_MISC_TARGET_NUMBER]==wpn->Misc[LW_ZH_I_WORK]){
			targetAngle=RadianAngle(wpn->X, wpn->Y, target_enemy->X, target_enemy->Y);
			if(targetAngle<0)
				targetAngle+=6.2832;
		}
	}
	return FireBigLWeapon(weaponID, x, y, targetAngle+angle, step, damage, sprite, sound, flags,width,height);
}


// Fire a non-angular lweapon larger than 1x1
lweapon FireBigNonAngularLweapon(int weaponID, int x, int y, int dir, int step, int damage, int sprite, int sound, int flags, int width, int height)
{
    lweapon wpn=FireNonAngularLWeapon(weaponID, x, y, dir, step, damage, sprite, sound, flags);
    wpn->Extend=3;
    wpn->TileWidth=width;
    wpn->TileHeight=height;
    wpn->HitWidth=16*width;
    wpn->HitHeight=16*height;
	return wpn;
}

//Included for compatiblilty with other scripts.

//Fires a scripted Lweapon.

//D0- Type of weapon
//D1- X coords to fire at.
//D2- Y coords to fire at.
//D3- Sprite to use.
//D4- Speed of Lweapon.
//D5- Damage Lweapon does.

lweapon FireScriptedLWeapon(int type, int X, int Y,int sprite, int Speed, int Damage,int flags){
	lweapon thing = Screen->CreateLWeapon(type);
	thing->X = X;
	thing->Y = Y;
	thing->Step = Speed;
	thing->Damage = Damage;
	if(sprite>=0)
        thing->UseSprite(sprite);
	else
		SetDefaultSprite(thing);
	thing->Dir= Link->Dir;
	if(thing->Dir == DIR_LEFTUP||thing->Dir == DIR_RIGHTUP
		||thing->Dir == DIR_LEFTDOWN||thing->Dir == DIR_RIGHTDOWN){
		if(thing->NumFrames!=0)thing->Tile+=(thing->NumFrames*2);
		else thing->Tile+=2;
		if(thing->Dir==DIR_LEFTUP)
			thing->Flip = FLIP_H;
		else if(thing->Dir==DIR_RIGHTDOWN)
			thing->Flip = FLIP_V;
		else if(thing->Dir==DIR_LEFTDOWN)
			thing->Flip = FLIP_B;
	}
	else if(thing->Dir==DIR_LEFT||thing->Dir==DIR_RIGHT){
		if(thing->NumFrames!=0)thing->Tile+=thing->NumFrames;
		else thing->Tile+=1;
		if(thing->Dir ==DIR_LEFT)thing->Flip= FLIP_H;
	}
	else{
		if(thing->Dir == DIR_DOWN)
			thing->Flip = FLIP_V;
	}
	thing->Misc[LW_ZH_I_FLAGS]=flags|__LWFI_IS_LWZH_LWPN;
	return thing;
}

lweapon FireIndependentLWeapon(int type, int X, int Y,int dir,int sprite, int Speed, int Damage,int flags){
	lweapon thing = Screen->CreateLWeapon(type);
	thing->X = X;
	thing->Y = Y;
	thing->Step = Speed;
	thing->Damage = Damage;
	if(sprite>=0)
        thing->UseSprite(sprite);
	else
		SetDefaultSprite(thing);
	thing->Dir= dir;
	if(thing->Dir == DIR_LEFTUP||thing->Dir == DIR_RIGHTUP
		||thing->Dir == DIR_LEFTDOWN||thing->Dir == DIR_RIGHTDOWN){
		if(thing->NumFrames!=0)thing->Tile+=(thing->NumFrames*2);
		else thing->Tile+=2;
		if(thing->Dir==DIR_LEFTUP)
			thing->Flip = FLIP_H;
		else if(thing->Dir==DIR_RIGHTDOWN)
			thing->Flip = FLIP_V;
		else if(thing->Dir==DIR_LEFTDOWN)
			thing->Flip = FLIP_B;
	}
	else if(thing->Dir==DIR_LEFT||thing->Dir==DIR_RIGHT){
		if(thing->NumFrames!=0)thing->Tile+=thing->NumFrames;
		else thing->Tile+=1;
		if(thing->Dir ==DIR_LEFT)thing->Flip= FLIP_H;
	}
	else{
		if(thing->Dir == DIR_DOWN)
			thing->Flip = FLIP_V;
	}
	thing->Misc[LW_ZH_I_FLAGS]=flags|__LWFI_IS_LWZH_LWPN;
	return thing;
}

// Set the weapon's direction based on its angle;

void SetLWeaponDir(lweapon wpn){
    float angle=wpn->Angle%6.2832;
    int dir;
	int tile = wpn->OriginalTile;
	int flip= wpn->Flip;
    
    if(angle<0)
        angle+=6.2832;
    if(angle<0.3927 || angle>5.8905){
		dir=DIR_RIGHT;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*wpn->TileWidth);
		else
			tile = wpn->OriginalTile+wpn->TileWidth;
	}
    else if(angle<1.1781){
		dir=DIR_RIGHTDOWN;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
		flip = FLIP_V;
	} 
    else if(angle<1.9635){
		dir=DIR_DOWN;
		if(wpn->TileWidth==1){
			if(wpn->TileHeight==1)
				flip = FLIP_V;
			else tile = wpn->OriginalTile+1;
		}
		else{
			if(wpn->TileHeight==1)
				flip = FLIP_V;
			else
				tile = wpn->OriginalTile+wpn->TileWidth;
		}
	}
    else if(angle<2.7489){
		dir=DIR_LEFTDOWN;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
		flip = FLIP_B;
	}
    else if(angle<3.5343){
		dir=DIR_LEFT;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*wpn->TileWidth);
		else
			tile = wpn->OriginalTile+wpn->TileWidth;
		if(wpn->TileWidth==1)
			flip= FLIP_H;
	}
    else if(angle<4.3197){
		dir=DIR_LEFTUP;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
		flip = FLIP_H;
	}
    else if(angle<5.1051)
        dir=DIR_UP;
    else{
		dir=DIR_RIGHTUP;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
	} 	
    wpn->Dir=dir;
	wpn->Tile = tile;
	wpn->Flip = flip;
}

// Flip the weapon's sprite to match its direction
void SetLWeaponRotation(lweapon wpn, int dir){
     float angle=wpn->Angle%6.2832;
        if(angle<0)
            angle+=6.2832;
	int tile = wpn->OriginalTile;
	int flip= wpn->Flip;
    wpn->Angular = true;
    if(angle<0)
        angle+=6.2832;
    if(angle<0.3927 || angle>5.8905){
		dir=DIR_RIGHT;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+wpn->NumFrames;
		else tile = wpn->OriginalTile+wpn->TileWidth;
	}
    else if(angle<1.1781){
		dir=DIR_RIGHTDOWN;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
		flip = FLIP_V;
	} 
    else if(angle<1.9635){
		dir=DIR_DOWN;
		if(wpn->TileWidth==1){
			if(wpn->TileHeight==1)
				flip = FLIP_V;
			else tile = wpn->OriginalTile+1;
		}
	}
    else if(angle<2.7489){
		dir=DIR_LEFTDOWN;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
		flip = FLIP_B;
	}
    else if(angle<3.5343){
		dir=DIR_LEFT;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+wpn->NumFrames;
		else tile = wpn->OriginalTile+wpn->TileWidth;
		if(wpn->TileWidth==1)
			flip= FLIP_H;
	}
    else if(angle<4.3197){
		dir=DIR_LEFTUP;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
		flip = FLIP_H;
	}
    else if(angle<5.1051)
        dir=DIR_UP;
    else{
		dir=DIR_RIGHTUP;
		if(wpn->NumFrames!=0)tile = wpn->OriginalTile+(wpn->NumFrames*2);
		else tile = wpn->OriginalTile+2;
	}   
    wpn->Dir=dir;
	wpn->Tile = tile;
	wpn->Flip = flip;
}

// Kill an lweapon, triggering any death effects

void KillLWeapon(lweapon wpn){
	if((wpn->Misc[LW_ZH_I_FLAGS]&__LWFI_IS_LWZH_LWPN)!=0){
		wpn->Misc[LW_ZH_I_FLAGS]|=__LWFI_DEAD;
		if(wpn->Misc[LW_ZH_I_ON_DEATH]==0){
			if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)!=0){
				wpn->Misc[LW_ZH_I_FLAGS]&= ~LWF_PIERCES_ENEMIES;
				wpn->DeadState = 0;
				Remove(wpn);
			}
			else
				Remove(wpn);
		}
	}
	else
		Remove(wpn);
}


//Removes a specific lweapon type.

void RemoveLWeaponType(int type){
	for(int i = Screen->NumLWeapons();i>0;i--){
		lweapon e = Screen->LoadLWeapon(i);
		if(e->ID==type)KillLWeapon(e);
	}
}

//A function to adjust an lweapon's hitbox size.
//D0- Lweapon to adjust
//D1- HitWidth
//D2- HitHeight
//D3- HitXOffset
//D4- HitYOffset

void SetLWeaponHitbox(lweapon wpn, int HitWidth, int HitHeight, int HitXOffset, int HitYOffset){
	wpn->HitHeight = HitHeight;
	wpn->HitWidth = HitWidth;
	wpn->HitXOffset = HitXOffset;
	wpn->HitYOffset = HitYOffset;
}

//A function to quickly change the size of an lweapon.
//D0- Lweapon to adjust.
//D1- Tile Width
//D2- Tile Height

void SetLWeaponSize(lweapon wpn, int TileWidth, int TileHeight){
	wpn->Extend = 3;
	wpn->TileHeight = TileHeight;
	wpn->TileWidth = TileWidth;
}

//Find a previously saved lweapon.

lweapon FindMiscLWeapon(int Weapon_ID){
	lweapon wpn;
	for(int i= Screen->NumLWeapons();i>0;i--){
		wpn = Screen->LoadLWeapon(i);
		//This is the right lweapon.
		if(wpn->Misc[LW_ZH_I_WORK_3]==Weapon_ID)
			return wpn;
	}
}

//Finds an lweapon of a certain type.

lweapon FindLWeaponType(int type){
	for(int i = Screen->NumLWeapons();i>0;i--){
		lweapon e = Screen->LoadLWeapon(i);
		if(e->ID==type)return e;
	}
}

//Default Settings for weapon sprites.

void SetDefaultSprite(lweapon wpn){
	if(wpn->ID ==LW_FIRE)
		wpn->UseSprite(SPR_FIRE);
	else if(wpn->ID == LW_MAGIC)
		wpn->UseSprite(SPR_MAGIC);
	else if(wpn->ID==LW_BEAM){
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_4)!=0)
			wpn->UseSprite(SPR_BEAM4);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)
			wpn->UseSprite(SPR_BEAM3);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)
			wpn->UseSprite(SPR_BEAM2);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)
			wpn->UseSprite(SPR_BEAM1);	
	}
	else if(wpn->ID==LW_BRANG){
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)
			wpn->UseSprite(SPR_BRANG3);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)
			wpn->UseSprite(SPR_BRANG2);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)
			wpn->UseSprite(SPR_BRANG1);	
	}
	else if(wpn->ID==LW_ARROW){
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)
			wpn->UseSprite(SPR_ARROW3);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)
			wpn->UseSprite(SPR_ARROW2);
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)
			wpn->UseSprite(SPR_ARROW1);	
	}
	else
		wpn->UseSprite(0);
}

//Default settings for weapon sounds.

void DefaultSound(lweapon wpn){
	if(wpn->ID ==LW_FIRE)
		Game->PlaySound(SFX_FIRE);
	else if(wpn->ID == LW_MAGIC)
		Game->PlaySound(SFX_WAND);
	else if(wpn->ID==LW_BEAM)
		Game->PlaySound(SFX_BEAM);
	else if(wpn->ID==LW_BRANG)
		Game->PlaySound(SFX_BRANG);
	else if(wpn->ID==LW_ARROW)
		Game->PlaySound(SFX_ARROW);
	else
		Game->PlaySound(0);
}

void SetLWeaponFlag(lweapon wpn, int flag){
	if((wpn->Misc[LW_ZH_I_FLAGS]&flag)==0)
		wpn->Misc[LW_ZH_I_FLAGS]|=flag;
}

void UnSetLWeaponFlag(lweapon wpn, int flag){
	if((wpn->Misc[LW_ZH_I_FLAGS]&flag)!=0)
		wpn->Misc[LW_ZH_I_FLAGS]&=~flag;
}

void SetLWeaponFlag2(lweapon wpn, int flag){
	if((wpn->Misc[LW_ZH_I_FLAGS_2]&flag)==0)
		wpn->Misc[LW_ZH_I_FLAGS_2]|=flag;
}

void UnSetLWeaponFlag2(lweapon wpn, int flag){
	if((wpn->Misc[LW_ZH_I_FLAGS_2]&flag)!=0)
		wpn->Misc[LW_ZH_I_FLAGS_2]&=~flag;
}

bool GetLWeaponFlag(lweapon wpn, int flag){
	return((wpn->Misc[LW_ZH_I_FLAGS]&flag)!=0);
}

bool GetLWeaponFlag2(lweapon wpn, int flag){
	return((wpn->Misc[LW_ZH_I_FLAGS_2]&flag)!=0);
}