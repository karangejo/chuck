MidiIn min;
MidiMsg msg;

1 => int port;

if (!min.open(port)){
  <<<"Error: Midi port did not open on port: ", port>>>;
  me.exit();
}


while(true){
  min => now;
  while(min.recv(msg)){
    <<< msg.data1, msg.data2, msg.data3>>>;
  }
}
