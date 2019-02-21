//  Simple rotating sine wave generator
//    by Perry R. Cook, Summer 2015
//   Doesn't do much but show how a point on a circle
//   sweeps out a sine wave in height, as the circle rotates
//   PS:  The left-right displacement would sweep out a cosine.

float xscale,xoffs,yoffs,yscale;
float mx = 50;
float X,Y,R = 0.95,Theta=0.0,del=0.1;
float pos[] = new float[1500];

boolean running = false;
boolean decay = false;

void setup() {
//   size(1920, 800); // for large-screen experience!!
   size(600, 300);
  yoffs = height/2;
  xoffs = yoffs;
  yscale = yoffs*0.95;
  xscale = 1.1;
  //center shape in window
  noStroke();
  frameRate(30);
}

void draw() {
  fill(0);   stroke(0);
  rect(0,0,width, height);
  drawSystem();
  drawPosGraph();
// Instructions, key controls:
  PFont f2 = createFont("Courier",12,true);
  textFont(f2);
  text("Key Controls:  <sp> = One tick forward in time",0,10);
  text("                'r' = run    's' = stop", 0,25);
  text("                'd' = decay (on/off)  '1' = setRadius=1",0,40);
}

void drawPosGraph()  {
   float ly = yoffs-pos[1499];
   stroke(255);
   line(xoffs/2+X,yoffs-Y,yscale,yoffs-Y);
   for (int x = 1499; x > 0; x--)  {
     float y = yoffs-pos[x-1];
     line(xscale*x+yscale,ly,xscale*x+yscale-1,y);
     ly = y;
     pos[x] = pos[x-1];
   }
   pos[0] = Y;
}   

void drawSystem()  {
  stroke(128);
  ellipse(xoffs/2,yoffs,yscale,yscale);
  ellipse(xoffs/2,yoffs,yscale-1,yscale-1);
  if (running) Theta += del;
  if (decay) R *= 0.99;
  X = R*yscale*0.5*cos(Theta); // x coordinate of dot
  Y = R*yscale*0.5*sin(Theta); // y coordinate of dot
  stroke(255);
  fill(255);
  ellipse(xoffs/2+X,yoffs-Y,6,6);
  ellipse(xoffs/2,yoffs,4,4);
  stroke(128);
//  line(50+X,yoffs-Y,100,yoffs-Y);  
}

void keyPressed()  {
    if (key == '0') clear();
    if (key == ' ') Theta += del;
    if (key == 'r') running = true;
    if (key == 's') running = false;
    if (key == 'd') decay = !decay;
    if (key == '1') R = 0.95;
}