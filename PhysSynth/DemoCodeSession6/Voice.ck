// Simple Subtractive Formant Voice Model
//   by Perry R. Cook,  2015

BlitSaw glot => Gain in;  // band-limited (smooth) sawtooth wave
//   Noise n => in; 0.0 => glot.gain; // do this for whispering
in => ResonZ f1 => dac;   // formant filters
in => ResonZ f2 => dac;
in => ResonZ f3 => dac;
30 => f1.Q => f2.Q => f3.Q;

[200.0, 800.0, 2500.0] @=> float formantTarget[];
220.0 => float pitchTarget;

spork ~ smoothStuff();

while (true)  {  // sing random stuff
    Math.random2f(0.4,1.0)::second => now;
    if (maybe) Math.random2f(50,200) => pitchTarget;
    if (maybe) {
        Math.random2f(200,600) => formantTarget[0];
        Math.random2f(600,2200) => formantTarget[1];
        Math.random2f(1800,3500) => formantTarget[2];
    }
}

fun void smoothStuff()  { // smooth formant and pitch changes
    while (true)   {
        ms => now;
        f1.freq()*0.99 + formantTarget[0]*0.01 => f1.freq;
        f2.freq()*0.99 + formantTarget[1]*0.01 => f2.freq;
        f3.freq()*0.99 + formantTarget[2]*0.01 => f3.freq;
        glot.freq()*0.99 + pitchTarget*0.01 => glot.freq;
  }
}
