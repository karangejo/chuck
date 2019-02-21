//  Three Zero Filter from scratch in ChucK
//   by Perry R. Cook, 2015

Noise n => Gain xn => Gain outGain => dac;
      n => Delay xn_1 => outGain;  // Delay 
1::samp => xn_1.delay;             //    of 1 sample
      n => Delay xn_2 => outGain;  // Delay 
2::samp => xn_2.delay;             //    of 2 samples
      n => Delay xn_3 => outGain;  // Delay 
3::samp => xn_3.delay;             //    of 3 samples

0.25 => outGain.gain;             // normalize so we don't clip

second => now;  // let 'er rip!

