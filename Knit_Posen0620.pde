int mapSizeX=400;
int mapSizeY=550;

PrintWriter output;
//0:not done,1:Done
int initialFlag=0;
int setNumFlag=0;

int lineNum=10;
int lineLength=300;
int lineStroke=8;
int startX=120;
int startY=150;
int distance=13;
int knitSize=12;
int reduceLen=knitSize/2;

//lineData:0=R,1=G,2=B,3=Length
int [][] lineData = new int [lineNum][4];
//linePosition:0=lineX,1=lineY,2=firstKnitFlag
int [][] linePosition= new int [lineNum][3];
//knitPoint:0=R,1=G,2=B,3=pointX,4=pointY
int [][] knitPoint=new int [1000][5];
//knitRecorder:0=CoreSort,1=RollerSort
int [][] knitRecorder= new int [1000][2];
//knitPosition:0=knitPointStartX,1=knitPointStartY,2=counter
int [][] knitPosition= new int [lineNum-1][3];

int numButtomSize=30;
int numButtomX=180;
int numButtomY=105;
int numButtomYshift=50;
int numButtomTextX=numButtomX+numButtomSize/2;
int numButtomTextY=numButtomY+numButtomSize/2;

int colorCardSize=100;
int colorCardX=260;
int colorCardY=startX;
int colorBoxSize=60;
int colorBoxX=265;
int colorBoxY=300;
int colorStackX=30;
int colorStackY=160;

int colorStackR;
int colorStackG;
int colorStackB;
int textOpeningX=100;
int textOpeningY=15;
int textStepX=50;
int textStepY=120;

int systemBoxSizeX=350;
int systemBoxSizeY=60;
int systemBoxX=25;
int systemBoxY=25;
int textSystemX=systemBoxX+10;
int textSystemY=systemBoxY+systemBoxSizeY/2;

int buttomXSize=80;
int buttomYSize=30;
int buttomX=260; //Set all the buttomX
int buttomY=200;
int buttomYshift=40;
int buttomTextX=buttomX+buttomXSize/2;
int buttomTextY=buttomY+buttomYSize/2;

int autoButtomX=20;
int autoButtomY=220;
int autoButtomYshift=40;
int autoButtomTextX=autoButtomX+buttomXSize/2;
int autoButtomTextY=autoButtomY+buttomYSize/2;

int Core, Roller, Chosen;
int knitReady, knitStart, canKnit, stepCounter, stepTag, autoStep;

//SystemText Flag
int reuse, neighbor, autoError, outputError, outputCorrect, lengthError, firstError, undoCorrect;
int coreFlag, colorFlag, lineFlag;
int c, r, i, j, k;

int skewStep, VStep, VLeftFlag;

void setup() {
  size(mapSizeX, mapSizeY);
}

void draw() {
  background(255, 255, 230);
  if (initialFlag==0) {
    numButtom();
    initialAll();
  } else {
    otherButtoms();
    if (knitReady==0) {
      colorCard(); //HEAVY COST
      chooseColor();
      colorStack();
    } else {
      textStep(Core, Roller);
      autoButtoms();
    }
  }
  textSystem();
  chooseLine();
  update();
}

void initialAll() {
  //knitStart=0;
  knitReady=0;
  //autoStep=stepTag=0;
  colorStackR=colorStackG=colorStackB=255;
  Core=Roller=Chosen=-1;
  canKnit=coreFlag=1;
  if (setNumFlag==1) {
    lineData=new int [lineNum][4];
    linePosition=new int [lineNum][3];
    knitPosition= new int [lineNum-1][3];

    j=0;
    k=distance/2;
    for (i=0; i<lineNum; i++) {
      //InitialPosition
      linePosition[i][0]=startX+j;
      linePosition[i][1]=startY;

      //Initial Line Color
      lineData[i][0]=110;
      lineData[i][1]=123;
      lineData[i][2]=139;
      //Initial Line Length
      lineData[i][3]=lineLength;

      if (i<(lineNum-1)) {
        knitPosition[i][0]=startX+k;
        knitPosition[i][1]=startY;
        knitPosition[i][2]=0;
      }
      j+=distance;
      k+=distance;
    }
    //Initial end
    initialFlag=1;
  }
}

void numButtom() {
  j=0;
  for (i=4; i<=10; i++) {
    strokeWeight(1);
    fill(139, 105, 105);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(i, numButtomTextX, numButtomTextY+j);

    stroke(255, 165, 0);
    fill(205, 133, 63, 50);
    rect(numButtomX, numButtomY+j, numButtomSize, numButtomSize);
    j+=numButtomYshift;
  }
}

