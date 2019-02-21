//interface device
Hid hid;
HidMsg msg;

BeeThree organ => JCRev rev => dac;
0.05 => rev.mix;

//for( 0 => int i; i < 10; i++){
  //i => int device;
  //if (hid.openMouse(device) ==  false) me.exit();
  //<<<"device:",i," ", hid.name()>>>;
//}


0 => int device;

if (hid.openMouse(device) ==  false) me.exit();
<<<"connected to device:",device," ", hid.name()>>>;

while(true){
  hid => now;
  while(hid.recv(msg)){
      //if((msg.deltaX != 0) ||
      //if(msg.deltaY != 0){
        //<<<"Mouse X:", msg.deltaX>>>;
        <<<"Mouse Y:", msg.deltaY>>>;
        <<<msg.fdata>>>;
      //}
  }
}
