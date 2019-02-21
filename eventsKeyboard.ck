// Human interface device
Hid hid;
HidMsg msg;

BeeThree organ => JCRev rev => dac;
0.05 => rev.mix;

for( 0 => int i; i < 10; i++){
  i => int device;
  if (hid.openKeyboard(device) ==  false) me.exit();
  <<<"device:",i," ", hid.name()>>>;
}


6 => int device;

if (hid.openKeyboard(device) ==  false) me.exit();
<<<"connected to device:",device," ", hid.name()>>>;

while(true){
  // wait for event
  hid => now;
  while(hid.recv(msg)){
    if(msg.isButtonDown()){
    <<<"BUTTON DOWN", msg.ascii>>>;
    msg.ascii => Std.mtof => float freq;
    if(freq > 20000)continue;
    freq => organ.freq;
    1 => organ.noteOn;
    80::ms => now;

      }
      else
      {
       <<<"BUTTON DOWN">>>;
       1 => organ.noteOff;
      }
    }
}
