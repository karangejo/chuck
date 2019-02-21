// sound Chain
ModalBar perc => JCRev rev => dac;
0.5 => rev.mix;

VoicForm voice => rev;
.1 => voice.vibratoFreq;
.5 => voice.vibratoGain;
.4 => voice.gain;

// connect to MIDI port for ZYN
// used instrument pulse_organ from the_mysterious_bank//
MidiOut mout;
MidiMsg msg;

17 => int port;

if(!mout.open(port)){
  <<<"ERROR!">>>;
  me.exit();
}

// make the scale we want
[0,2,3,5,7,9,10] @=> int dorian[];
5 => int keyOfE;

makeScale(dorian,keyOfE) @=> int Edorian[];

<<< "scale size ",Edorian.cap()>>>;

// E notes in midi
//52 64 76 88
// function to play random notes from scale according to a tempo
fun void playRand(int scale[], int tempoInMS){
  while(true){
    Math.random2(0,scale.cap()-1) =>int note;
    Math.random2(100,127) => int volume;
    send(note,volume);
    tempoInMS::ms => now;
    send(note,0);
  }
}

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


fun int[] makeScale( int scale[], int keyInt){
  //loop through and insert the notes in the right slots
  // the full scale is stored here
  int fullScale[127];
  0 => int fullcounter;

  for( 0 => int i; i < 11; i++){
    (i * 12) => int octave;
    for( 0 => int j; j < scale.cap(); j++){
      (octave + scale[j]) => int note;
      if(note > 127){
        break;
      }
      note => fullScale[fullcounter];
      <<< note, "in", fullcounter>>>;
      fullcounter++;
    }
  }
  // remove any notes greater than 127
  int lastNoteIndex;

  for( 0 => int i; i < fullScale.cap(); i++){
    if(fullScale[i] == 127){
      i =>  lastNoteIndex;
      <<< 1,lastNoteIndex>>>;
      break;
    }
    if(fullScale[i] > 127){
      i -1 => lastNoteIndex;
      <<< 2,lastNoteIndex>>>;
      break;
    }
  }

  int finalScale[lastNoteIndex+1];

  for( 0 => int i; i < finalScale.cap(); i++){
    fullScale[i] => finalScale[i];
  }

  // change keys by offsetting the values in the array
  keyInt => int keyOffset;

  for( 0 => int i; i < finalScale.cap(); i++){
    finalScale[i] + keyOffset => int newNote;
    if(newNote > 127){
      break;
    }
    newNote => finalScale[i];
    <<< newNote, "change key", i>>>;
  }

  //finalScale[] array contains the finished scale!
return finalScale;
}

fun void playModal(int scale[],int tempoInMS){
  while(true){
      6 => perc.preset;
      Math.random2f(0.7,1.0) => perc.strike;
      Math.random2(0,scale.cap()-20) => int index;
      Std.mtof(scale[index]) => perc.freq;
      tempoInMS::ms => now;

  }
}

fun void singDrone(int scale[], int rooti, int tempoInMS){
  while(true){
    voice.phoneme("aaa");
    scale[rooti]=> voice.freq;
    0.3=> voice.speak;
    0.3 => voice.loudness;
    tempoInMS::ms => now;
  }
}

1000=> float theTempo;
theTempo$int => int myTempo;

Shred theShred;


//spork ~ singDrone(Edorian,28,(theTempo*2)$int);
//(theTempo*8)::ms => now;
//spork ~ singDrone(Edorian,28+12,(theTempo*2)$int);
//(theTempo*8)::ms => now;
//spork ~ singDrone(Edorian,28 +24,(theTempo*2)$int);
//(theTempo*8)::ms => now;
spork ~ playModal(Edorian,(theTempo*2)$int) @=> theShred;
//(theTempo/2)::ms +
(theTempo*16)::ms => now;
theShred.exit();
spork ~ playIntervals(Edorian,28,7,4,myTempo,80,"down");
spork ~ playChord(Edorian,28,80,(myTempo*7)$int);
(theTempo*7*4)::ms => now;
spork ~ playIntervals(Edorian,30,6,3,(theTempo/2)$int,90,"up");
spork ~ playChord(Edorian,30,90,(myTempo/2*6)$int);
(theTempo/2*6*4)::ms => now;
spork ~ playIntervals(Edorian,34,5,2,(theTempo/4)$int,100,"up");
spork ~ playChord(Edorian,34,100,(myTempo/4*5)$int);
(theTempo/4*5*4)::ms => now;
spork ~ playIntervals(Edorian,42,4,1,(theTempo/8)$int,110,"up");
spork ~ playChord(Edorian,42,110,(myTempo/8*4)$int);
(theTempo/4*4*4)::ms => now;
//spork ~ playIntervals(Edorian,44,3,6,(theTempo/16)$int,122,"down") @=> theShred;
//(theTempo/4*3*4)::ms => now;
//theShred.exit();
//spork ~ playIntervals(Edorian,50,9,2,(theTempo/32)$int,122,"up") @=> theShred;


while(true){1::second=>now;}
