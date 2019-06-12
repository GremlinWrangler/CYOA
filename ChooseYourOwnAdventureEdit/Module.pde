class roomRecord{
  int xOffset;
  int yOffset;
  int Xpos;
  int Ypos;
  int indexnumber;
  boolean isActiveRoom = true;
  int colour =0;
  String Title;
  String Description = "blank";
  boolean [] roomLinks = new boolean[RoomCount];
  String  [] roomLinkText = new String[RoomCount];
  int [] itemLinks = new int [itemCount];
  String  [] itemLinkText = new String[itemCount];
  float x, y;
  int unit;
  int xDirection = 1;
  int yDirection = 1;
  float speed; 
 // int numberOfButtons = 20;

  
  // Contructor
  roomRecord(int index, int yOffsetTemp, int xTemp, int yTemp, float speedTemp, int tempUnit) {
    for (int counter=0; counter<RoomCount;counter++){roomLinks[counter]=false;}
    for (int counter=0; counter<itemCount;counter++){itemLinks[counter]=0;}
    indexnumber=index;
    xOffset = 0;
    yOffset = yOffsetTemp;
    x = xTemp;
    y = yTemp;
    Xpos = floor(random(0,20))*20;
    Ypos = floor(random(0,20))*20;
    speed = speedTemp;
    unit = tempUnit;
    Title=str(indexnumber);
  }
  
  // Custom method for updating the variables
  void update() {
  // print("dong");
  // println(indexnumber);
  }
  
  // Custom method for drawing the object
  void display() {
    if (isActiveRoom){
    
    for (int counter=indexnumber; counter<RoomCount;counter++){
     if (roomLinks[counter]==true){drawLineBetweenRooms(indexnumber,counter,"");} 
     if (rooms[counter].roomLinks[indexnumber]==true){drawLineBetweenRooms(counter,indexnumber,"");} 
    }
    for (int counter=0; counter<itemCount;counter++){
      if (itemLinks[counter]>0) {drawLineBetweenRooms(indexnumber,itemLinks[counter],itemNames[counter]);} 
       fill(255);
      if (itemStartingLocations[counter]==indexnumber) text(itemNames[counter],Xpos,Ypos+12+12+12);
    }
    stroke (boxOutLine);
    if (indexnumber==CurrentlySelectedRoom) fill(activeBoxFill); else fill(boxFill);
    
    rect(Xpos, Ypos, boxSize, boxSize/4);
       fill(255);
     text(""+Title,Xpos,Ypos+12);
  }
  }
}

void hideRoom(){
    rooms[CurrentlySelectedRoom].isActiveRoom=false;
    CurrentlySelectedRoom=0;
}

int addNewRoom(){
 int newRoomNumber=0;
 for (int counter=0; counter<RoomCount;counter++){
   if (newRoomNumber==0){
      if (rooms[counter].isActiveRoom==false) {
        rooms[counter].isActiveRoom=true; newRoomNumber=counter;
        rooms[counter].Title=str(counter);
        rooms[counter].Description="";
        rooms[counter].colour=0;
        rooms[counter].Xpos=20;
        rooms[counter].Ypos=20;
      }  
    }
 }
 if (newRoomNumber==0) println("all rooms in use");
 return newRoomNumber;
}

void roomItemLink(int roomfrom,int roomTo,int item){
  print("room from"+roomfrom+" roomto"+roomTo+ " itemNumber");
  if (rooms[roomfrom].itemLinks[item]==roomTo) { rooms[roomfrom].itemLinks[item]=0;rooms[roomfrom].itemLinkText[item]="";}
  else {rooms[roomfrom].itemLinks[item]=roomTo;
     rooms[roomfrom].itemLinkText[item]= itemNames[item]+" gets you to "+rooms[roomfrom].itemLinks[item];
  }
  
  
}