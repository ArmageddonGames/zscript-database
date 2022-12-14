//Functions used by LWeapons.zh that may be included with other headers.
//Preserved to allow internal functionality.

//Checks if one is true and the other is false.

bool __Xor(bool A, bool B){
	if((A&&!B)||(B&&!A))
		return true;
	return false;
}

// Returns true if FFC collides with a combo which has specific placed flag
bool ComboFlagCollision (int loc, int flag, lweapon l){
	if (ComboFI(loc,flag)){
		if (ComboCollision(loc, l->X,l->Y,l->X+16,l->Y+16)) return true;
	}
	return false;
}

// Returns true if FFC collides with a combo which has specific placed flag
bool ComboFlagCollision (int loc, int flag, int type,lweapon l){
	if (ComboFIT(loc,flag,type)){
		if (ComboCollision(loc, l->X,l->Y,l->X+16,l->Y+16)) return true;
	}
	return false;
}

// Returns TRUE if there is a collision between the combo and an arbitrary rectangle.
// From stdWeapons.
bool ComboCollision (int loc, int x1, int y1, int x2, int y2){
	return RectCollision( ComboX(loc), ComboY(loc), (ComboX(loc)+16), (ComboY(loc)+16), x1, y1, x2, y2);
}

bool ComboCollision(int loc, lweapon wpn){
	int wpnX = wpn->X+wpn->HitXOffset;
	int wpnY = wpn->Y+wpn->HitYOffset;
	int wpnXWidth = wpnX+wpn->HitWidth;
	int wpnYHeight = wpnY+wpn->HitHeight;
	return ComboCollision (loc, wpnX, wpnY, wpnXWidth, wpnYHeight);
}

bool ComboCollision(lweapon wpn, int loc){
	return ComboCollision(loc,wpn);
}

//Check if you're using an item.

bool PressButtonItem(int itm){
	if(GetEquipmentA()==itm&&Link->PressA)return true;
	else if(GetEquipmentB()==itm&&Link->PressB)return true;
	return false;
}

bool InputButtonItem(int itm){
	if(GetEquipmentA()==itm&&Link->InputA)return true;
	else if(GetEquipmentB()==itm&&Link->InputB)return true;
	return false;
}

//Returns true if a weapon is on screen.

//Returns TRUE, if lweapon is inside screen boundaries.
bool OnScreen (lweapon wpn){
	int lwx = wpn->X + wpn->HitXOffset;
	int lwy = wpn->Y + wpn->HitYOffset;
	if (lwx<0-wpn->HitWidth) return false;
	if (lwy<0-wpn->HitHeight) return false;
	if (lwx>256) return false;
	if (lwy>176) return false;
	return true;
}

//Returns TRUE, if lweapon is inside screen boundaries.
bool OnScreen (eweapon wpn){
	int lwx = wpn->X + wpn->HitXOffset;
	int lwy = wpn->Y + wpn->HitYOffset;
	if (lwx<0-wpn->HitWidth) return false;
	if (lwy<0-wpn->HitHeight) return false;
	if (lwx>256) return false;
	if (lwy>176) return false;
	return true;
}

//Returns TRUE, if lweapon is inside screen boundaries.
bool OnScreen (ffc wpn){
	int lwx = wpn->X;
	int lwy = wpn->Y;
	if (lwx<0-wpn->EffectWidth) return false;
	if (lwy<0-wpn->EffectHeight) return false;
	if (lwx>256) return false;
	if (lwy>176) return false;
	return true;
}

//Returns TRUE, if lweapon is inside screen boundaries.
bool OnScreen (npc wpn){
	int lwx = wpn->X + wpn->HitXOffset;
	int lwy = wpn->Y + wpn->HitYOffset;
	if (lwx<0-wpn->HitWidth) return false;
	if (lwy<0-wpn->HitHeight) return false;
	if (lwx>256) return false;
	if (lwy>176) return false;
	return true;
}

//Returns TRUE, if lweapon is touching screen boundaries.
bool OnScreenEdge(lweapon lw){
	int lwx = lw->X + lw->HitXOffset;
	int lwy = lw->Y + lw->HitYOffset;
	if (lw->X<=4)return true;
	if (lw->Y<=4)return true;
	if ((lw->X+lw->HitWidth)>=252)return true;
	if ((lw->Y+lw->HitHeight)>=172)return true;
	return false;
}

//Returns TRUE, if lweapon is inside screen boundaries.
bool InsideScreen (lweapon f){
	int lwx = f->X + f->HitXOffset;
	int lwy = f->Y + f->HitYOffset;
	if (lwx<0-f->HitWidth) return false;
	if (lwy<0-f->HitHeight) return false;
	if (lwx>256) return false;
	if (lwy>176) return false;
	return true;
}

