//INIT FONTS AND IMAGES
PFont fontMain;    //font used across the game
PFont fontBC;      //font used for BET and CREDIT
PImage bFace;      //back of the cards image
PImage dollar;     //dollar pic on splash page
PImage[] card = new PImage[53];  //front of the cards images

//SCREEN SETUP
int screenW=1024;  //game area width
int screenH=854;   //game area height
int hEdge;  //horizontal distance from screen edge to game area 
int vEdge;   //vertical distance from screen edge to game area
color bg=color(30,30,255);  //background color
  //splash screen funky colors
color[] splash={color(255,0,80),color(185,225,250),color(66,191,0),color(103,0,80),color(255,255,0),color(150,150,255),color(255,255,0),color(183,222,255),color(255,0,80)};
color[] text={color(255,0,0),color(150,230,255)};    //blinking text colors
int pixelSize=4;      //used to simulate 8bit graphic

//GAME CONFIG
  //cards coding
String[] cards={"500","101","102","103","104","105","106","107","108","109","110","111","112","113","201","202","203","204","205","206","207","208","209","210","211","212","213","301","302","303","304","305","306","307","308","309","310","311","312","313","401","402","403","404","405","406","407","408","409","410","411","412","413"};
String[] wins={"2 PAIRS","3 OF A KIND","STRAIGHT","FLUSH","FULL HOUSE","4 OF A KIND","STRAIGHT FLUSH","ROYAL FLUSH","5 OF A KIND","MINI BONUS"};
int[] bets={1,2,3,4,5,8,10,15,20,30,40,50,100};  //values of possible bets
int[] prize={3,5,7,9,12,40,80,300,600};          //values of prizes for each winnings on bet 1
int delay1=100;   //sets the delay for turning cards
int delay2=200;   //sets a secondary delay
int jollyChance=20;  //sets chance of getting a Jolly

//GAME DATA
int miniBonus=0;             //initialise mini bonus
int miniBonusWin;              //stores value at which mini bonus win is triggered (101-120)
int bet=0;                     //stores index of current bet from bets[]
int bet0=0;                    //used for storing bet used in 1st hand
int credit=0;                  //used for storing current credit
int screen=0;                  //used to identify current screen: 0=landing;1=Main;3=RNGame
int turn=0;                    //0=waiting deal;1=1st hand loaded;2=2nd hand loaded;3=RNGame
int cardsHeld=0;               //stores number of cards held
int flipOut=20;                //used to fade out cards
int flipIn;                    //used to fade in cards
int win=0;                     //Winning hand: 0=Nothing, 1=small pair, 2=high pair, 3=2 pairs...
int winPrize=0;                //index of win within prize[]
int hasJ=-1;                   //stores position of Jolly
int tCard;                     //stores value of the card in a pair winning, to determine the highest possible pair
int RNGWin;                    //total win for RNGame
int RNGHand;                   //current hand in RNGame
int RNGHands;                  //number of hands to guess in RNGame
int winSum;                    //current sum to win
int[] turnCards={0,0,0,0,0};   //Used for chaning cards in hand: 0=no; 1=back steady; 2=back interim 3=front
int[] hand={99,99,99,99,99};   //stores index of cards on the table from cards[]
int[] order={0,0,0,0,0};       //stores index of cards within hand when put in order
int[] RNGCards={99,99,99,99,99,99,99,99,99,99,99};  //buffer for storing used RNGame cards
long lastTurn=0;               //stores millis() on a specific moment
boolean[] hold={false,false,false,false,false};  //stores held cards information
boolean wait4cards;            //used to coordinate card drawing vs rest of the screen
boolean showWin=false;         //used to determine whether to show BET or WIN
String ttd;                    //used to store text


void setup() {

//SCREEN SETUP
  fullScreen();
  //size(1500,900);
  background(0);
  hEdge=width/2-screenW/2;        //calculates lateral edge from screen to game area
  vEdge=height/2-screenH/2;       //calculates top edge from screen to game area

//LOAD FONTS AND IMAGES
  fontMain = createFont("Press Start 2P",28);  //loads main font
  fontBC = createFont("Quadrit",42);           //loads font used for bet, credit and RNGame top prize
  
  bFace=loadImage("bFace.jpg");      //loads the back of the cards image
  dollar=loadImage("s.jpg");
  for (int i=0;i<card.length;i++) {    
    card[i]=loadImage(cards[i]+".jpg");  //loads all front of the cards
  }

//DRAW GAME AREA
  clearScreen();

//INIT GAME 
  miniBonusWin=int(random(101,120));
}

