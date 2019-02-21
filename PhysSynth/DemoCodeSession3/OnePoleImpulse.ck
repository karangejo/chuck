// ChucK's Built-in OnePole filter UGen
//     by Perry R. Cook, 2015
Impulse imp => OnePole onepole => dac;

0.99 => onepole.pole;  // set this to control exponential decay
10.0 => onepole.gain;  // should adjust this too, depending on pole

0.2::second => now;  // run it silent first, then

1 => imp.next;       // impulse response
3*second => now;

