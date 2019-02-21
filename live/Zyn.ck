public class ZynOut{

  MidiOut zynOut;
  MidiMsg msgZynOut;



  fun void setPort(int portNum){
    portNum => int port;

    if(!zynOut.open(port)){
      <<<"ERROR!">>>;
      me.exit();
    }
  }

  fun void sendZyn(int note, int velocity){
    144 => msgZynOut.data1;
    note => msgZynOut.data2;
    velocity => msgZynOut.data3;
    zynOut.send(msgZynOut);
  }

  fun void playSequence(int sequence[],int velocity,dur noteDuration){
    for(0=>int i;i<sequence.cap();i++){
      sendZyn(sequence[i],velocity);
      noteDuration=>now;
    }
  }

  fun void loopSequence(int sequence[],int velocity,dur noteDuration){
    while(true){
      playSequence(sequence,velocity,noteDuration);
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


  fun void playIntervals(int scale[],int startNoteI, int numNotes, int interval, dur noteDuration, int velocity, string direction){
    numNotes * interval => int range;
    if(direction == "up"){
      for(0 => int i; i < range; i++){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          sendZyn(scale[index],velocity);
          noteDuration => now;
          sendZyn(scale[index],0);
        }
      }
    }

    if(direction == "down"){
      for(range => int i; i > 0; i--){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          sendZyn(scale[index],velocity);
          noteDuration => now;
          sendZyn(scale[index],0);
        }
      }
    }
  }

  fun void loopIntervals(int scale[],int startNoteI, int numNotes, int interval, dur noteDuration, int velocity, string direction){
    while(true){
      playIntervals(scale,startNoteI,numNotes,interval,noteDuration,velocity,direction);
    }
  }

  fun void playChord(int scale[], int startNoteI, int velocity, dur noteDuration){
    //Shred noteShred[3];
    [scale[startNoteI],scale[startNoteI+2],scale[startNoteI+4]] @=>int chord[];
    for(0 => int i; i< chord.cap(); i++){
      sendZyn(chord[i],velocity); //@=> noteShred[i];
    }
    (noteDuration-10::ms) => now;
    for(0 => int i; i< chord.cap(); i++){
      sendZyn(chord[i],0);
      //noteShred[i].exit();
    }
    10::ms=>now;
  }

  fun void playChordProgression(int scale[], int progression[],int velocity, dur barDuration){
    for(0=>int i;i<progression.cap();i++){
      playChord(scale,progression[i],velocity,barDuration);
    }
  }

  fun void loopChordProgression(int scale[], int progression[],int velocity, dur barDuration){
    while(true){
      playChordProgression(scale,progression,velocity,barDuration);
    }
  }

  fun void bassLineProgression(int scale[],int progression[],int velocity,dur noteDuration,dur barDuration){
    (barDuration/noteDuration)$int => int numNotes;
    for(0=>int i;i<progression.cap();i++){
      progression[i] => int root;
      [scale[root],scale[root+2],scale[root+4]] @=> int choiceNotes[];
      for(0=>int j;j<numNotes;j++){
        Math.random2(0,choiceNotes.cap()-1) => int index;
        sendZyn(choiceNotes[index],127);
        noteDuration=>now;
        sendZyn(choiceNotes[index],0);
      }
    }
  }

  fun void loopBassLineProgression(int scale[],int progression[],int velocity,dur noteDuration,dur barDuration){
    while(true){
      bassLineProgression(scale,progression,velocity,noteDuration,barDuration);
    }
  }

  fun void loopChord(int scale[], int startNoteI, int velocity, dur noteDuration){
    while(true){
      playChord(scale,startNoteI,velocity,noteDuration);
    }
  }

  fun void randomWalk(int scale[], int root,int velocity, dur noteDuration){
    WeightedRand rand;
    [5,5,4,3,2] @=> int myWalkWeights[];
    rand.setWeights(myWalkWeights);

    sendZyn(scale[root],velocity);
    noteDuration => now;
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
      noteDuration => now;
      sendZyn(scale[currentStep],0);
    }
  }

  fun void randomWalkUp(int scale[], int root,int velocity, dur noteDuration){
    WeightedRand rand;
    [5,5,4,3,2] @=> int myWalkWeights[];
    rand.setWeights(myWalkWeights);

    sendZyn(scale[root],velocity);
    noteDuration => now;
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
      noteDuration => now;
      sendZyn(scale[currentStep],0);
    }
  }

  fun void playScaleAccordingToSteps(int scale[],int steps[],int startNoteI,int velocity,dur noteDuration){
    for(0=>int i;i<steps.cap();i++){
      sendZyn(scale[steps[i]+startNoteI],velocity);
      noteDuration=>now;
    }
  }

  fun void loopSteps(int scale[],int steps[],int startNoteI,int velocity,dur noteDuration){
    while(true){
      playScaleAccordingToSteps(scale,steps,startNoteI,velocity,noteDuration);
    }
  }


}
/*
ZynOut zyn;
Scalez Edorian;/////
[0,2,3,5,7,9,10] @=> int dorian[];
4 => int keyOfE;

Edorian.makeScale(dorian,keyOfE);
spork ~ zyn.loopIntervals(Edorian.myScale,28,5,3,500,127,"down");
spork ~ zyn.loopChord(Edorian.myScale,28,127,2500);
while(true){1::second=>now;}
*/
while(true){1::second=>now;}
