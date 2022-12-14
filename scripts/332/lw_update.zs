//LW_ZH Update functions.

//Fixes Link's collision detection if it needs it.

void UpdateLWZH1(){
	__ReflectedFix1();
}

void __ReflectedFix1(){
	 for(int i=Screen->NumLWeapons(); i>0; i--){
		lweapon wpn=Screen->LoadLWeapon(i);
		if(!GetLWeaponFlag2(wpn,LWF_NO_COLLISION)){
			// If this is a dummy, or if it's not a ghost.zh weapon, don't do anything
			if((wpn->Misc[LW_ZH_I_FLAGS]&__LWFI_IS_LWZH_LWPN)==0)
				continue;
			if(wpn->ID== LW_REFMAGIC||
				wpn->ID== LW_REFFIREBALL||
				wpn->ID== LW_REFROCK||
				wpn->ID== LW_REFBEAM){
				if(LinkCollision(wpn))
					wpn->CollDetection = false;
				else
					wpn->CollDetection = true;
				
			}
		}
    }
}

// Calls UpdateLWeapon() on every eweapon on the screen

void UpdateLWZH2(){
    lweapon wpn;
    
    for(int i=Screen->NumLWeapons(); i>0; i--){
		wpn=Screen->LoadLWeapon(i);
		
		// If this is a dummy, or if it's not a ghost.zh weapon, don't do anything
		if((wpn->Misc[LW_ZH_I_FLAGS]&__LWFI_IS_LWZH_LWPN)==0)
			continue;
	
		UpdateLWZH(wpn);
		__ReflectedFix2(wpn);
    }
}

void __ReflectedFix2(lweapon wpn){
	if(!GetLWeaponFlag2(wpn,LWF_NO_COLLISION)){
		if(wpn->ID== LW_REFMAGIC||
			wpn->ID== LW_REFFIREBALL||
			wpn->ID== LW_REFROCK||
			wpn->ID== LW_REFBEAM){
			if(LinkCollision(wpn))
				wpn->CollDetection = false;
			else
				wpn->CollDetection = true;
		}
	}
}

//Updates fancy lweapon movement stuff.

// Update a weapon's movement, lifespan, and death effects
void UpdateLWZH(lweapon wpn){
	
    // Is the weapon still active?
    if((wpn->Misc[LW_ZH_I_FLAGS]&__LWFI_DEAD )==0){
        // Start movement updates
        if(wpn->Misc[LW_ZH_I_MOVEMENT]!=0){
			if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_SINE_WAVE)
				__UpdateLWMSineWave(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOMING)
				__UpdateLWMHoming(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_THROW)
				__UpdateLWMThrow(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_FALL)
				__UpdateLWMFall(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_CIRCLE)
				__UpdateLWM_Circle(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG)
				__UpdateLWM_BRang(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_MELEE)
				__UpdateLWM_Melee(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_CARRY)
				__UpdateLWM_Carry(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_ARC)
				__UpdateLWM_Arc(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_FULL_SCREEN)
				__UpdateLWM_FullScreen(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_STRAFE)
				__UpdateLWM_Strafe(wpn);
			else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_CAROM)
				__Update_LWM_Carom(wpn);
        } // End movement updates
        
        // Start lifespan updates
        if(wpn->Misc[LW_ZH_I_LIFESPAN]!=0)
        {
			if(wpn->Misc[LW_ZH_I_LIFESPAN]==LWL_TIMER){
				wpn->Misc[LW_ZH_I_LIFESPAN_ARG]-=1;
				if(wpn->Misc[LW_ZH_I_LIFESPAN_ARG]<=0)
				   KillLWeapon(wpn);
			}
			else if(wpn->Misc[LW_ZH_I_LIFESPAN]==LWL_SOLID){
				if(__IsSolid(wpn)){
					if(wpn->Misc[LW_ZH_I_LIFESPAN_ARG]!=0
						&& !ComboTAtWpn(wpn,wpn->Misc[LW_ZH_I_LIFESPAN_ARG]))
					KillLWeapon(wpn);
				}
			}
           	else if(wpn->Misc[LW_ZH_I_LIFESPAN]==LWL_MP_COST){
				if(wpn->Misc[LW_ZH_I_LIFESPAN_ARG]>0){
					if(Game->Generic[GEN_MAGICDRAINRATE]==0)
						wpn->Misc[LW_ZH_I_WORK_3]= (wpn->Misc[LW_ZH_I_WORK_3]+1)%wpn->Misc[LW_ZH_I_LIFESPAN_ARG];
					else
						wpn->Misc[LW_ZH_I_WORK_3]= (wpn->Misc[LW_ZH_I_WORK_3]+1)
													%(wpn->Misc[LW_ZH_I_LIFESPAN_ARG]*2);
					if(wpn->Misc[LW_ZH_I_WORK_3]==0 && Link->MP>0)
						Link->MP--;
					if(Link->MP<=0){
						KillLWeapon(wpn);
						Link->MP =0;
					}
				}
				else{
					if(Link->MP<=0){
						KillLWeapon(wpn);
						Link->MP =0;
					}
				}
			}
			else if(wpn->Misc[LW_ZH_I_LIFESPAN]==LWL_EDGE){
				if(OnScreenEdge(wpn)){
					if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG)
						wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
					else
						KillLWeapon(wpn);
				}	
			}
        } // End lifespan updates
		
		if(wpn->Misc[LW_ZH_I_FX]>0)
			__UpdateLWE_Sound(wpn);
		
		//LWeapon flags, level 2
	
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_NO_COLLISION)!=0)
			__UpdateLWF_Collision(wpn);
		//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_HS_GRAB)!=0)
			//__HookshotPull(wpn);	
		//if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_LINK_FROZEN)!=0)
			//__UpdateLWF_Link_FreezeOn();
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_KNOCKBACK_OFF)!=0)
			__UpdateLWF_Knockback();
		if(GetLWeaponFlag2(wpn,LWF_SHADOW))
			__DrawLWeaponShadow(wpn);
		if(GetLWeaponFlag2(wpn,LWF_FIRE_BRINGER))
			__UpdateLWF_Burning(wpn);
		if(GetLWeaponFlag2(wpn,LWF_FREEZE_WATER))
			__UpdateLWF_Ice_Sheet(wpn);
		__UpdateLWE_BlockFlags(wpn);
	    __NPCCollision(wpn);
		__FlagTrigger(wpn);
    }
	
    // Start death effects
    else if(wpn->Misc[LW_ZH_I_ON_DEATH]!=0 && (wpn->Misc[LW_ZH_I_FLAGS]&__LWFI_DEATH_EFFECT_DONE)==0)
    {
		//LWeapon flags, level 2
		
		if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)!=0)
			wpn->Misc[LW_ZH_I_FLAGS]&= ~LWF_PIERCES_ENEMIES;	
        if(wpn->Misc[LW_ZH_I_ON_DEATH]<9){
            if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_VANISH)
                wpn->DeadState=0;
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_AIM_AT_NPC)
                __DoLWeaponDeathAimAtNPC(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_EXPLODE)
                __DoLWeaponDeathExplode(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_SBOMB_EXPLODE)
                __DoLWeaponDeathSBombExplode(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_4_FIREBALLS_HV)
                __DoLWeaponDeath4FireballsHV(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_4_FIREBALLS_DIAG)
                __DoLWeaponDeath4FireballsDiag(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_4_FIREBALLS_RANDOM)
                __DoLWeaponDeath4FireballsRand(wpn);
			else if(wpn->Misc[LW_ZH_I_ON_DEATH]==EWD_8_FIREBALLS)
                __DoLWeaponDeath8Fireballs(wpn);	
        }
        else // wpn->Misc[LW_ZH_I_ON_DEATH]>=8
        {
			if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_4_FIRES_HV)
                __DoLWeaponDeath4FiresHV(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_4_FIRES_DIAG)
                __DoLWeaponDeath4FiresDiag(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_4_FIRES_RANDOM)
                __DoLWeaponDeath4FiresRand(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_8_FIRES)
                __DoLWeaponDeath8Fires(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_FIRE)
                __DoLWeaponDeathSingleFire(wpn);
			else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_SHAKES_SCREEN)
				__DoLWeaponDeathShaky(wpn);
			else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_EXP_SHAKE)
                __DoLWDeathExplodeShake(wpn);
            else if(wpn->Misc[LW_ZH_I_ON_DEATH]==LWD_SBOMB_SHAKE)
                __DoLWDeathSBombShake(wpn);	
			else 
				__DoLWDeathReturn(wpn);	
		}
			
    } // End death effects
	
	//LWeapon flags, level 1

    if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_ITEM_PICKUP)!=0)
		__UpdateLWF_Pickup(wpn);
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)!=0)
		__UpdateLWF_Pierce(wpn);
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_STUNS_ENEMIES)!=0)
		__UpdateLWF_Stun(wpn);
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_LINK_FLOATS)!=0)
		__UpdateLWF_Float();
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_ZERO_G)!=0)
		__UpdateLWF_G_Force(wpn);
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_DETONATE)!=0)
		__UpdateLWF_BombPower(wpn);	
	//if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_POISON)!=0)
		//__UpdateLWF_Poison(wpn);
}