void draw() {
  //println((mouseX-hEdge) + "/" + (mouseY-vEdge));
  switch (screen) {
    case 0:
      loadLanding(millis()/500 % (splash.length-1));
      break;
    case 1:
      cardsHeld=0;
      for (int i=0;i<5;i++) {
        if (hold[i]==true) {
          cardsHeld++;
        }
      }
      loadMain();
      break;
    case 2:
    case 3:
      loadHelp();
      break;
    }
  
//Deal cards face down one by one
  if (millis()-lastTurn>delay1 && (turnCards[0]==1 || turnCards[0]==3)) {
    loadBFace(1);
    lastTurn=millis();
    if (turnCards[0]==1) {
      turnCards[0]=0;
    } else {
      turnCards[0]=2;
    }
  }
  if (millis()-lastTurn>delay1 && (turnCards[1]==1 || turnCards[1]==3)) {
    loadBFace(2);
    lastTurn=millis();
    if (turnCards[1]==1) {
      turnCards[1]=0;
    } else {
      turnCards[1]=2;
    }
  }
  if (millis()-lastTurn>delay1 && (turnCards[2]==1 || turnCards[2]==3)) {
    loadBFace(3);
    lastTurn=millis();
    if (turnCards[2]==1) {
      turnCards[2]=0;
    } else {
      turnCards[2]=2;
    }
  }
  if (millis()-lastTurn>delay1 && (turnCards[3]==1 || turnCards[3]==3)) {
    loadBFace(4);
    lastTurn=millis();
    if (turnCards[3]==1) {
      turnCards[3]=0;
    } else {
      turnCards[3]=2;
    }
  }
  if (millis()-lastTurn>delay1 && (turnCards[4]==1 || turnCards[4]==3)) {
    loadBFace(5);
    lastTurn=millis();
    if (turnCards[4]==1) {
      turnCards[4]=0;
    } else {
      turnCards[4]=2;
    }
  }

//flip cards face up  
  if (turnCards[0]!=3 && turnCards[1]!=3 && turnCards[2]!=3 && turnCards[3]!=3 && turnCards[4]!=3 && millis()-lastTurn>delay1) {
    for (int i=0;i<5;i++) {
      if (turnCards[i]==2) {
        if (flipOut<=110) {
          dealBOut();
          flipIn=flipOut;
        }
        if (flipOut>110) {
          if (flipIn>=20) {
            dealIn();
          } else {         
            turnCards[i]=0;
          }
        }
      }
    }
  }

//check if still waiting for cards
  if (turnCards[0]+turnCards[1]+turnCards[2]+turnCards[3]+turnCards[4]==0) {
    wait4cards=false;
  }
  
//mark held cards
  if (!wait4cards && screen==1) {
    textFont(fontMain);
    textAlign(LEFT);
    if (turn==1) {
      ttd="HELD";
      fill(255,255,0);
      text("SELECT HOLD CARDS",hEdge+25,vEdge+435);
    } else {
      if (turn==2 || turn==3) {
        ttd="WIN";
      } else {
        if (turn==4) {
          ttd="PAID";
        }
      }
    }

    textAlign(CENTER);
    for (int i=0;i<5;i++) {
      if (hold[i]) {
        fill(text[(millis()/500)%2]);
        text(ttd,hEdge+117+(i*199),vEdge+755);
      }
    }
  }
}

