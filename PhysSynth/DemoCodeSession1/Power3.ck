// Cheaper near-power calculator in ChucK.
//    by Perry R. Cook, Summer 2015
//  This version does a running sum of squared samples.
//   But it uses UGens, so much cheaper than Power2.ck
//  The OnePole acts as a "leaky integrator" (sum).
//  More on that in later sessions, when we get to Digital Filters)

adc => OnePole power => blackhole;  // squarer and one-pole
adc => power; 3 => power.op; 0.999 => power.pole; // attack/decay time
50 => power.gain; // hack this to whatever you like

4410 => int FRAME; // how often to check/print power

while (true)  {
    FRAME::samp => now;  // only wake up every FRAME samples
    if (power.last() > 0.001)  { // and you can hack this too
        <<< "LOUD!!!",power.last(), "LOUD!!!" >>>;
    }
    else {
        <<< "Power =",power.last() >>>;
    }    
}
