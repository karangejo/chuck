fun void writeIntsToFile(int integers[], string path) {

    // open the file
    FileIO file;
    if(!file.open(path))
        return; // error opening the specified file

    // write out the size and contents of the array
    //file <~ integers.cap();
    for (0 => int i; i < integers.cap(); i++){
        file <= integers[i];
        file <= " ";
    }


    // and we're done
    file.close(); // automatically calls file.finish()

}

fun int[] getIntsFromFile(string path){
  FileIO file;

  if(!file.open(path)){
    <<<"ERROR">>>;
    me.exit();
  }

  0=>int counter;
  file.size() => int size;
  int theInts[size];
  for(0=>int i;i<size;i++){
    if(file.eof()==true){
      break;
    }
    counter++;
    file.readInt(IO.READ_INT32) => int myInt;
    <<<myInt>>>;
    myInt => theInts[i];
  }

  int ret[counter];
  for(0=>int i;i<ret.cap();i++){
    theInts[i]=>ret[i];
  }

  return ret;
}
//readInts((me.dir()+"theInts.txt")) @=> string myInts[];


//}

[1, 2, 3,4,5,6,7,8,9]@=> int myInts[];
writeIntsToFile(myInts,(me.dir()+"theInts.txt"));
getIntsFromFile((me.dir()+"theInts.txt")) @=> int outInts[];

for(0=>int i;i<outInts.cap();i++){
  <<<outInts[i]>>>;
}
