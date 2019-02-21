// One pole filter built from scratch in ChucK
//    by Perry R. Cook, 2015

Impulse imp => Gain fb_1 => Gain outMix => dac;
      fb_1 => fb_1 => outMix;  // we get 1 sample of delay ('cause feedback)

0.999 => fb_1.gain; // set feedback gain
1.0 => outMix.gain; // and net filter gain

1 => imp.next;

second => now;

