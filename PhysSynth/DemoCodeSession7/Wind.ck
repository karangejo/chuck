// Break like the wind!!
//    simple noise-excited sweeping filters
// by Perry R. Cook, July 2015
Noise n => OnePole lp;
0.1 => lp.pole;
NRev r => dac;
0.1 => r.mix;

0.01 => float PROB;  // probablity for 3ms updates 

ResonZ rez[3];
[100.0,100,200] @=> float frqs[];
[1.0,0.0,0.0] @=> float gains[];
for (int i; i < 3; i++)  {
    lp => rez[i] => r;
    30 => rez[i].Q;
    0.0 => rez[i].gain;
}

while (true)  {
    for (int i; i < 3; i++)  { // smoothly ramp things around
        rez[i].freq()*0.9999 + frqs[i]*0.0001  => rez[i].freq;
        rez[i].gain()*0.9999 + gains[i]*0.0001 => rez[i].gain;
    }
    if (Math.random2f(0.0,1.0) < PROB) { // every so often, update somebody
        Math.random2(0,2) => int which;
        Math.random2f(50,1000) => float newFreq;
        Math.random2f(0.0,1.0) => float newGain;
        newFreq => frqs[which];
        newGain * frqs[which] / 2000 => gains[which];
        <<< "New frequency", newFreq, "and gain", gains[which], "for", which >>>;
    }
    3::ms => now;
}

