//   Additive Fourier Harmonic Display and GUI
//   by Perry R. Cook, Summer 2015
//   Key commands are printed into display window.
//   Run AdditiveHarmonicSynth.ck   in chuck before,
//   and you'll hear what you're doing in real time!!
//     NOTE:  You must import and add the OscP5 library

int nump = 110;
float xscale,yoffs,yscale;
float damp = 0.999;
float string[] = new float[nump];
int NUM_HARMS = 20;
float harms[] = new float[NUM_HARMS];
float basefreq = 1.0;
float time;

import oscP5.*;
import netP5.*; 
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
//  size(1920, 1080);
//  size(1280, 640);
  size(640, 320);
  xscale = width/(nump*1.0);
  yoffs = height/2;
  yscale = 0.5*yoffs;
  //center shape in window
  noStroke();
  frameRate(30);
  setupOSC();
  oscOrder(NUM_HARMS);
}

void setupOSC()  {
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void oscOrder(int order)  {
  OscMessage myMessage = new OscMessage("/Order");
  myMessage.add(order); /* add an int to the osc message */ 
  oscP5.send(myMessage, myRemoteLocation); 
}

void dispose()  {
  OscMessage myMessage = new OscMessage("/Order");
  myMessage.add(0); /* add an int to the osc message */ 
  oscP5.send(myMessage, myRemoteLocation); 
}

void draw() {
  fill(0);
  rect(0,0,width, height);
  stroke(0);
  line(0,0,width,0); // weird fixup for lines
  line(0,0,0,height);
  drawString(); 
  fill(255);
  text("Key Commands:  1-0 = harmonics1-10      <shift>1-9=harmonics11-19",20,20);
  text("    0 = clear     p=pulse   t=triangle   s = square   r = sawtooth (ramp)",20,40);
  text("    <space>=tick forward in time  (hold to run)",20,height-20);
}

void drawString()  {
   float lx = 0.0;
   float ly = height/2;
   stroke(255);
   for (int x=0; x < nump; x++)  {
        float xp = x*xscale;
        float y=yoffs;
        for (int i = 1; i < NUM_HARMS; i++)  {
            y -= harms[i]*yscale*sin(x*i*basefreq*PI/nump)*cos(i*time*PI);
        }
        line(lx,ly,xp,y);
        lx = xp;
        ly = y;
    }
}

void updateHarmsOSC()  {
  OscMessage myMessage = new OscMessage("/Harms");
  for (int i = 1; i < NUM_HARMS; i++)  {
     myMessage.add(harms[i]); /* add float to the osc message */
  }
  oscP5.send(myMessage, myRemoteLocation);
}

void keyPressed()  {
    if (key == 'c') clear();
    if (key == '1') harms[1] = 1.0;
    if (key == '2') harms[2] = 1.0/2;
    if (key == '3') harms[3] = 1.0/3;
    if (key == '4') harms[4] = 1.0/4;
    if (key == '5') harms[5] = 1.0/5;
    if (key == '6') harms[6] = 1.0/6;
    if (key == '7') harms[7] = 1.0/7;
    if (key == '8') harms[8] = 1.0/8;
    if (key == '9') harms[9] = 1.0/9;
    if (key == '0') harms[10] = 1.0/10;
    if (key == '!') harms[11] = 1.0/11;
    if (key == '@') harms[12] = 1.0/12;
    if (key == '#') harms[13] = 1.0/13;
    if (key == '$') harms[14] = 1.0/14;
    if (key == '%') harms[15] = 1.0/15;
    if (key == '^') harms[16] = 1.0/16;
    if (key == '&') harms[17] = 1.0/17;
    if (key == '*') harms[18] = 1.0/18;
    if (key == '(') harms[19] = 1.0/19;
    if (key == 't') triangle();
    if (key == 's') square();
    if (key == 'r') ramp();
    if (key == 'p') pulse();
    if (key == 'f') {
      if (basefreq == 1) basefreq = 2.0;
      else basefreq = 1;
    }
    if (key == ' ') time += 0.02;
    updateHarmsOSC();
}

void clear()  {
  for (int i = 0; i < NUM_HARMS; i++) harms[i] = 0;
  time = 0.0;
}

void triangle()  { // additive triangle wave, odd harmonics 1/N^2
  clear();
  harms[1] = 1.0;
  harms[3] = -1.0/9;
  harms[5] = 1.0/25;
  harms[7] = -1.0/49;
  harms[9] = 1.0/81;
  harms[11] = -1.0/121;
  harms[13] = 1.0/169;
  harms[15] = -1.0/225;
  harms[17] = 1.0/289;
  harms[19] = -1.0/361;
}

void square()  {  // additive square wave, odd harmonics 1/N
  clear();
  harms[1] = 1.0;
  harms[3] = 1.0/3;
  harms[5] = 1.0/5;
  harms[7] = 1.0/7;
  harms[9] = 1.0/9;
  harms[11] = 1.0/11;
  harms[13] = 1.0/13;
  harms[15] = 1.0/15;
  harms[17] = 1.0/17;
  harms[19] = 1.0/19;
}

void pulse()  {  // cosine pulse in center, additive model
   harms[ 1 ]= 0.159597 ; 
   harms[ 3 ]= -0.156406 ; 
   harms[ 5 ]= 0.150175 ; 
   harms[ 7 ]= -0.141202 ; 
   harms[ 9 ]= 0.129907 ; 
   harms[ 11 ]= -0.116805 ; 
   harms[ 13 ]= 0.102475 ; 
   harms[ 15 ]= -0.087522 ; 
   harms[ 17 ]= 0.072543 ; 
   harms[ 19 ]= -0.058090 ; 
}

void ramp()  {  // sawtooth
  clear();
  for (int i = 1; i < 20; i++) {
      harms[i] = 1.0/i;
  }
}