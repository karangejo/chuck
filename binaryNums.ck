public class MorseThue{

  // convert base ten to binary
  fun int binaryConvert(int num){
    num => int number => int theNumber;
    0 => float finalBit;
    0 => int counter;
    while(number > 0){
      number%2 => float bit;

      (Math.floor((number/2)))$int => int quotient;

      (bit/10)+(finalBit/10) => finalBit;

      quotient => number;
      counter++;
    }

    (finalBit*(Math.pow(10,counter)))$int=> int retFinalBit;
    <<<theNumber,"Is",retFinalBit,"in binary">>>;

    return retFinalBit;
  }
   /// convert base ten to any base
  fun int convertToNumBase(int num, int base){
    num => int number => int theNumber;
    0 => float finalBit;
    0 => int counter;
    while(number > 0){
      number%base => float bit;

      (Math.floor((number/base)))$int => int quotient;

      (bit/10)+(finalBit/10) => finalBit;

      quotient => number;
      counter++;
    }

    (finalBit*(Math.pow(10,counter)))$int=> int retFinalBit;
    <<<theNumber,"Is",retFinalBit,"in base",base>>>;

    return retFinalBit;
  }


  fun int binaryAppend(int one, int two){
    two => float secondOne;
    0 => int counter;
    while(secondOne >= 1){
      secondOne /10 => secondOne;
      counter++;

    }

    (Math.pow(10,counter))$int => int mutiplier;

    (one*mutiplier)+(two) => int appended;

    <<<appended>>>;
    return appended;

  }

  fun int binarySum(int binaryNum){
    binaryNum => float binary;
    0 => int sum;
    while(binary >= 1){
      ((Math.floor(binary))$int % 10) + sum => sum;
      binary/10 => binary;
    }
    <<<"sum of",binaryNum,"is",sum>>>;
    return sum;
  }
  // sum the digits of a number
  fun int digitSum(int number){
    number => float num;
    0 => int sum;
    while(num != 0){
      ((Math.floor(num))$int % 10)+ sum => sum;
      num/10 => num;
    }
    <<<"sum of",number,"is",sum>>>;
    return sum;
  }
  /// morse Thue sequence with binaries and their sums in a 2d matrix
  fun int[][] makeMorseThue(int length){

    int retMatrix[2][length];

    for(0 => int i; i < length; i++){

      binaryConvert(i) => int bin =>retMatrix[0][i];
      binarySum(bin) => retMatrix[1][i];
    }
    return retMatrix;
  }
  // morse thue sequence in any base with numbers and their sums
  fun int[][] makeMorseThueBase(int length, int base){

    int retMatrix[2][length];

    for(0 => int i; i < length; i++){

      convertToNumBase(i,base) => int bin =>retMatrix[0][i];
      digitSum(bin) => retMatrix[1][i];
    }
    return retMatrix;
  }
  //
  //makeMorseThueBase(100,5) @=> int MorseThue[][];
  //for(0 => int i; i < 100; i++){
  //  <<<MorseThue[0][i],MorseThue[1][i]>>>;
  //}

}
/*
MorseThue bin;
for(0=> int i; i< 10;i++){
  <<<bin.binaryConvert(i)>>>;
}
*/