bool CanMove(npc e,int dir,int imprecision){
	int eX = e->X+e->HitXOffset;
	int eY = e->Y+e->HitYOffset;
	int eRtX = eX+e->HitWidth;
	int eBtY = eY+e->HitHeight;
	int eCentX = eX+(e->HitWidth/2);
	int eCentY = eY+(e->HitHeight/2);
	if(dir==DIR_UP){
		if(Screen->isSolid(eCentX,eY-imprecision))return false;
		if(ComboFI(ComboAt(eCentX,eY-imprecision),CF_NOENEMY))return false;
		if(Screen->ComboT[ComboAt(eCentX,eY-imprecision)]==CT_NOENEMY)return false;
	}
	else if(dir==DIR_DOWN){
		if(Screen->isSolid(eCentX,eBtY+imprecision))return false;
		if(ComboFI(ComboAt(eCentX,eBtY+imprecision),CF_NOENEMY))return false;
		if(Screen->ComboT[ComboAt(eCentX,eBtY+imprecision)]==CT_NOENEMY)return false;
	}
	else if(dir==DIR_LEFT){
		if(Screen->isSolid(eX-imprecision,eCentY))return false;
		if(ComboFI(ComboAt(eX-imprecision,eCentY),CF_NOENEMY))return false;
		if(Screen->ComboT[ComboAt(eX-imprecision,eCentY)]==CT_NOENEMY)return false;
	}
	else if(dir==DIR_RIGHT){
		if(Screen->isSolid(eRtX+imprecision,eCentY))return false;
		if(ComboFI(ComboAt(eRtX+imprecision,eCentY),CF_NOENEMY))return false;
		if(Screen->ComboT[ComboAt(eRtX+imprecision,eCentY)]==CT_NOENEMY)return false;
	}
	return true;
}

bool CanMove(ffc e,int dir,int imprecision){
	int eX = e->X;
	int eY = e->Y;
	int eRtX = eX+e->EffectWidth;
	int eBtY = eY+e->EffectHeight;
	int eCentX = eX+(e->EffectWidth/2);
	int eCentY = eY+(e->EffectHeight/2);
	if(dir==DIR_UP){
		if(Screen->isSolid(eCentX,eY-imprecision))return false;
	}
	else if(dir==DIR_DOWN){
		if(Screen->isSolid(eCentX,eBtY+imprecision))return false;
	}
	else if(dir==DIR_LEFT){
		if(Screen->isSolid(eX-imprecision,eCentY))return false;
	}
	else if(dir==DIR_RIGHT){
		if(Screen->isSolid(eRtX+imprecision,eCentY))return false;
	}
	return true;
}

bool CanMove(eweapon e,int dir,int imprecision){
	int eX = e->X+e->HitXOffset;
	int eY = e->Y+e->HitYOffset;
	int eRtX = eX+e->HitWidth;
	int eBtY = eY+e->HitHeight;
	int eCentX = eX+(e->HitWidth/2);
	int eCentY = eY+(e->HitHeight/2);
	if(dir==DIR_UP){
		if(Screen->isSolid(eCentX,eY-imprecision))return false;
		if(Screen->ComboT[ComboAt(eCentX,eY-imprecision)]==CT_BLOCKALL)return false;
	}
	else if(dir==DIR_DOWN){
		if(Screen->isSolid(eCentX,eBtY+imprecision))return false;
		if(Screen->ComboT[ComboAt(eCentX,eBtY+imprecision)]==CT_BLOCKALL)return false;
	}
	else if(dir==DIR_LEFT){
		if(Screen->isSolid(eX-imprecision,eCentY))return false;
		if(Screen->ComboT[ComboAt(eX-imprecision,eCentY)]==CT_BLOCKALL)return false;
	}
	else if(dir==DIR_RIGHT){
		if(Screen->isSolid(eRtX+imprecision,eCentY))return false;
		if(Screen->ComboT[ComboAt(eRtX+imprecision,eCentY)]==CT_BLOCKALL)return false;
	}
	return true;
}

