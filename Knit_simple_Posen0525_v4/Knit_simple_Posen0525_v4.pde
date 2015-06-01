int mapSizeX=400;
int mapSizeY=650;

int initialFlag=1;

int lineNum=6;
int lineLength=300;
int lineStroke=8;
int startX=110;
int startY=90;
int distance=15;
int knitSize=12;
int reduceLen=knitSize/2;

//lineData:0=R,1=G,2=B,3=Length,4=coreCounter
int [][] lineData = new int [lineNum][5];
//linePosition:0=lineX,1=lineY,2=firstKnitFlag
int [][] linePosition= new int [lineNum][3];
//knitPoint:0=R,1=G,2=B,3=pointX,4=pointY
int [][] knitPoint=new int [1000][5];
//knitRecorder:0=CoreSort,1=RollerSort
int [][] knitRecorder= new int [1000][2];

int colorCardX=260;
int colorCardY=30;

int textOpeningX=100;
int textOpeningY=15;
int textStepX=50;
int textStepY=120;

int systemBoxSizeX=350;
int systemBoxSizeY=50;
int systemBoxX=25;
int systemBoxY=550;
int textSystemX=systemBoxX+10;
int textSystemY=systemBoxY+systemBoxSizeY/2;

void textSystem() {
  strokeWeight(3);
  stroke(204, 102, 0);
  fill(205, 133, 63, 50);
  rect(systemBoxX, systemBoxY, systemBoxSizeX, systemBoxSizeY);

  strokeWeight(1);
  fill(139, 105, 105);
  textAlign(LEFT, CENTER);
  textSize(20);
  if (reuse==1)text("Please choose the different line!", textSystemX, textSystemY);
  if (neighbor==1)text("Please choose the adjacent line!", textSystemX, textSystemY);
  if (canKnit==0)text("Oh oh~ line is not long enough!", textSystemX, textSystemY);
  
}

int colorBoxX=265;
int colorBoxY=210;
int colorBoxSize=60;

int buttomXSize=80;
int buttomYSize=30;

int buttomX=260; //Set all the buttomX
int okButtomY=150;
int undoButtomY=190;
int reButtomY=230;
int autoButtomY=270;
int doneButtomY=310;

int buttomTextX=buttomX+buttomXSize/2;

int Core, Roller, Chosen, ReKnit;
int knitReady, knitStart, stepCounter, canKnit;

int coreFlag, colorFlag;

int stepTag, autoStep, autoStart;
int skewEnd, skewStep;
int c, r, i, j, k;
int reuse, neighbor;

PrintWriter output;

void setup() {
  size(mapSizeX, mapSizeY);
}

void draw() {
  background(255, 255, 209);

  if (initialFlag==1) {
    initialAll();
  } else {

    if (knitReady==0) {
      textOpening();
      colorCard();
      chooseColor();
      okButtom();
    } else {

      otherButtoms();

      //mouseClicked();
      textStep(Core, Roller);
      Knitting();
      autoKnit();
      //SkewKnit();
    }
  }
  update();
  textSystem();
  chooseLine();
}

void initialAll() {
  j=0;
  for (i=0; i<lineNum; i++) {
    //InitialPosition
    linePosition[i][0]=startX+j;
    linePosition[i][1]=startY;
    linePosition[i][2]=0;

    j=j+distance;

    //InitialLine
    lineData[i][0]=110;
    lineData[i][1]=123;
    lineData[i][2]=139;
    lineData[i][3]=lineLength;
    lineData[i][4]=0;
  }
  //InitialData
  knitPoint=new int [1000][5];
  knitRecorder=new int [1000][2];
  stepCounter=knitStart=knitReady=0;
  Core=Roller=colorFlag=ReKnit=autoStart=0;
  coreFlag=1;
  canKnit=autoStep=1;
  stepTag=0;
  skewEnd=0;
  reuse=neighbor=0;

  //Initial end
  initialFlag=0;
}


void colorCard() {
  for ( i = 0; i <= 100; i += 1) {
    for (j = 0; j <= 100; j += 1) {
      noStroke();
      fill(i*2.25, j*2.25, 100); 
      ellipse(i+colorCardX, j+colorCardY, 1, 1);
    }
  }
}

void textOpening() {
  textAlign(CENTER, TOP);
  textSize(15);
  fill(205, 92, 92);
  text("Step1:Choose the Line."+(Chosen+1), textOpeningX, textOpeningY);
  text("Step2:Choose the Color.", textOpeningX, textOpeningY+20);
  text("Step3:Check the Buttom!", textOpeningX, textOpeningY+40);
}
void textStep(int c, int r) {
  textAlign(CENTER, TOP);
  textSize(20);
  fill(165, 42, 42);
  text("Step:"+(stepCounter), textStepX, textStepY);

  if (coreFlag==0) { 
    fill(139, 212, 115);
    text("Core:" + (c+1), textStepX, textStepY+25);
  } else {
    fill(139, 212, 115);
    text("Roller:" + (r+1), textStepX, textStepY+50);
  }
}

