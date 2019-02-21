/**
  * AMDF/AUTOCORR, by Perry R. Cook, July 2015
  * From the Minim demos.  Note:  You might need
  *   to go get and import Minim
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
*/

 import ddf.minim.*;
 Minim       minim;
 AudioInput in;

boolean doZCs = false;
boolean doAMDF = false;
boolean doACORR = false;
boolean doHYST = false;

int BUFFSIZE = 2400;  // you can play with this
float[] wave = new float[BUFFSIZE];
float[] amdf = new float[BUFFSIZE];
float[] autocorr = new float[BUFFSIZE];

int TEXTX = 450;

float xwoffs,ywoffs,xscale,yscale;
float AXOFF;
float amyoffs,amyscale,acoffs;

int STROKE = 255;  // color for lines
int HYST = 170;    // grey color for hysteresis lines
int BACKGROUND = 0; // background color

boolean running = true;

void setup()
{
//  size(1920, 1080, P3D); // for large-screen experience
  size(1000, 500, P3D);
  frameRate(5);
  xscale = 1.0*width/BUFFSIZE;
  yscale = 1.0*height;
  amyoffs = height/2;
  acoffs = 3*height/4;
  amyscale = height/10;
  ywoffs = height/5;
  AXOFF = width / 10;
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO,BUFFSIZE);
}

void draw()
{
  background(BACKGROUND);
  stroke(STROKE);
  
  float max = -10000.0;
  float min = 10000.0;
  float rms = 0.0;
  float ZCs = 0.0;
  boolean hystDown = true; // state variable for hysteresis
  
// Instructions, key controls:
  PFont f2 = createFont("Courier",18,true);
  textFont(f2);
  text("Key Controls:",3*width/4,height-90);
  text("   z = Zero Crossings",3*width/4,height-75);
  text("   h = ZC + Hysteresis",3*width/4,height-60);
  text("   a = AMDF",3*width/4,height-45);
  text("   c = AutoCorrelation",3*width/4,height-30);
  text("  <sp> = Freeze/Restart",3*width/4,height-15);


// draw the waveforms, calculate power
  if (running)   {
    for(int i = 0; i < BUFFSIZE - 1; i++)   {
      wave[i] = in.mix.get(i);
    }
  }
  for(int i = 0; i < BUFFSIZE - 1; i++)   {
      rms += wave[i]*wave[i];
      if (wave[i] > max) max = wave[i];
      if (wave[i] < min) min = wave[i];
  }
  rms = sqrt(rms);
  
  for(int i = 1; i < BUFFSIZE - 1; i++)   {
    line((i-1)*xscale, ywoffs-wave[i-1]*yscale,i*xscale,ywoffs-wave[i]*yscale);

    if (doZCs)  {
      if (doHYST) {
        if (wave[i] < (min*0.7)) {
            hystDown = true;
        }
        if (hystDown) {
           if (wave[i-1] <= max*0.6 && wave[i] > max*0.6)  {
              ZCs += 1;
              ellipse(i*xscale,ywoffs-wave[i-1]*yscale,5,5);
              hystDown = false;
           }  
        }
      }
      else { 
        if (wave[i-1] <= 0.0 && wave[i] > 0.0) {
          ZCs += 1;
          ellipse(i*xscale,ywoffs,5,5);
        }
      }
    }
  }
  
    stroke(STROKE);
    line(0,ywoffs,width,ywoffs);

  if (doHYST)  {
     stroke(HYST);  // draw hysteresis line
     line(0,ywoffs-max*0.6*yscale,width,ywoffs-max*0.6*yscale);
     stroke(STROKE);
     line(0,ywoffs-max*yscale,width,ywoffs-max*yscale);
     line(0,ywoffs-min*yscale,width,ywoffs-min*yscale);
  }
  
  float amdfMax = -10000.0;
  int amdfMaxLoc = 0;
  int amdfMinLoc;
  amdf[0] = 0.0;
  autocorr[0] = rms*rms;
  for (int j = 1; j < BUFFSIZE/2; j++)  {
     amdf[j] = 0.0;
     autocorr[j] = 0.0;
     for (int i = 0; i < BUFFSIZE - j; i++)  {
        amdf[j] += abs(wave[i] - wave[i+j]);
        autocorr[j] += wave[i]*wave[i+j];
     }
     if (amdf[j] > amdfMax) {
       amdfMax = amdf[j];
       amdfMaxLoc = j;
     }
  }
  autocorr[0] = 1.0;
  for (int j = 1; j < BUFFSIZE/2; j++)  {
    amdf[j] /= amdfMax;
    if (doAMDF) line(AXOFF+(j-1)*xscale, amyoffs-amdf[j-1]*amyscale,AXOFF+j*xscale,amyoffs-amdf[j]*amyscale);
    autocorr[j] = autocorr[j] / rms / rms;
    if (doACORR) line(AXOFF+(j-1)*xscale, acoffs-autocorr[j-1]*amyscale,AXOFF+j*xscale,acoffs-autocorr[j]*amyscale);
  }

  int amdFound = 0;
  int amdPt = amdfMaxLoc;
  amdfMinLoc = amdfMaxLoc;
  while (amdFound == 0 && amdPt < BUFFSIZE/2)  { 
    if ((amdf[amdPt] < 0.25) && (amdf[amdPt] < amdf[amdPt+1])) {
      amdFound = 1;
      amdfMinLoc = amdPt;
    }
    else amdPt++;
  }

  if (doAMDF || doACORR) line(AXOFF,amyoffs-amyscale,AXOFF,acoffs+amyscale);
  if (doACORR)  {
      line(AXOFF,acoffs,AXOFF+width/2,acoffs);
      text("AutoCorr:",10,acoffs-50);
  }
  if (doAMDF) {
    line(AXOFF,amyoffs,AXOFF+width/2,amyoffs);
    text("AMDF:",10,amyoffs-50);
    line(AXOFF+amdfMinLoc*xscale,amyoffs-50,AXOFF+amdfMinLoc*xscale,amyoffs+10);
    String m = "AMDFMin="+amdfMinLoc;
    text(m,amdfMinLoc*xscale,amyoffs+15);
    m = "FreqEst="+(in.sampleRate()/amdfMinLoc);
    text(m,amdfMinLoc*xscale,amyoffs+30);
  }
    
  PFont f = createFont("Arial",14,true);
  textFont(f);
  String m = "RMS= "+rms;
  text(m,TEXTX,40);
  if (doZCs)  {
    ZCs = ZCs * in.sampleRate() / in.bufferSize();
    m = "ZXings=    "+ZCs;
    text(m,TEXTX,60);
  }
  
  m = "Max: "+max;
  text(m,0,ywoffs-max*yscale-10);  
  m = "Min: "+min;
  text(m,0,ywoffs-min*yscale+20);  
}

void keyPressed()  {
    if (key == 'z') doZCs = !doZCs;
    if (key == 'a') doAMDF = !doAMDF;
    if (key == 'c') doACORR = !doACORR;
    if (key == 'h') doHYST = !doHYST;
    if (key == ' ') running = !running;
}