void colorCard() {
  for ( i = 0; i <= colorCardSize; i += 1) {
    for (j = 0; j <= colorCardSize; j += 1) {
      noStroke();
      fill(i*225/colorCardSize, j*225/colorCardSize, 100); 
      ellipse(i+colorCardX, j+colorCardY, 1, 1);
    }
  }
}

void checknumButtom() {
  if (mouseX>numButtomX&&mouseX<(numButtomX+numButtomSize)) {
    j=0;
    for (i=4; i<=10; i++) {
      if (mouseY>(numButtomY+j)&&mouseY<(numButtomY+numButtomSize+j)) {
        lineNum=i; 
        setNumFlag=1;
        break;
      }
      j+=numButtomYshift;
    }
  }
}

void textSystem() {
  strokeWeight(3);
  stroke(204, 102, 0);
  fill(205, 133, 63, 50);
  rect(systemBoxX, systemBoxY, systemBoxSizeX, systemBoxSizeY);

  strokeWeight(1);
  fill(139, 105, 105);
  textAlign(LEFT, CENTER);
  textSize(16);
  if (setNumFlag==0) {
    text("How many Lines you need?", textSystemX, textSystemY);
  } //else if (initialFlag==1&&knitReady==0) {
  else {//if (setNumFlag==1)
    if (knitReady==0) {
      if (initialFlag==1) {
        text("Choose any Line:"+(Chosen+1)+" , and choose the Color.", textSystemX, textSystemY);
      }
    } else {//if (knitReady==1) 
      if (neighbor==1)text("Please choose the adjacent Line!", textSystemX, textSystemY);
      else if (undoCorrect==1)text("Undo sucess!", textSystemX, textSystemY);
      else if (reuse==1)text("Please choose the different Line!", textSystemX, textSystemY);
      else if (firstError==1)text("Please try to Knitting first! ", textSystemX, textSystemY);
      else if (lengthError==1)text("Oh oh~ Line is not long enough!", textSystemX, textSystemY);
      else if (outputCorrect==1)text("Output Success! ", textSystemX, textSystemY);

      else if (coreFlag==0) { 
        text("Core="+(Core+1)+", then choose Roller line!", textSystemX, textSystemY);
      } else {
        text("Please choose Core line.", textSystemX, textSystemY);
      }
    }
  }
}

void textStep(int c, int r) {
  textAlign(CENTER, TOP);
  textSize(20);
  fill(165, 42, 42);
  text("Step:"+(stepCounter), textStepX, textStepY);
  text("Core:" + (c+1), textStepX, textStepY+25);
  text("Roller:" + (r+1), textStepX, textStepY+50);

  if (coreFlag==0) { 
    text("Core:" + (c+1), textStepX, textStepY+25);
  } else {
    text("Roller:" + (r+1), textStepX, textStepY+50);
  }
}

void chooseLine() {

  if (mouseY>startY&&mouseY<(startY+lineLength)) {
    j=0;

    for ( i=0; i<lineNum; i++) {
      if (mouseX>((startX+j)-(distance/2))&&mouseX<((startX+j)+(distance/2))) {
        strokeWeight(lineStroke+3);
        drawLine(lineData[i][0], lineData[i][1], lineData[i][2], lineData[i][3], linePosition[i][0], linePosition[i][1]);
        break;
      }
      j=j+distance;
    }
  }
}

void chooseColor() {
  stroke(0, 0, 0);
  strokeWeight(2);
  fill(0, 0, 0, 0);
  rect(colorBoxX, colorBoxY, colorBoxSize, colorBoxSize);
  if (mouseX>colorCardX&&mouseX<(colorCardX+colorCardSize)) {
    if (mouseY>colorCardY&&mouseY<(colorCardY+colorCardSize)) {
      stroke(255);
      fill((mouseX-colorCardX)*225/colorCardSize, (mouseY-colorCardY)*225/colorCardSize, 100); 
      rect(colorBoxX, colorBoxY, colorBoxSize, colorBoxSize);
    }
  }
}

void checkLine() {
  if (mouseY>startY&&mouseY<(startY+lineLength)) {
    j=0;
    for ( i=0; i<lineNum; i++) {
      if (mouseX>((startX+j)-(distance/2))&&mouseX<((startX+j)+(distance/2))) {
        Chosen=i;

        colorFlag=1;
        break;
      }
      j=j+distance;
    }
  }
} 

