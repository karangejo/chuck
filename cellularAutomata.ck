public class CellAuto{
  fun int[] updateCells(int array[],int ruleArray[]){
    int retArray[array.cap()];

    for(0=>int i;i<array.cap();i++){
      if(i == 0){
        ruleLookUp([array[array.cap()-1],array[i],array[i+1]],ruleArray)=> retArray[i];
        //<<<"i is zero",i>>>;
        //<<<"returning",retArray[i]>>>;
      }
      if(i == array.cap()-1){
        ruleLookUp([array[i-1],array[i],array[0]],ruleArray)=> retArray[i];
        //<<<"i is 8",i>>>;
        //<<<"returning",retArray[i]>>>;

      }
      if((i != 0) && (i != array.cap()-1)){
        ruleLookUp([array[i-1],array[i],array[i+1]],ruleArray)=> retArray[i];
      //  <<<"i is normal",i>>>;
      //  <<<"returning",retArray[i]>>>;

      }
    }

    return retArray;
  }


  fun int compareArray(int arrayOne[], int arrayTwo[]){
    int compArray[arrayOne.cap()];
    if(arrayOne.cap() != arrayTwo.cap()){
      <<<"different lengths!!">>>;
      return 0;
    }

    for(0=>int i;i<arrayOne.cap();i++){
      if(arrayOne[i] == arrayTwo[i]){
        1 => compArray[i];
      }
    }
    for(0=>int i;i<compArray.cap();i++){
      if(compArray[i] != 1){
        return 0;
      }
    }
    return 1;
  }

  fun int ruleLookUp(int array[],int ruleArray[]){
    if(compareArray(array,[0,0,0]) == 1 ){
      //<<<"rule 0">>>;
      return ruleArray[0];
    }
    if(compareArray(array,[0,0,1]) == 1 ){
      //<<<"rule 0">>>;
      return ruleArray[1];
    }
    if(compareArray(array,[0,1,0]) == 1 ){
      //<<<"rule 0">>>;
      return ruleArray[2];
    }
    if(compareArray(array,[0,1,1]) == 1 ){
    //  <<<"rule 0">>>;
      return ruleArray[3];
    }
    if(compareArray(array,[1,0,0]) == 1 ){
      //<<<"rule 0">>>;
      return ruleArray[4];
    }
    if(compareArray(array,[1,0,1]) == 1 ){
    //  <<<"rule 0">>>;
      return ruleArray[5];
    }
    if(compareArray(array,[1,1,0]) == 1 ){
      //<<<"rule 0">>>;
      return ruleArray[6];
    }
    if(compareArray(array,[1,1,1]) == 1 ){
      //<<<"rule 0">>>;
      return ruleArray[7];
    }
    <<<"no match">>>;
  }
}
/*
CellAuto cell;
[0,1,0,1,1,0,1,0] @=> int rules[];
[0,0,0,0,1,0,0,0,0] @=> int startState[];

[1,2,3] @=> int ar1[];
[1,2,3] @=> int ar2[];
[1,2,3,4] @=> int ar3[];

//([startState[0],startState[1],startState[2]]
//  ([0,0,0] == [0,0,0]) => int val;/
//<<<"this should be true",val>>>;

0 => int count;
while(count < 5){
//  <<<startState.cap()-1>>>;
  <<<"++++++NEXT+++++++">>>;
  for(0=>int i;i<startState.cap();i++){
    <<<startState[i]>>>;
  }
  cell.updateCells(startState,rules) @=> startState;
  count++;
}
*/
//<<<ruleLookUp([0,0,0],rules)>>>;
//<<<"true ", compareArray(ar1,ar2)>>>;
//<<<"false ", compareArray(ar1,ar3)>>>;
