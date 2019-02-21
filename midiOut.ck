//check the ports with chuck --probe
MidiOut mout;
MidiMsg msg;


17 => int port;

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

while(true){
  Math.random2(48,72) => int note;
  Math.random2(0,127) => int volume;
  send(note,  volume);
  0.5::second => now;
  send(note,0);
}
