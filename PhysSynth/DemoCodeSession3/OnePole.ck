//  One Pole IIR Filter from scratch
//     by Perry R. Cook, 2015
Noise n => Gain fb => Gain outMix => dac;
      fb => fb => outMix;  // loop output back (we get one sample of delay for free)

0.99 => fb.gain;     // can change this, as long as it's < 1.0
0.01 => outMix.gain; // might need to adjust this depending on r

second => now;