void __UpdateLWM_Strafe(lweapon wpn){
	int dir = wpn->Misc[LW_ZH_I_MOVEMENT_ARG];
	Link->Dir= dir;
	wpn->X = Link->X+InFrontX(Link->Dir,2);
	wpn->Y = Link->Y+InFrontY(Link->Dir,2);
	__UpdateShield(wpn);
}

const int ICE_WALK_COMBO= 6937;
const int ICE_BLOCK_CSET= 7;

void __UpdateLWF_Ice_Sheet(lweapon wpn){
	int loc = ComboAt(wpn->X+8,wpn->Y+8);
	if(IsWater(loc)){
		if(Screen->ComboF[loc]==CF_SCRIPT1
			&& !Is_ScriptedWater(loc))
			//Change the combo tp walkable, type none. Done to keep block from destroying the floor.
			ChangeCombo(loc,ICE_WALK_COMBO,ICE_BLOCK_CSET,CT_NONE);
	}					
}

void __UpdateLWF_Burning(lweapon wpn){
	int loc = ComboAt(wpn->X+8,wpn->Y+8);		
	if(GetLWeaponFlag2(wpn,LWF_LEVEL_1)){
		if(Screen->ComboF[loc]==CF_CANDLE1){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}	
	}
	else if(GetLWeaponFlag2(wpn,LWF_LEVEL_2)){
		if(Screen->ComboF[loc]==CF_CANDLE1){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}	
		if(Screen->ComboF[loc]==CF_CANDLE2){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}
	}	
	else if(GetLWeaponFlag2(wpn,LWF_LEVEL_3)){
		if(Screen->ComboF[loc]==CF_CANDLE1){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}	
		if(Screen->ComboF[loc]==CF_CANDLE2){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}
		if(Screen->ComboF[loc]==CF_WANDFIRE){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}
	}
	else if(GetLWeaponFlag2(wpn,LWF_LEVEL_4)){
		if(Screen->ComboF[loc]==CF_CANDLE1){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}	
		if(Screen->ComboF[loc]==CF_CANDLE2){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}
		if(Screen->ComboF[loc]==CF_WANDFIRE){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}
		if(Screen->ComboF[loc]==CF_DINSFIRE){
			Screen->ComboD[loc]++;
			Screen->ComboF[loc]=0;
		}
	}
}

void __UpdateLWF_BombPower(lweapon wpn){
	int loc = ComboAt(wpn->X+8,wpn->Y+8);
	if(wpn->Misc[LW_ZH_I_FLAGS_2]==LWF_LEVEL_1){
		if(Screen->ComboF[loc]==CF_BOMB)
			__DoLWeaponDeathExplode(wpn);
	}
	else if(wpn->Misc[LW_ZH_I_FLAGS_2]==LWF_LEVEL_2){
		if(Screen->ComboF[loc]==CF_BOMB)
			__DoLWeaponDeathExplode(wpn);
		if(Screen->ComboF[loc]==CF_SBOMB)
			__DoLWeaponDeathSBombExplode(wpn);	
	}
}

void __UpdateShield(lweapon wpn){
	for(int i = Screen->NumEWeapons();i>0;i--){
		eweapon wpn2 = Screen->LoadEWeapon(i);
		if(WeaponCollision(wpn,wpn2)){
			if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_ALL)!=0){
				Remove(wpn2);
				Game->PlaySound(SFX_CLINK);
			}
			else{
				if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_FIREBALL)!=0
						&& wpn2->ID==EW_FIREBALL){
					Remove(wpn2);
					Game->PlaySound(SFX_CLINK);
				}
				if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_ARROW)!=0
							&& wpn2->ID==EW_ARROW){
					Remove(wpn2);
					Game->PlaySound(SFX_CLINK);
				}	
				if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_BEAM)!=0
							&& wpn2->ID==EW_BEAM){
					Remove(wpn2);
					Game->PlaySound(SFX_CLINK);
				}
				if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_BRANG)!=0
							&& wpn2->ID==EW_BRANG){
					Remove(wpn2);
					Game->PlaySound(SFX_CLINK);
				}
				if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_MAGIC)!=0
							&& wpn2->ID==EW_MAGIC){
					Remove(wpn2);
					Game->PlaySound(SFX_CLINK);
				}
				if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWSF_ROCK)!=0
							&& wpn2->ID==EW_ROCK){
					Remove(wpn2);
					Game->PlaySound(SFX_CLINK);
				}	
			}
		}
	}
}

void __UpdateLWMF_Reflect_EWpn(lweapon wpn){
	eweapon EWpn;
	for(int i = Screen->NumEWeapons();i>0;i--){
		EWpn= Screen->LoadEWeapon(i);
		if(EWpn->ID==EW_MAGIC||EWpn->ID==EW_FIREBALL
			||EWpn->ID==EW_BEAM||EWpn->ID==EW_ROCK){
			if(WeaponCollision(wpn,EWpn))
				lweapon bounce = FireReflectedLWeapon(EWpn);
		}
	}
}

// Fire an lweapon
lweapon FireReflectedLWeapon(eweapon EWpn){
    lweapon wpn;
	if(EWpn->ID==EW_BEAM)
		wpn= Screen->CreateLWeapon(LW_REFBEAM);
	else if(EWpn->ID==EW_MAGIC)
		wpn= Screen->CreateLWeapon(LW_REFMAGIC);
	else if(EWpn->ID==EW_ROCK)
		wpn= Screen->CreateLWeapon(LW_REFROCK);
	else if(EWpn->ID==EW_FIREBALL)
		wpn= Screen->CreateLWeapon(LW_REFFIREBALL);	
    wpn->X=EWpn->X;
    wpn->Y=EWpn->Y;
    wpn->Step=EWpn->Step;
    wpn->Damage=EWpn->Damage;
    wpn->Angular=true;
	wpn->Dir = OppositeDir(EWpn->Dir);
	wpn->Angle= __DirtoRad(wpn->Dir);
    __CopySprite(wpn,EWpn,true);
    wpn->Misc[LW_ZH_I_FLAGS]|=__LWFI_IS_LWZH_LWPN;
    return wpn;
}



void __CopySprite(lweapon b, eweapon a,bool Flipped){
	b->Z = a->Z;
	b->Jump = a->Jump;
	b->HitWidth = a->HitWidth;
	b->HitHeight = a->HitHeight;
	b->HitZHeight = a->HitZHeight;
	b->HitXOffset = a->HitXOffset;
	b->HitYOffset = a->HitYOffset;
	b->DrawXOffset = a->DrawXOffset;
	b->DrawYOffset = a->DrawYOffset;
	b->DrawZOffset = a->DrawZOffset;
	b->Tile = a->Tile;
	b->CSet = a->CSet;
	b->DrawStyle = a->DrawStyle;
	b->OriginalTile = a->OriginalTile;
	b->OriginalCSet = a->OriginalCSet;
	b->FlashCSet = a->FlashCSet;
	b->NumFrames = a->NumFrames;
	b->Frame = a->Frame;
	b->ASpeed = a->ASpeed;
	if(Flipped){
		if(a->Dir==DIR_LEFT
			||a->Dir==DIR_RIGHT){
			if(a->Flip==FLIP_NO)
				b->Flip = FLIP_H;
			else
				b->Flip = FLIP_NO;
		}
		else
			b->Flip = FLIP_V;
	}
	else
		b->Flip = a->Flip;
	Remove(a);
}

//Handles LWeapons that continuously make sounds.

void __UpdateLWE_Sound(lweapon wpn){
	if(wpn->Misc[LW_ZH_I_WORK_2]>0){
		wpn->Misc[LW_ZH_I_WORK]=(wpn->Misc[LW_ZH_I_WORK]+1)%wpn->Misc[LW_ZH_I_WORK_2];
		if(wpn->Misc[LW_ZH_I_WORK]==0)Game->PlaySound(wpn->Misc[LW_ZH_I_FX]);
	}
}

