import "std.zh"
import "ffcscript.zh"

item script warpDoll {
void run(int ffcScriptNum1, int ffcScriptNum2, int itemCombo, int itemCSet, int LinkCombo, int LinkCSet, float time, int animType) {

//*******************************************************************************
// Item Arguments:
// D0: The slot of the FFC script switchLink
// D1: The slot of the FFC script appearAtLink
// D2: The combo number that the Warp Doll should use when placed.
// D3: The CSet of the Warp Doll when placed.
// D4: The combo to use for Link as he is warping. If set to 0, Link's current frame of animation is used (and D5 is ignored).
// D5: The CSet to use for the combo in D4.
// D6: The number of seconds the animation takes to complete.
// D7: The animation type. Setting this to 1 will use straight lines to switch. Setting this to 2 will use circular switching.
//
//*******************************************************************************

int dollFFCNum = FindFFCRunning(ffcScriptNum2);
if(dollFFCNum == 0) {
// Doll is not yet on the ground, so we run the FFC script appearAtLink to place it there.
int args[] = {itemCombo, itemCSet, ffcScriptNum1};
RunFFCScript(ffcScriptNum2, args);
}

else {
// Doll is on the ground.
// Load the FFC into a local variable.
ffc dollFFC = Screen->LoadFFC(dollFFCNum);

if(SquareCollision(Link->X+2, Link->Y+2, 12, dollFFC->X, dollFFC->Y, 16)) {
// Link is touching the doll. Pick it up and stop the FFC script.
dollFFC->Script = 0;
dollFFC->Data = FFCS_INVISIBLE_COMBO;
}

else {
// Link is not touching the doll. Run the FFC script switchLink.
int args[] = {dollFFCNum, LinkCombo, LinkCSet, time, animType};
RunFFCScript(ffcScriptNum1, args);
}
}
}
}

// This script switches the locations of Link and the doll.
ffc script switchLink{
void run(int dollFFCNum, int LinkCombo, int LinkCSet, int time, int animType) {

int sfx_num = 59;

// Load the doll FFC into a local variable.
ffc dollFFC = Screen->LoadFFC(dollFFCNum);

if(LinkCombo != 0) {
// The combo for Link's FFC is set.

// "This" FFC is the FFC representing Link during the warp.
this->Data = LinkCombo;
this->CSet = LinkCSet;
}

// Turn off Link's collision detection and make him invisible.
Link->CollDetection = false;
Link->Invisible = true;

// Place the "Link" FFC on Link's current position. If we're using Link's sprite instead of the FFC, the FFC position still needs to be set.
this->X = Link->X;
this->Y = Link->Y;

// Store the position where Link will be at the end of the warp.
int newLinkX = dollFFC->X;
int newLinkY = dollFFC->Y;

// Store the position where the Doll FFC will be at the end of the warp.
int newDollX = Link->X;
int newDollY = Link->Y;

// Play sound effect at beginning of warp.
Game->PlaySound(sfx_num);

if(animType == 1) {
// Straight-line Animation

// Set the x and y velocity of the Link FFC so that it reaches the final destination in time seconds.
this->Vx = (dollFFC->X - this->X)/(60*time);
this->Vy = (dollFFC->Y - this->Y)/(60*time);

// The Doll FFC has the negative velocity of the "Link" FFC, so that both are going at the same speed in opposite directions.
dollFFC->Vx = -(this->Vx);
dollFFC->Vy = -(this->Vy);

for(int i=1; i<=60*time; i++) {
// For all frames of animation...

if(LinkCombo == 0) {
// We're drawing Link's tiles instead of an FFC for animation.
Screen->FastTile(4, this->X, this->Y, Link->Tile, 6, OP_OPAQUE);
}

// Wait another frame of animation.
WaitNoAction();
}

// Change the velocity of both FFCs to 0.
this->Vx = 0;
this->Vy = 0;
dollFFC->Vx = 0;
dollFFC->Vy = 0;
}

else if(animType == 2) {
// Circle Animation

// Find the center between the two FFCs.
int centerX = (this->X + dollFFC->X)/2;
int centerY = (this->Y + dollFFC->Y)/2;

// Find the Link starting position relative to the center of the circle.
int linkStartX = this->X - centerX;
int linkStartY = this->Y - centerY;

// Find distance between the center of the circle and Link's starting position.
float hypotenuse = Sqrt(Pow(linkStartX,2) + Pow(linkStartY,2));

// Find the starting angle of Link relative to the center of the circle.
int startAngle = ArcTan(linkStartX, linkStartY);

for(int i=1; i<=60*time; i++) {
// Update every frame for time seconds.

// Find X and Y coordinates after rotating Link by i*PI/(Floor(60*time)) radians.
int tempX = centerX + hypotenuse*RadianCos(startAngle + i*PI/(Floor(60*time)));
int tempY = centerY + hypotenuse*RadianSin(startAngle + i*PI/(Floor(60*time)));

if(tempX <= -32) {
this->X = -31;
}
else if(tempX >= 288) {
this->X = 287;
}
else {
this->X = tempX;
}

if(tempY <= -32) {
this->Y = -31;
}
else if(tempY >= 208) {
this->Y = 207;
}
else {
this->Y = tempY;
}

// The Doll FFC position should be opposite the Link FFC with respect to the center of the circle.
tempX = -tempX + 2*centerX;
tempY = -tempY + 2*centerY;

if(tempX <= -32) {
dollFFC->X = -31;
}
else if(tempX >= 288) {
dollFFC->X = 287;
}
else {
dollFFC->X = tempX;
}

if(tempY <= -32) {
dollFFC->Y = -31;
}
else if(tempY >= 208) {
dollFFC->Y = 207;
}
else {
dollFFC->Y = tempY;
}

if(LinkCombo == 0) {
// We're using the actual Link sprite instead of an FFC for animation, so move Link into place.
Screen->FastTile(4, this->X, this->Y, Link->Tile, 6, OP_OPAQUE);
}

// Wait one frame of animation.
WaitNoAction();
}
}

// Animation has completed - place the Doll FFC in the old Link position.
dollFFC->X = newDollX;
dollFFC->Y = newDollY;

// Also update Link's position to the Doll's old position.
Link->X = newLinkX;
Link->Y = newLinkY;

// Make Link's FFC invisible (even if it already is)...
this->Data = FFCS_INVISIBLE_COMBO;

// ...and make actual Link visible (even if he already is) and turn on collision detection.
Link->CollDetection = true;
Link->Invisible = false;
}
}

