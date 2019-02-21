//  2D Finite Difference Mesh Simulation/Animation
//    by Perry R. Cook, 2015

int nump = 220;
int xy = 60;
int oversample = 10;
float scalex,scaley; // scale factors for surface plot
float wscalex,wscaley,woffs; // scale factors for waveform plot
int randHit = 0;
float speedOsound = 0.005;
float damp = 0.99;
float drum[][] = new float[xy+1][xy+1]; // one extra for safety (laziness...)
float drumv[][] = new float[xy+1][xy+1];

color scanc = color(255, 0, 0);
float rscan,xcenter,ycenter;
int myHeight;

import oscP5.*;
import netP5.*; 
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
//  size(1000, 1000);
  size(500, 500);
  myHeight = height;
  scalex = 1.0*width/xy;
  scaley = 1.0*myHeight/xy;
  wscalex = 1.0*width/nump;
  wscaley = (height-myHeight)/2;
  woffs = height - (height-myHeight)/2;
//   print(wscalex,wscaley,woffs,"\n");
  xcenter = width/2;
  ycenter = myHeight/2;
  //center shape in window
  noStroke();
  frameRate(30);
  pluck(xy/3,xy/4);
}
 
void draw() {
  fill(0);
  rect(0,0,width, height);
  if (randHit==1)  {
    if (random(1.0) < 0.05) { 
       int x = 2+int(random(xy-3));
       int y = 2+int(random(xy-3));
       pluck(x,y);
    }
  }
  for (int i = 0; i < oversample; i++)  {
    doPhysics();
  }
  drawSurface();
   fill(255);
   text("Key Controls:",20,height-60);    
   text("1-9: strike at different places",20,height-45);    
   text("r=run random strikes",20,height-30); 
   text("s=stop    0=clear",20,height-15); 
}

void drawSurface()  {
   for (int x=0; x < xy; x++)  {
        for (int y=0; y < xy; y++)  {
            stroke(128.0+(128.0*drum[x][y]));
            line(scalex*x,scaley*y,scalex*(x+1),scaley*(y+1));
            line(scalex*(x+1),scaley*y,scalex*x,scaley*(y+1));
        }
    }
}

void doPhysics()  {
    float curv, del1x, del2x, del1y, del2y;
    // lx, ly;
    for (int x=1; x < xy-1; x++)  {
        for (int y=1; y < xy-1; y++)  {
             del1x = drum[x][y] - drum[x-1][y]; // slope x minus
             del2x = drum[x+1][y] - drum[x][y]; // slope x plus
             del1y = drum[x][y] - drum[x][y-1]; // slope y minus
             del2y = drum[x][y+1] - drum[x][y]; // slope y plus
             curv = (del2x-del1x)+(del2y-del1y); // curvature in 2D
             drumv[x][y] += speedOsound*curv;     // acceleration => velocity
        }
    }
//  now update whole drum surface        
   for (int x=0; x < xy; x++)  {
        for (int y=0; y < xy; y++)  {
            drum[x][y] = damp*drum[x][y] + drumv[x][y];
        }
    }
}

void pluck(int x, int y)  {
    if (x < 2) x = 2;
    if (y < 2) y = 2;
    if (x > xy-3) x = xy-3;
    if (y > xy-3) y = xy-3;
//  gaussian  10.0, 3.6787944, 1.3533528, 0.1831564
//  bump:     main  one out    diagonal          
     drum[x][y] = 10.0;
     drum[x-1][y] = 3.6787944;  
     drum[x+1][y] = 3.6787944;  
     drum[x][y-1] = 3.6787944;  
     drum[x][y+1] = 3.6787944;
     drum[x-1][y-1] = 1.3533528;
     drum[x+1][y-1] = 1.3533528;
     drum[x-1][y+1] = 1.3533528;
     drum[x+1][y+1] = 1.3533528;
}

void keyPressed()  {
    if (key == '1') pluck(xy/2,xy/2);
    else if (key == '2') pluck(xy/3,xy/3);
    else if (key == '3') pluck(xy/4,xy/4);
    else if (key == '4') pluck(xy/7,xy/7);
    else if (key == '5') pluck(xy/2,xy/3);
    else if (key == '6') pluck(xy/3,3*xy/4);
    else if (key == '7') pluck(3*xy/4,xy/5);
    else if (key == '8') pluck(xy/4,3*xy/7);
    else if (key == '9') pluck(xy/2,xy/6);
    else if (key == 'r') {
      randHit = 1;
      int x = 2+int(random(xy-3));
      int y = 2+int(random(xy-3));
      pluck(x,y);
    }
    else if (key == 's') randHit = 0;
    else if (key == '0') clearDrum();
}

void clearDrum()  {
     for (int x=0; x < xy; x++)  {
        for (int y=0; y < xy; y++)  {
          drum[x][y] = 0.0;          
          drumv[x][y] = 0.0;
        }
     }
}