// Applause by using only one clap sound.

Gain g => NRev r => dac;    		 // gain into Reverb into Audio Out
0.06 => r.mix;                   	// amount of reverb

100 => int MAX;			// make 100 wave players

SndBuf claps[MAX];
float rates[MAX];
float pitches[MAX];

int i;											// iterator variable 

for (int i; i < MAX ; i++)      {		// run through all clappers
    "Clap.wav" => claps[i].read;		// load the sound file
    claps[i] => g;				// connect them to the mixer
    claps[i].samples() => claps[i].pos;
    Std.rand2f(0.2,0.5) => rates[i];  // pick a clapping tempo
    Std.rand2f(0.7,1.4) => pitches[i]; // pick a resonant frequency
    spork ~ clapper(i);			// and tell them to start clapping
}

fun void clapper(int which) 	{
    while (1)   {							// clap forever
        rates[which] * Std.rand2f(0.9,2.1) :: second => now; // rand. period
        Std.rand2f(0.4, 1.0) => claps[which].gain;       // random gain
        pitches[which] * Std.rand2f(0.85,1.15) => claps[which].rate; // rand. pitch
        0 => claps[which].pos;                        	 // trigger wave
    }
}

while (1) 1.0 :: second => now;					
