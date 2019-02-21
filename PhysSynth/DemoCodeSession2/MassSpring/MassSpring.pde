//  Mass/Spring/Damper system simulation
//    by Perry R. Cook, Summer 2015
//   Shows how this system oscillates in sine wave pattern
//   Key commands/controls displayed on screen

float xscale,yoffs,yscale;
float mx = 50;
float Y[] = new float[3];
float max = 80;
float basey = 200;
float time;
float pos[] = new float[580];

float tau,omega,T,coeff1,coeff2;

float mass = 10.0;
float spring = 1.0;
float damp = 0.1; // This controls loss (decay)
int OVERSAMP = 100;

boolean running = false;

void setup() {
  size(640, 320);
  yoffs = height/2;
  yscale = 0.5*yoffs;
  xscale = 1.1;
  //center shape in window
  noStroke();
  frameRate(30);
  computeCoeffs();
}

void computeCoeffs()  {
    tau = damp / 2.0 / mass;
    omega = sqrt((spring/mass) - (tau*tau));
    T = 1.0 / OVERSAMP;   //  sampling period for simulation
    float temp =  (mass + (T*damp) + (T*T*spring));  //  Coefficient denominator
    coeff1 = ((2.0*mass) + (T*damp)) / temp;
    coeff2 = - mass / temp;
//    print(tau, " ", omega, " ", temp, " ", coeff1,"  ",coeff2,"\n");
}

void draw() {
  fill(0);   stroke(0);
  rect(0,0,width, height);
  line(0,0,width,0); // weird fixup for lines
  line(0,0,0,height);
  if (running) doPhysics();
  drawSystem();
  drawPosGraph();
}

void drawPosGraph()  {
   float ly = yoffs-pos[579];
   stroke(255);
   for (int x = 579; x > 0; x--)  {
     float y = yoffs+50-pos[x-1];
     line(xscale*x+50,ly,xscale*x+49,y);
     ly = y;
     pos[x] = pos[x-1];
   }
   pos[0] = Y[0];
}   

void doPhysics()  {
//   Y[0] = Y[1]*1.9 - Y[2]*damp*damp;
   for (int i=0; i < OVERSAMP; i++)  {
       Y[0] = coeff1*Y[1] + coeff2*Y[2];
        Y[2] = Y[1];
       Y[1] = Y[0];
   }
   //   max*sin(time);
}

void drawSystem()  {
   float ploty = basey - Y[0];
   stroke(160); fill(160);
   ellipse(mx,height-20,54,20);
   line(mx-28,height-20,mx-28,height-200);
   line(mx-27,height-20,mx-27,height-200);
   line(mx+28,height-20,mx+28,height-200);
   line(mx+27,height-20,mx+27,height-200);
   fill(0);
   text("damp/r=",mx-24,height-18);
   fill(255);
   text("Key Commands:   k/K = spring constant less/more",100,20);
   text("                m/M = mass less/more",100,35);
   text("                d/D = damping less/more",100,50);
   text("                <space> = displace downward",100,65);
   text(damp,mx-20,height-6);
   stroke(200); fill(200);
   ellipse(mx,ploty+20,48,20);
   rect(mx-24,ploty-20,48,40);
   stroke(128); fill(128);
   ellipse(mx,ploty-20,48,20);
   stroke(255); fill(255);
   ellipse(mx,ploty+10,3,3);
   float dely = (ploty-20) / 20;
   float posy = ploty-20;
   fill(255);
   text("spring constant k/K = ",int(mx+20),int(ploty/2));
   text(spring,int(mx+150),int(ploty/2));
   fill(0);
   text("mass\nm/M =",int(mx-18),int(ploty-2));
   text(mass,int(mx-26),int(ploty+25));
   stroke(255); fill(0);
   for (int i = 0; i < 20; i++) {
      ellipse(mx,posy,25,10);
      posy -= dely;
   } 
}

void keyPressed()  {
    if (key == '0') clear();
    if (key == ' ') { Y[1] = Y[2] = -80; Y[0] = -80; }
    if (key == 'M') mass *= 2.0;
    if (key == 'm') mass /= 2.0;
    if (key == 'K') spring *= 2.0;
    if (key == 'k') spring /= 2.0;
    if (key == 'D') damp *= 2.0;
    if (key == 'd') damp /= 2.0;
    if (key == 'r') running = true;
    if (key == 's') running = false;
    computeCoeffs();
//    if (key == ' ') { my1 = my2 = -100; my = -100; }
}

void clear()  {
  Y[0] = Y[1] = Y[2] = 0.0;
  time = 0.0;
}