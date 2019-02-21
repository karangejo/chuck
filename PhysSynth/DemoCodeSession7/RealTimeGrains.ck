//  Brute force real-time granulizer
//   (chop up audio from dac)
//  Perry R. Cook, August 2015
adc => Gain input => blackhole;
Impulse imp => Delay d => dac;
input => Delay d2 => dac;
0.5 => input.gain;
0.8::second => d.max;
0.8::second => d2.max;

float buff[8820];
0 => int sndpoint;
0 => int outpoint;
1 => int outStep;

spork ~ frag();

while (1)  {
    input.last() => buff[sndpoint];
    sndpoint++;
    if (sndpoint >= 8820) 0 => sndpoint;
    buff[outpoint] => imp.next;
    Math.random2(0,2) +=> outpoint;
    if (outpoint >= 8820) 0 => outpoint;
    if (outpoint < 0) 8819 => outpoint;
    samp => now;
}

fun void frag()  {
    while (true) {
        Math.random2f(0.02,0.3):: second => now;
        Math.random2(0,8819) => outpoint;
        Math.random2f(0.1,0.4)::second => d.delay;
        Math.random2f(0.1,0.4)::second => d2.delay;
        Math.random2(-1,3) => outStep;
    }
}
 
