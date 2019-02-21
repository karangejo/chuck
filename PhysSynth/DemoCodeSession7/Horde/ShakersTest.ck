//  The variety of PHISEM (Physically Inspired Stochastic Event Modeling)
//    by Perry R. Cook, (1996-)2015
//    This program puts the model through all the paces showing the
//    variety in the presets, and how to modify the parameters to get
//    even more variety.

Shakers s => dac;

["Maraca","Cabasa","Sekere","Tambourine","SleighBells","Sticks",
 "Crunch","SandPaper","CokeCan","Mug",    "Penny+Mug","Nickle+Mug",
 "Dime+Mug","Quarter+Mug","Franc+Mug","Peso+Mug","Stones","Pebbles"] 
      @=> string shakerPresets[];
[    0,      1,        2,         6,          7,          8,
    9,       11,      12,        13,          14,         15,
    16,           17,          18,        19,      20,       21] 
      @=> int shakerNUMs[]; // numbers for PHISEM shakers

for (int i; i < shakerPresets.cap(); i++)  {
    <<< "Preset", shakerNUMs[i], shakerPresets[i]>>>;
    <<< "Shake it", "Baby!!!">>>;
    shakerNUMs[i] => s.preset;
    for (int j; j < 9; j++)  {
        Math.random2f(0.6,1.0) => s.energy;
        0.15::second => now;
    }
    0.85::second => now;
    <<< "Now with minimal damping", "" >>>;
    1.0 => s.decay;
    1.0 => s.energy;
    second => now;
    <<< "Now with very few objects", "" >>>;
    2 => s.objects;
    1.0 => s.energy;
    second => now;
    <<< "Now with many objects", "" >>>;
    128 => s.objects;
    1.0 => s.energy;
    second => now;
    <<< "Now change the resonance frequency", "" >>>;
    shakerNUMs[i] => s.preset; // reset back to default settings
    for (int j; j < 10; j++)  {
        10.0 *Math.pow(2,j) => s.freq;
        Math.random2f(0.6,1.0) => s.energy;
        0.25::second => now;
    }
    <<< "OK, on to the next preset...", "*******************" >>>;
    second => now;
}

["Guiro","Wrench"] @=> string ratchetPresets[];
[   3,      10] @=> int ratchetNUMs[];  // numbers for ratchets

for (int i; i < ratchetPresets.cap(); i++)  {
    <<< "Preset", ratchetNUMs[i], ratchetPresets[i]>>>;
    <<< "Scrape/Twist", "Baby!!!">>>;
    ratchetNUMs[i] => s.preset;
    0.1 => s.decay; // set 
    for (int j; j < 30; j++)  {
        1 => s.energy;
        Math.random2f(0.03,0.05)::second => now;
    }
    for (int j; j < 10; j++)  {
        1 => s.energy;
        Math.random2f(0.05,0.2)::second => now;
    }
    <<< "Move frequency around", "" >>>;
    for (int j; j < 16; j++)  {
        Math.random2f(10.0,5000) => s.freq;
        1 => s.energy;
        Math.random2f(0.1,0.2)::second => now;
    }
    second => now;
}

["BambooChimes","TunedBamboo"] @=> string tinklePresets[];
[      5,            22      ] @=> int tinkleNUMs[];  // tinkle numbers

for (int i; i < tinklePresets.cap(); i++)  {
    <<< "Preset", tinkleNUMs[i], tinklePresets[i]>>>;
    <<< "Water drops and Windchimes", "">>>;
    <<< "Shake it", "Baby!!!">>>;
    tinkleNUMs[i] => s.preset;
    1 => s.energy;
    2*second => now;
    <<< "Now with minimal damping", "" >>>;
    1.0 => s.decay => s.energy;
    2*second => now;
    <<< "Now with very few objects", "" >>>;
    2 => s.objects;
    1.0 => s.energy;
    2*second => now;
    <<< "Now with many objects", "" >>>;
    128 => s.objects;
    1.0 => s.energy;
    second => now;
    <<< "Now change the resonance frequency", "" >>>;
    tinkleNUMs[i] => s.preset; // reset back to default settings
    for (int j; j < 10; j++)  {
        10.0 *Math.pow(2,j) => s.freq;
        Math.random2f(0.6,1.0) => s.energy;
        0.25::second => now;
     }
     second => now;
     <<< "OK, on to the next preset...", "*******************" >>>;
}
