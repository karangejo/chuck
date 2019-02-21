// 2nd Order IIR filter from scratch in ChucK
//   by Perry R. Cook, 2015
Impulse imp => Gain inGain => Gain outMix => dac;
inGain => Delay fb_2 => inGain;      

-0.995 => fb_2.gain;  // this already has 1 sample delay (from feedback)
1::samp => fb_2.delay; // 1::samp makes it 2 samples of day (one automatic from feedback)

1.0 => outMix.gain;

1 => imp.next;

second => now;