void checkColor() {
  if (mouseX>colorCardX&&mouseX<(colorCardX+colorCardSize)) {
    if (mouseY>colorCardY&&mouseY<(colorCardY+colorCardSize)) {
      colorStackR=int((mouseX-colorCardX)*225/colorCardSize);
      colorStackG=int((mouseY-colorCardY)*225/colorCardSize);
      colorStackB=100;
      lineData[Chosen][0]=colorStackR;
      lineData[Chosen][1]=colorStackG;
      lineData[Chosen][2]=colorStackB;
      colorFlag=0;
    }
  } else if (mouseX>colorStackX&&mouseX<(colorStackX+colorBoxSize)) {
    if (mouseY>colorStackY&&mouseY<(colorStackY+colorBoxSize)) {
      lineData[Chosen][0]=colorStackR;
      lineData[Chosen][1]=colorStackG;
      lineData[Chosen][2]=colorStackB;
      colorFlag=0;
    }
  }
}

void colorStack() {
  //textAlign(CENTER, TOP);
  textSize(18);
  fill(139, 105, 105);
  text("Last Color", colorStackX+27, colorStackY-15);

  stroke(0, 0, 0);
  strokeWeight(1);
  fill(colorStackR, colorStackG, colorStackB);
  rect(colorStackX, colorStackY, colorBoxSize, colorBoxSize);
}

void otherButtoms() {//6 Buttoms:
  //okButtom
  if (knitReady==0) {
    strokeWeight(1);
    fill(139, 105, 105);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Start!", buttomTextX, buttomTextY+buttomYshift);

    stroke(255, 165, 0);
    fill(205, 133, 63, 50);
    rect(buttomX, buttomY+buttomYshift, buttomXSize, buttomYSize);
  } 

  //Others
  else {
    strokeWeight(1);
    fill(139, 105, 105);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Undo", buttomTextX, buttomTextY);
    text("ReKnit", buttomTextX, buttomTextY+buttomYshift);
    text("Auto Knit", buttomTextX, buttomTextY+buttomYshift*2);
    text("Output", buttomTextX, buttomTextY+buttomYshift*3);
    text("ReStart", buttomTextX, buttomTextY+buttomYshift*4);

    j=0;
    for (i=0; i<5; i++) {
      stroke(255, 165, 0);
      fill(205, 133, 63, 50);
      rect(buttomX, buttomY+j, buttomXSize, buttomYSize);
      j+=buttomYshift;
    }
  }
}

void autoButtoms() {
  strokeWeight(1);
  fill(139, 105, 105);
  textAlign(CENTER, CENTER);
  textSize(15);
  text("SkewKnit", autoButtomTextX, autoButtomTextY);
  text("VKnit", autoButtomTextX, autoButtomTextY+autoButtomYshift);
  //text("ZigzagKnit", autoButtomTextX, autoButtomTextY+autoButtomYshift*2);
  j=0;
  for (i=0; i<2; i++) {
    stroke(255, 165, 0);
    fill(205, 133, 63, 50);
    rect(autoButtomX, autoButtomY+j, buttomXSize, buttomYSize);
    j+=autoButtomYshift;
  }
}

void checkOkButtom() {
  if (mouseX>buttomX&&mouseX<(buttomX+buttomXSize)) {
    if (mouseY>buttomY+buttomYshift&&mouseY<(buttomY+buttomYshift+buttomYSize)) {
      knitReady=1;
    }
  }
}

void checkOtherButtom() {
  if (mouseX>buttomX&&mouseX<(buttomX+buttomXSize)) {
    j=0;
    for (i=1; i<=5; i++) {
      if (mouseY>(buttomY+j)&&mouseY<(buttomY+buttomYSize+j)) break;
      j+=buttomYshift;
    }
    // undoButtom
    if (i==1) {
      if (stepCounter>0) {
        undo();
        undoCorrect=1;
      } else firstError=1;
    }
    //reKnit
    else if (i==2) {
      if (stepCounter>0) {
        reKnit();
      } else firstError=1;
    }
    //autoButtom
    else if (i==3) {
      if (canKnit==1) {
        if (stepCounter>0) {
          stepTag=stepCounter;
          autoKnit();
        } else firstError=1;
      } else lengthError=1;
    }
    //outputButtom
    else if (i==4) {
      if (stepCounter>0) {
        outputResult();
      } else firstError=1;
    }
    // reStartButtom
    else if (i==5) {
      reStart();
    }
  }
}

void checkAutoButtom() {
  if (mouseX>autoButtomX&&mouseX<(autoButtomX+buttomXSize)) {
    j=0;
    for (i=1; i<=3; i++) {
      if (mouseY>(autoButtomY+j)&&mouseY<(autoButtomY+buttomYSize+j)) break;
      j+=autoButtomYshift;
    }
    if (canKnit==1) {
      // undoButtom
      if (i==1) {
        skewStep=0;
        SkewKnit();
      }
      // reButtom
      else if (i==2) {
        VLeftFlag=1;
        VKnit();
      }
      /*else if (i==3) {
       ZigzagFlag=0;
       ZigzagKnit();
       }*/
    } else lengthError=1;
  }
}

