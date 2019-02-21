// sndview.c
// Perry's horrible non-secret for almost 30 years now
// (c) Perry R. Cook, 1987-2015 (and beyond...)
// You're free to use this any way you like (except for evil)
//   Some system dependent things in here, but various makefiles:
//   makeOSX, makeLINUX, makeWindows32, should take care of it
// NOTE:  For playback (spacebar) of visible sound to work, you
//        have to have a version of playstk (play from STK) compiled
//        and placed in a directory in your path (or in this directory).
//        Alternatively, you could try afplay (but it broke on Yosemite)
//        SoX "play" function, or other command line sound player.
// Graphics is OpenGL/Glut, which is deprecated, but still used
// Use some variant of these, depending on architecture and OS
//    link with glut32.lib or whatever (Frameworks on MacOSX) 
//    or just use -lglut in compiler/linker line
#ifdef OSX
     // Use these includes for Mac OS X:
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <GLUT/glut.h>
#else
     // Use these includes for LINUX and Windoze 
     // (NOTE: Windoze users need some .dll's)
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#endif

// June08: Hacked this for intel arch.  Had to do some 
// byte-swap fixing so it's possible I broke it for m@tr@la 
// machines, so if you need it for your NeXT, SGI, or ppcMac, 
// then change the define from LITTLEENDIAN to BIGENDIAN, and
// hold on to your hat.  Things might work fine, but probly not.
// Rules of thumb: if data looks funny, try with -s or -b
// 
// August08:  Added some semblance of 24 bit file support
//	Check for anywhere HACKOLA or BIT24 appear.
// October08: Special Election Edition, All About Change!!
//    Hacked various things to make them more awesome (size, etc).
// June 2012, Lion!!  and more format hacking
// Summer 2015: Added some auto peak picking (keys 1-9)
//              Also added color toggle selection (B/W vs G/B)
//              Also prints out key commands into shell/terminal
// Nov 2015: Added window display, playstk support, fixes.
//
//   #define BIGENDIAN
#define LITTLEENDIAN

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
//  #include <conio.h>       // for getch() function on some compilers
//  #include <malloc.h>	    // for malloc on some compilers

#include <math.h>

char file_name[4096]; 

// HACKOLA: Changed some of these to better match word sizes, check all
#define RAW 0
#define WAV 1
#define SND 2
#define BIT24 3
#define FLT 4
#define AIF 5 /* as yet unsupported, use swap, byte, 16bit, 24Bit flags */
#define BYTE 1
#define WORD 2
#define MIN_WIN 16
#define MAX_WIN 524288  // you can make this as big as you like, but...

#define MAX_WIN_TYPE 5

int Size=64;
int Beginning=0;
int SkipBytes = 0;
int WinType=3;
int FileType = 0;	// RAW, WAV, SND, or BIT24
int SwapMode=0;	// 0 = don't swap
int WordSize=0;
long HdrLength=0;
long Srate = -1;
#ifdef OSX
    int OSRATE = 44100;   // default playback rate for Mac OSX
#else
    int OSRATE = 48000;  // default playback rate for LINUX (and some Windows)
#endif
short Chans = 1;  // we only deal with mono
long SrateOverride = -1;
long BytesPerSamp;
long Location=0;
long CursorPos=0;
float FreqScale=0;
FILE *MyFile,*TempFile;
int CalcSpectrum=0;
int ByteMode=0;
long MySize=0;
float WidthScale = 1.0;
float HeightScale = 1.0;

int newWindow = 0;

float drawC[4] = {0,1,0,0};
float clearC[4] = {0,0,0,0};

short data[MAX_WIN*2];			// moved these to here so we
float fdata[MAX_WIN*2];			// can see them for playback
float tempdata[MAX_WIN*2];		//      and other stuff

void swaplong(long *along)	{
    unsigned char *temp,temp2;
    temp = (unsigned char *) along;
    temp2 = temp[0];
    temp[0] = temp[3];
    temp[3] = temp2;
    temp2 = temp[1];
    temp[1] = temp[2];
    temp[2] = temp2;
}

void swapshort(short *ashort)	{
    unsigned char *temp,temp2;
    temp = (unsigned char *) ashort;
    temp2 = temp[0];
    temp[0] = temp[1];
    temp[1] = temp2;
}    

void Redraw(void);

