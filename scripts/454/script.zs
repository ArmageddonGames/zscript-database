const int NOFRIC_ICE_NOSLIP = 124; //Item that prevents slipping on stuff

const int CT_NOFRIC_ICE = 146;//Combo type used for defining frictionless ice

int slipdir=-1;

bool isScrollingNF=false;

//Frictionless Ice
//A common hazard in verious RPG games. As soon as one steps on this cruel combo, he will slide indefinetly, across atright line, 
//out of control, until either hitting solid combo, non-slippery stuff, or stright into hazard.
//Combine global script.

//You can place flags #62(up), #63(down), #64(left), 65(right) to turn frictionless ice combos into irresistible conveyer belts. Only placed flags work.

global script FrictionlessIceCombos{
	void run(){		
	
		int oldscreen = Game->GetCurScreen();
		int iceconveyor[176];
		SetupIce2Combos(iceconveyor);
		
		while(true){
		
			UpdateIcyInput();
			Waitdraw();
			
			FrictionlessIceUpdate(iceconveyor);
			oldscreen = Game->GetCurScreen();
			
			Waitframe();
		}
	}
}

void SetupIce2Combos(int iceconveyor){
	slipdir=-1;
	isScrollingNF=false;
	UpdateIcyConveyors(iceconveyor);
}

void UpdateIcyInput(){
	if (slipdir>=0){
		Link->InputUp=false;
		Link->InputDown=false;
		Link->InputLeft=false;
		Link->InputRight=false;
		if (slipdir==DIR_UP)Link->Y-=2;
		else if (slipdir==DIR_DOWN)Link->Y+=2;
		else if  (slipdir==DIR_LEFT)Link->X-=2;
		else if (slipdir==DIR_RIGHT)Link->X+=2;
		Link->Dir=slipdir;
	}
}

void FrictionlessIceUpdate (int iceconveyor){
	if (Link->Action==LA_SCROLLING){
		isScrollingNF=true;
		return;
	}
	else{
		if (isScrollingNF){
			UpdateIcyConveyors(iceconveyor);
			isScrollingNF=false;
		}
		if (Link->InputUp || Link->InputDown || Link->InputLeft || Link->InputRight){
			slipdir=OnIce2();
			if (slipdir>=0){
				int cmb = ComboAt(Link->X + 8, Link->Y + 12 );
				if (iceconveyor[cmb]>=0) slipdir=iceconveyor[cmb];
			}
		}
	}
	if (slipdir>=0){
		Link->Dir=slipdir;
		SlipUpdateWallCollision(slipdir);
		if (slipdir<0) return;
		slipdir=OnIce2();
		if (slipdir>=0){
			int cmb = ComboAt(Link->X + 8, Link->Y + 12 );
			if (iceconveyor[cmb]>=0){
				if (slipdir!=iceconveyor[cmb]){
					Link->X=ComboX(cmb);
					Link->Y=ComboY(cmb);
				}
				slipdir=iceconveyor[cmb];			
			}
		}
	}
	//if (Link->InputEx2){
	//	debugValue(1,slipdir);
	//	for (int i=0; i<176; i++){
	//		Screen->DrawInteger(2, ComboX(i), ComboY(i),0, 1,0 , -1, -1, iceconveyor[i], 0, OP_OPAQUE);
	//	}
	//}
}

void SlipUpdateWallCollision(int dir){
	int collpointsx[2];
	int collpointsY[2];
	if (dir==DIR_UP){
		collpointsx[0]=Link->X+1;
		collpointsx[1]=Link->X+14;
		collpointsY[0]=Link->Y+7;
		collpointsY[1]=Link->Y+7;
	}
	if (dir==DIR_DOWN){
		collpointsx[0]=Link->X+1;
		collpointsx[1]=Link->X+14;
		collpointsY[0]=Link->Y+16;
		collpointsY[1]=Link->Y+16;
	}
	if (dir==DIR_LEFT){
		collpointsx[0]=Link->X-1;
		collpointsx[1]=Link->X-1;
		collpointsY[0]=Link->Y+9;
		collpointsY[1]=Link->Y+14;
	}
	if (dir==DIR_RIGHT){
		collpointsx[0]=Link->X+16;
		collpointsx[1]=Link->X+16;
		collpointsY[0]=Link->Y+9;
		collpointsY[1]=Link->Y+14;
	}
	if (Screen->isSolid(collpointsx[0], collpointsY[0]) || Screen->isSolid(collpointsx[1], collpointsY[1])) slipdir=-1;
}