void checkCoreAndRoller() {   
  if (mouseY>startY&&mouseY<(startY+lineLength)) {
    j=0;
    for ( i=0; i<lineNum; i++) {
      if (mouseX>((startX+j)-(distance/2))&&mouseX<((startX+j)+(distance/2))) {
        if (coreFlag==1) {
          Core=i;
          coreFlag=0;
          //checkLineMotivation(lineData[Core][0], lineData[Core][1], lineData[Core][2], lineData[Core][3], linePosition[Core][0], linePosition[Core][1]);
          break;
        } else {
          Roller=i;
          coreFlag=1;
          //checkLineMotivation(lineData[Roller][0], lineData[Roller][1], lineData[Roller][2], lineData[Roller][3], linePosition[Roller][0], linePosition[Roller][1]);

          if (Core!=Roller) {
            if (abs(Core-Roller)==1&&canKnit==1) {
              Knitting();
            } else neighbor=1;
          } else  reuse=1;
          break;
        }
      }
      textStep(Core, Roller);
      j=j+distance;
    }
  }
}

void mouseClicked() {
  neighbor=undoCorrect=reuse=firstError=lengthError=outputCorrect=0;
  if (initialFlag==0) {
    checknumButtom();
  }
  if (knitReady==0) {
    checkLine();
    if (colorFlag==1) {
      checkColor();
    }
    checkOkButtom();
  } 
  //if(knitReady==1)
  else { 
    checkOtherButtom();
    checkAutoButtom();
    checkCoreAndRoller();
  }
}

void Knitting() {
  //for autoStep
  if (knitStart==1) {
    if (lineData[Core][3]<knitSize||lineData[Roller][3]<knitSize) {
      lengthError=1;
      canKnit=0;
    } else canKnit=1;
  }
  //Check the Core & Roller are enough to Knitting
  if (canKnit==1) {
    //Start to Knitting
    //knitRecorder[][] & knitPoint[][] from 1 to save data
    stepCounter++;
    //knitPosition[k][2]++;
    k=int((Core+Roller)/2);
    knitPosition[k][2]++;
    //Save Core & Roller to knitRecorder[][]
    knitRecorder[stepCounter][0]=Core;
    knitRecorder[stepCounter][1]=Roller;
    //Save R/G/B to knitPoint[][]
    knitPoint[stepCounter][0]=lineData[Roller][0];
    knitPoint[stepCounter][1]=lineData[Roller][1];
    knitPoint[stepCounter][2]=lineData[Roller][2];
    //Save the X poisitions of knit
    knitPoint[stepCounter][3]=knitPosition[k][0];
    if (knitPosition[k][2]==1) {
      j=linePosition[Core][1]>linePosition[Roller][1]? Core:Roller;
      //Set the First knitPositionY
      knitPosition[k][1]=linePosition[j][1];
      linePosition[j][1]+=knitSize/2;
      linePosition[Core][1]=linePosition[j][1];
      linePosition[Roller][1]=linePosition[j][1];
    } else {
      knitPosition[k][1]+=knitSize;
      linePosition[Core][1]=knitPosition[k][1]+knitSize/2;
      linePosition[Roller][1]=knitPosition[k][1]+knitSize/2;
    }
    knitPoint[stepCounter][4]=knitPosition[k][1];
    //REDUCE the Lengths of Core & Roller by reduceLen
    lineData[Core][3]-=reduceLen;
    lineData[Roller][3]-=reduceLen;

    //Swap the positions of Core & Roller
    for (i=0; i<4; i++) {
      int temp;
      temp=lineData[Core][i];
      lineData[Core][i]=lineData[Roller][i];
      lineData[Roller][i]=temp;
    }
    //Knitting End
    knitStart=0;
  }
}

