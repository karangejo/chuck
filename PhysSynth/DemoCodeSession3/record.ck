//  Run this along with any code
//  and it writes dac out to a (mono) file
//  Want stereo?  Just change WvOut to WvOut2
//  Might want to fiddle with fileGain

<<< me.arg(0), me.arg(1) >>>;

dac => WvOut w => blackhole;
me.arg(0) => w.wavFilename;
0.3 => w.fileGain;
Std.atof(me.arg(1)) :: second => now;
w.closeFile();

