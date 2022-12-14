//Miscellenous Constants used by the Deku Leaf.
const int I_DEKULEAF = 123;
const int I_DEKULEAF_LTM = 124;
const float GRAVITY2 = 0.3333;
const int LW_GUST = 31;
const int SFX_WIND1 = 0;
const int SFX_WIND2 = 0;
const int SFX_GLIDE = 0;
const int SFX_LAND = 0;

//Miscellaneous Variables used by the Deku Leaf.
float Link_Z;
int Glide_Time;
int draintimer;
int looptimer;
bool HitGround;

//These constants control how the whirlwind behaves and interacts with other things.
const int DEKU_DECELERATION = 1; //The deceleration in 100th's of a pixel per frame that undergoes the gust of wind.
const int DEKU_SPIN_LINK	= 4; //Whether or not the whirlwinds spin link into the air, also the spin speed in frames per 90 degree rotation.
const int DEKU_SPIN_NPCS	= 4; //Whether or not the whirlwinds spin npcs into the air, also the spin speed in frames per 90 degree rotation.
const int DEKU_GROUND_SPINS = 2; //The number of spins to do while the target is on the ground.
const int DEKU_AIR_SPINS	= 2; //The number of spins to do while the target is mid air.
const int DEKU_SPIN_JUMP	= 5; //The jump force to apply to the target in the whirlwind when it shoots them up in the air.

//These constants control how the deku parachute works.
const int DEKU_MAX_GLIDE_TIME = 60; //This is the max time that parachute can be open.
const int DEKU_CANCELLABLE	= 0;  //Whether or not the deku leaf can be cancelled. 0 = false, 1 = true.
const int DEKU_DRAIN		  = 0;  //This is the speed at which MP is consumed.
const int DEKU_LOOP		   = 0;  //This is the length of the glide sound effect in tics.

//This function should appear in your script file only once.
bool UsedItem(int id){
	return ((GetEquipmentA() == id && Link->PressA) || (GetEquipmentB() == id && Link->PressB));
}

//Combine this global script with your other ones if you want the gliding to work.
global script Slot2{
	void run(){
		//Declare a variable to keep the mp drain rate constant.
		while(true){
			if(Link->Z == 0){
				if(!HitGround) Game->PlaySound(SFX_LAND);
				HitGround = true;
			}
			//Check if Link has the Deku Leaf LTM item.
			if(Link->Item[I_DEKULEAF_LTM]){
				//Increment Glide_Time if it's greater than or equal to 0;
				if(Glide_Time >= 0)  Glide_Time++;
				//Check if DEKU_DRAIN doesn't equal 0.
				if(DEKU_DRAIN != 0){
					//Increment draintimer and wrap it to DEKU_DRAIN. If it equals 0 after all that decrement MP.
					draintimer = (draintimer + 1) % DEKU_DRAIN;
					if(draintimer == 0) Link->MP--;
				}
				//If Glide_Time has reached DEKU_MAX_GLIDE_TIME or MP has reached 0 cancel the gliding by removing the LTM item.
				if(Glide_Time == DEKU_MAX_GLIDE_TIME || Link->MP == 0) Link->Item[I_DEKULEAF_LTM] = false;
				//Otherwise if not scrolling glide down to the ground.
				else if(Link->Action != LA_SCROLLING){
					looptimer = (looptimer + 1) % DEKU_LOOP;
					if(looptimer == 0) Game->PlaySound(SFX_GLIDE);
					DekuGlide();
				}
				//Check if Link just used the DekuLeaf and if so cancel the gliding by removing the LTM item.
				if(UsedItem(I_DEKULEAF) && DEKU_CANCELLABLE) Link->Item[I_DEKULEAF_LTM] = false;
				//Null the A and B buttons to prevent item use.
				Link->InputA = false;
				Link->InputB = false;
			}
			//Waitframe to prevent freezing.
			Waitframe();
		}
	}
	//This function makes it appear that Link is holding the leaf overhead and makes him fall slower.
	void DekuGlide(){
		//Check Link's Z position and if it's less than or equal to 0 cancel the glide by removing the LTM item.
		if(Link->Z <= 0){
			Link_Z = 0;
			Link->Item[I_DEKULEAF_LTM] = 0;
		}
		//Otherwise load the itemdata of the LTM item and use it to draw the leaf on layer 4.
		else{
			itemdata id = Game->LoadItemData(I_DEKULEAF_LTM);
			Screen->FastTile(4, Link->X, Link->Y - Link_Z - 8, (id->InitD[0]*10) + Link->Dir, id->InitD[1], 128);
		}
		//Set Link's Z position to Link_Z and subtract Link_Z by GRAVITY2.
		Link->Z = Link_Z;
		Link_Z -= GRAVITY2;
	}
}

