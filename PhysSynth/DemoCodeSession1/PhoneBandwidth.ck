// Phone-quality speech, by Perry R. Cook, Summer 2015
// Includes limited bandwidth: 200 Hz on low end, 3500Hz on high end
// and 8-bit linear quantization as well

//  CAUTION!!!!  Feedback potential, wear headphones 
//     or turn mic way down until you get the gain right.

Noise n => Gain inp;  // for testing
0.0 => n.gain; // mute this for mic thruput
adc => inp;  // mic input (be sure you have things set up for mic)

HPF hp; // high-pass filter, low frequency rolloff
LPF lp[6]; // low-pass filters, high-frequency rolloff
inp => hp => lp[0]; // first in the chain;
300 => hp.freq; 1.0 => hp.Q; // set up high-pass section 
Step outp => dac; // last in chain

for (int i; i < 5; i++)  { // set all up for same cutoff
    lp[i] => lp[i+1];
    3500 => lp[i].freq;
    1.0 => lp[i].Q;
}
lp[5] => blackhole; // have to draw samples through so we can work on them
3500 => lp[5].freq;
1.0 => lp[5].Q;

while (true)  {
    Std.ftoi(128.0*lp[5].last()) => int temp; // stash in integer
    (temp*1.0) / 128.0 => outp.next;      // then convert back
    samp => now;                       // to do 8-bit quantization
}
