//  AdditiveHarmonicSynth.ck, by Perry R. Cook, Summer 2015
//  Companion synthesizer to the Processing Fourier
//   additive harmonic program FourierHarmString.pde
//  Run both of these, and you'll hear what's going
//   on as you make changes in the GUI program

//  NOTE:  Run this first, either in command line, or miniAudicle

20 => int samax;
220 => float FUNDAMENTAL;

SinOsc s[samax];
float harms[samax];

OscIn oin;  OscIn oinSetup;  12000 => oin.port;  12000 => oinSetup.port;
OscMsg msg;
oin.addAddress( "/Harms" );
oinSetup.addAddress( "/Order" );

1 => int notDone;

spork ~oscSetup();
spork ~ oscListenBlock();

Gain mix => dac;

0.3 => mix.gain;

for (int i; i < samax; i++)  {
    s[i] => mix;
    FUNDAMENTAL*(i+1) => s[i].freq;
    0.0 => s[i].gain;
}

while (notDone)  {
    second => now;
}

fun void oscSetup()  {
    while (notDone)  {
        oinSetup => now;
        while (oinSetup.recv(msg) != 0)   {
            // peel off integer
            msg.getInt(0) => int order;
            order => samax;
<<< "New Order=",order >>>;
            if (order <= 0) {
		0 => notDone;
		<<< "We done!!", "Buh Bye" >>>;
	    }
        }
    }
}
    
fun void oscListenBlock()  {
    while (notDone)  {
        oin => now;
        while (oin.recv(msg) != 0)   {
            // peel off integer, float
//            msg.getInt(0) => int ptr;
            for (int i; i < samax; i++)  {
                msg.getFloat(i) => float value;
                value => harms[i] => s[i].gain;
            }
        }
    }
}

