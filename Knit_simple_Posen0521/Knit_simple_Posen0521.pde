int mapSizeX=350;
int mapSizeY=500;

int lineNum=6;
int lineLength=300;
int lineStroke=5;
int startX=110;
int startY=100;
int distance=20;

int [][] lineData = new int [lineNum][4];
int [][] linePosition= new int [lineNum][2];
int [][] knitPoint=new int [1000][5];
//int [][] knitStepRecorder= new int [500][4];

int colorCardX=240;
int colorCardY=10;

int textOpeningX=30;
int textOpeningY=30;
int textStepX=10;
int textStepY=120;

int buttomXSize=70;
int buttomYSize=20;
int okButtomX=260;
int okButtomY=150;
int undoButtomX=260;
int undoButtomY=180;
int reButtomX=260;
int reButtomY=210;

int Core, Roller, chosen;

int chooseColor=0;
int knitReady, knitStart, stepCounter;

int coreFlag=1;
int lineFlag=1;
int colorFlag=0;

int knitSize=8;
int i, j, k;

void setup() {
  size(mapSizeX, mapSizeY);
  initialPosition();
  initialLine();
  //undoButtom();
}

void draw() {
  background(255, 255, 209);

  if (chooseColor==0) {
    initialPosition();
    initialLine();
    stepCounter=knitStart=knitReady=0;
    Core=Roller=0;
    knitPoint=new int [1000][5];
    update();
  }
  if (chooseColor==1) {
    textOpening();
    checkbuttom();
    chooseLine();
    colorCard();
    chooseColor();
    update();
  }
  if (knitReady==1) {
    undoButtom();
    reButtom();
    chooseLine();
    //mouseClicked();
    textStep(Core, Roller);
    update();
    Knitting();
  }
}

void initialPosition() {
  j=0;
  for (i=0; i<lineNum; i++) {
    linePosition[i][0]=startX+j;
    linePosition[i][1]=startY;
    j=j+distance;
  }
}

void initialLine() {
  for (i=0; i<lineNum; i++) {
    lineData[i][0]=110;
    lineData[i][1]=123;
    lineData[i][2]=139;
    lineData[i][3]=lineLength;
  }
  chooseColor=1;
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

void update() {
  for (i=0; i<lineNum; i++) {
    drawLine(lineData[i][0], lineData[i][1], lineData[i][2], lineData[i][3], linePosition[i][0], linePosition[i][1]);
  }
  for (i=0; i<=stepCounter; i++) {
    drawKnitPoint(knitPoint[i][0], knitPoint[i][1], knitPoint[i][2], knitPoint[i][3], knitPoint[i][4]);
  }
}
void textOpening() {
  textSize(15);
  fill(205, 92, 92);
  text("Step1:Choose the Line: "+(chosen+1), textOpeningX, textOpeningY);
  text("Step2:Choose the Color", textOpeningX, textOpeningY+20);
  text("Step3:Check the Buttom!", textOpeningX, textOpeningY+40);
}
void textStep(int c, int r) {
  textSize(20);
  fill(165, 42, 42);
  text("Step:"+(stepCounter), textStepX, textStepY);
  text("Core:" + (c+1), textStepX, textStepY+20);
  text("Roller:" + (r+1), textStepX, textStepY+40); 

  if (coreFlag==0) { 
    fill(139, 212, 115);
    text("Core:" + (c+1), textStepX, textStepY+20);
  } else {
    fill(139, 212, 115);
    text("Roller:" + (r+1), textStepX, textStepY+40);
  }
}

void chooseColor() {
  stroke(0, 0, 0);
  strokeWeight(2);
  fill(0, 0, 0, 0);
  rect(260, 180, 60, 60);
  if (mouseX>colorCardX&&mouseX<(colorCardX+100)) {
    if (mouseY>colorCardY&&mouseY<(colorCardY+100)) {
      stroke(255);
      fill((mouseX-colorCardX)*2.25, (mouseY-colorCardY)*2.25, 100); 
      rect(260, 180, 60, 60);
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
  if (chooseColor==1) {
    if (lineFlag ==1) {
      if (mouseY>startY&&mouseY<(startY+lineLength)) {
        j=0;
        for ( i=0; i<lineNum; i++) {
          if (mouseX>((startX+j)-(distance/2))&&mouseX<((startX+j)+(distance/2))) {
            chosen=i;

            lineFlag=0;
            colorFlag=1;
          }
          j=j+distance;
        }
      }
    }

    if (colorFlag==1) {
      if (mouseX>colorCardX&&mouseX<(colorCardX+100)) {
        if (mouseY>colorCardY&&mouseY<(colorCardY+100)) {
          lineData[chosen][0]=(int((mouseX-colorCardX)*2.25));
          lineData[chosen][1]=(int((mouseY-colorCardY)*2.25));
          lineData[chosen][2]=100;

          colorFlag=0;
          lineFlag=1;
        }
      }
    }
  }

  if (mouseX>okButtomX&&mouseX<(okButtomX+buttomXSize)) {
    if (mouseY>okButtomY&&mouseY<(okButtomY+buttomYSize)) {
      chooseColor=2;
      knitReady=1;
    }
    if (mouseY>undoButtomY&&mouseY<(undoButtomY+buttomYSize)) {
      //if(stepCounter>0)stepCounter--;
      textSize(30);
      fill(165, 42, 42);

      text("Oops! It cannont work!"+(stepCounter), textStepX, textStepY);
    }

    if (mouseY>reButtomY&&mouseY<(reButtomY+buttomYSize)) 
      chooseColor=0;
  }

  /*if (mouseX>undoButtomX&&mouseX<(undoButtomX+70)) {
   if (mouseY>undoButtomY&&mouseY<(undoButtomY+20)) {
   if(stepCounter>0)stepCounter--;
   }
   }
   
   if (mouseX>reButtomX&&mouseX<(reButtomX+70)) {
   if (mouseY>reButtomY&&mouseY<(reButtomY+20)) {
   chooseColor=0;
   }
   }*/

  if (knitReady==1) {
    if (mouseY>startY&&mouseY<(startY+lineLength)) {
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
            if (Core!=Roller) knitStart=1;
            textStep(Core, Roller);
            break;
          }
        }
        j=j+distance;
      }
    }
  }
}

