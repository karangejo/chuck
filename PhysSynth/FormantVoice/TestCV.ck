FormantVoice fv => dac;

["ppp","ttt","kkk","koo"] @=> string plos[]; // plosives
["bbb","ddd","ggg"] @=> string vplos[]; // stops
["djj","vvv","zzz","tzz","zhh","gxx"] @=> string vfric[]; // voiced fricatives
["fff","sss","thh","shh","cxh","xxx","hee","hah","hoo"] @=> string fric[]; // fricatives
["rrr","lll","mmm","nnn","nng"] @=> string liq[];
["ahh","ehh","eee","ohh","ooo"] @=> string vowels[];

// testCV(plos);
// testCV(vfric);
// testCV(vplos);
// testCV(fric);
testCV(liq);

fun void testCV(string cons[])  {
    for (int c; c < cons.cap(); c++)  {
        for (int v; v < vowels.cap(); v++)  {
            <<< cons[c], vowels[v] >>>;
            fv.setPhoneme(cons[c]);
            if (cons == plos) {
		20::ms => now;
		fv.quiet(20::ms);
	    }
	    else 90::ms => now;
	    fv.setPhoneme(vowels[v]);
	    Math.random2f(80,120) => fv.pitch;
	    300::ms => now;
	    fv.quiet(300::ms);
	}
    }
}


