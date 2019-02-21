//   2-Point Moving Average Filter, from scratch

Noise n => dac;  // first, one second of pure noise
second => now;

n =< dac;        // disconnect that (unChucK)

second => now;   // second of silence

n => Gain outMix => dac;         // build moving avg.
      n => Delay xn_1 => outMix;
1::samp => xn_1.delay;           // one sample delay
0.5 => outMix.gain;   // normalize so we don't clip

second => now;             // run that for one second