void undo() {
  //c=Core,r=Roller
  c=knitRecorder[stepCounter][0];
  r=knitRecorder[stepCounter][1];
  k=int((c+r)/2);
  //Swap Core,Roller
  for (i=0; i<4; i++) {
    int temp;
    temp=lineData[c][i];
    lineData[c][i]=lineData[r][i];
    lineData[r][i]=temp;
  }
  //ADD the Lengths of Core & Roller by reduceLen
  lineData[c][3]+=reduceLen;
  lineData[r][3]+=reduceLen;
  if (r>c) {
    i=k-1;
    if (i<0) i=0;
    j=k+1;
    if (j>(lineNum-2)) j=lineNum-2;
  } else {
    i=k+1;
    if (i>(lineNum-2)) j=lineNum-2;
    j=k-1;
    if (j<0) j=0;
  }
  if (knitPosition[k][2]>1) {
    knitPosition[k][1]-=knitSize;
    linePosition[c][1]=knitPosition[i][1]+knitSize/2;
    linePosition[r][1]=knitPosition[j][1]+knitSize/2;
  } else {
    if (c==0||c==lineNum-1) linePosition[c][1]=startY;
    else if (knitPosition[i][2]==0)linePosition[c][1]=startY;

    if (r==0||r==lineNum-1) linePosition[r][1]=startY;
    else if (knitPosition[j][2]==0)linePosition[r][1]=startY;
  }
  knitPosition[k][2]--;
  //Reduce steps
  stepCounter--;
}

void drawLine(int r, int g, int b, int l, int x, int y) {
  noStroke();
  stroke(r, g, b);
  line(x, y, x, y+l);
}

void drawKnitPoint(int r, int g, int b, int x, int y) {
  noStroke();
  fill(r, g, b);
  ellipse(x, y, knitSize, knitSize);
}

void update() {
  for (i=0; i<lineNum; i++) {
    strokeWeight(lineStroke);
    drawLine(lineData[i][0], lineData[i][1], lineData[i][2], lineData[i][3], linePosition[i][0], linePosition[i][1]);
  }
  for (i=1; i<=stepCounter; i++) {
    drawKnitPoint(knitPoint[i][0], knitPoint[i][1], knitPoint[i][2], knitPoint[i][3], knitPoint[i][4]);
  }
}

void outputResult() {
  output = createWriter("knitRecorder.txt");
  for (i=1; i<=stepCounter; i++) {
    output.println("Step "+ i + ":  Core: "+ knitRecorder[i][0] + ", Roller: "+knitRecorder[i][1]);
  }
  output.close();
  outputCorrect=1;
}

void autoKnit() {
  autoStep=i=0;
  while (autoStep!=stepTag) {
    i++;
    autoStep++;
    Core= knitRecorder[autoStep][0];
    Roller= knitRecorder[autoStep][1];    
    knitStart=1;
    Knitting();
    //autoStep=autoStep % stepTag;
    //if (autoStep==0) autoStep=stepTag;
  }
}

void reKnit() {
  stepCounter=0;
  canKnit=1;
  for (i=0; i<lineNum; i++) {
    //InitialPosition
    linePosition[i][1]=startY;
    //Initial Line Length
    lineData[i][3]=lineLength;
    if (i<(lineNum-1)) {
      knitPosition[i][1]=startY;
      knitPosition[i][2]=0;
    }
  }
}

void reStart() {
  lineNum=0;
  stepCounter=0;
  initialFlag=0;
  setNumFlag=0;
}

void SkewKnit() {
  while (skewStep!=lineNum) {
    Core= skewStep;
    Roller= skewStep+1;    
    knitStart=1;
    Knitting();
    skewStep++;
    if ( skewStep==(lineNum-1)) {
      //skewStep=0;
      skewStep=lineNum;
    }
  }
}

void VKnit() {
  while (VLeftFlag!=2) {
    j=lineNum/2-1;
    if (VLeftFlag==1) {
      VStep++;
      Core= VStep;
      Roller= VStep-1;
      if (VStep==j) {
        VStep=lineNum-1;
        VLeftFlag=0;
      }
    } else {
      VStep--;
      Core= VStep;
      Roller= VStep+1;
      if (VStep==j) {
        VStep=0;
        VLeftFlag=2;
        //VLeftFlag=0;
      }
    }
    knitStart=1;
    Knitting();
  }
}
/*int ZigzagFlag=0;
 int ZigzagStep;
 void ZigzagKnit() { 
 if (canKnit==1) {
 while (ZigzagFlag!=2) {
 if (ZigzagFlag==0) {
 i=0;
 ZigzagStep=lineNum-1;
 for (j=i; j<lineNum; j++) {
 i++;
 Core=ZigzagStep;
 Roller=ZigzagStep-1;
 knitStart=1;
 Knitting();
 ZigzagStep--;
 }
 i++;
 }
 }
 }
 }
 */
/*void checkLineMotivation(int r, int g, int b, int l, int x, int y) {
 int CorR=1;
 for (i=0; i<5; i++) {
 strokeWeight(lineStroke+i);
 drawLine(lineData[CorR][0], lineData[CorR][1], lineData[CorR][2], lineData[CorR][3], linePosition[CorR][0], linePosition[CorR][1]);
 }
 }*/
