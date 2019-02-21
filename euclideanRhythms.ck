public class EuclidR{
      /* generates euclideian patterns
     c: current step number
     k: hits per bar
     n: bar length
     r: rotation
     returns 1 or 0 according to the euclidean pattern*/

     fun int euclide( int c, int k, int n, int r ) {
       return (((c + r) * k) % n) < k;
     }

     // default rotation for standard euclidian rhythms is rotation = 4
     // 3 to move forward one beat. 5 to move backwards etc
     fun int[] euclidianPattern(int steps,int hits,int rotation){
       int retSeq[steps];
       for(0=>int i;i<retSeq.cap();i++){
         euclide(i,hits,steps,rotation)=> retSeq[i];
       }
       return retSeq;
     }

     fun int[] euclidRotator(int steps, int hits, int rotation){
       int rot;
       if(rotation == 1){
         rotation+3 => rot;
       }
       if(rotation > 1){
         steps - rotation + 1 + 4 => rot;
       }
       rot => int rotate;
       //<<<rotate>>>;
       return euclidianPattern(steps,hits,rotate);
     }
}
/*
euclidianPattern(7,2,4) @=> int pattern[];

for(0=>int i;i<pattern.cap();i++){
  <<<pattern[i]>>>;
}


<<<"+++++BREAK+++++">>>;
euclidRotator(7,2,5) @=> int pattern1[];

for(0=>int i;i<pattern1.cap();i++){
  <<<pattern1[i]>>>;
}
*/
/*
0 => int i;
while(i < 12) {
   euclide(i, 7, 12, 4) => int e;
   //declaring b just to print e
   <<<e>>> => int b;
   1 +=> i;
   100::ms => now;
}
*/
