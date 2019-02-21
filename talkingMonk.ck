public class TalkingMonk{
  FormantVoice voice => JCRev rev=> dac;
//  FormantVoice fv2 => rev;
  0.2 => rev.mix;

  ["ppp","ttt","kkk","koo"] @=> string plos[]; // plosives
  ["bbb","ddd","ggg"] @=> string vplos[]; // stops
  ["djj","vvv","zzz","tzz","zhh","gxx"] @=> string vfric[]; // voiced fricatives
  ["fff","sss","thh","shh","cxh","xxx","hee","hah","hoo"] @=> string fric[]; // fricatives
  ["rrr","lll","mmm","nnn","nng"] @=> string liq[];
  ["ahh","ehh","eee","ohh","ooo"] @=> string vowels[];

  ["bbb","ddd","ggg","rrr","lll","mmm","nnn","nng"] @=> string all[];


  //spork ~ singVowelConsLoop(all,fv,2000,200,40);

  // please take into account there is 10::ms of voice silence after each silabel
  //while(true){1::second=> now;}

  //sing one consonant and then vowel
  fun void singConsVowel(string cons[],int msVowel, int msCons, int midiPitch){
    Math.random2(0,cons.cap()-1) => int chooseCons;
    voice.setPhoneme(cons[chooseCons]);
    msCons::ms => now;
    Math.random2(0,vowels.cap()-1) => int chooseVowel;
    voice.setPhoneme(vowels[chooseVowel]);
    midiPitch => Std.mtof => voice.pitch;
    <<<cons[chooseCons]," ",vowels[chooseVowel]>>>;
    msVowel::ms => now;
    //voice.quiet(10::ms);
  }

  //sing one Vowel and then consonant
  fun void singVowelCons(string endCons[], int msVowel, int msCons,int midiPitch){
    Math.random2(0,vowels.cap()-1)=> int chooseVowel;
    voice.setPhoneme(vowels[chooseVowel]);
    midiPitch => Std.mtof => voice.pitch;
    msVowel::ms => now;
    Math.random2(0,endCons.cap()-1) => int chooseCons;
    voice.setPhoneme(endCons[chooseCons]);
    <<<vowels[chooseVowel]," ",endCons[chooseCons]>>>;
    msCons::ms => now;
    //voice.quiet(10::ms);
  }

  //sing consonant then vowel
  fun void singConsVowelLoop(string cons[], int msVowel, int msCons,int midiPitch){
    while(true){
      Math.random2(0,cons.cap()-1) => int chooseCons;
      voice.setPhoneme(cons[chooseCons]);
      msCons::ms => now;
      Math.random2(0,vowels.cap()-1) => int chooseVowel;
      voice.setPhoneme(vowels[chooseVowel]);
      midiPitch => Std.mtof => voice.pitch;
      <<<cons[chooseCons]," ",vowels[chooseVowel]>>>;
      msVowel::ms => now;
      ///voice.quiet(10::ms);
    }
  }

  // sing vowel then consonant
  fun void singVowelConsLoop(string endCons[], int msVowel, int msCons,int midiPitch){
    while(true){
      Math.random2(0,vowels.cap()-1)=> int chooseVowel;
      voice.setPhoneme(vowels[chooseVowel]);
      midiPitch => Std.mtof => voice.pitch;
      msVowel::ms => now;
      Math.random2(0,endCons.cap()-1) => int chooseCons;
      voice.setPhoneme(endCons[chooseCons]);
      <<<vowels[chooseVowel]," ",endCons[chooseCons]>>>;
      msCons::ms => now;
      //voice.quiet(10::ms);
    }
  }

  fun void singRandomWalk(string cons[], int scale[],int startNoteI, int tempoInMS){
    WeightedRand random;
    [5,5,4,3,2] @=> int myWalkWeights[];
    random.setWeights(myWalkWeights);

    ((tempoInMS/10)*9)$int => int vowelMs;
    ((tempoInMS/10))$int => int consonantMs;

    startNoteI => int currentStep;
    singConsVowel(cons,vowelMs,consonantMs,scale[currentStep]);

    while(true){
      random.random() => int step;
      Math.random2(0,1) =>int sign;
      if(sign == 1){
        currentStep + step => currentStep;
      }
      if(sign == 0){
        currentStep - step => currentStep;
      }
      if(currentStep < 0){
        (scale.cap()/2)$int => currentStep;
      }
      if(currentStep > (scale.cap()-1)){
        (scale.cap()/2)$int => currentStep;
      }
        singConsVowel(cons,vowelMs,consonantMs,scale[currentStep]);
    }
  }

  fun void singRandomWalkMostlyUp(string cons[], int scale[],int startNoteI, int tempoInMS){
    WeightedRand random;
    [5,5,4,3,2] @=> int myWalkWeights[];
    random.setWeights(myWalkWeights);

    ((tempoInMS/10)*9)$int => int vowelMs;
    ((tempoInMS/10))$int => int consonantMs;

    startNoteI => int currentStep;
    singConsVowel(cons,vowelMs,consonantMs,scale[currentStep]);
     <<<"scale size is:",scale.cap()>>>;
    while(true){
      random.random() => int step;
      Math.random2(0,4) =>int sign;
      if(sign == 1){
        currentStep - step => currentStep;
      }else{
        currentStep + step => currentStep;
      }
      if(currentStep < 0){
        (scale.cap()/2)$int => currentStep;
      }
      if(currentStep > (scale.cap()-1)){
        (scale.cap()/2)$int => currentStep;
      }
      <<<"current step is:",currentStep>>>;
        singConsVowel(cons,vowelMs,consonantMs,scale[currentStep]);
    }
  }

}

//TalkingMonk monk;

//monk.singConsVowelLoop(monk.all,1000,100,35);
//
//Scalez Edorian;

//[0,2,3,5,7,9,10] @=> int dorian[];
//4 => int keyOfE;

//Edorian.makeScale(dorian,keyOfE);

//TalkingMonk monk;
//monk.singRandomWalk(monk.all,Edorian.myScale,29,100);