void UpdateIcyConveyors(int iceconveyor){
	for (int i=0; i<176; i++){
		iceconveyor[i]=-1;
		if(Screen->ComboT[i] == CT_NOFRIC_ICE ){
			if (ComboFI(i,62)){
				iceconveyor[i]=DIR_UP;
				Screen->ComboF[i]=0;
			}
			if (ComboFI(i,63)){
				iceconveyor[i]=DIR_DOWN;
				Screen->ComboF[i]=0;
			}
			if (ComboFI(i,64)){
				iceconveyor[i]=DIR_LEFT;
				Screen->ComboF[i]=0;
			}
			if (ComboFI(i,65)){
				iceconveyor[i]=DIR_RIGHT;
				Screen->ComboF[i]=0;
			}
			if (Link->InputEx2)Screen->DrawInteger(2, ComboX(i), ComboY(i),0, 1,0 , -1, -1, iceconveyor[i], 0, OP_OPAQUE);
		}
		else if(Screen->LayerScreen(1) != -1 ){ 
			if (GetLayerComboT(1, i) == CT_NOFRIC_ICE ){
				if ( GetLayerComboF(1, i)==62){
					iceconveyor[i]=DIR_UP;
					SetLayerComboF(1, i, 0); 
				}
				if ( GetLayerComboF(1, i)==63){
					iceconveyor[i]=DIR_DOWN;
					SetLayerComboF(1, i, 0); 
				}
				if ( GetLayerComboF(1, i)==64){
					iceconveyor[i]=DIR_LEFT;
					SetLayerComboF(1, i, 0); 
				}
				if ( GetLayerComboF(1, i)==65){
					iceconveyor[i]=DIR_RIGHT;
					SetLayerComboF(1, i, 0); 
				}
			}
		}
		else if(Screen->LayerScreen(2) != -1 ){ 
			if (GetLayerComboT(2, i) == CT_NOFRIC_ICE ){
				if ( GetLayerComboF(2, i)==62){
					iceconveyor[i]=DIR_UP;
					SetLayerComboF(2, i, 0); 
				}
				if ( GetLayerComboF(2, i)==63){
					iceconveyor[i]=DIR_DOWN;
					SetLayerComboF(2, i, 0); 
				}
				if ( GetLayerComboF(2, i)==64){
					iceconveyor[i]=DIR_LEFT;
					SetLayerComboF(2, i, 0); 
				}
				if ( GetLayerComboF(1, i)==65){
					iceconveyor[i]=DIR_RIGHT;
					SetLayerComboF(2, i, 0); 
				}
			}
		}
	}
}

//Function used to check if Link is over a ice combo.
int OnIce2() {
	if (Link->Item[NOFRIC_ICE_NOSLIP]) return -1;
    if(Link->Z != 0)return -1;
    int comboLoc = ComboAt(Link->X + 8, Link->Y + 12 );
    if(Screen->ComboT[comboLoc] == CT_NOFRIC_ICE ) return Link->Dir;
	if(Screen->LayerScreen(1) != -1 ){ 
	if (GetLayerComboT(1, comboLoc) == CT_NOFRIC_ICE ) return Link->Dir;
	}
	if(Screen->LayerScreen(2) != -1 ){ 
	if (GetLayerComboT(2, comboLoc) == CT_NOFRIC_ICE ) return Link->Dir;
	}
    return -1;
}