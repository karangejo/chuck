//  ChucK Native OneZero High Pass
//    by Perry R. Cook, 2015

Noise n => OneZero onezero => dac;
0.5 => onezero.b0;  // zero sample delay gain
-.5 => onezero.b1;  // one sample delay gain

second => now;