void __UpdateLWM_FullScreen(lweapon wpn){
	if (IsOdd(wpn->Misc[LW_ZH_I_LIFESPAN_ARG])
		&& wpn->Misc[LW_ZH_I_MOVEMENT_ARG]>0) 
		Screen->Rectangle(7, 0, 0, 256, 176, 
							wpn->Misc[LW_ZH_I_MOVEMENT_ARG], 1, 
							0, 0, 0, true, wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]);
}

//Makes FFC bounce off solid combos. Don`t call it too often. Otherwise Lweapon can be stuck in a wall.
void __Update_LWM_Carom(lweapon lw){
	bool bounce = false;
	int Sound = lw->Misc[LW_ZH_I_FX]*-1;
	int lwx = lw->X + lw->HitXOffset;
	int lwy = lw->Y + lw->HitYOffset;
	if (Screen->isSolid(lwx+lw->HitWidth/2, lwy)) {
		lw->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx+lw->HitWidth/2, lwy+lw->HitHeight)) {
		lw->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx, lwy+lw->HitHeight/2)) {
		lw->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx+lw->HitWidth, lwy+lw->HitHeight/2)) {
		lw->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx, lwy)
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG] < 0 
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG2] <0){
		lw->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		lw->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx, lwy+lw->HitHeight)
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG] < 0
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG2] > 0){
		lw->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		lw->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx+lw->HitWidth, lwy+lw->HitHeight)
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG] > 0 
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG2] >0){
		lw->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		lw->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		bounce = true;
	}
	if (Screen->isSolid(lwx+lw->HitWidth, lwy)
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG] > 0 
		&& lw->Misc[LW_ZH_I_MOVEMENT_ARG2] <0){
		lw->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		lw->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		bounce = true;
	}
	if (bounce)
		Game->PlaySound(Sound);
	lw->X+=lw->Misc[LW_ZH_I_MOVEMENT_ARG];
	lw->Y+=lw->Misc[LW_ZH_I_MOVEMENT_ARG2];
}

//Handles lweapon that's blocked by a combo.

void __UpdateLWE_BlockFlags(lweapon wpn){
	if(ComboTAtWpn(wpn)==LWBlockType(wpn)||(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT 
		&& ComboTAtWpn(wpn)!=CT_HOOKSHOTONLY && ComboTAtWpn(wpn)!=CT_LADDERHOOKSHOT)){
		if(wpn->Misc[LW_ZH_I_MOVEMENT]!=LWM_BRANG && wpn->Misc[LW_ZH_I_MOVEMENT]!=LWM_HOOKSHOT){
			KillLWeapon(wpn);
			Game->PlaySound(SFX_CLINK);
		}
		else{
			//if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT && ComboTAtWpn(wpn)==CT_HSGRAB)
			   //wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_HS_GRAB;
			//else
				wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
		}		
	}
}

//void __UpdateLWM_Dual(lweapon wpn){
	//if(ComboTAtWpn(wpn)==LWBlockType(wpn->Misc[LW_ZH_I_MOVEMENT_ARG],wpn)
		//||ComboTAtWpn(wpn)==LWBlockType(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2],wpn)){
		//KillLWeapon(wpn);
		//Game->PlaySound(SFX_CLINK);	
	//}
	//bool trigger = false;
	//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_ARROW
		//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_ARROW){
		//if(ComboFIAtWpn(wpn,CF_ARROW)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		//}
		//if(ComboFIAtWpn(wpn,CF_ARROW2)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		//}
		//if(ComboFIAtWpn(wpn,CF_ARROW3)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)trigger = true;
		//}
	//}
	//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_BOMBBLAST
			//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_BOMBBLAST){
		//if(ComboFIAtWpn(wpn,CF_BOMB))trigger = true;
	//}
	//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_SBOMBBLAST
			//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_SBOMBBLAST){
		//if(ComboFIAtWpn(wpn,CF_SBOMB))trigger = true;
	//}
	//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_FIRE
			//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_FIRE){
		//if(ComboFIAtWpn(wpn,CF_CANDLE1)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		//}
		//if(ComboFIAtWpn(wpn,CF_CANDLE2)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		//}
	//}
	//if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_MAGIC
			//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_MAGIC)
			///&& ComboFIAtWpn(wpn,CF_WANDMAGIC)
			//&& (wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_IS_REFLECTED)==0)trigger = true;
	//if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_MAGIC
			//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_MAGIC)
			//&& ComboFIAtWpn(wpn,CF_REFMAGIC)
			//&& (wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_IS_REFLECTED)!=0)trigger = true;
	//else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_MELEE){
		//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_IS_SWORD){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)return CF_SWORD1;
			//else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)return CF_SWORD2;
			//else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)return CF_SWORD3;
			//else
				//return CF_SWORD4;
		//}
		//else if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_IS_HAMMER)
			//return CF_HAMMER;
		//else if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_IS_WAND)
			//return CF_WAND;
	//}
	//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_BEAM
			//||wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]==LW_BEAM){
		//if(ComboFIAtWpn(wpn,CF_SWORD1BEAM)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		//}
		//if(ComboFIAtWpn(wpn,CF_SWORD2BEAM)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		//}
		//if(ComboFIAtWpn(wpn,CF_SWORD3BEAM)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)trigger = true;
		//}
		//if(ComboFIAtWpn(wpn,CF_SWORD4BEAM)){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_4)!=0)trigger = true;
		//}
	//}
	//else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT)
		//return CF_HOOKSHOT;
	//if(trigger){
		//KillLWeapon(wpn);
		//Screen->TriggerSecrets();
		//Screen->State[ST_SECRET] = true;
		//Game->PlaySound(SFX_SECRET);
	//}
//}

//Handles lweapons that move in a sine wave.

void __UpdateLWMSineWave(lweapon wpn){
		float offset;
		wpn->Misc[LW_ZH_I_WORK]+=wpn->Misc[LW_ZH_I_MOVEMENT_ARG2];
		
		// Adjust the weapon's position at an angle
		// perpendicular to that of its forward movement.
		offset=wpn->Misc[LW_ZH_I_MOVEMENT_ARG]*Sin(wpn->Misc[LW_ZH_I_WORK]);
		wpn->Misc[LW_ZH_I_XPOS]+=(wpn->Step/100)*RadianCos(wpn->Angle);
		wpn->Misc[LW_ZH_I_YPOS]+=(wpn->Step/100)*RadianSin(wpn->Angle);
		wpn->X=wpn->Misc[LW_ZH_I_XPOS]+offset*RadianCos(wpn->Angle+1.5708);
		wpn->Y=wpn->Misc[LW_ZH_I_YPOS]+offset*RadianSin(wpn->Angle+1.5708);
}

//Handles homing lweapons.

void __UpdateLWMHoming(lweapon wpn){
    // Wrap angle to 0..2*PI
    float currentAngle=wpn->Angle%6.2832;

    if(currentAngle<0)
        currentAngle+=6.2832;
	npc target_enemy;
	int target_number;
	// Find angle to Link and wrap it
	if(Screen->NumNPCs()>0){
		if(wpn->Misc[LW_ZH_I_WORK]==0)wpn->Misc[LW_ZH_I_WORK] = Rand(1,Screen->NumNPCs());
		for(int i=Screen->NumNPCs();i>0;i--){
			target_enemy = Screen->LoadNPC(i);
			if(i==wpn->Misc[LW_ZH_I_WORK]
				&& target_enemy->Type!=NPCT_GUY 
				&& target_enemy->Type!=NPCT_FAIRY
				&& target_enemy->Type!=NPCT_ROCK
				&& target_enemy->Type!=NPCT_PROJECTILE
				&& (target_enemy->Defense[LWDefense(wpn->ID)]!=NPCDT_BLOCK||
				target_enemy->Defense[LWDefense(wpn->ID)]!=NPCDT_IGNORE))
				target_enemy->Misc[NPC_MISC_TARGET_NUMBER]=wpn->Misc[LW_ZH_I_WORK];
		}
		if(target_enemy->HP<=0)wpn->Misc[LW_ZH_I_WORK]=0;
		if(target_enemy->Misc[NPC_MISC_TARGET_NUMBER]==wpn->Misc[LW_ZH_I_WORK]){
			float targetAngle=RadianAngle(wpn->X, wpn->Y, target_enemy->X, target_enemy->Y);
			if(targetAngle<0)
				targetAngle+=6.2832;

			float diff=Abs(currentAngle-targetAngle);

			// Turn toward Link
			if(diff<wpn->Misc[LW_ZH_I_MOVEMENT_ARG] || diff>6.2832-wpn->Misc[LW_ZH_I_MOVEMENT_ARG])
				wpn->Angle=targetAngle;
			
			// Can't turn enough to point directly at him...
			else if(Sign(currentAngle-targetAngle)==Sign(diff-PI)) // current>target and diff>pi or
				wpn->Angle+=wpn->Misc[LW_ZH_I_MOVEMENT_ARG];         // current<target and diff<pi
			else                                                   // - Turn CW or CCW?
				wpn->Angle-=wpn->Misc[LW_ZH_I_MOVEMENT_ARG];

			SetLWeaponDir(wpn);
			
			// Decrement timer, unless it was negative to begin with
			if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]>0){
				wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]--;
				if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]<=0)
					Remove(wpn);
			}
		}
	}
	
}

