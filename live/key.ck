public class Key{
  Scalez scale;
  static int myKey[];

  fun void setScale(string mode,int key){
    int thisScale[];
    if(mode == "dorian"){
      [0,2,3,5,7,9,10] @=> thisScale;
    }
    if(mode == "minor"){
      [0,2,3,5,7,8,10] @=> thisScale;
    }
    if(mode == "major"){
      [0,2,4,5,7,9,11] @=> thisScale;
    }
    scale.makeScale(thisScale,key);
    scale.myScale @=> myKey;
  }

  fun int lookUpNoteByName(string note){
    scale.lookUpNoteByName(note)=> int retNote;
    return retNote;
  }

}
/*
X msg 58 15 \; minorScale 0 2 3 5 7 8 10;
#X msg 63 54 \; bluesScale 0 2 3 4 5 7 9 10 11;
#X msg 64 95 \; dorianScale 0 2 3 5 7 9 10;
#X msg 60 138 \; harmonicMinorScale 0 2 3 5 7 8 11;
#X msg 58 178 \; locrianScale 0 1 3 5 6 8 10;
#X msg 53 221 \; lydianScale 0 2 4 6 7 9 10;
#X msg 53 274 \; majorScale 0 2 4 5 7 9 11;
#X msg 48 319 \; melodicMinorScale 0 2 3 5 7 9 11;
#X msg 53 365 \; mixolydianScale 0 2 4 5 7 9 10;
#X msg 56 407 \; majorPentatonicScale 0 2 4 7 9;
#X msg 56 446 \; minorPentatonicScale 0 3 5 7 10;
#X msg 56 489 \; phrygianScale 0 1 3 5 7 8 10;
*/
me.arg(0)=>string mode;
Std.atoi(me.arg(1))=>int myKey;
Key key;
key.setScale(mode,myKey);
while(true){1::second=>now;}
