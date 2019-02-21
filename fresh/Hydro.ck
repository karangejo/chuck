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

  fun void playSequence(int sequence[],int note, int velocity, dur noteDuration){
    for(0=>int i;i<sequence.cap();i++){
      if(sequence[i] == 1){
        sendHydro(note,velocity);
        noteDuration => now;
      }
      noteDuration =>now;
    }
  }

  fun void loopSequence(int sequence[],int note, int velocity, dur noteDuration){
    while(true){
      playSequence(sequence,note,velocity,noteDuration);
    }
  }

  fun void playRandBeat(int lengthOfSeq, int oneOutofThis,dur noteDuration){
    for(36 => int i; i < 60; i++){
      Math.random2(0,1)=> int choose;
      if(choose == 1){
        makeRandomSequence(lengthOfSeq,oneOutofThis)@=> int thisSeq[];
        <<<"Midi Note ;",i>>>;
        for(0=>int i;i<thisSeq.cap();i++){
          <<<thisSeq[i]>>>;
        }
        <<<"++++++BREAK++++++">>>;
        spork ~ loopSequence(thisSeq,i,127,noteDuration);
      }
    }
    while(true){1::second=>now;}
  }

  fun void playSuperRandBeat(int maxlengthOfSeq, int oneOutofThis,dur noteDuration){
    for(36 => int i; i < 60; i++){
      Math.random2(0,2)=> int choose;
      if(choose == 1){
        Math.random2(2,maxlengthOfSeq) => int seqLength;
        makeRandomSequence(seqLength,oneOutofThis) @=> int thisSeq[];
        <<<"Midi Note ;",i>>>;
        for(0=>int i;i<thisSeq.cap();i++){
          <<<thisSeq[i]>>>;
        }
        <<<"++++++BREAK++++++">>>;
        spork ~ loopSequence(thisSeq,i,127,noteDuration);
      }
    }
    while(true){1::second=>now;}
  }


  fun void playRamdomEuclideanRhythm(int lengthOfSeq,dur noteDuration){
    for(36 => int i; i < 60; i++){
      Math.random2(0,2)=> int choose;
      if(choose == 1){
        Math.random2(1,(lengthOfSeq/2))=> int hits;
        Math.random2(1,(lengthOfSeq-2))=> int rotation;
        euclidRotator(lengthOfSeq,hits,rotation) @=> int thisSeq[];
        <<<"Midi Note ;",i>>>;
        for(0=>int i;i<thisSeq.cap();i++){
          <<<thisSeq[i]>>>;
        }
        <<<"++++++BREAK++++++">>>;
        spork ~ loopSequence(thisSeq,i,127,noteDuration);
      }
    }
    while(true){1::second=>now;}
  }



  fun int[] makeRandomSequence(int length, int oneOutofThis){
     int seq[length];
     (oneOutofThis/2)$int => int target;
     for(0 =>int i; i< seq.cap(); i++){
       Math.random2(0,oneOutofThis) => int choose;
       if(choose == target){
         1 => seq[i];
       }
       else{
         0 => seq[i];
       }
     }
     return seq;
  }

  fun int euclide( int c, int k, int n, int r ) {
       return (((c + r) * k) % n) < k;
     }

     // default rotation for standard euclidian rhythms is rotation = 4
     // 3 to move forward one beat. 5 to move backwards etc
     fun int[] euclidianPattern(int steps,int hits,int rotation){
       int retSeq[steps];
       for(0=>int i;i<retSeq.cap();i++){
         euclide(i,hits,steps,rotation)=> retSeq[i];
       }
       return retSeq;
     }

     fun int[] euclidRotator(int steps, int hits, int rotation){
       int rot;
       if(rotation == 1){
         rotation+3 => rot;
       }
       if(rotation > 1){
         steps - rotation + 1 + 4 => rot;
       }
       rot => int rotate;
       //<<<rotate>>>;
       return euclidianPattern(steps,hits,rotate);
     }

}
