HydroOut hyd;
Sync sync;
<<<"syncing to :", sync.bar>>>;
sync.bar - (now % sync.bar) => now;

Std.atoi(me.arg(0)) => int seqLength;
sync.getDuration(Std.atoi(me.arg(1))) => dur duration;

hyd.playRamdomEuclideanRhythm(seqLength,duration);
