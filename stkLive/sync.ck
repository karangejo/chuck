public class Sync{
  BPM bpm;

  static dur bar;
  static dur fourBar;


  fun dur getDuration(int durationName){
    bpm.getDuration(durationName) => dur retDur;
    return retDur;
  }

  fun void setTempo(float beat){
    bpm.tempo(beat);
    bpm.wholeNote => bar;
    bpm.wholeNote*4 => fourBar;
    <<<"whole note is",bar>>>;
    <<<"quarter note is",bpm.quarterNote>>>;
  }
}

Std.atof(me.arg(0)) => float beatsPerMinute;
Sync sync;
sync.setTempo(beatsPerMinute);

while(true){1::second=>now;}
