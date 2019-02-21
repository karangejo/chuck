// Silly demo program to sing "Bicycle built for two" song using
//  FormantVoice vocal model.  Shout out to Max Mathews, John Kelly 
//  and Carol Lochbaum, Arthur C. Clarke, and Stanley Kubrick
//   by Perry R. Cook, September 2015

FormantVoice fv => dac;

[44,41,37,32,34,36,37,34,37,32] @=> int notes[];

1.25 => fv.headSize; // make larger than life

Daisy(fv,notes[0],notes[1]);  // brute force, but pretty cool!
fv.quiet(400::ms);
0.03 => fv.vibrato; // bring in some vibrato
Daisy(fv,notes[2],notes[3]);
fv.quiet(400::ms);
0.0 => fv.vibrato; // turn off vibrato
Give(fv,notes[4]);
Me(fv,notes[5]);
Your(fv,notes[6]);
Answer(fv,notes[7],notes[8]);
0.04 => fv.vibrato; // bring vibrato back up
Do(fv,notes[9]);
second => now;

fun void Daisy(FormantVoice fmv, int note1, int note2)  {
    <<< "Daisy ", note1, note2 >>>;
    note1 => Std.mtof => fmv.pitchNow;
    fmv.setPhoneme("ehh");  // preset upper formants
    fmv.formantsNow(fmv.f[0],fmv.f[1],fmv.f[2]); // don't mess around
    fmv.setPhoneme("ddd"); fmv.formantsNow(fmv.f[0],fmv.f[1],fmv.f[2]); // don't mess around
    30::ms => now; 
    fmv.setPhoneme("ehh"); 
    600::ms => now;

    fmv.setPhoneme("zzz"); 
    200::ms => now;
    note2 => Std.mtof => fmv.pitch; 
    fmv.setPhoneme("eee"); 
    600::ms => now;
}

fun void Give(FormantVoice fmv, int note)  {
    <<< "Give ", note >>>;
    fmv.setPhoneme("ggg");
    100::ms => now;
    note => Std.mtof => fmv.pitch;
    fmv.setPhoneme("ihh");
    300::ms => now;
    fmv.setPhoneme("vvv");
    100::ms => now;
}

fun void Me(FormantVoice fmv, int note)  {
    <<< "Me ", note >>>;
    fmv.setPhoneme("mmm");
    100::ms => now;
    note => Std.mtof => fmv.pitch;
    fmv.setPhoneme("eee"); 
    300::ms => now;
}   

fun void Your(FormantVoice fmv, int note)  {
    <<< "Your ", note >>>;
    fmv.setPhoneme("eee");
    100::ms => now;
    note => Std.mtof => fmv.pitch;
    fmv.setPhoneme("ohh"); 
    400::ms => now;
    fmv.setPhoneme("rrr");
    100::ms => now;
}  

fun void Answer(FormantVoice fmv, int note1, int note2)  {
    <<< "Answer ", note1, note2 >>>;
    note1 => Std.mtof => fmv.pitch;
    fmv.setPhoneme("aah");
    700::ms => now;
    fmv.setPhoneme("nnn");
    100::ms => now;
    fmv.setPhoneme("sss");
    100::ms => now;
    note2 => Std.mtof => fmv.pitch;
    fmv.setPhoneme("rrr");
    400::ms => now;
}

fun void Do(FormantVoice fmv, int note)  {
    <<< "Do ", note >>>;
    fmv.setPhoneme("ddd");
    200::ms => now;
    note => Std.mtof => fmv.pitch;
    fmv.setPhoneme("ooo"); 
    500::ms => now;
}   

fun void Shaddap(FormantVoice fmv, dur howLong)  {
    0.0 => fmv.voiced => fmv.unVoiced => fmv.consonant;
    howLong => now;
}
