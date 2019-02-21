// Modal resyntheis with Residual Excitation
ResonZ modes[10];

[[301.464844, 0.500000],
[1663.439941, 0.783628],
[872.094727, 0.550664],
[2629.742432, 0.716552],
[3754.852295, 0.231353],
[263.781738, 0.049661],
[2651.275635, 0.012272],
[2605.517578, 0.006010],
[1684.973145, 0.009122],
[6395.361328, 0.053011]] @=> float freqsNamps[][];

SndBuf residue => Gain direct => dac;
Gain thruModes => dac;
"BowlResidue.wav" => residue.read;
80.0 => thruModes.gain;
1.0 => direct.gain;

for (int i; i < 10; i++)  {
    residue => modes[i] => thruModes;
    freqsNamps[i][0] => modes[i].freq;
    3000 => modes[i].Q;
    freqsNamps[i][1] => modes[i].gain;
}

while (true)  {
   for (int i; i < 10; i++)  {
        Math.random2f(freqsNamps[i][1]/2,2*freqsNamps[i][1]) => modes[i].gain;
   }
   1 => modes[2].gain;
   Math.random2f(600,1200) => modes[2].freq;
   0 => residue.pos;
   (Math.random2f(1,3)*0.3)::second => now;
}
