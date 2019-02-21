SndBuf soundBuf => dac;

me.dir()+me.arg(0) => soundBuf.read;

0 => soundBuf.pos;
1 => soundBuf.loop;

while(true){
  soundBuf.samples()::samp => now;
}
