//   RissetBeats.ck
/*  First done by Jean Claude Risset at Bell Labs  */
// He discusses this and much more in a seminal article:
//   "Computer Music: Why?" WERGO 2033-2, 1985
//           ( Google could help you find this )
//
// ChucK Version, 2015 by P. Cook
// for Kadenze/Stanford/CCRMA
// Physics-Based Sound Synthesis/DSP Course
//
//   YOUR COMMENTS AND THOUGHTS HERE

BlitSaw s[7];       // Make a bank of "Saw" Oscillators
Gain mix => dac;   // mixer for output gain control
1.0/7.0 => mix.gain;  // make sure total output < 1.0

for (int i; i < 7; i++)  {     // set up all of the oscillators
    7 => s[i].harmonics;       // number of harmonics to build saw wave
    s[i] => mix;               // connect to dac
    <<< (100.0+(0.1*i)) => s[i].freq >>>; // set frequencies to 100, 100.1, etc.
}

// Your job:   Change one (or more) base frequency(s) here
//  a little, hear the result, think, discuss...
//   YOUR COMMENTS AND THOUGHTS HERE
//    xxx.x => s[2].freq;  // as an example...
<<<300.0 => s[1].freq>>>;
20.0 :: second => now;

//   END
