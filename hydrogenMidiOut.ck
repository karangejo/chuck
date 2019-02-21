public class HydroOut{

  MidiOut hydroOut;
  MidiMsg msgHydroOut;

  18 => int port;

  if(!hydroOut.open(port)){
    <<<"ERROR!">>>;
    me.exit();
  }

  fun void sendHydro(int note, int velocity){
    144 => msgHydroOut.data1;
    note => msgHydroOut.data2;
    velocity => msgHydroOut.data3;
    hydroOut.send(msgHydroOut);
  }

  fun void playSequence(int sequence[],int note, int velocity, int tempoInMS){
    for(0=>int i;i<sequence.cap();i++){
      if(sequence[i] == 1){
        sendHydro(note,velocity);
        tempoInMS::ms => now;
      }
    }
  }

  fun void loopSequence(int sequence[],int note, int velocity, int tempoInMS){
    while(true){
      playSequence(sequence,note,velocity,tempoInMS);
    }
  }

  fun void playRandBeat(int lengthOfSeq, int oneOutofThis,int tempoInMS){
    MidiSeq seq;
    for(36 => int i; i < 60; i++){
      Math.random2(0,1)=> int choose;
      if(choose == 1){
        seq.makeRandomSequence(lengthOfSeq,oneOutofThis)@=> int thisSeq[];
        spork ~ loopSequence(thisSeq,i,127,tempoInMS);
      }
    }
    while(true){1::second=>now;}
  }

  fun void playSuperRandBeat(int maxlengthOfSeq, int oneOutofThis,int tempoInMS){
    MidiSeq seq;
    for(36 => int i; i < 60; i++){
      Math.random2(0,2)=> int choose;
      if(choose == 1){
        Math.random2(2,maxlengthOfSeq) => int seqLength;
        seq.makeRandomSequence(seqLength,oneOutofThis) @=> int thisSeq[];
        spork ~ loopSequence(thisSeq,i,127,tempoInMS);
      }
    }
    while(true){1::second=>now;}
  }

  fun void loopSuperRandBeat(int maxlengthOfSeq, int oneOutofThis,int tempoInMS){
    while(true){1::second=>now;}
  }

  fun void playRamdomEuclideanRhythm(int lengthOfSeq,int tempoInMS){
    EuclidR euclid;
    for(36 => int i; i < 60; i++){
      Math.random2(0,2)=> int choose;
      if(choose == 1){
        Math.random2(1,(lengthOfSeq/2))=> int hits;
        Math.random2(1,(lengthOfSeq-2))=> int rotation;
        euclid.euclidRotator(lengthOfSeq,hits,rotation) @=> int thisSeq[];
        spork ~ loopSequence(thisSeq,i,127,tempoInMS);
      }
    }
  }

  fun void loopRandomEuclideanRhythm(int lengthOfSeq,int tempoInMS){
    while(true){
      playRamdomEuclideanRhythm(lengthOfSeq,tempoInMS);
    }
  }

}
