ZynOut zyn;
Sync sync;
Key key;

<<<"syncing to :", sync.bar>>>;
sync.bar - (now % sync.bar) => now;


Std.atoi(me.arg(0)) => int startNoteI;
Std.atoi(me.arg(1)) => int numNotes;
Std.atoi(me.arg(2)) => int interval;

sync.getDuration(Std.atoi(me.arg(3))) => dur noteDuration;
me.arg(4) => string direction;



zyn.loopIntervals(key.myKey,startNoteI,numNotes,interval,noteDuration,127,direction);