void keyPressed() {
  if (key == 'h') {
    if (screen==0) {
      screen=2;
    } else {
      if (screen==1) {
        screen=3;
      } else {
        if (screen==2) {
          screen=0;
        } else {
          screen=1;
        }
      }
    }
  }
  if (screen<2) {
    if (key == CODED) {
      if (keyCode==RIGHT) {
        if (turn<3) {
          credit+=10;
        } else {
          if (winSum>0 && turn==3) {
            dealRNG();
            if(int(cards[RNGCards[RNGHand]].substring(0,1))==1 || int(cards[RNGCards[RNGHand]].substring(0,1))==3) {
              if (RNGHand<RNGHands-1) {
                winSum=winSum*2;    //double the win ammount
              } else {
                winSum=RNGWin;      //reached big prize
                turn=4;
              }
              RNGHand++;
              println(RNGHand + "/" + RNGHands);
            } else {
              winSum=0;            //lost
              turn=4;
            }
          }
        }
      }
      if (keyCode==LEFT) {
        if (turn<3) {
          if (credit>=10) {
            credit-=10;
          } else {
            credit=0;
          }
        } else {
          if (winSum>0 && turn==3) {
            dealRNG();
            if(int(cards[RNGCards[RNGHand]].substring(0,1))==2 || int(cards[RNGCards[RNGHand]].substring(0,1))==4) {
              if (RNGHand<RNGHands-1) {
                winSum=winSum*2;    //double the win ammount
              } else {
                winSum=RNGWin;      //reached big prize
                turn=4;
              }
              RNGHand++;
              println(RNGHand + "/" + RNGHands);
            } else {
              if (win==2) {
                miniBonus=0;
              }
              winSum=0;            //lost
              turn=4;
            }
          }
        }
      }
      if (keyCode==UP && screen==1 && bet<bets.length-1 && bets[bet+1]<=credit && !showWin) {
        if (turn<2 || (turn==2 && (cardsHeld==0 || (cardsHeld>0 && cardsHeld<5 && bet0>bets[bet+1])))) {
          bet++;
        }
      }
      if (keyCode==DOWN && screen==1 && bet>0 && !showWin) {
        bet--;
      }
    } else {
      if (key == ' ') {
        switch (screen) {
          case 0:
            if (credit>0) {
              clearScreen();
              screen=1;
              turn=0;
              for (int i=0;i<5;i++) {
                turnCards[i]=1;
              }
              lastTurn=millis();
            }
            break;
          case 1:
            switch (turn) {
              case 0:    //cards are waiting face down
                if (credit>=bets[bet]) {
                  credit-=bets[bet];
                  bet0=bet;
                  win=0;
                  flipOut=20;
                  hasJ=-1;
                  for (int i=0;i<5;i++) {
                    deal(i);
                    turnCards[i]=2;
                  }
                  wait4cards=true;
                  turn=1;
                  checkHand();
                }
                break;
              case 1:  //1st hand is on the screen
                if (cardsHeld==5 && win>2 && win!=5 && win!=7) {  //All cards are held and there's a win
                  doWin();
                } else {
                  if (cardsHeld!=5 && credit >= bets[bet]) {
                    credit-=bets[bet];
                    if (cardsHeld>0 && cardsHeld<5) {  //1-4 cards are held
                      for (int i=0;i<5;i++) {
                        if(hold[i]==false) {
                          unload(i);
                          deal(i);
                          turnCards[i]=3;
                        } else {
                          hold[i]=false;
                        }
                      }
                      wait4cards=true;
                      flipOut=20;
                      win=0;
                      turn=2;
                      checkHand();
                      if (win>1 && win!=5 && win!=7) {
                        doWin();
                      } else {
                        for (int i=0;i<5;i++) {
                          hold[i]=false;
                        }
                        turn=2;
                      }
                    } else {
                      if (cardsHeld==0) {
                        bet0=bet;
                        win=0;
                        flipOut=20;
                        hasJ=-1;
                        for (int i=0;i<5;i++) {
                          unload(i);
                          deal(i);
                          turnCards[i]=3;
                        }
                        wait4cards=true;
                        lastTurn=millis();
                        turn=1;
                        checkHand();
                      }
                    }
                  }
                }   
                break;
              case 2:
              case 4:
                if (winSum>0) {
                  turn=3;
                } else {
                  showWin=false;
                  if (credit>=bets[bet]) {
                    credit-=bets[bet];
                    bet0=bet;
                    win=0;
                    flipOut=20;
                    hasJ=-1;
                    for (int i=0;i<5;i++) {
                      unload(i);
                      deal(i);
                      turnCards[i]=3;
                    }
                    wait4cards=true;
                    turn=1;
                    checkHand();
                  }
                }
                break;
              case 3:
                credit+=winSum;
                winSum=0;
                win=0;
                turn=4;
                break;
            }
            break;
        }
      }
      if(key=='1' && turn==1) {
        hold[0]=!hold[0];
      }
      if(key=='2' && turn==1) {
        hold[1]=!hold[1];
      }
      if(key=='3' && turn==1) {
        hold[2]=!hold[2];
      }
      if(key=='4' && turn==1) {
        hold[3]=!hold[3];
      }
      if(key=='5' && turn==1) {
        hold[4]=!hold[4];
      }
    }
  }
}

void doWin() {
  //checks if there's a valid win and calculates prize, hands for RNGame, etc. 
  winSum=0;
  RNGWin=0;
  if (win==2) {
    miniBonus+=bets[bet];
    if (miniBonus>=miniBonusWin) {
      RNGWin=1000;
      winSum=100;
    } else {
      win=0;
      turn=2;
    }
  } else {
    if (bets[bet]<10) { //<>//
      //small bet. Prize is 5k
      RNGWin=5000;
    } else {
      if (bets[bet]<40) {
        //medium bet. Prize is 50k
        RNGWin=50000;
      } else {
        if (bets[bet]<100) {
        //high bet. Prize is 200k        RNGWin=200000;
        } else {
          //max bet. Prize is 250k
          RNGWin=250000;
        }
      }
    }
    winSum=prize[winPrize]*bets[bet];
  }
  //calculate number of hands to win in RNGame
  if (RNGWin>0) {
    RNGHands=1;
    int i=winSum;
    while (i < RNGWin) {
      RNGHands++;
      i=i*2;
    }
    RNGHands=RNGHands-2;
    RNGHand=0;
    showWin=true;
    for (int j=0;j<RNGCards.length;j++){
      RNGCards[j]=99;
    }
    turn=2;
  }
}

void deal(int count) {
  boolean done=false;
  
  if (hasJ<0 && int(random(jollyChance))==1) {
    hasJ=count;
    hand[count]=0;
  } else {
    while (!done) {
      done=true;
      hand[count]=int(random(1,cards.length));
      for (int i=0;i<5;i++) {
        if (i!=count && hand[count]==hand[i] || (hand[count]<4 && hand[i]<4)) {
          done=false;
        }
      }
    }
  }
}