void chooseColor() {
  stroke(0, 0, 0);
  strokeWeight(2);
  fill(0, 0, 0, 0);
  rect(colorBoxX, colorBoxY, colorBoxSize, colorBoxSize);
  if (mouseX>colorCardX&&mouseX<(colorCardX+100)) {
    if (mouseY>colorCardY&&mouseY<(colorCardY+100)) {
      stroke(255);
      fill((mouseX-colorCardX)*2.25, (mouseY-colorCardY)*2.25, 100); 
      rect(colorBoxX, colorBoxY, colorBoxSize, colorBoxSize);
    }
  }
}

void chooseLine() {
  if (mouseY>startY&&mouseY<(startY+lineLength)) {
    j=0;
    for ( i=0; i<lineNum; i++) {
      if (mouseX>((startX+j)-(distance/2))&&mouseX<((startX+j)+(distance/2))) {
        strokeWeight(5);
        drawBigLine(lineData[i][0], lineData[i][1], lineData[i][2], lineData[i][3], linePosition[i][0], linePosition[i][1]);
      }
      j=j+distance;
    }
  }
}

void mouseClicked() {
  if (knitReady==0) {
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
      
    if (colorFlag==1) {
      if (mouseX>colorCardX&&mouseX<(colorCardX+100)) {
        if (mouseY>colorCardY&&mouseY<(colorCardY+100)) {
          lineData[Chosen][0]=(int((mouseX-colorCardX)*2.25));
          lineData[Chosen][1]=(int((mouseY-colorCardY)*2.25));
          lineData[Chosen][2]=100;

          colorFlag=0;
        }
      }
    }

    if (knitReady==0) 
      // okButtom
      if (mouseX>buttomX&&mouseX<(buttomX+buttomXSize)) {
        if (mouseY>okButtomY&&mouseY<(okButtomY+buttomYSize)) {
          //initialFlag=2;
          knitReady=1;
        }
      }
  }


  if (knitReady==1) {
    // undoButtom
    if (mouseX>buttomX&&mouseX<(buttomX+buttomXSize)) {
      if (mouseY>undoButtomY&&mouseY<(undoButtomY+buttomYSize)) {
        if (stepCounter>0) undo();
      }
      // reButtom
      if (mouseY>reButtomY&&mouseY<(reButtomY+buttomYSize)) 
        initialFlag=1;
      //autoButtomY
      if (mouseY>autoButtomY&&mouseY<(autoButtomY+buttomYSize)) {
        if (stepCounter>0) {
          stepTag=stepCounter;
          autoStart=1;
        }
      }

      if (mouseY>doneButtomY&&mouseY<(doneButtomY+buttomYSize))
        outputResult();
    }

    if (mouseY>startY&&mouseY<(startY+lineLength)) {
      reuse=0;
      neighbor=0;
      j=0;
      for ( i=0; i<lineNum; i++) {
        if (mouseX>((startX+j)-(distance/2))&&mouseX<((startX+j)+(distance/2))) {
          if (coreFlag==1) {
            Core=i;
            coreFlag=0;
            break;
          } else {
            Roller=i;
            coreFlag=1;

            if (Core!=Roller) {
              if (abs(Core-Roller)>1) neighbor=1;
              else knitStart=1;
            } else  reuse=1;

            break;
          }
        }
        textStep(Core, Roller);
        j=j+distance;
      }
    }
  }
}


void undo() {
  //c=Core,r=Roller
  c=knitRecorder[stepCounter][0];
  r=knitRecorder[stepCounter][1];

  //Swap Core,Roller
  for (i=0; i<5; i++) {
    int temp;
    temp=lineData[c][i];
    lineData[c][i]=lineData[r][i];
    lineData[r][i]=temp;
  }

  // The Lengths of Core & Roller - reduceLen
  lineData[c][3]=lineData[c][3]+reduceLen;
  lineData[r][3]=lineData[r][3]+reduceLen;

  //k=Line's coreCounter
  k=lineData[c][4];

  linePosition[c][1]=linePosition[c][1]-knitSize;

  if (linePosition[c][2]==1) {
    //CorePositionY-(knitsize*k/2)
    linePosition[r][1]=linePosition[r][1]-(knitSize*k/2);
  } 
  linePosition[c][2]--;//Reduce position's knitCounter
  lineData[c][4]--; //Reduce Line's coreCounter
  stepCounter--;
}

