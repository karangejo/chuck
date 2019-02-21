//  Simple Subtractive Synthesizer
//    by Perry R. Cook, 2015
//  Sawtooth through single-resonance sweeping filter
//  This one sweeps the filter up (open)

SawOsc osc => ADSR env => ResonZ rez => dac;
(ms,second/4,0.3,second/4) => env.set;
10 => rez.Q;

play(48); second/2 => now;
play(50); second/2 => now;
play(52); second/2 => now;
play(53); second/2 => now;
play(55); second/2 => now;
play(57); second/2 => now;
play(59); second/2 => now;
play(60); second => now;

// This function plays a note, and starts the filter sweep
fun void play(int note)  {
    Std.mtof(note) => osc.freq;
    100.0 => rez.freq;
    1 => env.keyOn;
    spork ~ sweep();
}

//  This function sweeps the filter freq up to 1000 Hz.
fun void sweep()  {
    while (rez.freq() < 1000) {
        rez.freq()*1.005 => rez.freq;
        ms => now;
    }
}


