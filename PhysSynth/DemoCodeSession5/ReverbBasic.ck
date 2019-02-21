//  Simple 3-delay reverb from scratch
//    by Perry R. Cook   2015
adc => Gain inGain;  // caution, feedback potential!!!
0.5 => inGain.gain;  // for safety
Delay del[3];

for (int i; i < 3; i++)  {   // hook all up
   inGain => del[i] => dac;
   del[i] => del[i];
   0.7 => del[i].gain;
}

88::ms => del[0].delay;     // set delays
71::ms => del[1].delay;
53::ms => del[2].delay;

while (1)  {
   second => now;           // hang out
}

