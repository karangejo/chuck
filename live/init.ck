me.arg(0) => string beatsPerMinute;
me.arg(1) => string mode;
me.arg(2) => string key;

Machine.add(me.dir()+"status.ck");
Machine.add(me.dir()+"BPM.ck");
Machine.add(me.dir()+"weightedRand.ck");
Machine.add(me.dir()+"sync.ck:"+beatsPerMinute);
Machine.add(me.dir()+"scalez.ck");
Machine.add(me.dir()+"key.ck:"+ mode +":"+key);
Machine.add(me.dir()+"Hydro.ck");
Machine.add(me.dir()+"Zyn.ck");

while(true){
  1::second=>now;
}
