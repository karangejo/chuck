//  OneZero High Pass Filter, from Scratch
//    by Perry R. Cook, 2015

Noise n => Gain outMix => dac;
      n => Delay xn_1 => outMix;
1::samp => xn_1.delay;   // set delay
-1 => xn_1.gain;         // -x(n-1) term
0.5 => outMix.gain;      // normalize so we don't clip

second => now;

