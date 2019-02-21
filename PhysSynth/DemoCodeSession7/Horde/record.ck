<<< me.arg(0), me.arg(1) >>>;

dac => WvOut2 w => blackhole;
me.arg(0) => w.wavFilename;
0.2 => w.fileGain;
Std.atof(me.arg(1)) :: second => now;
w.closeFile();

