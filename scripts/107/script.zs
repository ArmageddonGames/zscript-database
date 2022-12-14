//import "std.zh"

///////////////////////////////////////
/// ItemHandling.zh                 ///
/// v6.7, originally by grayswandir ///
/// 23rd September, 2014            ///
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// This is a global function set for handling item interaction.                                            ///
/// The original authors of this function set are grayswandir, who provided it to me, for use in TGC,       ///
/// and SUCCESSOR, who contributed item use functions. I use it for so many components, that in sharing     ///
/// other scripts, I may as well make it a header, to provide the functionality needed for many FFC scripts ///
/// that I make available to others, operable without duplicating these functions in every instance.        ///
/// I may expand on it at some future point.                                                                ///
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////
/// Global Constants ///
////////////////////////
 
const int MISC_LWEAPON_ITEM = 0; // The id of the item used to create an lweapon.
 
////////////////////////
/// Global Variables ///
////////////////////////
 
int LastItemUsed = 0; // The item id of the last item Link has used.
bool itemActivate = false;
 
////////////////////////
/// Global Functions ///
////////////////////////
 
void UpdateLWeapons() {     //// Updates every LWeapon on screen. Call in the active script.
    for (int i = 1; i <= Screen->NumLWeapons(); i++) {
        UpdateLWeapon(Screen->LoadLWeapon(i));
    }
}
 

void UpdateLWeapon(lweapon lw) {    //// Update a given LWeapon.
// If the weapon does not have it's source item marked, mark it as being created by the last item that Link has used.
    if (lw->Misc[MISC_LWEAPON_ITEM] == 0) {
        lw->Misc[MISC_LWEAPON_ITEM] = LastItemUsed;
    }
}
 
/////////////////////////////////////////////////////////////////////////
/// Updates the LastItemUsed variable to our best guess at what was   ///
/// most recently used. This should be called at the end of the loop, ///
/// right before Waitdraw or Waitframe, because the item marked in    ///
/// LastItemUsed isn't actually used until after the Waitdraw or      ///
/// Waitframe.                                                        ///
/////////////////////////////////////////////////////////////////////////


void UpdateLastItem() {

  // Since we don't know which button has priority if both are pressed
  // at once, cancel the B button press if A has also been pressed
  // this frame.
  
    if (Link->PressA && Link->PressB) {
        Link->PressB = false;
    }

    // If Link is currently in an action where he obviously can't use items, then ignore his button presses.
    if (Link->Action != LA_NONE &&      
        Link->Action != LA_WALKING) {
            return;
    }

    // Check which button is being pressed, if any. Also check for the appopriate Jinx.

    if (Link->PressA && Link->SwordJinx == 0) {
        LastItemUsed = GetEquipmentA();
    }
    else if (Link->PressB && Link->ItemJinx == 0) {
        LastItemUsed = GetEquipmentB();
        }
}
 


bool IsFromItem(lweapon lw, int itemNumber) {   //// Return true if the given lweapon is from the given item.
    return lw->Misc[MISC_LWEAPON_ITEM] == itemNumber;
}
 


bool IsFromItemClass(lweapon lw, int itemClass) {   //// Return true if the given lweapon is from the given item class.
    itemdata data = Game->LoadItemData(lw->Misc[MISC_LWEAPON_ITEM]);
    return data->Family == itemClass;
}

//Changes B to specified item
void SetItemB(int it){
    if (Link->Item[it] == true) {
        //save current item to mark where we started
        int storeB = GetEquipmentB();
        
        //move to next item before checking conditions
        do Link->SelectBWeapon(DIR_RIGHT);
        
        //if Item B is the right item or the item we started at stop
        while(GetEquipmentB() != it && storeB != GetEquipmentB())

        //added check to confirm 
            //return GetEquipmentB() == it;
    }
}

void UseItemOnB(int input){
    int EquipB = GetEquipmentB();
    SetItemB(input);
    Link->InputB = true;
    Waitframe();
    SetItemB(EquipB);
	itemActivate = false;
}

bool SetCheckItemB(int it){
	SetItemB(it);
	return GetEquipmentB() == it;
}


//Change A to specified item
void SetItemA(int it){
    if (Link->Item[it] == true) {
        //save current item to mark where we started
        int storeA = GetEquipmentA();
        
        //move to next item before checking conditions
        do Link->SelectAWeapon(DIR_RIGHT);
        
        //stop if Item A is the right item or the item we started at
        while(GetEquipmentA() != it && storeA != GetEquipmentA())

        //added check to confirm 
            //return GetEquipmentA() == it;
    }
}

void UseItemOnA(int input){
    int EquipA = GetEquipmentA();
    SetItemA(input);
    Link->InputA = true;
    Waitframe();
    SetItemA(EquipA);
}

bool SetCheckItemA(int it){
	SetItemA(it);
	return GetEquipmentA() == it;
}



int buttonItems[11]={0,0,0,0,0,0,0,0,0,0,0};

