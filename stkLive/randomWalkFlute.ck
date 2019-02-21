FLUTE f;
Sync sync;
Key key;

<<<"syncing to :", sync.bar>>>;
sync.bar - (now % sync.bar) => now;


Std.atoi(me.arg(0)) => int root;

sync.getDuration(Std.atoi(me.arg(1))) => dur duration;

/*int newScale[key.myKey.cap()-28];
0 => int counter;
for(0=>int i;i<key.myKey.cap();i++){
  if((i >14) && (i<56))
  key.myKey[i] => newScale[counter];
  counter++;
}

for(0=>int i;i<newScale.cap();i++){
  <<<newScale[i]>>>;
}

*/


f.randomWalkUp(key.myKey,root,duration);