void Knitting() {
  if (knitStart==1) {
    if (lineData[Core][3]>knitSize&&lineData[Roller][3]>knitSize) {
      knitPoint[stepCounter][0]=lineData[Roller][0];
      knitPoint[stepCounter][1]=lineData[Roller][1];
      knitPoint[stepCounter][2]=lineData[Roller][2];
      knitPoint[stepCounter][3]=linePosition[Core][0];
      knitPoint[stepCounter][4]=linePosition[Core][1];
      linePosition[Core][1]=linePosition[Core][1]+knitSize;

      lineData[Core][3]=lineData[Core][3]-knitSize;
      lineData[Roller][3]=lineData[Roller][3]-knitSize;

      for (i=0; i<4; i++) {
        int temp;
        temp=lineData[Core][i];
        lineData[Core][i]=lineData[Roller][i];
        lineData[Roller][i]=temp;
      }
      knitStart=0;
      stepCounter++;
    }
  }
}

void drawLine(int r, int g, int b, int l, int x, int y) {
  strokeWeight(lineStroke);
  stroke(r, g, b);
  line(x, y, x, y+l);
}

void drawBigLine(int r, int g, int b, int l, int x, int y) {
  strokeWeight(lineStroke+5);
  stroke(r, g, b);
  line(x, y, x, y+l+4);
}

void drawKnitPoint(int r, int g, int b, int x, int y) {
  strokeWeight(0);
  fill(r, g, b);
  ellipse(x, y, knitSize, knitSize);
}

void checkbuttom() {
  fill(139, 105, 105);
  textSize(15);
  text("click OK!", okButtomX+5, okButtomY+15);
  fill(205, 133, 63, 10);
  rect(okButtomX, okButtomY, 70, 20);
}

void undoButtom() {
  fill(139, 105, 105);
  textSize(15);
  text("Undo", undoButtomX+15, undoButtomY+15);
  fill(205, 133, 63, 10);
  rect(undoButtomX, undoButtomY, 70, 20);
}

void reButtom() {
  fill(139, 105, 105);
  textSize(15);
  text("Restart", reButtomX+9, reButtomY+15);
  fill(205, 133, 63, 10);
  rect(reButtomX, reButtomY, 70, 20);
}