int SndView(int InitLocation, int InitSize, char *InitFileName)
{
   long sizeCount = 0;
   int k = 1;
   char bdata[1024];		// NEWHACK here, check it
   Size = InitSize;
   FreqScale = 1.0;
//   Location = InitLocation;
   CalcSpectrum = 1;
//   ByteMode = InitByteMode;
//   SwapMode = InitSwapMode;

   if (WordSize==BYTE)	{
       while(k)	{
	   k = fread(&bdata,BYTE,1024,MyFile);	// NEWHACK here, check it
	   sizeCount += k;
       }
   }
   else	if (WordSize==WORD)	{
       while(k)	{
	   k = fread(&bdata,WORD,512,MyFile);	// NEWHACK here, check this
	   sizeCount += k;
       }
   }
   else	if (WordSize==BIT24)	{
       while(k)	{
	   k = fread(&bdata,BIT24,256,MyFile);	// NEWHACK here, check this
	   sizeCount += k;
       }
	sizeCount = sizeCount - 2; // we do this in case things don't come out even
   }
   else	if (WordSize==FLT)	{
       while(k)	{
	   k = fread(&bdata,FLT,256,MyFile);	// NEWHACK here, check this
	   sizeCount += k;
       }
   }

	Beginning = 0;
	if (!strcmp(&file_name[strlen(InitFileName)-4],".wav"))	{ // .wav
		if (FileType==0) FileType = WAV; // if in command line, leave it
		HdrLength = 44;
		Beginning = HdrLength;	// major HACKOLA Need to research this more
		fseek(MyFile,22,0);
		fread(&Chans,2,1,MyFile);
		if (Chans > 1) {
		    printf("I really only deal with mono files!!!\n");
		    printf("Reconsider, then proceed if you must, at risk!!!\n");
		    fflush(stdout);
		}
		fseek(MyFile,24,0);
		fread(&Srate,4,1,MyFile);
		fseek(MyFile,32+SkipBytes,0);
		fread(&BytesPerSamp,2,1,MyFile);
		if (FileType==0 & BytesPerSamp==1) {
			ByteMode = 1;
			WordSize = 1;
			printf("Setting to byte mode from header info\n");
		}
		if (FileType==0 & BytesPerSamp==3)  { 
			FileType = BIT24;
			WordSize = BIT24;
			printf("Setting to 24bit mode from header info\n");
		}
#ifdef BIGENDIAN
		swaplong(&Srate);
#endif
	}
	else if (!strcmp(&file_name[strlen(InitFileName)-4],".snd"))	{ // .snd
		if (FileType == 0) FileType = SND; // if command line, leave it
		fseek(MyFile,4,0);
		fread(&HdrLength,4,1,MyFile);
		fseek(MyFile,16,0);
		fread(&Srate,4,1,MyFile);
#ifdef LITTLEENDIAN
		SwapMode = 1;
		swaplong(&HdrLength);
		swaplong(&Srate);
#endif
		Beginning = HdrLength;
        }
	else if (!strcmp(&file_name[strlen(InitFileName)-4],".au")) { // .au, same as .snd
		FileType = SND;
		fseek(MyFile,4,0);
		fread(&HdrLength,4,1,MyFile);
		fseek(MyFile,16,0);
		fread(&Srate,4,1,MyFile);
#ifdef LITTLEENDIAN
		SwapMode = 1;
		swaplong(&HdrLength);
		swaplong(&Srate);
#endif
		Beginning = HdrLength;
        }

   MySize = sizeCount;
   CursorPos = 32;
   WinType = 3;
//   Srate = -1;	// NO IDEA WHY THIS WAS HERE BEFORE

   return 1;
};

    #define PI 3.141592654782
    #define SQRT_TWO 1.414213562
    #define TWO_PI 6.283185309564

//  #define MAX_WIN 5

void rectangle(int size,float* array)
{
    //  Dummy, don't do anything
	;
}

void triangle(int size,float* array)
{
    int i;
    float w = 0.0, delta;
    delta = 2.0 / size;
    for (i=0;i<size/2;i++)  {
	array[i] *= w;
	array[size-i] *= w;
	w += delta;
    }
}

void hanning(int size,float* array)
{
    int i;
    float w,win_frq;
    win_frq = TWO_PI / size;
    for (i=0;i<size/2;i++)  {
	w = 0.5 - 0.5 * cos(i * win_frq);
	array[i] *= w;
	array[size-i] *= w;
    }
}

void hamming(int size,float* array)
{
    int i;
    float w,win_frq;
    win_frq = TWO_PI / size;
    for (i=0;i<size/2;i++)  {
        w = 0.54 - 0.46 * cos(i * win_frq);
        array[i] *= w;
        array[size-i] *= w;
    }
    return;
}

void blackman3(int size,float* array)
{
    int i;
    float w,win_frq;
    win_frq = TWO_PI / size;
    for (i=0;i<size/2;i++)  {
        w = (0.42 - 0.5 * cos(i * win_frq) + 0.08 * cos(2 * i * win_frq));
        array[size-i] *= w;
        array[i] *= w;
    }
    return;
}

void blackman4(int size,float* array)
{
    int i;
    float w,win_frq;
    win_frq = TWO_PI / size;
    for (i=0;i<size/2;i++)  {
        w = (0.35875 - 0.48829 * cos(i * win_frq) + 
                    0.14128 * cos(2 * i * win_frq) - 0.01168 * cos(3 * i * win_frq));
        array[i] *= w;
        array[size-i] *= w;
    }
    return;
}

int last_length = 0;

