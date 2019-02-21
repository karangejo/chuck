// Average Magnitude Difference Function Pitch Detector
// by Perry R. Cook, Original Nov., 2008, revised Summer 2015
//
// Uses bank of delay lines to calculate delayed differences
// and bank of one-pole envelope followers (leaky integrators)
// Minimum bin is minimum difference, so most likely period.
// This one only tracks two octaves from 110 to 440 Hz,
//    and only looks at equal tempered (scale notes) delays.
// So all pitches above that will get folded into these octaves,
//  and will be quantized to scale pitches.
// You could expand this to arbitrary notes, or arbitrary
// pitch accuracy (or arbitrary scales).
//
//  NOTE:  Wear headphones or turn speaker down, else it
//   might just hear the sine and detect that as pitch.

110.0 => float LOW_PITCH;
440.0 => float HIGH_PITCH;
24 => int NUM_BINS;
DelayL d[NUM_BINS];   // this is delay/lag
FullRect f[NUM_BINS]; //  this is magnitude
OnePole p[NUM_BINS];  //  this is average
Gain out[NUM_BINS];   // this does difference
1.0 / LOW_PITCH => float pdelay;

// Low-pass filter first, to help us out
adc => LPF l1 => LPF l2 => LPF l3 => Gain input;
2 * HIGH_PITCH => l1.freq => l2.freq => l3.freq;
1.0 => l1.Q => l2.Q => l3.Q;

adc => OnePole power => blackhole;  // squarer and one-pole
adc => power; 3 => power.op; 0.999 => power.pole; // attack/decay time

1.0 => power.gain; // hack these to whatever you like
1.0 => input.gain;

["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"]
 @=> string noteNames[];

int i;

for (0 => i; i < NUM_BINS; 1 +=> i)   {
    input => d[i] => out[i] => f[i] => p[i] => blackhole;
    -1.0 => d[i].gain;		// Difference function,
    input => out[i] => f[i];	// input minus delayed 
    f[i] => p[i];
    3 => p[i].op;		// envelope follower, double chuck + mult
    0.999 => p[i].pole;		// response time/decay
    pdelay :: second => d[i].max => d[i].delay;	// set delay = period
    <<< noteNames[i % 12], 44100.0 * pdelay >>>;
    pdelay / 1.059463 => pdelay; // next half step up in delay
}

SinOsc s => dac;  // we can use this to track our "pitch"

while (1)	{
    0.05 :: second => now;
    10000000 => float min; // set it to something absurd
    0 => int minBin;       // use this to keep track of minimum
    for (0 => i; i < NUM_BINS; 1 +=> i)   { // then search for least
        if (p[i].last() < min) {
	        p[i].last() => min;
    	    i => minBin;
        }
    }
    
    Math.sqrt(power.last()) => s.gain; // control our sine oscillator
    (44100.0 :: samp) / d[minBin].delay() => float freq => s.freq;
    
    <<< (44100.0 :: samp) / d[minBin].delay(), noteNames[minBin % 12], min >>>;
}
