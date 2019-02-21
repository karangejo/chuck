//  Flock by sporking individual bird tweeter shreds
//      by Perry R. Cook, (1996-) 2015
//  NOTE:  This is a somewhat dopey way to do it.

20 => int MAX;
Tweet tweeters[MAX];
int shreds[MAX];

0 => int num;

while (num < MAX)  {
   1 => shreds[num];
   spork ~ oneTweeter(num);
   num++;
   <<< num, "little birdies" >>>;
   second => now;
}

while (--num > -1)  {
    0 => shreds[num];
   <<< "Now", num+1, "little birdies" >>>;
    second => now;
}

fun void oneTweeter(int which)  {
    while (shreds[which]) {
        tweeters[which].tweet();
    }
}
