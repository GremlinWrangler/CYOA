/*
  int xOffset;
  int yOffset;
  int Xpos;
  int Ypos;
  int indexnumber;
  String Title;
  String Description;
  boolean [] roomLinks = new boolean[RoomCount];
  String  [] roomLinkText = new String[RoomCount];
  int [] itemLinks = new int [itemCount];
  String  [] itemLinkText = new String[itemCount];
  float x, y;
  int unit;
  int xDirection = 1;
  int yDirection = 1;
  float speed; 
*/
 import processing.pdf.*; 
 PGraphicsPDF pdf;
void createPDF()
 
{
  int lineCounter =20;
  int lineheight =10;
  int maskeWidth = 20;
  int gridSize =14;
  
  PGraphics pdf = createGraphics(570,840, PDF, "output.pdf") ;
  pdf.beginDraw();
  pdf.background(255);
  for (int counter=1;counter<RoomCount;counter++){
    boolean roomContainsAnItem=false;
    if (rooms[counter].isActiveRoom==true){
      pdf.fill(0);
      //pdf.rect(1,1,515,780);
      stroke(0);
      pdf.text("Room Number "+counter,20,lineCounter*lineheight);
      pdf.text(rooms[counter].Title,100,lineCounter*lineheight);
      lineCounter=lineCounter+2;
      pdf.text(rooms[counter].Description,20,lineCounter*lineheight,500,300);
      int descriptionLength = rooms[counter].Description.length()/65;//Guess at number of of lines used for description based on font size and kerning  
      lineCounter=10+descriptionLength;
      for (int intcounter=0; intcounter<RoomCount;intcounter++){
        if (rooms[counter].roomLinks[intcounter]==true){
            pdf.text(rooms[counter].roomLinkText [intcounter],10,lineCounter*lineheight);
            lineCounter++;
       }
      }
     for (int itemCounter=0;itemCounter<itemCount;itemCounter++)
      {
        if  (itemStartingLocations[itemCounter]==counter){
          roomContainsAnItem=true;  
          pdf.text(itemNames[itemCounter]+" is here",10,lineCounter*lineheight);
          lineCounter++;
        }    
      }
      lineCounter++;
      /*
      for (int itemCounter=0;itemCounter<itemCount;itemCounter++){ //manual insert of room link directions, for when you are not use the decoder grids
        if (rooms[counter].itemLinks[itemCounter]>0){
          // pdf.text("if you have"+itemNames[itemCounter]+"you can"+rooms[counter].itemLinkText[itemCounter]+" to "+rooms[counter].itemLinks[itemCounter],10,lineCounter*lineheight); 
           pdf.text(rooms[counter].itemLinkText[itemCounter],10,lineCounter*lineheight);
           lineCounter++; 
        }
      } */
     int itemIndex =0;
     int lineNumber =0;
     int columnNumber =0;
     int xOffset=60;
     int yoffset=20+lineCounter*lineheight;
     int maskArrayLength = itemMaskLengths.length;
     int [] itemCharacterCountArray = new int [itemCount];  
     pdf.fill(255);
     pdf.stroke(0);
     pdf.rect(xOffset,yoffset,gridSize*21,gridSize*20);
    if (roomContainsAnItem==false){
      for (int outerLoop=0;outerLoop<10;outerLoop++)
        {  
          for (int innerLoop=0;innerLoop<maskArrayLength;innerLoop++)
          {
            int newBlockWidth=itemMaskLengths[innerLoop];            
            pdf.fill(0);
            for (int blockIndex=0;blockIndex<newBlockWidth;blockIndex++) {
                char currentChar = returnRandomLetter();                
                if (rooms[counter].itemLinkText[itemIndex].length()>itemCharacterCountArray[itemIndex]){
                    currentChar = rooms[counter].itemLinkText[itemIndex].charAt(itemCharacterCountArray[itemIndex]);
                   }                
                pdf.text(currentChar,xOffset+(columnNumber+blockIndex)*gridSize+4,yoffset+lineNumber*gridSize+gridSize*4/5);
                itemCharacterCountArray[itemIndex]++;
              }              
              columnNumber=columnNumber+newBlockWidth;
              if (columnNumber>maskeWidth) {//handles roll overs
                columnNumber=0;
                lineNumber++;
             }
          itemIndex++;
          if (itemIndex>=itemNames.length) itemIndex=0;
        }
      }
    }
    ((PGraphicsPDF) pdf).nextPage();
   }   
  }
    //do item grids
    
    for (int itemCounter=0;itemCounter<itemCount;itemCounter++){
        pdf.fill(255);
        pdf.stroke(0);
        pdf.rect(58,20-12,gridSize*21+4,gridSize*22+6);
        pdf.fill(0);
       pdf.text(itemNames[itemCounter]+" found in room "+itemStartingLocations[itemCounter]+" the "+rooms[itemStartingLocations[itemCounter]].Title,60,20);
          int itemIndex =0;
          int lineNumber =0;
          int columnNumber =0;
          int xOffset=60;
          int yoffset=20+20;
          int maskArrayLength = itemMaskLengths.length;
          int [] itemCharacterCountArray = new int [itemCount];
           pdf.fill(128);
          pdf.rect(xOffset,yoffset,gridSize*21,gridSize*20);
          pdf.fill(255);
          for (int outerLoop=0;outerLoop<10;outerLoop++)
            {  
              for (int innerLoop=0;innerLoop<maskArrayLength;innerLoop++)
                {
                  int newBlockWidth=itemMaskLengths[innerLoop];         
                  fill(128);
                  if (itemCounter==itemIndex) pdf.rect( xOffset+columnNumber*gridSize,yoffset+lineNumber*gridSize,newBlockWidth*gridSize,gridSize);     
                  columnNumber=columnNumber+newBlockWidth;
                  if (columnNumber>maskeWidth) {
                    columnNumber=0;
                    lineNumber++;
                  }
               itemIndex++;
          if (itemIndex>=itemNames.length) itemIndex=0;
          }
        }
       ((PGraphicsPDF) pdf).nextPage();
    }    
  
  pdf.dispose();
  pdf.endDraw();
  //pdf.nextPage();
  print("pdf.complete");
}



