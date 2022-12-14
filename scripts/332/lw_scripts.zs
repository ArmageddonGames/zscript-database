item script Firebar{
	void run(int dummy, int Damage, int sprite){
		int i;
		lweapon fireball;
		if(NumLWeaponsOf(LW_SCRIPT4)==0){
			for(i=1;i<=7;i++){
				fireball= FireLWeapon(LW_SCRIPT4, Link->X + 8,
										 Link->Y+8, __DirtoRad(Link->Dir), 
										 100, Damage, sprite, SFX_SWORD, LWF_NORMALIZE);
				SetLWeaponLifespan(fireball,LWL_TIMER,180);
				SetLWeaponMovement(fireball,LWM_CIRCLE,(16*i),10);
				SetLWeaponDeathEffect(fireball,LWD_AIM_AT_NPC,10);
				SetLWeaponHitbox(fireball,8,8,4,4);
			}
		}
		else{
			for(i= Screen->NumLWeapons();i>0;i--){
				fireball= Screen->LoadLWeapon(i);
				if(fireball->ID==LW_SCRIPT4)
					KillLWeapon(fireball);
			}
		}
	}
}

item script OmniByrna{
	void run(int dummy, int Damage, int sprite){
		lweapon fireball1;
		lweapon fireball2;
		lweapon fireball3;
		lweapon fireball4;
		if(NumLWeaponsOf(LW_SCRIPT5)==0){
				fireball1= FireLWeapon(LW_SCRIPT5, Link->X + 8*Cos(0),
										 Link->Y+ 8*Sin(0), DegtoRad(0), 
										 100, Damage, sprite, SFX_SWORD, LWF_NORMALIZE);
				SetLWeaponLifespan(fireball1,LWL_MP_COST,5);
				SetLWeaponMovement(fireball1,LWM_CIRCLE,32,10);
				SetLWeaponDeathEffect(fireball1,LWD_VANISH,0);
				fireball2= FireLWeapon(LW_SCRIPT5, Link->X + 8*Cos(90),
										 Link->Y+ 8*Sin(90), DegtoRad(90), 
										 100, Damage, sprite, SFX_SWORD, LWF_NORMALIZE);
				SetLWeaponLifespan(fireball2,LWL_MP_COST,-1);						 
				SetLWeaponMovement(fireball2,LWM_CIRCLE,32,10);
				SetLWeaponDeathEffect(fireball2,LWD_VANISH,0);
				fireball3= FireLWeapon(LW_SCRIPT5, Link->X + 8*Cos(180),
										 Link->Y+ 8*Sin(180), DegtoRad(180), 
										 100, Damage, sprite, SFX_SWORD, LWF_NORMALIZE);
				SetLWeaponLifespan(fireball3,LWL_MP_COST,-1);						 
				SetLWeaponMovement(fireball3,LWM_CIRCLE,32,10);
				SetLWeaponDeathEffect(fireball3,LWD_VANISH,0);
				fireball4= FireLWeapon(LW_SCRIPT5, Link->X + 8*Cos(270),
										 Link->Y+ 8*Sin(270), DegtoRad(270), 
										 100, Damage, sprite, SFX_SWORD, LWF_NORMALIZE);
				SetLWeaponLifespan(fireball4,LWL_MP_COST,-1);						 
				SetLWeaponMovement(fireball4,LWM_CIRCLE,32,10);
				SetLWeaponDeathEffect(fireball4,LWD_VANISH,0);
		}
		else{
			for(int i= Screen->NumLWeapons();i>0;i--){
				fireball1= Screen->LoadLWeapon(i);
				if(fireball1->ID==LW_SCRIPT5)
					KillLWeapon(fireball1);
			}
		}
	}
}

item script Grenade{
	void run(int dummy, int Damage, int sprite){
		if(Game->Counter[CR_BOMBS]>=1){
			lweapon fireball;
			fireball= FireLWeapon(LW_SCRIPT6, Link->X+8, Link->Y, __DirtoRad(Link->Dir), 
									100, Damage, sprite, SFX_THROW, 0);
			SetLWeaponMovement(fireball,LWM_THROW,3,LWMF_BOUNCE|LWMF_DIE);
			SetLWeaponDeathEffect(fireball,LWD_EXPLODE,8);
			Link->Action = LA_ATTACKING;
			SetLWeaponFlag2(fireball,LWF_SHADOW);
			Game->Counter[CR_BOMBS]--;
		}
	}
}