void fhtRX4(int powerOfFour, float *array)
{
    /*  In place Fast Hartley Transform of floating point data in array.
	Size of data array must be power of four. Lots of sets of four
	inline code statements, so it is verbose and repetitive, but fast.
	A 1024 point FHT took approximately 80 milliseconds on the NeXT 
	(that's right) computer (not for DSP 56001, just in compiled C as shown here).

	The Fast Hartley Transform algorithm was patented (now expired), 
	and is documented in the book "The Hartley Transform", by (the late) 
	Ronald N. Bracewell. This routine was converted to C from a routine
        in BASIC from that book, that routine stated:
	Copyright 1985, The Board of Trustees of Stanford University       */

    register int j=0,i=0,k=0,L=0;
    int n=0,n4=0,d1=0,d2=0,d3=0,d4=0,d5=1,d6=0,d7=0,d8=0,d9=0;
    int L1=0,L2=0,L3=0,L4=0,L5=0,L6=0,L7=0,L8=0;
    float r=0.0;
    float a1=0,a2=0,a3=0;
    float t=0.0,t1=0.0,t2 =0.0,t3=0.0,t4=0.0,t5=0.0,t6=0.0,t7=0.0,t8=0.0;
    float t9=0.0,t0=0.0;
    float c1,c2,c3,s1,s2,s3;

    n = pow(4.0 , (double) powerOfFour);
    if (n!=last_length) {
//      make_sines(n);
	last_length = n;
    }
    n4 = n / 4;
    r = SQRT_TWO;
    j = 1;
    i = 0;
    while (i<n-1)       {
	i++;
	if (i<j)        {
		t = array[j-1];
		array[j-1] = array[i-1];
		array[i-1] = t;
	}
	k = n4;
	while ((3*k)<j) {
		j -= 3 * k;
		k /= 4;
	}
	j += k;
    }
    for (i=0;i<n;i += 4) {
	t5 = array[i];
	t6 = array[i+1];
	t7 = array[i+2];
	t8 = array[i+3];
	t1 = t5 + t6;
	t2 = t5 - t6;
	t3 = t7 + t8;
	t4 = t7 - t8;
	array[i] = t1 + t3;
	array[i+1] = t1 - t3;
	array[i+2] = t2 + t4;
	array[i+3] = t2 - t4;
    }
    for (L=2;L<=powerOfFour;L++)  {
	d1 = pow(2.0 , L+L-3.0);
	d2=d1+d1;
	d3=d2+d2;
	d4=d2+d3;
	d5=d3+d3;
	for (j=0;j<n;j += d5)     {
	     t5 = array[j];
	     t6 = array[j+d2];
	     t7 = array[j+d3];
	     t8 = array[j+d4];
	     t1 = t5+t6;
	     t2 = t5-t6;
	     t3 = t7+t8;
	     t4 = t7-t8;
	     array[j] = t1 + t3;
	     array[j+d2] = t1 - t3;
	     array[j+d3] = t2 + t4;
	     array[j+d4] = t2 - t4;
	     d6 = j+d1;
	     d7 = j+d1+d2;
	     d8 = j+d1+d3;
	     d9 = j+d1+d4;
	     t1 = array[d6];
	     t2 = array[d7] * r;
	     t3 = array[d8];
	     t4 = array[d9] * r;
	     array[d6] = t1 + t2 + t3;
	     array[d7] = t1 - t3 + t4;
	     array[d8] = t1 - t2 + t3;
	     array[d9] = t1 - t3 - t4;
	     for (k=1;k<d1;k++) {
		  L1 = j + k;
		  L2 = L1 + d2;
		  L3 = L1 + d3;
		  L4 = L1 + d4;
		  L5 = j + d2 - k;
		  L6 = L5 + d2;
		  L7 = L5 + d3;
		  L8 = L5 + d4;
		  a1 = (float) k / (float) d3 * PI;
		  a2 = a1 + a1;
		  a3 = a1 + a2;
		  c1 = cos(a1);
		  c2 = cos(a2);
		  c3 = cos(a3);
		  s1 = sin(a1);
		  s2 = sin(a2);
		  s3 = sin(a3);
		  t5 = array[L2] * c1 + array[L6] * s1;
		  t6 = array[L3] * c2 + array[L7] * s2;
		  t7 = array[L4] * c3 + array[L8] * s3;
		  t8 = array[L6] * c1 - array[L2] * s1;
		  t9 = array[L7] * c2 - array[L3] * s2;
		  t0 = array[L8] * c3 - array[L4] * s3;
		  t1 = array[L5] - t9;
		  t2 = array[L5] + t9;
		  t3 = - t8 - t0;
		  t4 = t5 - t7;
		  array[L5] = t1 + t4;
		  array[L6] = t2 + t3;
		  array[L7] = t1 - t4;
		  array[L8] = t2 - t3;
		  t1 = array[L1] + t6;
		  t2 = array[L1] - t6;
		  t3 = t8 - t0;
		  t4 = t5 + t7;
		  array[L1] = t1 + t4;
		  array[L2] = t2 + t3;
		  array[L3] = t1 - t4;
		  array[L4] = t2 - t3;
	     }
	}
    }
}

// Here's some new stuff I added late summer 2008 
// to support powers of two (instead of just 4) block length

int isEven(int somePower)	{
    int i = somePower / 2;
    float f = (float) somePower / 2.0;
    if ((f-i) == 0) return 1;
    else return 0;
}

void logMag(int size, float *array, float floor, float ceiling);

void magSpectrum(int poweroftwo,float *array)	{
    int p4,size,s2,k;
    if (isEven(poweroftwo))	{
	p4 = poweroftwo/2;
	fhtRX4(p4,array);
	size = pow(4,p4);
        logMag(size,array,-90.0,32768.0*32768.0*size);
    }
    else {  // HACK to use power of four, zero pad, xform, decimate
	s2 = pow(2,poweroftwo);		// our size given power of two
	p4 = (poweroftwo / 2) + 1;	 // our next biggest power of 4
	size = pow(4,p4);		// our power of 4 size
	for (k=s2;k<size;k++)	array[k] = 0.0; // zero pad our data
	fhtRX4(p4,array);
        logMag(size,array,-90.0,32768.0*32768.0*size);
	for (k=0;k<Size/2;k++)	{
	    array[k] = array[2*k]; 	// decimate the spectrum
	}
    }
}

// Calculate log magnitude of spectrum, with reference
// floor in dB and 0dB ceiling reference level

void logMag(int size, float *array, float floor, float ceiling)
{
    int i;
    float t1=0.0,t=0.0,t2=-12;
    t2 = floor / 10.0;
    t1 = ceiling;
    array[0] = 2 * fabs(array[0]);
    if (ceiling>0.0)    {
	if (array[0] > t1)
	    t1 = array[0];
    }
    for (i=1;i<size/2;i++)      {
	t = array[i]*array[i] + array[size-i]*array[size-i];
	array[i] = t;
	if (ceiling>0.0)        {
	    if (t>t1)
	       t1 = t;
	}
    }
//    printf("%f\n",t1);
    if (t1>0.0) {
      for (i=0;i<size/2;i++)      {
	if (array[i]>0.0) {
	  t = log10(array[i]/t1);
	  if (t<t2)
	    t = t2;
	  array[i] = 1 - t/t2;
	}
	else array[i] = 0.0;
      }
    }
    else for (i=0;i<size/2;i++) array[i] = 0.0;
}

