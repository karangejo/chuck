// Simple FM Bell, after Chowning
//   by Perry R. Cook, 2015

SinOsc modulator => ADSR menv => SinOsc carrier => ADSR cenv => dac;
2 => carrier.sync;      // tell carrier to allow modulation
1141 => carrier.freq;   // carrier frequency
217 => modulator.freq;  // modulator frequency
1000 => modulator.gain;  // amount of modulation
(10*ms,3::second,0.0,ms) => menv.set;
(5*ms,3::second,0.0,ms) => cenv.set;

1 => menv.keyOn => cenv.keyOn;

3*second => now;

0.3 => dac.gain;
while (true)  {
    Math.random2f(800,1500) => carrier.freq;
    Math.random2f(150,450) => modulator.freq;
    1 => menv.keyOn => cenv.keyOn;
    Math.random2f(0.5,1.5)*second => now;
}
