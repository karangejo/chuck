//  Formant Resonances dissected
//    by Perry R. Cook, August 2015
//  Note:  These aren't FOFs, but rather 
//  actual formant filter impulse responses.
//   All we would need do would be record each formant impulse
//   response, and play them back using SndBuf or other, and then
//   they'd be true FOFs.  The result is the same. 

Impulse imp[3];
ResonZ f[3];
for (int i; i < 3; i++)  {
   imp[i] => f[i] => dac;
   40 => f[i].Q;
}
50 => f[0].gain;
30 => f[1].gain;
10 => f[2].gain;

[[730.0,1090.0,2440.0],
 [270.0,2290.0,3010.0],
[300.0, 870.0, 2240.0]
] @=> float aaheeeooo[][];

["Ahh","Eee","Ooo"] @=> string names[];

<<< "One Pop of Ahh:", aaheeeooo[0][0], aaheeeooo[0][1], aaheeeooo[0][2] >>>; 
loadVowel(0);
popAll(); second/2 => now;
2*second => now;

for (int i; i < 3; i++)  {
    loadVowel(i);
    <<< "Now synthesizing each formant of", names[i] >>>;
    <<< "First formant:", aaheeeooo[i][0] >>>;
    popOne(0); second/2 => now; 
    popOne(0); second/2 => now;
    popOne(0); second => now;
    <<< "Second formant:", aaheeeooo[i][1] >>>;
    popOne(1); second/2 => now; 
    popOne(1); second/2 => now;
    popOne(1); second => now;
    <<< "Third formant:", aaheeeooo[i][2] >>>;
    popOne(2); second/2 => now;
    popOne(2); second/2 => now;
    popOne(2); second => now;
    <<< "Now, all Formants for", names[i] >>>;
    popAll(); second/2 => now;  
    popAll(); second/2 => now;
    popAll(); second/2 => now;
    2*second => now;
}

10*ms => dur T => dur TTarg;
spork ~ smoothPitch();

while (true)  {
    popAll();
    T => now;
    if (Math.random2(0,40) == 0) {
        Math.random2f(6,20)::ms => TTarg;
        Math.random2(0,2) => int temp;
        loadVowel(temp);
        <<< "Singing", names[temp] >>>;
    }
}

fun void smoothPitch()  {
    while (true)   {
        T*0.99 + TTarg*0.01 => T;
        ms => now;
    }
}

fun void loadVowel(int which)  {
    aaheeeooo[which][0] => f[0].freq;
    aaheeeooo[which][1] => f[1].freq;
    aaheeeooo[which][2] => f[2].freq;
}

fun void popOne(int which)  {
    1 => imp[which].next;
}

fun void popAll()  {
    popOne(0);
    popOne(1);
    popOne(2);
}