//Handles Lweapons thrown in an arc.

void __UpdateLWMThrow(lweapon wpn)
{
    // LW_ZH_I_WORK: Current jump
    // LW_ZH_I_WORK_2: Current Z position
    // LW_ZH_I_MOVEMENT_ARG: Initial jump
    wpn->Jump=0; // Override engine handling of Z movement
    
    // Just thrown
    if(wpn->Misc[LW_ZH_I_WORK]==0 && wpn->Misc[LW_ZH_I_MOVEMENT_ARG]!=0)
    {
        wpn->Misc[LW_ZH_I_WORK]=wpn->Misc[LW_ZH_I_MOVEMENT_ARG];
        wpn->Misc[LW_ZH_I_MOVEMENT_ARG]=0;
    }
    
    // Fall
    wpn->Misc[LW_ZH_I_WORK_2]=Max(wpn->Misc[LW_ZH_I_WORK_2]+wpn->Misc[LW_ZH_I_WORK], 0);
	if(!IsSideview())
		wpn->Z=wpn->Misc[LW_ZH_I_WORK_2];
    else
		wpn->Y = 176-wpn->Misc[LW_ZH_I_WORK_2];
	if(wpn->Misc[LW_ZH_I_WORK_2]>0 &&
		!__OnSidePlatform(wpn->X, wpn->Y, 
							wpn->HitXOffset,
							wpn->HitYOffset, 
							wpn->HitHeight,wpn->HitWidth)) // Z>0
			wpn->Misc[LW_ZH_I_WORK]=Max(wpn->Misc[LW_ZH_I_WORK]-GH_GRAVITY, -GH_TERMINAL_VELOCITY);
	else{
		bool done=false;
        
        // Bounce
        if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_BOUNCE)!=0){
			// Falling fast enough?
			if(wpn->Misc[LW_ZH_I_WORK]<-0.5){ // Jump<=-0.5
				wpn->Misc[LW_ZH_I_WORK]*=-0.5;
				wpn->Step*=0.75;
			}
			// Not fast enough
			else
				done=true;
        }
        // Don't bounce
        else
            done=true;
        
        // Movement ended; stop or die?
        if(done){
            if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_DIE)!=0){
                wpn->Z=0;
                KillLWeapon(wpn);
            }
            else{
                wpn->Misc[LW_ZH_I_MOVEMENT]=0;
                wpn->Step=0;
            }
        }
	}
}

//Handles Lweapons that fall from the sky.

void __UpdateLWMFall(lweapon wpn)
{
	wpn->Jump=0; // Override engine handling of Z movement
    wpn->Misc[LW_ZH_I_WORK_2]-=wpn->Misc[LW_ZH_I_WORK];
    if(!IsSideview())
		wpn->Z=wpn->Misc[LW_ZH_I_WORK_2];
    else{
		wpn->DrawYOffset=wpn->Misc[LW_ZH_I_WORK_2];
		wpn->HitYOffset =wpn->Misc[LW_ZH_I_WORK_2];
	}
    wpn->Misc[LW_ZH_I_WORK]=Min(wpn->Misc[LW_ZH_I_WORK]+GH_GRAVITY, GH_TERMINAL_VELOCITY);
	// Hit the ground
    // Still in the air; adjust velocity

    if(wpn->Misc[LW_ZH_I_WORK_2]>0
		&& !__OnSidePlatform(wpn->X, wpn->Y, 
							wpn->HitXOffset,
							wpn->HitYOffset, 
							wpn->HitHeight,wpn->HitWidth))// Z>0
			wpn->Misc[LW_ZH_I_WORK]=Max(wpn->Misc[LW_ZH_I_WORK]-GH_GRAVITY, -GH_TERMINAL_VELOCITY);
	else{
		bool done=false;
        
        // Bounce
        if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_BOUNCE)!=0){
           // Falling fast enough?
			if(wpn->Misc[LW_ZH_I_WORK]<-0.5){ // Jump<=-0.5
				wpn->Misc[LW_ZH_I_WORK]*=-0.5;
				wpn->Step*=0.75;
			}
			// Not fast enough
			else
				done=true;
        }
        // Don't bounce
        else
            done=true;
        
        // Movement ended; stop or die?
        if(done){
            if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_DIE)!=0){
                wpn->Z=0;
                KillLWeapon(wpn);
            }
            else{
                wpn->Misc[LW_ZH_I_MOVEMENT]=0;
                wpn->Step=0;
            }
        }
	}
}

//Handles Lweapons that circle Link.

void __UpdateLWM_Circle(lweapon wpn){
	
	//if(wpn->Misc[LW_ZH_I_XPOS]==0 && wpn->HitXOffset!=0)
			//wpn->Misc[LW_ZH_I_XPOS]= wpn->HitXOffset;
	//if(wpn->Misc[LW_ZH_I_YPOS]== 0 && wpn->HitYOffset!=0)
		//wpn->Misc[LW_ZH_I_YPOS]= wpn->HitYOffset;	
	wpn->Misc[LW_ZH_I_WORK]= (wpn->Misc[LW_ZH_I_WORK]
								+((wpn->Step/100)*wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]))%360;
	wpn->HitXOffset = //wpn->Misc[LW_ZH_I_XPOS]+
						VectorX(wpn->Misc[LW_ZH_I_MOVEMENT_ARG],wpn->Misc[LW_ZH_I_WORK]);//)-(Link->X+8);
	wpn->HitYOffset = //wpn->Misc[LW_ZH_I_YPOS]+
						VectorY(wpn->Misc[LW_ZH_I_MOVEMENT_ARG],wpn->Misc[LW_ZH_I_WORK]);//)-(Link->Y+8);
	
	wpn->Angle = DegtoRad(wpn->Misc[LW_ZH_I_WORK]);
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_NORMALIZE)==0)
		SetLWeaponDir(wpn);
	wpn->X=Link->X;
	wpn->Y=Link->Y;							
	wpn->DrawXOffset= wpn->HitXOffset;
	wpn->DrawYOffset= wpn->HitYOffset;
}

//Handles Lweapons that act like the hookshot.

//void __UpdateLWM_Hookshot(lweapon wpn){
	//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_RETURN)==0 
	    //&&(wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_HS_GRAB)==0){
		//if(wpn->Dir==DIR_LEFT||wpn->Dir==DIR_RIGHT){
			//if(Abs(wpn->X-Link->X+8)<=(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]*16)){
				//if(wpn->Dir==DIR_LEFT)wpn->Misc[LW_ZH_I_XPOS]--;
				//else if(wpn->Dir==DIR_RIGHT)wpn->Misc[LW_ZH_I_XPOS]++;
				//for(int i =0;i<=wpn->Misc[LW_ZH_I_MOVEMENT_ARG];i++){
					//lweapon particle = FireScriptedLWeapon(LW_SCRIPT1, Calc(wpn->X,Link->X+8,wpn->Misc[LW_ZH_I_MOVEMENT_ARG]), 
															//wpn->Y, wpn->Misc[LW_ZH_I_MOVEMENT_ARG2], 0, 0,LWF_NO_COLLISION);
					//SetLWeaponLifespan(particle,LWL_TIMER,1);
					//SetLWeaponDeathEffect(particle,LWD_VANISH,0);
				//}
			//}
			//else
				//wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
		//}
		//else{
			//if(Abs(wpn->Y-Link->Y+8)<=(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]*16)){
				//if(wpn->Dir==DIR_UP)wpn->Misc[LW_ZH_I_YPOS]--;
				//else if(wpn->Dir==DIR_DOWN)wpn->Misc[LW_ZH_I_YPOS]++;
				//for(int i =0;i<=wpn->Misc[LW_ZH_I_MOVEMENT_ARG];i++){
					//lweapon particle = FireScriptedLWeapon(LW_SCRIPT1, wpn->X, Calc(wpn->Y,Link->Y+8,wpn->Misc[LW_ZH_I_MOVEMENT_ARG]), 
						//								   wpn->Misc[LW_ZH_I_MOVEMENT_ARG2], 0, 0,LWF_NO_COLLISION);
					//SetLWeaponLifespan(particle,LWL_TIMER,1);
					//SetLWeaponDeathEffect(particle,LWD_VANISH,0);
				//}
			//}
			//else
				//wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
		//}
		//if(!OnScreen(wpn))
			//wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
		//Link->CollDetection = false;
		//NoAction();
	//}
	//SetLWeaponDir(wpn);
	//wpn->X= wpn->Misc[LW_ZH_I_XPOS];
	//wpn->Y= wpn->Misc[LW_ZH_I_YPOS];