float fitParabola(float leftSample,float midSample,float rightSample)
{
    float p;
    p = (leftSample - (2 * midSample) + rightSample);
    if (p!=0.0) p = (leftSample - rightSample) / p  * 0.5;
    return p;
}

static float xscale = 1.0/320.0;
static float yscale = 1.0/240.0;

void line(int x, int y, int x2, int y2)
{	
	glBegin(GL_LINES); 
	  glVertex2f(((float) x * xscale) - 1.0, 1.0 - (float) y * yscale);
	  glVertex2f(((float) x2 * xscale) - 1.0, 1.0 - (float) y2 * yscale);
    	glEnd();
	glBegin(GL_LINES); 
	  glVertex2f(((float) x * xscale) - 1.0, 1.0 - (float) (y+1) * yscale);
	  glVertex2f(((float) x2 * xscale) - 1.0, 1.0 - (float) (y2+1) * yscale);
    	glEnd();
}

void outtext(int x, int y, char* string)	{
	glRasterPos2f(((float) x*xscale) - 1.0, 1.0 - ((float) y*yscale));
	while (*string)	{
		glutBitmapCharacter(GLUT_BITMAP_HELVETICA_10,*string++);

	}
}

void Scale(float ScaleBy)
{
   Size *= ScaleBy;
   if (Location+Size > MySize) Location = MySize - Size;
   if (Location<Beginning) Location = Beginning;
   glutPostRedisplay();
}

void ToggleSpectrum()
{
   if (CalcSpectrum==1)
       CalcSpectrum = 0;
   else
       CalcSpectrum = 1;
   glutPostRedisplay();
}

void SetLocation(long NewLocation)
{
   Location = NewLocation;
   if (Location+Size > MySize) Location = MySize - Size;
   if (Location<Beginning) Location = Beginning;
   glutPostRedisplay();
}

long YourLocation()
{
     return Location;
}

void SetSize(int NewSize)
{
   Size = NewSize;
   if (Location+Size > MySize) Location = MySize - Size;
   if (Location<Beginning) Location = Beginning;
   glutPostRedisplay();
}

void SetFreqScale(float NewScale)
{
   FreqScale = NewScale;
   glutPostRedisplay();
}

void init(void)
{
}

static long size=256;
static long loc = 0;

void display(void)	{
	glClear( GL_COLOR_BUFFER_BIT ); 
	Redraw();
	glutSwapBuffers();
}
    
//    glutWMCloseFunc(die);
void die(void)  {
//    free(amps);  
//    free(pitches);
    exit(0);
}
 
static float fscale = 1.0;
static float floc = 0.0;

void SpecialFunc(int key, int x, int y)
{
//	printf("key=%i\n",key);
	  if (key==0x1b)  {
	      exit(0);
	  }
	  else if (key==GLUT_KEY_RIGHT) 	{
	      loc += (size>>1);
	      SetLocation(loc);
	      loc = YourLocation();
	  }
	  else if (key==GLUT_KEY_LEFT)     {
	      loc -= (size>>1);
	      SetLocation(loc);
	      loc = YourLocation();
	  }
	  else if (key==GLUT_KEY_HOME) {
	      loc = 0;
	      SetLocation(loc);
	      loc = YourLocation();
	  }
	  else if (key==GLUT_KEY_END)     {
	      loc = MySize;
	      SetLocation(loc);
	      loc = YourLocation();
	  }
}

#include "waveio.h" 	// Added new for 2008 to support file snip playback 
struct soundhdr myhdr = {"RIF",88244,"WAV","fmt",16,1,1,
                                 44100,88200,2,16,"dat",88200};
int doPeaks(int which)  {
    int i,j,k, maxloc[9];
    for (i=0;i<Size/2;i++) {
	tempdata[i] = fdata[i];
    }
    for (j=0;j<9;j++)  {
	float max = -10000;
	for (i=0;i<Size/2;i++) {
	    if (tempdata[i] > max) {
		max = tempdata[i];
	   	maxloc[j] = i;
	    }
	}
	for (k=0;k<16;k++) {
	    if (maxloc[j]+k < Size/2) tempdata[maxloc[j]+k] = 0.0;
	    if (maxloc[j]-k > 0) tempdata[maxloc[j]-k] = 0.0;
	}
//	printf("Peak %i = %i\n", j, maxloc[j]);
    }
    CursorPos = maxloc[which];
    if (CursorPos >= (FreqScale * Size / 2))
                        CursorPos = FreqScale * Size / 2;
    glutPostRedisplay();
}

