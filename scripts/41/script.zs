//import "std.zh"
//import "string.zh"
//import "ghost.zh"

// Idle settings
const int BTEK_MIN_IDLE_TIME = 45;
const int BTEK_MAX_IDLE_TIME = 90;
const int BTEK_MIN_FIRE_TIME = 25;
const int BTEK_MAX_FIRE_TIME = 60;

// Regular jump settings
const int BTEK_JUMP_CHARGE_TIME = 15;
const float BTEK_MIN_JUMPS_FACTOR = 0.5; // Used with halt rate
const float BTEK_MAX_JUMPS_FACTOR = 1.5; // Used with halt rate
const float BTEK_MIN_JUMP_VEL = 2;
const float BTEK_MAX_JUMP_VEL = 4.5;

// Super jump settings
const int BTEK_SJUMP_CHARGE_TIME = 60;
const float BTEK_SJUMP_DAMAGE_MULTIPLIER = 2;
const float BTEK_SJUMP_SPEED = 8;
const int BTEK_SJUMP_MIN_TIME = 240;
const int BTEK_SJUMP_MAX_TIME = 360;
const int BTEK_SJUMP_QUAKE_TIME = 90;

// Super jump - launched debris
const int BTEK_EW_DEBRIS = 31; // Also applies to dropped debris
const int BTEK_MIN_DEBRIS_LAUNCHED = 8;
const int BTEK_MAX_DEBRIS_LAUNCHED = 12;
const int BTEK_MIN_DEBRIS_STEP = 100;
const int BTEK_MAX_DEBRIS_STEP = 200;
const float BTEK_MIN_DEBRIS_VEL = 1.5;
const float BTEK_MAX_DEBRIS_VEL = 2.5;

// Super jump - falling objects
const int BTEK_ENEMY_LIMIT = 10;
const int BTEK_MIN_ENEMIES_DROPPED = 4; // Fewer will be used if near the limit
const int BTEK_MAX_ENEMIES_DROPPED = 5;
const int BTEK_MIN_DEBRIS_DROPPED = 10;
const int BTEK_MAX_DEBRIS_DROPPED = 15;

// Default settings (can be overridden by attributes)
const int BTEK_DEFAULT_SIZE = 2;
const int BTEK_DEFAULT_DEBRIS_SPRITE = 18;
const int BTEK_DEFAULT_STUN_TIME = 90;
const int BTEK_DEFAULT_DEBRIS_DAMAGE = 4; // Overridden by weapon damage


// npc->Attributes[] indices
const int BTEK_ATTR_SIZE = 0;
const int BTEK_ATTR_FLAGS = 1;
const int BTEK_ATTR_STUN_TIME = 2;
const int BTEK_ATTR_DROPPED_OBJECT = 3;
const int BTEK_ATTR_SFX_JUMP = 4;
const int BTEK_ATTR_SFX_SJUMP = 5;
const int BTEK_ATTR_SFX_FALL = 6;
const int BTEK_ATTR_SFX_LAND = 7;
const int BTEK_ATTR_DEBRIS_SPRITE = 8;
const int BTEK_ATTR_DEATH_TYPE = 9;

// ffc->Misc[] indices
const int BTEK_IDX_BASE_COMBO = 0;
const int BTEK_IDX_LINK_STUN_TIME = 1;

// Combo offsets
const int BTEK_CMB_IDLE = 0;
const int BTEK_CMB_CROUCH = 1;
const int BTEK_CMB_JUMP = 2;
const int BTEK_CMB_STUN = 3;

// Flags
const int BTEK_FLAG_FREEZABLE =    00000001b; // 1
const int BTEK_FLAG_NO_SJUMP =     00000010b; // 2
const int BTEK_FLAG_STUN_LINK =    00000100b; // 4
const int BTEK_FLAG_DEBRIS =       00001000b; // 8
const int BTEK_FLAG_DROP_OBJECTS = 00010000b; // 16
const int BTEK_FLAG_STUN_TO_HIT =  00100000b; // 32
const int BTEK_FLAG_UNBLOCKABLE =  01000000b; // 64
const int BTEK_FLAG_INTRO =        10000000b; // 128