const int BUTTON_A = 0;
const int BUTTON_B = 1;
const int EXTRA_BTN_L = 2;
const int EXTRA_BTN_R = 3;
const int EXTRA_BTN_EX1 = 4;
const int EXTRA_BTN_EX2 = 5;
const int EXTRA_BTN_EX3 = 6;
const int EXTRA_BTN_EX4 = 7;
const int STORED_ITEM_A = 8;
const int STORED_ITEM_B = 9;
const int STORED_ITEM_EXTRA = 10;

// Functions to keep items in array current for A and B items.

void updateButtonA(){
        buttonItems[BUTTON_A] = GetEquipmentA();
}

void updateButtonB(){
        buttonItems[BUTTON_A] = GetEquipmentB();
}

//Functions to store items for each button.

void storeItemA(int itemStored){
    buttonItems[STORED_ITEM_A] = itemStored;
}

void storeItemB(int itemStored){
    buttonItems[STORED_ITEM_B] = itemStored;
}

void storeItemL(int itemStored){
    buttonItems[EXTRA_BTN_L] = itemStored;
}

void storeItemR(int itemStored){
    buttonItems[EXTRA_BTN_R] = itemStored;
}

void storeItemEx1(int itemStored){
    buttonItems[EXTRA_BTN_EX1] = itemStored;
}

void storeItemEx2(int itemStored){
    buttonItems[EXTRA_BTN_EX2] = itemStored;
}

void storeItemEx3(int itemStored){
    buttonItems[EXTRA_BTN_EX3] = itemStored;
}

void storeItemEx4(int itemStored){
    buttonItems[EXTRA_BTN_EX4] = itemStored;
}


void swapItemsAB(){
    buttonItems[STORED_ITEM_A] = GetEquipmentA();
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemA(buttonItems[STORED_ITEM_B]);
    SetItemB(buttonItems[STORED_ITEM_A]);
}
    


//Use items.

void useItem(int itemToUse){
    buttonItems[STORED_ITEM_EXTRA] = GetEquipmentB();
    SetItemB(itemToUse);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_EXTRA]);
}

void useButtonA() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[BUTTON_A]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonB() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[BUTTON_B]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonL() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[EXTRA_BTN_L]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonR() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[EXTRA_BTN_R]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonEx1() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[EXTRA_BTN_EX1]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonEx2() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[EXTRA_BTN_EX2]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonEx3() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[EXTRA_BTN_EX3]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

void useButtonEx4() {
    buttonItems[STORED_ITEM_B] = GetEquipmentB();
    SetItemB(buttonItems[EXTRA_BTN_EX4]);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[STORED_ITEM_B]);
}

//We need a PressR (set item to R), script.



void useR_Item(int itemToUse){
    buttonItems[BUTTON_B] = GetEquipmentB();
    SetItemB(itemToUse);
    Link->InputB = true;
    Waitframe();
    SetItemB(buttonItems[BUTTON_B]);
}

bool lWeaponExists(int LType){
	for (int i = Screen->NumLWeapons(); i > 0; i--){
		lweapon e = Screen->LoadLWeapon(i);
		if ( e->ID == LType ){
			return true;
		}
		else {
			return false;
		}
	}
}



ffc script useRItem{ 
	void run(int input){
		//store B
		int EquipB = GetEquipmentB();
		
		//set B to "R" item
		SetItemB(input);
		
		//tell game that B was pressed
		Link->InputB = true;
		
		//wait a frame so game triggers B 
		Waitframe();
		
		//reset B
		SetItemB(EquipB);
	}
}

//Shouldn't this just be a function? 


///////////////////////////
/// General Use Scripts ///
///////////////////////////

ffc script NoDrops {
    void run() {
        npc en;
        while(true) {
            for(int i=1; i<=Screen->NumNPCs(); i++)
            {
                en=Screen->LoadNPC(i);
                if(en->ItemSet!=IS_NONE)
                    en->ItemSet=IS_NONE;
            }

            Waitframe();
        }
    }
}

ffc script removeDrops{
    void run(){
        while(true){
            for(int i = 1; i <= Screen->NumItems(); i++){
                item drop = Screen->LoadItem(i);
                if(drop->Pickup & IP_TIMEOUT){
                    Remove(drop);
                }
            }
            Waitframe();
        }
    }
}

item script playMessage{
    void run(int message){
        Screen->Message(message);
    }
}

item script playSound{
    void run(int soundEffect){
        Game->PlaySound(soundEffect);
    }
}

///Generic FFC Lweapon (or Item) Trigger, from grayswandir
//D0 Item to Trigger Event
//D1 Combo to Change (- Flags to Change)
//D2 COmbo to become (- Map & Screen to use to change flagged combos)
//D3 ???
//D4 Sound to Play
//D5 Message to Display.
//D6 
//D7 