//}

void __HookshotPull(lweapon wpn){
	wpn->Step = 0;
	if(Link->X!=wpn->X && Link->Y!=wpn->Y){
		if(Link->X<wpn->X)Link->X++;
		else
			Link->X--;
		if(Link->Y<wpn->Y)Link->Y++;
		else
			Link->Y--;
		Link->CollDetection = false;
		NoAction();
	}
	else{
		Link->CollDetection = true;
		KillLWeapon(wpn);
	}
}

void __NPCCollision(lweapon wpn){
	for(int i=Screen->NumNPCs();i>0;i--){
		npc n = Screen->LoadNPC(i);
		if(wpn->Misc[LW_ZH_I_MOVEMENT]!=LWM_FULL_SCREEN){
			if(wpn->Misc[LW_ZH_I_MOVEMENT]!=LWM_THROW){
				if(WeaponCollision(wpn,n)){
					if(n->Defense[LWDefense(wpn->ID)]==NPCDT_IGNORE)
						SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
					else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORIGNORE)
						SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
					else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_BLOCK)
						__LWeaponClink(wpn,true);
					else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORBLOCK)
						__LWeaponClink(wpn,false);
					if(!GetLWeaponFlag2(wpn,LWF_TEMP_PIERCE)){
						if(n->Defense[LWDefense(wpn->ID)]==NPCDT_ONEHITKILL)
							__KillNPC(n);
						if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG ||
						   wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT)
							wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
						else{
							if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
								KillLWeapon(wpn);
						}
					}
				}
				else{
					if(GetLWeaponFlag2(wpn,LWF_TEMP_PIERCE))
						UnSetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
					if((n->Misc[GEN_MISC_FLAGS]&NPC_F_FULL_SCREEN)!=0)
						n->Misc[GEN_MISC_FLAGS]&=~NPC_F_FULL_SCREEN;	
				}
			}
			else{
				if(WeaponCollision(wpn,n,false)){
					if(n->Defense[LWDefense(wpn->ID)]==NPCDT_IGNORE)
						SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
					else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORIGNORE)
						SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
					else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_BLOCK)
						__LWeaponClink(wpn,true);
					else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORBLOCK)
						__LWeaponClink(wpn,false);
					if(!GetLWeaponFlag2(wpn,LWF_TEMP_PIERCE)){
						if(n->Defense[LWDefense(wpn->ID)]==NPCDT_ONEHITKILL)
							__KillNPC(n);
						if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG ||
						   wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT)
							wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
						else{
							if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
								KillLWeapon(wpn);
						}
					}
				}
			}
		}
		else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_FULL_SCREEN){
			if(n->Misc[NPC_HURT_TIMER]==0){
				__DamageNPC(wpn,n,LW_HOOKSHOT,false);
				n->Misc[NPC_HURT_TIMER]= wpn->Misc[LW_ZH_I_LIFESPAN_ARG];
			}
			else
				n->Misc[NPC_HURT_TIMER]--;
		}
	}
}

void __KillNPC(npc enemy){
	enemy->HP = 0;
}

void __DamageNPC(lweapon wpn, npc ghost, int defense, bool destroy){
	if(ghost->Defense[LWDefense(defense)]==NPCDT_IGNORE)
		SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
	else if(ghost->Defense[LWDefense(defense)]==NPCDT_STUNORIGNORE)
		SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
	else if(ghost->Defense[LWDefense(defense)]==NPCDT_BLOCK)
		__LWeaponClink(wpn,destroy);
	else if(ghost->Defense[LWDefense(defense)]==NPCDT_STUNORBLOCK)
		__LWeaponClink(wpn,destroy);
	if(!GetLWeaponFlag2(wpn,LWF_TEMP_PIERCE)){
		if(ghost->Defense[LWDefense(defense)]==NPCDT_ONEHITKILL)
			__KillNPC(ghost);
		else{
			int Damage= wpn->Damage;
			if(ghost->Defense[LWDefense(defense)]==NPCDT_HALFDAMAGE)
				Damage/=2;
			else if(ghost->Defense[LWDefense(defense)]==NPCDT_QUARTERDAMAGE)
				Damage/=4;
			else if(ghost->Defense[LWDefense(defense)]==NPCDT_BLOCK)
				Damage= 0;
			else if(ghost->Defense[LWDefense(defense)]==NPCDT_STUNORBLOCK)
				Damage= 0;
			ghost->HP-=Damage;
			//Check to see if enemy is a boss
			Game->PlaySound(SFX_EHIT);
			if(destroy)
				KillLWeapon(wpn);
		}
	}	
}

//void __NPCCollision(lweapon wpn){
	//for(int i=Screen->NumNPCs();i>0;i--){
		//npc n = Screen->LoadNPC(i);
		//if(Collision(wpn,n)){
			//if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_DUAL_FX){
				//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG])]==NPCDT_BLOCK){
					//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_BLOCK)
						//__LWeaponClink(wpn,true);
					//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_STUNORBLOCK)
						//__LWeaponClink(wpn,false);
					//else{
						//int HitChance = Rand(0,100);
						//if(HitChance>=51)
							//__LWeaponClink(wpn,true);
						//else{
							//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_HALFDAMAGE)
								//wpn->Damage/=2;
							//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_QUARTERDAMAGE)
								//wpn->Damage/=4;
							//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_ONEHITKILL){
								//n->HP = 0;
								//KillLWeapon(wpn);
							//}
						//}
					//}	
				//}
				//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG])]==NPCDT_STUNORBLOCK){
					//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_BLOCK)
						//__LWeaponClink(wpn,true);
					//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_STUNORBLOCK)
						//__LWeaponClink(wpn,false);
					//else{
						//int HitChance = Rand(0,100);
						//if(HitChance>=51)
							//__LWeaponClink(wpn,true);
						//else{
							//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_HALFDAMAGE)
								//wpn->Damage/=2;
							//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_QUARTERDAMAGE)
								//wpn->Damage/=4;
							//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_ONEHITKILL){
								//n->HP = 0;
								//KillLWeapon(wpn);
							//}
						//}
					///}	
				//}
				//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG])]==NPCDT_HALFDAMAGE){
					//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_BLOCK)
						//__LWeaponClink(wpn,true);
					//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_STUNORBLOCK)
						//__LWeaponClink(wpn,false);
					//else{
						//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_QUARTERDAMAGE)
							//wpn->Damage/=4;
						//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_ONEHITKILL){
							//n->HP = 0;
							//KillLWeapon(wpn);
						//}
						//else
							//n->Damage/=2;
					//}
				//}
				//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG])]==NPCDT_QUARTERDAMAGE){
					//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_BLOCK)
						//__LWeaponClink(wpn,true);
					//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_STUNORBLOCK)
						//__LWeaponClink(wpn,false);
					//else{
						//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_HALFDAMAGE)
							//wpn->Damage/=2;
						//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_ONEHITKILL){
							//n->HP = 0;
							//KillLWeapon(wpn);
						//}
						//else
							//n->Damage/=4;
					//}
				//}
				//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG])]==NPCDT_ONEHITKILL){
					//if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_BLOCK)
						//__LWeaponClink(wpn,true);
					//else if(n->Defense[LWDefense(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])]==NPCDT_STUNORBLOCK)
						//__LWeaponClink(wpn,false);
					//else{
						//n->HP = 0;
						//KillLWeapon(wpn);
					//}
				//}
			//}
			//else{
				//if(n->Defense[LWDefense(wpn->ID)]==NPCDT_BLOCK)
					//__LWeaponClink(wpn,true);
				//else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORBLOCK)
					//__LWeaponClink(wpn,false);
				//else if(n->Defense[LWDefense(wpn->ID)]==NPCDT_IGNORE)
					//SetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
				//if(!GetLWeaponFlag2(wpn,LWF_TEMP_PIERCE)){
					//if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG ||
					  // wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT)
						//wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
					//else{
						//if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
							//KillLWeapon(wpn);
					//}
				//}
			//}
		//}
		//else{
			//if(GetLWeaponFlag2(wpn,LWF_TEMP_PIERCE))
				//UnSetLWeaponFlag2(wpn,LWF_TEMP_PIERCE);
		//}
	//}
//}