bool CanMove(lweapon e,int dir,int imprecision){
	int eX = e->X+e->HitXOffset;
	int eY = e->Y+e->HitYOffset;
	int eRtX = eX+e->HitWidth;
	int eBtY = eY+e->HitHeight;
	int eCentX = eX+(e->HitWidth/2);
	int eCentY = eY+(e->HitHeight/2);
	if(dir==DIR_UP){
		if(Screen->isSolid(eCentX,eY-imprecision))return false;
		if(Screen->ComboT[ComboAt(eCentX,eY-imprecision)]==CT_BLOCKALL)return false;
	}
	else if(dir==DIR_DOWN){
		if(Screen->isSolid(eCentX,eBtY+imprecision))return false;
		if(Screen->ComboT[ComboAt(eCentX,eBtY+imprecision)]==CT_BLOCKALL)return false;
	}
	else if(dir==DIR_LEFT){
		if(Screen->isSolid(eX-imprecision,eCentY))return false;
		if(Screen->ComboT[ComboAt(eX-imprecision,eCentY)]==CT_BLOCKALL)return false;
	}
	else if(dir==DIR_RIGHT){
		if(Screen->isSolid(eRtX+imprecision,eCentY))return false;
		if(Screen->ComboT[ComboAt(eRtX+imprecision,eCentY)]==CT_BLOCKALL)return false;
	}
	return true;
}

bool __DistX(lweapon a, int distance) {
    int dist;
    if ( a->X > Link->X ) dist = a->X - Link->X;
	else dist = Link->X - a->X;
    return ( dist <= distance );
}

bool __DistY(lweapon a, int distance) {
    int dist;
    if ( a->Y > Link->Y ) dist = a->Y - Link->Y;
	else dist = Link->Y - a->Y;
    return ( dist <= distance );
}