//Deku Leaf item script.
item script DekuLeaf{
	//D0 is the ffcScript Slot number that contains the GustofWind script.
	//D1 is the initial step speed of the whirlwind in 100th's of a pixel per frame.
	//D2 is the sprite used by the whirlwind.
	//D3 is the sound used when a whirlwind is fired.
	//D4 is the lifespan of the whirlwind in frames. Only used when it decelerates.
	void run(int ffcScriptNum, int step, int sprite, int sound, int lifespan){
		//Check if Link is in the air, and if so reset Glide_Time, set Link_Z to Link's Z position, Give him the LTM item and set his action to LA_NONE.
		if(Link->Z > 0){
			if(HitGround){
				HitGround = false;
				Glide_Time = 0;
				draintimer = 0;
				looptimer = 0;
				Link_Z = Link->Z;
				Link->Item[I_DEKULEAF_LTM] = true;
				Game->PlaySound(SFX_GLIDE);
			}
			Link->Action = LA_NONE;
		}
		//Otherwise if no FFC is running the GustofWind script launch one.
		else if(CountFFCsRunning(ffcScriptNum) == 0){
			int args[8] = {step, sprite, sound, lifespan};
			RunFFCScript(ffcScriptNum, args);
		}
	}
}

//GustofWind script for controlling Deku Leaf projectiles.
ffc script GustofWind{
	void run(int step, int sprite, int sound, int lifespan){
		//Create a lweapon next to link.
		lweapon gust = NextToLink(LW_GUST, 0);
		//Set the gust's sprite, step, and direction.
		gust->UseSprite(sprite);
		gust->Step = step;
		gust->Dir = Link->Dir;
		//Play the firing sound.
		Game->PlaySound(sound);
		//Turn off collision for the gust.
		gust->CollDetection = false;
		//Declare a npc pointer, and three variables for controlling the spinning of npcs and Link.
		npc target;
		bool spinning;
		int spintimer;
		float spins;
		//Loop until the wind either goes offscreen or step reaches 0.
		while(gust->isValid() && lifespan){
			//Draw the gust to layer 3.
			DrawToLayer(gust, 3, 128);
			//Check if it can move and if not set step to 0.
			if(!CanMove(gust)) gust->Step = 0;
			//Declerate the gust if it's step has not reached 0 yet.
			if(gust->Step > 0) gust->Step -= DEKU_DECELERATION;
			else gust->Step = 0;
			//Check if the gust of wind is not spinning anything.
			if(!spinning){
				//Resize Link's collision box for precision purposes.
				Link->HitWidth = 15;
				Link->HitHeight = 15;
				//First check for collision with Link if he's on the ground, but only if DEKU_SPIN_LINK is true.
				if(LinkCollision(gust) && Link->Z == 0 && DEKU_SPIN_LINK) spinning = true;
				//Otherwise check for collision with npcs.
				else if(DEKU_SPIN_NPCS){
					for(int i = Screen->NumNPCs(); i > 0; i--){
						npc n = Screen->LoadNPC(i);
						if(n->Attributes[11] == 0) continue;
						if(!Collision(n, gust) || !n->CollDetection) continue;
						target = n;
						spinning = true;
					}
				}
				//Return Link's collision box back to it's default size.
				Link->HitWidth = 16;
				Link->HitHeight = 16;
				//If spinning something play the sucked in sound
				if(spinning) Game->PlaySound(SFX_WIND1);
			}
			//Now check if spinning is true.
			if(spinning){
				if(target->isValid()){
					if(target->Z == 0){
						target->X = gust->X;
						target->Y = gust->Y;
					}
					spintimer = (spintimer + 1) % DEKU_SPIN_NPCS;
					if(spintimer == 0){
						if(target->Dir == DIR_UP) target->Dir = DIR_RIGHT;
						else if(target->Dir == DIR_DOWN) target->Dir = DIR_LEFT;
						else if(target->Dir == DIR_LEFT) target->Dir = DIR_UP;
						else if(target->Dir == DIR_RIGHT) target->Dir = DIR_DOWN;
						spins += .25;
						if(spins == DEKU_GROUND_SPINS){
							target->Jump = DEKU_SPIN_JUMP;
							Game->PlaySound(SFX_WIND2);
						}
						else if(spins == DEKU_GROUND_SPINS + DEKU_AIR_SPINS){
							npc n;
							target = n;
							spinning = false;
							spins = 0;
						}
					}
				}
				else{
					if(Link->Z == 0){
						Link->X = gust->X;
						Link->Y = gust->Y;
						NoAction();
					}
					spintimer = (spintimer + 1) % DEKU_SPIN_LINK;
					if(spintimer == 0){
						if(Link->Dir == DIR_UP) Link->Dir = DIR_RIGHT;
						else if(Link->Dir == DIR_DOWN) Link->Dir = DIR_LEFT;
						else if(Link->Dir == DIR_LEFT) Link->Dir = DIR_UP;
						else if(Link->Dir == DIR_RIGHT) Link->Dir = DIR_DOWN;
						spins += .25;
						if(spins == DEKU_GROUND_SPINS){
							Link->Jump = DEKU_SPIN_JUMP;
							Game->PlaySound(SFX_WIND2);
						}
						else if(spins == DEKU_GROUND_SPINS + DEKU_AIR_SPINS){
							spinning = false;
							spins = 0;
						}
					}
				}
			}
			//Now if Ceiling(gust->Step/100) equals 0 then decrement lifespan.
			if(Ceiling(gust->Step/100) == 0) lifespan--;
			//If lifespan equal 0 and it's spinning something set lifespan to 1.
			if(lifespan == 0 && spinning) lifespan = 1;
			//Waitframe to prevent freezing.
			Waitframe();
		}
		//If the gust is still valid set it's deadstate to 0.
		if(gust->isValid()) gust->DeadState = WDS_DEAD;
	}
	//gust function is used to determine if the statue can move in the given gust->Direction.
	bool CanMove(lweapon gust){
		//Initialize a boolean as true
		bool condition = true;
		//Go through the following loop 16 times.
		for(int i; i < 16; i++){
			//Check for solidity.
			if(gust->Dir == 0 && Screen->isSolid(gust->X + i, gust->Y - Ceiling(gust->Step/100))) condition = false;
			else if(gust->Dir == 1 && Screen->isSolid(gust->X + i, gust->Y + 15 + Ceiling(gust->Step/100))) condition = false;
			else if(gust->Dir == 2 && Screen->isSolid(gust->X - Ceiling(gust->Step/100), gust->Y + i)) condition = false;
			else if(gust->Dir == 3 && Screen->isSolid(gust->X + 15 + Ceiling(gust->Step/100), gust->Y + i)) condition = false;
			//Only do the rest of the loop for the first and last iteration of the loop.
			if(i == 0 || i == 15){
				//Check for water.
				if(gust->Dir == 0 && IsWater(ComboAt(gust->X + i, gust->Y - Ceiling(gust->Step/100)))) condition = false;
				else if(gust->Dir == 1 && IsWater(ComboAt(gust->X + i, gust->Y + 15 + Ceiling(gust->Step/100)))) condition = false;
				else if(gust->Dir == 2 && IsWater(ComboAt(gust->X - Ceiling(gust->Step/100), gust->Y + i))) condition = false;
				else if(gust->Dir == 3 && IsWater(ComboAt(gust->X + 15 + Ceiling(gust->Step/100), gust->Y + i))) condition = false;
				//Check for pits.
				if(gust->Dir == 0 && IsPit(ComboAt(gust->X + i, gust->Y - Ceiling(gust->Step/100)))) condition = false;
				else if(gust->Dir == 1 && IsPit(ComboAt(gust->X + i, gust->Y + 15 + Ceiling(gust->Step/100)))) condition = false;
				else if(gust->Dir == 2 && IsPit(ComboAt(gust->X - Ceiling(gust->Step/100), gust->Y + i))) condition = false;
				else if(gust->Dir == 3 && IsPit(ComboAt(gust->X + 15 + Ceiling(gust->Step/100), gust->Y + i))) condition = false;
			}
		}
		//Return the boolean we declared at the beginning of the function.
		return condition;
	}
}