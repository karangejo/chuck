//  Applause by sporking individual clappers
//  NOTE:  This is an expensive way to do it.
//         But each clapper here has a "character"
//            including rate, avg. freq, and pan.
//         See PHISEMApplause.ck for a super-efficient way

20 => int MAX;   // see how many you can run!!
int shreds[MAX];
0 => int num;

// add clappers 1 at a time
while (num < MAX)  {  // (like at the end of that movie :-)
   Machine.add(me.dir()+"/ClapFilter.ck") => shreds[num];
   num++;
   second => now;
}

0 => num;
while (num < MAX)  {  // now take them out 1 at a time
    Machine.remove(shreds[num]);
    num++;
    second => now;
}