item script Boulder{
	void run(int dummy, int Damage, int sprite){
		if(NumLWeaponsOf(LW_SCRIPT7)==0){
			lweapon fireball;
			fireball= FireBigLWeapon(LW_SCRIPT7, Link->X+8, Link->Y, __DirtoRad(Link->Dir), 
									100, Damage, sprite, SFX_THROW, 0,2,2);
			SetLWeaponMovement(fireball,LWM_THROW,3,LWMF_DIE);
			SetLWeaponDeathEffect(fireball,LWD_4_FIREBALLS_RANDOM,99);
			SetLWeaponFlag2(fireball,LWF_SHADOW);
			Link->Action = LA_ATTACKING;
		}
	}
}

item script Message{
	void run(int message){
		Screen->Message(message);
	}
}

item script ScriptBoomerang{
	void run(int dummy, int range,int level, int Damage, int sprite,int script_id){
		lweapon brang;
		if(NumLWeaponsOf(LW_SCRIPT8)==0){
			brang = FireLWeapon(LW_SCRIPT8, Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2),
							 __DirtoRad(Link->Dir), 100, Damage, sprite, SFX_BRANG, LWF_STUNS_ENEMIES|LWF_ITEM_PICKUP);
			SetLWeaponMovement(brang,LWM_BRANG,range,15);
			SetLWeaponSFX(brang,SFX_BRANG,30);
			SetLWeaponDeathEffect(brang,LWD_VANISH,0);	
			brang->Misc[LW_ZH_I_FLAGS_2]|=level;
			if(level==LWF_LEVEL_2)
				SetLWeaponLifespan(brang,LWL_EDGE,SPR_MAGIC_SPARKLE);
			else if(level==LWF_LEVEL_3)
				SetLWeaponLifespan(brang,LWL_EDGE,SPR_FIRE_SPARKLE);
			else
				SetLWeaponLifespan(brang,LWL_EDGE,0);
		}
	}
}

const int SPR_MAGIC_SPARKLE = 31;
const int SPR_FIRE_SPARKLE  = 32;

item script BombArrows{
	void run(int dummy, int damage, int sprite){
		if(Game->Counter[CR_ARROWS]!=0 && Game->Counter[CR_BOMBS]!=0){
			lweapon bombarrow;
			bombarrow = FireLWeapon(LW_ARROW, Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2), 
									__DirtoRad(Link->Dir), 200, damage, sprite, SFX_ARROW, LWF_DETONATE);
			SetLWeaponLifespan(bombarrow,LWL_EDGE,0);						
			SetLWeaponDeathEffect(bombarrow,LWD_EXPLODE,8);
			bombarrow->Misc[LW_ZH_I_FLAGS_2]|=LWF_LEVEL_1;
			Link->Action = LA_ATTACKING;
			Game->Counter[CR_ARROWS]--;
			Game->Counter[CR_BOMBS]--;
		}
	}
}

item script Fire_Rod{
	void run(int dummy, int MPCost, int damage, int spritemagic, int spritewand){
		if(Link->MP>=MPCost){
			lweapon magic;
			lweapon wand;
			wand = FireLWeapon(LW_SCRIPT9,Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2),
								__DirtoRad(Link->Dir), 0, damage, spritewand, 0, LWF_PIERCES_ENEMIES);
			SetLWeaponLifespan(wand,LWL_TIMER,10);
			SetLWeaponMovement(wand,LWM_MELEE,0,LWMF_TRACKER);
			SetLWeaponDeathEffect(wand,LWD_VANISH,0);
			magic = FireLWeapon(LW_MAGIC,Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2),
								__DirtoRad(Link->Dir), 200, damage, spritemagic, SFX_WAND, 0);
			SetLWeaponLifespan(magic,LWL_EDGE,0);
			SetLWeaponDeathEffect(magic,LWD_FIRE,85);
			magic->Misc[LW_ZH_I_FLAGS_2]|=LWF_LEVEL_3;
			Link->Action = LA_ATTACKING;
			Link->MP-=MPCost;
		}
	}
}

