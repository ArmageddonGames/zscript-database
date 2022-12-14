const int NPC_MISC_ORIGTILE = 0; //Index for NPC`s Misc array for Npc`s real original tile chosen in Enemy Editor
const int NPC_MISC_OLDX = 1; //Index for NPC`s Misc array for Npc`s X coordinate in previous frame.
const int NPC_MISC_OLDY = 2; //Index for NPC`s Misc array for Npc`s Y coordinate in previous frame.
const int NPC_MISC_HALTCOUNTER = 3; //Index for NPC`s Misc array for Npc`s halt counter

ffc script BigEnemyDX{
    void run(int EnemyNum, int Width, int Height, int XDraw, int YDraw, int XHit, int YHit, int animoverride){
        Waitframes(4);
        npc Boss = Screen->LoadNPC(EnemyNum);
       Boss->HitWidth = Width;
       Boss->HitHeight = Height;
        if (Width >=16){
             Boss->Extend=3;
             Boss->TileWidth = Width/16;
        }
        if (Height>=16){
            Boss->Extend=3;
            Boss->TileHeight = Height/16;
        }
       Boss->DrawXOffset = XDraw;
       Boss->DrawYOffset = YDraw;
       Boss->HitXOffset = XHit;
       Boss->HitYOffset = YHit;
       Boss->Misc[NPC_MISC_ORIGTILE] = Boss->OriginalTile;
       while (Boss->isValid()){
           CustomAnimation(Boss, animoverride);
           Waitframe();
       } 
    }
}

//Used to determine animation direction for facing Link
int FaceLink (npc b){
    if (IsSideview()){
        if (b->X > CenterLinkX()) return DIR_LEFT;
        else return DIR_RIGHT;
    }
    else{
        int LX = CenterLinkX();
        int LY = CenterLinkY();
        int BX = CenterX(b);
        int BY = CenterY(b);
        int vector = Angle(LX,LY,BX,BY);
        if (Abs(vector)>135){
            return DIR_RIGHT;
        }
        else if (Abs(vector)>45){
            if (vector > 0) return DIR_UP;
            else return DIR_DOWN;
        }
        else return DIR_LEFT;
    }
}

//Defines custom animation. Call this function every frame to prevent glitching tiles.
void CustomAnimation(npc b, int animflags){
    if ((animflags&1) == 0) return; //Custom animation was not enabled.
    if (b->Attributes[11] > 0) return; //Stay away from ghosted enemies.
    int OrigTileOffset = b->TileHeight * 20; //Find incremental for BigEnemy`s OriginalTile offset
    float HaltThreshold = 100/(b->Step); //Find out the threshold used to detect whether the enemy is halting.
    if (HaltThreshold==0) HaltThreshold = 1; //Set the threshold for fast enemies
    int andir=0; //Direction the enemy is facing. Not the npc->Dir!
     int HaltTileOffset=0; //Tile offset used for "firing"animation
     int OrigTile = b->Misc[NPC_MISC_ORIGTILE]; //The actual original tile of enemy.
     // /!\ Must be recorded on enemy initialization
     int OldX = b->Misc[NPC_MISC_OLDX]; //Enemy`s X coordinate on previous frame.
     int OldY = b->Misc[NPC_MISC_OLDY]; //Enemy`s Y coordinate on previous frame.
     if ((animflags&4)>0) andir = FaceLink(b); //Always face Link if approriate flag is used
     else andir = b->Dir; //Otherwise, use npc->Dir
     if ((animflags&8)>0){ //Firing animation is used?
     if ((b->X == OldX)&&(b->Y==OldY)&&(OldX==GridX(OldX))&&(OldY==GridY(OldY))){ //Main halting detection check. Not perfect. :-(
          b->Misc[NPC_MISC_HALTCOUNTER]++; //Update halt counter
          if (b->Misc[NPC_MISC_HALTCOUNTER]>HaltThreshold){
         if ((animflags&2)>0) HaltTileOffset=  OrigTileOffset*8; //Check diagonal allowance flag
         else HaltTileOffset=  OrigTileOffset*4; //And set tile offset accordingly.
         if (b->Misc[NPC_MISC_HALTCOUNTER] >= 24) HaltTileOffset *= 2; 
          }
    }
     else b->Misc[NPC_MISC_HALTCOUNTER] = 0; //Reset halt counter
     }
     b->Misc[NPC_MISC_OLDX] = b->X; //Update old coordinates
     b->Misc[NPC_MISC_OLDY] = b->Y;
     b->OriginalTile = OrigTile + HaltTileOffset+ (OrigTileOffset * andir); //And, finally, set npc`s Original Tile
     //debugValue(1, (b->Misc[NPC_MISC_HALTCOUNTER]));
     //debugValue(2, HaltThreshold);
}