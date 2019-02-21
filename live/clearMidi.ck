MidiOut mout;
MidiMsg msg;

18=> int port;

if(!mout.open(port)){
  <<<"ERROR!">>>;
  me.exit();
}

fun void send(int note, int velocity){
  128 => msg.data1;
  note => msg.data2;
  velocity => msg.data3;
  mout.send(msg);
}

for(0 => int i; i < 128; i++){
  send(i,0);
}
