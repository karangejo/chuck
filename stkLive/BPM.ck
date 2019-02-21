public class BPM {
  //dur myDuration[6];
  static dur wholeNote, halfNote, quarterNote, eightNote, sixteenthNote, thirtysecondNote;
  static dur thirdNote, sixthNote, twelfthNote, twentyfourthNote;
  static dur fifthNote, tenthNote, twentiethNote, fourtiethNote;
  static dur seventhNote, fourtenthNote,twentyeighthNote;
  static dur ninthNote, eighteenthNote,thirtysixthNote;


  fun void tempo(float beat){

    60.0/(beat) => float SPB; //second per beat
    SPB::second => quarterNote;
    quarterNote*0.5 => eightNote;
    eightNote*0.5 => sixteenthNote;
    sixteenthNote*0.5 => thirtysecondNote;
    quarterNote*4 => wholeNote;
    quarterNote*2 => halfNote;
    wholeNote/3 => thirdNote;
    thirdNote*0.5 => sixthNote;
    sixthNote*0.5 => twelfthNote;
    twelfthNote*0.5 => twentyfourthNote;
    wholeNote/5 => fifthNote;
    fifthNote*0.5 => tenthNote;
    tenthNote*0.5 => twentiethNote;
    twentiethNote*0.5 => fourtiethNote;
    wholeNote/7 => seventhNote;
    seventhNote*0.5 => fourtenthNote;
    fourtenthNote*0.5 => twentyeighthNote;
    wholeNote/9 => ninthNote;
    ninthNote*0.5 => eighteenthNote;
    eighteenthNote*0.5 => thirtysixthNote;

    //[wholeNote,halfNote,quarterNote,eightNote,sixteenthNote,thirtysecondNote] @=> myDuration;
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
    if(durationName == 3){
      thirdNote => retDur;
    }
    if(durationName == 6){
      sixthNote => retDur;
    }
    if(durationName == 12){
      twelfthNote => retDur;
    }
    if(durationName == 24){
      twentyfourthNote => retDur;
    }
    if(durationName == 5){
      fifthNote => retDur;
    }
    if(durationName == 10){
      tenthNote => retDur;
    }
    if(durationName == 20){
      twentiethNote => retDur;
    }
    if(durationName == 40){
      fourtiethNote => retDur;
    }
    if(durationName == 7){
      seventhNote => retDur;
    }
    if(durationName == 14){
      fourtenthNote => retDur;
    }
    if(durationName == 28){
      twentyeighthNote => retDur;
    }
    if(durationName == 9){
      ninthNote => retDur;
    }
    if(durationName == 18){
      eighteenthNote => retDur;
    }
    if(durationName == 36){
      thirtysixthNote => retDur;
    }

    return retDur;
  }

}
while(true){1::second=>now;}
