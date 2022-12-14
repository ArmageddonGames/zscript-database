//LWeapons.zh Scripted Hookshots

item script Run_Hookshot{
	void run(){
		if(CountFFCsRunning(GRAPPLE_BEAM_SCRIPT)==0){
			int Args[8]= {160};
			NewFFCScript(GRAPPLE_BEAM_SCRIPT, Args);
		}
	}
}

const int SFX_GRAPPLESOUND = 17;//What sound to play when using grapple
const int I_GRAPPLE = 157;//Item ID for grapple beam.
const int TIL_GRAPPLEHOOK = 621;//First tile of grapple beam.
const int CS_GRAPPLEHOOK = 1;//Cset of grapple beam.
const int FREQ_GRAPPLESOUND = 4;//How often to play grapple sound.
const int GRAPPLE_BEAM_SCRIPT = 7;

ffc script GrappleBeam{
	int HookX(int dir){
		if(dir==DIR_LEFT)
			return -16;
		else if(dir==DIR_LEFTUP||dir==DIR_LEFTDOWN)
			return -12;
		else if(dir==DIR_RIGHT)
			return 16;
		else if(dir==DIR_RIGHTUP||dir==DIR_RIGHTDOWN)
			return 12;
		else
			return 0;
	}
	int HookY(int dir){
		if(dir==DIR_UP||dir==DIR_LEFTUP||dir==DIR_RIGHTUP)
			return -16;
		else if(dir==DIR_LEFTUP||dir==DIR_RIGHTUP)
			return -16;
		else if(dir==DIR_DOWN)
			return 16;
		else if(dir==DIR_LEFTDOWN||dir==DIR_RIGHTDOWN)
			return 12;
		else
			return 0;
	}
	bool CanPlaceLink(int X, int Y){
		for(int x=0; x<3; x++){
			for(int y=0; y<3; y++){
				if(Screen->isSolid(X+x*7.5, Y+y*7.5))
					return false;
			}
		}
		return true;
	}
	int GrappleDetect(int X, int Y){
		if(ComboT(X+4, Y+4,CT_HSGRAB))
			return ComboAt(X+4, Y+4);
		else if(ComboT(X+12, Y+4,CT_HSGRAB))
			return ComboAt(X+12, Y+4);
		else if(ComboT(X+4, Y+12,CT_HSGRAB))
			return ComboAt(X+4, Y+12);
		else if(ComboT(X+12, Y+12,CT_HSGRAB))
			return ComboAt(X+12, Y+12);
		return -1;
	}
	bool GrappleSolid(int X, int Y){
		if((Screen->isSolid(X+4, Y+4)&& !ComboT(X+4, Y+4,CT_HOOKSHOTONLY))||
			(Screen->isSolid(X+12, Y+4)&& !ComboT(X+12, Y+4,CT_HOOKSHOTONLY))||
			(Screen->isSolid(X+4, Y+12)&& !ComboT(X+4, Y+12,CT_HOOKSHOTONLY))||
			(Screen->isSolid(X+12, Y+12)&& !ComboT(X+12, Y+12,CT_HOOKSHOTONLY)))
			return true;
		return false;
	}
	void run(int Max_Length){
		this->Data = GH_INVISIBLE_COMBO;
		Game->PlaySound(SFX_GRAPPLESOUND);
		bool Grapple;
		int Length;
		int LinkX = Link->X;
		int LinkY = Link->Y;
		int HookStartX = Link->X+HookX(Link->Dir);
		int HookStartY = Link->Y+HookY(Link->Dir);
		int HookX = HookStartX;
		int HookY = HookStartY;
		int HookAngle = __DirAngle(Link->Dir);
		int SFXTimer = 0;
		lweapon Damage = CreateLWeaponAt(LW_REFFIREBALL, HookX, HookY);
		Damage->Step = 0;
		Damage->DrawYOffset = -1000;
		Damage->Damage = 1;
		Damage->Dir = Link->Dir;
		SetLWeaponFlag(Damage,__LWFI_IS_LWZH_LWPN);
		SetLWeaponFlag(Damage,LWF_ITEM_PICKUP);
		SetLWeaponFlag(Damage,LWF_INSTA_DELIVER);
		int GrappleTimer;
		this->TileWidth = 1;
		this->TileHeight = 1;
		int loc;
		int flip;
		while(Length<Max_Length){
			Length+=4;
			HookStartX = Link->X+HookX(Link->Dir);
			HookStartY = Link->Y+HookY(Link->Dir);
			HookX += VectorX(4, HookAngle);
			HookY += VectorY(4, HookAngle);
			Link->X = LinkX;
			Link->Y = LinkY;
			Link->Jump = 0;
			if(GrappleDetect(HookX, HookY)>-1){
				HookX = ComboX(GrappleDetect(HookX,HookY));
				HookY = ComboY(GrappleDetect(HookX,HookY));
				loc= ComboAt(HookX,HookY);
				Grapple = true;
				break;
			}
			else if(GrappleSolid(HookX, HookY)||!InputButtonItem(I_GRAPPLE)
					||HookX<0||HookX>240||HookY<0||HookY>160||!Damage->isValid())
				break;
			SFXTimer = __TimedSFX(SFXTimer, SFX_GRAPPLESOUND, FREQ_GRAPPLESOUND);
			if(Damage->isValid()){
				Damage->Dir = Link->Dir;
				Damage->X = HookX;
				Damage->Y = HookY;
			}
			Hookshot_Waitframes(HookStartX,HookStartY,HookX,HookY,HookAngle,Length,TIL_GRAPPLEHOOK,2);
		}
		if(Damage->isValid())
			SetLWeaponFlag(Damage,LWF_PIERCES_ENEMIES);
		if(Grapple){
			int cmbX = ComboX(loc);
			int cmbY = ComboY(loc);
			if(Link->Dir==DIR_LEFT){
				cmbX+=8;
				Link->Y=cmbY;
			}
			else if(Link->Dir==DIR_RIGHT){
				cmbX-=8;
				Link->Y=cmbY;
			}
			else if(Link->Dir==DIR_DOWN){
				cmbY-=8;
				Link->X=cmbX;
			}
			else if(Link->Dir==DIR_UP){
				cmbY+=8;
				Link->X=cmbX;
			}
			while(Distance(Link->X, Link->Y, cmbX, cmbY)>8){
				HookStartX = Link->X+HookX(Link->Dir);
				HookStartY = Link->Y+HookY(Link->Dir);
				HookAngle = Angle(HookStartX, HookStartY, HookX, HookY);
				SFXTimer = __TimedSFX(SFXTimer, SFX_GRAPPLESOUND, FREQ_GRAPPLESOUND);
				Link->Z= 1;
				Link->Jump= 0;
				if(Link->Dir==DIR_LEFT)
					Link->X-=2;
				else if(Link->Dir==DIR_RIGHT)
					Link->X+=2;
				else if(Link->Dir==DIR_DOWN)
					Link->Y+=2;
				else if(Link->Dir==DIR_UP)
					Link->Y-=2;
				Length = Distance(HookStartX,HookStartY,HookX,HookY);
				Hookshot_Waitframes(HookStartX,HookStartY,HookX,HookY,HookAngle,Length,TIL_GRAPPLEHOOK,2);
			}
		}
		while(Distance(HookStartX, HookStartY, HookX, HookY)>8 ){
			if(Damage->isValid()){
				Damage->Dir = Link->Dir;
				Damage->X = HookX;
				Damage->Y = HookY;
			}
			HookStartX = Link->X+HookX(Link->Dir);
			HookStartY = Link->Y+HookY(Link->Dir);
			HookAngle = Angle(HookStartX, HookStartY, HookX, HookY);
			HookX += VectorX(8, HookAngle-180);
			HookY += VectorY(8, HookAngle-180);
			Length = Distance(HookStartX,HookStartY,HookX,HookY);
			SFXTimer = __TimedSFX(SFXTimer, SFX_GRAPPLESOUND, FREQ_GRAPPLESOUND);
			Hookshot_Waitframes(HookStartX,HookStartY,HookX,HookY,HookAngle,Length,TIL_GRAPPLEHOOK,2);
		}
		KillLWeapon(Damage);
	}
}

