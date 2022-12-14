//LW_ZH Movement functions

//Set up an lweapon's movement.

//D0- Lweapon to alter.
//D1= Type of movement.
//D2- Movement argument one.
//D3- Movement argument two.

// Set an lweapon's movement type
void SetLWeaponMovement(lweapon wpn, int type, int arg, int arg2)
{
    wpn->Misc[LW_ZH_I_XPOS]= wpn->X;
	wpn->Misc[LW_ZH_I_YPOS]= wpn->Y;
    wpn->Misc[LW_ZH_I_WORK]=0;
    wpn->Misc[LW_ZH_I_MOVEMENT]=type;
    wpn->Misc[LW_ZH_I_MOVEMENT_ARG]=arg;
    wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]=arg2;
    //wpn->Misc[LW_ZH_I_FLAGS]|=__LWFI_IS_LWZH_LWPN;
	if(type!=LWM_FALL)wpn->Angular = true;
    if(type==LWM_THROW){
		if(!IsSideview())
			wpn->Misc[LW_ZH_I_WORK_2]=wpn->Z;
		else
			wpn->Misc[LW_ZH_I_WORK_2]= 176-wpn->Y;
        // Necessary upward velocity to reach Link for thrown weapons
        if(arg<=0){
			if(!IsSideview()){
				if(Screen->NumNPCs()>0){
					if(wpn->Misc[LW_ZH_I_WORK]==0)wpn->Misc[LW_ZH_I_WORK] = Rand(1,Screen->NumNPCs());
					npc target_enemy = Screen->LoadNPC(wpn->Misc[LW_ZH_I_WORK]);
					target_enemy->Misc[NPC_MISC_TARGET_NUMBER]=wpn->Misc[LW_ZH_I_WORK];
					if(target_enemy->HP<=0)wpn->Misc[LW_ZH_I_WORK]=0;
					if(target_enemy->Misc[NPC_MISC_TARGET_NUMBER]==wpn->Misc[LW_ZH_I_WORK]){
						float time=Distance(wpn->X, wpn->Y, target_enemy->X,target_enemy->Y)/(wpn->Step/100);
						wpn->Misc[LW_ZH_I_MOVEMENT_ARG]=GH_GRAVITY*time/2;
					}
				}
			}
			else
				wpn->Misc[LW_ZH_I_MOVEMENT_ARG]= wpn->Step/100;
        }
    }
    else if(type==LWM_FALL){
        if(!IsSideview()){
			wpn->Z = arg;
			wpn->Misc[LW_ZH_I_WORK_2]=arg;
		}
		else{
			wpn->HitYOffset-= arg;
			wpn->DrawYOffset-=arg;
			wpn->Misc[LW_ZH_I_WORK_2]= arg;
		}
        wpn->Misc[LW_ZH_I_WORK]=GH_GRAVITY;
    }
	else if(type==LWM_CIRCLE||type==LWM_ARC)
		wpn->Misc[LW_ZH_I_WORK]= RadtoDeg(wpn->Angle);
	else if(type==LWM_CAROM){
		int dir = AngleDir4(wpn->Angle);
		if(dir==DIR_RIGHT){
			if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]<=0)
				wpn->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;	
		}
		else if(dir==DIR_LEFT){
			if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG]>=0)
				wpn->Misc[LW_ZH_I_MOVEMENT_ARG]*=-1;
		}
		else if(dir==DIR_UP){
			if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]>=0)
				wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		}
		else if(dir==DIR_DOWN){
			if(wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]<=0)
				wpn->Misc[LW_ZH_I_MOVEMENT_ARG2]*=-1;
		}
	}
}

void SetLWeaponMovementStyle(lweapon wpn, int style){
	wpn->Misc[LW_ZH_I_WORK_3]= style;
}