void KeyFunc(unsigned char key, int x, int y)
{
	char tempString[2048];
        int tsr; // temporary sample rate, for later

	  if (key==0x1b)  {
		fclose(MyFile);
	      exit(0);
	  }
	  if (key=='q')  {
		fclose(MyFile);
	      exit(0);
	  }
	  else if (key=='+')      {
	      size *= 2;
	      if (size>MAX_WIN) size = MAX_WIN;
		  else {
			  CursorPos *= 2;
				if (CursorPos >= (FreqScale * Size / 2))
					CursorPos = FreqScale * Size / 2;
		  }
	      SetSize(size);
	  }
	  else if (key=='-')      {
	      size /= 2;
	      if (size<MIN_WIN) size = MIN_WIN;
		  else CursorPos /= 2;
	      SetSize(size);
	  }
	  else if (key=='<')      {
	      fscale *= 0.5;
	      if (fscale*size<1) fscale = 1.0 / size;
	      if (floc>=1.0/fscale-1.0) floc = 1.0/fscale-1.0;
	      SetFreqScale(fscale);
	  }
	  else if (key=='>')      {
	      fscale *= 2.0;
	      if (fscale>1.0) fscale=1.0;
	      if (floc>=1.0/fscale-1.0) floc = 1.0/fscale-1.0;
	      SetFreqScale(fscale);
	  }
	  else if (key==',')      {
	      floc = floc - fscale/2;
	      if (floc < 0) floc = 0;
	      SetFreqScale(fscale);
	  }
	  else if (key=='.')      {
	     if (fscale < 1.0)	{
		floc = floc + fscale/2;
	      if (floc>=1.0/fscale-1.0) floc = 1.0/fscale-1.0;
	     }
	     SetFreqScale(fscale);
	  }
	  else if (key>48 && key<58)      {
	     doPeaks(key-49);
	  }
	  else if (key==' ')  {	// play displayed buffer from temp file
//  OK, This is sort of a mess, but might be OK for you
//     IFF, you have or make an STK playstk executable, and 
//     either have it in the directory you run sndview from,
//     or you put it in a directory that's in your search path.
#ifdef LITTLEENDIAN 
	      if (Srate > 0)  {
		tsr = Srate;
		fillheader(&myhdr,Srate);   // use actual file sample rate
	      }
	      else  {
		tsr = 22050;
		fillheader(&myhdr,22050.0); // best compromise? on sample rate
	      }
	      TempFile = opensoundout("sndviewTemp.wav",&myhdr);
	      fwrite(data,Size,2,TempFile);
//	      short tempdata = 0;	// for some players, you need
//	      int i;			// to add silence to the end
//	      for (i=0;i<Size;i++) {	// of very short files
//		fwrite(&tempdata,1,2,TempFile); // this does that
//	      }                           // but you should change Size to Size*2
	      closesoundout(TempFile,Size);
	      printf("Playing chunk, standby ");
      // Only if your OS supports multiple sample rate playback
//	      sprintf(tempString,"playstk sndviewTemp.wav %i &\n", Srate);  
      // else do this (44.1/48 Mac/Linux)
	      sprintf(tempString,"./playstk sndviewTemp.wav %i &\n", OSRATE);  
              int yo = system(tempString); // NOTE: Needs STK playstk somewhere in path

//            system("afplay sndviewTemp.wav &"); // NOTE: Mac only!! Pretty broke in Yosemite
//            system("play sndviewTemp.wav &"); // NOTE: Linux only!! Install SoX 

//            if (yo)  {
		 float hang = Size*(1.0*OSRATE/tsr)/tsr; // hang while playing file
	      	 while (hang > 0)  {  //   so we don't trash the file
		    usleep(250000);  // file while we're playing it
		    hang -= 0.25;
		    printf(".");
		    fflush(stdout);
	      	 }
	         printf(" And... we're back!!!\n");
//	      }
     
//	    system("rm sndviewTemp.wav");  // If you wanna clean up your trash
#endif
#ifdef BIGENDIAN
	printf("M@tr@la Byte Order Playback Unimplemented!! (for now)\n");
#endif 
	  }
	  else if (key==']')	{
		  CursorPos += FreqScale * Size / 64;
		  if (CursorPos >= (FreqScale * Size / 2))
			CursorPos = FreqScale * Size / 2;
	      glutPostRedisplay();
	  }
	  else if (key=='[')	{
		  CursorPos -= FreqScale * Size / 64;
		  if (CursorPos < 0) 
			CursorPos = 0;
	      glutPostRedisplay();
	  }
	  else if (key=='}')	{
		  CursorPos += 1;
		  if (CursorPos >= (FreqScale * Size / 2))
			CursorPos = FreqScale * Size / 2;
	      glutPostRedisplay();
	  }
	  else if (key=='{')	{
		  CursorPos -= 1;
		  if (CursorPos < 0) 
			CursorPos = 0;
	      glutPostRedisplay();
	  }
	  else if (key=='S')      {
	      ToggleSpectrum();
	      glutPostRedisplay();
	  }
	  else if (key=='W')	{
		  WinType += 1;
		  if (WinType > MAX_WIN_TYPE) WinType = 0;
		  newWindow = 1;
	      SetSize(size);
	  }
	  else if (key=='w')	{
		  WinType -= 1;
		  if (WinType < 0 ) WinType = MAX_WIN_TYPE;
		  newWindow = 1;
	      SetSize(size);
	  }
	  else if (key=='C')	{
		if (clearC[0]==0)	{
		  clearC[0]=1; clearC[1]=1; clearC[2]=1; clearC[3]=1;
		  drawC[0]=0; drawC[1]=0; drawC[2]=0; drawC[3]=0;
		}
		else	{
		  clearC[0]=0; clearC[1]=0; clearC[2]=0; clearC[3]=0;
		  drawC[0]=0; drawC[1]=1; drawC[2]=0; drawC[3]=0;
		}
	      glColor4f(drawC[0],drawC[1],drawC[2],drawC[3]);
	      glClearColor(clearC[0],clearC[1],clearC[2],clearC[3]);

	      glutPostRedisplay();
	  }
}

