// D'Alembert solution of string (or any 1D wave)
//   Perry R. Cook, 2015

int nump = 160;
float xscale,yoffs,yscale,loffs,roffs;
float damp = 0.999;
float string[] = new float[nump];
float stringl[] = new float[nump];
float stringr[] = new float[nump];
float basefreq = 1.0;
float time;
int running = 0;

void setup() {
//   size(1920, 1080);
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
   drawString();
   fill(255);
   text("Key Commands:  1-0 = pluck position",20,20);
   text("  p=pulse   t=triangle   s=square   h=hammer",20,40);
   text("  <space>=tick in time  r=run -=stop",20,height-20);
}

void drawString()  {
   float ly = yoffs;
   float ll = loffs;
   float lr = roffs;
   stroke(255);
   for (int x=0; x < nump; x++)  {
        string[x] = stringl[x] + stringr[x];
        float y  = yoffs - yscale*string[x];
        float yl = loffs - 0.5*yscale*stringl[x];
        float yr = roffs - 0.5*yscale*stringr[x];
        line((x-1)*xscale,ly,x*xscale,y);
        line((x-1)*xscale,ll,x*xscale,yl);
        line((x-1)*xscale,lr,x*xscale,yr);
        ly = y;
        ll = yl;
        lr = yr;
    }
   fill(255);
   text("Shape = sum",20,yoffs+20);    
   text("Left going",20,loffs+20);    
   text("Right going",20,roffs+20);    
}

void keyPressed()  {
    if (key == '0') clear();
    if (key == 't') triangle();
    if (key == 's') square();
    if (key == 'h') hammer();
    if (key == '1') ramp(nump/20);
    if (key == '2') ramp(nump/14);
    if (key == '3') ramp(nump/8);
    if (key == '4') ramp(nump/6);
    if (key == '5') ramp(nump/5);
    if (key == '6') ramp(nump/4);
    if (key == '7') ramp(2*nump/5);
    if (key == '8') ramp(nump/2);
    if (key == 'p') pulse();
    if (key == ' ') tick();
    if (key == 'r') running = 1;
    if (key == '-') running = 0;
}

void pulse()  {
   clear();
   for (int i = 0; i < 16; i++)  {
      float val = (float)(1.0-Math.cos(PI*i/8));
      stringl[nump/2-8+i] = 0.25*val;
      stringr[nump/2-8+i] = 0.25*val;
   }
}

void hammer()  {
  pulse();
  for (int i = 0; i < nump; i++)  {
     stringr[i] = -stringl[i];
  }
}

void tick()  {
   float temp = stringl[0];
   for (int x = 0; x < nump-1; x++)  {
      stringl[x] = stringl[x+1];
   }
   stringl[nump-1] = -stringr[nump-1];
   for (int x = nump-1; x > 0; x--)  {
      stringr[x] = stringr[x-1];
   }
   stringr[0] = -temp;
}
    
void clear()  {
  for (int x = 0; x < nump; x++)  {
    string[x] = 0.0;
    stringl[x] = 0.0;
    stringr[x] = 0.0;
  }
}

void triangle()  {
  clear();
  for (int x = 1; x < nump/2; x++)  {
    stringl[x] = 1.0*x/nump;
    stringl[nump-x] = stringl[x];
    stringr[x] = stringl[x];
    stringr[nump-x] = stringl[x];
  }
  stringl[nump/2] = 0.5;
  stringr[nump/2] = 0.5;
}

void square()  {
  clear();
  for (int x = 1; x < nump-1; x++)  {
     stringl[x] = 0.5;
     stringr[x] = 0.5;
  }
}

void ramp(int pos)  {
   clear();
   float delup = 0.5 / float(pos);
   float deldown = 0.5/(nump-pos-1);
   float val = 0.0;
   for (int x = 0; x < pos; x++)  {
      stringl[x] = val;
      stringr[x] = val;
      val += delup;
   }
   val -= deldown;
   for (int x = pos; x < nump-1; x++)  {
      stringl[x] = val;
      stringr[x] = val;
      val -= deldown;
   }
}