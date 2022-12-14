//General Functions Zelda Header 1.5

//Extra Constants

//Misc Screen Flags

const int SF_MISC_LADDER		 = 0x0001;//Whether ladder is allowed
const int SF_MISC_DIVING		 = 0x0002;//Whether diving is allowed
const int SF_MISC_SCRIPT1        = 0x0004; //General use 1 (Scripts)
const int SF_MISC_SCRIPT2        = 0x0008; //General use 2 (Scripts)
const int SF_MISC_SCRIPT3        = 0x0010; //General use 3 (Scripts)
const int SF_MISC_SCRIPT4        = 0x0020; //General use 4 (Scripts)
const int SF_MISC_SCRIPT5        = 0x0040; //General use 5 (Scripts)

//Scripted Lens Constants

const int INVISIBLE_MISC_INDEX 	= 0;//Used by scripted lens. Stores combo to draw.
const int DRAWN_MISC_INDEX 		= 1;//Used by scripted lens. Tells whether or not to draw enemy.
const int LENS_RADIUS 			= 60;//Width of scripted lens aperture.

//LW_ZH bools

//Test if one location is between two others.
//D0- Location to test
//D1- Lower bound
//D2- Higher bound

bool Between(int loc,int greaterthan, int lessthan){
	if(loc>=greaterthan && loc<=lessthan)return true;
	return false;
}

//Randomly set a bool's value to true or false.

bool ChooseBool() {
	if (Rand(0,1)==0) return true;
	else return false;
}

//Checks for matching combo flag and type.

//D0- On scren location.
//D1- Combo Flag to check.
//D2- Combo Type to check.

bool ComboFIT(int loc,int flag,int type){
	if(ComboFI(loc,flag)&& Screen->ComboT[loc]==type)return true;
	return false;
}

//Checks for matching combo flag and type.

//D0- On scren location.
//D1- Combo Flag to check.
//D2- Combo Type to check.

bool ComboFIT(int X, int Y,int flag,int type){
	int loc = ComboAt(X,Y);
	if(ComboFI(loc,flag)&& Screen->ComboT[loc]==type)return true;
	return false;
}

//Test if a combo is a certain type.

bool ComboT(int X, int Y, int type){
	int loc = ComboAt(X,Y);
	return (Screen->ComboT[loc]==type);
}

//Test if a combo is a certain type.

bool ComboT(int loc, int type){
	return (Screen->ComboT[loc]==type);
}

//Test if a combo has a certain placed flag.

bool ComboF(int X, int Y, int flag){
	int loc = ComboAt(X,Y);
	return (Screen->ComboF[loc]==flag);
}

//Test if a combo has a certain placed flag.

bool ComboF(int loc, int flag){
	return (Screen->ComboF[loc]==flag);
}

//Test if a combo has a certain placed flag.

bool ComboI(int X, int Y, int flag){
	int loc = ComboAt(X,Y);
	return (Screen->ComboI[loc]==flag);
}

//Test if a combo has a certain placed flag.

bool ComboI(int loc, int flag){
	return (Screen->ComboI[loc]==flag);
}

bool IsScriptedWater(int loc){
	return ComboFIT(loc,CF_SCRIPT1,CT_WALKSLOW);
}

bool IsScriptedWater(int X, int Y){
	return ComboFIT(X,Y,CF_SCRIPT1,CT_WALKSLOW);
}

//Checks if a screen flag has been toggled.

//D0- Category of flag
//D1- Actual flag, in hex.

bool ScreenFlagTest(int category,int flag){
	return Screen->Flags[category]&flag;
}

//Uses to make a boss using the Gen_Explode_Waitframe wait for a certain number of frames before doing something.

void Gen_Explode_Waitframes(ffc this, npc ghost,int frames){
	for(;frames>0;frames--){
		Gen_Explode_Waitframe(this,ghost);
	}
}    
                   
//A general utility function to make a boss explode on death.

void Gen_Explode_Waitframe(ffc this, npc ghost){
     if(!Ghost_Waitframe(this, ghost, false, false)){
	   Ghost_DeathAnimation(this, ghost, 2);
	   Quit();
     }
}

