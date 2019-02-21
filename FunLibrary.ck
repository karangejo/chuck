//Weighted random numbers!!
//initialize an array of weights with the heaviest first!!
//[5,2,2,1] @=> int weights[];

fun int weightedRandom(int weights[]){
  //Weighted random numbers!!
  //initialize an array of weights with the heaviest first in weights[]!!
  int chosenOne;
  0 => int sumOfWeights;

  //get the sum of all weights
  for(0 => int i; i<weights.cap(); i++){
    sumOfWeights + weights[i] => sumOfWeights;
  }

  //choose a random number between 1 and the sumOfWeights
  Math.random2(1,sumOfWeights + 1) => int ranNum;
  //loop over the array and subtract the weights from the random number
  for(0 => int i; i<weights.cap(); i++){
    ranNum - weights[i] => ranNum;
    //if it is 0  or less then return that number
    if(ranNum <= 0){
      i => chosenOne;
      break;
    }
  }
  //final random number chosen is chosenOne
  return chosenOne;
}

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
//makeMinChord(60) @=> int minchord[];
//<<<minchord[0],minchord[1],minchord[2]>>>;
fun int[] makeMinChord(int root){
  [root, (root+3),(root+7)] @=> int chord[];
  return chord;
}

fun int[] makeMajChord(int root){
  [root, (root+4),(root+7)] @=> int chord[];
  return chord;
}

fun int[] makeDimChord(int root){
  [root, (root+3),(root+6)] @=> int chord[];
  return chord;
}
