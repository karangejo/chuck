SndBuf buffer => ResonZ rez => dac;

me.dir() + "074_classicbrk-16.aif" => buffer.read;

1 => rez.Q;
1 => buffer.loop; //make sure it loops if the end of the file is reached

buffer.samples() / 16=> int s;
<<<s>>>;
s::samp => dur tick;
<<<tick>>>;

float t;

while(true){
  Math.random2(1,10) => int prob;
  <<<prob>>>;
  100 + Std.fabs(Math.sin(t))* 5000 => rez.freq;
  <<<rez.freq>>>;
  .3 +=> t;
  if(prob <= 8) {
    if(prob < 4){
      2 => buffer.rate;
    }else{
      1 => buffer.rate;
    }
  }else{
    0.5 => buffer.rate;
  }
  tick => now;
}