void dealRNG() {
  boolean done=false;
  
  while (!done) {
    done=true;
    RNGCards[RNGHand]=int(random(1,cards.length));
    for (int i=0;i<5;i++) {
      if (hand[i]==RNGCards[RNGHand]) {
        done=false;
      }
      if (RNGHand!=i && RNGCards[RNGHand]==RNGCards[i]) {
        done=false;
      }
    }
  }
}

void dealIn() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  for (int i=0;i<5;i++) {
    if (turnCards[i]==2) {
      fill(0);
      rect(flipIn-1+(i*199),439,191-(flipIn-19)*2,282);
      rect8bit(flipIn+(i*199),440,189-(flipIn-20)*2,280,1,0,0,100,255,255,255);
      image(card[hand[i]],flipIn+5+(i*199),445,179-(flipIn-20)*2,270);
    }
  }
  flipIn-=10;
  popMatrix();
}

void dealBOut() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  for (int i=0;i<5;i++) {
    if (turnCards[i]==2) {
      fill(bg);
      rect(19+(i*199),439,191,282);
      rect8bit(flipOut+(i*199),440,189-(flipOut-20)*2,280,1,0,0,100,255,255,255);
      image(bFace,flipOut+5+(i*199),445,179-(flipOut-20)*2,270);
    }
    flipOut+=10;
  }
  popMatrix();
}

void unload(int count) {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  fill(bg);
  rect(19+(199*count),439,191,282);
  popMatrix();
}

void loadMain() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  fill(bg);
  rect(0,40,screenW,350);
  rect(0,390,screenW,49);
  rect(0,721,screenW,39);
  rect(0,760, screenW, 80);
  popMatrix();
  
  if (turn<3) {
    loadPrizeList();
  } else {
    loadRNGame();
  }
  loadMiniBonus();
  if (showWin && !wait4cards) {
    loadWin();
  } else {
    loadBet();
  }
  loadCredit();
}

void loadLanding(int count) {      //draws the splash screen
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  fill(bg);
  rect(0, 0, screenW,screenH);
  
  //draw title in an 8bit rectangle
  textFont(fontMain);
  rect8bit(10,40,950,60,3,66,244,238,130,45,160);
  fill(255,255,0);
  text("A M E R I C A N   P O K E R  II",65,85);
  
  //draw funky squares
  rectMode(CORNERS);
  stroke(splash[count]);
  strokeWeight(20);
  rect(350,120,674,680);
  
  stroke(splash[(count+1) % (splash.length-1)]);
  strokeWeight(4);
  rect(362,132,662,668);
  
  stroke(splash[(count+2) % (splash.length-1)]);
  rect(366,136,658,664);
  
  stroke(splash[(count+3) % (splash.length-1)]);
  strokeWeight(20);
  rect(378,148,646,652);
  
  stroke(splash[(count+4) % (splash.length-1)]);
  strokeWeight(4);
  rect(390,160,634,640);
  
  stroke(splash[(count+5) % (splash.length-1)]);
  strokeWeight(20);
  rect(402,172,622,628);
  
  stroke(splash[(count+6) % (splash.length-1)]);
  strokeWeight(4);
  rect(414,186,610,616);
  
  stroke(splash[(count+7) % (splash.length-1)]);
  strokeWeight(20);
  rect(426,198,598,604);
  
  noStroke();
  fill(0);
  rect(436,208,588,594);
  
  fill(151,184,255);
  rect(442,214,582,264);
  rect(442,528,582,588);
  
  fill(255,255,0);
  image(dollar,442,270,140,252);
  //rect(442,270,582,522);
  
  textAlign(CENTER);
  textFont(fontMain);
  fill(text[count%2]);
  text("Load CREDIT to start",512,735);
  textAlign(LEFT);
  rectMode(CORNER);
  popMatrix();
  loadMiniBonus();
  loadBet();
  loadCredit();
}

void loadHelp() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  textFont(fontMain);
  rect8bit(150,40,724,350,2,0,0,165,66,244,238);
  textAlign(RIGHT);
  fill(255,0,0);
  text("<UP>",360,90);
  text("<DOWN>",360,140);
  text("<RIGHT>",360,190);
  text("<LEFT>",360,240);
  text("SPACE",360,290);
  text("1-5",360,340);
  textAlign(LEFT);
  fill(0,0,255);
  text("BET+",380,90);
  text("BET-",380,140);
  text("CREDIT+ / BLACK*",380,190);
  text("CREDIT- / RED*",380,240);
  text("DEAL / CASH-IN",380,290);
  text("HOLD CARDS",380,340);
  textSize(16);
  text("*=during RED/BLACK betting game",250,370);
  popMatrix();
}

