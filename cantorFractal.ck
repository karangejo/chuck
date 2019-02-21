ArrayFun ar;
/// must be divisible by 3
fun int[][] divideThree(int array[]){
  if((array.cap())%3 != 0){
    <<<"ERROR: must be divisible by 3">>>;
    return int nothing[0][0];
  }
  ((array.cap()+1)/3)$int => int firstPlace;
  firstPlace*2 => int secondPlace;
  array.cap()=> int lastPlace;
  <<<firstPlace,secondPlace,lastPlace>>>;

  int retArray[3][firstPlace];

  for(0=>int i;i<firstPlace;i++){
    array[i]=>retArray[0][i];
  }
  for(firstPlace=>int i;i<secondPlace;i++){
    array[i]=>retArray[1][i-firstPlace];
  }
  for(secondPlace=>int i;i<lastPlace;i++){
    array[i]=>retArray[2][i-secondPlace];
  }

  return retArray;
}


fun int[] mankeCantorSeq(int array[]){
  array.cap()/3 => int length;
  if(array.cap()/3 == 0){
    return [1,0,1];
  }
  divideThree(array)@=> int divided[][];
  int seq1[length];
  int seq2[length];
  int seq3[length];
  for(0=>int i; i< length;i++){
    divided[0][i] => seq1[i];
    divided[1][i] => seq2[i];
    divided[2][i] => seq3[i];

  }
  ar.appendThree(mankeCantorSeq(seq1),seq2,mankeCantorSeq(seq3))@=>int retSeq[];
  return retSeq;
}

//[1,2,3,4,5,6,7,8,9,10,11,12,12] @=> int seq12[];

//<<<seq12.cap()>>>;

//divideThree(seq12) @=> int Divided[][];

//for(0=>int i;i<3;i++){
  //<<<"array:",i>>>;
  //for(0=>int j;j<4;j++){
    //<<<Divided[i][j]>>>;
  //}
//}
//[0,0,0,0,0,0,0,0,0,0,0,0] @=> int sequence12[];
//mankeCantorSeq(sequence12) @=> int aSeq[];
//
//for(0=> int i; i< aSeq.cap();i++){
  //<<<aSeq[i]>>>;
//}

fun int[] makeCantorSeq(int length, int ratio){
  if(length == 3){
    return [1,0,1];
  }
  if(length == 2){
    return [1,0];
  }

  (Math.floor(length/ ratio))$int => int div;
  length%ratio => int mod;
  if(mod != 0){
    div+mod => int last;
    ar.appendThree(makeCantorSeq(div,ratio),makeZeros(div),makeCantorSeq(last,ratio)) @=> int retAr[];
    return retAr;
  }

  ar.appendThree(makeCantorSeq(div,ratio),makeZeros(div),makeCantorSeq(div,ratio)) @=> int retAr[];
  return retAr;

}

fun int[] makeZeros(int length){
  int retArray[length];
  for(0=>int i;i<retArray.cap();i++){
    0=>retArray[i];
  }
  return retArray;
}




makeCantorSeq(15,3)@=> int Cantor[];
for(0=>int i;i<Cantor.cap();i++){
  <<<Cantor[i]>>>;
}
