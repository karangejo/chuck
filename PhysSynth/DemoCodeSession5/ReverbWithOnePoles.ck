//  Simple 3-delay reverb from scratch
//    by Perry R. Cook, 2015
//  This one adds one pole lowpass filters

adc => Gain inGain;  // caution, feedback potential!!!
0.5 => inGain.gain;  // for safety
Delay del[3];
OnePole loss[3];  // add loss filters for paths

for (int i; i < 3; i++)  {   // hook all up
   inGain => del[i] => dac;
   del[i] => loss[i] => del[i];  // put low pass in loop
   0.7 => loss[i].pole;          // and set the poles 
   0.7 => del[i].gain;
}

88::ms => del[0].delay;     // set delays
71::ms => del[1].delay;
53::ms => del[2].delay;

while (1)  {
   second => now;           // hang out
}