//A collision between an lweapon and an npc.
bool WeaponCollision(lweapon a, npc b) {
  int ax = a->X + a->HitXOffset+1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y + a->HitYOffset+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection || !a->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1)
						&& (a->Z + a->HitZHeight >= b->Z) && (a->Z <= b->Z + b->HitZHeight);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(npc b, lweapon a) {
  int ax = a->X + a->HitXOffset+1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y + a->HitYOffset+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection || !a->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1)
						&& (a->Z + a->HitZHeight >= b->Z) && (a->Z <= b->Z + b->HitZHeight);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(lweapon a, npc b, bool Z_Axis) {
  int ax = a->X + a->HitXOffset+1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y + a->HitYOffset+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection || !a->CollDetection)
	return false;
  if(Z_Axis)
	return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1)
						&& (a->Z + a->HitZHeight >= b->Z) && (a->Z <= b->Z + b->HitZHeight);
  else
	return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(npc b, lweapon a, bool Z_Axis) {
  int ax = a->X + a->HitXOffset+1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y + a->HitYOffset+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection || !a->CollDetection)
	return false;
  if(Z_Axis)
	return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1)
						&& (a->Z + a->HitZHeight >= b->Z) && (a->Z <= b->Z + b->HitZHeight);
  else
	return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(lweapon a, eweapon b) {
  int ax = a->X + a->HitXOffset+1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y + a->HitYOffset+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection || !a->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1)
						&& (a->Z + a->HitZHeight >= b->Z) && (a->Z <= b->Z + b->HitZHeight);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(eweapon b, lweapon a) {
  int ax = a->X + a->HitXOffset+1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y + a->HitYOffset+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection || !a->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->HitWidth-1, ay+a->HitHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1)
						&& (a->Z + a->HitZHeight >= b->Z) && (a->Z <= b->Z + b->HitZHeight);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(eweapon b, ffc a) {
  int ax = a->X +1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->EffectWidth-1, ay+a->EffectHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(ffc a, eweapon b) {
  int ax = a->X +1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->EffectWidth-1, ay+a->EffectHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(lweapon b, ffc a) {
  int ax = a->X +1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->EffectWidth-1, ay+a->EffectHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1);
}

//A collision between an lweapon and an npc.
bool WeaponCollision(ffc a, lweapon b) {
  int ax = a->X +1;
  int bx = b->X + b->HitXOffset+1;
  int ay = a->Y+1;
  int by = b->Y + b->HitYOffset+1;
  if(!b->CollDetection)
	return false;
  return RectCollision(ax, ay, ax+a->EffectWidth-1, ay+a->EffectHeight-1, 
						bx, by, bx+b->HitWidth-1, by+b->HitHeight-1);
}

bool __OnSidePlatform(int x, int y, int xOff, int yOff, int h, int w) {
	for(int i =0;i<=w-1;i++){
		if(Screen->isSolid((x+xOff+i),(y+yOff)+h) 
		    && Screen->Flags[SF_ROOMTYPE]&4)
			return true;
	}
	return false;
}

bool __IsChest(int loc){
	if(Screen->ComboT[loc]==CT_CHEST)
		return true;
	if(Screen->ComboT[loc]==CT_CHEST2)
		return true;
	if(Screen->ComboT[loc]==CT_BOSSCHEST)
		return true;
	if(Screen->ComboT[loc]==CT_BOSSCHEST2)
		return true;
	if(Screen->ComboT[loc]==CT_LOCKEDCHEST)
		return true;
	if(Screen->ComboT[loc]==CT_LOCKEDCHEST2)
		return true;
	return false;
}

//Returns the amount in radians for a direction.

float __DirtoRad(int dir){
	if(dir==DIR_UP)return DegtoRad(270);
	else if(dir==DIR_RIGHTUP)return DegtoRad(315);
	else if(dir==DIR_RIGHT)return DegtoRad(0);
	else if(dir==DIR_RIGHTDOWN)return DegtoRad(45);
	else if(dir==DIR_DOWN)return DegtoRad(90);
	else if(dir==DIR_LEFTDOWN)return DegtoRad(135);
	else if(dir==DIR_LEFT)return DegtoRad(180);
	else if(dir==DIR_LEFTUP)return DegtoRad(225);
}

//Draws a screen specified by 'sourceMap and sourceScreen;, from layers specified by 'layerMin and layerMax', 
//at a desired opacity, to the layer specified by 'destLayer' of the current screen.
void __ScreenToLayer(int sourceMap, int sourceScreen, int layerMin, int layerMax, int drawOpacity, int destLayer){
	for (int i = layerMin; i < layerMax; i++){
		Screen->DrawLayer(destLayer, sourceMap, sourceScreen, i, 0, 0, 0, drawOpacity);
	}
}

//Draws all layers of a screen specified by 'sourceMap and sourceScreen;,
//at a desired opacity, to the layer specified by 'destLayer' of the current screen.
void __ScreenToLayer(int sourceMap, int sourceScreen, int drawOpacity, int destLayer){
	for (int i = 0; i < 6; i++){
		Screen->DrawLayer(destLayer, sourceMap, sourceScreen, i, 0, 0, 0, drawOpacity);
	}
}

int ItemsToPickup[]={	I_ARROWAMMO1, I_ARROWAMMO5, I_ARROWAMMO10, I_ARROWAMMO30,  //Stock arrow ammo.
						I_BOMBAMMO1, I_BOMBAMMO4, I_BOMBAMMO8, I_BOMBAMMO30, //Stock bomb ammo.
						I_FAIRY, I_FAIRYSTILL, I_HEART, I_MAGICJAR1, I_MAGICJAR2, //Stock refills.
						I_CLOCK, //Stock clock item.
						I_RUPEE1, I_RUPEE5, I_RUPEE10, I_RUPEE20, I_RUPEE50, I_RUPEE100, I_RUPEE200, //Stock Rupee Items
						I_KEY, I_LEVELKEY,  //Stock keys.
						I_COMPASS, //Stock Dungeon Compass
						I_MAP, //Stock dungeon map.
						I_BOSSKEY, //Stock dungeon/level master key.
						I_HCPIECE};	

	
//Play a sound every so often.

int __TimedSFX(int timer, int sfx, int freq){
	timer++;
	if(timer>=freq){
		Game->PlaySound(sfx);
		timer = 0;
	}
	return timer;
}
	
int NewFFCScript(int scriptNum, float args){
    // Invalid script
    if(scriptNum<0 || scriptNum>511)
        return 0;
    
    ffc theFFC;
    
    // Find an FFC not already in use
    for(int i=FFCS_MIN_FFC; i<=FFCS_MAX_FFC; i++){
        theFFC=Screen->LoadFFC(i);
        
        if(theFFC->Script!=0 ||
         (theFFC->Data!=0 && theFFC->Data!=FFCS_INVISIBLE_COMBO) ||
         theFFC->Flags[FFCF_CHANGER])
            continue;
        
        // Found an unused one; set it up
        theFFC->Data=FFCS_INVISIBLE_COMBO;
		theFFC->TileWidth = 1;
		theFFC->TileHeight = 1;
        theFFC->Script=scriptNum;
        
        if(args!=NULL){
            for(int j=Min(SizeOfArray(args), 8)-1; j>=0; j--)
                theFFC->InitD[j]=args[j];
        }
        theFFC->Flags[FFCF_ETHEREAL]= true;
        return i;
    }
    
    // No FFCs available
    return 0;
}

//Converts a direction to an angle
int __DirAngle(int Dir){
	if(Dir==DIR_UP)return 270;
	else if(Dir==DIR_DOWN)return 90;
	else if(Dir==DIR_LEFT)return 180;
	else if(Dir==DIR_RIGHT)return 0;
	else if(Dir==DIR_LEFTUP)return 225;
	else if(Dir==DIR_RIGHTUP)return 315;
	else if(Dir==DIR_LEFTDOWN)return 135;
	else if(Dir==DIR_RIGHTDOWN)return 45;
}

ffc NewFFCScriptOrQuit(int scriptNum, float args){
    // Invalid script
    if(scriptNum<0 || scriptNum>511)
        Quit();
    
    int ffcID=NewFFCScript(scriptNum, args);
    if(ffcID==0)
        Quit();
    
    return Screen->LoadFFC(ffcID);
}

// replaces the code in old Pegasus boots function for dash cutting through slashable combos.
// allows easier customization to suit your needs.
void DoDashSlash(int loc){
   int ctype = Screen->ComboT[loc];
   int sprite;
   int itmset = IS_COMBOS; // item set 12 (tall grass by default)
   bool playsound = false;
   // add sprites to certain types
   if(ctype == CT_BUSH || ctype == CT_BUSHNEXT) sprite = SPR_BUSH_CUT;
   else if(ctype == CT_TALLGRASS || ctype == CT_TALLGRASSNEXT) sprite = SPR_GRASS_CUT;
   else if(ctype == CT_FLOWERS) sprite = SPR_FLOWER_CUT;
   // no sprite is typically associated with Slash type combos, but it could be added.
   // itemset is changed here to the default for these types.  could add more item sets based on type
   if(ctype == CT_SLASHITEM || ctype == CT_SLASHNEXTITEM) itmset = 10; // default for these combo types
   //these types default to undercombo
   if(ctype == CT_BUSH || ctype == CT_TALLGRASS || ctype == CT_FLOWERS || ctype == CT_SLASH || ctype == CT_SLASHITEM){
      Screen->ComboD[loc] = Screen->UnderCombo;
      playsound = true;
   }
   //these types default to next combo
   if(ctype == CT_BUSHNEXT || ctype == CT_TALLGRASSNEXT || ctype == CT_FLOWERS || ctype == CT_SLASHNEXT || ctype == CT_SLASHNEXTITEM){
      Screen->ComboD[loc] += 1;
      playsound = true;
   }
   //no functionality added for Continuous type combos.
   if(playsound){
      CreateGraphicAt(sprite,ComboX(loc),ComboY(loc));
      Game->PlaySound(SFX_GRASSCUT);
      ItemSetAt(itmset,loc);
   }//end playsound if
}

// replaces the code in old Pegasus boots function for dash cutting through slashable combos.
// allows easier customization to suit your needs.
void DoDashSlash(int loc, int itmset){
   int ctype = Screen->ComboT[loc];
   int sprite;
   bool playsound = false;
   // add sprites to certain types
   if(ctype == CT_BUSH || ctype == CT_BUSHNEXT) sprite = SPR_BUSH_CUT;
   else if(ctype == CT_TALLGRASS || ctype == CT_TALLGRASSNEXT) sprite = SPR_GRASS_CUT;
   else if(ctype == CT_FLOWERS) sprite = SPR_FLOWER_CUT;
   if(ctype == CT_BUSH || ctype == CT_TALLGRASS || ctype == CT_FLOWERS || ctype == CT_SLASH || ctype == CT_SLASHITEM){
      Screen->ComboD[loc] = Screen->UnderCombo;
      playsound = true;
   }
   //these types default to next combo
   if(ctype == CT_BUSHNEXT || ctype == CT_TALLGRASSNEXT || ctype == CT_FLOWERS || ctype == CT_SLASHNEXT || ctype == CT_SLASHNEXTITEM){
      Screen->ComboD[loc] += 1;
      playsound = true;
   }
   //no functionality added for Continuous type combos.
   if(playsound){
      CreateGraphicAt(sprite,ComboX(loc),ComboY(loc));
      Game->PlaySound(SFX_GRASSCUT);
      ItemSetAt(itmset,loc);
   }//end playsound if
}

void CreateGraphicAt(int sprite, int x, int y){
    eweapon e = Screen->CreateEWeapon(EW_SCRIPT1);
    e->HitXOffset = 500;
    e->UseSprite(sprite);
    e->DeadState = e->NumFrames*e->ASpeed;
    e->X = x;
    e->Y = y;
}

//Handles items generated by slashing combos.
void ItemSetAt(int itemset,int loc){
    npc e = Screen->CreateNPC(NPC_ITEMSET);
    e->ItemSet = itemset;
    if(e->isValid()){
        e->X = loc%16*16;
        e->Y = loc-loc%16;
		e->CollDetection = false;
    }
    e->HP = HP_SILENT;
}
					