void Hookshot_Waitframe(int StartX, int StartY, int EndX, int EndY, float angle, int length, int tile){
	int flip;
	for(int i=0; i<Ceiling(length/8); i++){
		if(Link->Dir==DIR_LEFT||Link->Dir==DIR_RIGHT)Screen->FastTile(2, EndX+VectorX(8*i, angle-180), EndY+VectorY(8*i, angle-180), tile+3, CS_GRAPPLEHOOK, 128);
		else if(Link->Dir==DIR_UP||Link->Dir==DIR_DOWN)	
			Screen->FastTile(2, EndX+VectorX(8*i, angle-180), EndY+VectorY(8*i, angle-180), tile+5, CS_GRAPPLEHOOK, 128);
	}
	if(Link->Dir==DIR_LEFT||Link->Dir==DIR_RIGHT){
		if(Link->Dir==DIR_LEFT)
			flip = FLIP_H;
		Screen->DrawTile(2, EndX, EndY, tile+1, 1, 1, CS_GRAPPLEHOOK, -1, -1, 0, 0, 0, flip, true, 128);	
		Screen->DrawTile(2, StartX, StartY, tile+7, 1, 1, CS_GRAPPLEHOOK, -1, -1, 0,0,0, flip, true, 128);
	}
	else if(Link->Dir==DIR_DOWN||Link->Dir==DIR_UP){
		if(Link->Dir==DIR_DOWN)
			flip = FLIP_V;
		Screen->DrawTile(2, EndX, EndY, tile, 1, 1, CS_GRAPPLEHOOK, -1, -1, 0, 0, 0, flip, true, 128);	
		Screen->DrawTile(2, StartX, StartY, tile+6, 1, 1, CS_GRAPPLEHOOK, -1, -1, 0,0,0, flip, true, 128);
	}
	WaitNoAction();
}