// This script makes the Doll FFC appear at Link's position.
// It runs until Link picks the doll up.
// It also moves the doll if the doll comes into contact with a solid combo.
ffc script appearAtLink{
void run(int itemCombo, int itemCSet, int ffcScriptNum1) {

// Place the Doll FFC at Link's position.
this->X = Link->X;
this->Y = Link->Y;

// Set up the Doll FFC's combo and CSet.
this->Data = itemCombo;
this->CSet = itemCSet;

// Keep running until script is manually stopped by picking up doll.
while(true) {

if(!FindFFCRunning(ffcScriptNum1)) {

if(ffcCollision(this->X, this->Y)) {
// The bottom half of the Doll FFC is overlapping with a solid portion of a combo.

// Record the Doll FFC's initial position.
int tempX = this->X;
int tempY = this->Y;

// Initialize the time. At each time instance, a different position is checked.
int t=0;

while(ffcCollision(tempX, tempY)) {
// If the Doll FFC were moved to position at tempX, tempY, then it would overlap with a solid portion of a combo.

if(t%4==0) {
// Case 1: t=4n
// Shift the Doll FFC right by t/4+1 pixels.
tempX = this->X + t/4+1;
tempY = this->Y;
}

else if(t%4==1) {
// Case 2: t=4n+1
// Shift the Doll FFC left by (t-1)/4+1 pixels.
tempX = this->X - ((t-1)/4+1);
tempY = this->Y;
}

else if(t%4==2) {
// Case 3: t=4n+2
// Shift the Doll FFC down by (t-2)/4+1 pixels.
tempX = this->X;
tempY = this->Y + (t-2)/4+1;
}

else {
// Case 4: t=4n+3
// Shift the Doll FFC up by (t-3)/4+1 pixels.
tempX = this->X;
tempY = this->Y - ((t-3)/4+1);
}

t++;
}

// A spot that's not solid has been found. Move the Doll FFC here.
this->X = tempX;
this->Y = tempY;
}
}

// Continue to next frame.
Waitframe();
}
}
}

// This function checks returns true if the lower half of an FFC combo is overlapping with the solid part of a combo.
// Otherwise, it returns false.
bool ffcCollision(int ffcX, int ffcY) {

if(Screen->isSolid(ffcX,ffcY+ 8) || Screen->isSolid(ffcX,ffcY+15) || Screen->isSolid(ffcX+8,ffcY+ 8) ||
Screen->isSolid(ffcX+8,ffcY+15) || Screen->isSolid(ffcX+15,ffcY+ 8) || Screen->isSolid(ffcX+15,ffcY+15)) {
// For the lower half rectangle of the FFC, at least one of the following points is on a solid combo:
// 1) Lower-left corner
// 2) Lower-right corner
// 3) Upper-left corner
// 4) Upper-right corner
// 5) Lower-Middle pixel
// 6) Upper-Middle Pixel
// If any of these points is on a solid combo, the function returns true.
return true;
}
else {
return false;
}
}