ffc script BigTektite
{
    void run(int enemyID)
    {
        npc ghost=Ghost_InitAutoGhost(this, enemyID);
        this->Flags[FFCF_OVERLAY]=true;
        Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_FREEZABLE)!=0)
        {
            Ghost_SetFlag(GHF_STUN);
            Ghost_SetFlag(GHF_CLOCK);
        }
        
        this->Misc[BTEK_IDX_BASE_COMBO]=Ghost_Data;
        
        int defenses[18];
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_STUN_TO_HIT)!=0)
        {
            Ghost_StoreDefenses(ghost, defenses);
            Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
        }
        
        Ghost_TileWidth=Ghost_GetAttribute(ghost, BTEK_ATTR_SIZE, BTEK_DEFAULT_SIZE, 1, 4);
        Ghost_TileHeight=Ghost_TileWidth;
        if(Ghost_TileHeight>1)
            Ghost_SetHitOffsets(ghost, 0.33, 0.1, 0, 0);
            
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_INTRO)!=0)
            DoIntro(this, ghost);
        else if(Ghost_Z==0)
            Ghost_SpawnAnimationPuff(this, ghost);
        else // Dropping from the ceiling?
        {
            while(Ghost_Z>0)
                BTWaitframe(this, ghost);
        }
        
        int numJumps;
        
        while(true)
        {
            // The for loop doesn't make much sense if super jumps are disabled,
            // but whatever...
            for(int i=Rand(3, 5); i>0; i--)
            {
                Idle(this, ghost);
                
                // Number of successive jumps is based on halt rate
                numJumps=Rand((16-ghost->Haltrate)*BTEK_MIN_JUMPS_FACTOR,
                              (16-ghost->Haltrate)*BTEK_MAX_JUMPS_FACTOR);
                if(numJumps<1)
                    numJumps=1;
                for(; numJumps>0; numJumps--)
                    Jump(this, ghost);
            }
            
            if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_NO_SJUMP)==0)
            {
                Idle(this, ghost);
                SuperJump(this, ghost, defenses);
            }
        }
    }
    
    // ========== Idle ==========
    
    // Just stand in place, maybe shooting fireballs or something.
    void Idle(ffc this, npc ghost)
    {
        int idleTime=Rand(BTEK_MIN_IDLE_TIME, BTEK_MAX_IDLE_TIME);
        int fireTime=Rand(BTEK_MIN_FIRE_TIME, BTEK_MAX_FIRE_TIME);
        
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_IDLE;
        
        // Wait until timer counts down or the tektite is hit
        for(; idleTime>0 && !Ghost_GotHit(); idleTime--)
        {
            fireTime--;
            if(fireTime==0)
            {
                FireIdleWeapon(ghost);
                fireTime=Rand(BTEK_MIN_FIRE_TIME, BTEK_MAX_FIRE_TIME);
            }
            
            BTWaitframe(this, ghost);
        }
    }
    
    // Fire any weapons used while standing on the ground
    void FireIdleWeapon(npc ghost)
    {
        int weaponID=WeaponTypeToID(ghost->Weapon);
        int flags=0;
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_UNBLOCKABLE)!=0)
            flags|=EWF_UNBLOCKABLE;
            
	    // Angular weapons
	    if(weaponID==EW_FIREBALL || weaponID==EW_BRANG)
	    {
	        FireAimedEWeapon(weaponID, BTCenterX()-8, BTCenterY()-8,
	                         0, 200, ghost->WeaponDamage, -1, -1, flags);
        }
        
        // Fireball 2: 3-way
        else if(weaponID==EW_FIREBALL2)
        {
            eweapon fb;
            fb=FireAimedEWeapon(weaponID, BTCenterX()-8, BTCenterY()-8,
	                            0, 200, ghost->WeaponDamage, -1, -1, flags);
	        SetEWeaponMovement(fb, EWM_DRIFT_WAIT, DIR_UP, 0);
	        
	        fb=FireAimedEWeapon(weaponID, BTCenterX()-8, BTCenterY()-8,
                                0, 200, ghost->WeaponDamage, -1, -1, flags);
            SetEWeaponMovement(fb, EWM_DRIFT_WAIT, DIR_UP, 0.5);
            
	        fb=FireAimedEWeapon(weaponID, BTCenterX()-8, BTCenterY()-8,
                                0, 200, ghost->WeaponDamage, -1, -1, flags);
            SetEWeaponMovement(fb, EWM_DRIFT_WAIT, DIR_DOWN, 0.5);
        }
        
        // Non-angular weapons
        else if(weaponID==EW_WIND || weaponID==EW_ARROW || weaponID==EW_BEAM ||
                weaponID==EW_ROCK || weaponID==EW_MAGIC)
        {
            if(!(weaponID==EW_WIND || weaponID==EW_ROCK))
                flags|=EWF_ROTATE;
            
            int dir=AngleDir4(Angle(BTCenterX(), BTCenterY(),
                                    Link->X+8, Link->Y+8));
            FireNonAngularEWeapon(weaponID, BTCenterX()-8, BTCenterY()-8,
                                  dir, 200, ghost->WeaponDamage, -1, -1, flags);
        }
    }
    
    // ========== Jumping ==========
    
    void Jump(ffc this, npc ghost)
    {
        float jumpHeight;
        float angle;
        lweapon bait;
        
        // Find bait if there's any chance the tektite will go for it
        if(ghost->Hunger>0)
            bait=LoadLWeaponOf(LW_BAIT);
        
        // Charge for a moment
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_CROUCH;
        
        for(int i=0; i<BTEK_JUMP_CHARGE_TIME; i++)
            BTWaitframe(this, ghost);
        
        // Decide where to jump
        
        // Go for bait?
        if(Rand(4)<ghost->Hunger && bait->isValid())
        {
            float dist=BTDistanceTo(bait->X+8, bait->Y+8);
            jumpHeight=GH_GRAVITY*dist/(ghost->Step/50);
            angle=Angle(BTCenterX(), BTCenterY(), bait->X+8, bait->Y+8);
        }
        
        // Try to hit Link?
        else if(Rand(256)<ghost->Homing)
        {
            // A rough approximation, but it works pretty well.
            float dist=BTDistanceTo(Link->X+8, Link->Y+8);
            jumpHeight=GH_GRAVITY*dist/(ghost->Step/50);
            angle=Angle(BTCenterX(), BTCenterY(), Link->X+8, Link->Y+8);
        }
        
        // Jump randomly
        else
        {
            jumpHeight=Rand(BTEK_MIN_JUMP_VEL, BTEK_MAX_JUMP_VEL);
            angle=Rand(360);
        }
        
        // In case the target wasn't actually in range...
        jumpHeight=Clamp(jumpHeight, BTEK_MIN_JUMP_VEL, BTEK_MAX_JUMP_VEL);
        
        // Jump
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_JUMP;
        Game->PlaySound(ghost->Attributes[BTEK_ATTR_SFX_JUMP]);
        Ghost_Jump=jumpHeight;
        Ghost_Vx=VectorX(ghost->Step/100, angle);
        Ghost_Vy=VectorY(ghost->Step/100, angle);
        FireJumpingWeapon(ghost);
        
        // And then just wait to land
        do
        {
            BounceOffScreenEdges();
            BTWaitframe(this, ghost);
        } while(Ghost_Z>0);
        
        FireLandingWeapon(ghost);
        Ghost_Vx=0;
        Ghost_Vy=0;
    }
    
    // Leave a weapon behind when jumping (bomb, super bomb, fire trail)
    void FireJumpingWeapon(npc ghost)
    {
        eweapon wpn;
        
        if(ghost->Weapon==WPN_ENEMYLITBOMB)
        {
            // Always unblockable
            wpn=FireNonAngularEWeapon(EW_BOMB, BTCenterX()-8, BTCenterY()-8,
                                      0, 0, 0, -1, -1, EWF_UNBLOCKABLE);
            SetEWeaponLifespan(wpn, EWL_TIMER, 30);
            SetEWeaponDeathEffect(wpn, EWD_EXPLODE, ghost->WeaponDamage);
        }
        else if(ghost->Weapon==WPN_ENEMYLITSBOMB)
        {
            wpn=FireNonAngularEWeapon(EW_SBOMB, BTCenterX()-8, BTCenterY()-8,
                                      0, 0, 0, -1, -1, EWF_UNBLOCKABLE);
            SetEWeaponLifespan(wpn, EWL_TIMER, 30);
            SetEWeaponDeathEffect(wpn, EWD_SBOMB_EXPLODE, ghost->WeaponDamage);
        }
        else if(ghost->Weapon==WPN_ENEMYFIRETRAIL)
        {
            // 1x1: Single flame
            if(Ghost_TileWidth==1)
            {
                wpn=FireNonAngularEWeapon(EW_FIRETRAIL, Ghost_X, Ghost_Y,
                                          0, 0, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE);
                SetEWeaponLifespan(wpn, EWL_TIMER, 30);
                SetEWeaponDeathEffect(wpn, EWD_VANISH, 0);
            }
            
            // 2x2 or bigger: One on each tile except on the top row
            else
            {
                for(int row=1; row<Ghost_TileHeight; row++)
                {
                    for(int col=0; col<Ghost_TileWidth; col++)
                    {
                        wpn=FireNonAngularEWeapon(EW_FIRETRAIL,
                                                  Ghost_X+16*col, Ghost_Y+16*row,
                                                  0, 0, ghost->WeaponDamage,
                                                  -1, -1, EWF_UNBLOCKABLE);
                        SetEWeaponLifespan(wpn, EWL_TIMER, 60);
                        SetEWeaponDeathEffect(wpn, EWD_VANISH, 0);
                    }
                }
            }
        }
    }
    
    // Use weapons when landing (fire, explosion)
    void FireLandingWeapon(npc ghost)
    {
        int weaponID;
        
        // Explosions are disabled for other-type enemies in 2.50.
        // This should work in 2.50.1, though...
        if(ghost->Weapon==WPN_ENEMYBOMB || ghost->Weapon==WPN_ENEMYSBOMB)
        {
            eweapon wpn;
            
            if(ghost->Weapon==WPN_ENEMYBOMB)
                weaponID=EW_BOMBBLAST;
            else
                weaponID=EW_SBOMBBLAST;
            
            wpn=Screen->CreateEWeapon(weaponID);
            wpn->Damage=ghost->WeaponDamage;
            wpn->Dir=-1;
            wpn->X=BTCenterX()-8;
            wpn->Y=BTCenterY()-8;
        }
        
        // 8-way fires
        // WPN_ENEMYFLAME2 is incorrect...
        else if(ghost->Weapon==WPN_ENEMYFLAME || ghost->Weapon==142)
        {
            int i;
            int flags=0;
            if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_UNBLOCKABLE)!=0)
                flags|=EWF_UNBLOCKABLE;
            
            if(ghost->Weapon==WPN_ENEMYFLAME)
                weaponID=EW_FIRE;
            else
                weaponID=EW_FIRE2;
                
            for(i=0; i<4; i++)
                FireNonAngularEWeapon(weaponID,
                                      BTCenterX()-8, BTCenterY()-8,
                                      i, 100, ghost->WeaponDamage, -1, 0, flags);
            for(i=4; i<8; i++)
                FireNonAngularEWeapon(weaponID,
                                      BTCenterX()-8, BTCenterY()-8,
                                      i, 71, ghost->WeaponDamage, -1, 0, flags);
            Game->PlaySound(SFX_FIRE);
        }
    }
    
    void BounceOffScreenEdges()
    {
        if(Ghost_X<=16)
            Ghost_Vx=Abs(Ghost_Vx);
        else if(Ghost_X+16*Ghost_TileWidth>=240)
            Ghost_Vx=-Abs(Ghost_Vx);
        
        if(Ghost_Y<=16)
            Ghost_Vy=Abs(Ghost_Vy);
        else if(Ghost_Y+16*Ghost_TileHeight>=160)
            Ghost_Vy=-Abs(Ghost_Vy);
    }
    
    // ========== Super jump ==========
    
    void SuperJump(ffc this, npc ghost, int defenses)
    {
        int timer;
        float targetAngle;
        float targetSpeed;
        float dist;
        float targetVx;
        float targetVy;
        
        // Charge up
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_CROUCH;
        for(timer=0; timer<BTEK_SJUMP_CHARGE_TIME; timer++)
            BTWaitframe(this, ghost);
        
        // Jump...
        Ghost_SetFlag(GHF_NO_FALL); // Override gravity handling
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_JUMP;
        Game->PlaySound(ghost->Attributes[BTEK_ATTR_SFX_SJUMP]);
        while(Ghost_Z<176)
        {
            Ghost_Z+=BTEK_SJUMP_SPEED;
            BTWaitframe(this, ghost);
        }
        
        // Follow Link around for a while
        for(timer=Rand(BTEK_SJUMP_MIN_TIME, BTEK_SJUMP_MAX_TIME); timer>0; timer--)
        {
            dist=BTDistanceTo(Link->X+8, Link->Y+8);
            
            // If far from Link, adjust aim; otherwise, try to stop
            if(dist>4)
            {
                targetAngle=Angle(BTCenterX(), BTCenterY(), Link->X+8, Link->Y+8);
                targetSpeed=ghost->Step/200;
            }
            else
                targetSpeed=0;
            
            // Don't change direction suddenly
            targetVx=targetSpeed*Cos(targetAngle);
            targetVy=targetSpeed*Sin(targetAngle);
            
            if(Ghost_Vx<targetVx)
                Ghost_Vx=Min(Ghost_Vx+0.05, targetVx);
            else if(Ghost_Vx>targetVx)
                Ghost_Vx=Max(Ghost_Vx-0.05, targetVx);
            
            if(Ghost_Vy<targetVy)
                Ghost_Vy=Min(Ghost_Vy+0.05, targetVy);
            else if(Ghost_Vy>targetVy)
                Ghost_Vy=Max(Ghost_Vy-0.05, targetVy);
            
            BTWaitframe(this, ghost);
        }
        
        // Fall
        Ghost_Vx=0;
        Ghost_Vy=0;
        ghost->Damage*=BTEK_SJUMP_DAMAGE_MULTIPLIER;
        Game->PlaySound(ghost->Attributes[BTEK_ATTR_SFX_FALL]);
        while(Ghost_Z>0)
        {
            Ghost_Z-=BTEK_SJUMP_SPEED;
            BTWaitframe(this, ghost);
        }
        
        // Land
        Ghost_Z=0;
        ghost->Damage/=BTEK_SJUMP_DAMAGE_MULTIPLIER;
        LaunchDebris(ghost);
        DropObjects(ghost);
        Screen->Quake=BTEK_SJUMP_QUAKE_TIME;
        Game->PlaySound(ghost->Attributes[BTEK_ATTR_SFX_LAND]);
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_STUN_LINK)!=0 && Link->Z==0)
            this->Misc[BTEK_IDX_LINK_STUN_TIME]=BTEK_SJUMP_QUAKE_TIME;
        
        // Be stunned for a bit
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_STUN_TO_HIT)!=0)
            Ghost_SetDefenses(ghost, defenses);
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_STUN;
        timer=Ghost_GetAttribute(ghost, BTEK_ATTR_STUN_TIME, BTEK_DEFAULT_STUN_TIME);
        for(; timer>0; timer--)
            BTWaitframe(this, ghost);
        
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_STUN_TO_HIT)!=0)
            Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
        
        Ghost_UnsetFlag(GHF_NO_FALL);
    }
    
    void LaunchDebris(npc ghost)
    {
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_DEBRIS)==0)
            return;
        
        int count=Rand(BTEK_MIN_DEBRIS_LAUNCHED, BTEK_MAX_DEBRIS_LAUNCHED);
        int sprite=Ghost_GetAttribute(ghost, BTEK_ATTR_DEBRIS_SPRITE,
                                      BTEK_DEFAULT_DEBRIS_SPRITE);
        int damage=ghost->WeaponDamage;
        if(damage==0)
            damage=BTEK_DEFAULT_DEBRIS_DAMAGE;
        float angle;
        eweapon debris;
        
        for(; count>0; count--)
        {
            angle=Randf(PI2);
            // Large function calls!
            debris=FireEWeapon(BTEK_EW_DEBRIS, 
                               BTCenterX()-8+8*RadianCos(angle),
                               BTCenterY()-8+8*RadianSin(angle),
                               angle,
                               Rand(BTEK_MIN_DEBRIS_STEP, BTEK_MAX_DEBRIS_STEP),
                               damage,
                               sprite,
                               0,
                               EWF_SHADOW|EWF_UNBLOCKABLE);
            SetEWeaponMovement(debris,
                               EWM_THROW,
                               Randf(BTEK_MIN_DEBRIS_VEL, BTEK_MAX_DEBRIS_VEL),
                               EWMF_DIE);
            SetEWeaponDeathEffect(debris, EWD_VANISH, 0);
        }
    }
    
    void DropObjects(npc ghost)
    {
        // Don't do anything if the flag isn't set.
        if((ghost->Attributes[BTEK_ATTR_FLAGS]&BTEK_FLAG_DROP_OBJECTS)==0)
            return;
        
        // Or if the object to drop isn't valid.
        int objID=ghost->Attributes[BTEK_ATTR_DROPPED_OBJECT];
        if(objID!=0 && !(objID>=20 && objID<=511))
            return;
        
        // Drop debris
        if(objID==0)
        {
            eweapon debris;
            int count=Rand(BTEK_MIN_DEBRIS_DROPPED, BTEK_MAX_DEBRIS_DROPPED);
            int sprite=Ghost_GetAttribute(ghost, BTEK_ATTR_DEBRIS_SPRITE,
                                          BTEK_DEFAULT_DEBRIS_SPRITE);
            int damage=ghost->WeaponDamage;
            if(damage==0)
                damage=BTEK_DEFAULT_DEBRIS_DAMAGE;
            
            for(; count>0; count--)
            {
                debris=FireEWeapon(BTEK_EW_DEBRIS, Rand(16, 224), Rand(16, 144),
                                   0, 0, damage, sprite, 0,
                                   EWF_SHADOW|EWF_UNBLOCKABLE);
                SetEWeaponMovement(debris, EWM_FALL, Rand(160, 224), EWMF_DIE);
                SetEWeaponDeathEffect(debris, EWD_VANISH, 0);
            }
        }
        
        // Drop enemies
        else
        {
            // Don't do anything if there are too many already
            if(Screen->NumNPCs()>=BTEK_ENEMY_LIMIT)
                return;
            
            npc enemy;
            int count=Rand(BTEK_MIN_ENEMIES_DROPPED, BTEK_MAX_ENEMIES_DROPPED);
            if(Screen->NumNPCs()+count>BTEK_ENEMY_LIMIT)
                count=BTEK_ENEMY_LIMIT-Screen->NumNPCs();
            
            for(; count>0; count--)
            {
                enemy=SpawnNPC(objID);
                enemy->Z=Rand(160, 224);
            }
        }
    }
    
    // ========== Other ==========
    
    // Fall onto the screen at the start of the fight
    void DoIntro(ffc this, npc ghost)
    {
        Ghost_X=128-8*Ghost_TileWidth;
        Ghost_Y=96-16*Ghost_TileHeight;
        Ghost_Z=176;
        Ghost_SetFlag(GHF_NO_FALL);
        Ghost_SetFlag(GHF_STATIC_SHADOW);
        ghost->CollDetection=false;
        
        // Wait half a second, then fall
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_JUMP;
        Ghost_Waitframes(this, ghost, true, true, 60);
        
        Game->PlaySound(ghost->Attributes[BTEK_ATTR_SFX_FALL]);
        while(Ghost_Z>0)
        {
            Ghost_Z-=BTEK_SJUMP_SPEED;
            Ghost_Waitframe(this, ghost, true, true);
        }
        
        // On impact, shake the screen and disable Link for a moment
        Screen->Quake=BTEK_SJUMP_QUAKE_TIME;
        Ghost_Data=this->Misc[BTEK_IDX_BASE_COMBO]+BTEK_CMB_CROUCH;
        Game->PlaySound(ghost->Attributes[BTEK_ATTR_SFX_LAND]);
        while(Screen->Quake>0)
        {
            NoAction();
            Ghost_Waitframe(this, ghost, true, true);
        }
        
        // Back to normal
        Ghost_UnsetFlag(GHF_NO_FALL);
        Ghost_UnsetFlag(GHF_STATIC_SHADOW);
        ghost->CollDetection=true;
    }
    
    void BTWaitframe(ffc this, npc ghost)
    {
        // Is Link stunned?
        if(this->Misc[BTEK_IDX_LINK_STUN_TIME]>0)
        {
            NoAction();
            this->Misc[BTEK_IDX_LINK_STUN_TIME]--;
        }
        
        bool noDeathAnim=ghost->Attributes[BTEK_ATTR_DEATH_TYPE]==0;
        if(!Ghost_Waitframe(this, ghost, noDeathAnim, noDeathAnim))
        {
            Ghost_DeathAnimation(this, ghost, ghost->Attributes[BTEK_ATTR_DEATH_TYPE]);
            Quit();
        }
    }
    
    float BTCenterX()
    {
        return Ghost_X+8*Ghost_TileWidth;
    }
    
    // Doesn't really return the center unless the tektite is 1x1; if it's
    // bigger, it's actually the center of the shadow, which might be either
    // 1x1 or 2x2 depending on size and ghost.zh settings.
    float BTCenterY()
    {
        if(GH_FAKE_Z!=0 && GH_LARGE_SHADOW_TILE!=0)
        {
            if(Ghost_TileHeight==1) // 1x1 shadow
                return Ghost_Y+8;
            else if(Ghost_TileHeight==2) // 1x1
                return Ghost_Y+24;
            else if(Ghost_TileHeight==3) // 2x2
                return Ghost_Y+32;
            else // 2x2
                return Ghost_Y+48;
        }
        else // 1x1
        {
            if(Ghost_TileHeight==1)
                return Ghost_Y+8;
            else
                return Ghost_Y+16+8*(Ghost_TileHeight-1); // 24, 40, 56
        }
    }
    
    // Distance from "center" to a given point
    float BTDistanceTo(float x, float y)
    {
        float dx=BTCenterX()-x;
        float dy=BTCenterY()-y;
        
        return Sqrt(dx*dx+dy*dy);
    }
}