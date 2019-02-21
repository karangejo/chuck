Shakers shak => JCRev rev => dac;

0.2 => rev.mix;

while(true){
    3 => shak.preset;
    //Math.random2f(0.5,1.0) => shak.energy;
    //Math.random2f(600,2000) => shak.freq;
    //Math.random2f(10.9,128.0)
    //128 => shak.objects;
    //Math.random2f(0.1,1.0) => shak.decay;
    1 => shak.decay;
    1 => shak.energy;
    1::second => now;
}
