public class ArrayFun{
  fun int[] append(int arrayOne[],int arrayTwo[]){
    arrayOne.cap()+arrayTwo.cap() => int totalSize;
    int retArray[totalSize];
    for(0=> int i;i<arrayOne.cap();i++){
      arrayOne[i]=>retArray[i];
    }
    for(0=> int i;i<arrayTwo.cap();i++){
      i+arrayOne.cap() => int index;
      arrayTwo[i]  => retArray[index];
    }
    return retArray;
  }

  fun int[] appendThree(int arrayOne[],int arrayTwo[],int arrayThree[]){
    append(append(arrayOne,arrayTwo),arrayThree) @=> int retArray[];
    return retArray;
  }

  fun int[] subset(int array[],int lowerIndex,int upperIndex){
    upperIndex-lowerIndex+1 => int size;
    int retArray[size];
    for(0=> int i;i<retArray.cap();i++){
      i+lowerIndex => int index;
      array[index] => retArray[i];
    }
    return retArray;
  }

}

//[1] @=> int one[];
//[5] @=> int two[];
//[1] @=> int three[];

//append(one,two) @=> int three[];
//for(0=> int i;i<three.cap();i++){
  //<<<three[i]>>>;//
//}

//subset(three,2,4) @=> int four[];
//for(0=> int i;i<four.cap();i++){
  //<<<four[i]>>>;
//}
//ArrayFun ar;
//ar.appendThree(one,two,three) @=> int all[];
//for(0=> int i;i<all.cap();i++){
  //<<<all[i]>>>;
//}