PrintWriter output;
void writeDataOut(){
  
 output = createWriter(fileNameToUse);
 for (int counter=0; counter<RoomCount;counter++){
   if (rooms[counter].isActiveRoom==true){
   output.println("#"+rooms[counter].indexnumber);
   output.println("Title="+rooms[counter].Title);
   output.println("Description="+rooms[counter].Description);
   output.println(";end Description");
   output.println("colour="+rooms[counter].colour+"; xPos="+rooms[counter].Xpos+"; yPos="+rooms[counter].Ypos+";");
   for (int intcounter=0; intcounter<RoomCount;intcounter++){
       if (rooms[counter].roomLinks[intcounter]==true){
            output.println("link="+intcounter+"; text="+rooms[counter].roomLinkText [intcounter]+";");
       }
     }
     for (int intcounter=0; intcounter<itemCount;intcounter++){
       if (rooms[counter].itemLinks[intcounter]>0){
           output.println("item="+intcounter+"; links to="+rooms[counter].itemLinks[intcounter]+"; text="+ rooms[counter].itemLinkText[intcounter]+";");
       }
     }
   }
 }
    output.flush(); // Write the remaining data
  output.close(); // Finish the file
 }

void readDataIn(){
  int currentRoomNumber=0;
  String[] lines;
  lines = loadStrings(fileNameToUse);
  for (int counter=0; counter<RoomCount;counter++){
    rooms[counter].isActiveRoom=false; // zeroise all rooms
    rooms[counter].Title="";
    rooms[counter].Description="";
    rooms[counter].colour=0;
    rooms[counter].Xpos=0;
    rooms[counter].Ypos=0;
    for (int intcounter=0; intcounter<RoomCount;intcounter++){
         rooms[counter].roomLinks[intcounter]=false;
         rooms[counter].roomLinkText[intcounter]="";
      }
      for (int intcounter=0; intcounter<itemCount;intcounter++){
        rooms[counter].itemLinks[intcounter]=0;
        rooms[counter].itemLinkText[intcounter]="";
      }
   boolean foundBlock = false;
   
   String roomIndexStringToMatch = "#"+counter;
   for (int i = 0; i < lines.length; i++) {     
     if (lines[i].indexOf("#")>-1){//we have a room number
           //if (counter==1&&i<20) println(lines[i]+"|"+roomIndexStringToMatch);
           
           int currentLineNumber=extractTaggedIntFromString("#",lines[i]);
           //println("currentline"+currentLineNumber);
           if(currentLineNumber==counter) {foundBlock=true; rooms[counter].isActiveRoom=true; } else foundBlock=false;
       }
     if (foundBlock==true){
              
               String tempLine = lines[i];  
               if (tempLine.indexOf("Title=")>-1) rooms[counter].Title=extractStringFromTaggedString("Title=",tempLine);
               if (tempLine.indexOf("Description=")>-1) rooms[counter].Description=extractStringFromTaggedString("Description=",tempLine);
               if (tempLine.indexOf("colour=")>-1) rooms[counter].colour=extractTaggedIntFromString("colour=",tempLine);
               if (tempLine.indexOf("xPos=")>-1) rooms[counter].Xpos=extractTaggedIntFromString("xPos=",tempLine);
               if (tempLine.indexOf("yPos=")>-1) rooms[counter].Ypos=extractTaggedIntFromString("yPos=",tempLine);
             
               if (tempLine.indexOf("link=")>-1) { int linkedRoomIndexNumber = extractTaggedIntFromString("link=",tempLine);
                                                   rooms[counter].roomLinks[linkedRoomIndexNumber]=true;
                                                  rooms[counter].roomLinkText[linkedRoomIndexNumber]=extractStringFromTaggedString("text=",tempLine);}
               if (tempLine.indexOf("item=")>-1) { int linkeditemIndexNumber = extractTaggedIntFromString("item=",tempLine);
                                                   rooms[counter].itemLinks[linkeditemIndexNumber]=extractTaggedIntFromString("links to=",tempLine);
                                                  rooms[counter].itemLinkText[linkeditemIndexNumber]=extractStringFromTaggedString("text=",tempLine);}                                    
              // if (counter==1) {println("ding"+tempLine); if (tempLine.indexOf("colour=")>-1) println("colourline"+rooms[counter].Xpos);}
               
            }
       }

   }
   }

String extractStringFromTaggedString(String stringToLocate,String stringToSearch){
  String returnString = "";
 int lengthofTag = stringToLocate.length(); 
 int startOfTag = stringToSearch.indexOf(stringToLocate);
 stringToSearch=stringToSearch.substring( startOfTag+lengthofTag);
  int endOfTag = stringToSearch.indexOf(";");
  if (endOfTag>-1) stringToSearch=stringToSearch.substring(0,endOfTag );//trim off any extra values in line
  returnString=stringToSearch;
 return returnString ;
}
      
int extractTaggedIntFromString(String stringToLocate,String stringToSearch){
     int lengthofTag = stringToLocate.length();
     int startOfTag = stringToSearch.indexOf(stringToLocate);
     int tempInt=0;
     stringToSearch=stringToSearch.substring( startOfTag+lengthofTag);
      int endOfTag = stringToSearch.indexOf(";");
     if (endOfTag>-1) stringToSearch=stringToSearch.substring(0,endOfTag );//trim off any extra values in line
     tempInt=int(stringToSearch);
     return tempInt;
}