void drawWindow(void) {
   int i,x,y,xL,yL;
   float xscale = 600.0 / (float) Size;
   int yoffset = 128;
   for (i=0;i<Size;i++) {
	fdata[i] = 29000;
	tempdata[i] = data[i]; // save this for later
   }
   if (WinType == 0) {  
	rectangle(Size,fdata);	// Do Nothing, Rectangular Window
	fdata[0] = 0.0; fdata[Size-1] = 0.0; // well, not nothing...
   }
   else if (WinType == 1)	triangle(Size,fdata);
   else if (WinType == 2)	hanning(Size,fdata);
   else if (WinType == 3)	hamming(Size,fdata);
   else if (WinType == 4)	blackman3(Size,fdata);
   else if (WinType == 5)	blackman4(Size,fdata);
   for (i=0;i<Size;i++) data[i] = fdata[i];
   xL = 20;
   yL = yoffset - (data[0]>>8);
   for (i=1;i<Size;i++) {
       x = i * xscale + 20;
       y = yoffset-(data[i]>>8);
       line(xL,yL,x,y);
	xL=x;
	yL=y;
   }
   for (i=0;i<Size;i++) data[i] = fdata[i]*tempdata[i]/32000.0; // restore, but windowed (in case playback is attempted)
}

void Redraw(void)	{
   long i,tempi;
   int k,pow2,siz2;
   int x,y,xL,yL;
   unsigned char bdata[MAX_WIN*2];
   char out_string[512],temp_string[32];
   int xoffset=0.0,morexoffset=0.0,xright = 630;
   int yoffset = 128,yoffset3 = yoffset*3.3,yfscale=160;
   float xscale,temp,temp2;
   int maxLoc = 0;

//	printf("FileType= %i, SwapMode= %i, ByteMode = %i\n",FileType, SwapMode, ByteMode);

   if (ByteMode)	{
       k = fseek(MyFile,Location+SkipBytes,0);
       k = fread(&bdata,BYTE,Size,MyFile);
       for (i=0;i<k;i++)	{
	   data[i] = (short) (bdata[i] - 128) << 8;
       }
   }
   else	{
	if (FileType == FLT)	{
	    k = fseek(MyFile,Location*4+SkipBytes,0);
	    k = fread(&fdata,FLT,Size,MyFile);	
	    for (i=0;i<k;i++) data[i] = (short) fdata[i];
	}
	else if (FileType == BIT24)	{
	    k = fseek(MyFile,Location*3+SkipBytes,0);
	    k = 0;
	    for (i=0;i<Size;i++) {
		if (SwapMode == 1)	{
		    fread(&data[i+1],1,1,MyFile); // ignore LSByte, sorry...
		    k += fread(&data[i],2,1,MyFile);   // read 2MSBytes
		    swapshort(&data[i]);
		}
		else	{
		    k += fread(&data[i],2,1,MyFile);   // read 2MSBytes
		    fread(&data[i+1],1,1,MyFile); // ignore LSByte, sorry...
		}
	    }
	}
	else	{
	   k = fseek(MyFile,Location*2+SkipBytes,0);
           k = fread(&data,WORD,Size,MyFile);
	}
   }
   if (k<Size)
       for (i=k;i<Size;i++) data[i] = 0;
#ifdef BIGENDIAN
	if (FileType==WAV) for (i=0;i<Size;i++) swapshort(&data[i]);
#endif
#ifdef LITTENDIAN
	if (FileType==SND) for (i=0;i<Size;i++) swapshort(&data[i]);
#endif
   if (SwapMode==1) for (i=0;i<Size;i++) swapshort(&data[i]);

   line(20,yoffset,620,yoffset);
   line(10,1,630,1);
   line(10,yoffset*2,630,yoffset*2);
   line(10,1,10,yoffset*2);
   line(320,11,320,yoffset*2 - 30);
   line(630,1,630,yoffset*2);

   strcpy(out_string,"Block Size= ");
   sprintf(temp_string,"%i ",Size);
   strcat(out_string,temp_string);
   if (Srate > 0) {
	float windowtime = (float) Size / (float) Srate;
   	sprintf(temp_string,"(%.3f s.)",windowtime);
   }
   else {
	sprintf(temp_string,"(%i, samps)",Size);
   }
   strcat(out_string,temp_string);
   outtext(150,240,out_string);

   sprintf(temp_string,"%li ",Location - Beginning);
   outtext(20,240,temp_string);
   tempi = Location - Beginning + (Size / 2);
   if (Srate > 0.0)	{
	sprintf(temp_string,"%li (%.3f s.)",tempi, (float) tempi /(float) Srate);
   }
   else {
	sprintf(temp_string,"%li ",tempi);
   }
   outtext(310,240,temp_string);
   sprintf(temp_string,"%li ",Location - Beginning + Size);
   outtext(590,240,temp_string);

   xscale = 600.0 / (float) Size;
   xL = 20;
   if (newWindow)  { // window data for display, only on new window type
       for (i=0;i<Size;i++) fdata[i] = data[i];
       if (WinType == 0)	;	// Do Nothing, Rectangular Window
	   else if (WinType == 1)	triangle(Size,fdata);
	   else if (WinType == 2)	hanning(Size,fdata);
	   else if (WinType == 3)	hamming(Size,fdata);
	   else if (WinType == 4)	blackman3(Size,fdata);
	   else if (WinType == 5)	blackman4(Size,fdata);
       for (i=0;i<Size;i++) data[i] = fdata[i];
   }

   yL = yoffset - (data[0]>>8);
   for (i=1;i<Size;i++) {
       x = i * xscale + 20;
       y = yoffset-(data[i]>>8);
       line(xL,yL,x,y);
	xL=x;
	yL=y;
   }
   if (CalcSpectrum)	{
       siz2 = 64;
       pow2 = 6;
       while (siz2<Size) {
	   pow2 += 1;
	   siz2 *= 2;
       }
       for (i=0;i<Size;i++) fdata[i] = (float) data[i];
       if (siz2>Size) for (i=Size;i<siz2;i++) fdata[i] = 0.0;
       xoffset = 50;
       xright = 630;
       morexoffset = -5.0;
       	if (floc==0.0)	
	    line(xoffset,yoffset3,xoffset,yoffset3-yfscale);
	else 
	    morexoffset = 30.0;
       	if (fscale==1.0) 
	   line(xright,yoffset3,xright,yoffset3-yfscale);
	else
	    xright = 600;
       line(xoffset+morexoffset,yoffset3,xright,yoffset3);
       line(xoffset+morexoffset,yoffset3-yfscale*0.33,xright,yoffset3-yfscale*0.33);
       line(xoffset+morexoffset,yoffset3-yfscale*0.66,xright,yoffset3-yfscale*0.66);
       line(xoffset+morexoffset,yoffset3-yfscale,xright,yoffset3-yfscale);

       if (!newWindow)  {  // if newWindow then we already did this
           if (WinType == 0)	;	// Do Nothing, Rectangular Window
	   else if (WinType == 1)	triangle(Size,fdata);
	   else if (WinType == 2)	hanning(Size,fdata);
	   else if (WinType == 3)	hamming(Size,fdata);
	   else if (WinType == 4)	blackman3(Size,fdata);
	   else if (WinType == 5)	blackman4(Size,fdata);
       }

// GACK       fhtRX4(j,fdata);	// used to be these for power of 4
//        logMag(k,fdata,-90.0,32768.0*32768.0*k);  // but see below at magSpectrum

       magSpectrum(pow2,fdata);	// this now wants power of 2

       xscale = 1160.0 / (FreqScale * Size);
	k = 0;
	temp = Size*FreqScale*floc*0.5; 
       xL = xoffset;
       yL = yoffset3 - (int) (fdata[(int) temp] * yfscale);
        for (i=temp;i<temp + FreqScale*Size*0.5;i++,k++) {
	       x = k * xscale + xoffset;
	       y = yoffset3 - (int) (fdata[i] * yfscale);
	       line(xL,yL,x,y);
			xL = x;
			yL = y;
	}
	x = (xscale * CursorPos) + xoffset;
	line(x,yoffset3+11,x,yoffset3-yfscale);
       outtext(5,270,"     0dB");
       outtext(5,318,"-30dB");
       outtext(5,372,"-60dB");
       outtext(5,422,"-90dB");
       sprintf(temp_string,"%i",(int) (2.0 / FreqScale));
//       strcpy(out_string,"SR/");
	if (Srate > 0.0)	{
	    sprintf(out_string,"%5.0f",(1.0+floc)*Srate/2.0*FreqScale);
	    strcpy(temp_string," Hz.");
            strcat(out_string,temp_string);
            outtext(590,433,out_string);
	    sprintf(out_string,"%5.0f",floc*Srate/2.0*FreqScale);
	    strcpy(temp_string," Hz.");
            strcat(out_string,temp_string);
            outtext(xoffset-20,433,out_string);
	}
	else {
	    sprintf(out_string,"%f.2*SRATE",(1+floc)/2.0*FreqScale);
            outtext(590,433,out_string);
	    if (floc==0.0) sprintf(out_string,"0.0Hz."); 
	    else sprintf(out_string,"SRATE*%f.2",floc/2.0*FreqScale);
            outtext(xoffset-20,433,out_string);
	}
//	   temp = 0.0;
//       j = 1;
//       while(fdata[j] > fdata[j+1]) j++;
//       for (i=j;i<FreqScale*Size*0.5;i++)       {
//	   if (fdata[i]>temp) {
//	      temp = fdata[i];
//	      maxLoc = i;
//	   }
//     }
//       temp = maxLoc + fitParabola(fdata[maxLoc-1],fdata[maxLoc],fdata[maxLoc+1]);
//       sprintf(temp_string,"Peak Location = %f ",temp);
//       outtext(0,440,temp_string);
		temp = 90.0 * (fdata[CursorPos + (int) (floc * fscale * Size/2.0)] - 1.0);
		temp2 = (float) (CursorPos + (floc * fscale * (float) Size / 2.0)) / (float) Size;
//       if (FileType==RAW | FileType==BIT24)	{
	if (Srate > 0.0)	{
		temp2 *= Srate;
		sprintf(temp_string,"%3.2f dB",temp);
		outtext(xscale * CursorPos + 20 ,445,temp_string);
		sprintf(temp_string,"%5.2f Hz.",temp2);
		outtext(xscale * CursorPos + 20 ,455,temp_string);
       }
	   else	{
		sprintf(temp_string,"%3.2f dB",temp);
		outtext(xscale * CursorPos + 20,445,temp_string);
		sprintf(temp_string,"%5.2f SRATE ",temp2);
		outtext(xscale * CursorPos + 20 ,455,temp_string);
       }
//	   outtext(300,435,temp_string);
	   if (strlen(file_name) < 60) 
		outtext(470,477,file_name);
	   else 
		outtext(470,477,&file_name[strlen(file_name)-60]);
	   if (Srate > 0.0) 
		sprintf(temp_string,"SRATE=%li",Srate);
	   else 
		sprintf(temp_string,"SRATE=??");
       	   outtext(470,467,temp_string);

	   strcpy(out_string, "Bits/Samp=");
	   if      (WordSize==1) strcat(out_string,"8s");
	   else if (WordSize==2) strcat(out_string,"16s");
	   else if (WordSize==3) strcat(out_string,"24s");
	   else if (WordSize==4) strcat(out_string,"32f");
	   else strcat(out_string,"?");
	   outtext(550,467,out_string);
	   
	   if (WinType == 0) sprintf(temp_string,"Rectangular Window");
	   else if (WinType == 1) sprintf(temp_string,"Triangular Window");
	   else if (WinType == 2) sprintf(temp_string,"Hanning Window");
	   else if (WinType == 3) sprintf(temp_string,"Hamming Window");
	   else if (WinType == 4) sprintf(temp_string,"Blackman3 Window");
	   else if (WinType == 5) sprintf(temp_string,"Blackman4 Window");
	   outtext(370,477,temp_string);
   }
   else	{
       outtext(200,340,"SPECTRUM DISPLAY DISABLED");
   }
   if (newWindow)  {
      drawWindow();  // draw actual window shape too
      newWindow = 0;
   }
   outtext(0,467," WavSize=+/-   Loc=L/R arrow   Window=w/W   Color=C  Spect:View=S  Size=<>  Pos= , / .");
   outtext(0,477," SpectCursor  L/R={  }  (fast=[  ])    Peaks=1-9      Play=<sp>     Exit: ESC");
}