void Hookshot_Waitframes(int StartX, int StartY, int EndX, int EndY, float angle, int length, int tile, int frames){
	for(;frames>0;frames--)
		Hookshot_Waitframe(StartX,StartY,EndX,EndY,angle,length,tile);
}

const int SWITCH_HOOK_SCRIPT = 8;
const int I_SWITCH_HOOK = 0;
const int SFX_SWITCHHOOK = 86;

item script Run_Switchhook{
	void run(){
		if(CountFFCsRunning(SWITCH_HOOK_SCRIPT)==0){
			int Args[8]= {160};
			NewFFCScript(GRAPPLE_BEAM_SCRIPT, Args);
		}
	}
}

ffc script Switch_Hook{
	int HookX(int dir){
		if(dir==DIR_LEFT)
			return -16;
		else if(dir==DIR_LEFTUP||dir==DIR_LEFTDOWN)
			return -12;
		else if(dir==DIR_RIGHT)
			return 16;
		else if(dir==DIR_RIGHTUP||dir==DIR_RIGHTDOWN)
			return 12;
		else
			return 0;
	}
	int HookY(int dir){
		if(dir==DIR_UP||dir==DIR_LEFTUP||dir==DIR_RIGHTUP)
			return -16;
		else if(dir==DIR_LEFTUP||dir==DIR_RIGHTUP)
			return -16;
		else if(dir==DIR_DOWN)
			return 16;
		else if(dir==DIR_LEFTDOWN||dir==DIR_RIGHTDOWN)
			return 12;
		else
			return 0;
	}
	bool CanPlaceLink(int X, int Y){
		for(int x=0; x<3; x++){
			for(int y=0; y<3; y++){
				if(Screen->isSolid(X+x*7.5, Y+y*7.5))
					return false;
			}
		}
		return true;
	}
	int GrappleDetect(int X, int Y){
		if(ComboFIT(X+4, Y+4,CF_SCRIPT1,CT_HSGRAB))
			return ComboAt(X+4, Y+4);
		else if(ComboFIT(X+12, Y+4,CF_SCRIPT1,CT_HSGRAB))
			return ComboAt(X+12, Y+4);
		else if(ComboFIT(X+4, Y+12,CF_SCRIPT1,CT_HSGRAB))
			return ComboAt(X+4, Y+12);
		else if(ComboFIT(X+12, Y+12,CF_SCRIPT1,CT_HSGRAB))
			return ComboAt(X+12, Y+12);
		return -1;
	}
	bool GrappleSolid(int X, int Y){
		if((Screen->isSolid(X+4, Y+4)&& !ComboT(X+4, Y+4,CT_HOOKSHOTONLY))||
			(Screen->isSolid(X+12, Y+4)&& !ComboT(X+12, Y+4,CT_HOOKSHOTONLY))||
			(Screen->isSolid(X+4, Y+12)&& !ComboT(X+4, Y+12,CT_HOOKSHOTONLY))||
			(Screen->isSolid(X+12, Y+12)&& !ComboT(X+12, Y+12,CT_HOOKSHOTONLY))
			)
			return true;
		return false;
	}
	void run(int Max_Length){
		this->Data = GH_INVISIBLE_COMBO;
		Game->PlaySound(SFX_GRAPPLESOUND);
		bool Grapple;
		int Length;
		int LinkX = Link->X;
		int LinkY = Link->Y;
		int HookStartX = Link->X+HookX(Link->Dir);
		int HookStartY = Link->Y+HookY(Link->Dir);
		int HookX = HookStartX;
		int HookY = HookStartY;
		int HookAngle = __DirAngle(Link->Dir);
		int SFXTimer = 0;
		lweapon Damage = CreateLWeaponAt(LW_REFROCK, HookX, HookY);
		Damage->Step = 0;
		Damage->DrawYOffset = -1000;
		Damage->Damage = 1;
		Damage->Dir = Link->Dir;
		SetLWeaponFlag(Damage,__LWFI_IS_LWZH_LWPN);
		SetLWeaponFlag(Damage,LWF_ITEM_PICKUP);
		SetLWeaponFlag(Damage,LWF_INSTA_DELIVER);
		int GrappleTimer;
		this->TileWidth = 1;
		this->TileHeight = 1;
		int loc;
		int flip;
		bool Switched = false;
		while(Length<Max_Length){
			Length+=4;
			HookStartX = Link->X+HookX(Link->Dir);
			HookStartY = Link->Y+HookY(Link->Dir);
			HookX += VectorX(4, HookAngle);
			HookY += VectorY(4, HookAngle);
			Link->X = LinkX;
			Link->Y = LinkY;
			Link->Jump = 0;
			if(GrappleDetect(HookX, HookY)>-1 && !Switched){
				HookX = ComboX(GrappleDetect(HookX,HookY));
				HookY = ComboY(GrappleDetect(HookX,HookY));
				loc= ComboAt(HookX,HookY);
				Grapple = true;
				break;
			}
			else if(GrappleSolid(HookX, HookY)||!InputButtonItem(I_SWITCH_HOOK)
					||HookX<0||HookX>240||HookY<0||HookY>160||!Damage->isValid())
				break;
			SFXTimer = __TimedSFX(SFXTimer, SFX_GRAPPLESOUND, FREQ_GRAPPLESOUND);
			if(Damage->isValid()){
				Damage->Dir = Link->Dir;
				Damage->X = HookX;
				Damage->Y = HookY;
			}
			Hookshot_Waitframes(HookStartX,HookStartY,HookX,HookY,HookAngle,Length,TIL_GRAPPLEHOOK,2);
		}
		if(Damage->isValid())
			SetLWeaponFlag(Damage,LWF_PIERCES_ENEMIES);
		if(Grapple && !Switched){
			int cmbX = ComboX(loc);
			int cmbY = ComboY(loc);
			int lx = CenterLinkX();
			int ly = CenterLinkY();
			int cmbD = Screen->ComboD[loc];
			int newCSet = Screen->ComboC[loc];
			int cmbLink = ComboAt(lx,ly);
		    int oldcmb = Screen->ComboD[cmbLink];
			int oldCSet = Screen->ComboC[cmbLink];
			Screen->ComboD[cmbLink] = cmbD;
			Screen->ComboC[cmbLink] = newCSet;
			Screen->ComboD[loc]= oldcmb;
			Screen->ComboC[loc] = oldCSet;
			Link->X = cmbX;
			Link->Y = cmbY;
			Game->PlaySound(SFX_SWITCHHOOK);
			Switched = true;
		}
		while(Distance(HookStartX, HookStartY, HookX, HookY)>8 ){
			if(Damage->isValid()){
				Damage->Dir = Link->Dir;
				Damage->X = HookX;
				Damage->Y = HookY;
			}
			HookStartX = Link->X+HookX(Link->Dir);
			HookStartY = Link->Y+HookY(Link->Dir);
			HookAngle = Angle(HookStartX, HookStartY, HookX, HookY);
			HookX += VectorX(8, HookAngle-180);
			HookY += VectorY(8, HookAngle-180);
			SFXTimer = __TimedSFX(SFXTimer, SFX_GRAPPLESOUND, FREQ_GRAPPLESOUND);
			Link->InputUp = false;
			Link->InputDown = false;
			Hookshot_Waitframes(HookStartX,HookStartY,HookX,HookY,HookAngle,Length,TIL_GRAPPLEHOOK,2);
		}
		KillLWeapon(Damage);
	}
}
