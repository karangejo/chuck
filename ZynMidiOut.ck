public class ZynOut{

  MidiOut zynOut;
  MidiMsg msgZynOut;


  17 => int port;

  if(!zynOut.open(port)){
    <<<"ERROR!">>>;
    me.exit();
  }

  fun void sendZyn(int note, int velocity){
    144 => msgZynOut.data1;
    note => msgZynOut.data2;
    velocity => msgZynOut.data3;
    zynOut.send(msgZynOut);
  }

  fun void playSequence(int sequence[],int velocity,int tempoInMS){
    for(0=>int i;i<sequence.cap();i++){
      sendZyn(sequence[i],velocity);
      tempoInMS::ms=>now;
    }
  }

  fun void loopSequence(int sequence[],int velocity,int tempoInMS){
    while(true){
      playSequence(sequence,velocity,tempoInMS);
    }
  }

  fun void playRhythmMelody(int rhythmInMs[], int melody[],int velocity){
    if(melody.cap() != rhythmInMs.cap()){
      <<<"rhythm and melody do not match!!!">>>;
      me.exit();

    }
    for(0=>int i;i<melody.cap();i++){
      sendZyn(melody[i],velocity);
      rhythmInMs[i]::ms=>now;
    }
  }

  fun void loopRhythmMelody(int rhythmInMs[], int melody[],int velocity){
    while(true){
      playRhythmMelody(rhythmInMs,melody,velocity);
    }
  }
  fun void playIntervals(int scale[],string startNote, int numNotes, int interval, int tempoInMS, int velocity, string direction){
    Scalez scalez;
    scalez.makeChromaticScale();
    scalez.lookUpNoteByName(scale,startNote) => int thisNote;
    playIntervals(scale,thisNote, numNotes,interval,tempoInMS,velocity, direction);
  }

  fun void playIntervals(int scale[],int startNoteI, int numNotes, int interval, int tempoInMS, int velocity, string direction){
    numNotes * interval => int range;
    if(direction == "up"){
      for(0 => int i; i < range; i++){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          sendZyn(scale[index],velocity);
          tempoInMS::ms => now;
          sendZyn(scale[index],0);
        }
      }
    }

    if(direction == "down"){
      for(range => int i; i > 0; i--){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          sendZyn(scale[index],velocity);
          tempoInMS::ms => now;
          sendZyn(scale[index],0);
        }
      }
    }
  }

  fun void loopIntervals(int scale[],int startNoteI, int numNotes, int interval, int tempoInMS, int velocity, string direction){
    while(true){
      playIntervals(scale,startNoteI,numNotes,interval,tempoInMS,velocity,direction);
    }
  }

  fun void playChord(int scale[], int startNoteI, int velocity, int tempoInMS){
    Shred noteShred[3];
    [scale[startNoteI],scale[startNoteI+2],scale[startNoteI+4]] @=>int chord[];
    for(0 => int i; i< chord.cap(); i++){
      spork ~ sendZyn(chord[i],velocity) @=> noteShred[i];
    }
    tempoInMS::ms => now;
    for(0 => int i; i< chord.cap(); i++){
      noteShred[i].exit();
    }
  }

  fun void loopChord(int scale[], int startNoteI, int velocity, int tempoInMS){
    while(true){
      playChord(scale,startNoteI,velocity,tempoInMS);
    }
  }

  fun void randomWalk(int scale[], int root,int velocity, int tempoInMS){
    WeightedRand rand;
    [5,5,4,3,2] @=> int myWalkWeights[];
    rand.setWeights(myWalkWeights);

    sendZyn(scale[root],velocity);
    tempoInMS::ms => now;
    sendZyn(scale[root],0);
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
      sendZyn(scale[currentStep],velocity);
      tempoInMS::ms => now;
      sendZyn(scale[currentStep],0);
    }
  }

  fun void randomWalkUp(int scale[], int root,int velocity, int tempoInMS){
    WeightedRand rand;
    [5,5,4,3,2] @=> int myWalkWeights[];
    rand.setWeights(myWalkWeights);

    sendZyn(scale[root],velocity);
    tempoInMS::ms => now;
    sendZyn(scale[root],0);
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
      sendZyn(scale[currentStep],velocity);
      tempoInMS::ms => now;
      sendZyn(scale[currentStep],0);
    }
  }

  fun void playScaleAccordingToSteps(int scale[],int steps[],int startNoteI,int velocity,int tempoInMS){
    for(0=>int i;i<steps.cap();i++){
      sendZyn(scale[steps[i]+startNoteI],velocity);
      tempoInMS::ms=>now;
    }
  }

  fun void loopSteps(int scale[],int steps[],int startNoteI,int velocity,int tempoInMS){
    while(true){
      playScaleAccordingToSteps(scale,steps,startNoteI,velocity,tempoInMS);
    }
  }


}