void loadPrizeList() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  rect8bit(150,40,724,350,2,0,0,165,66,244,238);
  textFont(fontMain);
  textAlign(LEFT);  
  
  if (turn>0) {
    fill(255,0,0);
  }
  if (!wait4cards) {
    switch (win) {
      case 3:
        rect(155,325,714,29);
        break;
      case 4:
        rect(155,295,714,29);
        break;
      case 6:
        rect(155,265,714,29);
        break;
      case 8:
        rect(155,235,714,29);
        break;
      case 9:
        rect(155,205,714,29);
        break;
      case 10:
        rect(155,175,714,29);
        break;
      case 11:
        rect(155,145,714,29);
        break;
      case 12:
        rect(155,85,714,29);
        break;
      case 13:
        rect(155,55,714,29);      
        break;
    }
  }
  if (win==13 && !wait4cards) {
    fill(255,255,0);
    text("5 OF A KIND",210,85);
    fill(255,0,0);
    text("ROYAL FLUSH",210,115);
    fill(255,255,0);
    textAlign(RIGHT);
    text(prize[8]*bets[bet],830,85);
    fill(255,0,0);
    text(prize[7]*bets[bet],830,115);
  } else {
    if (win==12 && !wait4cards) {
      fill(255,0,0);
      text("5 OF A KIND",210,85);
      fill(255,255,0);
      text("ROYAL FLUSH",210,115);
      fill(255,0,0);
      textAlign(RIGHT);
      text(prize[8]*bets[bet],830,85);
      fill(255,255,0);
      text(prize[7]*bets[bet],830,115);
    } else {
      fill(255,0,0);
      text("5 OF A KIND",210,85);
      text("ROYAL FLUSH",210,115);
      textAlign(RIGHT);
      text(prize[8]*bets[bet],830,85);
      text(prize[7]*bets[bet],830,115);
    }
  }
  
  textAlign(LEFT);
  fill(0);
  text("STR FLUSH",210,175);
  text("4 OF A KIND",210,205);
  text("FULL HOUSE",210,235);
  text("FLUSH",210,265);
  text("STRAIGHT",210,295);
  text("3 OF A KIND",210,325);
  text("2 PAIR",210,355);
  fill(255,0,0);
  textAlign(RIGHT);

  fill(0);
  text(prize[6]*bets[bet],830,175);
  text(prize[5]*bets[bet],830,205);
  text(prize[4]*bets[bet],830,235);
  text(prize[3]*bets[bet],830,265);
  text(prize[2]*bets[bet],830,295);
  text(prize[1]*bets[bet],830,325);
  text(prize[0]*bets[bet],830,355);
  textAlign(LEFT);
  popMatrix();
}

void loadMiniBonus() {    //draws the mini bonus box
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  if (miniBonus<100) {
    rect8bit(15,760,310,80,1,0,0,165,66,244,238);
    fill(0);
  } else {
    rect8bit(15,760,310,80,1,0,0,165,255,255,0);
    fill(255,0,0);
  }
  textFont(fontMain);
  textAlign(LEFT);
  text("MINI BONUS",35,800);
  textAlign(RIGHT);
  if (miniBonus<100) {
    text(miniBonus,260,830);
  } else {
    text(100,260,830);
  }
  textAlign(LEFT);
  popMatrix();
}

void loadBet() {      //draws the bet box
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  if (bet>credit && credit>0) {
    rect8bit(360,760,250,80,1,0,0,165,240,0,0);
  } else {
    rect8bit(360,760,250,80,1,0,0,165,66,244,238);
  }
    
  textFont(fontBC);
  fill(bg);
  
  for (int x=-3; x<4;x++) {
    textAlign(LEFT);
    text("BET",375+x,820);
    text("BET",375,820+x);
    textAlign(RIGHT);
    text(bets[bet],595+x,820);
    text(bets[bet],595,820+x);
  }
  if (bet<10) {
    fill(255,255,0);
  } else {
    fill(255,30,30);
  }
  textAlign(LEFT);
  text("BET",375,820);
  textAlign(RIGHT);
  text(bets[bet],595,820);
  textAlign(LEFT);
  popMatrix();
}

void loadCredit() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  rect8bit(645,760,365,80,1,0,0,165,66,244,238);
  textFont(fontBC);
  fill(bg);
  
  for (int x=-3; x<4;x++) {
    textAlign(LEFT);
    text("CREDIT",660+x,820);
    text("CREDIT",660,820+x);
    textAlign(RIGHT);
    text(credit,995+x,820);
    text(credit,995,820+x);
  }
  if (bet<10) {
    fill(255,255,0);
  } else {
    fill(255,30,30);
  }
  textAlign(LEFT);
  text("CREDIT",660,820);
  textAlign(RIGHT);
  text(credit,995,820);
  textAlign(LEFT);
  popMatrix();
}

void loadWin() {      //draws the win box instead of bet
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2); //<>//
  rect8bit(360,760,250,80,1,0,0,165,66,244,238);
  textFont(fontBC);
  fill(bg);
  
  for (int x=-3; x<4;x++) {
    textAlign(LEFT);
    text("WIN",375+x,820);
    text("WIN",375,820+x);
    textAlign(RIGHT);
    text(winSum,595+x,820);
    text(winSum,595,820+x);
  }
  fill(255,30,30);
  textAlign(LEFT);
  text("WIN",375,820);
  textAlign(RIGHT);
  text(winSum,595,820);
  textAlign(LEFT);
  popMatrix();
}

