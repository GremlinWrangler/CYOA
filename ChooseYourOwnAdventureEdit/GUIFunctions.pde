void activeRoomDetails(int roomToShow)
{// print("ding");
   stroke(153);
   fill(0);
   rect(2, height-40, width-4,38);
   fill(255);
   text("room"+rooms[roomToShow].indexnumber,10,height-30);
   text(rooms[roomToShow].Title,20,height-20);
   text(rooms[roomToShow].colour,120,height-20);
   text(rooms[roomToShow].Description,20,height-10);
   if (mouseStateMachineValue==2) text("current Item to Link"+CurrentlySelectedItem,160,height-20);
   else text("mouse state"+mouseStateMachineValue,160,height-20);
   
}
int mousePositionCheck(int xPos, int yPos){
 int foundMarker =0;
 
 
 for (int counter=0; counter<RoomCount;counter++){
  int boxXpos=rooms[counter].Xpos;
  int boxYpos=rooms[counter].Ypos;
  if (xPos>boxXpos&&xPos<boxXpos+boxSize&&yPos>boxYpos&&yPos<boxYpos+boxSize/4){
       
       foundMarker=counter;
       counter=RoomCount;
    }    
  } 
 return foundMarker;  
}

int clickedAlinkLine(int x,int y){
  int linkClickedOn = 0;
  float shortestdistance = 1000;
  for (int counter=0; counter<RoomCount;counter++){
       if (rooms[CurrentlySelectedRoom].roomLinks[counter]==true){
           int x1=rooms[CurrentlySelectedRoom].Xpos+boxSize/2;
           int x2=rooms[counter].Xpos+boxSize/2;
           int y1=rooms[CurrentlySelectedRoom].Ypos+boxSize/8;
           int y2=rooms[counter].Ypos+boxSize/8;
           int midpointx = (x2-x1)/2+x1;
           int midpointy = (y2-y1)/2+y1;
           float angle=atan2(y2-y1,x2-x1);
           int halfPointX=midpointx+floor(sin(angle)*10);
           int halfPointY=midpointy-floor(cos(angle)*10);
           float distance = sqrt(sq(halfPointX-x)+sq(halfPointY-y));
           
           if (distance<15){
             if (distance<shortestdistance)
               {
               linkClickedOn=counter;
                shortestdistance=distance;
             }
           }
       }
    }
  
  return linkClickedOn;
  
}

char returnRandomLetter(){
 char [] validChars = {'b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z',' ','9','7','6'}; 
 int randomIndex=floor(random(0,24));
 return validChars[randomIndex];
}

void drawMask(int itemNumber,int roomNumber,int debugState){//debugState ==1 equals drawn and coloured grid, 2 equals outline for making mask, 3 equals grid for a room page
  int maskeWidth = 20;
  int gridSize =14;
  int itemIndex =0;
  int lineNumber =0;
  int columnNumber =0;
  int xOffset=700;
  int yoffset=300;
  int maskArrayLength = itemMaskLengths.length;
  int [] itemCharacterCountArray = new int [itemCount];
  
  if (debugState==3){fill(255);rect(xOffset,yoffset,gridSize*21,gridSize*22);}
  for (int outerLoop=0;outerLoop<10;outerLoop++)
    {  
      for (int innerLoop=0;innerLoop<maskArrayLength;innerLoop++)
      {
          int newBlockWidth=itemMaskLengths[innerLoop];
         
          if (debugState==1){  fill((itemIndex*100)%256,(itemIndex*100)%128*2,(itemIndex*100)%64*4);} else fill(0);
            if (debugState==1||(debugState==2&&itemNumber==itemIndex)) rect( xOffset+columnNumber*gridSize,yoffset+lineNumber*gridSize,newBlockWidth*gridSize,gridSize); //only draw rectangles for debug 1(test) or if selected item in grid draw mode
            fill(0);
            for (int blockIndex=0;blockIndex<newBlockWidth;blockIndex++) {
                char currentChar = returnRandomLetter();
                if (debugState==1) currentChar=' ';
                if (rooms[roomNumber].itemLinkText[itemIndex].length()>itemCharacterCountArray[itemIndex]){
                    currentChar = rooms[roomNumber].itemLinkText[itemIndex].charAt(itemCharacterCountArray[itemIndex]);
                 }
                
                if (debugState==3||debugState==1)text(currentChar,xOffset+(columnNumber+blockIndex)*gridSize+4,yoffset+lineNumber*gridSize+gridSize*4/5);
                itemCharacterCountArray[itemIndex]++;
                }
              
          columnNumber=columnNumber+newBlockWidth;
          if (columnNumber>maskeWidth) {
              columnNumber=0;
              lineNumber++;
            }
          itemIndex++;
          if (itemIndex>=itemNames.length) itemIndex=0;
      }
    }
}

