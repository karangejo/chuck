FormantVoice fv => JCRev rev=> dac;
FormantVoice fv2 => rev;
0.2 => rev.mix;

["ppp","ttt","kkk","koo"] @=> string plos[]; // plosives
["bbb","ddd","ggg"] @=> string vplos[]; // stops
["djj","vvv","zzz","tzz","zhh","gxx"] @=> string vfric[]; // voiced fricatives
["fff","sss","thh","shh","cxh","xxx","hee","hah","hoo"] @=> string fric[]; // fricatives
["rrr","lll","mmm","nnn","nng"] @=> string liq[];
["ahh","ehh","eee","ohh","ooo"] @=> string vowels[];

["bbb","ddd","ggg","rrr","lll","mmm","nnn","nng"] @=> string all[];


spork ~ singVowelConsLoop(all,fv,2000,200,40);


while(true){1::second=> now;}

//sing one consonant and then vowel
fun void singConsVowel(string cons[],FormantVoice voice,int msVowel, int msCons, int midiPitch){
  Math.random2(0,cons.cap()-1) => int chooseCons;
  voice.setPhoneme(cons[chooseCons]);
  msCons::ms => now;
  Math.random2(0,vowels.cap()-1) => int chooseVowel;
  voice.setPhoneme(vowels[chooseVowel]);
  midiPitch => Std.mtof => voice.pitch;
  <<<cons[chooseCons]," ",vowels[chooseVowel]>>>;
  msVowel::ms => now;
  voice.quiet(10::ms);
}

//sing one Vowel and then consonant
fun void singVowelCons(string endCons[],FormantVoice voice, int msVowel, int msCons,int midiPitch){
  Math.random2(0,vowels.cap()-1)=> int chooseVowel;
  voice.setPhoneme(vowels[chooseVowel]);
  midiPitch => Std.mtof => voice.pitch;
  msVowel::ms => now;
  Math.random2(0,endCons.cap()-1) => int chooseCons;
  voice.setPhoneme(endCons[chooseCons]);
  <<<vowels[chooseVowel]," ",endCons[chooseCons]>>>;
  msCons::ms => now;
  voice.quiet(10::ms);
}

//sing consonant then vowel
fun void singConsVowelLoop(string cons[],FormantVoice voice, int msVowel, int msCons,int midiPitch){
  while(true){
    Math.random2(0,cons.cap()-1) => int chooseCons;
    voice.setPhoneme(cons[chooseCons]);
    msCons::ms => now;
    Math.random2(0,vowels.cap()-1) => int chooseVowel;
    voice.setPhoneme(vowels[chooseVowel]);
    midiPitch => Std.mtof => voice.pitch;
    <<<cons[chooseCons]," ",vowels[chooseVowel]>>>;
    msVowel::ms => now;
    voice.quiet(10::ms);
  }
}

// sing vowel then consonant
fun void singVowelConsLoop(string endCons[],FormantVoice voice, int msVowel, int msCons,int midiPitch){
  while(true){
    Math.random2(0,vowels.cap()-1)=> int chooseVowel;
    voice.setPhoneme(vowels[chooseVowel]);
    midiPitch => Std.mtof => voice.pitch;
    msVowel::ms => now;
    Math.random2(0,endCons.cap()-1) => int chooseCons;
    voice.setPhoneme(endCons[chooseCons]);
    <<<vowels[chooseVowel]," ",endCons[chooseCons]>>>;
    msCons::ms => now;
    voice.quiet(10::ms);
  }
}
