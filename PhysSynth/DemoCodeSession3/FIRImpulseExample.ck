//  FIR FILTER Example, arbitrary gain coefficients
//    by Perry R. Cook, 2015
Impulse imp => FIR firFilt => dac;
firFilt.order(10);  // Can be any order
firFilt.coeff(0, 1.0); // zero delay (input)
firFilt.coeff(1, 0.5); // one delay gain
firFilt.coeff(2,-1.0); // etc.
firFilt.coeff(3, 0.25); //     etc.
firFilt.coeff(4, 0.3);    //      etc.
firFilt.coeff(5, 1.0);
firFilt.coeff(6, 0.4); //   you can set these to anything!
firFilt.coeff(7,-0.4);
firFilt.coeff(8, 0.9);
firFilt.coeff(9, 1.0);
firFilt.gain(2.0);     // might need to adjust this so you don't clip

0.2 :: second => now; // hang out a bit, then

1.0 => imp.next;    // put a 1.0 into the filter for one sample

second => now;        // let 'er rip

