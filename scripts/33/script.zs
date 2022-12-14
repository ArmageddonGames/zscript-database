const int T_CHAIN			= 196;		//Mace Chain
const int T_HEAD			= 197;		//Mace Head
//Gives an enemy a mace to swing at Link
ffc script MaceEnemy{
	void run(int num, int maxradius, int damage){
	int counter = Rand(360);
	int spintimer;
	int radius = maxradius;
	int x; int y;
	int ret;
		Waitframes(4);
		npc e = Screen->LoadNPC(num);
		while(e->isValid()){
			spintimer = 0;
			//spin the ball
			while(spintimer < 240+Rand(120) && e->isValid()){
				SpinBall(radius,counter,num,damage,false);
				if(spintimer%90 == 0) Game->PlaySound(SFX_BRANG);
				spintimer++;
				counter = (counter+3)%360;
			Waitframe();
			}
			//pull the ball in
			while(radius > 20 && e->isValid()){
				SpinBall(radius,counter,num,damage,false);
				radius -= 2;
				counter = (counter+3)%360;
			Waitframe();
			}
			spintimer = 0;
			//spin very fast with small radius
			while(spintimer < 120 && e->isValid()){
				SpinBall(radius,counter,num,damage,false);
				if(spintimer%30 == 0) Game->PlaySound(SFX_BRANG);
				spintimer++;
				counter = (counter+10)%360;
			Waitframe();
			}
			//throw at Link
			x = Link->X;
			y = Link->Y;
			counter = 4;
			ret = 1;
			while(e->isValid() && counter > 0){
				SpinBall(counter,ArcTan((x-e->X),(y-e->Y)),num,damage,true);
				if(Abs(x-(e->X + RadianCos(ArcTan((x-e->X),(y-e->Y)))*counter)) < 4
				&& Abs(y-(e->Y + RadianSin(ArcTan((x-e->X),(y-e->Y)))*counter)) < 4){
					if(ret == 1){
						Game->PlaySound(SFX_HAMMER);
						Pause(counter,ArcTan((x-e->X),(y-e->Y)),num,damage);
					}
					//return
					ret = -1;
				}
				counter += 4*ret;
			Waitframe();
			}
			Pause(0,0,num,damage);
			//bring back to main spin position
			counter = Floor(ArcTan((x-e->X),(y-e->Y))*180/PI);
			radius = 0;
			while(radius < maxradius && e->isValid()){
				SpinBall(radius,counter,num,damage,false);
				radius += 2;
				counter = (counter+3)%360;
			Waitframe();
			}
		}
		Screen->ClearSprites(SL_EWPNS);
	}
	void Pause(int r, int c, int n, int d){
		for(int i=0;i<10;i++){
			SpinBall(r,c,n,d,true);
		Waitframe();
		}
	}
	void SpinBall(int radius, int counter, int num, int damage, bool radians){
		npc e = Screen->LoadNPC(num);
		Screen->ClearSprites(SL_EWPNS);
		for(int i=0;i<5;i++){
			eweapon ball = Screen->CreateEWeapon(EW_SCRIPT1);
			if(i<4) ball->Tile = T_CHAIN;
			else ball->Tile = T_HEAD;
			ball->Damage = damage;
			if(radians){
				ball->X = e->X + RadianCos(counter)*(radius*(i+1)/5);
				ball->Y = e->Y + RadianSin(counter)*(radius*(i+1)/5);
			}else{
				ball->X = e->X + Cos(counter)*(radius*(i+1)/5);
				ball->Y = e->Y + Sin(counter)*(radius*(i+1)/5);
			}
		}
	}
}