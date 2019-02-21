// Harmonic (odd) Triangle wave synthesis
//   by Perry R. Cook, Summer 2015

class DecaySine extends Chubgraph {
    SinOsc s => ExpEnv e => outlet;
    fun void freq(float freq) { freq => s.freq; }
    fun void T60(dur tsixty) { tsixty => e.T60; }
    fun void keyOn() { 1 => e.keyOn; }
}

DecaySine s[20];

[1.0, 0, -1.0/9, 0, 1.0/25, 0, -1.0/49, 0, 
1.0/81, 0, -1.0/121, 0, 1.0/169, 0, -1.0/225, 0,
1.0/289, 0, -1.0/361,0.0] @=> float harms[];

Gain mix => dac;
0.3 => mix.gain;

for (int i; i < 20; i++)  {
    s[i] => mix;
    440.0 * (i+1) => s[i].freq;
    (3.0-(i*0.01))::second => s[i].T60;
    harms[i] => s[i].gain;
    s[i].keyOn();
}

3*second => now;

