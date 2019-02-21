// Silly demo program to say "ChucK" using FormantVoice vocal model.  
//   by Perry R. Cook, September 2015
// Headsize and pitch vary randomly.  Sometimes it 
//  sounds like "ChucK"  Sometimes not so much.

FormantVoice fv => dac;

ChucK(fv,140);
fv.quiet(second);

while (true)  {
    Math.random2f(0.6,1.5) => float temp; // scale head size randomly
    temp => fv.headSize;
    250/temp/temp => float pitch;  // scale pitch, but by more
    <<< "Head size =", temp, "Pitch =", pitch >>>;
    ChucK(fv,pitch);  // brute force, but pretty cool!
    fv.quiet(second/2);
}

fun void ChucK(FormantVoice fmv, float pitch)  {
    pitch => fmv.pitchNow;
    fmv.setPhoneme("shh"); // short shh is a "ch" sound
    20::ms => now; 
    fmv.setPhoneme("ahh"); 
    pitch/2.0 => float targ;
    while (pitch > targ)  {
        10::ms => now;
        0.98 *=> pitch;
        pitch => fmv.pitch;
    }
    fmv.setPhoneme("kkk"); 
    30::ms => now;
}
