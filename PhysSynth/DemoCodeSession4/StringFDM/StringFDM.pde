// Finite difference solution of string (or any 1D wave)
//   Perry R. Cook, 2015

int nump = 110;
int randPluck = 0;
float xscale;
float damp = 0.999;
float string[] = new float[nump];
float stringv[] = new float[nump];
float accel, del1x,del2x,yoffs;

boolean running = false;
boolean graphv = false;

color scanc = color(255,0,0);

import oscP5.*;
import netP5.*; 
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(640, 480);
  xscale = width/(nump*1.0);
  yoffs = height/2;
  //center shape in window
  noStroke();
  frameRate(30);
  setupOSC();
  oscOrder(nump);
  pluck(nump/2);
}
 
void keyPressed()  {
    if (key == '1') pluck(nump/20);
    if (key == '2') pluck(nump/14);
    if (key == '3') pluck(nump/8);
    if (key == '4') pluck(nump/6);
    if (key == '5') pluck(nump/5);
    if (key == '6') pluck(nump/4);
    if (key == '7') pluck(2*nump/5);
    if (key == '8') pluck(nump/2);

     if (key == '9') { clear(); strike(nump/2); }

     if (key == 't') pluck(nump/2);
     if (key == 'p') pulse();    
     if (key == 'h') hammer();    

     if (key == '0') clear();
     if (key == 'r') running = true;
     if (key == 's') running = false;
     if (key == 'v') graphv = !graphv;
}

void pulse()  {
   clear();
   for (int i = 0; i < 16; i++)  {
      float val = (float)(1.0-Math.cos(PI*i/8));
      string[nump/2-8+i] = 0.25*val;
   }
}

void hammer()  {
   clear();
   for (int i = 0; i < 8; i++)  {
      float val = (float)(1.0-Math.cos(PI*i/4));
      stringv[i+1] = -0.03*val;
   }
}

void clear()  {
  for (int x = 0; x < nump; x++)  {
    string[x] = 0.0;
    stringv[x] = 0.0;
  }
}

void strike(int pos)  {
   stringv[pos] = 0.5;  
}

void pluck(int pos)  {
    float delup = 0.5/pos;
    float deldown = 0.5/(nump-pos-1);
    float val = 0.0;
    if (!running) {
      for (int x=0; x <= nump-1; x++)  {
          string[x] = 0.0;
      }
    }
    for (int x=0; x < pos; x++)  {
       string[x] += val;
       val += delup;
    }
    val -= deldown;
    for (int x=pos; x < nump-1; x++)  {
      string[x] += val;
      val -= deldown;
    }     
}

void setupOSC()  {
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void oscOrder(int order)  {
  OscMessage myMessage = new OscMessage("/scanOrder");
  myMessage.add(order); /* add an int to the osc message */ 
  oscP5.send(myMessage, myRemoteLocation); 
}

void draw() {
  fill(0); stroke(0);
  rect(0,0,width, height);
  drawString();  
  fill(255); stroke(255);
  text("Key Commands:  1-9=pluck position  0=clear",20,20);
  text("  p=pulse (in center)   t=triangle   h=hammer (at end)",20,40);
  text("   NOTE: some new excitations are additive, use 0 to clear",20,60);
  text("  r=run s=stop   v=velocity plot",20,80);
}

void drawString()  {
  if (running)  {
   for (int x=1; x < nump-1; x++)  {
         del1x = string[x] - string[x-1];
         del2x = string[x+1] - string[x];
         accel = (del2x-del1x);
         stringv[x] += 0.5*accel;
    }
//  now update whole string
   for (int x=0; x < nump; x++)  {
        string[x] = damp*string[x] + stringv[x];
   }
//   stroke(128);
//   line(0,ly,width,ly);
  }

  // draw string and send OSC  
   stroke(255);
   float lx = 0.0;
   float ly = height/2;
   float y;
   OscMessage myMessage = new OscMessage("/scanSynth");
   for (int x=0; x < nump; x++)  {
        y = yoffs - yoffs*string[x];
        float xp = x*xscale;
//        print(x,y,"\n");
        line(lx,ly,xp,y);
        myMessage.add(string[x]); /* add a float to the osc message */
        lx = xp;
        ly = y;
    }
    if (graphv)  {
       lx = 0.0;
       ly = 4*height/5;
       for (int x=0; x < nump; x++)  {
           float xp = x*xscale;
           y =  1.5*yoffs - yoffs*stringv[x];
           line(lx,ly,xp,y);
           lx = xp;
           ly = y;
       }
    }
       
   oscP5.send(myMessage, myRemoteLocation); 

}