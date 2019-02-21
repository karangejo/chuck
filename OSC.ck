OscIn oin;
OscMsg msg;

6449 => oin.port;

"/playNote" => oin.addAddress;

OscOut oout;
oout.dest("localhost", 6449);

fun void sendNote(){
  while(true){
    oout.start("/playNote");
    oout.add(Math.random2(48,72));
    oout.add(Math.random2f(0.5,1.0));

    oout.send();
    .5::second => now;
  }
}

Mandolin mand => dac;

fun void recvNote(){
  while(true){
    oin => now;
    while(oin.recv(msg)){
      msg.address @=> string address;
      msg.getInt(0) => int note;
      msg.getFloat(1) => float gain;

      <<<address,note,gain>>>;

      note => Std.mtof => mand.freq;
      gain => mand.pluck;
    }
  }
}


spork ~ sendNote();
spork ~ recvNote();

while(true){1::second=>now;}
