public class BPM {
  dur myDuration[6];
  dur wholeNote, halfNote, quarterNote, eightNote, sixteenthNote, thirtysecondNote;

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
}
