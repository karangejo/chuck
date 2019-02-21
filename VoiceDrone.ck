VoicForm voice => JCRev rev => dac;

0.2 => rev.mix;
85 => voice.freq;
.1 => voice.vibratoFreq;
.5 => voice.vibratoGain;

while(true){
  voice.phoneme("ohh");
  85 => voice.freq;
  //<<<1>>>;
 1::second => now;
//  voice.phoneme("eee");
//  85 => voice.freq;
//  <<<2>>>;
//  .5::second => now;
//  voice.phoneme("aaa");
//  85 => voice.freq;
//  <<<3>>>;
//  .5::second => now;
}
