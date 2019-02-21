//VoicForm voice => JCRev rev => dac;;
//.1 => voice.vibratoFreq;
///.5 => voice.vibratoGain;
//.4 => voice.gain;

// connect to MIDI port for ZYN
// used instrument pulse_organ from the_mysterious_bank//
MidiOut mout;
MidiMsg msg;

18 => int port;

if(!mout.open(port)){
  <<<"ERROR!">>>;
  me.exit();
}

TalkingMonk monk;

MidiSeq Sequence;

Scalez Edorian;

[0,2,3,5,7,9,10] @=> int dorian[];
4 => int keyOfE;

Edorian.makeScale(dorian,keyOfE);

<<< "scale size ",Edorian.myScale.cap()>>>;

fun void playIntervals(int scale[],int startNoteI, int numNotes, int interval, int tempoInMS, int velocity, string direction){
  numNotes * interval => int range;
  while(true){
    if(direction == "up"){
      for(0 => int i; i < range; i++){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          send(scale[index],velocity);
          <<<"note :",scale[index]," in Index :", index>>>;
          tempoInMS::ms => now;
          send(scale[index],0);
        }
      }
    }

    if(direction == "down"){
      for(range => int i; i > 0; i--){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          send(scale[index],velocity);
          <<<"note :",scale[index]," in Index :", index>>>;
          tempoInMS::ms => now;
          send(scale[index],0);
        }
      }
    }
  }
}

fun void playChord(int scale[], int startNoteI, int velocity, int tempoInMS){
  while(true){
    Shred noteShred[3];
    [scale[startNoteI],scale[startNoteI+2],scale[startNoteI+4]] @=>int chord[];
    for(0 => int i; i< chord.cap(); i++){
      spork ~ send(chord[i],velocity) @=> noteShred[i];
    }
    tempoInMS::ms => now;
    for(0 => int i; i< chord.cap(); i++){
      noteShred[i].exit();
    }
  }
}

fun void send(int note, int velocity){
  144 => msg.data1;
  note => msg.data2;
  velocity => msg.data3;
  mout.send(msg);
}

fun void randomWalk(int scale[], int root,int velocity, int tempoInMS){
  WeightedRand rand;
  [5,5,4,3,2] @=> int myWalkWeights[];
  rand.setWeights(myWalkWeights);

  send(scale[root],velocity);
  tempoInMS::ms => now;
  send(scale[root],0);
  root => int currentStep;

  while(true){
    rand.random() => int step;
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
    if(currentStep > scale.cap()){
      (scale.cap()/2)$int => currentStep;
    }
    send(scale[currentStep],velocity);
    tempoInMS::ms => now;
    send(scale[currentStep],0);
  }

}

fun void randomWalkUp(int scale[], int root,int velocity, int tempoInMS){
  WeightedRand rand;
  [5,5,4,3,2] @=> int myWalkWeights[];
  rand.setWeights(myWalkWeights);

  send(scale[root],velocity);
  tempoInMS::ms => now;
  send(scale[root],0);
  root => int currentStep;

  while(true){
    rand.random() => int step;
    currentStep + step => currentStep;
    if(currentStep < 0){
      (scale.cap()/2)$int => currentStep;
    }
    if(currentStep >= scale.cap()){
      (scale.cap()/2)$int => currentStep;
    }
    send(scale[currentStep],velocity);
    tempoInMS::ms => now;
    send(scale[currentStep],0);
  }

}


fun void superRandBeat(int length, int oneOutofThis, int tempoInMS){
  Sequence.playSuperRandBeat(length,oneOutofThis,tempoInMS);
  while(true){
    1::second=>now;
  }
}

fun void monkSing(string cons[], int scale[],int startNoteI, int tempoInMS){
  WeightedRand random;
  [5,5,4,3,2] @=> int myWalkWeights[];
  random.setWeights(myWalkWeights);

  ((tempoInMS/10)*9)$int => int vowelMs;
  ((tempoInMS/10))$int => int consonantMs;

  startNoteI => int currentStep;
  monk.singConsVowel(cons,vowelMs,consonantMs,scale[currentStep]);

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
    if(currentStep > scale.cap()){
      (scale.cap()/2)$int => currentStep;
    }
      monk.singConsVowel(cons,vowelMs,consonantMs,scale[currentStep]);
  }
}

fun void monkSingUp(string cons[],int scale[],int startNoteI, int tempoInMS){
  monk.singRandomWalkMostlyUp(monk.all,Edorian.myScale,startNoteI,tempoInMS);
}

1000=> float theTempo;
theTempo$int => int myTempo;

Shred intervals[4];
Shred chords[4];
Shred beats[6];
Shred randwalk[4];


spork ~ superRandBeat(32,3,(theTempo/2)$int) @=> beats[0];
spork ~ playIntervals(Edorian.myScale,28,7,4,myTempo,80,"down") @=> intervals[0];
spork ~ playChord(Edorian.myScale,28,80,(myTempo*7)$int) @=> chords[0];
(theTempo*7*4)::ms => now;
beats[0].exit();
spork ~ superRandBeat(32,3,(theTempo/4)$int) @=> beats[1];
spork ~ playIntervals(Edorian.myScale,30,6,3,(theTempo/2)$int,90,"up") @=> intervals[1];
spork ~ playChord(Edorian.myScale,30,90,(myTempo/2*6)$int) @=> chords[1];
(theTempo/2*6*4)::ms => now;
beats[1].exit();
spork ~ superRandBeat(32,3,(theTempo/8)$int) @=> beats[2];
spork ~ playIntervals(Edorian.myScale,34,5,2,(theTempo/4)$int,100,"up") @=> intervals[2];
spork ~ playChord(Edorian.myScale,34,100,(myTempo/4*5)$int) @=> chords[2];
(theTempo/4*5*4)::ms => now;
beats[2].exit();
spork ~ superRandBeat(32,3,(theTempo/8)$int) @=> beats[3];
spork ~ playIntervals(Edorian.myScale,42,4,1,(theTempo/8)$int,110,"up") @=> intervals[3];
spork ~ playChord(Edorian.myScale,42,110,(myTempo/8*4)$int) @=> chords[3];
(theTempo/4*4*8)::ms => now;
intervals[3].exit();
intervals[2].exit();
intervals[1].exit();
intervals[0].exit();
chords[3].exit();
chords[2].exit();
chords[1].exit();
chords[0].exit();
beats[3].exit();
spork ~ superRandBeat(32,3,(theTempo/8)$int) @=> beats[4];
spork ~ randomWalkUp(Edorian.myScale,42,110,(theTempo/8)$int)@=> randwalk[0];
spork ~ randomWalk(Edorian.myScale,42,110,(theTempo/4)$int)@=> randwalk[1];
(theTempo*7*4)::ms => now;
//beats[4].exit();
//randwalk[0].exit();
//randwalk[1].exit();


//spork ~ playIntervals(Edorian,44,3,6,(theTempo/16)$int,122,"down")
//spork ~ playIntervals(Edorian,50,9,2,(theTempo/32)$int,122,"up")


//while(true){1::second=>now;}
