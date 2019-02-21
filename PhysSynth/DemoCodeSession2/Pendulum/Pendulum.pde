//    Pendulum system solution display
//    by Perry R. Cook, Summer 2015
//   Shows how this system oscillates in sine wave pattern
//   Key commands/controls displayed on screen
//   NOTE:  Here we're displaying the solution to the
//      differential equation, not solving it in code.
//      We could, of course, solve it from forces, etc. though.

float xscale,xoffs;
float mx = 50;
float X,Y,R = 0.95,Theta=0.0,del=0.1;
float g,L,baseL;
float pos[] = new float[600];
float mass = 1.0;
boolean running = false;
float damp = 1.0;

void setup() {
  size(320, 680);
  xoffs = width/2;
  xscale = xoffs*0.95;
  L = 0.97*height/2;
  baseL = L;
  g = 1.0;
  //center shape in window
  noStroke();
  frameRate(30);
}

void draw() {
  fill(0);   stroke(0);
  rect(0,0,width, height);
  line(0,0,width,0); // weird fixup for lines
  line(0,0,0,height);
  drawSystem();
  drawPosGraph();
  stroke(255);fill(255);
  PFont f2 = createFont("Courier",18,true);
  textFont(f2);
  text("KeyCommands:  <space>displace",0,20);
  text("<g/G>ravity=",10,40);
  text(g,width-80,40);  
  text("<d/D>amp=",10,60);
  text(1.0-damp,width-80,60);  
  text("<m/M>ass=",10,80);
  text(mass,width-80,80);
  text("l/Length",10,100);
  text("<r>un",10,120);
  text("<s>top",10,140);
}

void drawPosGraph()  {
   float lx = xoffs-pos[599];
   stroke(255);
   for (int y = 599; y > 0; y--)  {
     float x = xoffs-pos[y-1];
     line(x,y+L,lx,y+L+1);
     lx = x;
     pos[y] = pos[y-1];
   }
   pos[0] = -X;
}   

void drawSystem()  {
  stroke(255);
  if (running) {
    Theta += del;
    R *= damp;
  }
  X = 0.4*width*R*cos(Theta/sqrt(L/baseL/g));
  Y = sqrt(L*L - X*X);
  line(width/2,0,width/2+X,Y);
  ellipse(width/2+X,Y,8*mass,8*mass);
  line(width/2+X,Y,width/2+X,Y+g*20);
  line(width/2+X-5,Y+g*20-10,width/2+X,Y+g*20);
  line(width/2+X+5,Y+g*20-10,width/2+X,Y+g*20);
}

void keyPressed()  {
    if (key == '0') clear();
    if (key == ' ') {
      R = 0.95*L/baseL;
      Theta = 0.0;
    }
    if (key == 'r') running = true;
    if (key == 's') running = false;
    if (key == 'D') damp -= 0.002;
    if (key == 'd') {
      damp += 0.002;
      if (damp > 1.0) damp = 1.0;
    }
    if (key == 'l') {
      L /= 2.0;
      if (L/baseL < 0.125) L *= 2.0;
      else R *= 0.5;
    }
    if (key == 'L') {
      L *= 2.0;
      if (L > height) L /= 2.0;
      else R /= 0.5;
    }
    if (key == 'g') {
      g /= 2.0;
    }
    if (key == 'G') {
      g *= 2.0;
    }
    if (key == 'm')  {
        mass -= 1.0;
        if (mass < 1.0) mass = 1.0;
    }
    if (key == 'M')  {
        mass += 1.0;
    }
}

void clear()  {
   R = 0.0;
}