const int ICE_ROD_SCRIPT = 2;
const int ICE_BLOCK_COMBO =3449;

item script Ice_Rod{
	void run(int dummy, int MPCost, int damage, int spritemagic, int spritewand){
		if(Link->MP>=MPCost){
			lweapon magic;
			lweapon wand;
			int Args[8]= {Rand(0,255)}; 
			wand = FireLWeapon(LW_SCRIPT9,Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2),
								__DirtoRad(Link->Dir), 0, damage, spritewand, 0, LWF_NORMALIZE);
			SetLWeaponLifespan(wand,LWL_TIMER,10);
			SetLWeaponMovement(wand,LWM_MELEE,0,LWMF_TRACKER);
			SetLWeaponDeathEffect(wand,LWD_VANISH,0);
			magic = FireLWeapon(LW_MAGIC,Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2),
								__DirtoRad(Link->Dir), 200, 0, 
								spritemagic, SFX_WAND, LWF_STUNS_ENEMIES);
			SetLWeaponLifespan(magic,LWL_EDGE,0);
			SetLWeaponScript(magic,ICE_ROD_SCRIPT,Rand(0,255));
			SetLWeaponFlag2(magic,LWF_FREEZE_WATER);
			Link->Action = LA_ATTACKING;
			Link->MP-=MPCost;
		}
	}
}

const int SPR_WAVE_SHARDS = 57;

item script Wave_Sword_Beam{
	void run(int dummy1, int dummy2, int Damage, int percent, int sprite){
		Game->PlaySound(SFX_BEAM);
		Link->Action = LA_ATTACKING;
		lweapon beam;
		lweapon fakesword;
		beam = FireScriptedLWeapon(LW_BEAM, Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2), 
											sprite, 200, Damage,LWF_ZERO_G);
		beam->Misc[LW_ZH_I_FLAGS_2]|=LWF_LEVEL_3;
		SetLWeaponLifespan(beam,LWL_EDGE,0);
		if(beam->Dir==DIR_UP || beam->Dir==DIR_DOWN)SetLWeaponMovement(beam, LWM_SINE_WAVE, 6, 4);
		else
			SetLWeaponMovement(beam, EWM_SINE_WAVE, 4, 6);
		if(Link->HP>=(Link->MaxHP * 0.01 * percent))
			SetLWeaponDeathEffect(beam,LWD_4_FIREBALLS_DIAG,SPR_WAVE_SHARDS);
		beam->Angle = __DirtoRad(Link->Dir);
	}
}


const int SPR_ARROW_1 = 10;//Sprite for normal missile.
const int SPR_ARROW_2 = 11;//Sprite for ice missile.
const int SPR_ARROW_3 = 34;//Sprite for hyper missile.

item script Variable_Strength_Arrow{
	void run(int dummy1, int dummy2, int level, int Damage){
		//Create and position Lweapon.
		lweapon beam;//Lweapon created by charge.
		if(level==1){
			beam = FireScriptedLWeapon(LW_ARROW, Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2), 
												SPR_ARROW_1, 200, Damage,LWF_ZERO_G);
			beam->Misc[LW_ZH_I_FLAGS_2]|=LWF_LEVEL_1;
			SetLWeaponDeathEffect(beam,LWD_VANISH,0);
		}
		else if(level==2){
			beam = FireScriptedLWeapon(LW_ARROW, Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2), 
												SPR_ARROW_2, 200, Damage,LWF_ZERO_G);
			beam->Misc[LW_ZH_I_FLAGS_2]|=LWF_LEVEL_2;
			SetLWeaponLifespan(beam,LWL_TIMER,60);
			SetLWeaponDeathEffect(beam,LWD_8_FIREBALLS,75);
		}
		else if(level ==3){
			beam = FireScriptedLWeapon(LW_ARROW, Link->X+InFrontX(Link->Dir,2), Link->Y+InFrontY(Link->Dir,2), 
												SPR_ARROW_3, 200, Damage,LWF_ZERO_G);
			beam->Misc[LW_ZH_I_FLAGS_2]|=LWF_LEVEL_3;
			if(Screen->NumNPCs()>0){
				beam->Angle = __DirtoRad(Link->Dir);
				SetLWeaponMovement(beam, LWM_HOMING, 15, -1);
			}
			SetLWeaponDeathEffect(beam,LWD_VANISH,0);		
		}
		Game->PlaySound(SFX_ARROW);
		Link->Action = LA_ATTACKING;
		Game->Counter[CR_ARROWS]--;
		SetLWeaponLifespan(beam,LWL_EDGE,0);
	}
}

