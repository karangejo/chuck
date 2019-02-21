// Improved Karplus Strong Plucked String Synthesis Model
//    by Perry R. Cook, July 2015
// Noise into feedback delay (collapsed Left/Right waveguide),
// with 3-pt FIR lowpass loop filter (brightness)

class KarplusStrong2 extends Chubgraph {
    Noise n => ADSR plk => DelayA strng => TwoZero loop => dac;
    loop => strng;
    10.0 => float sust; // in seconds
    0.5 => float brite; // 0.0 to 1.0
    330.0 => float frq;
    
    second/50 => strng.max; // 50 Hz lowest frequency
    
    fun void freq(float frequency)  {
        frequency => frq;
        ((second / samp) / frequency - 1) => float period;
        (ms,period::samp,0.0,ms) => plk.set;
        period::samp => strng.delay;        
    }
    
    fun void bright(float brightness)  {
        brightness => brite;
        loop.gain()*(1-brite)/4 => loop.b0;
        loop.gain()*(1-brite)/4 => loop.b2;
        loop.gain()*(1+brite)/2 => loop.b1;
    }
    
    fun void sustain(float aT60)  {
        aT60 => sust;
        Math.exp(-6.91/sust/frq) => loop.gain;
    }
    
    fun void pluck(float note, float velocity)  {
        Std.mtof(note) => freq;
        bright(brite); // reset parameters given delay length
        ((second / samp) / frq - 1) => float period;
        (ms,period::samp,0.0,ms) => plk.set;
        period::samp => strng.delay;
        velocity => n.gain;
        1 => plk.keyOn;
    }
}

KarplusStrong2 ks => dac;

0 => int i;

while (i++ < 10)  {
    i / 10.0 => float temp;
    temp => ks.bright;
    <<< "Brightness =",  temp >>>;
    ks.pluck(64, 0.7);
    second/2 => now;        
}
second => now;

0.5 => ks.bright; // moderate brightness
0 => i;

30.0 => float temp;

while (i++ < 10)  {
    temp => ks.sustain;
    2.0 /=> temp;
    <<< "Sustain (T60) =",  temp >>>;
    ks.pluck(56, 0.7);
    second => now;        
}

 