////////////////
//// When hit by an LWeapon satisfying the <trigger> condition, change
//// all combos on screen that match the <target> condition to what
//// <result> specifies.
////
//// <trigger>: This is what kind of LWeapon will trigger the combo
//// change. If positive, it specifies the item number that will
//// trigger this (e.g. I_ARROW2 will make Silver Arrows trigger
//// this). If negative or 0, it specifies the item class that will
//// trigger this (e.g. -IC_ARROW will make any arrow trigger this).
////
//// <target>: This is what combos that this trigger will change when
//// it is actually triggered. If positive, it specifies that all
//// combos on screen with the given Combo ID will be changed (e.g. a
//// 12 means change all instances of combo 12). If negative, it
//// specifies that all combos on screen with the given flag will be
//// changed (e.g. a -CF_SECRETS01 means to change all combos with the
//// Secret 1 flag on them).
////
//// <result>: This is what the target combos are changed to. If
//// positive, it specifies a combo id to change them to. If negative,
//// it instead specifies a map and screen to grab combos from. The
//// format is "-MMMYXX", where MMM is the map number, Y is the
//// screen's Y position on that map (from 0 to 7), and XX is the
//// screen's X position on that map (from 0 to 15). Every target
//// combo is changed to whatever combo is at the same coordinates on
//// that screen.
////
//// <dieOnComboChange>: If positive, this causes this ffc to cancel
//// if the combo underneath the ffc every changes its Combo ID.
////
//// <sound>: If this is non-zero, it causes the given sound to be
//// played when the trigger occurs.
////
//// <message>: If this is non-zero, it causes the given message to be
//// displayed when the trigger occurs.

ffc script GenericFFCTrigger {
    void run(int trigger, int target, int result, int dieOnComboChange, int sound, int message) {
        // Grab the combo id underneath us so we can tell when it changes.
        int loc = ComboAt(CenterX(this), CenterY(this));
        int underComboId = Screen->ComboD[loc];
     
        // Interpret <result> if it is negative.
        int map;
        int screen;
        if (result < 0) {
            map = (result * -0.001) >> 0;
            screen = ((result * -0.01 % 10) >> 0) * 16 + (-result % 100);
        }
 
        // Wait for something to happen.
        bool waiting = true;
        while (waiting) {

            // If <dieOnComboChange> is set and the combo does change, terminate.
            if (dieOnComboChange > 0 && Screen->ComboD[loc] != underComboId) {
                return;
            }

            // Loop through all LWeapons on screen.
            for (int i = 1; i <= Screen->NumLWeapons(); i++) {
                lweapon lw = Screen->LoadLWeapon(i);

                // If the LWeapon is touching us.
                if (lw->CollDetection && Collision(this, lw)) {

                    // If <trigger> is positive, test the lweapon for being the
                    // right item type.
                    if (trigger > 0) {
                        if (IsFromItem(lw, trigger)) {
                            waiting = false;
                        }
                    }

                    // If <trigger> is negative, test the lweapon for being the
                    // right item class.
                    else {
                        if (IsFromItemClass(lw, -trigger)) {
                          waiting = false;
                        }
                    }
                }
            }

            // Advance to next frame.
            Waitframe();
        }
 
        // If we reach this point, it means that we've successfully been
        // hit by an acceptable LWeapon.

        // Now loop through every combo on screen looking for combos
        // matching <target>.
        for (loc = 0; loc < 176; loc++) {
            bool match = false;

            // If <target> is positive, test for Combo ID.
            if (target > 0) {
                if (Screen->ComboD[loc] == target) {
                    match = true;
                }
            }

            // If <target> is negative, test for the flag being present.
            else if (target < 0) {
                if (ComboFI(loc, -target)) {
                    match = true;
                }
            }

            // If the current combo is a match, then transform the combo
            // according to <result>.
            if (match) {

                // If <result> is positive, just change the target to <result>.
                if (result > 0) {
                    Screen->ComboD[loc] = result;
                }
                // If <result> is negative, grab the combo from the given screen.
                else if (result < 0) {
                    Screen->ComboD[loc] = Game->GetComboData(map, screen, loc);
                }
            }
        }

        // Now play the message and sound, if appropriate.
        if (sound != 0) {
            Game->PlaySound(sound);
        }
        if (message != 0) {
            Screen->Message(message);
        }
    }
}
 

//////////////////////////////
/// CREDITS (ALPHABETICAL) ///
//////////////////////////////

///////////////////////////
/// Programming Credits ///
/////////////////////////////////////////////////////////////////////////
/// Aevin                                                             ///
/// Alucard                                                           ///
/// blackbishop89                                                     ///
/// Gleeok (Assorted functions, that led to this.)                    ///
/// grayswandir (Original creatorof most funtions herein.)            ///        
/// jsm116 (FFCs and FFC functions.)                                  ///
/// MasterManiac                                                      ///
/// MoscowModder (Too much to list; possible also UseRItem)           ///
/// Saffith (Tango, Ghost, FFCs, etc.)                                ///
/// SUCCESSOR (Set/Use Item Funtions)                                 ///
/// Zecora (Forum discussions, and assistance.)                       ///
/// ZoriaRPG (Library Maintainer, packaging, testing, some code etc.) ///
/////////////////////////////////////////////////////////////////////////