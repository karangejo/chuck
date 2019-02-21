// D'Alembert solution of open/closed tube
//   Perry R. Cook, 2015

int nump = 80;
float xscale,yoffs,yscale,loffs,roffs;
float damp = 0.999;
float tube[] = new float[nump];
float tubel[] = new float[nump];
float tuber[] = new float[nump];
float basefreq = 1.0;
float time;

int running = 0;

void setup() {
   size(640, 480);
   xscale = width/(nump*1.0);
   yoffs = height/4;
   yscale = 0.95*yoffs;
   loffs = height/2;
   roffs = loffs+yoffs;
   //center shape in window
   noStroke();
   frameRate(30);
}

void draw() {
   fill(0);
   rect(0,0,width, height);
   stroke(0);
   line(0,0,width,0); // weird fixup for lines
   line(0,0,0,height);
   if (running==1) tick();
   drawTube();  
   fill(255);
   text("Key Commands:  1-0 = pluck position",20,height-40);
   text("  <space>=tick in time  r=run -=stop",20,height-20);
}

void drawTube()  {
   float ly = yoffs;
   float ll = loffs;
   float lr = roffs;
   stroke(255);
   for (int x=0; x < nump; x++)  {
        tube[x] = tubel[x] + tuber[x];
        float y  = yoffs - 0.5*yscale*tube[x];
        float yl = loffs - 0.5*yscale*tubel[x];
        float yr = roffs - 0.5*yscale*tuber[x];
        line((x-1)*xscale,ly,x*xscale,y);
        line((x-1)*xscale,ll,x*xscale,yl);
        line((x-1)*xscale,lr,x*xscale,yr);
        ly = y;
        ll = yl;
        lr = yr;
    }
   fill(255);
   text("Pressure = sum",20,yoffs+20);    
   text("Left going",20,loffs+20);    
   text("Right going",20,roffs+20);    
}

void keyPressed()  {
    if (key == '0') clear();
    if (key == 'p') pulse();
    if (key == ' ') tick();
    if (key == 'r') running = 1;
    if (key == 's') running = 0;
}

void pulse()  {
   clear();
   tuber[1] = 1.0;
}

void tick()  {
   float temp = tubel[0];
   for (int x = 0; x < nump-1; x++)  {
      tubel[x] = tubel[x+1];
   }
   tubel[nump-1] = tuber[nump-1];    // ONLY CHANGE HERE
   for (int x = nump-1; x > 0; x--)  {
      tuber[x] = tuber[x-1];
   }
   tuber[0] = -temp;
}
    
void clear()  {
  for (int x = 0; x < nump; x++)  {
    tube[x] = 0.0;
    tubel[x] = 0.0;
    tuber[x] = 0.0;
  }
}