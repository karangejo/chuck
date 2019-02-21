Organ o;
Sync sync;
Key key;

<<<"syncing to :", sync.bar>>>;
sync.bar - (now % sync.bar) => now;


Std.atoi(me.arg(0)) => int firstRoot;
Std.atoi(me.arg(1)) => int secondRoot;
Std.atoi(me.arg(2)) => int thirdRoot;
Std.atoi(me.arg(3)) => int fourthRoot;

sync.getDuration(Std.atoi(me.arg(4))) => dur duration;

o.loopChordProgression(key.myKey,[firstRoot,secondRoot,thirdRoot,fourthRoot],duration);