item script Meteor{
	void run(int dummy, int Damage, int sprite, int num){
		int i;
		lweapon fireball;
		for(i=0;i<=num;i++){
			fireball= FireLWeapon(LW_REFMAGIC,  Rand(32,240),Rand(32,120),
									DegtoRad(90), 0, Damage, sprite, SFX_FALL, LWF_NORMALIZE);
			SetLWeaponMovement(fireball,LWM_FALL,20,LWMF_DIE);
			SetLWeaponDeathEffect(fireball,LWD_SBOMB_EXPLODE,8);
			SetLWeaponFlag2(fireball,LWF_SHADOW);
		}
	}
}



//D0- Weapon type that triggers this.
//D1- Level of weapon.
//    Binary- 1= level one
//            2= level two
//            4= level three
//            8= level four
//D2- Screen->D register to store secrets in.
	
ffc script LWeapon_Index_Trigger{
	void run(int type, int level, int perm, int sfx){
		lweapon thing;
		int i;
		bool triggered = false;
		if(Screen->D[perm]!=0)
			triggered = true;
		while(!triggered){
			for(i = Screen->NumLWeapons();i>0;i--){
				thing = Screen->LoadLWeapon(i);
				if(thing->ID ==type && Collision(this,thing))
					if(level!=0 && ((thing->Misc[LW_ZH_I_FLAGS_2]&level)!=0))
						triggered = true;
					else if(level==0)
						triggered = true;
			}
			Waitframe();
		}
		Screen->TriggerSecrets();
		Screen->State[ST_SECRET]= true;
		Screen->D[perm] = 1;
		if(sfx)
			Game->PlaySound(sfx);
		else
			Game->PlaySound(SFX_SECRET);
	}
}

const int LINK_HOLD_2_COMBO = 32380;

