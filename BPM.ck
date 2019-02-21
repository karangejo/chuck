public class BPM {
  dur myDuration[4];
  dur quarterNote, eightNote, sixteenthNote, thirtysecondNote;

  fun void tempo(float beat){

    60.0/(beat) => float SPB; //second per beat
    SPB::second => quarterNote;
    quarterNote*0.5 => eightNote;
    eightNote*0.5 => sixteenthNote;
    sixteenthNote*0.5 => thirtysecondNote;

    [quarterNote,eightNote,sixteenthNote,thirtysecondNote] @=> myDuration;
  }
}
