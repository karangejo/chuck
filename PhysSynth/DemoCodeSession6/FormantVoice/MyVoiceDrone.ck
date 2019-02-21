Machine.add(me.dir()+"FormantVoice.ck");

FormantVoice fv => JCRev rev => dac;
 0.1=> rev.mix;

fv.setPhoneme("ooo");
85 => fv.ptch;
.1 => fv.vibFreq;
.5 => fv.vibrato;
 //1 => fv.pitchSmooth;
1 => fv.formSmooth;
1=> fv.headSize;

while(true){
  3::second => now;
  fv.setPhoneme("mmm");
  1::second => now;
  fv.vowelNames[(Math.random2(1,10) -1)] => string vowel;
  Math.random2f(50.0,90.0) => float frek;
  Math.random2f(0.8,1.9) => float head;
  <<<vowel," ", frek, " ", head>>>;
  head => fv.headSize;
  fv.setPhoneme(vowel);
  frek => fv.ptch;

}
