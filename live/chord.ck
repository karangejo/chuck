ZynOut zyn;
Scalez Edorian;
BPM bpm;

bpm.tempo(140);

[0,2,3,5,7,9,10] @=> int dorian[];
4 => int keyOfE;
Edorian.makeScale(dorian,keyOfE);

zyn.playChordProgression(Edorian.myScale,[24,26,28,30],127,bpm.wholeNote);