void loadRNGame() {
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  textFont(fontMain);
  rect8bit(10,40,950,60,3,66,244,238,130,45,160);
  textAlign(LEFT);
  fill(255,255,0);
  text(wins[winPrize],65,85);
  textAlign(RIGHT);
  text(winSum,910,85);
  rect8bit(10,105,950,310,2,220,220,220,66,244,238);
  strokeWeight(2);
  stroke(bg);
  rect(35,120,2,276);
  rect(935,120,2,276);
  stroke(0,0,71);
  rect(39,123,2,270);
  rect(931,123,2,270);
  strokeWeight(3);
  if (RNGHand<RNGHands) {
    fill(151,151,151);
  } else {
    fill(255,255,0);
  }
  beginShape();
    vertex(700,193);
    vertex(900,193);
    vertex(910,183);
    vertex(910,133);
    vertex(900,123);
    vertex(700,123);
    vertex(690,133);
    vertex(690,183);
    vertex(700,193);
  endShape();
  textFont(fontBC);
  fill(0,0,71);
  textAlign(CENTER);
  for (int x=-3; x<4;x++) {
    text(RNGWin,800+x,180);
    text(RNGWin,800,180+x);
  }
  fill(0,255,0);
  text(RNGWin,800,180);
  for (int i=0;i<RNGHands-1;i++) {
    if (RNGHands-i>RNGHand+1) {
      fill(151,151,151);
    } else {
      fill(255,255,0);
    }
    beginShape();
      vertex(690,215+(20*i));
      vertex(910,215+(20*i));
      vertex(900,200+(20*i));
      vertex(700,200+(20*i));
      vertex(690,215+(20*i));
    endShape();
  }
  
  //display cards
  fill(0);
  for (int j=0;j<=RNGHand;j++){
    if (RNGCards[j]==99) {
      if (winSum>0 && RNGHand<RNGHands) {
        if (millis()%2==0) {
          fill(55,55,255);
          stroke(55,55,255);
          rect(50+(50*j),117,191,282);
          rect8bit(51+(50*j),118,189,280,1,55,55,255,255,255,255);
        } else {
          rect(50+(50*j),117,191,282);
          rect8bit(51+(50*j),118,189,280,1,0,0,100,255,255,255);
        }
        image(bFace,56+(50*j),123,179,270);
      }
    } else {
      rect(50+(50*j),117,191,282);
      rect8bit(51+(50*j),118,189,280,1,0,0,100,255,255,255);
      image(card[RNGCards[j]],56+(50*j),123,179,270);
    }
  }
  popMatrix();
}

void clearScreen() {
  noStroke();
  fill(bg);
  rect(hEdge, vEdge, screenW,screenH);
}

void loadBFace(int count) {      //loads the (count) card face down 
  pushMatrix();
  translate(width/2-screenW/2,height/2-screenH/2);
  if (count==1) {
    fill(0);
    rect(19,439,191,282);
    rect8bit(20,440,189,280,1,0,0,100,255,255,255);
    image(bFace,25,445,179,270);
  }
  
  if (count==2) {
    fill(0);
    rect(218,439,191,282);
    rect8bit(219,440,189,280,1,0,0,100,255,255,255);
    image(bFace,224,445,179,270);
  }
  if (count==3) {
    fill(0);
    rect(417,439,191,282);
    rect8bit(418,440,189,280,1,0,0,100,255,255,255);
    image(bFace,423,445,179,270);
  }
  if (count==4) {
    fill(0);
    rect(616,439,191,282);
    rect8bit(617,440,189,280,1,0,0,100,255,255,255);
    image(bFace,622,445,179,270);
  }
  if (count==5) {
    fill(0);
    rect(815,439,191,282);
    rect8bit(816,440,189,280,1,0,0,100,255,255,255);
    image(bFace,821,445,179,270);
  }
  popMatrix();
}

