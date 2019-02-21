Welcome to sndview!  (c) Perry R. Cook 1987(yep!) - present (Nov. 2015 
at this point)

No warranties.  Use as you like (except for evil)

I've been working on this program, on many platforms, since Stanford 
graduate school.  I was taking a course on frequency transforms, and 
thought the Hartley was cool (a different casting of the Fourier, but 
mostly the same when you boil it down), and I wanted to make a 
sound/spectrum viewer (not an editor, just an inspector).

sndview was the result.  It started in Windows (2.0, earlier?) in Turbo 
C, then got ported forward a number of times, forked off into Spectro 
for the NeXT Machine, and into SoundView for SGI, and sndpeek (by Ge, 
Ananya, others) for Mac.  But sndview persisted in its clunky green on 
black (holla back to old monochrome monitors!), command line, all 
keyboard controlled, glory.  So here it is.

The documentation/useage is pretty much onscreen, and is printed into 
the Terminal/CommandPrompt that you launch it from.  But I'll go over 
some subtleties and tips here.  Notes on compilation, dependencies (few 
save for GL/glut) and compatibility are at the bottom of this file.  
Here's how to use it, and various arguments you can provide on the 
command line:

Useage and Command Line Arguments: Useage: sndview fileName [-b] [-f] 
[-s] [-t] [-j<N>] [-c] [-w<X>] [-h<Y>]
            where -b sets byte mode
                  -x sets 16 bit mode
		  -f sets float mode
                  -t sets 24 bit mode
                  -jN sets jump (skip) forward N Bytes
                  -rM sets Sample Rate = M
                  -c sets color to black on white
                  -wX scales Display Width by X (float, 1.0 default)
                  -hY scales Display Height by Y (float, 1.0 default)
              and -s forces byteswapped data
                      (for raw, unknown, etc.)

The program does a little to figure out what kind of soundfile it is 
(.wav, .au, .snd), but it's not super smart.  It really only works with 
Mono files. It will happily eat a stereo file, but the display will be 
odd, frequencies wrong, etc.  If what you see on the screen is junk, 
then try forcing a format using -b (byte mode), -x (16 bit), -f (4-byte 
float), -t (24 bit mode).  If it's still junk, try byte-swap using -s.  
Also you can try jumping forward in the file by some number of bytes 
(-j1 -j2 -j3 -jN etc. causes it to jump forward 1, 2, 3, or N bytes into 
the file).  If it's still junk, see if you can load the file into your 
favorite sound editor (Audacity or other), and save it out as Mono, 16 
bit, .wav format.  Then sndview should be able to understand it better.  
The -s argument allows you to force a sample rate (this is only what it 
uses to calculate frequencies, no conversions are performed.  But if you 
play using the space bar, it will use this SRate, which may or may not 
be the right thing to do). Other arguments are cosmetic (color and 
X/Y size multipliers).

Once it's running, here's the Key Command summary:

WaveSize    = + or - (powers of 2)
Location    = LeftArrow/RightArrow keys 
Window Type = w/W down/up thru menu
Color       = C toggle B/W or Green/B 
Spectrum    = S (toggle spectral display on/off) 
Spect Size  = < > (powers of two) 
Spect. Pos  = , or . 
SpectCursor = L/R={ } (fast=[ ]) 
Play Segment= <sp> 
SpectPeaks  = 1 - 9
Exit        = ESC (or <cntl>C) 

If you use it for 30 years like I have, then your fingers will memorize 
these.  Some are obvious (left/right arrows), others not at all.

The thing I use sndview for the most is to find out things about 
spectral slices of sounds.  So your buddies are Spect Size </> and 
SpectPos ,/. which allow you to zoom into regions easily. 
SpectCursor { } or [ ] allows you to place a cursor on, thus 
measure a frequency and amplitude at one point.  
And (new for 2015!!) the 1 - 9 keys automagically find and move the 
cursor to each of the 9 highest peaks in the spectrum.  NOTE: If 
you're zoomed into the spectrum and you hit 1-9, it may move off 
screen where you can't see it.

If you're set up correctly (a playstk executable in a directory in your 
path, or in this directory), then hitting the spacebar causes the 
currently visible waveform to play.  For a large segment, the program 
hangs while the sound is playing. This is to avoid clobbering the 
temporary file that's playing by hitting the spacebar again.  NOTE: 
using this feature will create a temporary file, sndviewTemp.wav in 
whatever directory you run sndview from.  So, in this really stupid 
primitive way, sndview is a sound editor as well!! If you don't want 
those files laying around, edit (uncomment) the source down at the line
    // system("rm sndviewTemp.wav");

There is much joy to using sndview.  The best part is that it's
free and open-source.  ENJOY!!! 
__________________________________________________
NOTES on Running/Building

I have included executables for most of the common platforms and OS 
versions.  They’re all in the main directory with filenames like 
sndviewMacOSX10.10.5 sndviewWindows32 (32 bit), sndviewRPi (Raspberry 
Pi), etc.  Find one that runs and copy it to sndview, in a directory in 
your search path where executables are usually stored.  Then you’re 
ready to go! Also, Windows users must have the gl.dll files somewhere 
they can be found and loaded.

If you must build, or want to hack the source:

There is only one big huge flat .c file.  That's both good and bad.  
Good is that there's just one command line to compile it.  Bad is if 
you have to edit it, it's one big huge file.  There are make scripts for 
most of the architectures you might encounter.  Just type makeOSX, or 
makeWindows32, etc.  But no guarantees. All of these assume cc or gcc as 
the compiler.  No MSVC for Windows.  Download and install MinGW (Minimal 
Gnu for Windows), and compile it in a Command Prompt/Shell like a real 
programmer :-) You might also want to get MSYS (Unix for Windows), 
especially if you want or need to build STK (for playstk, for example, 
see below).

For sndview to play the visible sound (spacebar), it does a system call 
to an executable called playstk This is the play.cpp example from STK.  
You should copy it to a directory in your search path where executables 
are stored.  ~/bin or C:\Program Files or other.  I've included 
playstk's for most common architectures and versions.  Just find one 
that works, copy it to playstk (name must be exactly that) and put it 
where your OS can find it.  If all else fails, go get STK and build the 
examples, then rename play to playstk and put it somewhere visible.

That's all I can say for now.  Happy viewing!! 
_________________________________________________
