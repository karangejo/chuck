<<<me.dir()>>>;
SndBuf tabla => dac;

string tablaSamples [6];

me.dir()+"/Audio/loud-ge.wav" => tablaSamples[0];
me.dir()+"/Audio/na.wav" => tablaSamples[1];
me.dir()+"/Audio/tu.wav" => tablaSamples[2];
me.dir()+"/Audio/tin.wav" => tablaSamples[3];
me.dir()+"/Audio/te.wav" => tablaSamples[4];
me.dir()+"/Audio/sur.wav" => tablaSamples[5];

150::ms => dur beat;
//random sequencer
while(true){
  Math.random2(0,tablaSamples.cap()-1) => int which;
  //Math.random2f(.9,1.1) => tabla.rate;
  tablaSamples[which] => tabla.read;
  Math.random2(0,3) => int chooseTime;
  <<<chooseTime>>>;
  if(chooseTime == 0){
    beat => now;
  }
  if(chooseTime == 1){
    beat * 2 => now;
  }
  if(chooseTime ==2){
    beat / 2 => now;
  }
}

//Weighted random numbers!!
//initialize an array of weights with the heaviest first!!
[5,2,2,1] @=> int weights[];

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