void __LWeaponClink(lweapon wpn, bool destroy){
	if(destroy){
		Game->PlaySound(SFX_CLINK);
		if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
			KillLWeapon(wpn);
	}
	else{
		int HitChance = Rand(0,100);
		if(HitChance>=51){
			Game->PlaySound(SFX_CLINK);
			if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_PIERCES_ENEMIES)==0)
				KillLWeapon(wpn);
		}
	}
}

//Handles Lweapon that moves like a boomerang.

void __UpdateLWM_BRang(lweapon wpn){
	float currentAngle=wpn->Angle%6.2832;
	int RandX;
	int RandY;
	int PartX;
	int PartY;
    if(currentAngle<0)
        currentAngle+=6.2832;
	if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_RETURN)==0){
		if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]>0){
			//This boomerang isn't farther from Link than it's range.
			if(Abs(wpn->X-wpn->Misc[LW_ZH_I_XPOS])>wpn->Misc[LW_ZH_I_MOVEMENT_ARG]
			   ||Abs(wpn->Y-wpn->Misc[LW_ZH_I_YPOS])>wpn->Misc[LW_ZH_I_MOVEMENT_ARG])
			   wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
		}
		if(OnScreenEdge(wpn))
			   wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
	}
	if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_RETURN)!=0){
		//Set it not to collide with enemies.
		wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_NO_COLLISION;
		float targetAngle=RadianAngle(wpn->X, wpn->Y, CenterLinkX(), CenterLinkY());
		if(targetAngle<0)
			targetAngle+=6.2832;

		float diff=Abs(currentAngle-targetAngle);

		//Turn toward Link
		if(diff<wpn->Misc[LW_ZH_I_MOVEMENT_ARG2] || diff>6.2832-wpn->Misc[LW_ZH_I_MOVEMENT_ARG2])
			wpn->Angle=targetAngle;
		
		// Can't turn enough to point directly at him...
		else if(Sign(currentAngle-targetAngle)==Sign(diff-PI)) // current>target and diff>pi or
			wpn->Angle+=wpn->Misc[LW_ZH_I_MOVEMENT_ARG2];         // current<target and diff<pi
		else                                                   // - Turn CW or CCW?
			wpn->Angle-=wpn->Misc[LW_ZH_I_MOVEMENT_ARG2];

		SetLWeaponDir(wpn);
		
		if(LinkCollision(wpn))
			KillLWeapon(wpn);
	}
	//This boomerang makes sparkles.
	if(wpn->Misc[LW_ZH_I_LIFESPAN_ARG]>0){
		//Every 30 frames, create a sparkle.
		//This sparkle dies in 30 frames.
		wpn->Misc[LW_ZH_I_WORK_3]= (wpn->Misc[LW_ZH_I_WORK_3]+1)%5;
		if(wpn->Misc[LW_ZH_I_WORK_3]==0){
			if(wpn->Dir ==DIR_LEFT||wpn->Dir==DIR_RIGHT){
				RandY = Rand(-4,4);
				PartY = wpn->Y;
				PartX = CenterWpnX(wpn);
			}
			else{
				RandX = Rand(-4,4);
				PartX = wpn->X;
				PartY = CenterWpnY(wpn);
			}
			lweapon particle = FireLWeapon(LW_SCRIPT1,PartX+RandX,PartY+RandY,
											DegtoRad(0), 0, wpn->Damage, wpn->Misc[LW_ZH_I_LIFESPAN_ARG], 0, 0);
			SetLWeaponLifespan(particle,LWL_TIMER,60);
			SetLWeaponDeathEffect(particle,LWD_VANISH,0);
		}
	}
}

//Handles lweapon that is carried.

void __UpdateLWM_Carry(lweapon wpn){
	wpn->Misc[LW_ZH_I_XPOS]= Link->X;
	wpn->Misc[LW_ZH_I_YPOS]= Link->Y-16;
	wpn->X = wpn->Misc[LW_ZH_I_XPOS];
	wpn->Y = wpn->Misc[LW_ZH_I_YPOS];
	//else if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]== LWM_CARRY_SOM){
		//if((Link->X+16)==wpn->X && Between(Link->Y+8,wpn->Y,wpn->Y+wpn->HitHeight)
			//&& (Link->PressRight ||Link->InputRight) 
			//&& !Screen->isSolid(wpn->X+wpn->HitWidth,wpn->Y) 
			//&& !Screen->isSolid(wpn->X+wpn->HitWidth,wpn->Y+wpn->HitHeight)){
			//wpn->Misc[LW_ZH_I_XPOS]++;
		//}
		//else if((Link->X+16)==wpn->X && Between(Link->Y+8,wpn->Y,wpn->Y+wpn->HitHeight)
				//&& (Link->PressRight ||Link->InputRight) 
				//&& Screen->isSolid(wpn->X+wpn->HitWidth,wpn->Y) 
				//&& Screen->isSolid(wpn->X+wpn->HitWidth,wpn->Y+wpn->HitHeight)){
			//Link->PressRight = false;
			//Link->InputRight = false;
		//}
		//else if((Link->Y+16)==wpn->Y && Between(Link->X+8,wpn->X,wpn->X+wpn->HitWidth)
				//&& (Link->PressDown ||Link->InputDown) 
				//&& !Screen->isSolid(wpn->X,wpn->Y+wpn->HitHeight) 
				//&& !Screen->isSolid(wpn->X+wpn->HitWidth,wpn->Y+wpn->HitHeight)){
			//wpn->Misc[LW_ZH_I_YPOS]++;
		//}
		//else if((Link->Y+16)==wpn->Y && Between(Link->X+8,wpn->X,wpn->X+wpn->HitWidth)
				//&& (Link->PressDown ||Link->InputDown) 
				//&& Screen->isSolid(wpn->X,wpn->Y+wpn->HitHeight) 
				//&& Screen->isSolid(wpn->X+wpn->HitHeight,wpn->Y+wpn->HitHeight)){
			//Link->PressDown = false;
			//Link->InputDown = false;
		//}
		//else if(Link->X==(wpn->X+wpn->HitWidth) && Between(Link->Y+8,wpn->Y,wpn->Y+wpn->HitHeight)
				//&& (Link->PressLeft ||Link->InputLeft) 
				//&& !Screen->isSolid(wpn->X-1,wpn->Y) 
				//&& !Screen->isSolid(wpn->X-1,wpn->Y+wpn->HitHeight)){
			//wpn->Misc[LW_ZH_I_XPOS]--;
		//}
		//else if(Link->X==(wpn->X+wpn->HitWidth) && Between(Link->Y+8,wpn->Y,wpn->Y+wpn->HitHeight)
				//&& (Link->PressLeft ||Link->InputLeft) 
				//&& Screen->isSolid(wpn->X-1,wpn->Y) 
				//&& Screen->isSolid(wpn->X-1,wpn->Y+wpn->HitHeight)){
			//Link->PressLeft = false;
			//Link->InputLeft = false;
		//}
		//else if(Link->Y==(wpn->Y+wpn->HitHeight) && Between(Link->X+8,wpn->X,wpn->Y+wpn->HitWidth)
				//&& (Link->PressUp ||Link->InputUp) 
				//&& !Screen->isSolid(wpn->X,wpn->Y-1) 
				//&& !Screen->isSolid(wpn->X+wpn->HitHeight,wpn->Y-1)){
			//wpn->Misc[LW_ZH_I_YPOS]--;
		//}
		//else if(Link->Y==(wpn->Y+wpn->HitHeight) && Between(Link->X+8,wpn->X,wpn->Y+wpn->HitWidth)
				//&& (Link->PressUp ||Link->InputUp) 
				//&& Screen->isSolid(wpn->X,wpn->Y-1) 
				//&& Screen->isSolid(wpn->X+wpn->HitHeight,wpn->Y-1)){
			//Link->PressUp = false;
			//Link->InputUp = false;
		//}
		//wpn->X = wpn->Misc[LW_ZH_I_XPOS];
		//wpn->Y = wpn->Misc[LW_ZH_I_YPOS];
		//__UpdateLWE_Somaria(wpn);
	//}
	//else if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]== LWM_R_MAGNET){
		//if(Link->PressLeft||Link->InputLeft)
			//wpn->Misc[LW_ZH_I_XPOS]--;
		//else if(Link->PressRight||Link->InputRight)
			//wpn->Misc[LW_ZH_I_XPOS]++;
		//if(Link->PressUp||Link->InputUp)
			//wpn->Misc[LW_ZH_I_YPOS]--;
		//else if(Link->PressDown||Link->InputDown)
			//wpn->Misc[LW_ZH_I_YPOS]++;
		//Link->Dir= wpn->Dir;
		//wpn->X = wpn->Misc[LW_ZH_I_XPOS];
		//wpn->Y = wpn->Misc[LW_ZH_I_YPOS];
		//__UpdateLWE_Magnet(wpn);
	//}
}

