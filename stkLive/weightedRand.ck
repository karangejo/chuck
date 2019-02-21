public class WeightedRand{
  //Weighted random numbers!!
  //initialize an array of weights with the heaviest first!!
  //[5,2,2,1] @=> int weights[];
  [5,5] @=> int weights[];

  fun void setWeights(int inWeights[]){
    inWeights @=> weights;
  }

  fun int random(){
    getrandom(weights) => int ret;
    return ret;
  }

  fun int getrandom(int weights[]){
    //Weighted random numbers!!
    //returns a number between 0 and the size of the array of weighted numbers
    //initialize an array of weights with the heaviest first in weights[]!!
    // most likely number is zero
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

}
while(true){1::second=>now;}


//WeightedRand rand;
//[5,4,3,2,1] @=> int myWeights[];/
//<<<rand.random()>>>;
//rand.setWeights(myWeights);
//<<<rand.weights[0]>>>;
