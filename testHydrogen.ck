MidiOut mout;
MidiMsg msg;

// find port for midi instrument (hydrogen probably)
17=> int port;

if(!mout.open(port)){
  <<<"ERROR!">>>;
  me.exit();
}

fun void send(int note, int velocity){
  144 => msg.data1;
  note => msg.data2;
  velocity => msg.data3;
  mout.send(msg);
}


for(0=> int i; i < 127;i++){
  send(i,127);
  <<<"midi note :",i>>>;
  10::ms => now;
}
