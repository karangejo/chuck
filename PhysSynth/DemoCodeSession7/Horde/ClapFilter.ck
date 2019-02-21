//  One clapper dude
// Noise thru envelope thru filter thru reverb into dac
Noise n => ADSR a => BiQuad b => Pan2 p => dac;
p => NRev r => dac;
(2*ms,2*ms,0.0,ms) => a.set;
1.0 => r.mix;  0.04 => r.gain;

1 => b.eqzs;

Math.random2f(0.3,0.5) => float tempo; // pick a random average tempo for this clapper
Math.random2f(700,2200) => float freq; // pick an average center frequency
Math.random2f(-1.0,1.0) => p.pan; // pick a pan (spatial location L/R)

0.2 => p.gain; // normalize a bit (we're going to be making lots of these)

while (1)	{
    clap(tempo,freq);
}

fun void clap(float basicTempo,float basicFreq)  {
    Math.random2f(0.8*basicFreq,1.2*basicFreq) => b.pfreq;
    Math.random2f(0.94,0.98) => b.prad;
    1 => a.keyOn;
    Math.random2f(0.9*basicTempo,1.1*basicTempo) :: second => now;
}