ffc script Large_Item{
	void run(int item_to_give,int width, int height){
		item anitem;
		if(!Screen->State[ST_ITEM]){
			anitem = Screen->CreateItem(item_to_give);
			anitem->X = this->X;
			anitem->Y = this->Y;
		}
		int timer;
		int tile = anitem->OriginalTile;
		int cset = anitem->CSet;
		while(anitem->isValid()){
			anitem->Extend = 3;
			anitem->TileWidth = width;
			anitem->TileHeight = height;
			if(LinkCollision(anitem)){
				anitem->X = Link->X;
				anitem->Y = Link->Y;
				Game->PlaySound(SFX_PICKUP);
				while(timer<30){
					Link->Invisible = true;
					Screen->DrawTile(0, Link->X+8-((width*16)/2), Link->Y-(height*16), 
									tile, width, height, cset, -1, -1, 0, 0, 0, 0, true, 128);	
					Screen->DrawCombo(0, Link->X, Link->Y, LINK_HOLD_2_COMBO, 
									  1, 1, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
					timer++;
					WaitNoAction();
				}
				Link->Invisible = false;
				Screen->State[ST_ITEM]= true;
			}
			Waitframe();
		}
	}
}

item script Bracelet{
	void run(int dummy, int Strength, int damage, int this_id){
		lweapon Carried;
		lweapon Thrown;
		int ComboType;
		int Sprite;
		if(Strength == 1){
			if(NumLWeaponsOf(LW_SCRIPT1)==0){
				if(ComboTypeInFront()== CT_BUSH ||
					ComboTypeInFront()== CT_BUSHNEXT){
					ComboType = Screen->ComboT[ComboLocInFront()];
					Carried= FireLWeapon(LW_SCRIPT1, Link->X,Link->Y-16,
									DegtoRad(270), 0, damage, SPR_BUSH, SFX_HEFT, LWF_PIERCES_ENEMIES);
					SetLWeaponMovement(Carried,LWM_CARRY,ComboType,this_id);
					if(ComboTypeInFront()==CT_BUSH)
						Screen->ComboD[ComboLocInFront()]= Screen->UnderCombo;
					else
						Screen->ComboD[ComboLocInFront()]++;
					Link->Action = LA_ATTACKING;
				}
			}
			else if(NumLWeaponsOf(LW_SCRIPT2)==0){
				Carried = FindLWeaponType(LW_SCRIPT1);
				if(Carried->Misc[LW_ZH_I_MOVEMENT_ARG]== CT_BUSH ||
					Carried->Misc[LW_ZH_I_MOVEMENT_ARG]== CT_BUSHNEXT)
					Sprite = SPR_BUSH;
				RemoveLWeaponType(LW_SCRIPT1);
				Thrown = FireLWeapon(LW_SCRIPT2, Link->X,Link->Y-16, __DirtoRad(Link->Dir), 
									100, damage*Strength, Sprite, SFX_THROW, 0);
				SetLWeaponMovement(Thrown,LWM_THROW,3,LWMF_DIE);
				Link->Action = LA_ATTACKING;
			}
		}
	}
}

const int MAX_ICE_TIME = 600;//Time ice platform exists
const int ICEBLOCK_CSET = 2;//Cset for ice block.

ffc script IceRodFFC{
	void run(int Weapon_ID){
		this->Data = GH_INVISIBLE_COMBO;
		npc current_enemy;
		bool Stop = false;
		bool impact = false;//Tests whether an enemy or freezable combo has been hit.
		//Two variables used to save location of ffc upon impact.
		int impactX;
		int impactY;
		//Increase size of platform for larger enemies.
		int BlockWidth=1;
		int BlockHeight=1;
		int Ice_Timer;//Used internally by ffc to track how long ice combo has existed.
		int i;
		int j;
		lweapon beam = FindMiscLWeapon(Weapon_ID);//Find previously saved lweapon.
		//Position ffc.
		if(beam->isValid()){
			this->X = beam->X;
			this->Y = beam->Y;
		}
		else{
			this->Data = 0;
			Quit();
		}
		while(!Stop){
			while(!impact && this->X>0 && this->Y>0 && this->X<256 && this->Y<170){
				//Adjust the position of the ffc every frame, based on the direction Link was facing when he fired it.
				if(beam->isValid()){
					this->X = beam->X;
					this->Y = beam->Y;
				}
				else{
					this->Data = 0;
					Quit();
				}
				//Update current number of enemies.
				for(i=Screen->NumNPCs();i>0;i--){
					current_enemy = Screen->LoadNPC(i);
					if(current_enemy->HP<=0)break;
					if (Collision(beam,current_enemy)){
						if(current_enemy->Defense[NPCD_SCRIPT]!=NPCDT_IGNORE
							&& (current_enemy->Misc[GEN_MISC_FLAGS]&NPC_F_FREEZE)==0){
							impactX = current_enemy->X;
							impactY = current_enemy->Y;
							BlockWidth = current_enemy->TileWidth;
							BlockHeight = current_enemy->TileHeight;
							//Stun the enemy.
							current_enemy->Stun = MAX_ICE_TIME;
							current_enemy->Misc[GEN_MISC_FLAGS]|=NPC_F_FREEZE;
							impact = true;
							this->Flags[FFCF_OVERLAY]= true;
							this->Flags[FFCF_TRANS] = true;
							if(beam->isValid())
								KillLWeapon(beam);		
						}
						else{
							if(beam->isValid())
								KillLWeapon(beam);
						}
					}
				}
				Waitframe();
			}
			//You've hit an enemy.
			if(impact){
				//Position the ffc.
				this->X = impactX;
				this->Y = impactY;
				//Set up timer.
				Ice_Timer = MAX_ICE_TIME;
			}
			while(Ice_Timer>0){
				Ice_Timer--;
				///if(BlockWidth>1){
					///for(i=impactX;i<(impactX+BlockWidth*16);i+=16)
						///Screen->FastCombo(3,i,impactY,ICE_BLOCK_COMBO,ICEBLOCK_CSET,64);
				//}
				//else
					//Screen->FastCombo(3,impactX,impactY,ICE_BLOCK_COMBO,ICEBLOCK_CSET,64);
				//if(BlockHeight >1){
					for(j= impactY;j<impactY+(BlockHeight*16);j+=16){
						for(i=impactX;i<impactX+(BlockWidth*16);i+=16)
							Screen->FastCombo(3,i,j,ICE_BLOCK_COMBO,ICEBLOCK_CSET,64);	
					}
				//}
				//else
					//Screen->FastCombo(3,impactX,impactY,ICE_BLOCK_COMBO,ICEBLOCK_CSET,64);
				if(Ice_Timer<5){
					if(current_enemy->isValid())
						current_enemy->Misc[GEN_MISC_FLAGS]&=~NPC_F_FREEZE;
					Stop = true;
					break;
				}
				Waitframe();
			}
			Waitframe();	
		}
		this->Data = 0;
		Quit();
	}
}

const int SPR_SPEAR_RT = 108;
const int SPR_SPEAR_UP = 105;

//D0- Blank so other scripts can use item
//D1- Damage done by item.
//D2- Sound made when using item

item script Spear{
	void run(int dummy, int Damage, int sfx){
		if(NumLWeaponsOf(LW_SCRIPT10)==0){
			lweapon spear;
			if(Link->Dir==DIR_UP)
				spear = FireBigLWeapon(LW_SCRIPT10, Link->X, Link->Y-32, 
										__DirtoRad(Link->Dir), 0, Damage, 
										SPR_SPEAR_UP, sfx, LWF_PIERCES_ENEMIES,1,2);
			else if(Link->Dir==DIR_DOWN)
				spear = FireBigLWeapon(LW_SCRIPT10, Link->X, Link->Y+16, 
										__DirtoRad(Link->Dir), 0, Damage, 
										SPR_SPEAR_UP, sfx, LWF_PIERCES_ENEMIES,1,2);
			else if(Link->Dir==DIR_LEFT)
				spear = FireBigLWeapon(LW_SCRIPT10, Link->X-32, Link->Y, 
										__DirtoRad(Link->Dir), 0, Damage, 
										SPR_SPEAR_RT, sfx, LWF_PIERCES_ENEMIES,2,1);
			else if(Link->Dir==DIR_RIGHT)
				spear = FireBigLWeapon(LW_SCRIPT10, Link->X+16, Link->Y, 
										__DirtoRad(Link->Dir), 0, Damage, 
										SPR_SPEAR_RT, sfx, LWF_PIERCES_ENEMIES,2,1);								
			SetLWeaponLifespan(spear,LWL_TIMER,10);
			SetLWeaponMovement(spear,LWM_MELEE,0,LWMF_SLASH|LWMF_REFLECTS_EWPN);
			SetLWeaponDeathEffect(spear,LWD_VANISH,0);
			Link->Action = LA_ATTACKING;
		}
	}
}

const int SPR_HAMMER = 25;

item script Run_Hammer{
	void run(int dummy){
		lweapon hammer = FireLWeapon(LW_REFROCK,Link->X+8, Link->Y+8,
						__DirtoRad(Link->Dir), 0, 5, SPR_HAMMER, 0, LWF_PIERCES_ENEMIES);			
		SetLWeaponLifespan(hammer,LWL_TIMER,30);
		SetLWeaponMovement(hammer,LWM_MELEE,0,LWMF_POUND|LWMF_TRACKER);
		SetLWeaponDeathEffect(hammer,LWD_VANISH,0);
		Game->PlaySound(SFX_HAMMER);
		Link->Action =LA_ATTACKING;
	}
}

item script Ball_And_Chain{
	void run(int dummy,int sprite){
		//Name of the lweapon.
		lweapon mace;
		//Only create if it doesn't already exist.
		if(NumLWeaponsOf(LW_REFFIREBALL)==0){
			//Position it around Link.
			mace= FireLWeapon(LW_REFFIREBALL, Link->X+InFrontX(Link->Dir,2),
									Link->Y+InFrontY(Link->Dir,2), __DirtoRad(Link->Dir), 
									100, 10, sprite, SFX_SWORD, LWF_PIERCES_ENEMIES);
			//Destroyed by solid objects, other than Hookshot Only type.
			SetLWeaponLifespan(mace,LWL_SOLID,CT_HOOKSHOTONLY);
			//Set up circular movement.
			if(mace->Dir==DIR_UP || mace->Dir==DIR_DOWN)
					SetLWeaponMovement(mace, LWM_SINE_WAVE, 6, 4);
			else if(mace->Dir==DIR_LEFT || mace->Dir==DIR_RIGHT)
				SetLWeaponMovement(mace, LWM_SINE_WAVE, 4, 6);
			//Shakes the screen for a second when it dies.
			SetLWeaponDeathEffect(mace,LWD_SHAKES_SCREEN,60);
		}
		Link->Action=LA_ATTACKING;
	}
}

const int SPR_SHOVEL = 102;
const int SFX_SHOVEL  =93;
const int SFX_SHOVEL_CLINK=57;
const int DUG_COMBO =704;
 
item script New_Shovel{
    void run(){
        if(NumLWeaponsOf(LW_REFROCK)==0){
            lweapon mitt= FireScriptedLWeapon(LW_REFROCK, Link->X+InFrontX(Link->Dir,2),
                                                Link->Y+InFrontY(Link->Dir,2), SPR_SHOVEL,
                                                SFX_SHOVEL, 8,LWF_PIERCES_ENEMIES);
            SetLWeaponLifespan(mitt,LWL_TIMER,15);
			SetLWeaponMovement(mitt,LWM_MELEE,0,LWMF_TRACKER);
            SetLWeaponDeathEffect(mitt,LWD_VANISH,0);
            Link->Action = LA_ATTACKING;
            int loc = ComboAt(mitt->X+8,mitt->Y+8);
            if(!Screen->isSolid(mitt->X+8,mitt->Y+8)
				&& Screen->ComboD[loc]!=DUG_COMBO
				&& !ScreenFlagTest(SF_MISC,SF_MISC_SCRIPT3)){
				if(Screen->ComboT[loc]==CT_SCRIPT1){
					if(ComboFI(loc,CF_WHISTLE))
						Screen->ComboD[loc]= Screen->UnderCombo;
					else
						Screen->ComboD[loc]=DUG_COMBO;
					if(Screen->RoomType!=RT_SPECIALITEM ||
						(Screen->RoomType==RT_SPECIALITEM
						&& Screen->State[ST_SPECIALITEM]))
						ItemSetAt(IS_COMBOS,loc);
					else{
						if(ComboFI(loc,CF_DIVEITEM)){
							item theitem = Screen->CreateItem(Screen->RoomData);
							theitem->X= ComboX(loc);
							theitem->Y= ComboY(loc);
							theitem->Pickup |= IP_HOLDUP;
							theitem->Pickup |= IP_ST_SPECIALITEM;
							Screen->ComboF[loc]= 0;
							Screen->ComboI[loc]= 0;
						}					
						else
							ItemSetAt(IS_COMBOS,loc);
					}	
				}
				else{
					Screen->ComboD[loc]=DUG_COMBO;
					ItemSetAt(IS_COMBOS,loc);
				}
			
			}
			else
				Game->PlaySound(SFX_SHOVEL_CLINK);
		}
    }
}

item script Use_Bombchu{
	void run(int dummy, int counter, int bombchu_life){
		if(CountFFCsRunning(BOMBCHU_FFC_SCRIPT)==0){
			Link->Action= LA_ATTACKING;
			if(counter!=0 && Game->Counter[counter]>0){
				Game->Counter[counter]--;
				int Args[8]= {bombchu_life};
				NewFFCScript(BOMBCHU_FFC_SCRIPT, Args);
			}
			else if(counter==0){
				int Args[8]= {bombchu_life};
				NewFFCScript(BOMBCHU_FFC_SCRIPT, Args);
			}
		}
	}
}

const int BOMBCHU_FFC_SCRIPT = 66;
const int BOMB_CHU_ACTIVE_TILE = 63692;

ffc script Bombchu_FFC{
	void run(int timer){
		this->Data=GH_INVISIBLE_COMBO;
		this->X= Link->X+InFrontX(Link->Dir,2);
		this->Y= Link->Y+InFrontY(Link->Dir,2);
		lweapon bombchu = FireLWeapon(LW_SCRIPT10, this->X, this->Y, __DirtoRad(Link->Dir), 
								100, 10, SPR_NULL, SFX_PLACE, 0);
		SetLWeaponLifespan(bombchu,LWL_TIMER,timer);
		SetLWeaponDeathEffect(bombchu,LWD_EXPLODE,10);
		int tile;
		int flip;
		if(Link->Dir==DIR_UP)
			tile = BOMB_CHU_ACTIVE_TILE;
		else if(Link->Dir==DIR_DOWN){
			tile = BOMB_CHU_ACTIVE_TILE;
			flip= FLIP_V;
		}
		else if(Link->Dir==DIR_LEFT){
			tile = BOMB_CHU_ACTIVE_TILE+1;
			flip = FLIP_H;
		}
		else
			tile = BOMB_CHU_ACTIVE_TILE+1;
		while (bombchu->isValid()){
			//Move ffc to match input.
			if(Link->InputUp && this->Y >1 
				&& !Screen->isSolid(this->X+8,this->Y-2)){
				Link->InputUp = false;
				Link->PressUp = false;
				this->Y-=2;
				tile = BOMB_CHU_ACTIVE_TILE;
				flip = FLIP_NO;
			}
			else if(Link->InputDown && this->Y <170
					&& !Screen->isSolid(this->X+8,this->Y+2)){
				Link->InputDown = false;
				Link->PressDown = false;
				this->Y+=2;
				tile = BOMB_CHU_ACTIVE_TILE;
				flip= FLIP_V;
			}
			else if(Link->InputRight && this->X<255
					&& !Screen->isSolid(this->X+18,this->Y+8)){
				Link->InputRight = false;
				Link->PressRight = false;
				this->X+=2;
				tile = BOMB_CHU_ACTIVE_TILE+1;
				flip = FLIP_NO;
			}
			else if(Link->InputLeft && this->X>1
					&& !Screen->isSolid(this->X-2,this->Y+8)){
				Link->InputLeft = false;
				Link->PressLeft = false;
				this->X-=2;
				tile = BOMB_CHU_ACTIVE_TILE+1;
				flip = FLIP_H;
			}
			bombchu->X= this->X;
			bombchu->Y= this->Y;
			Screen->DrawTile(2,this->X,this->Y,tile,1,1,8,-1,-1,0,0,0,flip,true,128);
			Waitframe();
		}
	}
}

item script Scripted_Shield{
	void run(int dummy, int sprite, int sfx, int script_id, int Button_A){
		if(CountFFCsRunning(script_id)==0){
			int args[8]= {sprite,sfx,Button_A};
			NewFFCScript(script_id,args);
		}		
	}
}

ffc script Held_Shield{
	void run(int sprite, int sfx, int Button_A){
		lweapon shield = FireLWeapon(LW_SCRIPT1,Link->X,Link->Y,__DirtoRad(Link->Dir),
										0,0,sprite,sfx,LWF_PIERCES_ENEMIES);
		SetLWeaponMovement(shield,LWM_STRAFE,Link->Dir,LWSF_ALL);
		SetLWeaponDeathEffect(shield,LWD_VANISH,0);
		SetLWeaponFlag2(shield,LWF_NO_COLLISION);
		while((Link->InputA && Button_A) ||
				(Link->InputB && !Button_A))
				Waitframe();
		KillLWeapon(shield);
	}
}	

item script Bouncy_Ball{
	void run(int dummy, int sprite, int sfx, int VX, int VY){
		if(NumLWeaponsOf(LW_SCRIPT1)==0){
			lweapon ball = FireLWeapon(LW_SCRIPT1,Link->X,Link->Y,__DirtoRad(Link->Dir),
											0,0,sprite,0,0);
			SetLWeaponSFX(ball,sfx,0);
			SetLWeaponMovement(ball,LWM_CAROM,VX,VY);
			SetLWeaponDeathEffect(ball,LWD_VANISH,0);
		}
	}
}