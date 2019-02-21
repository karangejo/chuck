//  Taking the Blown Bottle through the paces
//   by Perry R. Cook, 2015

BlowBotl botl => dac;

1 => botl.startBlowing;
second => now;
0.7 => botl.vibratoGain;
second => now;
0.0 => botl.vibratoGain;

while (1)  {
    1 => botl.noteOff;
    second/2 => now;
    Math.random2(54,90) => Std.mtof => botl.freq;
    Math.random2f(0.0,0.7) => botl.noiseGain;
    1 => botl.noteOn;    
    second => now;
}
 