int main(int ac, char *av[]    )
{
    int k;
    char titleString[512];

//    int graphdriver = DETECT, graphmode;
    
	long loc = 0;

    if (ac>1)      {
 	strcpy(file_name,av[1]);
	MyFile = fopen(file_name,"rb");
	WordSize = 2;
	if (MyFile)    {
	    k = 2;
	    while(k<ac)	{
		if (av[k][0]=='-')  {
		    if (av[k][1]=='b') {
			WordSize = BYTE;
		    	ByteMode = 1;
			printf("Setting byte mode\n");
		    }
		    else if (av[k][1]=='s') 	{
		    	SwapMode = 1;
			printf("Setting swap mode\n");
		    }
		    else if (av[k][1]=='x')	{
			WordSize = WORD;
			FileType = WORD;
			printf("Setting 16-bit word mode\n");
		    }
		    else if (av[k][1]=='f')	{
			WordSize = FLT;
			FileType = FLT;
			printf("Setting float mode\n");
		    }
		    else if (av[k][1]=='t')	{
			WordSize = BIT24;
			FileType = BIT24;
			printf("Setting 24 bit mode\n");
		    }
		    else if (av[k][1]=='r')	{
			Srate = atoi(&av[k][2]);
			SrateOverride = Srate;
			printf("Setting SampleRate to: %li\n",Srate);
		    }
		    else if (av[k][1]=='j')	{
			SkipBytes = atoi(&(av[k][2]));
			printf("Skipping (jumping) %i bytes\n",SkipBytes);
		    }
		    else if (av[k][1]=='c')	{
			clearC[0]=1; clearC[1]=1; clearC[2]=1; clearC[3]=1;
			drawC[0]=0; drawC[1]=0; drawC[2]=0; drawC[3]=0;
			printf("Setting Colors to Black on White\n");
		    }
		    else if (av[k][1]=='w')	{
			WidthScale = atof(&(av[k][2]));
			printf("Scaling Window Width by %f\n",WidthScale);
		    }
		    else if (av[k][1]=='h')	{
			HeightScale = atof(&(av[k][2]));
			printf("Scaling Window Height by %f\n",HeightScale);
		    }
		    else 
		    	printf("I don't understand your arguments\n");
		}
		k += 1;
	    }
 	}
	else {
	    printf("Gimme a valid filename!!!\n");
	    exit(0);
	}
    }
    else   {
	printf("Useage:     sndview fileName [-b] [-f] [-s] [-t] [-j<N>]\n");
	printf("            where -b sets byte mode\n");
        printf("                  -x sets 16 bit mode\n");
	printf("		  -f sets float mode\n");
	printf("                  -t sets 24 bit mode\n");
	printf("                  -jN sets Skip (jump) N Bytes\n");
	printf("                  -rM sets Sample Rate = M\n");
	printf("                  -c sets color to black on white\n");
	printf("                  -wX scales Display Width by X\n");
	printf("                  -hY scales Display Height by Y\n");
	printf("              and -s forces byteswapped data\n"); 
	printf("                      (for raw, unknown, etc.)\n"); 
	exit(0);
    }

printf("Key Commands:   WaveSize    = + or - (powers of 2)\n");
printf("                Location    = LeftArrow/ RightArrow keys\n");
printf("                Window Type = w/W indow type down/up thru menu\n");
printf("                Color       = C toggle B/W or Green/B\n");
printf("                Spectrum    = S (toggle spectral display)\n");
printf("                Spect Size  = < > (powers of two)\n");
printf("                Spect. Posl = , or . \n");
printf("                SpectCursor = L/R={  }  (fast=[  ])\n");
printf("                Play Segment= <sp>\n"); 
printf("                Exit        = ESC (or <cntl>C)\n");   
printf("                SpectPeaks  = 1 - 9\n");
fflush(stdout);

    glutInit(&ac, av);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    strcpy(titleString,"SndView: ");
	strcat(titleString,file_name);
	glutInitWindowSize(640*WidthScale,480*HeightScale);
	glutCreateWindow(titleString);

    SndView(0,256,file_name);
    SetLocation(loc);
    if (SrateOverride > 0.0) Srate = SrateOverride;

    glutDisplayFunc(display);
	glutKeyboardFunc(KeyFunc);
	glutSpecialFunc(SpecialFunc);
//     glutCloseFunc(die);  // OLD DEAD FUNCTION
#ifdef OSX
     glutWMCloseFunc(die);  // COMMENT THIS OUT FOR WINDOZE/LINUX
#endif
	glColor4f(drawC[0],drawC[1],drawC[2],drawC[3]);
	glClearColor(clearC[0],clearC[1],clearC[2],clearC[3]);

    init();

    glutMainLoop();

//    initgraph(&graphdriver, &graphmode, "c:/tc/bgi");
//    setgraphmode(graphmode);
//    closegraph();
	fclose(MyFile);
    return 0;
}