void rect8bit(int x, int y, int w, int h, int step, int R1, int G1, int B1, int R2, int G2, int B2) {
  rectMode(CORNERS);
  noStroke();
  
  for (int i=step;i>0;i--) {
    fill(R1,G1,B1);
    rect(x+pixelSize*i,y+pixelSize*(step-i+1),x+pixelSize*(i+1),y+pixelSize*(step-i+2));
    rect(x+w-pixelSize*(i+1),y+pixelSize*(step-i+1),x+w-pixelSize*i,y+pixelSize*(step-i+2));
    rect(x+pixelSize*i,y+h-pixelSize*(step-i+1),x+pixelSize*(i+1),y+h-pixelSize*(step-i+2));
    rect(x+w-pixelSize*(i+1),y+h-pixelSize*(step-i+1),x+w-pixelSize*i,y+h-pixelSize*(step-i+2));
    fill(R2,G2,B2);
    rect(x+pixelSize*(i+1),y+pixelSize*(step-i+1),x+w-pixelSize*(i+1),y+pixelSize*(step-i+2));
    rect(x+pixelSize*(i+1),y+h-pixelSize*(step-i+1),x+w-pixelSize*(i+1),y+h-pixelSize*(step-i+2));
  }
  rect(x+pixelSize,y+pixelSize*(step+1),x+w-pixelSize,y+h-pixelSize*(step+1));
  fill(R1,G1,B1);
  rect(x+pixelSize*(step+1),y,x+w-pixelSize*(step+1),y+pixelSize);
  rect(x+pixelSize*(step+1),y+h-pixelSize,x+w-pixelSize*(step+1),y+h);
  rect(x,y+pixelSize*(step+1),x+pixelSize,y+h-pixelSize*(step+1));
  rect(x+w-pixelSize,y+pixelSize*(step+1),x+w,y+h-pixelSize*(step+1));  
  rectMode(CORNER);
}

void checkHand() {
  boolean[] thold={false,false,false,false,false};  //used to temporary hold cards that form winning hand
  
  if (hasJ>=0) {
    for (int i=4;i<cards.length;i++) {
      boolean found=false;
      for (int j=0;j<5;j++) {
        if (j!=hasJ && cards[i]==cards[hand[j]]) {
          found=true;
        }
      }
      if (!found) {
        hand[hasJ]=i;
        int tempWin=checkWin();
        if (win <= tempWin) {
          tCard=int(cards[i].substring(1,3));
          for (int j=0;j<5;j++) {
            thold[j]=hold[j];
          }
          win=tempWin;
        }
      }
    }
    hand[hasJ]=0;
    hold=thold;
    if (turn<2) {
      hold[hasJ]=true;
    }
  } else {
    win = checkWin();
  }
}