//General utility function for spawning another enemy when the main one dies.
//Has same effects as Gen_Explode_Waitframe.
//Set the original enemy's Misc 1 attribute to what enemy to spawn.
//If no enemy is to be spawned, leave it at zero.

void Gen_Spawn_Waitframe(ffc this, npc ghost){
	if(!Ghost_Waitframe(this, ghost, false, false)){
	   Ghost_DeathAnimation(this, ghost, 2);
	   int EnemyToSpawn = Ghost_GetAttribute(ghost,0,0);
	   if(EnemyToSpawn!=0){
			npc n = Screen->CreateNPC(EnemyToSpawn);
			n->X = ghost->X;
			n->Y = ghost->Y;
	   }
	   Quit();
	}
}

void Gen_Spawn_Waitframes(ffc this, npc ghost, int frames){
	for(;frames>0;frames--)
		Gen_Spawn_Waitframe(this,ghost);
}

//Kills all npcs on screen when this enemy dies.

void Gen_Leader_Waitframe(ffc this, npc ghost){
	 if(!Ghost_Waitframe(this, ghost, false, false)){
	   Ghost_DeathAnimation(this, ghost, 2);
	   for(int i =Screen->NumNPCs();i>0;i--){
			npc n = Screen->LoadNPC(i);
			n->HP = 0;
	   }
	   Quit();
     }
}

void Gen_Leader_Waitframes(ffc this, npc ghost, int frames){
	for(;frames>0;frames--)
		Gen_Leader_Waitframe(this,ghost);
}
	
//A function to adjust an eweapon's hitbox size.
//D0- Eweapon to adjust
//D1- HitWidth
//D2- HitHeight
//D3- HitXOffset
//D4- HitYOffset

void SetEWeaponHitbox(eweapon wpn, int HitWidth, int HitHeight, int HitXOffset, int HitYOffset){
	wpn->HitHeight = HitHeight;
	wpn->HitWidth = HitWidth;
	wpn->HitXOffset = HitXOffset;
	wpn->HitYOffset = HitYOffset;
}	

//A function to quickly change the size of an eweapon.
//D0- EWeapon to adjust.
//D1- Tile Width
//D2- Tile Height

void SetEWeaponSize(eweapon wpn, int TileWidth, int TileHeight){
	wpn->Extend = 3;
	wpn->TileHeight = TileHeight;
	wpn->TileWidth = TileWidth;
}

//A function to change the current combo at a location.
//Changes id, cset and type.

//D0- Location to change.
//D1- Combo Id to change to.
//D2- Combo Cset to change to.
//D3- Combo Type to change to.

void ChangeCombo(int loc, int comboid, int cset, int type){
	if(comboid>-1)Screen->ComboD[loc] = comboid;
	if(cset>-1)Screen->ComboC[loc]= cset;
	if(type>-1)Screen->ComboT[loc] = type;
}

//D0- Location to change.
//D1- Combo Id to change to.
//D2- Combo Cset to change to.
//D3- Combo Type to change to.
//D4- Placed flag to change to.

void ChangeCombo(int loc, int comboid,int cset,int type, int flag){
	if(comboid>-1)Screen->ComboD[loc] = comboid;
	if(cset>-1)Screen->ComboC[loc]= cset;
	if(type>-1)Screen->ComboT[loc] = type;
	if(flag>-1)Screen->ComboF[loc] = flag;
}

//D0- Location to change.
//D1- Combo Id to change to.
//D2- Combo Cset to change to.
//D3- Combo Type to change to.
//D4- Placed flag to change to.
//D5- Inherent flag to change to.

void ChangeCombo(int loc, int comboid,int cset,int type, int flag, int inh_flag){
	if(comboid>-1)Screen->ComboD[loc] = comboid;
	if(cset>-1)Screen->ComboC[loc]= cset;
	if(type>-1)Screen->ComboT[loc] = type;
	if(flag>-1)Screen->ComboF[loc] = flag;
	if(inh_flag>-1)Screen->ComboI[loc] = inh_flag;
}

//A function to quickly change the size of an npc.
//D0- Npc to adjust.
//D1- Tile Width
//D2- Tile Height

void EnemyResize(npc enemy, int TileWidth, int TileHeight){
	enemy->Extend = 3;
	enemy->TileHeight = TileHeight;
	enemy->TileWidth = TileWidth;
}

