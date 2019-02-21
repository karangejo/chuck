// Simple Frequency Modulation, One Carrier, One Modulator
//   by Perry R. Cook, 2015

SinOsc modulator => SinOsc carrier => dac;
2 => carrier.sync;      // tell carrier to allow modulation
1000 => carrier.freq;   // carrier frequency
100 => modulator.freq;  // modulator frequency
1000 => modulator.gain;  // amount of modulation

<<< "100 Hz modulator", "1000 Hz. carrier" >>>;
second => now;
0 => carrier.gain;  second => now;

<<< "200 Hz modulator", "1000 Hz. carrier" >>>;
200 => modulator.freq; 1 => carrier.gain; second => now;
0 => carrier.gain;  second => now;

<<< "237 Hz modulator", "1000 Hz. carrier" >>>;
237 => modulator.freq; 1 => carrier.gain; second => now;
