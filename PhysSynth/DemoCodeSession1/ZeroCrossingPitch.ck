//  Zero Crossing based pitch detector
//  Perry Cook, created in 2007, last revised, Summer 2015
//  for CCRMA/Kadenze Physics-Based DSP Course
//  This one uses the ZeroX UG and OnePole for efficiency
//  Some bells and whistles, and controls a SinOsc
//
//  NOTE:  Wear headphones or turn speaker down, else it
//   might just hear the sine and detect that as pitch.

adc => ZeroX z => FullRect f => OnePole p => blackhole;	// basic patch
-1.0 => p.a1; 		// This is dangerous, 
1.0 => p.b0; 		// but we know what we're doing :-)
100.0 => float lowest; 	// Lower limit on our pitch estimate
500.0 => float highest;	// Upper limit on our pitch estimate
0.0 => float myZeroes;	// This holds the last zero crossing count


adc => OnePole power => blackhole;  // squarer and one-pole
adc => power; 3 => power.op; 0.999 => power.pole; // attack/decay time

SinOsc s => dac;  // our "synthesizer" to track pitch

spork ~ ZC(0.040); // run zero crossings in side-shred

float freq;

while (true)	{
    0.04 :: second => now;	// hang out
    myZeroes/0.04/2 => freq;	// frequency=#zero pairs per window (we hope)
    <<< "Power=", power.last(), "    Frequency=", freq >>>;
	freq => s.freq; 	             // control our 
    Math.sqrt(power.last()) => s.gain; // sine oscillator
}

fun void ZC(float howoften)	{
    howoften*44100 - 1 => float wait;
    while (1)	{
	wait :: samp => now;	// hang out counting
	p.last() => myZeroes;	// save count
	0.0 => p.a1;		// Clear 
	0.0 => p.b0;		//   our
	1 :: samp => now;	//     counter
	-1.0 => p.a1;		// Start counting
	1.0 => p.b0;		//   again
    }
}
    
