//  Offline Granular Synthesis
//   operates on entire sound at once
//  by Perry R. Cook,  2015

SndBuf main => dac;
me.dir()+"/SomeSpeech.wav" => main.read; // direct dry sound
SndBuf s[10]; ADSR a[10]; Pan2 p[10]; // grains (with random pan)
Gain mix[2] => dac;  // stereo output mix "bus"
for (int i; i < 10; i++)  {
    s[i] => a[i] => p[i] => mix;
    1 => s[i].loop;
    me.dir()+"/SomeSpeech.wav" => s[i].read;
    (500::ms,500::ms,0.0,ms) => a[i].set;
    spork ~ chop(i);
}

1 => int notDone;
1000.0 / main.samples() => float del;
0.0 => mix[0].gain => mix[1].gain;

while (main.pos() < main.samples())  {
    1000::samp => now;
    mix[0].gain()+del => mix[0].gain => mix[1].gain;
}

0 => notDone;

// wake up every once an a while and pick/fire/pan a new grain
fun void chop(int which)  {
    while (notDone)  {
        Math.random2f(0.2,0.5)::second => now;
        Math.random2f(-0.6,0.6) => p[which].pan;
        Math.random2(0,s[which].samples()) => s[which].pos;
        1 => a[which].keyOn;
    }
}

