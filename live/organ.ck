public class Organ{

   BeeThree b3 => JCRev rev => Gain gain=> dac;
    0.5 => rev.mix;
    0.3 => gain.gain;
    //20=> b3.lfoSpeed;
    //0.5 => b3.lfoDepth;

  fun void playNote(int midiNote,dur duration){
    Std.mtof(midiNote)=>b3.freq;
    1 => b3.noteOn;
    duration=>now;
    0 => b3.noteOff;
  }

  fun void playSequence(int sequence[],dur noteDuration){
    for(0=>int i;i<sequence.cap();i++){
      playNote(sequence[i],noteDuration);
    }
  }

  fun void loopSequence(int sequence[],dur noteDuration){
    while(true){
      playSequence(sequence,noteDuration);
    }
  }

  fun void playRhythmMelody(dur rhythmInMs[], int melody[]){
    if(melody.cap() != rhythmInMs.cap()){
      <<<"rhythm and melody do not match!!!">>>;
      me.exit();

    }
    for(0=>int i;i<melody.cap();i++){
      playNote(melody[i],rhythmInMs[i]);
    }
  }

  fun void loopRhythmMelody(dur rhythmInMs[], int melody[]){
    while(true){
      playRhythmMelody(rhythmInMs,melody);
    }
  }


  fun void playIntervals(int scale[],int startNoteI, int numNotes, int interval, dur noteDuration, string direction){
    numNotes * interval => int range;
    if(direction == "up"){
      for(0 => int i; i < range; i++){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          playNote(scale[index],noteDuration);
        }
      }
    }

    if(direction == "down"){
      for(range => int i; i > 0; i--){
        i+startNoteI=> int index;
        if((i%interval) == 0){
          playNote(scale[index],noteDuration);
        }
      }
    }
  }

  fun void loopIntervals(int scale[],int startNoteI, int numNotes, int interval, dur noteDuration, string direction){
    while(true){
      playIntervals(scale,startNoteI,numNotes,interval,noteDuration,direction);
    }
  }

  fun void playChord(int scale[], int startNoteI, dur noteDuration){
    //Shred noteShred[3];
    [scale[startNoteI],scale[startNoteI+2],scale[startNoteI+4]] @=>int chord[];
    for(0 => int i; i< chord.cap(); i++){
      <<<chord[i]>>>;
      spork ~ playNote(chord[i],(noteDuration-10::ms)); //@=> noteShred[i];
    }

    noteDuration=>now;
  }

  fun void playChordProgression(int scale[], int progression[],dur barDuration){
    for(0=>int i;i<progression.cap();i++){
      playChord(scale,progression[i],barDuration);
    }
  }

  fun void loopChordProgression(int scale[], int progression[],dur barDuration){
    while(true){
      playChordProgression(scale,progression,barDuration);
    }
  }

  fun void loopChord(int scale[], int startNoteI, dur noteDuration){
    while(true){
      playChord(scale,startNoteI,noteDuration);
    }
  }


    fun void bassLineProgression(int scale[],int progression[],dur noteDuration,dur barDuration){
      (barDuration/noteDuration)$int => int numNotes;
      for(0=>int i;i<progression.cap();i++){
        progression[i] => int root;
        [scale[root],scale[root+2],scale[root+4],scale[root+7]] @=> int choiceNotes[];
        for(0=>int j;j<numNotes;j++){
          Math.random2(0,choiceNotes.cap()-1) => int index;
          playNote(choiceNotes[index],noteDuration);
        }
      }
    }

    fun void loopBassLineProgression(int scale[],int progression[],dur noteDuration,dur barDuration){
      while(true){
        bassLineProgression(scale,progression,noteDuration,barDuration);
      }
    }

    fun void bassLineProgressionThirds(int scale[],int progression[],int numThirds,dur noteDuration,dur barDuration){
      (barDuration/noteDuration)$int => int numNotes;
      for(0=>int i;i<progression.cap();i++){
        progression[i] => int root;
        int choiceNotes[numThirds];
        for(0=>int k;k<choiceNotes.cap();k++){
          scale[root+k]=> choiceNotes[k];
        }
        for(0=>int j;j<numNotes;j++){
          Math.random2(0,choiceNotes.cap()-1) => int index;
          playNote(choiceNotes[index],noteDuration);
        }
      }
    }

    fun void loopBassLineProgressionThirds(int scale[],int progression[],int numThirds,dur noteDuration,dur barDuration){
      while(true){
        bassLineProgressionThirds(scale,progression,numThirds,noteDuration,barDuration);
      }
    }

  fun void randomWalk(int scale[], int root,dur noteDuration){
    WeightedRand rand;
    [5,5,4,3,2] @=> int myWalkWeights[];
    rand.setWeights(myWalkWeights);

    playNote(scale[root],noteDuration);
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
      playNote(scale[currentStep],noteDuration);
    }
  }

  fun void randomWalkUp(int scale[], int root,dur noteDuration){
    WeightedRand rand;
    [5,5,4,3,2] @=> int myWalkWeights[];
    rand.setWeights(myWalkWeights);

    playNote(scale[root],noteDuration);
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
      playNote(scale[currentStep],noteDuration);
    }
  }

  fun void playScaleAccordingToSteps(int scale[],int steps[],int startNoteI,dur noteDuration){
    for(0=>int i;i<steps.cap();i++){
      playNote(scale[steps[i]+startNoteI],noteDuration);
    }
  }

  fun void loopSteps(int scale[],int steps[],int startNoteI,dur noteDuration){
    while(true){
      playScaleAccordingToSteps(scale,steps,startNoteI,noteDuration);
    }
  }


}
/*
Scalez Edorian;
[0,2,3,5,7,9,10] @=> int dorian[];
4 => int keyOfE;
Edorian.makeScale(dorian,keyOfE);

Instrument organ;
2::second => dur bar;
spork ~organ.loopChordProgression(Edorian.myScale,[23,25,27,29],bar);
//spork ~ organ.loopIntervals(Edorian.myScale,28,7,5,(bar/7),"up");
spork ~organ.loopBassLineProgression(Edorian.myScale,[16,18,20,22],(bar/8),bar);
*/
while(true){1::second=>now;}
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
