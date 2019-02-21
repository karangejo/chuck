
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

//test
//makeMinChord(60) @=> int minchord[];
//<<<minchord[0],minchord[1],minchord[2]>>>;