//A function to adjust an enemy's hitbox size.
//D0- Enemy to adjust
//D1- HitWidth
//D2- HitHeight
//D3- HitXOffset
//D4- HitYOffset

void SetEnemyHitbox(npc enemy, int HitWidth, int HitHeight, int HitXOffset, int HitYOffset){
	enemy->HitHeight = HitHeight;
	enemy->HitWidth = HitWidth;
	enemy->HitXOffset = HitXOffset;
	enemy->HitYOffset = HitYOffset;
}

//Combines enemy reaize and enemy set hitbox functions.

//D0- Enemy to set.
//D1- Tile width. Hit Width will be this times 16.
//D2- Tile Height. Hit height will be this times 16.

void Enemy_ExtendSimple(npc enemy,int TileWidth,int TileHeight){
	EnemyResize(enemy,TileWidth,TileHeight);
	SetEnemyHitbox(enemy,TileWidth*16,TileHeight*16,0,0);
}

//Draw an inverted circle (fill whole screen except circle)
//Also draws an enemy if it is invisible and ghosted.
void InvertedLensCircle(int bitmapID, int layer, int x, int y, int radius, int scale, int fillcolor,npc ghost){
    Screen->SetRenderTarget(bitmapID);     //Set the render target to the bitmap.
    Screen->Rectangle(layer, 0, 0, 256, 176, fillcolor, 1, 0, 0, 0, true, 128); //Cover the screen
	Screen->Circle(layer, x, y, radius, 0, scale, 0, 0, 0, true, 128); //Draw a transparent circle.
    if(ghost->Dir==DIR_UP||ghost->Dir==DIR_LEFTUP)Screen->DrawCombo(layer, ghost->X, ghost->Y, ghost->Misc[INVISIBLE_MISC_INDEX], ghost->TileWidth, ghost->TileHeight, ghost->Attributes[8], -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
	else if(ghost->Dir==DIR_DOWN ||ghost->Dir== DIR_RIGHTDOWN)Screen->DrawCombo(layer, ghost->X, ghost->Y, ghost->Misc[INVISIBLE_MISC_INDEX]+1, ghost->TileWidth, ghost->TileHeight, ghost->Attributes[8], -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
	else if(ghost->Dir==DIR_LEFT||ghost->Dir== DIR_LEFTDOWN)Screen->DrawCombo(layer, ghost->X, ghost->Y, ghost->Misc[INVISIBLE_MISC_INDEX]+2, ghost->TileWidth, ghost->TileHeight, ghost->Attributes[8], -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
	else if(ghost->Dir==DIR_RIGHT||ghost->Dir== DIR_RIGHTUP)Screen->DrawCombo(layer, ghost->X, ghost->Y, ghost->Misc[INVISIBLE_MISC_INDEX]+3, ghost->TileWidth, ghost->TileHeight, ghost->Attributes[8], -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
	Screen->SetRenderTarget(RT_SCREEN); //Set the render target back to the screen.
    Screen->DrawBitmap(layer, bitmapID, 0, 0, 256, 176, 0, 0, 256, 176, 0, true); //Draw the bitmap
}

//Draws scripted enemies with scripted lens.

void Drawn_Enemy_Waitframe(ffc this, npc ghost){
	if(Ghost_Waitframe(this,ghost,false,false)){
		if(ghost->Misc[DRAWN_MISC_INDEX]==1)InvertedLensCircle(4, 6, CenterLinkX(), CenterLinkY(), LENS_RADIUS, 1, 15,ghost);
	}
	else if(!Ghost_Waitframe(this, ghost, false, false)){
	   Ghost_DeathAnimation(this, ghost, 2);
	   Quit();
    }
}

//Same as above, but multiple frames.

void Drawn_Enemy_Waitframes(ffc this,npc ghost,int frames){
	for(;frames>0;frames--)
		Drawn_Enemy_Waitframe(this,ghost);
}

//Removes a specific eweapon type.

void RemoveEWeaponType(int type){
	for(int i = Screen->NumEWeapons();i>0;i--){
		eweapon e = Screen->LoadEWeapon(i);
		if(e->ID==type)Remove(e);
	}
}

//Traces Current Dmap and Screen numbers.

void TraceDMapScreen(){
	int DMAP[]= "The current DMap number is ";
	int SCREEN[]= "The current screen number is ";
	TraceS(DMAP);
	Trace(Game->GetCurDMap());
	TraceNL();
	TraceS(SCREEN);
	Trace(Game->GetCurDMapScreen());
}

//Sets an index of an array to equal a value.
void SetArrayIndex(int TheArray, int index,int value){
	TheArray[index]=value;
}

//Add or subtract amount from array index
void AdjustArrayIndex(int TheArray,int index, int amount){
	TheArray[index]+=amount;
}

//Multiply array index by amount.
void MultiplyArrayIndex(int TheArray,int index, int amount){
	TheArray[index]*=amount;
}

//Divide array index by amount.
void DivideArrayIndex(int TheArray,int index, int amount){
	TheArray[index]/=amount;
}

void Align_FFC(ffc this){
	if(this->X%16>7)
		this->X = GridX(this->X +8);
	else
		this->X = GridX(this->X);
	if(this->Y%16>7)
		this->Y = GridY(this->Y +8);
	else
		this->Y = GridY(this->Y);
}

//Calculates Average distance between two points, for a certain number of times.

//D0- First X or Y.
//D1- Second X or Y.
//D2- Number of times to divide.

int CalcXY(int XY1,int XY2, int NumberOfParts){
	return (Abs(XY1-XY2))/NumberOfParts;
}

int CalcX(int X1,int X2, int NumberOfParts){
	return (Abs(X1-X2))/NumberOfParts;
}

int CalcY(int Y1,int Y2, int NumberOfParts){
	return (Abs(Y1-Y2))/NumberOfParts;
}

//Returns the correct offset to be 'dist' pixels away from the front of a sprite facing in the direction 'dir'

int FixedInFrontX(int dir, int dist) {
	int x = 0;
	if(dir == DIR_LEFT) x = -dist;
	else if(dir == DIR_RIGHT) x = dist;
	return x;
}

int FixedInFrontY(int dir, int dist){
	int y = 0;
	if(dir == DIR_UP) y = -dist;
	else if(dir == DIR_DOWN) y = 16+dist;
	return y;
}

int TrueFixedInFrontY(int dir, int dist){
	int y = 0;
	if(dir == DIR_UP) y = -dist;
	else if(dir == DIR_DOWN) y = dist;
	return y;
}

//Returns the first non-zero index of an array.
int GetFirstUsedIndex(int TheArray){
	int index;
	int size = SizeOfArray(TheArray);
	for(index=0;index<size;index++){
		if(TheArray[index]!=0)
			return index;
	}
}

//Returns the last non-zero index of an array.
int GetLastUsedIndex(int TheArray){
	int index;
	int size = (SizeOfArray(TheArray)-1);
	for(index=size;index>0;index--){
		if(TheArray[index]!=0)
			return index;
	}
}

//Returns number of used indices in an array.
int GetNumUsedIndices(int TheArray){
	int index;
	int size = SizeOfArray(TheArray);
	int ret;
	for(index=0;index<size;index++){
		if(TheArray[index]!=0)
			ret++;
	}
	return ret;
}

//Returns number of unused indices in an array.
int GetNumUnusedIndices(int TheArray){
	int index;
	int size = SizeOfArray(TheArray);
	int ret;
	for(index=0;index<size;index++){
		if(TheArray[index]==0)
			ret++;
	}
	return ret;
}

//Determines the value stored in an index of an array.
int GetIndexValue(int TheArray, int index){
	return TheArray[index];
}

//Retrieves combo data from a remote screen.

//D0- Map (not DMap) to look at.
//D1- Screen to look at.
//D2- Combo Position to look at.

int GetRemoteComboD(int map, int screen, int position){
	return Game->GetComboData(map, screen, position);
}

// Determines how much percent of a whole number another is,
// D0- Number to check.
// D1- Whole amount.

float PercentOfWhole(int number, int whole){
	float x;
	x= (100*number)/whole;
	return x;
}

//Determines what number is a certain percent of a whole.
// D0- Percent to find.
// D1- Whole Amount

float PartOfWhole(int percent, int whole){
	float x;
	x = (percent* whole)/100;
	return x;
}