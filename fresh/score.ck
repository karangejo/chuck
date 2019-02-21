//ZynOut zyn;
//HydroOut hyd;
Scalez Edorian;
//BPM bpm;

[0,2,3,5,7,9,10] @=> int dorian[];
4 => int keyOfE;
Edorian.makeScale(dorian,keyOfE);

//bpm.tempo(140);

Edorian.lookUpNoteByName("e7") => int eSeven;
<<<eSeven>>>;
//spork ~ zyn.loopIntervals(Edorian.myScale,28,4,3,bpm.quarterNote,127,"down");
//spork ~ zyn.loopChord(Edorian.myScale,28,127,bpm.wholeNote);
//spork ~ hyd.playRamdomEuclideanRhythm(32,bpm.eightNote);


while(true){1::second=>now;}
