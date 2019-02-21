// Super simple instantaneous power calculator in ChucK.
//    by Perry R. Cook, Summer 2015
//  This version only operates on one sample each "frame",
// so really it's a sparse peak-squared-signal detector.

adc => Gain squarer => blackhole;  
adc => squarer;                  // connect twice and then
3 => squarer.op;                 // set it to multiply (square)

while (true)  {
    ms => now;
    squarer.last() => float power;
    if (power > 0.003) {   //  Adjust this to taste
        <<< "LOUD!!!",power, "LOUD!!!" >>>;
    }
    else {
        <<< "Power =", power >>>;
    }        
}
