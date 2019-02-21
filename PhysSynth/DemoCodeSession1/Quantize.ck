// Quantization demo, by Perry R. Cook, Summer 2015

//  CAUTION!!!!  Feedback potential, wear headphones 
//     or turn mic way down until you get the gain right.

adc => Gain inp => blackhole; // be sure you have mic input set up right
Step outp => dac; // last link in the chain

// SET THIS INTEGER TO THE # Bits you
7 => int QUANTIZE; // desire for quantization

Math.pow(2.0,QUANTIZE) => float NORM; // calculated automatically

while (true)  {
    Std.ftoi(NORM*inp.last()) => int temp; // stash in integer, then
    (temp*1.0) / NORM => outp.next;       // convert back to quantize
    samp => now;                          // Do this every sample
}

