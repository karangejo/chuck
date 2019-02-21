//  Inharmonic (six total) sine mode synthesis
//   by Perry R. Cook, Summer 2015
//  Superseded by SineSynth.ck for Assignment 2, PongSynth2

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

//  Our glass as analyzed in class
class ClinkGlass extends Chubgraph {
    DecaySine s[6];
    Gain mix => dac;
    0.3 => mix.gain;
    [754.0, 2938, 3628, 5642, 7816, 9388] @=> float freqs[];
    [0.7, 0.8, 1.0, 0.5, 0.3, 0.1] @=> float gains[];
    for (int i; i < 6; i++)  {
        s[i] => mix;
        freqs[i] => s[i].freq;
        (2.0-(i*0.2))::second => s[i].T60;
        gains[i] => s[i].gain;
    }
    fun void whackIt()  {
        for (int i; i < 6; i++)  {
            s[i].keyOn();
        }
    }
}

ClinkGlass clink;

clink.whackIt();

3*second => now;