//Handles Lweapons that pickup items.

void __UpdateLWF_Pickup(lweapon wpn){
	if(Screen->NumItems()>0){
		for(int i=1;i<=Screen->NumItems();i++){
			item anitem = Screen->LoadItem(i);
			for ( int r = 0; r < SizeOfArray(ItemsToPickup); r++ ) {
				if(anitem->isValid()){
					if ( anitem->ID == ItemsToPickup[r]) {
						if (Collision(wpn,anitem)) {
							if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_INSTA_DELIVER)!=0){
								anitem->X = Link->X;
								anitem->Y = Link->Y;
							}
							else{
								if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG)
									wpn->Misc[LW_ZH_I_FLAGS_2]|= LWF_RETURN;
								anitem->X = wpn->X;
								anitem->Y = wpn->Y;
								if(LinkCollision(wpn)){
									anitem->X = Link->X;
									anitem->Y = Link->Y;
								}
							}
						}
						
					}
				}
				else
					continue;
			}
		}
	}
}

//Handles Lweapons that pierce enemies.

void __UpdateLWF_Pierce(lweapon wpn){
	wpn->DeadState = WDS_ALIVE;
}

//Handles Lweapons that stun enemies.

void __UpdateLWF_Stun(lweapon wpn){
	if(Screen->NumNPCs()>0){
		for(int i=Screen->NumNPCs();i>0;i--){
			npc thing = Screen->LoadNPC(i);
			if(thing->HP<=0)break;
			if(Collision(thing,wpn) && (thing->Defense[LWDefense(wpn->ID)]==NPCDT_STUN
				|| thing->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORBLOCK
				|| thing->Defense[LWDefense(wpn->ID)]==NPCDT_STUNORIGNORE)){
				if(thing->Defense[LWDefense(wpn->ID)]!=NPCDT_STUN){
					int StunChance = Rand(0,100);
					if(StunChance>50)
						thing->Stun= Rand(0,MAX_STUN_TIME);
				}
				else
					thing->Stun = Rand(0,MAX_STUN_TIME);
				KillLWeapon(wpn);
			}
		}
	}
}

void __UpdateLWF_Float(){
	if(IsSideview())
		Link->Jump = 0;
	else{
		Link->Z = 1;
		Link->Jump = 0;
	}
}

//Handles lweapons that are reflected off of magic mirrors.

///void __UpdateLWF_Reflect(lweapon wpn){
	//float angle;
	//lweapon new;
	//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_WAS_REFLECTED)==0){
		//if(ComboTAtWpn(wpn,CT_MIRROR)||
			//ComboTAtWpn(wpn,CT_MIRRORBACKSLASH)||
			//ComboTAtWpn(wpn,CT_MIRRORSLASH)){
		   //if(ComboTAtWpn(wpn)==CT_MIRRORSLASH){
				//if(wpn->Dir==DIR_UP){
					//angle = DegtoRad(0);
					//wpn->Y-=16;
				//}
				//else if(wpn->Dir==DIR_DOWN){
					//angle = DegtoRad(180);
					//wpn->Y+=16;
				//}
				//else if(wpn->Dir==DIR_LEFT){
					//angle = DegtoRad(270);
					//wpn->X-=16;
				//}
				//else if(wpn->Dir==DIR_RIGHT){
					//angle = DegtoRad(90);
					//wpn->X+=16;
				//}
		  // }
		   //else if(ComboTAtWpn(wpn)==CT_MIRRORBACKSLASH){
				//if(wpn->Dir==DIR_UP){
					//angle = DegtoRad(180);
					//wpn->Y-=16;
				//}
				//else if(wpn->Dir==DIR_DOWN){
					//angle = DegtoRad(0);
					//wpn->Y+=16;
				//}
				//else if(wpn->Dir==DIR_LEFT){
					//angle = DegtoRad(90);
					//wpn->X-=16;
				//}
				//else if(wpn->Dir==DIR_RIGHT){
					//angle = DegtoRad(270);
					//wpn->X+=16;
				//}
		   //}
		   //wpn->X=WeaponXLoc(wpn);
		   //wpn->Y=WeaponYLoc(wpn);
		  // wpn->Angle = angle;
		  // SetLWeaponDir(wpn);
		   //if(wpn->TileHeight==0 && wpn->TileWidth==0)
				//new = FireLWeapon(wpn->ID, wpn->X, wpn->Y, angle, wpn->Step, wpn->Damage, wpn->Misc[LW_ZH_I_LIFESPAN_ARG], wpn->Misc[LW_ZH_I_FX], wpn->Misc[LW_ZH_I_FLAGS]);
			//else
				//new = FireBigLWeapon(wpn->ID, wpn->X, wpn->Y, angle, wpn->Step, wpn->Damage, wpn->Misc[LW_ZH_I_LIFESPAN_ARG], wpn->Misc[LW_ZH_I_FX], wpn->Misc[LW_ZH_I_FLAGS],wpn->TileHeight,wpn->TileWidth);
			//SetLWeaponLifespan(new, wpn->Misc[LW_ZH_I_LIFESPAN], wpn->Misc[LW_ZH_I_LIFESPAN_ARG]);
			//SetLWeaponMovement(new,wpn->Misc[LW_ZH_I_MOVEMENT],wpn->Misc[LW_ZH_I_MOVEMENT_ARG],wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]);
			//if(wpn->Misc[LW_ZH_I_FX]>0)
				//SetLWeaponSFX(new, wpn->Misc[LW_ZH_I_FX], wpn->Misc[LW_ZH_I_WORK_2]);
			//SetLWeaponDeathEffect(new, wpn->Misc[LW_ZH_I_ON_DEATH], wpn->Misc[LW_ZH_I_ON_DEATH_ARG]);
			//new->Misc[LW_ZH_I_FLAGS_2]|=wpn->Misc[LW_ZH_I_FLAGS_2]|LWF_WAS_REFLECTED;			
			//Remove(wpn);
			//wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_WAS_REFLECTED;			
		//}
	//}
	//else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_WAS_REFLECTED)!=0){
		//if(!ComboTAtWpn(wpn,CT_MIRROR)&&
			//!ComboTAtWpn(wpn,CT_MIRRORBACKSLASH)&&
			//!ComboTAtWpn(wpn,CT_MIRRORSLASH)){
			//wpn->Misc[LW_ZH_I_FLAGS_2]&=~LWF_WAS_REFLECTED;
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_IS_REFLECTED)==0)
				//wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_IS_REFLECTED;
		//}
	//}
//}

//Makes lweapon ignore gravity

void __UpdateLWF_G_Force(lweapon wpn){
	wpn->Jump = 0;
}

//Turns an lweapons collision detection off.

void __UpdateLWF_Collision(lweapon wpn){
	wpn->CollDetection= false;
}

//Makes Link invincible while this is active.

//void __UpdateLWF_Link_CollOff(){
	//if(Link->CollDetection){
		//Link->CollDetection= false;
		//LW_Vars[NOT_COLL]=1;
	//}
	//else if(!LW_Vars[NOT_COLL] && !Link->CollDetection)
		//LW_Vars[NOT_COLL]=0;
//}

//Makes it where Link can't move while this lweapon is active.

void __UpdateLWF_Link_FreezeOn(){
	NoAction();
}

void __UpdateLWF_Knockback(){
	if ( ( Link->Action == LA_GOTHURTLAND || Link->Action == LA_GOTHURTWATER ) && Link->HitDir != -1 ) {
		Link->HitDir = -1;
	}
}

