//test drums class


kjzBD101 A;
A.output => dac;

for(int i; i < 8; i++)
{ A.hit(.5 + i * .1); .5::second => now; }
