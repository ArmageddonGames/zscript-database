//////////////////////////
/// Title Screen FFC   ///
///   By: ZoriaRPG     ///
///  With Assistance   ///
/// From: MasterManiac ///
//////////////////////////////////////////////////////////////////////////////
/// This script is used to run a title screen, using FFCs, and uses one    ///
/// FFC to establish the functions of the title screen, which begins the   ///
/// game by pressing the START button, as one might expect to happen in    ///
/// games that actually *have* a START button.                             ///
///                                                                        ///
/// You may change the button to suit your game, by replacing ImputStart   ///
/// with the desired input, such as InputEx1, if you want a game to start  ///
/// by pressing SELECT, such as a few Kusoge titles do, that I can recall. ///
///                                                                        ///
/// Set to 'Run at Screen init' in FFC Flags!                              ///
//////////////////////////////////////////////////////////////////////////////
///                            ...............                             ///
///                             FFC ARGUMENTS                              ///
///                            ...............                             ///
///---------------------------{ D0: Start SFX }----------------------------///
/// D0: SFX to play when the player presses 'START'.                       ///
/// Set from Quest->Audio->SFX Data.                                       ///
///---------------------------{ D1: Delay Time }---------------------------///
/// D1: Length of time, between pressing start, and the game starting.     ///
/// Time this to match your SFX, where 60 = 1-second.                      ///
/// (240, would therefore be four-seconds, and is my default value.)       ///
///----------------------{ D2/D3: Warp Destinations }----------------------///
/// D2: If using a direct warp, set this to the DMAP number for the warp   ///
/// (not the 'Map' number, but the 'DMAP' number), stating at 0.           ///
/// D3: If using direct warps, set this to the screen number for the       ///
/// warp destination. This will use WARP RETURN 'A'.                       ///
///------------------------{ D4: Secret Warp Mode }------------------------///
/// D4: If you are going to use a SENSITIVE WARP tile, placed under the    ///
/// player, to control the warp (and thus, control fade effects), then     ///
/// set this to a value of '1' (or greater). Set warp destinations from    ///
/// Screen->Tilewarp, and set your tile warp combo in Screen->Secrets, as  ///
/// SECRET TILE 0, then place Flag-16 over where the player is caged on    ///
/// your title screen.                                                     ///
//////////////////////////////////////////////////////////////////////////////


ffc script titleScreen {
    void run(int SFX, int timeValue, int W_DMAP_NUMBER, int W_SREEN_NUMBER, int secrets) {
    Link->InputStart = false; //present subscreen from falling.
    bool waiting = true; //Establish main while loop.
    bool pressed = false; //Establish timer requirements.
    int timer = 0; //Set timer to exist.
    
        while(waiting){  //The main while loop. 
             
            if (Link->InputStart) {  //Is the player presses START
                Link->InputStart = false; //Keep subscreen from falling.
                pressed = true; //Initiate countdown timer.
                Game->PlaySound(SFX); //Play SFX set in D0.
            }
            if(pressed){   //Run Timer
                timer++;   //Timer counts up, until it reaches amount set in D1.
            }
            
            if(timer >= timeValue){  //if timer is equal to, or greater than value of D1.
                if ( secrets > 0 ) {  //If D4 is set to 1 or higher...
                    Screen->TriggerSecrets();  //Trigger secret combos. Use this if using a warp combo.
                }
                else {  //If D4 is set to 0, and we are using direct warps...
                    Link->Warp(W_DMAP_NUMBER, W_SREEN_NUMBER);  //Warp Link to the DMAP set in D2, and the screen set in D3, using Warp Return A.
                }
            }
            Waitframe(); //Pause, to cycle the loop.
        }
    }
}