void __UpdateLWM_Melee(lweapon wpn){
	if(wpn->Misc[LW_ZH_I_WORK_3]==0){
		wpn->HitXOffset =0;
		wpn->HitYOffset =0;
		wpn->DrawXOffset=0;
		wpn->DrawYOffset=0;
	}
	else{
		if(wpn->Misc[LW_ZH_I_WORK_3]==LWMS_SLASH)
			__UpdateLW_MS_Slash(wpn);
	}
	if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_TRACKER)!=0){
		if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_TALL_LINK)==0){
			if (Link->Dir == DIR_UP){
			   wpn->X = Link->X;
			   wpn->Y = Link->Y - 12;
			}
			if (Link->Dir == DIR_DOWN){
			   wpn->X = Link->X;
			   wpn->Y = Link->Y + 12;
			}
			if (Link->Dir == DIR_LEFT){
			   wpn->X = Link->X-12;
			   wpn->Y = Link->Y;
			}
			if (Link->Dir == DIR_RIGHT){
			   wpn->X = Link->X+12;
			   wpn->Y = Link->Y;
			}
			wpn->Z = Link->Z;
			if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_NORMALIZE)==0)
				__Melee_LWeaponDir(wpn);
		}
		else if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG]&LWMF_TALL_LINK)!=0){
			if (Link->Dir == DIR_UP){
			   wpn->X = Link->X;
			   wpn->Y = Link->Y - 12;
			}
			if (Link->Dir == DIR_DOWN){
			   wpn->X = Link->X;
			   wpn->Y = Link->Y + 44;
			}
			if (Link->Dir == DIR_LEFT){
			   wpn->X = Link->X-12;
			   wpn->Y = Link->Y-16;
			}
			if (Link->Dir == DIR_RIGHT){
			   wpn->X = Link->X+12;
			   wpn->Y = Link->Y-16;
			}
			wpn->Z = Link->Z;
			if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_NORMALIZE)==0)
				__Melee_LWeaponDir(wpn);
		}
	}
	if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_SLASH)!=0){
		int loc = ComboAt(wpn->X+8+wpn->HitXOffset,wpn->Y+8+wpn->HitYOffset);
		DoDashSlash(loc,wpn->Misc[LW_ZH_I_MOVEMENT_ARG]);
		Item_Spawn(loc);
	}
	if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_POUND)!=0){
		int loc = ComboAt(wpn->X+8+wpn->HitXOffset,wpn->Y+8+wpn->HitYOffset);
		if(ComboT(loc,CT_POUND)){
			Game->PlaySound(SFX_HAMMER);
			Screen->ComboD[loc]++;
		}
		if(Screen->ComboF[loc]==CF_HAMMER||
			Screen->ComboI[loc]==CF_HAMMER){
			Game->PlaySound(SFX_HAMMER);
			Screen->State[ST_SECRET]= true;
			Screen->TriggerSecrets();
		}	
			
	}
	if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_REFLECTS_EWPN)!=0)
		__UpdateLWMF_Reflect_EWpn(wpn);
}

void Item_Spawn(int loc){
	if(!Screen->State[ST_SPECIALITEM]){
		if(ComboFI(loc,CF_ARMOSITEM)){
			if(!__IsChest(loc)){
				item theitem = Screen->CreateItem(Screen->RoomData);
				theitem->X= ComboX(loc);
				theitem->Y= ComboY(loc);
				theitem->Pickup |= IP_HOLDUP;
				theitem->Pickup |= IP_ST_SPECIALITEM;
				Screen->ComboF[loc]= 0;
				Screen->ComboI[loc]= 0;
			}
		}
	}
}

//Handles Lweapons that circle Link.

void __UpdateLWM_Arc(lweapon wpn){
	wpn->Misc[LW_ZH_I_WORK]= (wpn->Misc[LW_ZH_I_WORK]
								+(wpn->Step/50))%360;
	wpn->HitXOffset = VectorX(wpn->HitWidth,wpn->Misc[LW_ZH_I_WORK]);
	wpn->HitYOffset = VectorY(wpn->HitHeight,wpn->Misc[LW_ZH_I_WORK]);
	
	wpn->Angle = DegtoRad(wpn->Misc[LW_ZH_I_WORK]);
	if((wpn->Misc[LW_ZH_I_FLAGS]&LWF_NORMALIZE)==0)
		SetLWeaponDir(wpn);
	wpn->X=Link->X;
	wpn->Y=Link->Y;	
	wpn->DrawXOffset=wpn->HitXOffset;
	wpn->DrawYOffset=wpn->HitYOffset;
	DrawLWeapon(wpn);
	if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_SLASH)!=0){
		int loc = ComboAt(wpn->X+8+wpn->HitXOffset,wpn->Y+8+wpn->HitYOffset);
		DoDashSlash(loc,wpn->Misc[LW_ZH_I_WORK_3]);
		Item_Spawn(loc);
	}
	if((wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]&LWMF_REFLECTS_EWPN)!=0)
		__UpdateLWMF_Reflect_EWpn(wpn);
}

void __Melee_LWeaponDir(lweapon wpn){
    float angle=__DirtoRad(Link->Dir);
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
	wpn->Flip =flip;
}

//Handles Lweapons that circle Link.

void __UpdateLW_MS_Slash(lweapon wpn){
	
	wpn->Misc[LW_ZH_I_WORK]= (wpn->Misc[LW_ZH_I_WORK]
								+((wpn->Step/100)*wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]))%360;
	wpn->HitXOffset = VectorX(8,wpn->Misc[LW_ZH_I_WORK]);
	wpn->HitYOffset = VectorY(8,wpn->Misc[LW_ZH_I_WORK]);
	
	wpn->Angle = DegtoRad(wpn->Misc[LW_ZH_I_WORK]);
	DrawLWeapon(wpn);
	wpn->X=Link->X;
	wpn->Y=Link->Y;							
	wpn->DrawXOffset= wpn->HitXOffset;
	wpn->DrawYOffset= wpn->HitYOffset;
}

// Used when Link is holding up an item. UpdateEWeapon() doesn't run, but
// the appearance-related flags still need handled.
void DrawLWeapon(lweapon wpn){
	float angle;
	int tile;
	if(wpn->Angular)
		angle=RadtoDeg(wpn->Angle);
	else{
		int dir=__NormalizeDir(wpn->Dir);
		
		if(dir==DIR_UP)
			angle=-90;
		else if(dir==DIR_RIGHTUP)
			angle=-45;
		else if(dir==DIR_RIGHT)
			angle=0;
		else if(dir==DIR_RIGHTDOWN)
			angle=45;
		else if(dir==DIR_DOWN)
			angle=90;
		else if(dir==DIR_LEFTDOWN)
			angle=135;
		else if(dir==DIR_LEFT)
			angle=180;
		else // DIR_LEFTUP
			angle=-135;
	}
        
	int flip;
	if(angle>=0 && angle<180)
		flip=0;
	else
		flip=2;
	if(!wpn->Misc[LW_ZH_I_MOVEMENT_ARG])
		tile= wpn->Tile;
	else
		tile= wpn->Misc[LW_ZH_I_MOVEMENT_ARG];
	// Currently, these are always drawn on layer 4.
	// That should probably be changed...
	Screen->DrawTile(4, wpn->X+wpn->DrawXOffset, wpn->Y-wpn->Z+wpn->DrawYOffset, 
						tile, 1, 1, wpn->CSet,
						-1, -1, wpn->X+wpn->DrawXOffset, 
						wpn->Y-wpn->Z+wpn->DrawYOffset, angle, flip, true, OP_OPAQUE);
}

void __FlagTrigger(lweapon wpn){
	bool trigger = false;
	if(wpn->ID==LW_ARROW){
		if(ComboFIAtWpn(wpn,CF_ARROW)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_ARROW2)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_ARROW3)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)trigger = true;
		}
	}
	else if(wpn->ID==LW_FIRE){
		if(ComboFIAtWpn(wpn,CF_CANDLE1)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_CANDLE2)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		}
	}
	else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG){
		if(ComboFIAtWpn(wpn,CF_BRANG1)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_BRANG2)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_BRANG3)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)trigger = true;
		}
	}
	else if(wpn->ID==LW_MAGIC && ComboFIAtWpn(wpn,CF_WANDMAGIC))trigger = true;
	else if(wpn->ID==LW_MAGIC && ComboFIAtWpn(wpn,CF_WANDFIRE)
			&& (wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)trigger = true;
	//else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_MELEE){
		//if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_IS_SWORD){
			//if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)return CF_SWORD1;
			//else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)return CF_SWORD2;
			//else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)return CF_SWORD3;
			//else
				//return CF_SWORD4;
		//}
		//else if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_IS_HAMMER)
			//return CF_HAMMER;
		//else if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]==LW_IS_WAND)
			//return CF_WAND;
	//}
	else if(wpn->ID==LW_BEAM){
		if(ComboFIAtWpn(wpn,CF_SWORD1BEAM)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_SWORD2BEAM)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_SWORD3BEAM)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_3)!=0)trigger = true;
		}
		if(ComboFIAtWpn(wpn,CF_SWORD4BEAM)){
			if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_4)!=0)trigger = true;
		}
	}
	//else if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_HOOKSHOT)
		//return CF_HOOKSHOT;
	if(trigger){
		if(wpn->Misc[LW_ZH_I_MOVEMENT]==LWM_BRANG)
			wpn->Misc[LW_ZH_I_FLAGS_2]|=LWF_RETURN;
		else
			KillLWeapon(wpn);
		Screen->TriggerSecrets();
		Screen->State[ST_SECRET] = true;
		Game->PlaySound(SFX_SECRET);
	}
}