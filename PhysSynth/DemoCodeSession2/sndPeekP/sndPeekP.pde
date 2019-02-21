/**
  * sndpeekLP (sndpeek for Processing), 
  *      by Perry R. Cook, April 2014
  * From the Minim FFT demo.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioInput in;
FFT         fft;

int MAX_HIST = 24;
float[][] history;

int TEXTX = 20;
int TEXTY = 160;

int linp = 23, loup = 0;
float[] sdel;

float left = 0.0;
float rite = 0.0;
float lleft = 975;
float lrite = 75;

float zoom = 2.0; // x (frequency) axis scaling

boolean wuterfall = true;
int SPECTONLY = 50;

void setup()
{
  //  We should do more about auto-scaling here (like anything)
  size(1024, 640, P3D);
//  size(1280, 800, P3D);
//  size(600, 400, P3D);  // this cuts off some
  
  minim = new Minim(this);
  
   in = minim.getLineIn(Minim.STEREO,2048);
   fft = new FFT( in.bufferSize(), in.sampleRate() );
   fft.window(fft.BLACKMAN);

   history = new float[MAX_HIST][fft.specSize()];
   sdel = new float[1024];
}

void draw()
{
  background(0);
  stroke(255);
  
  text("KeyCommands:",width-250,150);
  text("     w = waterFall on/off",width-250,170);
  text("     s/S = spectrum Zoom",width-250,190);
  float mag = 0.0;
  float max = 0.0;
  int maxbin = 0;
  float rms = 0.0;
  float cen = 0.0;
  
  float ster = 0.0;

  float ZCs = 0.0;
  
// draw the waveforms, draw lissajous, count zero crossings, calculate power
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    left = in.left.get(i);
    rite = sdel[loup++];
    sdel[linp++] = in.right.get(i);
    loup = loup % 1024;
    linp = linp % 1024;
    

    line( i*0.9, 50 + lleft*50, (i+1)*0.9, 50 + left*50 );
    line( i*0.9, 100 + lrite*50, (i+1)*0.9, 100 + rite*50 );
    
    line(975+lleft*100,75-lrite*100,975+left*100,75-rite*100);
    
    lleft = left;
    lrite = rite;
    
    rms += in.mix.get(i)*in.mix.get(i);
    
    if (in.mix.get(i) <= 0.0 && in.mix.get(i+1) > 0.0) ZCs += 1;
  }
  rms = sqrt(rms);

  PFont f = createFont("Arial",24,true);
  String m = "RMSEnrgy="+rms;
  text(m,TEXTX,TEXTY);
  ZCs = ZCs * in.sampleRate() / in.bufferSize();
  m = "ZXings=    "+ZCs;
  text(m,TEXTX,TEXTY+16);
  
  // perform a forward FFT on the input samples,
  // which contains the mix of both the left and right channels

  fft.forward( in.mix );
  
// calculate log magnitude spectrum, percolate old ones
  for(int i = 0; i < fft.specSize(); i++)
  {
    mag =  fft.getBand(i)*20; // arbitrary here
    if (mag<1.0) mag = 1.0;
    mag = 40*log(mag);        // here too
    if (mag > max) {
      max = mag;
      maxbin = i;
    }
    for (int j = MAX_HIST-1; j > 0; j--)  {
      history[j][i] = history[j-1][i];
    }
    history[0][i] = mag;
  }
//  print("Max = "+max+"  at:"+maxbin+"\n");

  int offset = 0;
  if (!wuterfall) offset = SPECTONLY;
  
  line(offset+zoom*maxbin,height-15-history[0][maxbin],offset+zoom*maxbin,height);
  m = "Max: "+(in.sampleRate()*maxbin/in.bufferSize());
  text(m,offset+zoom*maxbin-40,height-15);
  
// draw waterfall spectrum with fading intensity
  int j = 0;
  stroke(255);
  for (int i = 0; i < fft.specSize()-1; i++)  {
      line( zoom*i+offset, height-40-history[j][i]-offset, zoom*(i+1)+offset, height - 40 - history[j][i+1]-offset );
      line( zoom*i+offset+1, height-40-history[j][i]-offset, zoom*(i+1)+offset+1, height - 40 - history[j][i+1]-offset );
      line( zoom*i+offset, height-40-history[j][i]-offset+1, zoom*(i+1)+offset, height - 40 - history[j][i+1]-offset+1 );
  }
  if (wuterfall)  {
    for (j = 1; j < MAX_HIST; j++)  {
        stroke(255-j*10);
        offset = j*15;
        for (int i = 0; i < fft.specSize()-1; i++)  {
           line( zoom*i+offset, height-40-history[j][i]-offset, zoom*(i+1)+offset, height - 40 - history[j][i+1]-offset );
           line( zoom*i+offset+1, height-40-history[j][i]-offset, zoom*(i+1)+offset+1, height - 40 - history[j][i+1]-offset );
           line( zoom*i+offset, height-40-history[j][i]-offset+1, zoom*(i+1)+offset, height - 40 - history[j][i+1]-offset+1 );
        }
    }
  }

  int sumi = 0;
  float sum = 0.0;
  
  for (int i = 0; i < fft.specSize(); i++)  {
    cen += fft.getBand(i)*i;
    sum += fft.getBand(i);
    sumi += i;
  }
  cen = 44100.0*(cen/sumi)/fft.specSize()/2.0;
  m = "Centroid=  "+cen;
  text(m,TEXTX,TEXTY+32);
  
  float roll = 0.0;
  float roll60 = 0.0;
  float roll75 = 0.0;
  float roll90 = 0.0;
  
  for (int i = 0; i < fft.specSize(); i++)  {
    roll += fft.getBand(i);
    if (roll < sum*0.60) roll60 = i;
    if (roll < sum*0.75) roll75 = i;
    if (roll < sum*0.90) roll90 = i;
  }
  roll60 = 44100*roll60/fft.specSize()/2.0;
  m = "60%Rolloff="+roll60;
  text(m,TEXTX,TEXTY+48);
  roll75 = 44100*roll75/fft.specSize()/2.0;
  m = "75%Rolloff="+roll75;
  text(m,TEXTX,TEXTY+64);
  roll90 = 44100*roll90/fft.specSize()/2.0;
  m = "90%Rolloff="+roll90;
  text(m,TEXTX,TEXTY+80);
}

void keyPressed()  {
    if (key == 'w') wuterfall = !wuterfall;
    if (key == 's') zoom = 0.5*zoom;
    if (key == 'S') zoom = 2.0*zoom;
}