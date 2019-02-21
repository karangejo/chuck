//  Additive Synthesis Demo for 
//  theoretical modes of square plate
//  Perry R. Cook, 2015

28 => int NUM_MODES;
440.0 => float BASEFREQ;

[[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],
 [2,2],[2,3],[2,4],[2,5],[2,6],[2,7],
 [3,3],[3,4],[3,5],[3,6],[3,7],
 [4,4],[4,5],[4,6],[4,7],
 [5,5],[5,6],[5,7],
 [6,6],[6,7],
 [7,7]] @=> int modes[][];

Impulse imp;
ResonZ mode[NUM_MODES];

for (int i;i<NUM_MODES;i++)   {
   500 => mode[i].Q;
   imp => mode[i] => dac;
   1000.0 / (i+1) => mode[i].gain;
}

while (true)  {
    setFreqs(Math.random2f(220.0,880.0));
    1.0 => imp.next;
    second => now;
}

fun void setFreqs(float freq)  {
    for (int i;i<NUM_MODES;i++)   {
        freq * Math.sqrt(modes[i][0]*modes[i][0] +
                            modes[i][1]*modes[i][1]) => mode[i].freq;
    }
}


