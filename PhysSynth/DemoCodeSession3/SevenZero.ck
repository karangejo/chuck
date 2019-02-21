//  8-point moving average (7 zero) filter from scratch in ChucK
//   by Perry R. Cook, 2015
Noise n => Gain xn => Gain outGain => dac;
      n => Delay xn_1 => outGain;    // Delays
      n => Delay xn_2 => outGain;
      n => Delay xn_3 => outGain;
      n => Delay xn_4 => outGain;
      n => Delay xn_5 => outGain;
      n => Delay xn_6 => outGain;
      n => Delay xn_7 => outGain;
1::samp => xn_1.delay;            // set delay of each
2::samp => xn_2.delay;
3::samp => xn_3.delay;
4::samp => xn_4.delay;
5::samp => xn_5.delay;
6::samp => xn_6.delay;
7::samp => xn_7.delay;

0.125 => outGain.gain; // normalize

second => now;     // run it

