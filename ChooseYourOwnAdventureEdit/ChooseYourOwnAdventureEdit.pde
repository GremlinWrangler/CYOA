/**
 * Array Objects. 
 * 
 * Demonstrates the syntax for creating an array of custom objects. 
 */
 

 //  PGraphicsPDF pdf;
   
PFont mainFont;
int unit = 40;
int count;
int RoomCount=50;
int itemCount=10;
int CurrentlySelectedRoom=1;
int CurrentlySelectedItem=0;
int boxSize =80;
  int buttonStartXPos = 660;
  int buttonStartYPos = 20;
 int mouseStateMachineValue=0;
 int mouseButtonDownTime = 0;
roomRecord[] rooms;
  String [] buttonTitle = {"save","load","add","hide","name","description","pdf"};
  String [] itemNames = {"Gold Key","Iron Key","CrowBar","Lamp","Rope","Rock","Rusty knife","Treasure","Red Brick","rope" };
  int [] itemStartingLocations = {0,6,9,4,48,12,7,28,9,10};
  String fileNameToUse = "roomData.txt";
  String currentTextEdit;
  
  int [] itemMaskLengths = {3,4,5,4,5,5,3,2,4,3,4};
  
  color boxOutLine=color(200);
  color boxFill=#867C08;
  int activeBoxFill=#F5BD2F;
  color linkLines=#3166FF;
  color activeLinkLines=#9DB6FF;
  
void setup() {
  size(1400, 720);

  mainFont = createFont("Comic Sans MS", 12);
   textFont(mainFont);
  //noStroke();
  int wideCount = width / unit;
  int highCount = height / unit;
  count = wideCount * highCount;
  rooms = new roomRecord[RoomCount];

  int index = 0;
  for (int counter=0; counter<RoomCount;counter++){
   // print("ding");
        rooms[counter] = new roomRecord(counter, 1, 1, 1, random(0.05, 0.8), unit);
 
    
    }
    rooms[1].Title="castle doors";
    readDataIn();
   
}

void mousePressed() {
    int mouseDownOver = mousePositionCheck(mouseX,mouseY); 
    mouseButtonDownTime = millis();
    if (mouseDownOver==0) {
      mouseStateMachineValue=0;
      String buttonActive=buttonPositionCheck(mouseX,mouseY); //checks if we clicked a menu button, which for reasons returns a string
      if (buttonActive!=""){
          if (buttonActive=="load")readDataIn();
          if (buttonActive=="save")writeDataOut();
          if (buttonActive=="add") addNewRoom();
          if (buttonActive=="hide") hideRoom();
          if (buttonActive=="name") currentTextEdit="title";
          if (buttonActive=="description") currentTextEdit="description";
          if (buttonActive=="pdf") createPDF();
          if (buttonActive.indexOf("item")>-1){mouseStateMachineValue=2;CurrentlySelectedItem=extractTaggedIntFromString("item",buttonActive);}
          //println(buttonActive);
      }
      if (clickedAlinkLine(mouseX,mouseY)>0){rooms[CurrentlySelectedRoom].roomLinks[clickedAlinkLine(mouseX,mouseY)]=false;rooms[CurrentlySelectedRoom].roomLinkText[clickedAlinkLine(mouseX,mouseY)]="";}
    } else{ //clicked into a room box
            if (mouseStateMachineValue==0){
            mouseStateMachineValue=1;
            CurrentlySelectedRoom=mouseDownOver;}
            if (mouseStateMachineValue==2) {
              
               roomItemLink(CurrentlySelectedRoom,mouseDownOver,CurrentlySelectedItem); 
               CurrentlySelectedItem=0;
               mouseStateMachineValue=0;
             }
          }
}
void mouseReleased(){
   if (mouseStateMachineValue==1){
     mouseStateMachineValue=0;
   int mouseUpOver =  mousePositionCheck(mouseX,mouseY);
     if (CurrentlySelectedRoom>0){
     if (mouseButton == LEFT){
       if (millis()-mouseButtonDownTime>400){//differentiate click vs click/drag
         rooms[CurrentlySelectedRoom].Xpos=mouseX-boxSize/2;
         rooms[CurrentlySelectedRoom].Ypos=mouseY-boxSize/8;
       }
     }
     if (mouseButton == RIGHT){ //right mouse drag is to link rooms
         if(mouseUpOver !=CurrentlySelectedRoom||mouseUpOver>0){
            rooms[CurrentlySelectedRoom].roomLinks[mouseUpOver]=true;
            rooms[CurrentlySelectedRoom].roomLinkText[mouseUpOver]="Go to "+mouseUpOver+" to get to "+rooms[mouseUpOver].Title;
            rooms[mouseUpOver].roomLinks[CurrentlySelectedRoom]=true;
            rooms[mouseUpOver].roomLinkText[CurrentlySelectedRoom]="Go to "+CurrentlySelectedRoom+" to get to "+rooms[CurrentlySelectedRoom].Title;
         }
       }
     }
   } 
}

void keyPressed()
{

  // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
  if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')||(key >= '0' && key <= '9'||key == ' '||key== '.'||key== '?')) {
  if (currentTextEdit=="title") rooms[CurrentlySelectedRoom].Title=rooms[CurrentlySelectedRoom].Title+key;
  if (currentTextEdit=="description") rooms[CurrentlySelectedRoom].Description=rooms[CurrentlySelectedRoom].Description+key;
  }
  
  if (key==BACKSPACE){
      if (currentTextEdit=="title"&&rooms[CurrentlySelectedRoom].Title.length()>0) rooms[CurrentlySelectedRoom].Title=rooms[CurrentlySelectedRoom].Title.substring(0,rooms[CurrentlySelectedRoom].Title.length()-1);
      if (currentTextEdit=="description"&&rooms[CurrentlySelectedRoom].Description.length()>0) rooms[CurrentlySelectedRoom].Description=rooms[CurrentlySelectedRoom].Description.substring(0,rooms[CurrentlySelectedRoom].Description.length()-1);
  }
  if (key==DELETE){
      if (currentTextEdit=="title") rooms[CurrentlySelectedRoom].Title="";
      if (currentTextEdit=="description")rooms[CurrentlySelectedRoom].Description="";
  }
  if (key==ENTER){currentTextEdit="";}
}


void draw() {
  background(0);
  for (roomRecord rooms : rooms) {
    rooms.update();
    rooms.display();
  }
  drawButtons();
  activeRoomDetails(CurrentlySelectedRoom);
  drawMask(1,CurrentlySelectedRoom,1);
}