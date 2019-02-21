public class Scalez
{
  // initialize the scale intervals in midi
  // [0, 2, 4, 5, 7, 9, 11] @=> int scale[]; this is major scale
  // 0   1  2   3  4  5  6   7  8  9  10 11
  // c  c#  d   d# e  f  f#  g  g# a  a#  b
  // offsets for different keys

  [0] @=> int myScale[];
  [0, 2, 4, 5, 7, 9, 11] @=> int Majscale[];
/*
  [0] @=> int octaveOne[];
  [0] @=> int octaveTwo[];
  [0] @=> int octaveThree[];
  [0] @=> int octaveFour[];
  [0] @=> int octaveFive[];
  [0] @=> int octaveSix[];
  [0] @=> int octaveSeven[];
  [0] @=> int octaveEight[];
  [0] @=> int octaveNine[];
  [0] @=> int octaveTen[];
*/
  int chromaticScaleAsoc[127];
  string chromaticScale[];
  int myOctave[11][8];

  0 => int key;

  fun void makeOctaves(){
    int newOctave[8];
    for(0=>int i;i<11;i++){
      getOctave(i)@=> int newOctave[];
      for(0=>int j;j<8;j++){
        newOctave[j]=> myOctave[i][j];
      }
    }
  }

  fun int[] getOctave(int octaveNum){
      (octaveNum*7) => int startNote;
    <<<"starting from index:",startNote>>>;
    int retOctave[8];
    for(0=>int i;i<retOctave.cap();i++){
      i +startNote =>int  myIndex;
      if(myIndex>myScale.cap()-1){
        break;
      }
      myScale[myIndex] => retOctave[i];
    }
    return retOctave;
  }

  fun void makeScale(){
    makeScaleInternal(Majscale,key) @=> myScale;
  }

  fun void makeScale(int scale[], int keyInt){
    makeScaleInternal(scale,keyInt) @=> myScale;
  }

  fun int[] makeScaleInternal( int scale[], int keyInt){
    //loop through and insert the notes in the right slots
    // the full scale is stored here
    makeChromaticScale();
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
    0 => int repeatedIndex;

    for( 0 => int i; i < finalScale.cap(); i++){
      finalScale[i] + keyOffset => int newNote;
      if(newNote > 127){
        i => repeatedIndex;
        break;
      }
      newNote => finalScale[i];
      <<< newNote, "change key", i>>>;
    }

    int lastScale[repeatedIndex];
    for(0=>int i; i < lastScale.cap();i++){
      finalScale[i] => lastScale[i];
      <<< lastScale[i], "note in index :", i>>>;
    }

    //finalScale[] array contains the finished scale!
  return lastScale;
  }

  fun void makeChromaticScale(){
    ["c","c#","d","d#","e","f","f#","g","g#","a","a#","b"] @=> string  ABCs[];
    ["1","2","3","4","5","6","7","8","9","10","11"] @=> string octaveNums[];
    string chromaticScaleNames[127];
    //
    0=>int octaveIndex;
    for(0=>int i;i<127;i++){
      i%12 => int ABCindex;
      if((ABCindex == 0) && (i != 0)){
        octaveIndex++;
      }
      i => chromaticScaleAsoc[ABCs[ABCindex]+octaveNums[octaveIndex]];
      ABCs[ABCindex]+octaveNums[octaveIndex] => chromaticScaleNames[i];
    }
    chromaticScaleNames @=> chromaticScale;
  }

  fun int lookUpNoteByName(int scale[],string note){
    chromaticScaleAsoc[note] => int myNote;
    for(0=>int i;i<scale.cap();i++){
      if(scale[i]==myNote){
        return i;
      }
    }
    <<<"note not found!">>>;
    me.exit();
  }

}
/*
Scalez Edorian;

[0,2,3,5,7,9,10] @=> int dorian[];
4 => int keyOfE;

Edorian.makeScale(dorian,keyOfE);

<<< "scale size ",Edorian.myScale.cap()>>>;
//Edorian.getOctave(5) @=> int myOctave[];
Edorian.makeOctaves();
77
for(0=>int i; i < 11;i++){
  <<<"octave number:",i>>>;
  for(0=>int j; j < 8;j++){
    <<<Edorian.myOctave[i][j]>>>;
  }
}
*/


//for(0=>int i;i<127;i++){
  //<<<chromaticScaleNames[i]>>>;
//}
