//Other Lweapons stuff

void SetLWeaponSFX(lweapon wpn, int type, int arg){
	wpn->Misc[LW_ZH_I_FX]= type;
	wpn->Misc[LW_ZH_I_WORK_2]= arg;
}

//Set up the lweapon and ffc to track one another.

void SetLWeaponScript(lweapon wpn, int script_num, int Misc_Num){
	wpn->Misc[LW_ZH_I_WORK_3]= Misc_Num;//Save a specific number.
	//Send that number to the ffc.
	int Args[8]= {Misc_Num};
	NewFFCScript(script_num,Args);
}

void SetLWeaponItemSet(lweapon wpn, int item_set){
	wpn->Misc[LW_ZH_I_WORK_3]= item_set;
}

// Draw a shadow under an lweapon
void __DrawLWeaponShadow(lweapon wpn)
{
    
    int x=CenterX(wpn)-8+wpn->DrawXOffset;
    int y=wpn->Y+(wpn->TileHeight-1)*16+wpn->DrawYOffset-wpn->DrawZOffset;
	int tile;
	if(wpn->TileWidth>1 || wpn->TileHeight>1)
		tile = LW_LARGE_SHADOW_TILE;
	else
		tile = LW_SHADOW_TILE;
    if(LW_SHADOW_TRANSLUCENT>0)
        Screen->DrawTile(1, x, y, tile,wpn->TileWidth,wpn->TileHeight, 
							GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, 64);
    else
        Screen->DrawTile(1, x, y, tile,wpn->TileWidth,wpn->TileHeight, 
							GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, 128);
}

//Returns the right index in Npc->Defense for a lweapon type.

int LWDefense(int type){
	if(type==LW_ARROW)return NPCD_ARROW;
	else if(type == LW_BEAM)return NPCD_BEAM;
	else if(type == LW_BRANG)return NPCD_BRANG;
	else if(type == LW_BOMBBLAST)return NPCD_BOMB;
	else if(type == LW_SBOMBBLAST)return NPCD_SBOMB;
	else if(type == LW_FIRE)return NPCD_FIRE;
	else if(type == LW_MAGIC)return NPCD_MAGIC;
	else if(type == LW_REFBEAM)return NPCD_REFBEAM;
	else if(type == LW_REFMAGIC)return NPCD_REFMAGIC;
	else if(type == LW_REFFIREBALL)return NPCD_REFFIREBALL;
	else if(type == LW_REFROCK)return NPCD_REFROCK;
	else if(type == LW_HOOKSHOT)return NPCD_HOOKSHOT;
	else if(type == LW_WAND)return NPCD_WAND;
	else if(type == LW_SWORD)return NPCD_SWORD;
	else if(type == LW_HAMMER)return NPCD_HAMMER;
	else if(type == LW_CANEOFBYRNA)return NPCD_BYRNA;
	else if(Between(type,LW_SCRIPT1,LW_SCRIPT10))return NPCD_SCRIPT;
}

//Calculate average distance.

//D0- First coordinate
//D1- Second coordinate
//D2- Divisor

int Calc(int x1, int x2, int numParts){
	return (Abs(x1-x2))/numParts;
}

//Returns what combo types block this LWeapon

int LWBlockType(lweapon wpn){
	if(wpn->ID==LW_MAGIC)return CT_BLOCKMAGIC;
	else if(wpn->ID==LW_BEAM)return CT_BLOCKSWORDBEAM;
    else if(wpn->ID==LW_ARROW){
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)return CT_BLOCKARROW1;
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)return CT_BLOCKARROW2;
		else 
			return CT_BLOCKARROW3;
	}
	else if(wpn->ID==LW_BRANG){
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0) return CT_BLOCKBRANG1;
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)return CT_BLOCKBRANG2;
	    else
			return CT_BLOCKBRANG3;
	}
	else
		return CT_BLOCKALL;
}

//Returns the combo type that blocks an lweapon. Uses for dual lweapons.

int LWBlockType(int wpn_id,lweapon wpn){
	if(wpn_id==LW_MAGIC)return CT_BLOCKMAGIC;
	else if(wpn_id==LW_BEAM)return CT_BLOCKSWORDBEAM;
    else if(wpn_id==LW_ARROW){
		if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_1)!=0)return CT_BLOCKARROW1;
		else if((wpn->Misc[LW_ZH_I_FLAGS_2]&LWF_LEVEL_2)!=0)return CT_BLOCKARROW2;
		else 
			return CT_BLOCKARROW3;
	}
	else
		return CT_BLOCKALL;
}

//Find X center of a lweapon.

int CenterWpnX(lweapon wpn){
	int x = wpn->X+wpn->HitXOffset;
	x+=(wpn->HitWidth/2);
	return x;
}

//Find Y center of a lweapon.