int checkWin(){
  int handS[]={99,99,99,99,99};
  int result=0;
  handS[0]=hand[0];
  order[0]=0;
  
  for (int i=1;i<5;i++) {
    boolean bolFound=false;
    for (int j=0;j<=i;j++) {
      if (!bolFound) {
        if (handS[j]==99) {
          handS[j]=hand[i];
          order[j]=i;
          bolFound=true;
        } else {
          if(int(cards[hand[i]].substring(1,3))<int(cards[handS[j]].substring(1,3))) {
            for (int k=4;k>j;k--) {
              handS[k]=handS[k-1];
              order[k]=order[k-1];
            }
            handS[j]=hand[i];
            order[j]=i;
            bolFound=true;
          }
        }
      }
    }
  }


  if (int(cards[handS[0]].substring(1,3))==int(cards[handS[3]].substring(1,3))){
    //XXXX*
    hold[order[0]]=true;
    hold[order[1]]=true;
    hold[order[2]]=true;
    hold[order[3]]=true;
    hold[order[4]]=false;
    result=10;
  }
  if (int(cards[handS[1]].substring(1,3))==int(cards[handS[4]].substring(1,3))) {
    //*XXXX
    hold[order[1]]=true;
    hold[order[2]]=true;
    hold[order[3]]=true;
    hold[order[4]]=true;
    result=10;
  }
  if (result==0 && int(cards[handS[0]].substring(1,3))==int(cards[handS[2]].substring(1,3))) {
    //XXX??
    if (int(cards[handS[3]].substring(1,3))==int(cards[handS[4]].substring(1,3))) {
      //XXXYY
      hold[order[0]]=true;
      hold[order[1]]=true;
      hold[order[2]]=true;
      hold[order[3]]=true;
      hold[order[4]]=true;
      result=9;
    } else {
      //XXX**
      hold[order[0]]=true;
      hold[order[1]]=true;
      hold[order[2]]=true;
      hold[order[3]]=false;
      hold[order[4]]=false;
      result=4;
    }
  }
  if (result==0 && int(cards[handS[2]].substring(1,3))==int(cards[handS[4]].substring(1,3))) {
    //??XXX
    if (int(cards[handS[0]].substring(1,3))==int(cards[handS[1]].substring(1,3))) {
      //YYXXX
      hold[order[0]]=true;
      hold[order[1]]=true;
      hold[order[2]]=true;
      hold[order[3]]=true;
      hold[order[4]]=true;
      result=9;
    } else {
      //**XXX
      hold[order[0]]=false;
      hold[order[1]]=false;
      hold[order[2]]=true;
      hold[order[3]]=true;
      hold[order[4]]=true;
      result=4;
    }
  }
  if (result==0 && int(cards[handS[1]].substring(1,3))==int(cards[handS[3]].substring(1,3))) {
    //*XXX*
    hold[order[0]]=false;
    hold[order[1]]=true;
    hold[order[2]]=true;
    hold[order[3]]=true;
    hold[order[4]]=false;
    result=4;
  }
  if (result==0 && int(cards[handS[0]].substring(1,3))==int(cards[handS[1]].substring(1,3))){
    //XX???
    if(int(cards[handS[2]].substring(1,3))==int(cards[handS[3]].substring(1,3))) {
    //XXYY*
    hold[order[0]]=true;
    hold[order[1]]=true;
    hold[order[2]]=true;
    hold[order[3]]=true;
    hold[order[4]]=false;
    result=3;
    } else {
      if(int(cards[handS[3]].substring(1,3))==int(cards[handS[4]].substring(1,3))) {
        //XX*YY
        hold[order[0]]=true;
        hold[order[1]]=true;
        hold[order[2]]=false;
        hold[order[3]]=true;
        hold[order[4]]=true;
        result=3;
      }
    }
  } //<>//
  if (result==0 && int(cards[handS[1]].substring(1,3))==int(cards[handS[2]].substring(1,3)) && int(cards[handS[3]].substring(1,3))==int(cards[handS[4]].substring(1,3))){
    //*XXYY
    hold[order[0]]=false;
    hold[order[1]]=true;
    hold[order[2]]=true;
    hold[order[3]]=true;
    hold[order[4]]=true;
    result=3;
  }
  if (int(cards[handS[0]].substring(1,3))+1==int(cards[handS[1]].substring(1,3)) && int(cards[handS[1]].substring(1,3))+1==int(cards[handS[2]].substring(1,3))) {
    //ABC??
    if (int(cards[handS[2]].substring(1,3))+1==int(cards[handS[3]].substring(1,3)) && int(cards[handS[3]].substring(1,3))+1==int(cards[handS[4]].substring(1,3))) {
      //ABCDE
      hold[order[0]]=true;
      hold[order[1]]=true;
      hold[order[2]]=true;
      hold[order[3]]=true;
      hold[order[4]]=true;
      result=6;
    }
  }
  
  if (result==0 && int(cards[handS[0]].substring(1,3))==1 && int(cards[handS[1]].substring(1,3))==10 && int(cards[handS[2]].substring(1,3))==11 && int(cards[handS[3]].substring(1,3))==12 && int(cards[handS[4]].substring(1,3))==13) {
    //A0JQK
    hold[order[0]]=true;
    hold[order[1]]=true;
    hold[order[2]]=true;
    hold[order[3]]=true;
    hold[order[4]]=true;
    result=6;
  }
  if (int(cards[handS[0]].substring(0,1))==int(cards[handS[1]].substring(0,1)) && int(cards[handS[1]].substring(0,1))==int(cards[handS[2]].substring(0,1))) {
    //CCC??
    if (int(cards[handS[2]].substring(0,1))==int(cards[handS[3]].substring(0,1)) && int(cards[handS[3]].substring(0,1))==int(cards[handS[4]].substring(0,1))) {
      if (result==6) {
        //Already straight
        if (int(cards[handS[0]].substring(1,3))==1 && int(cards[handS[4]].substring(1,3))==13) {
          //ROYAL FLUSH
          hold[order[0]]=true;
          hold[order[1]]=true;
          hold[order[2]]=true;
          hold[order[3]]=true;
          hold[order[4]]=true;
          result=12;
        } else {
          //STRAIGHT FLUSH
          hold[order[0]]=true;
          hold[order[1]]=true;
          hold[order[2]]=true;
          hold[order[3]]=true;
          hold[order[4]]=true;
          result=11;
        }
      } else {
        hold[order[0]]=true;
        hold[order[1]]=true;
        hold[order[2]]=true;
        hold[order[3]]=true;
        hold[order[4]]=true;
        result=8;
      }
    }
  }
  if (result==0) {
    for (int i=0;i<5;i++) {
      hold[i]=false;
    }
    for (int i=0;i<4;i++) {
      if (int(cards[handS[i]].substring(1,3))==int(cards[handS[i+1]].substring(1,3))) {
        //PAIR
        if (int(cards[handS[i]].substring(1,3))>10 || int(cards[handS[i]].substring(1,3))==1) {
          if ((int(cards[handS[i]].substring(1,3))>tCard && tCard!=1) || int(cards[handS[i]].substring(1,3))==1) { 
            result=2;
          }
        } else {
          if (int(cards[handS[i]].substring(1,3))>tCard && tCard!=1) {
            result=1;
          }
        }
        if (turn<2) {
          hold[order[i]]=true;
          hold[order[i+1]]=true;
        }
      }
    }
  }
  //println(cards[handS[0]] + ":" + cards[handS[1]] + ":" + cards[handS[2]] + ":" + cards[handS[3]] + ":" + cards[handS[4]]);
  if (result >win) {
    switch (result) {
      case 3:
        winPrize=0;
        break;
      case 4:
        winPrize=1;
        break;
      case 6:
        winPrize=2;
        break;
      case 8:
        winPrize=3;
        break;
      case 9:
        winPrize=4;
        break;
      case 10:
        winPrize=5;
        break;
      case 11:
        winPrize=6;
        break;
      case 12:
        winPrize=7;
        break;
      case 13:
        winPrize=8;
        break;
    }
  }
  return result;
}