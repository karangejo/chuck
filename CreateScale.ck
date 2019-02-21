
// initialize the scale intervals in midi
// [0, 2, 4, 5, 7, 9, 11] @=> int scale[]; this is major scale
// 1  2   3  4  5  6  7  8  9  10 11  12
// c  c#  d  d# e  f  f# g  g# a  a#  b
// offsets for different keys

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


//test
// play scale in thirds!!
//TriOsc triangle => dac;
//SawOsc saw => dac;

//0.09 => triangle.gain;
//0.09 => saw.gain;

//[0, 2, 4, 5, 7, 9, 11] @=> int major[];
//makeScale(major, 0) @=> int newScale[];

//while(true){
  //for(24 => int i; i < 60; i++){
    //<<< i >>>;
    //if(i % 2 == 0){
      //<<<"third", i>>>;
      //Std.mtof(newScale[i]) => float frequency;
      //frequency => triangle.freq;
      //Std.mtof(newScale[i+2]) => float frequencySaw;
      //frequencySaw => saw.freq;
      //150::ms => now;
  //  }
//  }
//}
//
