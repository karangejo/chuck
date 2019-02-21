SndBuf soundBuf => dac;

me.dir()+me.arg(0) => soundBuf.read;

soundBuf.samples() => soundBuf.pos;
-1 => soundBuf.rate;
1 => soundBuf.loop;

while(true){
  soundBuf.samples()::samp => now;
}
