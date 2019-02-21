public class MidiSeq{

   // the function will choose 1 random number between zero
   //and oneOutofThis and if it is == (oneOutofThis/2)$int it will put in a beat
   // if oneOutofThis is 4 that means there is 1 in 4 chance any given beat
   // will have a hit. this is the same for all functions below as well

   fun int[] makeRandomSequence(int length, int oneOutofThis){
     int seq[length];
     (oneOutofThis/2)$int => int target;
     for(0 =>int i; i< seq.cap(); i++){
       Math.random2(0,oneOutofThis) => int choose;
       if(choose == target){
         1 => seq[i];
       }
       else{
         0 => seq[i];
       }
     }
     return seq;
  }




}

//1 2 3 4 5 6 7 8  9 10 11 12 13 14 15 16  17 18 19 20 21 22 23 24  25 26 27 28 29 30 31 32
 //[1,0,0,0,0,0,0,0 ,1,0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0] @=> int bass[];
// [0,0,0,0,1,0,0,0 ,0,0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0] @=> int snare[];
 //[0,1,1,1,0,1,1,1 ,0,1, 1, 1, 0, 1, 1, 1,  0, 1, 1, 1, 0, 1, 1, 1,  0, 1, 1, 1, 0, 1, 1, 1] @=> int hat[];
 //[0,0,0,0,0,0,0,0 ,0,0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0]
 //[0,0,0,0,0,0,0,0 ,0,0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0]
 //[0,0,0,0,0,0,0,0 ,0,0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0]
