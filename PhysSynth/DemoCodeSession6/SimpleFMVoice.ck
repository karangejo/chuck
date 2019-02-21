// Simple FM Voice, 3 carriers for 3 formants
//  one modulator to rule them all!!
//    by Perry R. Cook, 2015

SinOsc modulator => SinOsc f1 => dac;  // one carrier
       modulator => SinOsc f2 => dac;  //   for each
       modulator => SinOsc f3 => dac;  //     formant
2 => f1.sync;      // tell carriers to allow modulation
2 => f2.sync;      // tell carriers to allow modulation
2 => f3.sync;      // tell carriers to allow modulation
90 => modulator.gain;  // amount of modulation

100 => modulator.freq;  // modulator frequency
700 => f1.freq;   // carrier/formant frequency
1100 => f2.freq;   // carrier/formant frequency
2500 => f3.freq;   // carrier/formant frequency
<<< "FM", "Ahh" >>>;
second => now;

112 => modulator.freq; // new mod freq
224 => f1.freq; // must be multiples of mod freq
2576 => f2.freq; 
3136 => f3.freq;
<<< "FM", "Eee" >>>;
second => now;

125 => modulator.freq; // new mod freq
250 => f1.freq; // must be multiple of mod freq
875 => f2.freq; 
2250 => f3.freq;
<<< "FM", "Ooo" >>>;
second => now;



