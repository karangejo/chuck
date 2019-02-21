//  Physically Informed Stochastic Event Modeling (PHISEM)
//     Applause simulator.  Use only three sound makers!!
// Noise thru envelope thru filter thru reverb into dac
Noise n;
ADSR env[3];
BiQuad b[3];
Pan2 p[3];
NRev r[2];
r[0] => dac.left;    // one left reverb
r[1] => dac.right;   // one right reverb
0.04 => r[0].mix; 0.04 => r[1].mix;

0 => int which;  // we'll use this for round-robin voice allocation

for (int i; i < 3; i++)  {
    n => env[i] => b[i] => p[i];
    p[i].chan(0) => r[0]; // pans connect to both
    p[i].chan(1) => r[1]; // left/right reverbs
    (2*ms,2*ms,0.0,ms) => env[i].set;
    1 => b[i].eqzs;
}
        
0.005 => float PROB;  // this sets perceived average number of clappers
0.3 => n.gain;

while (PROB < 1.0)	{
    ms => now;  // you could change this, or PROB, or both
    if (Math.random2f(0.0,1.0) < PROB) clap();
    1.0005 *=> PROB; // increase number of clappers
}

while (PROB > 0.001)	{
    ms => now;
    if (Math.random2f(0.0,1.0) < PROB) clap();
    1.001 /=> PROB; // decrease number of clappers
}

fun void clap()  {  // make a (random) clap
    (which++ % 3) => which; // grab the least recent dude
    Math.random2f(800,2200) => b[which].pfreq; // pick a frequency
    Math.random2f(0.92,0.97) => b[which].prad;
    Math.random2f(-1.0,1.0) => p[which].pan; // place it random stereo
    1 => env[which].keyOn;
}
    