int CenterWpnY(lweapon wpn){
	int y = wpn->Y+wpn->HitYOffset;
	y+=(wpn->HitHeight/2);
	return y;
}

//Returns combo type in front of Link.

int ComboLocInFront(){
	if(Link->Dir==DIR_UP)
		return ComboAt(Link->X,Link->Y-8);
	else if(Link->Dir==DIR_DOWN)
		return ComboAt(Link->X,Link->Y+16);
	else if(Link->Dir==DIR_LEFT)
		return ComboAt(Link->X-16,Link->Y+8);
	else if(Link->Dir==DIR_RIGHT)
		return ComboAt(Link->X+16,Link->Y+8);
}

//Returns combo type in front of Link.

int ComboTypeInFront(){
	if(Link->Dir==DIR_UP)
		return Screen->ComboT[ComboAt(Link->X,Link->Y-8)];
	else if(Link->Dir==DIR_DOWN)
		return Screen->ComboT[ComboAt(Link->X,Link->Y+16)];
	else if(Link->Dir==DIR_LEFT)
		return Screen->ComboT[ComboAt(Link->X-16,Link->Y+8)];
	else if(Link->Dir==DIR_RIGHT)
		return Screen->ComboT[ComboAt(Link->X+16,Link->Y+8)];
}

//Counts number of Lweapons with a certain flag set.

int NumMiscLWeapons(int index,int flag){
	int ret;
	for(int i = Screen->NumLWeapons();i>0;i--){
		lweapon wpn = Screen->LoadLWeapon(i);
		if((wpn->Misc[index]&flag)!=0)
			ret++;
	}
	return ret;
}

int NumMoveLWeapons(int type){
	int ret;
	for(int i = Screen->NumLWeapons();i>0;i--){
		lweapon wpn = Screen->LoadLWeapon(i);
		if(wpn->Misc[LW_ZH_I_MOVEMENT]==type)
			ret++;
	}
	return ret;
}

//Combo Type at weapon location.

int ComboTAtWpn(lweapon wpn){
	return Screen->ComboT[ComboAt(CenterWpnX(wpn),CenterWpnY(wpn))];
}

//Onscreen Location of weapon

int WeaponXLoc(lweapon wpn){
	return ComboX(ComboAt(CenterWpnX(wpn),CenterWpnY(wpn)));
}

int WeaponYLoc(lweapon wpn){
	return ComboY(ComboAt(CenterWpnX(wpn),CenterWpnY(wpn)));
}

//Returnss an lweapon with a particular movement type.

lweapon FindLWeaponMove(int type){
	for(int i = Screen->NumLWeapons();i>0;i--){
		lweapon wpn = Screen->LoadLWeapon(i);
		if(wpn->Misc[LW_ZH_I_MOVEMENT]==type)
			return wpn;
	}
}

bool ComboFIAtWpn(lweapon wpn,int flag){
	return (ComboFI(ComboAt(wpn->X + 3, wpn->Y + 3),flag)
	|| ComboFI(ComboAt(wpn->X + 8, wpn->Y + 3),flag)
	|| ComboFI(ComboAt(wpn->X + 13, wpn->Y + 3),flag)
	|| ComboFI(ComboAt(wpn->X + 3, wpn->Y + 8),flag)
	|| ComboFI(ComboAt(wpn->X + 8, wpn->Y + 8),flag)
	|| ComboFI(ComboAt(wpn->X + 13, wpn->Y + 8),flag)
	|| ComboFI(ComboAt(wpn->X + 3,wpn->Y + 13),flag)
	|| ComboFI(ComboAt(wpn->X + 8, wpn->Y + 13),flag)
	|| ComboFI(ComboAt(wpn->X + 13, wpn->Y + 13),flag));
}

bool ComboFITAtWpn(lweapon wpn,int flag,int type){
	return (ComboFIT(ComboAt(wpn->X + 3, wpn->Y + 3),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 8, wpn->Y + 3),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 13, wpn->Y + 3),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 3, wpn->Y + 8),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 8, wpn->Y + 8),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 13, wpn->Y + 8),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 3,wpn->Y + 13),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 8, wpn->Y + 13),flag,type)
	|| ComboFIT(ComboAt(wpn->X + 13, wpn->Y + 13),flag,type));
}

bool ComboTAtWpn(lweapon wpn,int type){
	return ((Screen->ComboT[ComboAt(wpn->X + 3, wpn->Y + 3)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 8, wpn->Y + 3)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 13, wpn->Y + 3)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 3, wpn->Y + 8)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 8, wpn->Y + 8)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 13, wpn->Y + 8)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 3,wpn->Y + 13)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 8, wpn->Y + 13)]==type)
	|| (Screen->ComboT[ComboAt(wpn->X + 13, wpn->Y + 13)]==type));
}