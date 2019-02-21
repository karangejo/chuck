MidiOut mout;
MidiMsg msg;
EuclidR r;


17 => int port;

if(!mout.open(port)){
  <<<"ERROR!">>>;
  me.exit();
}

fun void send(int note, int velocity){
  144 => msg.data1;
  note => msg.data2;
  velocity => msg.data3;
  mout.send(msg);
}


fun void playSequence(int array[],int note,int tempoInMs){
    while(true){
      for(0=>int i;i<array.cap();i++){
        if(array[i]==1){
          send(note,127);
        }
        tempoInMs::ms => now;
      }
    }
}

fun void playRandomEuclid(int maxSteps, int tempoInMs){
  for(36=> int i;i<60;i++){
    Math.random2(0,1)=> int choose;
    if(choose == 1){
      Math.random2(2,maxSteps) => int steps;
      Math.random2(1,(steps/2)) => int hits;
      Math.random2(1,steps-2) => int rotation;
    //  <<<steps,hits,rotation>>>;
      r.euclidRotator(steps,hits,rotation) @=> int EuclidianSeq[];
      for(0=>int i;i<EuclidianSeq.cap();i++){
      //  <<<EuclidianSeq[i]>>>;
      }
    //  <<<"playing sequence:",i>>>;
      tempoInMs => int tempo;
      Math.random2(0,1) => int chooseSpeed;
      if(chooseSpeed == 1){
        tempoInMs/2 => tempo;
      }
      //<<<"tempo",tempoInMs>>>;
      spork ~ playSequence(EuclidianSeq,i,tempo);
    }
  }
  while(true){1::second=> now;}
}

fun void playCellularBeats(int startState[], int rules[],int tempoInMs){
  CellAuto cell;

  for(36=>int i;i<60;i++){
    Math.random2(0,1)=> int choose;
    if(choose == 1){
      cell.updateCells(startState,rules) @=> startState @=> int thisArray[];
      spork ~ playSequence(thisArray,i,tempoInMs);
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

//[0,1,0,1,1,0,1,0] @=> int rules[];
makeRandomSequence(8,2) @=> int rules[];
makeRandomSequence(32,4) @=> int startState[];

playCellularBeats(startState,rules,200);

/*
200 => int myTempo;
NumSeq seq;
seq.fibonacci(4) @=> int fibSeq[];
while(true){
  for(0=>int i;i<fibSeq.cap();i++){
    <<<"fibonacci number",fibSeq[i]>>>;
    (myTempo*fibSeq[i]*fibSeq[i]) => int thisTempo;
    <<<"sporking this for this long",thisTempo>>>;
    Shred s;
    spork ~ playRandomEuclid(fibSeq[i],myTempo) @=> s;

    thisTempo::ms=>now;
    s.exit();
  }
}

*/
