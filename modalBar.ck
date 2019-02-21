ModalBar perc => JCRev rev => dac;

0.2 => rev.mix;
while(true){
    6 => perc.preset;
    1 => perc.strike;
    Math.random2(0,128) => Std.mtof => perc.freq;
    1::second => now;

}
