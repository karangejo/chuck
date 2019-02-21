public class NumSeq{
  fun int[] fibonacci(int length){
    if(length < 2){
      <<<"too short">>>;
      return [1,2];
    }
    2 => int count;
    int retArray[length];
    1 => retArray[0];
    2 => retArray[1];

    while(count<length){
      retArray[count-2]+retArray[count-1] => retArray[count];
      count++;
    }

    return retArray;
  }

  fun int[] triangularSeq(int length){
    int retArray[length-1];
    for(1=>int i;i<retArray.cap()+1;i++){
      sumUpto(i)=> retArray[i-1];
    }
    return retArray;
  }

  fun int sumUpto(int num){
    1=>int j =>int k;
    for(1=>int i;i< num;i++){
      j+1=>j;
      k+j=> k;
    }

    return k;
  }

  fun int[] squareSeq(int length){
    int retArray[length-1];
    for(1=>int i;i<retArray.cap()+1;i++){
      i*i => retArray[i-1];
    }
    return retArray;
  }
}


/*
fibonacci(20) @=> int fib[];

for(0=>int i;i<fib.cap();i++){
  <<<fib[i]>>>;
}

//<<<sumUpto(1)>>>;
triangularSeq(10) @=> int trig[];
for(0=>int i;i<trig.cap();i++){
  <<<trig[i]>>>;
}

squareSeq(10)@=> int square[];
for(0=>int i;i<square.cap();i++){
  <<<square[i]>>>;
}
*/