void Knitting() {
  if (knitStart==1) { 
    //Start to Knitting
    //Check the Core & Roller are enough to Knitting
    if (lineData[Core][3]>knitSize&&lineData[Roller][3]>knitSize) {
      canKnit=1;

      stepCounter++; //knitRecorder[][] & knitPoint[][] from 1 to save data 
      lineData[Core][4]++; //Line's coreCounter from 1 to add
      linePosition[Core][2]++;//Position's knitCounter ++

        knitRecorder[stepCounter][0]=Core;
      knitRecorder[stepCounter][1]=Roller;

      //Save R/G/B to knitPoint[][]
      knitPoint[stepCounter][0]=lineData[Roller][0];
      knitPoint[stepCounter][1]=lineData[Roller][1];
      knitPoint[stepCounter][2]=lineData[Roller][2];

      //Save the poisitions of knit(CoreX,CoreY)
      knitPoint[stepCounter][3]=linePosition[Core][0];
      knitPoint[stepCounter][4]=linePosition[Core][1];

      linePosition[Core][1]=linePosition[Core][1]+knitSize;
      k=lineData[Core][4]; //k=coreCounter
      if (linePosition[Core][2]==1) {
        //CorePositionY-(knitsize*k/2)
        linePosition[Roller][1]=linePosition[Roller][1]+(knitSize*k/2);
      } 

      // The Lengths of Core & Roller - reduceLen
      lineData[Core][3]=lineData[Core][3]-reduceLen;
      lineData[Roller][3]=lineData[Roller][3]-reduceLen;

      //Swap the positions of Core & Roller
      for (i=0; i<5; i++) {
        int temp;
        temp=lineData[Core][i];
        lineData[Core][i]=lineData[Roller][i];
        lineData[Roller][i]=temp;
      }

      //Knitting End
      knitStart=0;
    } else {
      canKnit=0;
    }
  }
}

void update() {
  for (i=0; i<lineNum; i++) {
    drawLine(lineData[i][0], lineData[i][1], lineData[i][2], lineData[i][3], linePosition[i][0], linePosition[i][1]);
  }
  for (i=1; i<=stepCounter; i++) {
    drawKnitPoint(knitPoint[i][0], knitPoint[i][1], knitPoint[i][2], knitPoint[i][3], knitPoint[i][4]);
  }
}

void drawLine(int r, int g, int b, int l, int x, int y) {
  noStroke();
  strokeWeight(lineStroke);
  stroke(r, g, b);
  line(x, y, x, y+l);
}

void drawBigLine(int r, int g, int b, int l, int x, int y) {
  noStroke();
  strokeWeight(lineStroke+5);
  stroke(r, g, b);
  line(x, y, x, y+l+4);
}

void drawKnitPoint(int r, int g, int b, int x, int y) {
  noStroke();
  fill(r, g, b);
  ellipse(x, y, knitSize, knitSize);
}

//5 Buttoms:

void okButtom() {
  strokeWeight(1);
  fill(139, 105, 105);
  textAlign(CENTER, CENTER);
  textSize(15);
  text("Start!", buttomTextX, (okButtomY+buttomYSize/2));
  stroke(255, 165, 0);
  fill(205, 133, 63, 50);
  rect(buttomX, okButtomY, buttomXSize, buttomYSize);
}

void otherButtoms() {
  strokeWeight(1);
  fill(139, 105, 105);
  textAlign(CENTER, CENTER);
  textSize(15);
  text("Undo", buttomTextX, (undoButtomY+buttomYSize/2));
  text("Restart", buttomTextX, (reButtomY+buttomYSize/2));
  text("Auto Knit", buttomTextX, (autoButtomY+buttomYSize/2));
  text("Output", buttomTextX, (doneButtomY+buttomYSize/2));

  stroke(255, 165, 0);
  fill(205, 133, 63, 50);
  rect(buttomX, undoButtomY, buttomXSize, buttomYSize);
  rect(buttomX, reButtomY, buttomXSize, buttomYSize);
  rect(buttomX, autoButtomY, buttomXSize, buttomYSize);
  rect(buttomX, doneButtomY, buttomXSize, buttomYSize);
}

void outputResult() {
  output = createWriter("knitRecorder.txt");
  if (stepCounter==0) output.println("Nothing~ Please enjoy this Knitting APP");
  for (i=1; i<=stepCounter; i++) {
    output.println("Step "+ i + ":  Core: "+ knitRecorder[i][0] + ", Roller: "+knitRecorder[i][1]);
  }
  output.close();
}

void SkewKnit() { 
  skewEnd++;
  if (canKnit==1) {
    Core= skewStep;
    Roller= skewStep+1;    
    knitStart=1;
    Knitting();

    skewStep++;
    if ( skewStep==(lineNum-1)) skewStep=0;
  } else {
    autoStart=0;
  }
}

void autoKnit() {
  if (autoStart==1&&canKnit==1) {
    if (autoStep==stepTag) autoStart=0;
    Core= knitRecorder[autoStep][0];
    Roller= knitRecorder[autoStep][1];    
    knitStart=1;
    Knitting();

    autoStep++;

    autoStep=autoStep % stepTag;
    if (autoStep==0) autoStep=stepTag;
  } else {
    autoStart=0;
  }
}

