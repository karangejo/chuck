public class BPM {
  dur myDuration[6];
  static dur wholeNote, halfNote, quarterNote, eightNote, sixteenthNote, thirtysecondNote;

  fun void tempo(float beat){

    60.0/(beat) => float SPB; //second per beat
    SPB::second => quarterNote;
    quarterNote*0.5 => eightNote;
    eightNote*0.5 => sixteenthNote;
    sixteenthNote*0.5 => thirtysecondNote;

    quarterNote*4 => wholeNote;
    quarterNote*2 => halfNote;

    [wholeNote,halfNote,quarterNote,eightNote,sixteenthNote,thirtysecondNote] @=> myDuration;
  }

  fun dur getDuration(int durationName){
    dur retDur;
    if(durationName == 1){
      wholeNote => retDur;
    }
    if(durationName == 2){
      halfNote => retDur;
    }
    if(durationName == 4){
      quarterNote => retDur;
    }
    if(durationName == 8){
      eightNote => retDur;
    }
    if(durationName == 16){
      sixteenthNote => retDur;
    }
    if(durationName == 32){
      thirtysecondNote => retDur;
    }
    return retDur;
  }

}
while(true){1::second=>now;}