String buttonPositionCheck(int xPos,int yPos){
  String returnString = "";
  int numberOfButtons = buttonTitle.length;

   for (int counter=0; counter<numberOfButtons;counter++){
     int buttonYPos = buttonStartYPos+counter*boxSize/2;
     if (xPos>buttonStartXPos&&xPos<buttonStartXPos+boxSize&&yPos>buttonYPos&&yPos<buttonYPos+boxSize/4)
        returnString=buttonTitle[counter];
   }
  for (int counter=0; counter<itemCount;counter++){//checking for items
     int buttonYPos = buttonStartYPos+counter*boxSize/2;
     if (xPos>buttonStartXPos+boxSize&&xPos<buttonStartXPos+boxSize*2&&yPos>buttonYPos&&yPos<buttonYPos+boxSize/4)
        returnString="item"+counter;
   }
  return returnString;
}

void turtleLine(int xPoint, int yPoint, float inputAngle,int distance){
      int endPointX=xPoint+floor(sin(inputAngle)*distance);
      int endPointY=yPoint-floor(cos(inputAngle)*distance);
        line(xPoint,yPoint,endPointX,endPointY);
}
/*
void drawCurvleLineSegment(int XstartingPoint,int yStartingPoint,int xEndingPoint, int yEndingPoint,int stepTotal,int stepNumber)
{
  float lineLength=sqrt(sq(XstartingPoint-xEndingPoint)+sq(yStartingPoint-yEndingPoint));
  float stepsize=lineLength/stepTotal;
  float lineAngle = =atan2(yEndingPoint-yStartingPoint,xEndingPoint-XstartingPoint);
  int onLineXPoint1 = floor(XstartingPoint+sin(lineAngle)*stepsize*stepNumber);
  int onLineYPoint1 = floor(XstartingPoint+sin(lineAngle)*stepsize*stepNumber);
} */

void drawLineBetweenRooms(int room1, int room2, String lineType)
{
  stroke(153);
  int x1=rooms[room1].Xpos+boxSize/2;
  int x2=rooms[room2].Xpos+boxSize/2;
  int y1=rooms[room1].Ypos+boxSize/8;
  int y2=rooms[room2].Ypos+boxSize/8;
  int midpointx = (x2-x1)/2+x1;
  int midpointy = (y2-y1)/2+y1;
  float angle=atan2(y2-y1,x2-x1);
  int halfPointX=midpointx+floor(sin(angle)*10);
  int halfPointY=midpointy-floor(cos(angle)*10);
//  line(x1,y1,x2,y2);
  noFill();
  if (room1==CurrentlySelectedRoom) stroke(activeLinkLines); else stroke(linkLines);
  if (lineType.length()>1) stroke(200,0,0);
  bezier(x1,y1,halfPointX,halfPointY,halfPointX,halfPointY,x2,y2);
//rect( midpointx-2, midpointy -2,5,5);
  if (room1==CurrentlySelectedRoom){
    stroke (255,0,0);
    turtleLine(halfPointX,halfPointY,angle-HALF_PI-HALF_PI/2,8);
    turtleLine(halfPointX,halfPointY,angle-HALF_PI/2,8);
    if (lineType.length()>1)text(lineType,halfPointX,halfPointY);
    else rect( halfPointX-2,halfPointY-2,5,5);
  } 
  else {
    turtleLine(halfPointX,halfPointY,angle-HALF_PI-HALF_PI/2,5);
    turtleLine(halfPointX,halfPointY,angle-HALF_PI/2,5);
  }
}

void drawButtons(){
  int numberOfButtons = buttonTitle.length;

 for (int counter=0; counter<numberOfButtons;counter++){
   int buttonYPos = buttonStartYPos+counter*boxSize/2;
   stroke(153);
   fill(0);
   rect(buttonStartXPos,buttonYPos , boxSize ,boxSize /4);
   fill(255);
   text(buttonTitle[counter],buttonStartXPos+5,buttonYPos+20);
  
 }
 for (int counter=0; counter<itemCount;counter++){
   int buttonYPos = buttonStartYPos+counter*boxSize/2;
   stroke(153);
   fill(0);
   rect(buttonStartXPos+ boxSize ,buttonYPos , boxSize ,boxSize /4);
   fill(255);
   text(itemNames [counter],buttonStartXPos+5+ boxSize ,buttonYPos+20);
 }
 
 
}