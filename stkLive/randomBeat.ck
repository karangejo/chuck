HydroOut hyd;
Sync sync;
<<<"syncing to :", sync.bar>>>;
sync.bar - (now % sync.bar) => now;

Std.atoi(me.arg(0)) => int seqLength;
Std.atoi(me.arg(1)) => int oneOutofThis;
sync.getDuration(Std.atoi(me.arg(2))) => dur duration;



hyd.playRandBeat(seqLength,oneOutofThis,duration);
