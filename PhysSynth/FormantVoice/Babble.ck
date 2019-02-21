// Silly demo program to do Random Child Babbling using
//   FormantVoice vocal model.  
//   by Perry R. Cook, September 2015
// Headsize set small for child-like formants
//  Phonemes and pitch vary randomly.  Shows how to access 
//  random phonemes (or specific ones using "name" from 
//  the various phoneme types of FormantVoice:
//  vowelNames,liquidNames, stopNames, voicedFricNames // pitched 
//  fricativeNames, plosiveNames // unpitched

FormantVoice fv => dac;
0.7 => fv.headSize;      // set small head size
0.999 => fv.pitchSmooth; // set pitch smoothing more speech-like (really slow)

while (true)  {
    // first pick a consonant 
    Math.random2(0,4) => int type;  // of some type
    if (type==0) { // fricative: fff, sss, shh, etc.
        randomPhoneme(fv,fv.fricativeNames, 40::ms); // you could change time
    }
    else if (type==1) { // voiced fricative: vvv, zzz, etc.
        randomPhoneme(fv, fv.voicedFricNames, 110::ms); // you could change time
    }
    else if (type==2) { // liquid consonant: mmm, nnn, lll, rrr, nng
        randomPhoneme(fv, fv.liquidNames, 120::ms); // you could change time
    }
    else if (type==3) { // plosives: ppp, ttt, kkk, etc.
        randomPhoneme(fv, fv.plosiveNames, 20::ms); // you could change time
    }
    else if (type==3) { // stops: bbb, ddd, ggg, etc.
        randomPhoneme(fv, fv.stopNames,100::ms); // you could change time
    }
    
    // then pick a new pitch
    Math.random2f(150,400) => fv.pitch; // new pitch
    
    // and pick a vowel to hang out on
    randomPhoneme(fv,fv.vowelNames, Math.random2(200,600)::ms); // you could change time
    
    // then decide whether to end word or not
    if (Math.random2(0,4)==0) {
        <<< "Silent for a bit!", "" >>>;
        fv.quiet(Math.random2(100,400)::ms);
    }
}

fun string randomPhoneme(FormantVoice f, string array[], dur wait) {
    Math.random2(0,array.cap()-1) => int which;
    <<< "It's: ", array[which], wait/second >>>;
    f.setPhoneme(array[which]);
    wait => now;
    return array[which];
}