//  Simple Fourier Additive Plucked String
//   Perry R. Cook  2015
//  Pluck is all harmonics, 1/Harmonic# gains
//    (yielding a ramp with peak at one end)

//   Single, exponentially decaying sine wave
class DecaySine extends Chubgraph {
    SinOsc s => Gain mul => outlet;
    Impulse ex => OnePole env => mul;
    3 => mul.op; // set to multiply
    fun void freq(float freq) { freq => s.freq; }
    fun void T60(dur tsixty) { 
        Math.pow(10.0,-3.0/(tsixty/samp)) => env.pole;
        //        <<< env.pole() >>>;
        0.1 => env.b0;
    }
    fun void keyOn() { 1.0 => ex.next; }
}

DecaySine s[20];

for (int i; i < 20; i++)  {
    s[i] => dac;
    247.0 * (i+1) => s[i].freq;
    (3.0-(i*0.1))::second => s[i].T60;
    0.5/(1+i) => s[i].gain;
    s[i].keyOn();
}

3*second => now;

