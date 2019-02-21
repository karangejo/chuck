// Actual power calculator in ChucK.
//    by Perry R. Cook, Summer 2015
//  This version does a running sum of squared samples.
//   But it calculates each sample, so it's fairly CPU-hungry.
//   There's a better (much cheaper) way (see Power3 and ZCPitch)

adc => blackhole;
4410 => int FRAME; // how often to check/print power
0 => int counter;  // keep track of how many samples
0.0 => float power; // running sum of power

while (true)  {
    samp => now;                     // don't miss any samples
    adc.last()*adc.last() +=> power; // running sum of squares (power)
    if (++counter == FRAME) {  // increment and check sample counter
        power / FRAME => power; // normalize to get average per-sample power
        if (power > 0.001)  {
            <<< "LOUD!!!",power, "LOUD!!!" >>>;
        }
        else {
            <<< "Power =",power >>>;
        }
        0 => counter => power; // reset everybody to start over
    }        
}
